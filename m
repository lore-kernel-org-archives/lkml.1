Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbXBVWxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbXBVWxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 17:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbXBVWxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 17:53:40 -0500
Received: from [198.99.130.12] ([198.99.130.12]:35934 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbXBVWxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 17:53:38 -0500
Date: Thu, 22 Feb 2007 17:45:27 -0500
From: Jeff Dike <jdike@addtoit.com>
To: akpm@osdl.org, Blaisorblade <blaisorblade@yahoo.it>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 1/2] UML - Fix host LDT lookup initialization locking, try 2
Message-ID: <20070222224527.GA7982@ccure.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add some locking to host_ldt_entries to prevent racing when reading
LDT information from the host.

The locking is somewhat more careful than my previous attempt.  Now,
only the check of host_ldt_entries is locked.  The lock is dropped
immediately afterwards, and if the LDT needs initializing, that (and
the memory allocations needed) proceed outside the lock.

Also fixed some style violations.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
--
 arch/um/sys-i386/ldt.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

Index: linux-2.6.17/arch/um/sys-i386/ldt.c
===================================================================
--- linux-2.6.17.orig/arch/um/sys-i386/ldt.c	2007-02-05 17:12:14.000000000 -0500
+++ linux-2.6.17/arch/um/sys-i386/ldt.c	2007-02-22 17:30:24.000000000 -0500
@@ -7,6 +7,7 @@
 #include "linux/slab.h"
 #include "linux/types.h"
 #include "linux/errno.h"
+#include "linux/spinlock.h"
 #include "asm/uaccess.h"
 #include "asm/smp.h"
 #include "asm/ldt.h"
@@ -386,23 +387,33 @@ static long do_modify_ldt_skas(int func,
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
-	struct ldt_entry * ldt;
+	struct ldt_entry * ldt, *tmp;
 	int i, size, k, order;
 
+	spin_lock(&host_ldt_lock);
+
+	if(host_ldt_entries != NULL){
+		spin_unlock(&host_ldt_lock);
+		return;
+	}
 	host_ldt_entries = dummy_list+1;
 
+	spin_unlock(&host_ldt_lock);
+
 	for(i = LDT_PAGES_MAX-1, order=0; i; i>>=1, order++);
 
 	ldt = (struct ldt_entry *)
 	      __get_free_pages(GFP_KERNEL|__GFP_ZERO, order);
 	if(ldt == NULL) {
-		printk("ldt_get_host_info: couldn't allocate buffer for host ldt\n");
+		printk("ldt_get_host_info: couldn't allocate buffer for host "
+		       "ldt\n");
 		return;
 	}
 
@@ -426,11 +437,13 @@ void ldt_get_host_info(void)
 		host_ldt_entries = dummy_list;
 	else {
 		size = (size + 1) * sizeof(dummy_list[0]);
-		host_ldt_entries = kmalloc(size, GFP_KERNEL);
-		if(host_ldt_entries == NULL) {
-			printk("ldt_get_host_info: couldn't allocate host ldt list\n");
+		tmp = kmalloc(size, GFP_KERNEL);
+		if(tmp == NULL) {
+			printk("ldt_get_host_info: couldn't allocate host ldt "
+			       "list\n");
 			goto out_free;
 		}
+		host_ldt_entries = tmp;
 	}
 
 	for(i=0, k=0; i<ret/LDT_ENTRY_SIZE; i++){
@@ -480,8 +493,7 @@ long init_new_ldt(struct mmu_context_ska
 			 * inherited from the host. All ldt-entries found
 			 * will be reset in the following loop
 			 */
-			if(host_ldt_entries == NULL)
-				ldt_get_host_info();
+			ldt_get_host_info();
 			for(num_p=host_ldt_entries; *num_p != -1; num_p++){
 				desc.entry_number = *num_p;
 				err = write_ldt_entry(&new_mm->id, 1, &desc,
@@ -560,6 +572,6 @@ void free_ldt(struct mmu_context_skas * 
 
 int sys_modify_ldt(int func, void __user *ptr, unsigned long bytecount)
 {
-	return(CHOOSE_MODE_PROC(do_modify_ldt_tt, do_modify_ldt_skas, func,
-	                        ptr, bytecount));
+	return CHOOSE_MODE_PROC(do_modify_ldt_tt, do_modify_ldt_skas, func,
+	                        ptr, bytecount);
 }
