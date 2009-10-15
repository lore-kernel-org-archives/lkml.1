Return-Path: <linux-kernel-owner+w=401wt.eu-S933122AbZJOInh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbZJOInh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933133AbZJOIng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:43:36 -0400
Received: from www.tglx.de ([62.245.132.106]:55049 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933121AbZJOIne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:43:34 -0400
Message-Id: <20091015083933.897280001@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 15 Oct 2009 08:42:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
       ALan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [patch 4/7] sh: Remove BKL from landisk gio
References: <20091015083906.716130653@linutronix.de>
Content-Disposition: inline; filename=sh-remove-bkl-from-landisk-gio.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The open function got the BKL via the big push down. Replace it by
preempt_enable/disable as this is sufficient for an UP machine.

The ioctl can be unlocked because there is no functionality which
requires serialization. The usage by multiple callers is broken with
and without the BKL due to the local static variable addr.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/boards/mach-landisk/gio.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: linux-2.6-tip/arch/sh/boards/mach-landisk/gio.c
===================================================================
--- linux-2.6-tip.orig/arch/sh/boards/mach-landisk/gio.c
+++ linux-2.6-tip/arch/sh/boards/mach-landisk/gio.c
@@ -14,7 +14,6 @@
  */
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/smp_lock.h>
 #include <linux/kdev_t.h>
 #include <linux/cdev.h>
 #include <linux/fs.h>
@@ -35,7 +34,7 @@ static int gio_open(struct inode *inode,
 	int minor;
 	int ret = -ENOENT;
 
-	lock_kernel();
+	preempt_disable();
 	minor = MINOR(inode->i_rdev);
 	if (minor < DEVCOUNT) {
 		if (openCnt > 0) {
@@ -45,7 +44,7 @@ static int gio_open(struct inode *inode,
 			ret = 0;
 		}
 	}
-	unlock_kernel();
+	preempt_enable();
 	return ret;
 }
 
@@ -60,8 +59,7 @@ static int gio_close(struct inode *inode
 	return 0;
 }
 
-static int gio_ioctl(struct inode *inode, struct file *filp,
-			     unsigned int cmd, unsigned long arg)
+static long gio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	unsigned int data;
 	static unsigned int addr = 0;
@@ -129,7 +127,7 @@ static const struct file_operations gio_
 	.owner = THIS_MODULE,
 	.open = gio_open,	/* open */
 	.release = gio_close,	/* release */
-	.ioctl = gio_ioctl,	/* ioctl */
+	.unlocked_ioctl = gio_ioctl,
 };
 
 static int __init gio_init(void)


