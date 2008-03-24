Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbYCXRC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbYCXRC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 13:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbYCXRCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:02:48 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:40464 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516AbYCXRCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:02:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUHAO9650dMQWoK/2dsb2JhbACBW6YL
Date: Mon, 24 Mar 2008 13:02:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86 Fix text_poke for vmalloced pages
Message-ID: <20080324170243.GB14908@Krystal>
References: <20080320003908.GA4988@Krystal> <20080321093821.GG20420@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080321093821.GG20420@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:00:08 up 24 days, 10:11,  4 users,  load average: 0.63, 0.86,
	0.81
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
> > core_kernel_text() to make sure we only shadow map the core kernel 
> > text, not modules.
> > 
> > This is an incremental change to make the DEBUG_RODATA and text_poke 
> > play together nicely. A future step will be to make the module text 
> > read-only too, which will require changes to load module, module free 
> > and text_poke. The idea is to fix the current x86 git tree quickly.
> 
> > +	if (core_kernel_text((unsigned long)addr)) {
> >  		struct page *pages[2] = { virt_to_page(addr),
> >  			virt_to_page(addr + PAGE_SIZE) };
> >  		if (!pages[1])
> > @@ -522,6 +522,13 @@ void *__kprobes text_poke(void *addr, co
> >  		memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
> >  		local_irq_restore(flags);
> >  		vunmap(vaddr);
> > +	} else {
> > +		/*
> > +		 * modules are in vmalloc'ed memory, always writable.
> > +		 */
> > +		local_irq_save(flags);
> > +		memcpy(addr, opcode, len);
> > +		local_irq_restore(flags);
> 
> hm, this looks ugly, and the whole text_poke() function looks ugly. For 
> example why the extra code block + indentation here:
> 
> +void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
> +{
> +       unsigned long flags;
> +       char *vaddr;
> +       int nr_pages = 2;
> +
> +       BUG_ON(len > sizeof(long));
> +       BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
> +               - ((long)addr & ~(sizeof(long) - 1)));
> +       {
> +               struct page *pages[2] = { virt_to_page(addr),
> +                       virt_to_page(addr + PAGE_SIZE) };
> 

The extra indentation is there so we can declare
struct page *pages[2] = { };

Otherwise, we would be located after the BUG_ON lines and would have to
do the following, which takes extra lines...

  unsigned long flags;
  char *vaddr;
  int nr_pages = 2;
  struct page *pages[2];

  BUG_ONs...
  pages[0] = virt_to_page(addr);
  pages[1] = virt_to_page(addr + PAGE_SIZE);

but then extra indentation in the new text_poke is within a block
depending on a "if" statement, so it becomes less curbersome. But it all
goes away in the update below.


> also, more fundamentally - why not introduce a proper, generic "look up 
> kernel text struct page *" method, instead of open-coding various 
> assumptions about which kernel text is readonly and which isnt?
> 

I totally agree with you, that's the correct way to do it. And why
should we special-case the "kernel text is not read-only" case ?
Considering this is a slow path and that it would just potentially make
bugs harder to detect, I would simply consider _always_ doing a shadow
map to modify the kernel text. New patch attached.

Mathieu

> 	Ingo

x86 Fix text_poke for vmalloced pages

The shadow vmap for DEBUG_RODATA kernel text modification uses virt_to_page to
get the pages from the pointer address and vmalloc_to_page for vmalloc'ed
pages.

However, I think vmalloc_to_page would be required in case the page is used for
modules.

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
