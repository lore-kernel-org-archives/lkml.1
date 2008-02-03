Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbYBCVec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbYBCVec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 16:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYBCVeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 16:34:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33916 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbYBCVeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 16:34:05 -0500
Date: Sun, 3 Feb 2008 22:33:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Latest -git ioremap error
Message-ID: <20080203213353.GB27737@elte.hu>
References: <47A606B5.7090001@gmail.com> <47A608F8.5080206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A608F8.5080206@gmail.com>
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


* Kevin Winchester <kjwinchester@gmail.com> wrote:

> >     x86: fix ioremap RAM check
> > 
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Lucky first try - reverting this commit fixes the problem for me.  Any 
> ideas?

Could you check the patch below - does that too fix the problem for you?

	Ingo

----------------->
Subject: x86: relax RAM check in ioremap()
From: Ingo Molnar <mingo@elte.hu>

Kevin Winchester reported the loss of direct rendering, due to:

[    0.588184] agpgart: Detected AGP bridge 0
[    0.588184] agpgart: unable to get memory for graphics translation table.
[    0.588184] agpgart: agp_backend_initialize() failed.
[    0.588207] agpgart-amd64: probe of 0000:00:00.0 failed with error -12

and bisected it down to:

> commit 266b9f8727976769e2ed2dad77ac9295f37e321e
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Wed Jan 30 13:34:06 2008 +0100
>
>     x86: fix ioremap RAM check

this check was too strict and caused an ioremap() failure.

the problem is due to the somewhat unclean way of how the GART code
reserves a memory range for its aperture, and how it utilizes it
later on.

Allow RAM pages to be ioremap()-ed too, as long as they are reserved.

Bisected-by: Kevin Winchester <kjwinchester@gmail.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/ioremap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-x86.q/arch/x86/mm/ioremap.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/ioremap.c
+++ linux-x86.q/arch/x86/mm/ioremap.c
@@ -116,7 +116,7 @@ static void __iomem *__ioremap(unsigned 
 {
 	void __iomem *addr;
 	struct vm_struct *area;
-	unsigned long offset, last_addr;
+	unsigned long pfn, offset, last_addr;
 	pgprot_t prot;
 
 	/* Don't allow wraparound or zero size */
@@ -133,9 +133,9 @@ static void __iomem *__ioremap(unsigned 
 	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
-	for (offset = phys_addr >> PAGE_SHIFT; offset < max_pfn_mapped &&
-	     (offset << PAGE_SHIFT) < last_addr; offset++) {
-		if (page_is_ram(offset))
+	for (pfn = phys_addr >> PAGE_SHIFT; pfn < max_pfn_mapped &&
+	     (pfn << PAGE_SHIFT) < last_addr; pfn++) {
+		if (pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))
 			return NULL;
 	}
 
