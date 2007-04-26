Return-Path: <linux-kernel-owner+w=401wt.eu-S1031488AbXDZUAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031488AbXDZUAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031480AbXDZUAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:00:32 -0400
Received: from [198.99.130.12] ([198.99.130.12]:49651 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1031483AbXDZUAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:00:30 -0400
Date: Thu, 26 Apr 2007 15:56:24 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/5] UML - Only flush areas covered by VMA
Message-ID: <20070426195624.GA9578@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When doing a full address space flush, only look at areas covered by a VMA.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/kernel/skas/tlb.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6.21-mm/arch/um/kernel/skas/tlb.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/skas/tlb.c	2007-04-17 12:20:05.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/skas/tlb.c	2007-04-17 12:55:38.000000000 -0400
@@ -89,8 +89,13 @@ void flush_tlb_mm_skas(struct mm_struct 
 
 void force_flush_all_skas(void)
 {
-	unsigned long end = proc_mm ? task_size : CONFIG_STUB_START;
-        fix_range(current->mm, 0, end, 1);
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma = mm->mmap;
+
+	while(vma != NULL) {
+		fix_range(mm, vma->vm_start, vma->vm_end, 1);
+		vma = vma->vm_next;
+	}
 }
 
 void flush_tlb_page_skas(struct vm_area_struct *vma, unsigned long address)
