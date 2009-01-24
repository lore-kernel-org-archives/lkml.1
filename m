Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbZAXQDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbZAXQDA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 11:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZAXQCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 11:02:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:53095 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbZAXQCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 11:02:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=k+o0+qoqZBrym/N5DTkv/wcE8JNUCcpMd1eDa16l90xRXg6cF6/Dp2y9TuziZUX1WK
         ZdCOXkNeTOIW9wfhXHVx53GVSRFkRERfeZnn3Ry38BXe3MFWWnIKdKxdWEXpcK2KH3eh
         OUbl2btQ2pUhnYodtfhDB1s19q7R9XbRPQJKA=
Date: Sat, 24 Jan 2009 17:02:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] tracing/function-graph-tracer: various fixes
	and features
Message-ID: <20090124160244.GB5773@nowhere>
References: <497917b5.09cc660a.5f4c.ffffc568@mx.google.com> <20090123101949.GD15188@elte.hu> <c62985530901230236v4a8f5d6od80924cb6542d994@mail.gmail.com> <20090123110037.GI15188@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090123110037.GI15188@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 12:00:37PM +0100, Ingo Molnar wrote:
> 
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
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


Ok, yeah that's a good idea.

 
> Furthermore, another trace_option could introduce a third 'strongly 
> ordered' trace-clock variant, which would use cmpxchg and per cpu 
> timestamps, something like this:
> 
> atomic64_t curr_time;
> 
> DEFINE_PER_CPU(u64, prev_cpu_time);
> ...
> 
> retry:
> 	prev_cpu_time = per_cpu(prev_cpu_time, cpu);
> 	cpu_time = sched_clock();
> 	old_time = atomic64_read(&curr_time);
> 
> 	delta = cpu_time - prev_cpu_time;
> 	if (unlikely((s64)delta <= 0))
> 		delta = 1;
> 
> 	new_time = old_time + delta;
> 
> 	if (atomic64_cmpxchg(&curr_time, old_time, new_time) != new_time)
> 		goto repeat;
> 
>         time = new_time << DEBUG_SHIFT;
> 
> This would be a monotonic, global clock wrapped around sched_clock(). It 
> uses a cmpxchg to achieve it, but we have to use global ordering anyway. 
> 
> It would still be _much_ faster than any GTOD clocksource we have.
> 
> Hm?
> 

And that would be even more faster that cpu_clock().

But why implement both? Wouldn't the above be more faster while playing the same thing
than cpu_clock()

