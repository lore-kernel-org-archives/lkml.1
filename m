Return-Path: <linux-kernel-owner+w=401wt.eu-S1760630AbZBMO1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630AbZBMO1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758495AbZBMO1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:27:16 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:44888 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758094AbZBMO1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:27:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah0FAJ8MlUlMQWt2/2dsb2JhbACBbtEkhBgG
Date: Fri, 13 Feb 2009 09:27:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: text_poke might sleep
Message-ID: <20090213142705.GC31922@Krystal>
References: <1234529407.6519.28.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1234529407.6519.28.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:25:24 up 43 days, 14:23,  4 users,  load average: 0.28, 0.29,
	0.26
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:

> Now text_poke() uses local_irq_save/restore(), which conveys that it can
> be called with IRQs disabled, which is exactly what happens in the trace
> above, however we just established that vmap/vunmap() are not irq-safe.
> 
> Anybody got an idea on how to fix this?

Add might_sleep(), comments and use local_irq_disable/enable in text_poke so
people are really aware that it uses vmap, which sleeps.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Nick Piggin <npiggin@suse.de>
CC: akpm <akpm@linux-foundation.org>
---
 arch/x86/kernel/alternative.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-lttng/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/alternative.c	2009-02-13 09:02:20.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/alternative.c	2009-02-13 09:05:05.000000000 -0500
@@ -494,16 +494,16 @@ void *text_poke_early(void *addr, const 
  * Only atomic text poke/set should be allowed when not doing early patching.
  * It means the size must be writable atomically and the address must be aligned
  * in a way that permits an atomic write. It also makes sure we fit on a single
- * page.
+ * page. Should be called with preemption enabled.
  */
 void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 {
-	unsigned long flags;
 	char *vaddr;
 	int nr_pages = 2;
 	struct page *pages[2];
 	int i;
 
+	might_sleep();
 	if (!core_kernel_text((unsigned long)addr)) {
 		pages[0] = vmalloc_to_page(addr);
 		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
@@ -517,9 +517,9 @@ void *__kprobes text_poke(void *addr, co
 		nr_pages = 1;
 	vaddr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
 	BUG_ON(!vaddr);
-	local_irq_save(flags);
+	local_irq_disable();
 	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
-	local_irq_restore(flags);
+	local_irq_enable();
 	vunmap(vaddr);
 	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
