Return-Path: <linux-kernel-owner+w=401wt.eu-S1760039AbYB1NYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbYB1NYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 08:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757122AbYB1NYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 08:24:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53529 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756304AbYB1NYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 08:24:22 -0500
Date: Thu, 28 Feb 2008 14:24:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: x86: potential ioremap() issues
Message-ID: <20080228132404.GB18551@elte.hu>
References: <47C6BE37.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47C6BE37.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> Ingo,
> 
> with the new ioremap() implementation I see a couple of (potential)
> issues:
> - When ioremap_page_range() fails, remove_vm_area() is used rather
>   than vunmap() - I think this will cause a 'struct vm_struct' leak.

indeed, good catch - could you check whether the patch below fixes this? 
I also pushed this out into x86.git#testing, which you can pick up via:

       http://people.redhat.com/mingo/x86.git/README

> - While ioremap() continues to happily map RAM pages (with a bogus
>   [see below] WARN_ON_ONCE()), cacheability of the memory is not
>   being restored in iounmap().

correct - these are never supposed to be 'true', generally allocated RAM 
pages - or like we do with AGP where the pages are exclusively owned we 
restore their cacheability explicitly.

> - The check for RAM pages (except for the WARN_ON_ONCE())
>   continues to be applied only to lowmem pages.

yes, the biggest constraint from ioremap comes when it applies to pages 
that are mapped by the kernel. But i guess we could extend this to all 
things RAM ... the second patch below does this. What do you think? I've 
queued this up in x86.git#testing as well.

> - The WARN_ON_ONCE() itself is applied to the pfn after the
>   preceding loop finished, i.e. to a pfn that doesn't actually participate
>   in the operation. Shouldn't it be moved inside the loop?

i removed the WARN_ON_ONCE() from x86.git a few days ago, it's lined up 
for the next push.

	Ingo

--------------------->
Subject: x86: fix leak un ioremap_page_range() failure
From: Ingo Molnar <mingo@elte.hu>
Date: Thu Feb 28 14:02:08 CET 2008

Jan Beulich noticed that if a driver's ioremap() fails (say due to -ENOMEM)
then we might leak the struct vm_area - free it properly.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/ioremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/mm/ioremap.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/ioremap.c
+++ linux-x86.q/arch/x86/mm/ioremap.c
@@ -179,7 +179,7 @@ static void __iomem *__ioremap(unsigned 
 	area->phys_addr = phys_addr;
 	vaddr = (unsigned long) area->addr;
 	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot)) {
-		remove_vm_area((void *)(vaddr & PAGE_MASK));
+		free_vm_area(area);
 		return NULL;
 	}

-------------------> 
Subject: x86: ioremap(), extend check to all RAM pages
From: Ingo Molnar <mingo@elte.hu>
Date: Thu Feb 28 14:10:49 CET 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/ioremap.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-x86.q/arch/x86/mm/ioremap.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/ioremap.c
+++ linux-x86.q/arch/x86/mm/ioremap.c
@@ -146,8 +146,9 @@ static void __iomem *__ioremap(unsigned 
 	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
-	for (pfn = phys_addr >> PAGE_SHIFT; pfn < max_pfn_mapped &&
-	     (pfn << PAGE_SHIFT) < last_addr; pfn++) {
+	for (pfn = phys_addr >> PAGE_SHIFT;
+				(pfn << PAGE_SHIFT) < last_addr; pfn++) {
+
 		if (page_is_ram(pfn) && pfn_valid(pfn) &&
 		    !PageReserved(pfn_to_page(pfn)))
 			return NULL;
