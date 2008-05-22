Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbYEVUtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbYEVUtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754938AbYEVUtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:49:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50147 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754706AbYEVUtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:49:21 -0400
Date: Thu, 22 May 2008 21:36:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jrv@vanzandt.mv.com, linux-kernel@vger.kernel.org
Subject: [PATCH] dtlk: Push down the BKL
Message-ID: <20080522213653.08f7c90b@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is pretty close to eliminating it but needs someone to take the
final steps

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/dtlk.c b/drivers/char/dtlk.c
index abde6dd..3fd9284 100644
--- a/drivers/char/dtlk.c
+++ b/drivers/char/dtlk.c
@@ -62,6 +62,7 @@
 #include <linux/init.h>		/* for __init, module_{init,exit} */
 #include <linux/poll.h>		/* for POLLIN, etc. */
 #include <linux/dtlk.h>		/* local header file for DoubleTalk values */
+#include <linux/smp_lock.h>
 
 #ifdef TRACING
 #define TRACE_TEXT(str) printk(str);
@@ -91,8 +92,8 @@ static ssize_t dtlk_write(struct file *, const char __user *,
 static unsigned int dtlk_poll(struct file *, poll_table *);
 static int dtlk_open(struct inode *, struct file *);
 static int dtlk_release(struct inode *, struct file *);
-static int dtlk_ioctl(struct inode *inode, struct file *file,
-		      unsigned int cmd, unsigned long arg);
+static long dtlk_ioctl(struct file *file, unsigned int cmd,
+			unsigned long arg);
 
 static const struct file_operations dtlk_fops =
 {
@@ -100,7 +101,7 @@ static const struct file_operations dtlk_fops =
 	.read		= dtlk_read,
 	.write		= dtlk_write,
 	.poll		= dtlk_poll,
-	.ioctl		= dtlk_ioctl,
+	.unlocked_ioctl	= dtlk_ioctl,
 	.open		= dtlk_open,
 	.release	= dtlk_release,
 };
@@ -261,10 +262,8 @@ static void dtlk_timer_tick(unsigned long data)
 	wake_up_interruptible(&dtlk_process_list);
 }
 
-static int dtlk_ioctl(struct inode *inode,
-		      struct file *file,
-		      unsigned int cmd,
-		      unsigned long arg)
+static long dtlk_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	char __user *argp = (char __user *)arg;
 	struct dtlk_settings *sp;
@@ -274,17 +273,21 @@ static int dtlk_ioctl(struct inode *inode,
 	switch (cmd) {
 
 	case DTLK_INTERROGATE:
+		lock_kernel();
 		sp = dtlk_interrogate();
+		unlock_kernel();
 		if (copy_to_user(argp, sp, sizeof(struct dtlk_settings)))
 			return -EINVAL;
 		return 0;
 
 	case DTLK_STATUS:
+		lock_kernel();
 		portval = inb_p(dtlk_port_tts);
+		unlock_kernel();
 		return put_user(portval, argp);
 
 	default:
-		return -EINVAL;
+		return -ENOTTY;
 	}
 }
 
