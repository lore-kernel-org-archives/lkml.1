Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYAICLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYAICLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 21:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYAICL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 21:11:28 -0500
Received: from mx1.suse.de ([195.135.220.2]:44448 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbYAICL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 21:11:27 -0500
Date: Wed, 9 Jan 2008 03:11:24 +0100
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
Message-ID: <20080109021124.GH25945@bingen.suse.de>
References: <20080109002014.GB31289@elte.hu> <20080109002803.GA3732@elte.hu> <20080109003034.GA4658@elte.hu> <47841B09.3020507@goop.org> <20080109005914.GA24228@elte.hu> <47841E3C.9020106@goop.org> <20080109011233.GD25945@bingen.suse.de> <478424DE.3030609@goop.org> <20080109014233.GG25945@bingen.suse.de> <478429DE.1090901@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478429DE.1090901@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

-Andi

Here was Jan's patch; it incidently fixes the G problem too

snip

Additionally I found it necessary to fix ioremap_64.c's use of
change_page_attr_addr():

--- a/arch/x86/mm/ioremap_64.c
+++ b/arch/x86/mm/ioremap_64.c
@@ -48,7 +48,7 @@ ioremap_change_attr(unsigned long phys_a
  		 * Must use a address here and not struct page because the phys addr
 		 * can be a in hole between nodes and not have an memmap entry.
 		 */
-		err = change_page_attr_addr(vaddr,npages,__pgprot(__PAGE_KERNEL|flags));
+		err = change_page_attr_addr(vaddr,npages,MAKE_GLOBAL(__PAGE_KERNEL|flags));
 		if (!err)
 			global_flush_tlb();
 	}
@@ -199,7 +199,7 @@ void iounmap(volatile void __iomem *addr
 
 	/* Reset the direct mapping. Can block */
 	if (p->flags >> 20)
-		ioremap_change_attr(p->phys_addr, p->size, 0);
+		ioremap_change_attr(p->phys_addr, get_vm_area_size(p), 0);
 
 	/* Finally remove it */
 	o = remove_vm_area((void *)addr);

Other extra changes I had in my version could possibly be counted as enhancements...

Jan
