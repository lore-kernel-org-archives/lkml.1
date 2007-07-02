Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbXGBOsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbXGBOsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755768AbXGBOsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:48:16 -0400
Received: from mail.screens.ru ([213.234.233.54]:51127 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977AbXGBOsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:48:14 -0400
Date: Mon, 2 Jul 2007 18:48:17 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Markus Rechberger <mrechberger@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Thomas Sattler <tsattler@gmx.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Mack <daniel@qanu.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Holger Waechtler <holger@qanu.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] dvb/cinergyT2: fix flush_workqueue() vs work->func() deadlock
Message-ID: <20070702144817.GA455@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spotted and tested by Thomas Sattler <tsattler@gmx.de>.

cinergyT2.c does cancel_delayed_work() + flush_scheduled_work() while
holding cinergyt2->sem. This leads to deadlock because work->func()
needs the same mutex to complete. Another bug is that this code in fact
can't reliably stop the re-arming delayed_work.

Convert this code to use cancel_rearming_delayed_work() and move it
out of ->sem. Another mutex, ->wq_sem, was added to protect against the
concurrent open/resume.

This patch is a horrible hack to fix the lockup which happens in practice.
As Dmitry Torokhov pointed out this driver has other problems and needs
further changes.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/drivers/media/dvb/cinergyT2/cinergyT2.c~cinergy	2007-06-19 17:09:15.000000000 +0400
+++ t/drivers/media/dvb/cinergyT2/cinergyT2.c	2007-06-30 18:01:43.000000000 +0400
@@ -118,6 +118,7 @@ struct cinergyt2 {
 	struct dvb_demux demux;
 	struct usb_device *udev;
 	struct mutex sem;
+	struct mutex wq_sem;
 	struct dvb_adapter adapter;
 	struct dvb_device *fedev;
 	struct dmxdev dmxdev;
@@ -482,14 +483,14 @@ static int cinergyt2_open (struct inode 
 	struct cinergyt2 *cinergyt2 = dvbdev->priv;
 	int err = -ERESTARTSYS;
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->sem))
-		return -ERESTARTSYS;
+	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->wq_sem))
+		goto out;
 
-	if ((err = dvb_generic_open(inode, file))) {
-		mutex_unlock(&cinergyt2->sem);
-		return err;
-	}
+	if (mutex_lock_interruptible(&cinergyt2->sem))
+		goto out_unlock1;
 
