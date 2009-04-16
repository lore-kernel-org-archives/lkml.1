Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZDPA4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZDPA4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 20:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZDPA4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 20:56:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46680 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbZDPA4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 20:56:31 -0400
Date: Wed, 15 Apr 2009 20:56:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with CREATE_TRACE_POINTS and recursion safety
In-Reply-To: <49E67D1D.8020704@goop.org>
Message-ID: <alpine.DEB.2.00.0904152042350.4459@gandalf.stny.rr.com>
References: <49E67D1D.8020704@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 15 Apr 2009, Jeremy Fitzhardinge wrote:

> I'm having a problem with CREATE_TRACE_POINTS being too indiscriminate.  The
> trouble is that it not only creates tracepoint definitions for the intended
> tracepoints, but any other tracepoint definitions which get included
> incidentally.
> 
> For example, I'm seeing my paravirt tracepoints being instantiated in both
> kernel/sched.o and kernel/irq/manage.o as side-effects of the scheduler and
> irq tracepoints being instantiated.
> 
> I'm experimenting with a different scheme, wherein a subsystem defines
> CREATE_FOO_TRACE_POINTS in the .c file where it wants to instantiate the
> tracepoints - rather than CREATE_TRACE_POINTS - and its trace/events/foo.h
> does:
> 
>    #ifdef CREATE_FOO_TRACE_POINTS
>    #undef CREATE_FOO_TRACE_POINTS	/* avoid infinite recursion */
>    #include <trace/instantiate_trace.h>
>    #else
>    #include <trace/define_trace.h>
>    #endif
> 
> where instantiate_trace.h is:
> 
>    #define CREATE_TRACE_POINTS
>    #include <trace/define_trace.h>
>    #undef CREATE_TRACE_POINTS
> 
> (Just to prevent a bit more repeated boilerplate in each events definition
> file.)
> 
> This seems to work.  (Update: no it doesn't.  WTF has paravirt-trace.o got
> duplicate kmem tracepoints?!)

kmem was a PITA.  Looks like we might need to do a:

#ifdef CREATE_FOO_TRACE_POINTS
#include <trace/define_trace.h>
#endif

type of thing, and have each user define their own CREATE_FOO_TRACE_POINTS 
that they want to instantiate. This should be a requirement on any 
trace point header that is used in other headers.

Does just adding the above to the kmem.h header and your header fix it for 
you?

-- Steve




> 
> A related problem is that the TRACE_INCLUDE_FILE mechanism doesn't work,
> because if any tracepoint definition header sets it, it overrides the setting
> for all others, so, for example, arch/x86/include/asm/paravirt.h ends up being
> included as the source of definitions for events/sched.h.  I gave up and moved
> paravirt-trace.h to trace/events/pvops.h rather than try to deal with it.

Those that define TRACE_INCLUDE_FILE need to undef it too. :-/

> 
> Lucky for you Steven, none of this is getting any more pretty, so you may yet
> get your prize.

