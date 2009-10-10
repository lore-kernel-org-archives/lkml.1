Return-Path: <linux-kernel-owner+w=401wt.eu-S1762002AbZJJPiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762002AbZJJPiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761985AbZJJPis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:38:48 -0400
Received: from www.tglx.de ([62.245.132.106]:55589 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761986AbZJJPiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:38:46 -0400
Message-Id: <20091010153349.682213670@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:36:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Jeff Dike <jdike@addtoit.com>
Subject: [patch 15/28] um: Remove BKL from mmapper
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=um-remove-BKL-from-mmapper.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cycle_kernel_lock() was added during the big BKL pushdown. It should
ensure the serializiation against driver init code.

mmapper_open() cannot be called before misc_register() succeeded, but
p_buf might be uninitialized.

Move the initialization of p_buf before the misc_register() call and
get rid of cycle_kernel_lock().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Dike <jdike@addtoit.com>
---
 arch/um/drivers/mmapper_kern.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: linux-2.6-tip/arch/um/drivers/mmapper_kern.c
===================================================================
--- linux-2.6-tip.orig/arch/um/drivers/mmapper_kern.c
+++ linux-2.6-tip/arch/um/drivers/mmapper_kern.c
@@ -16,7 +16,7 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/smp_lock.h>
+
 #include <asm/uaccess.h>
 #include "mem_user.h"
 
@@ -78,7 +78,6 @@ out:
 
 static int mmapper_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
 	return 0;
 }
 
@@ -115,18 +114,16 @@ static int __init mmapper_init(void)
 	v_buf = (char *) find_iomem("mmapper", &mmapper_size);
 	if (mmapper_size == 0) {
 		printk(KERN_ERR "mmapper_init - find_iomem failed\n");
-		goto out;
+		return -ENODEV;
 	}
+	p_buf = __pa(v_buf);
 
 	err = misc_register(&mmapper_dev);
 	if (err) {
 		printk(KERN_ERR "mmapper - misc_register failed, err = %d\n",
 		       err);
-		goto out;
+		return err;;
 	}
-
-	p_buf = __pa(v_buf);
-out:
 	return 0;
 }
 


