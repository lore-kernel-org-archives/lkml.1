Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbZBDPfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbZBDPfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 10:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZBDPe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 10:34:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58279 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZBDPe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 10:34:56 -0500
Subject: Re: [PATCH 3/3] tracing: Tracers that use CALLER_ADDR macros
	should select FRAME_POINTER
From: Steven Rostedt <srostedt@redhat.com>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <c62985530902040726x34aeee7fr3b2937d898d3061e@mail.gmail.com>
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru>
	 <20090204150840.GC30027@oksana.dev.rtsoft.ru>
	 <c62985530902040726x34aeee7fr3b2937d898d3061e@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Organization: Red Hat
Date: Wed, 04 Feb 2009 10:31:21 -0500
Message-Id: <1233761481.16878.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2009-02-04 at 16:26 +0100, Frédéric Weisbecker wrote:
> 2009/2/4 Anton Vorontsov <avorontsov@ru.mvista.com>:
> > Irqsoff, switch and preempt tracers use CALLER_ADDR macros, so they
> > should select FRAME_POINTER. Otherwise traces are meaningless.
> >
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > ---
> >  kernel/trace/Kconfig |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> >
> > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > index e2a4ff6..48f7a37 100644
> > --- a/kernel/trace/Kconfig
> > +++ b/kernel/trace/Kconfig
> > @@ -86,6 +86,7 @@ config IRQSOFF_TRACER
> >        select TRACE_IRQFLAGS
> >        select TRACING
> >        select TRACER_MAX_TRACE
> > +       select FRAME_POINTER
> >        help
> >          This option measures the time spent in irqs-off critical
> >          sections, with microsecond accuracy.
> > @@ -108,6 +109,7 @@ config PREEMPT_TRACER
> >        depends on DEBUG_KERNEL
> >        select TRACING
> >        select TRACER_MAX_TRACE
> > +       select FRAME_POINTER
> >        help
> >          This option measures the time spent in preemption off critical
> >          sections, with microsecond accuracy.
> > @@ -136,6 +138,7 @@ config SCHED_TRACER
> >        select TRACING
> >        select CONTEXT_SWITCH_TRACER
> >        select TRACER_MAX_TRACE
> > +       select FRAME_POINTER
> >        help
> >          This tracer tracks the latency of the highest priority task
> >          to be scheduled in, starting from the point it has woken up.
> > --
> 
> 
> Looks right.
> 
> BTW, how behaves builtin_return_address in case of !FRAME_POINTERS ?
> I guess it would only work with the first caller builtin_return_address(0)


>From ftrace.h:

#ifdef CONFIG_FRAME_POINTER
/* TODO: need to fix this for ARM */
# define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
# define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
# define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
# define CALLER_ADDR3 ((unsigned long)__builtin_return_address(3))
# define CALLER_ADDR4 ((unsigned long)__builtin_return_address(4))
# define CALLER_ADDR5 ((unsigned long)__builtin_return_address(5))
# define CALLER_ADDR6 ((unsigned long)__builtin_return_address(6))
#else
# define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
# define CALLER_ADDR1 0UL
# define CALLER_ADDR2 0UL
# define CALLER_ADDR3 0UL
# define CALLER_ADDR4 0UL
# define CALLER_ADDR5 0UL
# define CALLER_ADDR6 0UL
#endif

Yep!

-- Steve


