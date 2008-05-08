Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbYEHRso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbYEHRso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764361AbYEHRnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:43:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:33524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbYEHRnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:43:45 -0400
Date: Thu, 8 May 2008 10:42:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 11/16] b43: Fix some TX/RX locking issues
Message-ID: <20080508174221.GL855@suse.de>
References: <20080508173436.454278564@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43-fix-some-tx-rx-locking-issues.patch"
In-Reply-To: <20080508174122.GA855@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Michael Buesch <mb@bu3sch.de>

commit 21a75d7788f4e29b6c6d28e08f9f0310c4de828d upstream.

This fixes some TX/RX related locking issues.
With this patch applied, some of the PHY transmission errors are fixed.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/b43.h  |    4 ++++
 drivers/net/wireless/b43/main.c |   32 +++++++++++++++++++++++---------
 2 files changed, 27 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -628,6 +628,10 @@ struct b43_wl {
 
 	struct mutex mutex;
 	spinlock_t irq_lock;
+	/* R/W lock for data transmission.
+	 * Transmissions on 2+ queues can run concurrently, but somebody else
+	 * might sync with TX by write_lock_irqsave()'ing. */
+	rwlock_t tx_lock;
 	/* Lock for LEDs access. */
 	spinlock_t leds_lock;
 	/* Lock for SHM access. */
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -622,6 +622,7 @@ static void b43_synchronize_irq(struct b
  */
 void b43_dummy_transmission(struct b43_wldev *dev)
 {
+	struct b43_wl *wl = dev->wl;
 	struct b43_phy *phy = &dev->phy;
 	unsigned int i, max_loop;
 	u16 value;
@@ -648,6 +649,9 @@ void b43_dummy_transmission(struct b43_w
 		return;
 	}
 
+	spin_lock_irq(&wl->irq_lock);
+	write_lock(&wl->tx_lock);
+
 	for (i = 0; i < 5; i++)
 		b43_ram_write(dev, i * 4, buffer[i]);
 
@@ -688,6 +692,9 @@ void b43_dummy_transmission(struct b43_w
 	}
 	if (phy->radio_ver == 0x2050 && phy->radio_rev <= 0x5)
 		b43_radio_write16(dev, 0x0051, 0x0037);
+
+	write_unlock(&wl->tx_lock);
+	spin_unlock_irq(&wl->irq_lock);
 }
 
 static void key_write(struct b43_wldev *dev,
@@ -2592,15 +2599,21 @@ static int b43_op_tx(struct ieee80211_hw
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
-	int err = -ENODEV;
+	unsigned long flags;
+	int err;
 
 	if (unlikely(!dev))
-		goto out;
-	if (unlikely(b43_status(dev) < B43_STAT_STARTED))
-		goto out;
-	/* DMA-TX is done without a global lock. */
-	err = b43_dma_tx(dev, skb, ctl);
-out:
+		return NETDEV_TX_BUSY;
+
+	/* Transmissions on seperate queues can run concurrently. */
+	read_lock_irqsave(&wl->tx_lock, flags);
+
+	err = -ENODEV;
+	if (likely(b43_status(dev) >= B43_STAT_STARTED))
+		err = b43_dma_tx(dev, skb, ctl);
+
+	read_unlock_irqrestore(&wl->tx_lock, flags);
+
 	if (unlikely(err))
 		return NETDEV_TX_BUSY;
 	return NETDEV_TX_OK;
@@ -3109,7 +3122,9 @@ static void b43_wireless_core_stop(struc
 	spin_unlock_irqrestore(&wl->irq_lock, flags);
 	b43_synchronize_irq(dev);
 
+	write_lock_irqsave(&wl->tx_lock, flags);
 	b43_set_status(dev, B43_STAT_INITIALIZED);
+	write_unlock_irqrestore(&wl->tx_lock, flags);
 
 	mutex_unlock(&wl->mutex);
 	/* Must unlock as it would otherwise deadlock. No races here.
@@ -3117,8 +3132,6 @@ static void b43_wireless_core_stop(struc
 	cancel_delayed_work_sync(&dev->periodic_work);
 	mutex_lock(&wl->mutex);
 
-	ieee80211_stop_queues(wl->hw);	//FIXME this could cause a deadlock, as mac80211 seems buggy.
-
 	b43_mac_suspend(dev);
 	free_irq(dev->dev->irq, dev);
 	b43dbg(wl, "Wireless interface stopped\n");
@@ -4084,6 +4097,7 @@ static int b43_wireless_init(struct ssb_
 	memset(wl, 0, sizeof(*wl));
 	wl->hw = hw;
 	spin_lock_init(&wl->irq_lock);
+	rwlock_init(&wl->tx_lock);
 	spin_lock_init(&wl->leds_lock);
 	spin_lock_init(&wl->shm_lock);
 	mutex_init(&wl->mutex);

-- 
