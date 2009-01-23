Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbZAWOyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbZAWOyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 09:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbZAWOyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 09:54:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34412 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbZAWOyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 09:54:03 -0500
Date: Fri, 23 Jan 2009 09:53:59 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] tracing/function-graph-tracer: various fixes and
 features
In-Reply-To: <20090123110037.GI15188@elte.hu>
Message-ID: <alpine.DEB.1.10.0901230948400.8605@gandalf.stny.rr.com>
References: <497917b5.09cc660a.5f4c.ffffc568@mx.google.com> <20090123101949.GD15188@elte.hu> <c62985530901230236v4a8f5d6od80924cb6542d994@mail.gmail.com> <20090123110037.GI15188@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 23 Jan 2009, Ingo Molnar wrote:

> 
> * Fr?d?ric Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > Still needs a solution - if we do cross-CPU traces we want to have a 
> > > global trace clock with 'seemless' transition between CPUs.
> > 
> > So it doesn't only need a monotonic clock. It needs a global consistent 
> > clock like ktime for example? Unfortunately this one uses seq_locks and 
> > would add some drawbacks like verifying if the traced function doesn't 
> > hold the write seq_lock and it will bring some more ftrace recursion...
> 
> using ktime_get() is indeed out of question - GTOD callpaths are too 
> complex (and also too slow).
> 
> I'd not change anything in the current logic, but i was thinking of a new 
> trace_option, which can be set optionally. If that trace option is set 
> then this bit of ring_buffer_time_stamp():
> 
>         time = sched_clock() << DEBUG_SHIFT;
> 
> gets turned into:
> 
>         time = cpu_clock(cpu) << DEBUG_SHIFT;
> 
> This way we default to sched_clock(), but also gain some 'global' 
> properties if the trace_option is set.

I would like to keep the ring buffer agnostic to ftrace, or any other 
user. What we could do is add an interface to the ring buffer that will 
allow the time keeping interface to be set by the buffer.

typedef u64 (*ring_buffer_time_stamp_func)(int cpu);
typedef void(*ring_buffer_normalize_func)(int cpu, u64 *ts);

void ring_buffer_add_time_source(ring_buffer_time_stamp_func *tsfunc,
				ring_buffer_normalize_func *norfunc);

Then the ftrace tracer could pass in its own function to keep time.

This way we could also make several different tracers that use different 
timesources to test them out and compare, without needing to reboot.

-- Steve

