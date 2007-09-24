Return-Path: <linux-kernel-owner+w=401wt.eu-S1763624AbXIXQop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763624AbXIXQop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761018AbXIXQ3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:29:09 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58187 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761310AbXIXQ3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:29:07 -0400
Date: Mon, 24 Sep 2007 09:22:56 -0700
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
       Larry Finger <Larry.Finger@lwfinger.net>, Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [50/50] bcm43xx: Fix cancellation of work queue crashes
Message-ID: <20070924162256.GY13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bcm43xx-fix-cancellation-of-work-queue-crashes.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

port of 3f7086978fc0193eff24a77d8b57ac4debc088fa from mainline.

A crash upon booting that is caused by bcm43xx has been reported [1] and
found to be due to a work queue being reinitialized while work on that
queue is still pending. This fix modifies the shutdown of work queues and
prevents periodic work from being requeued during shutdown. With this patch,
no more crashes on reboot were observed by the original reporter. I do not
get that particular failure on my system; however, when running a large
number of ifdown/ifup sequences, my system would kernel panic with the
'caps lock' light blinking at roughly a 1 Hz rate. In addition, there were
infrequent failures in the firmware that resulted in 'IRQ READY TIMEOUT'
errors. With this patch, no more of the first type of failure occur, and
incidence of the second type is greatly reduced.

[1] http://bugzilla.kernel.org/show_bug.cgi?id=8937

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/bcm43xx/bcm43xx_main.c  |   28 +++++++++++++++++++--------
 drivers/net/wireless/bcm43xx/bcm43xx_main.h  |    2 -
 drivers/net/wireless/bcm43xx/bcm43xx_sysfs.c |    2 -
 3 files changed, 22 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -3183,6 +3183,9 @@ static void bcm43xx_periodic_work_handle
 	unsigned long orig_trans_start = 0;
 
 	mutex_lock(&bcm->mutex);
+	/* keep from doing and rearming periodic work if shutting down */
+	if (bcm43xx_status(bcm) == BCM43xx_STAT_UNINIT)
+		goto unlock_mutex;
 	if (unlikely(bcm->periodic_state % 60 == 0)) {
 		/* Periodic work will take a long time, so we want it to
 		 * be preemtible.
@@ -3228,14 +3231,10 @@ static void bcm43xx_periodic_work_handle
 	mmiowb();
 	bcm->periodic_state++;
 	spin_unlock_irqrestore(&bcm->irq_lock, flags);
+unlock_mutex:
 	mutex_unlock(&bcm->mutex);
 }
 
-void bcm43xx_periodic_tasks_delete(struct bcm43xx_private *bcm)
-{
-	cancel_rearming_delayed_work(&bcm->periodic_work);
-}
-
 void bcm43xx_periodic_tasks_setup(struct bcm43xx_private *bcm)
 {
 	struct delayed_work *work = &bcm->periodic_work;
@@ -3285,6 +3284,14 @@ static int bcm43xx_rng_init(struct bcm43
 	return err;
 }
 
+void bcm43xx_cancel_work(struct bcm43xx_private *bcm)
+{
+	/* The system must be unlocked when this routine is entered.
+	 * If not, the next 2 steps may deadlock */
+	cancel_work_sync(&bcm->restart_work);
+	cancel_rearming_delayed_work(&bcm->periodic_work);
+}
+
 static int bcm43xx_shutdown_all_wireless_cores(struct bcm43xx_private *bcm)
 {
 	int ret = 0;
@@ -3321,7 +3328,12 @@ static void bcm43xx_free_board(struct bc
 {
 	bcm43xx_rng_exit(bcm);
 	bcm43xx_sysfs_unregister(bcm);
-	bcm43xx_periodic_tasks_delete(bcm);
+
+	mutex_lock(&(bcm)->mutex);
+	bcm43xx_set_status(bcm, BCM43xx_STAT_UNINIT);
+	mutex_unlock(&(bcm)->mutex);
+
+	bcm43xx_cancel_work(bcm);
 
 	mutex_lock(&(bcm)->mutex);
 	bcm43xx_shutdown_all_wireless_cores(bcm);
@@ -4018,7 +4030,7 @@ static int bcm43xx_net_stop(struct net_d
 	err = bcm43xx_disable_interrupts_sync(bcm);
 	assert(!err);
 	bcm43xx_free_board(bcm);
-	flush_scheduled_work();
+	bcm43xx_cancel_work(bcm);
 
 	return 0;
 }
@@ -4150,9 +4162,9 @@ static void bcm43xx_chip_reset(struct wo
 	struct bcm43xx_phyinfo *phy;
 	int err = -ENODEV;
 
+	bcm43xx_cancel_work(bcm);
 	mutex_lock(&(bcm)->mutex);
 	if (bcm43xx_status(bcm) == BCM43xx_STAT_INITIALIZED) {
-		bcm43xx_periodic_tasks_delete(bcm);
 		phy = bcm43xx_current_phy(bcm);
 		err = bcm43xx_select_wireless_core(bcm, phy->type);
 		if (!err)
--- a/drivers/net/wireless/bcm43xx/bcm43xx_main.h
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_main.h
@@ -122,7 +122,7 @@ void bcm43xx_wireless_core_reset(struct 
 void bcm43xx_mac_suspend(struct bcm43xx_private *bcm);
 void bcm43xx_mac_enable(struct bcm43xx_private *bcm);
 
-void bcm43xx_periodic_tasks_delete(struct bcm43xx_private *bcm);
+void bcm43xx_cancel_work(struct bcm43xx_private *bcm);
 void bcm43xx_periodic_tasks_setup(struct bcm43xx_private *bcm);
 
 void bcm43xx_controller_restart(struct bcm43xx_private *bcm, const char *reason);
--- a/drivers/net/wireless/bcm43xx/bcm43xx_sysfs.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_sysfs.c
@@ -327,7 +327,7 @@ static ssize_t bcm43xx_attr_phymode_stor
 		goto out;
 	}
 
-	bcm43xx_periodic_tasks_delete(bcm);
+	bcm43xx_cancel_work(bcm);
 	mutex_lock(&(bcm)->mutex);
 	err = bcm43xx_select_wireless_core(bcm, phytype);
 	if (!err)

-- 
