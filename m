Return-Path: <linux-kernel-owner+w=401wt.eu-S934640AbZJNPq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934640AbZJNPq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934575AbZJNPq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:46:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:33968 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934598AbZJNPqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:46:54 -0400
Date: Wed, 14 Oct 2009 15:45:49 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jdike@addtoit.com, tglx@linutronix.de
In-Reply-To: <20091010153349.682213670@linutronix.de>
References: <20091010153349.682213670@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/arch] um: Remove BKL from mmapper
Message-ID: <tip-d63c489b881707adf9c0b89f771b30a1d78f4197@git.kernel.org>
Git-Commit-ID: d63c489b881707adf9c0b89f771b30a1d78f4197
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:45:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d63c489b881707adf9c0b89f771b30a1d78f4197
Gitweb:     http://git.kernel.org/tip/d63c489b881707adf9c0b89f771b30a1d78f4197
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 10 Oct 2009 15:36:34 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 15:35:51 +0200

um: Remove BKL from mmapper

cycle_kernel_lock() was added during the big BKL pushdown. It should
ensure the serializiation against driver init code.

mmapper_open() cannot be called before misc_register() succeeded, but
p_buf might be uninitialized.

Move the initialization of p_buf before the misc_register() call and
get rid of cycle_kernel_lock().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091010153349.682213670@linutronix.de>
Cc: Jeff Dike <jdike@addtoit.com>
---
 arch/um/drivers/mmapper_kern.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/um/drivers/mmapper_kern.c b/arch/um/drivers/mmapper_kern.c
index eb24032..d22f9e5 100644
--- a/arch/um/drivers/mmapper_kern.c
+++ b/arch/um/drivers/mmapper_kern.c
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
 
