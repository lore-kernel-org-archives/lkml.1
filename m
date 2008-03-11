Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbYCKUVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbYCKUVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYCKUU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:20:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:49160 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbYCKUU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:20:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,482,1199692800"; 
   d="scan'208";a="261959702"
Date: Tue, 11 Mar 2008 13:19:22 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 1/2] x86, fpu: split FPU state from task struct - v5
Message-ID: <20080311201921.GE15909@linux-os.sc.intel.com>
References: <20080310222955.565902000@linux-os.sc.intel.com> <20080311050644.GB4589@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311050644.GB4589@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 08:07:34AM +0300, Alexey Dobriyan wrote:
> On Mon, Mar 10, 2008 at 03:28:04PM -0700, Suresh Siddha wrote:
> > Split the FPU save area from the task struct. This allows easy migration
> > of FPU context, and it's generally cleaner. It also allows the following
> > two optimizations:
> > 
> > 1) only allocate when the application actually uses FPU, so in the first
> > lazy FPU trap. This could save memory for non-fpu using apps. Next patch
> > does this lazy allocation.
> > 
> > 2) allocate the right size for the actual cpu rather than 512 bytes always.
> > Patches enabling xsave/xrstor support (coming shortly) will take advantage
> > of this.
> 
> Ugh, not seeing patch, but judging from description it will make
> "choose wrong CONFIG_M* and fxsave will corrupt random FPU state" situation
> likely?

No. CONFIG_M* doesn't determine the size of the state. Feature information from
the 'cpuid' instruction will dictate the size allocated/used. Anyhow, please
wait for the xsave patches.

> 
> > --- linux-2.6-x86.orig/arch/x86/kernel/process_64.c
> > +++ linux-2.6-x86/arch/x86/kernel/process_64.c
> > @@ -634,7 +634,7 @@
> >  
> >  	/* we're going to use this soon, after a few expensive things */
> >  	if (next_p->fpu_counter>5)
> > -		prefetch(&next->i387.fxsave);
> > +		prefetch(next->xstate);
> 
> Can we please give it better name, like fpu_state? It's a member of
> task_struct after all.

It need not be only FPU. We can have non-math state here aswell.

selected 'xstate' for extended state. I am all open for any reasonable name,
reflecting math, extended math(fsave/fxsave/..) and future math/
non-math extensions.

> >  {
> >  	unsigned long oldcr0 = read_cr0();
> > -	extern void __bad_fxsave_alignment(void);
> > -
> > -	if (offsetof(struct task_struct, thread.i387.fxsave) & 15)
> > -		__bad_fxsave_alignment();
> 
> I think removal of such checks needs giving necessary alignment to cache.
> Previously it worked because of __aligned((16)) and L1_CACHE_SHIFT
> combo.

alignment is now specified as part of kmem_cache_create() and checed
in the allocation routines.

thanks,
suresh
