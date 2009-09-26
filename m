Return-Path: <linux-kernel-owner+w=401wt.eu-S1752371AbZIZSKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbZIZSKv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZIZSKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:10:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39566 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbZIZSKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:10:49 -0400
Date: Sat, 26 Sep 2009 20:10:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Fix hwpoison code related build failure on 32-bit
	NUMAQ
Message-ID: <20090926181037.GA4666@elte.hu>
References: <20090916125116.GA12751@basil.fritz.box> <20090926141352.GA26117@elte.hu> <20090926151740.GN30185@one.firstfloor.org> <alpine.LFD.2.01.0909260930410.3303@localhost.localdomain> <20090926173522.GA22723@elte.hu> <alpine.LFD.2.01.0909261038510.3303@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0909261038510.3303@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 26 Sep 2009, Ingo Molnar wrote:
> > >  
> > > +config X86_SUPPORTS_MEMORY_FAILURE
> > > +	bool
> > > +	depends on !X86_NUMAQ
> > > +	select ARCH_SUPPORTS_MEMORY_FAILURE
> > > +	default y
> > 
> > Thanks Linus, this patch fixed the NUMAQ build problem.
> 
> I think it's slightly buggy still.
> 
> I think the X86_SUPPORTS_MEMORY_FAILURE thing should also have a
> 
> 	depends on X86_MCE
> 
> line, because we still depend on MCE.

Yeah.

( Note, it should not necessarily depend on it: while the only hw 
  mechanism that calls memory_failure() is indeed MCE, the act of having 
  a memory-failures subsystem does not depend on the presence of an x86 
  MCE subsystem. There's for example the injection debug-code which 
  allows the injection of memory_failure() calls. That should work fine 
  without having MCE build in as well.

  But that is a separate change. )

> And as you found out, there's also the sparsemem thing.
> 
> Don't make it one huge ugly thing, just split out the requirements like
> 
> 	depends on X86_MCE
> 	depends on !X86_NUMAQ
> 	depends on X86_64 || !SPARSEMEM
> 
> because I think the requirements are fairly independent, and it makes 
> it easier to read (you could even comment each line on why _that_ 
> particular issue needs to disable X86_SUPPORTS_MEMORY_FAILURE)

Good idea, have done that too.

> But yeah, with that, and some testing, please add my sign-off (or 
> acked-by, if you end up changing the patch so much that it has little 
> to do with my original one)

It's still mostly your patch so i've added your SOB, thanks. Below is 
the updated patch.

btw., i think mm/memory-failure.c needs similar cleanups to 
ARCH_SUPPORTS_MEMORY_FAILURE.

Right now it is full of x86 details, not sure that is right. 'MCE' for 
example is an x86 expression and goes way beyond just memory errors - it 
stands for 'Machine Check Exception' and covers IO/bus errors, etc.

We even put 'MCE' into new ABI details in include/asm-generic/siginfo.h:

/* hardware memory error consumed on a machine check: action required */
#define BUS_MCEERR_AR   (__SI_FAULT|4)
/* hardware memory error detected in process but not consumed: action optional*/
#define BUS_MCEERR_AO   (__SI_FAULT|5)
#define NSIGBUS         5

That should be fixed to be something like:

	 BUS_MEMERR_MANDATORY
	 BUS_MEMERR_OPTIONAL

before such a kernel is released, IMHO.

In mm/memory-failure.c i find the 'ao' / 'ar' abbreviations rather 
unreadable as well - they are totally meaningless (to me at least),
even if i know the code.

Same goes for the me_*() prefixes.

Also, 'struct to_kill' ....

	Ingo
