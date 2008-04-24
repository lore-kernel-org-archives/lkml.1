Return-Path: <linux-kernel-owner+w=401wt.eu-S1760129AbYDXPPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129AbYDXPPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758910AbYDXPOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:14:33 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:55943 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564AbYDXPOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:14:31 -0400
Message-Id: <20080424151355.559306461@polymtl.ca>
References: <20080424150324.802695381@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 11:03:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 09/37] Fix sched-devel text_poke
Content-Disposition: inline; filename=fix-sched-devel-text-poke.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Apr 2008 15:13:56 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use core_text_address() instead of kernel_text_address(). Deal with modules in
the same way used for the core kernel.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/x86/kernel/alternative.c |   38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

Index: linux-2.6-sched-devel/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6-sched-devel.orig/arch/x86/kernel/alternative.c	2008-04-22 20:15:41.000000000 -0400
+++ linux-2.6-sched-devel/arch/x86/kernel/alternative.c	2008-04-22 20:16:22.000000000 -0400
@@ -511,31 +511,29 @@ void *__kprobes text_poke(void *addr, co
 	unsigned long flags;
 	char *vaddr;
 	int nr_pages = 2;
+	struct page *pages[2];
+	int i;
 
-	BUG_ON(len > sizeof(long));
-	BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
-		- ((long)addr & ~(sizeof(long) - 1)));
-	if (kernel_text_address((unsigned long)addr)) {
-		struct page *pages[2] = { virt_to_page(addr),
-			virt_to_page(addr + PAGE_SIZE) };
-		if (!pages[1])
-			nr_pages = 1;
-		vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
-		BUG_ON(!vaddr);
-		local_irq_save(flags);
-		memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
-		local_irq_restore(flags);
-		vunmap(vaddr);
+	if (!core_kernel_text((unsigned long)addr)) {
+		pages[0] = vmalloc_to_page(addr);
+		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
 	} else {
-		/*
-		 * modules are in vmalloc'ed memory, always writable.
-		 */
-		local_irq_save(flags);
-		memcpy(addr, opcode, len);
-		local_irq_restore(flags);
+		pages[0] = virt_to_page(addr);
+		pages[1] = virt_to_page(addr + PAGE_SIZE);
 	}
+	BUG_ON(!pages[0]);
+	if (!pages[1])
+		nr_pages = 1;
+	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
+	BUG_ON(!vaddr);
+	local_irq_save(flags);
+	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
+	local_irq_restore(flags);
+	vunmap(vaddr);
 	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but
 	   that causes hangs on some VIA CPUs. */
+	for (i = 0; i < len; i++)
+		BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
 	return addr;
 }

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
