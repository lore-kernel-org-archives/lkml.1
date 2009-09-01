Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbZIAJ0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbZIAJ0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 05:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZIAJ0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 05:26:46 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:49750 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105AbZIAJ0q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 05:26:46 -0400
Subject: Re: [PATCH 1/2] kmemleak: Inform kmemleak about kernel stack
	allocation
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20090831084546.GE15619@elte.hu>
References: <20090827165927.27901.97270.stgit@pc1117.cambridge.arm.com>
	 <20090827170253.27901.33997.stgit@pc1117.cambridge.arm.com>
	 <20090829132954.GB24123@elte.hu>
	 <1251556083.5518.2.camel@pc1117.cambridge.arm.com>
	 <20090831084546.GE15619@elte.hu>
Content-Type: text/plain; charset=utf-8
Organization: ARM Ltd
Date: Tue, 01 Sep 2009 10:25:14 +0100
Message-Id: <1251797114.10349.28.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 01 Sep 2009 09:25:15.0454 (UTC) FILETIME=[1D3815E0:01CA2AE6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-31 at 10:45 +0200, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > On Sat, 2009-08-29 at 15:29 +0200, Ingo Molnar wrote:
> > > * Catalin Marinas <catalin.marinas@arm.com> wrote:
[...]
> > > > diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
> > > > index fad7d40..f26432a 100644
> > > > --- a/arch/x86/include/asm/thread_info.h
> > > > +++ b/arch/x86/include/asm/thread_info.h
> > > > @@ -162,7 +162,12 @@ struct thread_info {
> > > >  #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
> > > >  
> > > >  #define alloc_thread_info(tsk)						\
> > > > -	((struct thread_info *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER))
> > > > +({									\
> > > > +	struct thread_info *ti = (struct thread_info *)			\
> > > > +		__get_free_pages(THREAD_FLAGS, THREAD_ORDER);		\
> > > > +	kmemleak_alloc(ti, THREAD_SIZE, 1, THREAD_FLAGS);		\
> > > > +	ti;								\
> > > > +})
> > > 
> > > Sidenote:this used to be a trivial wrapper to gfp so it was 
> > > borderline OK as a CPP macro - now it's a non-trivial CPP wrapper 
> > > macro which is not OK. Mind converting it to an inline function?
> > 
> > I tried this first but got compilation errors in files that didn't 
> > even call this function. To make it workable, thread_info.h would 
> > need to include additional headers. If that's acceptable, I can 
> > post an updated patch.
> 
> I havent tried the patch myself, but by your description those build 
> problems seem to be pre-existing include file dependency problems 
> that should be tracked down and resolved - instead of widening them 
> by adding even more hidden dependencies via CPP macros.

I tried to move to an inline function and linux/gfp.h is needed for
__get_free_pages() and GFP_* macros. This leads to some complicated
circular dependencies like below:

  CC      arch/x86/kernel/asm-offsets.s
In file included from /work/Linux/2.6/linux-2.6-arm/include/linux/mmzone.h:9,
                 from /work/Linux/2.6/linux-2.6-arm/include/linux/gfp.h:4,
                 from /work/Linux/2.6/linux-2.6-arm/arch/x86/include/asm/thread_info.h:22,
                 from /work/Linux/2.6/linux-2.6-arm/include/linux/thread_info.h:56,
                 from /work/Linux/2.6/linux-2.6-arm/include/linux/preempt.h:9,
                 from /work/Linux/2.6/linux-2.6-arm/include/linux/spinlock.h:50,
                 from /work/Linux/2.6/linux-2.6-arm/include/linux/seqlock.h:29,
                 from /work/Linux/2.6/linux-2.6-arm/include/linux/time.h:8,
                 from /work/Linux/2.6/linux-2.6-arm/include/linux/stat.h:60,
                 from /work/Linux/2.6/linux-2.6-arm/include/linux/module.h:10,
                 from /work/Linux/2.6/linux-2.6-arm/include/linux/crypto.h:21,
                 from /work/Linux/2.6/linux-2.6-arm/arch/x86/kernel/asm-offsets_32.c:7,
                 from /work/Linux/2.6/linux-2.6-arm/arch/x86/kernel/asm-offsets.c:2:
include/linux/wait.h|51| error: expected specifier-qualifier-list before ‘spinlock_t’

The linux/mmzone.h file normally includes linux/spinlock.h but the
reverse is also true when the latter includes the former via
thread_info.h and gfp.h. Because of the (correct) guards in the header
files, the spinlock_t definition is no longer available in mmzone.h.


Anyway, what I'd like with this patch is to reduce the latency caused by
holding the tasklist_lock while scanning the stacks and also allow
rescheduling. If you have 500 threads in a system with 8K stacks,
kmemleak would need to scan about 4MB of stacks. While I think I can use
rcu_read_lock/unlock around do_each_thread..while_each_thread,
scheduling still isn't possible.

An alternative would be to traverse the tasks list for every stack
scanned. This traversing should be negligible compared to a stack
scanning time (looking up pointers in the prio tree).

Any opinion/suggestion here?

Thanks.

-- 
Catalin