+	if ((err = dvb_generic_open(inode, file)))
+		goto out_unlock2;
 
 	if ((file->f_flags & O_ACCMODE) != O_RDONLY) {
 		cinergyt2_sleep(cinergyt2, 0);
@@ -498,8 +499,12 @@ static int cinergyt2_open (struct inode 
 
 	atomic_inc(&cinergyt2->inuse);
 
+out_unlock2:
 	mutex_unlock(&cinergyt2->sem);
-	return 0;
+out_unlock1:
+	mutex_unlock(&cinergyt2->wq_sem);
+out:
+	return err;
 }
 
 static void cinergyt2_unregister(struct cinergyt2 *cinergyt2)
@@ -519,15 +524,17 @@ static int cinergyt2_release (struct ino
 	struct dvb_device *dvbdev = file->private_data;
 	struct cinergyt2 *cinergyt2 = dvbdev->priv;
 
-	mutex_lock(&cinergyt2->sem);
+	mutex_lock(&cinergyt2->wq_sem);
 
 	if (!cinergyt2->disconnect_pending && (file->f_flags & O_ACCMODE) != O_RDONLY) {
-		cancel_delayed_work(&cinergyt2->query_work);
-		flush_scheduled_work();
+		cancel_rearming_delayed_work(&cinergyt2->query_work);
+
+		mutex_lock(&cinergyt2->sem);
 		cinergyt2_sleep(cinergyt2, 1);
+		mutex_unlock(&cinergyt2->sem);
 	}
 
-	mutex_unlock(&cinergyt2->sem);
+	mutex_unlock(&cinergyt2->wq_sem);
 
 	if (atomic_dec_and_test(&cinergyt2->inuse) && cinergyt2->disconnect_pending) {
 		warn("delayed unregister in release");
@@ -838,13 +845,13 @@ static int cinergyt2_register_rc(struct 
 
 static void cinergyt2_unregister_rc(struct cinergyt2 *cinergyt2)
 {
-	cancel_delayed_work(&cinergyt2->rc_query_work);
+	cancel_rearming_delayed_work(&cinergyt2->rc_query_work);
 	input_unregister_device(cinergyt2->rc_input_dev);
 }
 
 static inline void cinergyt2_suspend_rc(struct cinergyt2 *cinergyt2)
 {
-	cancel_delayed_work(&cinergyt2->rc_query_work);
+	cancel_rearming_delayed_work(&cinergyt2->rc_query_work);
 }
 
 static inline void cinergyt2_resume_rc(struct cinergyt2 *cinergyt2)
@@ -907,6 +914,7 @@ static int cinergyt2_probe (struct usb_i
 	usb_set_intfdata (intf, (void *) cinergyt2);
 
 	mutex_init(&cinergyt2->sem);
+	mutex_init(&cinergyt2->wq_sem);
 	init_waitqueue_head (&cinergyt2->poll_wq);
 	INIT_DELAYED_WORK(&cinergyt2->query_work, cinergyt2_query);
 
@@ -974,11 +982,8 @@ static void cinergyt2_disconnect (struct
 {
 	struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 
-	flush_scheduled_work();
-
 	cinergyt2_unregister_rc(cinergyt2);
-
-	cancel_delayed_work(&cinergyt2->query_work);
+	cancel_rearming_delayed_work(&cinergyt2->query_work);
 	wake_up_interruptible(&cinergyt2->poll_wq);
 
 	cinergyt2->demux.dmx.close(&cinergyt2->demux.dmx);
@@ -992,21 +997,22 @@ static int cinergyt2_suspend (struct usb
 {
 	struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->sem))
+	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->wq_sem))
 		return -ERESTARTSYS;
 
 	if (1) {
-		struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 
 		cinergyt2_suspend_rc(cinergyt2);
-		cancel_delayed_work(&cinergyt2->query_work);
+		cancel_rearming_delayed_work(&cinergyt2->query_work);
+
+		mutex_lock(&cinergyt2->sem);
 		if (cinergyt2->streaming)
 			cinergyt2_stop_stream_xfer(cinergyt2);
-		flush_scheduled_work();
 		cinergyt2_sleep(cinergyt2, 1);
+		mutex_unlock(&cinergyt2->sem);
 	}
 
-	mutex_unlock(&cinergyt2->sem);
+	mutex_unlock(&cinergyt2->wq_sem);
 	return 0;
 }
 
@@ -1014,9 +1020,15 @@ static int cinergyt2_resume (struct usb_
 {
 	struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 	struct dvbt_set_parameters_msg *param = &cinergyt2->param;
+	int err = -ERESTARTSYS;
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->sem))
-		return -ERESTARTSYS;
+	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->wq_sem))
+		goto out;
+
+	if (mutex_lock_interruptible(&cinergyt2->sem))
+		goto out_unlock1;
+
+	err = 0;
 
 	if (!cinergyt2->sleeping) {
 		cinergyt2_sleep(cinergyt2, 0);
@@ -1029,7 +1041,10 @@ static int cinergyt2_resume (struct usb_
 	cinergyt2_resume_rc(cinergyt2);
 
 	mutex_unlock(&cinergyt2->sem);
-	return 0;
+out_unlock1:
+	mutex_unlock(&cinergyt2->wq_sem);
+out:
+	return err;
 }
 
 static const struct usb_device_id cinergyt2_table [] __devinitdata = {

