Return-Path: <linux-kernel-owner+w=401wt.eu-S1752636AbZHaIqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbZHaIqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZHaIqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:46:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55569 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZHaIqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:46:19 -0400
Date: Mon, 31 Aug 2009 10:45:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/2] kmemleak: Inform kmemleak about kernel stack
	allocation
Message-ID: <20090831084546.GE15619@elte.hu>
References: <20090827165927.27901.97270.stgit@pc1117.cambridge.arm.com> <20090827170253.27901.33997.stgit@pc1117.cambridge.arm.com> <20090829132954.GB24123@elte.hu> <1251556083.5518.2.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251556083.5518.2.camel@pc1117.cambridge.arm.com>
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


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Sat, 2009-08-29 at 15:29 +0200, Ingo Molnar wrote:
> > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > 
> > > Traversing all the tasks in the system for scanning the kernel 
> > > stacks requires locking which increases the kernel latency 
> > > considerably. This patch informs kmemleak about newly allocated or 
> > > freed stacks so that they are treated as any other allocated 
> > > object. Subsequent patch will remove the explicit stack scanning 
> > > from mm/kmemleak.c.
> > > 
> > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: Ingo Molnar <mingo@redhat.com>
> > > ---
> > >  arch/x86/include/asm/thread_info.h |    7 ++++++-
> > >  arch/x86/kernel/process.c          |    2 ++
> > >  kernel/fork.c                      |    7 ++++++-
> > >  3 files changed, 14 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
> > > index fad7d40..f26432a 100644
> > > --- a/arch/x86/include/asm/thread_info.h
> > > +++ b/arch/x86/include/asm/thread_info.h
> > > @@ -162,7 +162,12 @@ struct thread_info {
> > >  #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
> > >  
> > >  #define alloc_thread_info(tsk)						\
> > > -	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
> > > +({									\
> > > +	struct thread_info *ti = (struct thread_info *)			\
> > > +		__get_free_pages(THREAD_FLAGS, THREAD_ORDER);		\
> > > +	kmemleak_alloc(ti, THREAD_SIZE, 1, THREAD_FLAGS);		\
> > > +	ti;								\
> > > +})
> > 
> > Sidenote:this used to be a trivial wrapper to gfp so it was 
> > borderline OK as a CPP macro - now it's a non-trivial CPP wrapper 
> > macro which is not OK. Mind converting it to an inline function?
> 
> I tried this first but got compilation errors in files that didn't 
> even call this function. To make it workable, thread_info.h would 
> need to include additional headers. If that's acceptable, I can 
> post an updated patch.

I havent tried the patch myself, but by your description those build 
problems seem to be pre-existing include file dependency problems 
that should be tracked down and resolved - instead of widening them 
by adding even more hidden dependencies via CPP macros.

	Ingo
