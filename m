Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbXJNO2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbXJNO2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 10:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbXJNO2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 10:28:30 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:52025 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbXJNO23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 10:28:29 -0400
Message-id: <24841282012868130110_1@pripojeni.net>
In-reply-to: <21044149499772302@pripojeni.net>
Subject: [PATCH 1/1 try 2] V4L: cinergyT2, remove bad usage of ERESTARTSYS
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <daniel@qanu.de>
Cc: <holger@qanu.de>
Cc: <mchehab@infradead.org>
Cc: <video4linux-list@redhat.com>
Date: Sun, 14 Oct 2007 10:28:29 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cinergyT2, remove bad usage of ERESTARTSYS

test of cinergyt2->disconnect_pending doesn't ensure pending signal and so
ERESTARTSYS would reach userspace, which is not permitted. Change it to
EAGAIN

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 4b741d759e5b898bf1bf19631d5e5b14a221ce52
tree af90dcd22292fc4fee4b3337118e6cb527796499
parent f87566db6dd9613dde8de59380cd2f423166511e
author Jiri Slaby <jirislaby@gmail.com> Sun, 14 Oct 2007 16:25:55 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 14 Oct 2007 16:25:55 +0200

 drivers/media/dvb/cinergyT2/cinergyT2.c |   42 +++++++++++++++++++++----------
 1 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb/cinergyT2/cinergyT2.c b/drivers/media/dvb/cinergyT2/cinergyT2.c
index 154a7ce..7199e4c 100644
--- a/drivers/media/dvb/cinergyT2/cinergyT2.c
+++ b/drivers/media/dvb/cinergyT2/cinergyT2.c
@@ -345,7 +345,9 @@ static int cinergyt2_start_feed(struct dvb_demux_feed *dvbdmxfeed)
 	struct dvb_demux *demux = dvbdmxfeed->demux;
 	struct cinergyt2 *cinergyt2 = demux->priv;
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->sem))
+	if (cinergyt2->disconnect_pending)
+		return -EAGAIN;
+	if (mutex_lock_interruptible(&cinergyt2->sem))
 		return -ERESTARTSYS;
 
 	if (cinergyt2->streaming == 0)
@@ -361,7 +363,9 @@ static int cinergyt2_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 	struct dvb_demux *demux = dvbdmxfeed->demux;
 	struct cinergyt2 *cinergyt2 = demux->priv;
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->sem))
+	if (cinergyt2->disconnect_pending)
+		return -EAGAIN;
+	if (mutex_lock_interruptible(&cinergyt2->sem))
 		return -ERESTARTSYS;
 
 	if (--cinergyt2->streaming == 0)
@@ -481,12 +485,16 @@ static int cinergyt2_open (struct inode *inode, struct file *file)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct cinergyt2 *cinergyt2 = dvbdev->priv;
-	int err = -ERESTARTSYS;
+	int err = -EAGAIN;
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->wq_sem))
+	if (cinergyt2->disconnect_pending)
+		goto out;
+	err = mutex_lock_interruptible(&cinergyt2->wq_sem);
+	if (err)
 		goto out;
 
-	if (mutex_lock_interruptible(&cinergyt2->sem))
+	err = mutex_lock_interruptible(&cinergyt2->sem);
+	if (err)
 		goto out_unlock1;
 
 	if ((err = dvb_generic_open(inode, file)))
@@ -550,7 +558,9 @@ static unsigned int cinergyt2_poll (struct file *file, struct poll_table_struct
 	struct cinergyt2 *cinergyt2 = dvbdev->priv;
 	unsigned int mask = 0;
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->sem))
+	if (cinergyt2->disconnect_pending)
+		return -EAGAIN;
+	if (mutex_lock_interruptible(&cinergyt2->sem))
 		return -ERESTARTSYS;
 
 	poll_wait(file, &cinergyt2->poll_wq, wait);
@@ -625,7 +635,9 @@ static int cinergyt2_ioctl (struct inode *inode, struct file *file,
 		if (copy_from_user(&p, (void  __user*) arg, sizeof(p)))
 			return -EFAULT;
 
-		if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->sem))
+		if (cinergyt2->disconnect_pending)
+			return -EAGAIN;
+		if (mutex_lock_interruptible(&cinergyt2->sem))
 			return -ERESTARTSYS;
 
 		param->cmd = CINERGYT2_EP1_SET_TUNER_PARAMETERS;
@@ -996,7 +1008,9 @@ static int cinergyt2_suspend (struct usb_interface *intf, pm_message_t state)
 {
 	struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->wq_sem))
+	if (cinergyt2->disconnect_pending)
+		return -EAGAIN;
+	if (mutex_lock_interruptible(&cinergyt2->wq_sem))
 		return -ERESTARTSYS;
 
 	cinergyt2_suspend_rc(cinergyt2);
@@ -1017,16 +1031,18 @@ static int cinergyt2_resume (struct usb_interface *intf)
 {
 	struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 	struct dvbt_set_parameters_msg *param = &cinergyt2->param;
-	int err = -ERESTARTSYS;
+	int err = -EAGAIN;
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->wq_sem))
+	if (cinergyt2->disconnect_pending)
+		goto out;
+	err = mutex_lock_interruptible(&cinergyt2->wq_sem);
+	if (err)
 		goto out;
 
-	if (mutex_lock_interruptible(&cinergyt2->sem))
+	err = mutex_lock_interruptible(&cinergyt2->sem);
+	if (err)
 		goto out_unlock1;
 
-	err = 0;
-
 	if (!cinergyt2->sleeping) {
 		cinergyt2_sleep(cinergyt2, 0);
 		cinergyt2_command(cinergyt2, (char *) param, sizeof(*param), NULL, 0);
