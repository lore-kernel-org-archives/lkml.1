Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbZBYMst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbZBYMst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 07:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZBYMsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 07:48:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57915 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbZBYMsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 07:48:39 -0500
Date: Wed, 25 Feb 2009 13:47:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       steiner@sgi.com
Subject: Re: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single
	ipi fallback for smp_call_function_many())
Message-ID: <20090225124748.GC26273@elte.hu>
References: <1234923702.29823.7.camel@vayu> <20090218135945.GC23125@wotan.suse.de> <1234982620.29823.22.camel@vayu> <20090218191757.GD8889@elte.hu> <1235001314.14523.2.camel@vayu> <20090219122031.GC1703@elte.hu> <1235080824.14523.19.camel@vayu> <20090220105640.GE28581@elte.hu> <1235156214.14523.54.camel@vayu> <20090225033230.GA4611@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225033230.GA4611@wotan.suse.de>
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


* Nick Piggin <npiggin@suse.de> wrote:

> On Fri, Feb 20, 2009 at 10:56:54AM -0800, Suresh B wrote:
> > On Fri, 2009-02-20 at 02:56 -0800, Ingo Molnar wrote:
> > > * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > > 
> > > > On Thu, 2009-02-19 at 04:20 -0800, Ingo Molnar wrote:
> > > > > Could you please refresh this patch to latest tip:master? The 
> > > > > APIC drivers moved to arch/x86/kernel/apic/.
> > > > 
> > > > Appended the refreshed patch. Thanks.
> > > 
> > > thanks. Two details i noticed:
> > > 
> > > Firstly:
> > > 
> > > > +++ b/arch/x86/kernel/apic/x2apic_cluster.c
> > > > +++ b/arch/x86/kernel/apic/x2apic_phys.c
> > > 
> > > how about x2apic_uv.c? It uses uv_write_global_mmr64() in its 
> > > IPI sending method, which uses:
> > > 
> > > static inline void uv_write_global_mmr64(int pnode, unsigned long offset,
> > >                                 unsigned long val)
> > > {
> > >         *uv_global_mmr64_address(pnode, offset) = val;
> > > }
> > > 
> > > which uses ->mmr_base, which is mapped via:
> > > 
> > >         init_extra_mapping_uc(UV_LOCAL_MMR_BASE, UV_LOCAL_MMR_SIZE);
> > >
> > > so it should be fine because uncached - but at minimum we should 
> > > put a comment into x2apic_uv.c that the generic IPI code relies 
> > > on the lowlevel code serializing - i.e. relies on the UC PAT 
> > > attribute.
> > 
> > Oops. I forgot to mention that and copy Jack to confirm our
> > understanding. I can send a followup patch adding the comments for UV.
> > Jack, are you ok?
> > 
> > > 
> > > Secondly, you added smp_mb(), which will translate to an MFENCE. 
> > > 
> > > But in theory it should be enough to have a wmb() here. [Note, 
> > > not an smp_wmb() that i suggested before.] That will translate 
> > > to an SFENCE - which will serialize writes but still allows 
> > > reads/prefetches to pass.
> > > 
> > > So the question is, is an SFENCE there enough to serialize the 
> > > WRMSR with previous memory-writes? It's not specified in the 
> > > x2apic docs as far as i could see.
> > 
> > No. sfence is not enough (wrmsr to x2apic regs was still passing ahead).
> > We have done a small experiment to demonstrate the issue and adding
> > mfence fixes the issue but not sfence. We need a serializing instruction
> > or mfence. I will try to get the SDM updated.
> 
> Just if I may add something -- I would probably slightly 
> prefer if you explicitly used an sfence or other serializing 
> instruction rather than smp_mb(). Maybe call it wrmsr_fence() 
> or something. Apart from being self documenting, and less 
> confusing (wrmsr is not part of normal ordering), I assume you 
> technically also need it on UP systems?

Hm, UP systems shouldnt worry too much about sending IPIs to 
other CPUs, right? We optimize out same-CPU IPIs already so that 
bit should not matter.

Agreed on the self-documentation aspect.

	Ingo
