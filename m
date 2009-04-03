Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbZDCJnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbZDCJnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 05:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762250AbZDCJma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 05:42:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:56368 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762245AbZDCJm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 05:42:28 -0400
Subject: Re: [Announce] 2.6.29-rt2
From: Peter Zijlstra <peterz@infradead.org>
To: will_schmidt@vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
In-Reply-To: <1238693053.8813.27.camel@lexx>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>
	 <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain>
	 <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain>
	 <1238688145.8813.16.camel@lexx>
	 <alpine.LFD.2.00.0904021842050.12916@localhost.localdomain>
	 <1238693053.8813.27.camel@lexx>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 03 Apr 2009 11:43:13 +0200
Message-Id: <1238751793.798.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 12:24 -0500, Will Schmidt wrote:

> > --------
> > 
> > Index: linux-2.6-tip/arch/powerpc/mm/tlb_hash64.c
> > ===================================================================
> > --- linux-2.6-tip.orig/arch/powerpc/mm/tlb_hash64.c
> > +++ linux-2.6-tip/arch/powerpc/mm/tlb_hash64.c
> > @@ -32,6 +32,8 @@
> >  #include <asm/bug.h>
> >  #include <asm/machdep.h>
> > 
> > +DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
> > +
> >  /*
> >   * A linux PTE was changed and the corresponding hash table entry
> >   * neesd to be flushed. This function will either perform the flush

Will, could you see if the below makes your splat go away?

diff --git a/arch/powerpc/include/asm/tlb.h b/arch/powerpc/include/asm/tlb.h
index ec82dac..3ddc8f6 100644
--- a/arch/powerpc/include/asm/tlb.h
+++ b/arch/powerpc/include/asm/tlb.h
@@ -38,6 +38,8 @@ struct arch_mmu_gather {
 	struct pte_freelist_batch *batch;
 };
 
+#define ARCH_MMU_GATHER_INIT (struct arch_mmu_gather){ .batch = NULL, }
+
 #if !defined(CONFIG_PPC_STD_MMU)
 
 #define tlb_flush(tlb)			flush_tlb_mm((tlb)->mm)
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 7f2167e..50a09de 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -71,6 +71,10 @@ tlb_gather_mmu(struct mmu_gather *tlb, struct mm_struct *mm, unsigned int full_m
 		tlb->nr = ~0U;
 
 	tlb->fullmm = full_mm_flush;
+
+#ifdef HAVE_ARCH_MMU_GATHER
+	tlb->arch = ARCH_MMU_GATHER_INIT;
+#endif
 }
 
 static inline void

