Return-Path: <linux-kernel-owner+w=401wt.eu-S933272AbYBHTFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272AbYBHTFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 14:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933395AbYBHTEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 14:04:53 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:44657 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390AbYBHTEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 14:04:50 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] tty: BKL pushdown fix
Date: Fri,  8 Feb 2008 20:04:47 +0100
Message-Id: <1202497487-32550-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080208154208.0efd6885@core>
References: <20080208154208.0efd6885@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/n_hdlc.c  |    4 ++--
 drivers/char/n_r3964.c |    6 +++---
 drivers/char/n_tty.c   |    2 +-
 drivers/char/tty_io.c  |   16 +++++++++-------
 drivers/char/vt.c      |    8 ++++----
 5 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/char/n_hdlc.c b/drivers/char/n_hdlc.c
index 0bc0498..77629da 100644
--- a/drivers/char/n_hdlc.c
+++ b/drivers/char/n_hdlc.c
@@ -579,7 +579,7 @@ static ssize_t n_hdlc_tty_read(struct tty_struct *tty, struct file *file,
 	}
 
 	lock_kernel();
-	
+
 	for (;;) {
 		if (test_bit(TTY_OTHER_CLOSED, &tty->flags)) {
 			unlock_kernel();
@@ -672,7 +672,7 @@ static ssize_t n_hdlc_tty_write(struct tty_struct *tty, struct file *file,
 	}
 	
 	lock_kernel();
-	
+
 	add_wait_queue(&tty->write_wait, &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
 	
diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
index 3eb7880..3f6486e 100644
--- a/drivers/char/n_r3964.c
+++ b/drivers/char/n_r3964.c
@@ -1074,7 +1074,7 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 	int count;
 
 	TRACE_L("read()");
-	
+
 	lock_kernel();
 
 	pClient = findClient(pInfo, task_pid(current));
@@ -1165,7 +1165,7 @@ static ssize_t r3964_write(struct tty_struct *tty, struct file *file,
 	pHeader->owner = NULL;
 
 	lock_kernel();
-	
+
 	pClient = findClient(pInfo, task_pid(current));
 	if (pClient) {
 		pHeader->owner = pClient;
@@ -1182,7 +1182,7 @@ static ssize_t r3964_write(struct tty_struct *tty, struct file *file,
  */
 	add_tx_queue(pInfo, pHeader);
 	trigger_transmit(pInfo);
-	
+
 	unlock_kernel();
 
 	return 0;
diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index a9c8c8f..79a052e 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -1303,7 +1303,7 @@ do_it_again:
 			return -ERESTARTSYS;
 	}
 	packet = tty->packet;
-	
+
 	add_wait_queue(&tty->read_wait, &wait);
 	while (nr) {
 		/* First test for status change. */
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 3d489ce..bf08a38 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1204,8 +1204,8 @@ static unsigned int hung_up_tty_poll(struct file *filp, poll_table *wait)
 	return POLLIN | POLLOUT | POLLERR | POLLHUP | POLLRDNORM | POLLWRNORM;
 }
 
-static long hung_up_tty_ioctl(struct inode *inode, struct file *file,
-			     unsigned int cmd, unsigned long arg)
+static long hung_up_tty_ioctl(struct file *file, unsigned int cmd,
+		unsigned long arg)
 {
 	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
 }
@@ -1259,7 +1259,7 @@ static const struct file_operations hung_up_tty_fops = {
 	.read		= hung_up_tty_read,
 	.write		= hung_up_tty_write,
 	.poll		= hung_up_tty_poll,
-	.ioctl		= hung_up_tty_ioctl,
+	.unlocked_ioctl	= hung_up_tty_ioctl,
 	.compat_ioctl	= hung_up_tty_compat_ioctl,
 	.release	= tty_release,
 };
@@ -3208,10 +3208,12 @@ static int tiocsetd(struct tty_struct *tty, int __user *p)
 
 	if (get_user(ldisc, p))
 		return -EFAULT;
-		
+
 	lock_kernel();
 	ret = tty_set_ldisc(tty, ldisc);
 	unlock_kernel();
+
+	return ret;
 }
 
 /**
@@ -3230,7 +3232,7 @@ static int tiocsetd(struct tty_struct *tty, int __user *p)
 static int send_break(struct tty_struct *tty, unsigned int duration)
 {
 	int retval = -EINTR;
-	
+
 	lock_kernel();
 	if (tty_write_lock(tty, 0) < 0)
 		goto out;
@@ -3345,9 +3347,9 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	/*
 	 * Break handling by driver
 	 */
-	 
+
 	retval = -EINVAL;
-	
+
 	if (!tty->driver->break_ctl) {
 		switch (cmd) {
 		case TIOCSBRK:
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index d6a3a2a..a26d65b 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2531,9 +2531,9 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 	if (get_user(type, p))
 		return -EFAULT;
 	ret = 0;
-	
+
 	lock_kernel();
-	
+
 	switch (type)
 	{
 		case TIOCL_SETSEL:
@@ -2553,7 +2553,7 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 			ret = sel_loadlut(p);
 			break;
 		case TIOCL_GETSHIFTSTATE:
-			
+
 	/*
 	 * Make it possible to react to Shift+Mousebutton.
 	 * Note that 'shift_state' is an undocumented
@@ -3823,7 +3823,7 @@ static int con_font_get(struct vc_data *vc, struct console_font_op *op)
 		goto out;
 
 	c = (font.width+7)/8 * 32 * font.charcount;
-	
+
 	if (op->data && font.charcount > op->charcount)
 		rc = -ENOSPC;
 	if (!(op->flags & KD_FONT_FLAG_OLD)) {
-- 
1.5.3.8

