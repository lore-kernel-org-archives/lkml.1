Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbZH2PKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbZH2PKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 11:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZH2PKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 11:10:22 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:40629 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813AbZH2PKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 11:10:22 -0400
Subject: Re: [PATCH 1/2] kmemleak: Inform kmemleak about kernel stack
	allocation
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1251556083.5518.2.camel@pc1117.cambridge.arm.com>
References: <20090827165927.27901.97270.stgit@pc1117.cambridge.arm.com>
	 <20090827170253.27901.33997.stgit@pc1117.cambridge.arm.com>
	 <20090829132954.GB24123@elte.hu>
	 <1251556083.5518.2.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Sat, 29 Aug 2009 16:08:42 +0100
Message-Id: <1251558522.5923.1.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Aug 2009 15:08:42.0986 (UTC) FILETIME=[9906ACA0:01CA28BA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-29 at 15:28 +0100, Catalin Marinas wrote:
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
> I tried this first but got compilation errors in files that didn't even
> call this function. To make it workable, thread_info.h would need to
> include additional headers. If that's acceptable, I can post an updated
> patch.

Actually I think it's only the kmemleak.h header but it would get
included via thread_info.h in many other files. An alternative is to
make kmemleak_alloc() etc. return the pointer passed as argument and
keep the macro something like:

kmemleak_alloc(__get_free_pages(...), ...)

though it is still a bit long.

-- 
Catalin

