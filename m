Return-Path: <linux-kernel-owner+w=401wt.eu-S932811AbZLGAN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811AbZLGAN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758532AbZLGANY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:24 -0500
Received: from kroah.org ([198.145.64.141]:34453 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758503AbZLGANP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:15 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:50 2009
Message-Id: <20091207000650.209768037@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Michael Buesch <mb@bu3sch.de>
Subject: [057/119] b43: Work around mac80211 race condition
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=b43-work-around-mac80211-race-condition.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Larry Finger <Larry.Finger@lwfinger.net>

commit 18c6951091eca7645005a71b556106cc99a6f4b1 upstream.

As shown in http://thread.gmane.org/gmane.linux.kernel.wireless.general/36497,
mac80211 has a bug that allows a call to the TX routine after the queues have
been stopped. This situation will only occur under extreme stress. Although
b43 does not crash when this condition occurs, it does generate a WARN_ON and
also logs a queue overrun message. This patch recognizes b43 is not at fault
and logs a message only when the most verbose debugging mode is enabled. In
the unlikely event that the queue is not stopped when the DMA queue becomes
full, then a warning is issued.

During testing of this patch with one output stream running repeated tcpperf
writes and a second running a flood ping, this routine was entered with
the DMA ring stopped about once per hour. The condition where the DMA queue is
full but the ring has not been stopped has never been seen by me.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/dma.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1334,13 +1334,22 @@ int b43_dma_tx(struct b43_wldev *dev, st
 	spin_lock_irqsave(&ring->lock, flags);
 
 	B43_WARN_ON(!ring->tx);
-	/* Check if the queue was stopped in mac80211,
-	 * but we got called nevertheless.
-	 * That would be a mac80211 bug. */
-	B43_WARN_ON(ring->stopped);
 
-	if (unlikely(free_slots(ring) < TX_SLOTS_PER_FRAME)) {
-		b43warn(dev->wl, "DMA queue overflow\n");
+	if (unlikely(ring->stopped)) {
+		/* We get here only because of a bug in mac80211.
+		 * Because of a race, one packet may be queued after
+		 * the queue is stopped, thus we got called when we shouldn't.
+		 * For now, just refuse the transmit. */
+		if (b43_debug(dev, B43_DBG_DMAVERBOSE))
+			b43err(dev->wl, "Packet after queue stopped\n");
+		err = -ENOSPC;
+		goto out_unlock;
+	}
+
+	if (unlikely(WARN_ON(free_slots(ring) < TX_SLOTS_PER_FRAME))) {
+		/* If we get here, we have a real error with the queue
+		 * full, but queues not stopped. */
+		b43err(dev->wl, "DMA queue overflow\n");
 		err = -ENOSPC;
 		goto out_unlock;
 	}


