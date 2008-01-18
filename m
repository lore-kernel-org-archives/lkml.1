Return-Path: <linux-kernel-owner+w=401wt.eu-S1763603AbYARSIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763603AbYARSIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761258AbYARSIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:08:06 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:50878 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761288AbYARSIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:08:05 -0500
Date: Fri, 18 Jan 2008 13:07:49 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: UML is leaking memory in arch_dup_mmap
Message-ID: <20080118180749.GA7688@c2.user-mode-linux.org>
References: <E1JFsQo-0000aG-BZ@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JFsQo-0000aG-BZ@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 03:42:54PM +0100, Miklos Szeredi wrote:
> uml:~#  grep arch_dup_mmap /proc/slab_allocators
> size-32: 10861 arch_dup_mmap+0x9f/0x130

Whoops - try the patch below.

				Jeff

-- 
Work email - jdike at linux dot intel dot com

Index: linux-2.6.22/arch/um/include/um_mmu.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/um_mmu.h	2008-01-17 13:44:49.000000000 -0500
+++ linux-2.6.22/arch/um/include/um_mmu.h	2008-01-18 12:53:10.000000000 -0500
@@ -17,6 +17,7 @@ typedef struct mm_context {
 	unsigned long last_pmd;
 #endif
 	struct uml_ldt ldt;
+	struct page **stub_pages;
 } mm_context_t;
 
 extern void __switch_mm(struct mm_id * mm_idp);
Index: linux-2.6.22/arch/um/kernel/skas/mmu.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/skas/mmu.c	2008-01-18 13:02:52.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/skas/mmu.c	2008-01-18 13:04:42.000000000 -0500
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
 
+	if(mm->context.stub_pages != NULL)
+		kfree(mm->context.stub_pages);
 	pte = virt_to_pte(mm, STUB_CODE);
 	if (pte != NULL)
 		pte_clear(mm, STUB_CODE, pte);
