Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbXJHMfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbXJHMfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 08:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbXJHMez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 08:34:55 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:47084 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755677AbXJHMey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 08:34:54 -0400
Message-id: <24841282012868130110@pripojeni.net>
In-reply-to: <21044149499772302@pripojeni.net>
Subject: [PATCH 3/3] V4L: cinergyT2, remove bad usage of ERESTARTSYS
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <daniel@qanu.de>
Cc: <holger@qanu.de>
Cc: <mchehab@infradead.org>
Cc: <video4linux-list@redhat.com>
Date: Mon, 8 Oct 2007 08:34:54 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cinergyT2, remove bad usage of ERESTARTSYS

test of cinergyt2->disconnect_pending doesn't ensure pending signal and so
ERESTARTSYS would reach userspace, which is not permitted. Change it to
EAGAIN

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit b227f5517ddd99f581a9d241c8ba9c50c50fbc3e
tree f469eea4a298db2d4fe27313e48901d74211b2ca
parent 235cf594bc65128250632a642f3e9d7e4df4975e
author Jiri Slaby <jirislaby@gmail.com> Mon, 08 Oct 2007 14:24:32 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 08 Oct 2007 14:24:32 +0200

 drivers/media/dvb/cinergyT2/cinergyT2.c |   38 ++++++++++++++++++++-----------
 1 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb/cinergyT2/cinergyT2.c b/drivers/media/dvb/cinergyT2/cinergyT2.c
index 154a7ce..a1f6ebd 100644
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
@@ -481,12 +485,14 @@ static int cinergyt2_open (struct inode *inode, struct file *file)
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct cinergyt2 *cinergyt2 = dvbdev->priv;
-	int err = -ERESTARTSYS;
+	int err = -EAGAIN;
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->wq_sem))
+	if (cinergyt2->disconnect_pending)
+		goto out;
+	if ((err = mutex_lock_interruptible(&cinergyt2->wq_sem)))
 		goto out;
 
-	if (mutex_lock_interruptible(&cinergyt2->sem))
+	if ((err = mutex_lock_interruptible(&cinergyt2->sem)))
 		goto out_unlock1;
 
 	if ((err = dvb_generic_open(inode, file)))
@@ -550,7 +556,9 @@ static unsigned int cinergyt2_poll (struct file *file, struct poll_table_struct
 	struct cinergyt2 *cinergyt2 = dvbdev->priv;
 	unsigned int mask = 0;
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->sem))
+	if (cinergyt2->disconnect_pending)
+		return -EAGAIN;
+	if (mutex_lock_interruptible(&cinergyt2->sem))
 		return -ERESTARTSYS;
 
 	poll_wait(file, &cinergyt2->poll_wq, wait);
@@ -625,7 +633,9 @@ static int cinergyt2_ioctl (struct inode *inode, struct file *file,
 		if (copy_from_user(&p, (void  __user*) arg, sizeof(p)))
 			return -EFAULT;
 
-		if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->sem))
+		if (cinergyt2->disconnect_pending)
+			return -EAGAIN;
+		if (mutex_lock_interruptible(&cinergyt2->sem))
 			return -ERESTARTSYS;
 
 		param->cmd = CINERGYT2_EP1_SET_TUNER_PARAMETERS;
@@ -996,7 +1006,9 @@ static int cinergyt2_suspend (struct usb_interface *intf, pm_message_t state)
 {
 	struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->wq_sem))
+	if (cinergyt2->disconnect_pending)
+		return -EAGAIN;
+	if (mutex_lock_interruptible(&cinergyt2->wq_sem))
 		return -ERESTARTSYS;
 
 	cinergyt2_suspend_rc(cinergyt2);
@@ -1017,16 +1029,16 @@ static int cinergyt2_resume (struct usb_interface *intf)
 {
 	struct cinergyt2 *cinergyt2 = usb_get_intfdata (intf);
 	struct dvbt_set_parameters_msg *param = &cinergyt2->param;
-	int err = -ERESTARTSYS;
+	int err = -EAGAIN;
 
-	if (cinergyt2->disconnect_pending || mutex_lock_interruptible(&cinergyt2->wq_sem))
+	if (cinergyt2->disconnect_pending)
+		goto out;
+	if ((err = mutex_lock_interruptible(&cinergyt2->wq_sem)))
 		goto out;
 
-	if (mutex_lock_interruptible(&cinergyt2->sem))
+	if ((err = mutex_lock_interruptible(&cinergyt2->sem)))
 		goto out_unlock1;
 
-	err = 0;
-
 	if (!cinergyt2->sleeping) {
 		cinergyt2_sleep(cinergyt2, 0);
 		cinergyt2_command(cinergyt2, (char *) param, sizeof(*param), NULL, 0);
