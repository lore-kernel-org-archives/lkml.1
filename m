Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYACTYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYACTYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 14:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYACTY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 14:24:29 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:47255 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751600AbYACTY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 14:24:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAKnDfEdMROHU/2dsb2JhbACBV6hh
Date: Thu, 3 Jan 2008 14:24:23 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, dipankar@in.ibm.com, ego@in.ibm.com,
       paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH 2/2] Markers Implementation for Preempt RCU Boost
	Tracing
Message-ID: <20080103192423.GA4321@Krystal>
References: <20071231060911.GB6461@in.ibm.com> <20071231102045.GB30380@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071231102045.GB30380@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:11:20 up 61 days, 16 min,  5 users,  load average: 0.02, 0.04,
	0.08
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * K. Prasad <prasad@linux.vnet.ibm.com> wrote:
> 
> > @@ -486,12 +309,12 @@ void rcu_unboost_readers(void)
> >  
> >  	spin_lock_irqsave(&rcu_boost_wake_lock, flags);
> >  
> > -	rcu_trace_boost_try_unboost_readers(RCU_BOOST_ME);
> > +	trace_mark(try_unboost_readers, "%u", smp_processor_id());
> 
> this isnt directed at you or your patch, it's more directed at Mathieu, 
> but looking at this actual markers patch submitted to me, i'm still 
> fundamentally worried about the whole marker approach.
> 

Hi Ingo,

Just to note that some of your concerns have been answered by Frank and
that I fully agree with what he said. Sorry for the late reply
(vacation..)

> Firstly, why on earth does a full format string have to be passed in for 
> something as simple as a CPU id? This way we basically codify it forever 
> that tracing _has_ to be expensive when enabled. The latency-tracer 
> (which i'd love to convert to markers, if only markers were capable 
> enough) has shown it that tracing _can_ be used to capture performance 
> data without disturbing the measured system, even at hundreds of 
> thousands context switches a second per CPU.
> 

As I replyed in my other email, the cpu id does not have to be passed as
an argument. Also, when no argument is passed, the format string does
not have to be parsed at all in the callback.

> Secondly, the inlined overhead of trace_mark() is still WAY too large:
> 
>                 if (unlikely(__mark_##name.state)) {                    \
>                         preempt_disable();                              \
>                         (*__mark_##name.call)                           \
>                                 (&__mark_##name, call_data,             \
>                                 format, ## args);                       \
>                         preempt_enable();                               \
>                 }                                                       \
> 

To get the full version of my trace_mark, you would have to take a few
bits from the -mm tree, which includes the "multiple probes support"
(this one moves the preempt disable/enable completely out of line) and
you should also get the "markers use immediate values" patch which I
submitted a few weeks ago : it uses code patching to modify a byte in a
mov instruction that is used to jump over the entire function call
(memory references, stack setup and the call itself)

> Whatever became of the obvious suggestion that i outlined years ago, to 
> have a _single_ trace call instruction and to _patch out_ the damn 
> marker calls by default? No .state flag checking inlined. No 
> preempt_disable()/enable() pair. Patching static tracepoints OUT of the 
> kernel, only leaving a ~5-byte NOP sequence behind them (and some 
> minimal disturbance to the variables the tracepoint accesses). We've got 
> all the alternatives.h code patching infrastructure available for such 
> purposes. Why are we 2 years down the line and _STILL_ arguing about 
> this?
> 

Frank replied appropriately to this. It's mostly because of stack setup
and/or move to registers to prepare the call.

> Thirdly, the patch selects CONFIG_MARKERS:
> 
> >  config RCU_TRACE
> > -       bool "Enable tracing for RCU - currently stats in debugfs"
> > +       tristate "Enable tracing for RCU - currently stats in debugfs"
> >         select DEBUG_FS
> > -       default y
> > +       select MARKERS
> 
> Which adds overhead (inlined checks for markers) all around the kernel, 
> even if all markers are deactivated! Imagine a thousand of them and the 
> kernel blows up measurably.
> 
> Sadly, this whole trace_mark() API seems to have gotten much worse since 
> i last saw it. It's sub-par when it's turned on and it's sub-par when 
> it's turned off. It gets us the worst of both worlds.
> 
> If it continues like this then i'd much rather see people add printks as 
> tracing, because there you _know_ that it's high-overhead and people 
> wont start arguing about trace compatibility either, etc.
> 

I think Frank's response explains things in enough depth.

> 	Ingo

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
