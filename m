Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbYAONOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbYAONOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 08:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbYAONOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 08:14:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33117 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbYAONOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 08:14:03 -0500
Date: Tue, 15 Jan 2008 14:13:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: bugreport kernel panic on early stage, with HIGHMEM4G:
Message-ID: <20080115131340.GA6237@elte.hu>
References: <20080107053908.M5584@visp.net.lb> <20080115113947.GA14603@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115113947.GA14603@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> thanks for the detailed report, i think i know what's going on. Could 
> you try the patch below, does it fix your problem?

find below the fix with a more complete changelog and with no debugging 
printouts.

	Ingo

-------------->
Subject: x86: fix boot crash on HIGHMEM4G && SPARSEMEM
From: Ingo Molnar <mingo@elte.hu>

Denys Fedoryshchenko reported a bootup crash when he upgraded
his system from 3GB to 4GB RAM:

   http://lkml.org/lkml/2008/1/7/9

the bug is due to HIGHMEM4G && SPARSEMEM kernels making pfn_to_page() to 
return an invalid pointer when the pfn is in a memory hole. The 256 MB 
PCI aperture at the end of RAM was not mapped by sparsemem, and hence 
the pfn was not valid. But set_highmem_pages_init() iterated this range 
without checking the pfn's validity first - crashing the bootup.

this bug was probably present in the sparsemem code ever since sparsemem 
has been introduced in v2.6.13. It was masked due to HIGHMEM64G using 
larger memory regions in sparsemem_32.h:

 #ifdef CONFIG_X86_PAE
 #define SECTION_SIZE_BITS       30
 #define MAX_PHYSADDR_BITS       36
 #define MAX_PHYSMEM_BITS        36
 #else
 #define SECTION_SIZE_BITS       26
 #define MAX_PHYSADDR_BITS       32
 #define MAX_PHYSMEM_BITS        32
 #endif

which creates 1GB sparsemem regions instead of 64MB sparsemem regions. 
So in practice we only ever created true sparsemem holes on x86 with 
HIGHMEM4G - but that was rarely used by distros.

( btw., we could probably save 2MB of mem_map[]s on X86_PAE if we reduced
  the sparsemem region size to 256 MB. )

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init_32.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux/arch/x86/mm/init_32.c
===================================================================
--- linux.orig/arch/x86/mm/init_32.c
+++ linux/arch/x86/mm/init_32.c
@@ -321,8 +321,13 @@ extern void set_highmem_pages_init(int);
 static void __init set_highmem_pages_init(int bad_ppro)
 {
 	int pfn;
-	for (pfn = highstart_pfn; pfn < highend_pfn; pfn++)
-		add_one_highpage_init(pfn_to_page(pfn), pfn, bad_ppro);
+	for (pfn = highstart_pfn; pfn < highend_pfn; pfn++) {
+		/*
+		 * Holes under sparsemem might not have no mem_map[]:
+		 */
+		if (pfn_valid(pfn))
+			add_one_highpage_init(pfn_to_page(pfn), pfn, bad_ppro);
+	}
 	totalram_pages += totalhigh_pages;
 }
 #endif /* CONFIG_FLATMEM */
