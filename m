Return-Path: <linux-kernel-owner+w=401wt.eu-S1761639AbYBOT72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639AbYBOT72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758424AbYBOT7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:59:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41369 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757527AbYBOT7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:59:16 -0500
Date: Fri, 15 Feb 2008 20:58:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi@firstfloor.org>
Subject: [patch 2/3] x86_64: CPA, fix cache attribute inconsistency bug,
	v2.6.23 backport
Message-ID: <20080215195854.GB15432@elte.hu>
References: <20080215195508.GA12405@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215195508.GA12405@elte.hu>
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


fix CPA cache attribute bug in v2.6.23. When phys_base is nonzero
(when CONFIG_RELOCATABLE=y) then change_page_attr_addr() miscalculates
the secondary alias address by -14 MB (depending on the configured
offset).

The default 64-bit kernels of Fedora and Ubuntu are affected:

   $ grep RELOCA /boot/config-2.6.23.9-85.fc8
     CONFIG_RELOCATABLE=y

   $ grep RELOC /boot/config-2.6.22-14-generic
     CONFIG_RELOCATABLE=y

and probably on many other distros as well.

the bug affects all pages in the first 40 MB of physical RAM that
are allocated by some subsystem that does ioremap_nocache() on them:

       if (__pa(address) < KERNEL_TEXT_SIZE) {

Hence we might leave page table entries with inconsistent cache
attributes around (pages mapped at both UnCacheable and Write-Back),
and we can also set the wrong kernel text pages to UnCacheable.

the effects of this bug can be random slowdowns and other misbehavior.
If for example AGP allocates its aperture pages into the first 40 MB
of physical RAM, then the -14 MB bug might mark random kernel texto
pages as uncacheable, slowing down a random portion of the 64-bit
kernel until the AGP driver is unloaded.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86_64/mm/pageattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-tmp/arch/x86_64/mm/pageattr.c
===================================================================
--- linux-tmp.orig/arch/x86_64/mm/pageattr.c
+++ linux-tmp/arch/x86_64/mm/pageattr.c
@@ -206,7 +206,7 @@ int change_page_attr_addr(unsigned long 
 		if (__pa(address) < KERNEL_TEXT_SIZE) {
 			unsigned long addr2;
 			pgprot_t prot2;
-			addr2 = __START_KERNEL_map + __pa(address);
+			addr2 = __START_KERNEL_map + __pa(address) - phys_base;
 			/* Make sure the kernel mappings stay executable */
 			prot2 = pte_pgprot(pte_mkexec(pfn_pte(0, prot)));
 			err = __change_page_attr(addr2, pfn, prot2,
