Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbXE3IqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbXE3IqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbXE3IqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:46:07 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:60213
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750796AbXE3IqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:46:06 -0400
Date: Wed, 30 May 2007 10:47:52 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: axboe@kernel.dk, zaitcev@redhat.com, linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] drivers/block/ub.c: use list_for_each_entry()
Message-ID: <20070530084752.GE14284@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	axboe@kernel.dk, zaitcev@redhat.com,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Low performance USB storage driver: Use list_for_each_entry() instead
of list_for_each()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index 746a118..18c8b6c 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -1547,10 +1547,8 @@ static void ub_reset_enter(struct ub_dev *sc, int try)
 #endif
 
 #if 0 /* We let them stop themselves. */
-	struct list_head *p;
 	struct ub_lun *lun;
-	list_for_each(p, &sc->luns) {
-		lun = list_entry(p, struct ub_lun, link);
+	list_for_each_entry(lun, &sc->luns, link) {
 		blk_stop_queue(lun->disk->queue);
 	}
 #endif
@@ -1562,7 +1560,6 @@ static void ub_reset_task(struct work_struct *work)
 {
 	struct ub_dev *sc = container_of(work, struct ub_dev, reset_work);
 	unsigned long flags;
-	struct list_head *p;
 	struct ub_lun *lun;
 	int lkr, rc;
 
@@ -1608,8 +1605,7 @@ static void ub_reset_task(struct work_struct *work)
 	spin_lock_irqsave(sc->lock, flags);
 	sc->reset = 0;
 	tasklet_schedule(&sc->tasklet);
-	list_for_each(p, &sc->luns) {
-		lun = list_entry(p, struct ub_lun, link);
+	list_for_each_entry(lun, &sc->luns, link) {
 		blk_start_queue(lun->disk->queue);
 	}
 	wake_up(&sc->reset_wait);
@@ -2348,7 +2344,6 @@ err_alloc:
 static void ub_disconnect(struct usb_interface *intf)
 {
 	struct ub_dev *sc = usb_get_intfdata(intf);
-	struct list_head *p;
 	struct ub_lun *lun;
 	unsigned long flags;
 
@@ -2403,8 +2398,7 @@ static void ub_disconnect(struct usb_interface *intf)
 	/*
 	 * Unregister the upper layer.
 	 */
-	list_for_each (p, &sc->luns) {
-		lun = list_entry(p, struct ub_lun, link);
+	list_for_each_entry(lun, &sc->luns, link) {
 		del_gendisk(lun->disk);
 		/*
 		 * I wish I could do:

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

             "The only important thing Windows does better
            than Debian is implementing the win32 platform"
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
