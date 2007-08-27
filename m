Return-Path: <linux-kernel-owner+w=401wt.eu-S933822AbXH0VrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822AbXH0VrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765120AbXH0VbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:31:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47210 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765565AbXH0VbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:31:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 3/4] Hibernation: Pass CR3 in the image header on x86_64 (rev. 2)
Date: Mon, 27 Aug 2007 23:38:32 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <ak@suse.de>, Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708272331.28584.rjw@sisk.pl>
In-Reply-To: <200708272331.28584.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708272338.32873.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since we already pass the address of restore_registers() in the image header,
we can also pass the value of the CR3 register from before the hibernation in
the same way.  This will allow us to avoid using init_level4_pgt page tables
during the restore.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 arch/x86_64/kernel/suspend.c     |   16 ++++++++++++----
 arch/x86_64/kernel/suspend_asm.S |    8 +++++---
 2 files changed, 17 insertions(+), 7 deletions(-)

Index: linux-2.6.23-rc3/arch/x86_64/kernel/suspend.c
===================================================================
--- linux-2.6.23-rc3.orig/arch/x86_64/kernel/suspend.c	2007-08-25 22:11:43.000000000 +0200
+++ linux-2.6.23-rc3/arch/x86_64/kernel/suspend.c	2007-08-25 22:51:56.000000000 +0200
@@ -150,6 +150,12 @@ extern int restore_image(void);
  */
 unsigned long restore_jump_address;
 
+/*
+ * Value of the cr3 register from before the hibernation (this value is passed
+ * in the image header).
+ */
+unsigned long restore_cr3;
+
 pgd_t *temp_level4_pgt;
 
 void *relocated_restore_code;
@@ -248,7 +254,8 @@ int pfn_is_nosave(unsigned long pfn)
 
 struct restore_data_record {
 	unsigned long jump_address;
-	unsigned long control;
+	unsigned long cr3;
+	unsigned long magic;
 };
 
 #define RESTORE_MAGIC	0x0123456789ABCDEFUL
@@ -265,7 +272,8 @@ int arch_hibernation_header_save(void *a
 	if (max_size < sizeof(struct restore_data_record))
 		return -EOVERFLOW;
 	rdr->jump_address = restore_jump_address;
-	rdr->control = (restore_jump_address ^ RESTORE_MAGIC);
+	rdr->cr3 = restore_cr3;
+	rdr->magic = RESTORE_MAGIC;
 	return 0;
 }
 
@@ -279,7 +287,7 @@ int arch_hibernation_header_restore(void
 	struct restore_data_record *rdr = addr;
 
 	restore_jump_address = rdr->jump_address;
-	return (rdr->control == (restore_jump_address ^ RESTORE_MAGIC)) ?
-			0 : -EINVAL;
+	restore_cr3 = rdr->cr3;
+	return (rdr->magic == RESTORE_MAGIC) ? 0 : -EINVAL;
 }
 #endif /* CONFIG_HIBERNATION */
Index: linux-2.6.23-rc3/arch/x86_64/kernel/suspend_asm.S
===================================================================
--- linux-2.6.23-rc3.orig/arch/x86_64/kernel/suspend_asm.S	2007-08-25 22:10:25.000000000 +0200
+++ linux-2.6.23-rc3/arch/x86_64/kernel/suspend_asm.S	2007-08-25 22:51:56.000000000 +0200
@@ -39,6 +39,9 @@ ENTRY(swsusp_arch_suspend)
 	/* save the address of restore_registers */
 	movq	$restore_registers, %rax
 	movq	%rax, restore_jump_address(%rip)
+	/* save cr3 */
+	movq	%cr3, %rax
+	movq	%rax, restore_cr3(%rip)
 
 	call swsusp_save
 	ret
@@ -60,6 +63,7 @@ ENTRY(restore_image)
 
 	/* prepare to jump to the image kernel */
 	movq	restore_jump_address(%rip), %rax
+	movq	restore_cr3(%rip), %rbx
 
 	/* prepare to copy image data to their original locations */
 	movq	restore_pblist(%rip), %rdx
@@ -98,9 +102,7 @@ done:
 
 ENTRY(restore_registers)
 	/* go back to the original page tables */
-	movq    $(init_level4_pgt - __START_KERNEL_map), %rax
-	addq    phys_base(%rip), %rax
-	movq    %rax, %cr3
+	movq    %rbx, %cr3
 
 	/* Flush TLB, including "global" things (vmalloc) */
 	movq	mmu_cr4_features(%rip), %rax
