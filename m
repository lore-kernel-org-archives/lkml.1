Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbZDBQrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbZDBQrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765991AbZDBQqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:46:54 -0400
Received: from www.tglx.de ([62.245.132.106]:54246 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765963AbZDBQqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:46:53 -0400
Date: Thu, 2 Apr 2009 18:45:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Will Schmidt <will_schmidt@vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Subject: Re: [Announce] 2.6.29-rt2
In-Reply-To: <1238688145.8813.16.camel@lexx>
Message-ID: <alpine.LFD.2.00.0904021842050.12916@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>  <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>  <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain> 
 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>  <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>  <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>  <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain> 
 <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>  <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain>  <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain> <1238688145.8813.16.camel@lexx>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009, Will Schmidt wrote:

> On Thu, 2009-04-02 at 02:17 +0200, Thomas Gleixner wrote:
> > We are pleased to announce the next update to our new preempt-rt
> > series.
> > 
> >       - fix a fork/exit bug in the signal per task cache (/me puts on
> >         a huge brown paper bag - Thanks to Phillipe Reynes and Will
> >         Schmidt for reporting and testing)
> > 
> >       - fix a group scheduling migration accounting bug (decoded with
> >         and fixed by Peter Zijlstra - reported by Robin Gareus)
> > 
> >       - tlb gather rework by Peter Zijlstra - Thanks Peter !
> > 
> >       - the usual fixlets
> > 
> > The tlb rework might be incomplete on some of the uncountable
> > incarnations of PowerPC and ARM platforms, so look out for wreckage
> > and keep the usual tools (fire-extinguishers, brooms, buckets etc.)
> > handy.
> 
> I can confirm that the tlb rework does appear to be missing some parts
> for Power.  (Using 2.6.29-rt3 on pseries ppc64)
> 
> arch/powerpc/kernel/built-in.o:(.toc1+0x4d0): undefined reference to
> `per_cpu__ppc64_tlb_batch'
> <...>
> mm/built-in.o:(.toc1+0xed0): more undefined references to
> `per_cpu__ppc64_tlb_batch' follow
> 
> Not clear to me if this is just missing a "DEFINE_PER_CPU_LOCKED" to
> replace the removed "DEFINE_PER_CPU", (similar to the prior RT patches),
> or if the tlb rework is more involved.   So, I will patiently remain
> tuned in.  :-)

No, the DEFINE_PER_CPU was removed accidentaly. Should have stayed there

Thanks,

	tglx

--------

Index: linux-2.6-tip/arch/powerpc/mm/tlb_hash64.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/mm/tlb_hash64.c
+++ linux-2.6-tip/arch/powerpc/mm/tlb_hash64.c
@@ -32,6 +32,8 @@
 #include <asm/bug.h>
 #include <asm/machdep.h>
 
+DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
+
 /*
  * A linux PTE was changed and the corresponding hash table entry
  * neesd to be flushed. This function will either perform the flush
