Return-Path: <linux-kernel-owner+w=401wt.eu-S1760523AbYDPViK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523AbYDPViK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbYDPVgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:36:09 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:34993 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbYDPVgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:36:05 -0400
Message-Id: <20080416213547.759543169@polymtl.ca>
References: <20080416213426.298498397@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 17:34:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 03/27] Check for breakpoint in text_poke to eliminate bug_on
Content-Disposition: inline; filename=check-for-breakpoint-in-text-poke-to-eliminate-bug-on.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 16 Apr 2008 21:35:48 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's ok to modify an instruction non-atomically (multiple memory accesses to a
large and/or non aligned instruction) *if and only if* we have inserted a
breakpoint at the beginning of the instruction.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/x86/kernel/alternative.c |   49 ++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

Index: linux-2.6-sched-devel/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6-sched-devel.orig/arch/x86/kernel/alternative.c	2008-04-16 17:17:59.000000000 -0400
+++ linux-2.6-sched-devel/arch/x86/kernel/alternative.c	2008-04-16 17:19:53.000000000 -0400
@@ -15,6 +15,7 @@
 #include <asm/io.h>
 
 #define MAX_PATCH_LEN (255-1)
+#define BREAKPOINT_INSTRUCTION	0xcc
 
 #ifdef CONFIG_HOTPLUG_CPU
 static int smp_alt_once;
@@ -505,37 +506,45 @@ void *text_poke_early(void *addr, const 
  * It means the size must be writable atomically and the address must be aligned
  * in a way that permits an atomic write. It also makes sure we fit on a single
  * page.
+ *
+ * It's ok to modify an instruction non-atomically (multiple memory accesses to
+ * a large and/or non aligned instruction) *if and only if* we have inserted a
+ * breakpoint at the beginning of the instruction and we are modifying the rest
+ * of the instruction.
  */
 void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 {
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
+	if (*((uint8_t *)addr - 1) != BREAKPOINT_INSTRUCTION) {
+		BUG_ON(len > sizeof(long));
+		BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
+			- ((long)addr & ~(sizeof(long) - 1)));
+	}
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
