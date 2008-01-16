Return-Path: <linux-kernel-owner+w=401wt.eu-S1758658AbYAPH0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbYAPH0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 02:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbYAPH0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 02:26:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57457 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbYAPH0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 02:26:14 -0500
Date: Wed, 16 Jan 2008 08:25:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0 of 4] x86: some more patches
Message-ID: <20080116072559.GC30950@elte.hu>
References: <patchbomb.1200435425@localhost> <20080115223534.GA20484@elte.hu> <478D4197.8060904@goop.org> <200801160144.33140.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801160144.33140.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> [...] I found that Jan's ioremap fix also causes silent hangs here 
> during earlier bisecting (not sure why)

please send a fuller bugreport - all these problems on your testbox 
might be interrelated. Jan's patch is undone in a later part of the 
series so it's a bisection artifact. I've fixed that up.

	Ingo

------------------->
Subject: x86: fix 64-bit ioremap()
From: From: Jan Beulich <jbeulich@novell.com>

> Yeah, that may be true, but this particular tree is weird, and I'm trying
> to understand what's going on here.  Specifically, 64-bit ioremap()s
> *don't* set _PAGE_GLOBAL, which appears to be an accident resulting from
> the strange definitions of __PAGE_KERNEL_* vs PAGE_KERNEL_*.

ioremap() should set G agreed.

> For example, ioremap_64.c:__ioremap() creates a vma for the io mapping, and
> explicitly sets _PAGE_GLOBAL in the vma's version of pgprot - but then it
> calls ioremap_page_range() to actually create the mapping, which ends up
> making a non-global mapping, because its rolling its own version of
> PAGE_KERNEL by using pgprot(__PAGE_KERNEL) - which is not the actual
> definition of PAGE_KERNEL.

That should not really matter because ioremap_change_attr()->c_p_a is only called
when flags is != 0 and that means it is already different from PAGE_KERNEL.

>
> I think there's a bug around here, but I think its currently being hidden

There's one Jan pointed out: iounmap does not subtract the guard page size
so it ends up resetting one page too much. That is probably what causes your
problem. But again you should be passing in G in the first place.

Additionally I found it necessary to fix ioremap_64.c's use of
change_page_attr_addr():

[ mingo@elte.hu: fixed coding style errors ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/ioremap_64.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-x86.q/arch/x86/mm/ioremap_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/ioremap_64.c
+++ linux-x86.q/arch/x86/mm/ioremap_64.c
@@ -45,10 +45,12 @@ ioremap_change_attr(unsigned long phys_a
 		unsigned long vaddr = (unsigned long) __va(phys_addr);
 
 		/*
- 		 * Must use a address here and not struct page because the phys addr
-		 * can be a in hole between nodes and not have an memmap entry.
+		 * Must use an address here and not struct page because the
+		 * phys addr can be a in hole between nodes and not have an
+		 * memmap entry:
 		 */
-		err = change_page_attr_addr(vaddr,npages,__pgprot(__PAGE_KERNEL|flags));
+		err = change_page_attr_addr(vaddr, npages,
+					    MAKE_GLOBAL(__PAGE_KERNEL|flags));
 		if (!err)
 			global_flush_tlb();
 	}
@@ -181,7 +183,7 @@ void iounmap(volatile void __iomem *addr
 
 	/* Reset the direct mapping. Can block */
 	if (p->flags >> 20)
-		ioremap_change_attr(p->phys_addr, p->size, 0);
+		ioremap_change_attr(p->phys_addr, get_vm_area_size(p), 0);
 
 	/* Finally remove it */
 	o = remove_vm_area((void *)addr);
