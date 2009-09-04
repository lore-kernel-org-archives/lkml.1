Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbZIDG6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbZIDG6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 02:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbZIDG6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 02:58:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41150 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460AbZIDG6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:58:15 -0400
Date: Fri, 4 Sep 2009 08:57:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/2] kmemleak: Inform kmemleak about kernel stack
	allocation
Message-ID: <20090904065745.GE29829@elte.hu>
References: <20090827165927.27901.97270.stgit@pc1117.cambridge.arm.com> <20090827170253.27901.33997.stgit@pc1117.cambridge.arm.com> <20090829132954.GB24123@elte.hu> <1251556083.5518.2.camel@pc1117.cambridge.arm.com> <20090831084546.GE15619@elte.hu> <1251797114.10349.28.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251797114.10349.28.camel@pc1117.cambridge.arm.com>
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

> On Mon, 2009-08-31 at 10:45 +0200, Ingo Molnar wrote:
> > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > 
> > > On Sat, 2009-08-29 at 15:29 +0200, Ingo Molnar wrote:
> > > > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> [...]
> > > > > diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
> > > > > index fad7d40..f26432a 100644
> > > > > --- a/arch/x86/include/asm/thread_info.h
> > > > > +++ b/arch/x86/include/asm/thread_info.h
> > > > > @@ -162,7 +162,12 @@ struct thread_info {
> > > > >  #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
> > > > >  
> > > > >  #define alloc_thread_info(tsk)						\
> > > > > -	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
> > > > > +({									\
> > > > > +	struct thread_info *ti = (struct thread_info *)			\
> > > > > +		__get_free_pages(THREAD_FLAGS, THREAD_ORDER);		\
> > > > > +	kmemleak_alloc(ti, THREAD_SIZE, 1, THREAD_FLAGS);		\
> > > > > +	ti;								\
> > > > > +})
> > > > 
> > > > Sidenote:this used to be a trivial wrapper to gfp so it was 
> > > > borderline OK as a CPP macro - now it's a non-trivial CPP wrapper 
> > > > macro which is not OK. Mind converting it to an inline function?
> > > 
> > > I tried this first but got compilation errors in files that didn't 
> > > even call this function. To make it workable, thread_info.h would 
> > > need to include additional headers. If that's acceptable, I can 
> > > post an updated patch.
> > 
> > I havent tried the patch myself, but by your description those build 
> > problems seem to be pre-existing include file dependency problems 
> > that should be tracked down and resolved - instead of widening them 
> > by adding even more hidden dependencies via CPP macros.
> 
> I tried to move to an inline function and linux/gfp.h is needed for
> __get_free_pages() and GFP_* macros. This leads to some complicated
> circular dependencies like below:
> 
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from /work/Linux/2.6/linux-2.6-arm/include/linux/mmzone.h:9,
>                  from /work/Linux/2.6/linux-2.6-arm/include/linux/gfp.h:4,
>                  from /work/Linux/2.6/linux-2.6-arm/arch/x86/include/asm/thread_info.h:22,
>                  from /work/Linux/2.6/linux-2.6-arm/include/linux/thread_info.h:56,
>                  from /work/Linux/2.6/linux-2.6-arm/include/linux/preempt.h:9,
>                  from /work/Linux/2.6/linux-2.6-arm/include/linux/spinlock.h:50,
>                  from /work/Linux/2.6/linux-2.6-arm/include/linux/seqlock.h:29,
>                  from /work/Linux/2.6/linux-2.6-arm/include/linux/time.h:8,
>                  from /work/Linux/2.6/linux-2.6-arm/include/linux/stat.h:60,
>                  from /work/Linux/2.6/linux-2.6-arm/include/linux/module.h:10,
>                  from /work/Linux/2.6/linux-2.6-arm/include/linux/crypto.h:21,
>                  from /work/Linux/2.6/linux-2.6-arm/arch/x86/kernel/asm-offsets_32.c:7,
>                  from /work/Linux/2.6/linux-2.6-arm/arch/x86/kernel/asm-offsets.c:2:
> include/linux/wait.h|51| error: expected specifier-qualifier-list before ???spinlock_t???
> 
> The linux/mmzone.h file normally includes linux/spinlock.h but the 
> reverse is also true when the latter includes the former via 
> thread_info.h and gfp.h. Because of the (correct) guards in the 
> header files, the spinlock_t definition is no longer available in 
> mmzone.h.

mmzone.h probably should not include spinlock.h (which is heavy) - 
it should include spinlock_types.h (which is lighter). It only needs 
the type definitions and none of the API definitions.

	Ingo
