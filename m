Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbYBFRqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbYBFRqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbYBFRpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:45:46 -0500
Received: from [198.99.130.12] ([198.99.130.12]:44521 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756638AbYBFRpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:45:44 -0500
Date: Wed, 6 Feb 2008 12:44:48 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 5/5] UML - Fix mm_context memory leak 
Message-ID: <20080206174448.GA7851@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Spotted by Miklos ]

Fix a memory leak in init_new_context.  The struct page ** buffer
allocated for install_special_mapping was never recorded, and thus
leaked when the mm_struct was freed.  Fix it by saving the pointer in
mm_context_t and freeing it in arch_exit_mmap.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
---
 arch/um/include/um_mmu.h  |    1 +
 arch/um/kernel/skas/mmu.c |    5 +++++
 2 files changed, 6 insertions(+)

Index: linux-2.6-git/arch/um/include/um_mmu.h
===================================================================
--- linux-2.6-git.orig/arch/um/include/um_mmu.h	2008-02-06 12:15:05.000000000 -0500
+++ linux-2.6-git/arch/um/include/um_mmu.h	2008-02-06 12:24:08.000000000 -0500
@@ -13,6 +13,7 @@
 typedef struct mm_context {
 	struct mm_id id;
 	struct uml_ldt ldt;
+	struct page **stub_pages;
 } mm_context_t;
 
 extern void __switch_mm(struct mm_id * mm_idp);
Index: linux-2.6-git/arch/um/kernel/skas/mmu.c
===================================================================
--- linux-2.6-git.orig/arch/um/kernel/skas/mmu.c	2008-02-06 12:15:05.000000000 -0500
+++ linux-2.6-git/arch/um/kernel/skas/mmu.c	2008-02-06 12:24:31.000000000 -0500
@@ -91,6 +91,8 @@ int init_new_context(struct task_struct 
 		goto out_free;
 	}
 
+	to_mm->stub_pages = NULL;
+
 	return 0;
 
  out_free:
@@ -126,6 +128,7 @@ void arch_dup_mmap(struct mm_struct *old
 
 	pages[0] = virt_to_page(&__syscall_stub_start);
 	pages[1] = virt_to_page(mm->context.id.stack);
+	mm->context.stub_pages = pages;
 
 	/* dup_mmap already holds mmap_sem */
 	err = install_special_mapping(mm, STUB_START, STUB_END - STUB_START,
@@ -147,6 +150,8 @@ void arch_exit_mmap(struct mm_struct *mm
 {
 	pte_t *pte;
 
+	if (mm->context.stub_pages != NULL)
+		kfree(mm->context.stub_pages);
 	pte = virt_to_pte(mm, STUB_CODE);
 	if (pte != NULL)
 		pte_clear(mm, STUB_CODE, pte);
