Return-Path: <linux-kernel-owner+w=401wt.eu-S1759448AbYFYPgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448AbYFYPgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYFYPg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:36:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54504 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148AbYFYPg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:36:28 -0400
Date: Wed, 25 Jun 2008 17:36:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Merge setup_32/64.c into setup.c
Message-ID: <20080625153614.GB18796@elte.hu>
References: <200806242213.15310.yhlu.kernel@gmail.com> <200806242214.09503.yhlu.kernel@gmail.com> <200806250114.09858.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806250114.09858.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  arch/x86/kernel/Makefile   |    2 
>  arch/x86/kernel/setup.c    |  676 ++++++++++++++++++++++++++++++++++++++++++++-
>  arch/x86/kernel/setup_32.c |  543 ------------------------------------
>  arch/x86/kernel/setup_64.c |  381 -------------------------
>  include/asm-x86/setup.h    |    2 
>  5 files changed, 670 insertions(+), 934 deletions(-)

very nice!

could we please split this up into several, gradual steps that bring 
setup_32.c and setup_64.c to exactly the same content - where the final 
patch just renames arch/x86/kernel/setup_32.c to arch/x86/kernel/setup.c 
and deletes arch/x86/kernel/setup_64.c ?

it would still result in exactly the same end result - but is much more 
bisectable (and reviewable, etc.). A bit like how arch/x86/mm/ioremap.c 
or arch/x86/mm/pageattr.c was unified.

maybe it can be done in less than 10 patches - but it guess it should be 
rather something in the neighborhood of 20 patches. Changes like this:

-       /*
-        * NOTE: before this point _nobody_ is allowed to allocate
-        * any memory using the bootmem allocator.  Although the
-        * allocator is now initialised only the first 8Mb of the kernel
-        * virtual address space has been mapped.  All allocations before
-        * paging_init() has completed must use the alloc_bootmem_low_pages()
-        * variant (which allocates DMA'able memory) and care must be taken
-        * not to exceed the 8Mb limit.
-        */

should be in a separate patch - you removed this restriction from the 
x86 architecture via your earlier patches, so the removal of the comment 
comes from that (and deserves a separate commit), not purely from the 
mechanic unification in the end.

other changes like this:

-#ifdef CONFIG_X86_FIND_SMP_CONFIG
+#if defined(CONFIG_X86_FIND_SMP_CONFIG) && defined(CONFIG_X86_32) || \
+    defined(CONFIG_X86_MPPARSE) && defined(CONFIG_X86_64)

here you fix coding style:

-        /*
-         * Parse SRAT to discover nodes.
-         */
-        acpi_numa_init();
+       /*
+        * Parse SRAT to discover nodes.
+        */
+       acpi_numa_init();

etc. etc. You do a lot more very useful work than the plain single 
unification patch you sent tells us - all these changes should be split 
up.

[ and in the unlikely event of there being a bug somewhere in this 1600
  lines patch, a splitup is also useful for finding bugs :-) ]

	Ingo
