Return-Path: <linux-kernel-owner+w=401wt.eu-S934896AbZJOIsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934896AbZJOIsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934760AbZJOIsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:48:54 -0400
Received: from www.tglx.de ([62.245.132.106]:34198 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934445AbZJOIsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:48:52 -0400
Message-Id: <20091015083934.032160870@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 15 Oct 2009 08:42:49 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
       ALan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Dike <jdike@addtoit.com>
Subject: [patch 7/7] um: Remove BKL from harddog
References: <20091015083906.716130653@linutronix.de>
Content-Disposition: inline; filename=um-remove-bkl-from-harddog.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's safe to remove the BKL from harddog because:

     - open() needs no serialization versus init
     - open() is already serialized with a local lock

     - ioctl() does not need BKL for put/copy_user
     - ioctl() does not need BKL for pin_watchdog as it
       simply writes to the fd which was created in open()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Dike <jdike@addtoit.com>
---
 arch/um/drivers/harddog_kern.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

Index: linux-2.6-tip/arch/um/drivers/harddog_kern.c
===================================================================
--- linux-2.6-tip.orig/arch/um/drivers/harddog_kern.c
+++ linux-2.6-tip/arch/um/drivers/harddog_kern.c
@@ -42,7 +42,6 @@
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/reboot.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <asm/uaccess.h>
@@ -66,7 +65,6 @@ static int harddog_open(struct inode *in
 	int err = -EBUSY;
 	char *sock = NULL;
 
-	lock_kernel();
 	spin_lock(&lock);
 	if(timer_alive)
 		goto err;
@@ -83,11 +81,9 @@ static int harddog_open(struct inode *in
 
 	timer_alive = 1;
 	spin_unlock(&lock);
-	unlock_kernel();
 	return nonseekable_open(inode, file);
 err:
 	spin_unlock(&lock);
-	unlock_kernel();
 	return err;
 }
 
@@ -124,8 +120,8 @@ static ssize_t harddog_write(struct file
 	return 0;
 }
 
-static int harddog_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, unsigned long arg)
+static long harddog_ioctl(struct file *file, unsigned int cmd,
+			  unsigned long arg)
 {
 	void __user *argp= (void __user *)arg;
 	static struct watchdog_info ident = {
@@ -151,7 +147,7 @@ static int harddog_ioctl(struct inode *i
 static const struct file_operations harddog_fops = {
 	.owner		= THIS_MODULE,
 	.write		= harddog_write,
-	.ioctl		= harddog_ioctl,
+	.unlocked_ioctl	= harddog_ioctl,
 	.open		= harddog_open,
 	.release	= harddog_release,
 };


