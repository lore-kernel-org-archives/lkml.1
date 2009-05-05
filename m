Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbZEENfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbZEENfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 09:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbZEENe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 09:34:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37895 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbZEENe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 09:34:58 -0400
Subject: Re: [PATCH 1/3] powerpc, Makefile: Make it possible to safely
	select CONFIG_FRAME_POINTER
From: Steven Rostedt <srostedt@redhat.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <6A6BE346-925C-4F73-ABFA-C6110070F071@kernel.crashing.org>
References: <20090502001329.GA11549@oksana.dev.rtsoft.ru>
	 <20090502001421.GA9342@oksana.dev.rtsoft.ru>
	 <68B2EF73-0FD2-41F9-966B-9A54965AFBA6@kernel.crashing.org>
	 <1241316249.4243.22.camel@localhost.localdomain>
	 <6A6BE346-925C-4F73-ABFA-C6110070F071@kernel.crashing.org>
Content-Type: text/plain
Organization: Red Hat
Date: Tue, 05 May 2009 09:33:02 -0400
Message-Id: <1241530382.11379.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-05-05 at 09:56 +0200, Segher Boessenkool wrote:
> > Yeah, I agree. This needs a better description. I only know what's  
> > going
> > on because I was there for the start of the discussion.
> >
> > But just to be sure, this is what I think is happening.
> >
> > When we add "-pg" to gcc, it automatically causes frame pointers to be
> > used.
> 
> Nope, it does no such thing.

Well, mcount is expected to be able to get to not just who called
mcount, but also the parent of that function. The way mcount is
implemented does not let you do that. If mcount was the first thing to
be called in a function, then it would have been perfect. We could get
to the caller, its parent, and even the parameters. But unfortunately,
mcount is called after the stack is set up. Thus, without frame pointers
(the way to find a previous frame) there's no way (on some archs) to
find the parent. Nor can we figure out the parameters, which really
sucks.


> 
> > But with PPC, it always has frame pointers and there's no problem.
> 
> Well, what do you call a "frame pointer"?  In the general meaning
> of "some register that points to the incoming function arguments
> and the function local variables", PowerPC can _usually_ use GPR1,
> the stack pointer (and indeed it is called "stack frame pointer"
> in the ABI).  In the more narrow meaning of "what GCC calls the
> frame pointer", "the thing that -fomit-frame-pointer optimises
> away" -- on PowerPC (and many other targets), -fomit-frame-pointer
> is the *default* when optimisation is enabled!
> 
> There is a GCC bug here though: it won't allow both -pg and
> -fomit-frame-pointer be set at the command line at the same time,
> even on targets where that is not problematic.
> 
> > But with Linux, when you add CONFIG_FRAME_POINTER, it automatically
> > adds:  -fno-omit-frame-pointer. Thus the config will add
> > "-fomit-frame-pointer" when CONFIG_FRAME_POINTER is not set, or it  
> > will
> > add "-fno-omit-frame-pointer" when it is set.
> >
> > The problem with PPC is that "-fno-omit-frame-pointer" is buggy and
> > causes gcc to produce bad code.
> 
> It's a deeper problem that is only _exposed_ by -fno-o-f-p (and can be
> hidden by -mno-sched-epilog in the one spot where it hit us).
> 
> > Perhaps a better name would be:
> >
> > HAVE_FRAME_POINTER_AS_DEFAULT
> 
> NO_NO_OMIT_FRAME_POINTER ?  Or better, just never use -fno-o-f-p,
> I don't see why you would ever need it.

Because on x86_64 it gives better back traces. x86_64 has no way to get
to the previous frames without it. There's code to use other debug
metadata to get back tracing, but for uses of things like the stack
tracer, we need to be able to use the actual stack frames.

As you said above, -fomit-frame-pointer is default when we optimize, and
that is how the kernel is built. If we optimize on x86_64 and do not use
-fno-omit-frame-pointer, the stack tracer is useless.

-- Steve


