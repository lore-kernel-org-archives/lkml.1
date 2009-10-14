Return-Path: <linux-kernel-owner+w=401wt.eu-S934764AbZJNPwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934764AbZJNPwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934713AbZJNPwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:52:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:34688 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934613AbZJNPwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:52:14 -0400
Date: Wed, 14 Oct 2009 15:51:15 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: yuasa@linux-mips.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yuasa@linux-mips.org, ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20091010153350.222654356@linutronix.de>
References: <20091010153350.222654356@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] mips: Remove BKL from tb0219
Message-ID: <tip-d2a7be0be1099c2554f4705d2c1c5081f8f96efc@git.kernel.org>
Git-Commit-ID: d2a7be0be1099c2554f4705d2c1c5081f8f96efc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:51:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2a7be0be1099c2554f4705d2c1c5081f8f96efc
Gitweb:     http://git.kernel.org/tip/d2a7be0be1099c2554f4705d2c1c5081f8f96efc
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 10 Oct 2009 16:07:03 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:36:53 +0200

mips: Remove BKL from tb0219

cycle_kernel_lock() was added during the big BKL pushdown. It should
ensure the serializiation against driver init code.

tb0219_base is initialized before the character device is
registered, but the spinlock is not initialized.

Initialize the spinlock statically and remove cycle_kernel_lock().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091010153350.222654356@linutronix.de>
Cc: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 drivers/char/tb0219.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tb0219.c b/drivers/char/tb0219.c
index b3ec9b1..cad4eb6 100644
--- a/drivers/char/tb0219.c
+++ b/drivers/char/tb0219.c
@@ -21,7 +21,6 @@
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 
 #include <asm/io.h>
 #include <asm/reboot.h>
@@ -38,7 +37,7 @@ MODULE_PARM_DESC(major, "Major device number");
 
 static void (*old_machine_restart)(char *command);
 static void __iomem *tb0219_base;
-static spinlock_t tb0219_lock;
+static DEFINE_SPINLOCK(tb0219_lock);
 
 #define tb0219_read(offset)		readw(tb0219_base + (offset))
 #define tb0219_write(offset, value)	writew((value), tb0219_base + (offset))
@@ -237,7 +236,6 @@ static int tanbac_tb0219_open(struct inode *inode, struct file *file)
 {
 	unsigned int minor;
 
-	cycle_kernel_lock();
 	minor = iminor(inode);
 	switch (minor) {
 	case 0:
@@ -306,8 +304,6 @@ static int __devinit tb0219_probe(struct platform_device *dev)
 		return retval;
 	}
 
-	spin_lock_init(&tb0219_lock);
-
 	old_machine_restart = _machine_restart;
 	_machine_restart = tb0219_restart;
 
