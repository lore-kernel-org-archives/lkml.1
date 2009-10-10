Return-Path: <linux-kernel-owner+w=401wt.eu-S1761875AbZJJPh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761875AbZJJPh3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761847AbZJJPh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:37:28 -0400
Received: from www.tglx.de ([62.245.132.106]:55302 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761837AbZJJPhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:37:25 -0400
Message-Id: <20091010153349.237173041@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:35:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 05/28] drivers: Remove BKL from drivers/char/misc.c
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=driver-char-misc-remove-bkl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

misc_open() is already serialized with misc_mtx. Remove the BKL
locking which got there via the BKL pushdown.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/misc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6-tip/drivers/char/misc.c
===================================================================
--- linux-2.6-tip.orig/drivers/char/misc.c
+++ linux-2.6-tip/drivers/char/misc.c
@@ -49,7 +49,6 @@
 #include <linux/device.h>
 #include <linux/tty.h>
 #include <linux/kmod.h>
-#include <linux/smp_lock.h>
 
 /*
  * Head entry for the doubly linked miscdevice list
@@ -118,8 +117,7 @@ static int misc_open(struct inode * inod
 	struct miscdevice *c;
 	int err = -ENODEV;
 	const struct file_operations *old_fops, *new_fops = NULL;
-	
-	lock_kernel();
+
 	mutex_lock(&misc_mtx);
 	
 	list_for_each_entry(c, &misc_list, list) {
@@ -157,7 +155,6 @@ static int misc_open(struct inode * inod
 	fops_put(old_fops);
 fail:
 	mutex_unlock(&misc_mtx);
-	unlock_kernel();
 	return err;
 }
 


