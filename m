Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbYDIQVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbYDIQVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 12:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYDIQVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 12:21:09 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58296 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbYDIQVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 12:21:08 -0400
Message-Id: <20080409152048.169234727@polymtl.ca>
References: <20080409150829.855195878@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Apr 2008 11:08:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 05/17] x86 Fix text_poke for vmalloced pages
Content-Disposition: inline; filename=fix-text-poke-for-vmalloced-pages.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Apr 2008 16:20:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shadow vmap for DEBUG_RODATA kernel text modification uses virt_to_page to
get the pages from the pointer address and vmalloc_to_page for vmalloc'ed
pages.

- Changelog:
Deal with read-only module text.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/alternative.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

Index: linux-2.6-lttng/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/alternative.c	2008-03-24 10:00:30.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/alternative.c	2008-03-24 10:18:19.000000000 -0400
@@ -507,22 +507,27 @@ void *__kprobes text_poke(void *addr, co
 	unsigned long flags;
 	char *vaddr;
 	int nr_pages = 2;
+	struct page *pages[2];
 
 	BUG_ON(len > sizeof(long));
 	BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
 		- ((long)addr & ~(sizeof(long) - 1)));
-	{
-		struct page *pages[2] = { virt_to_page(addr),
-			virt_to_page(addr + PAGE_SIZE) };
-		if (!pages[1])
-			nr_pages = 1;
-		vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
-		WARN_ON(!vaddr);
-		local_irq_save(flags);
-		memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
-		local_irq_restore(flags);
-		vunmap(vaddr);
+	if (is_vmalloc_addr(addr)) {
+		pages[0] = vmalloc_to_page(addr);
+		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
+	} else {
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

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
