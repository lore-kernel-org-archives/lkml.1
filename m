Return-Path: <linux-kernel-owner+w=401wt.eu-S1761981AbZJJPim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761981AbZJJPim (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761964AbZJJPik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:38:40 -0400
Received: from www.tglx.de ([62.245.132.106]:55571 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761932AbZJJPii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:38:38 -0400
Message-Id: <20091010153349.804244057@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:36:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 18/28] watchdog: Remove BKL from rio watchdog driver
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=drivers-watchdog-rio-remove-bkl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cycle_kernel_lock() was added with the BKL pushdown. The rio driver
indeed needs that because riowd_device is initialized after
misc_register(). So an open(), write/ioctl() which happens to get
between misc_register returning and riowd_device initialization would
dereference a NULL pointer.

Move riowd_device initialization before misc_register() and get rid of
cycle_kernel_lock().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/watchdog/riowd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-tip/drivers/watchdog/riowd.c
===================================================================
--- linux-2.6-tip.orig/drivers/watchdog/riowd.c
+++ linux-2.6-tip/drivers/watchdog/riowd.c
@@ -10,7 +10,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
-#include <linux/smp_lock.h>
 #include <linux/watchdog.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -75,7 +74,6 @@ static void riowd_writereg(struct riowd 
 
 static int riowd_open(struct inode *inode, struct file *filp)
 {
-	cycle_kernel_lock();
 	nonseekable_open(inode, filp);
 	return 0;
 }
@@ -194,6 +192,8 @@ static int __devinit riowd_probe(struct 
 		printk(KERN_ERR PFX "Cannot map registers.\n");
 		goto out_free;
 	}
+	/* Make miscdev useable right away */
+	riowd_device = p;
 
 	err = misc_register(&riowd_miscdev);
 	if (err) {
@@ -205,10 +205,10 @@ static int __devinit riowd_probe(struct 
 	       "regs at %p\n", riowd_timeout, p->regs);
 
 	dev_set_drvdata(&op->dev, p);
-	riowd_device = p;
 	return 0;
 
 out_iounmap:
+	riowd_device = NULL;
 	of_iounmap(&op->resource[0], p->regs, 2);
 
 out_free:


