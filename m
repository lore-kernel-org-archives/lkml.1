Return-Path: <linux-kernel-owner+w=401wt.eu-S964849AbZJJPjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964849AbZJJPjd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934404AbZJJPja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:39:30 -0400
Received: from www.tglx.de ([62.245.132.106]:55674 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761787AbZJJPj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:39:27 -0400
Message-Id: <20091010153350.222654356@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:37:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Yoichi Yuasa <yuasa@linux-mips.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: [patch 28/28] mips: Remove BKL from tb0219
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=tb0219-remove-bkl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cycle_kernel_lock() was added during the big BKL pushdown. It should
ensure the serializiation against driver init code.

tb0219_base is initialized before the character device is
registered, but the spinlock is not initialized.

Initialize the spinlock statically and remove cycle_kernel_lock().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 drivers/char/tb0219.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux-2.6-tip/drivers/char/tb0219.c
===================================================================
--- linux-2.6-tip.orig/drivers/char/tb0219.c
+++ linux-2.6-tip/drivers/char/tb0219.c
@@ -21,7 +21,6 @@
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 
 #include <asm/io.h>
 #include <asm/reboot.h>
@@ -38,7 +37,7 @@ MODULE_PARM_DESC(major, "Major device nu
 
 static void (*old_machine_restart)(char *command);
 static void __iomem *tb0219_base;
-static spinlock_t tb0219_lock;
+static DEFINE_SPINLOCK(tb0219_lock);
 
 #define tb0219_read(offset)		readw(tb0219_base + (offset))
 #define tb0219_write(offset, value)	writew((value), tb0219_base + (offset))
@@ -237,7 +236,6 @@ static int tanbac_tb0219_open(struct ino
 {
 	unsigned int minor;
 
-	cycle_kernel_lock();
 	minor = iminor(inode);
 	switch (minor) {
 	case 0:
@@ -306,8 +304,6 @@ static int __devinit tb0219_probe(struct
 		return retval;
 	}
 
-	spin_lock_init(&tb0219_lock);
-
 	old_machine_restart = _machine_restart;
 	_machine_restart = tb0219_restart;
 


