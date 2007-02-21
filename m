Return-Path: <linux-kernel-owner+w=401wt.eu-S1423109AbXBUUeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423109AbXBUUeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423088AbXBUUdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:33:46 -0500
Received: from [198.99.130.12] ([198.99.130.12]:59701 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1423105AbXBUUdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:33:40 -0500
Message-Id: <200702212025.l1LKPKRm006789@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 4/4] UML - lock host ldt retrieval
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 21 Feb 2007 15:25:20 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add some locking to host_ldt_entries to prevent racing when reading
LDT information from the host.

Also fixed some style violations.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/sys-i386/ldt.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

Index: linux-2.6.18-mm/arch/um/sys-i386/ldt.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/sys-i386/ldt.c	2007-01-14 17:29:35.000000000 +1100
+++ linux-2.6.18-mm/arch/um/sys-i386/ldt.c	2007-01-15 17:03:25.000000000 +1100
@@ -7,6 +7,7 @@
 #include "linux/slab.h"
 #include "linux/types.h"
 #include "linux/errno.h"
+#include "linux/spinlock.h"
 #include "asm/uaccess.h"
 #include "asm/smp.h"
 #include "asm/ldt.h"
@@ -386,15 +387,20 @@ static long do_modify_ldt_skas(int func,
 	return ret;
 }
 
-short dummy_list[9] = {0, -1};
-short * host_ldt_entries = NULL;
+static DEFINE_SPINLOCK(host_ldt_lock);
+static short dummy_list[9] = {0, -1};
+static short * host_ldt_entries = NULL;
 
-void ldt_get_host_info(void)
+static void ldt_get_host_info(void)
 {
 	long ret;
 	struct ldt_entry * ldt;
 	int i, size, k, order;
 
+	spin_lock(&host_ldt_lock);
+	if(host_ldt_entries != NULL)
+		goto out_unlock;
+
 	host_ldt_entries = dummy_list+1;
 
 	for(i = LDT_PAGES_MAX-1, order=0; i; i>>=1, order++);
@@ -402,8 +408,9 @@ void ldt_get_host_info(void)
 	ldt = (struct ldt_entry *)
 	      __get_free_pages(GFP_KERNEL|__GFP_ZERO, order);
 	if(ldt == NULL) {
-		printk("ldt_get_host_info: couldn't allocate buffer for host ldt\n");
-		return;
+		printk("ldt_get_host_info: couldn't allocate buffer for host "
+		       "ldt\n");
+		goto out_unlock;
 	}
 
 	ret = modify_ldt(0, ldt, (1<<order)*PAGE_SIZE);
@@ -428,7 +435,8 @@ void ldt_get_host_info(void)
 		size = (size + 1) * sizeof(dummy_list[0]);
 		host_ldt_entries = kmalloc(size, GFP_KERNEL);
 		if(host_ldt_entries == NULL) {
-			printk("ldt_get_host_info: couldn't allocate host ldt list\n");
+			printk("ldt_get_host_info: couldn't allocate host ldt "
+			       "list\n");
 			goto out_free;
 		}
 	}
@@ -442,6 +450,8 @@ void ldt_get_host_info(void)
 
 out_free:
 	free_pages((unsigned long)ldt, order);
+out_unlock:
+	spin_unlock(&host_ldt_lock);
 }
 
 long init_new_ldt(struct mmu_context_skas * new_mm,
@@ -480,8 +490,7 @@ long init_new_ldt(struct mmu_context_ska
 			 * inherited from the host. All ldt-entries found
 			 * will be reset in the following loop
 			 */
-			if(host_ldt_entries == NULL)
-				ldt_get_host_info();
+			ldt_get_host_info();
 			for(num_p=host_ldt_entries; *num_p != -1; num_p++){
 				desc.entry_number = *num_p;
 				err = write_ldt_entry(&new_mm->id, 1, &desc,
@@ -560,6 +569,6 @@ void free_ldt(struct mmu_context_skas * 
 
 int sys_modify_ldt(int func, void __user *ptr, unsigned long bytecount)
 {
-	return(CHOOSE_MODE_PROC(do_modify_ldt_tt, do_modify_ldt_skas, func,
-	                        ptr, bytecount));
+	return CHOOSE_MODE_PROC(do_modify_ldt_tt, do_modify_ldt_skas, func,
+	                        ptr, bytecount);
 }

