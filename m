Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbYCLPy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbYCLPy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 11:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYCLPyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 11:54:21 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:59083 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914AbYCLPyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 11:54:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqoEABKa10dMQWoK/2dsb2JhbACBWaZS
Date: Wed, 12 Mar 2008 11:54:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org
Subject: Re: [PATCH] x86 Fix test_poke for vmalloced pages
Message-ID: <20080312155415.GA11230@Krystal>
References: <20080310183653.GA4482@Krystal> <20080311090947.GG25110@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080311090947.GG25110@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:45:20 up 12 days, 11:56,  7 users,  load average: 0.26, 0.64,
	0.65
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > The shadow vmap for DEBUG_RODATA kernel text modification uses 
> > virt_to_page to get the pages from the pointer address.
> > 
> > However, I think vmalloc_to_page would be required in case the page is 
> > used for modules.
> > 
> > Since only the core kernel text is marked read-only, use 
> > kernel_text_address() to make sure we only shadow map the core kernel 
> > text, not modules.
> 
> actually, i think we should mark module text readonly too.
> 

Yes, but in the meantime, the x86 tree would need this patch to make
kprobes work correctly on modules.

I suspect that without this fix, with the enhanced hotplug and kprobes
patch, kprobes will use text_poke to insert breakpoints in modules
(vmalloced pages used), which will map the wrong pages and corrupt
random kernel locations instead of updating the correct page.

Work that would write protect the module pages should clearly be done,
but it can come in a later time. We have to make sure we interact
correctly with the page allocation debugging, as an example.

Here is the patch against x86.git 2.6.25-rc5 :

The shadow vmap for DEBUG_RODATA kernel text modification uses virt_to_page to
get the pages from the pointer address.

However, I think vmalloc_to_page would be required in case the page is used for
modules.

Since only the core kernel text is marked read-only, use kernel_text_address()
to make sure we only shadow map the core kernel text, not modules.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
CC: akpm@linux-foundation.org
---
 arch/x86/kernel/alternative.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6-x86/arch/x86/kernel/alternative.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/alternative.c	2008-03-10 10:34:11.000000000 -0400
+++ linux-2.6-x86/arch/x86/kernel/alternative.c	2008-03-10 10:50:38.000000000 -0400
@@ -511,7 +511,7 @@
 	BUG_ON(len > sizeof(long));
 	BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
 		- ((long)addr & ~(sizeof(long) - 1)));
-	{
+	if (kernel_text_address((unsigned long)addr)) {
 		struct page *pages[2] = { virt_to_page(addr),
 			virt_to_page(addr + PAGE_SIZE) };
 		if (!pages[1])
@@ -522,6 +522,13 @@
 		memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
 		local_irq_restore(flags);
 		vunmap(vaddr);
+	} else {
+		/*
+		 * modules are in vmalloc'ed memory, always writable.
+		 */
+		local_irq_save(flags);
+		memcpy(addr, opcode, len);
+		local_irq_restore(flags);
 	}
 	sync_core();
 	/* Could also do a CLFLUSH here to speed up CPU recovery; but


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
