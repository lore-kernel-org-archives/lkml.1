Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbYIWBjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbYIWBjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 21:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbYIWBjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 21:39:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35182 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbYIWBjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 21:39:42 -0400
Date: Mon, 22 Sep 2008 21:39:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Roland Dreier <rdreier@cisco.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
In-Reply-To: <adaod2f649o.fsf@cisco.com>
Message-ID: <alpine.DEB.1.10.0809222130590.26011@gandalf.stny.rr.com>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <48D7F5E8.3000705@redhat.com> <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com> <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>
 <48D832B6.3010409@redhat.com> <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org> <adaod2f649o.fsf@cisco.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Sep 2008, Roland Dreier wrote:

>  > Because all it tells you is the ordering of the atomic increment, not of 
>  > the caller. The atomic increment is not related to all the other ops that 
>  > the code that you trace actually does in any shape or form, and so the 
>  > ordering of the trace doesn't actually imply anything for the ordering of 
>  > the operations you are tracing!
> 
> This reminds me of a naive question that occurred to me while we were
> discussing this at KS.  Namely, what does "ordering" mean for events?
> 
> An example I'm all too familiar with is the lack of ordering of MMIO on
> big SGI systems -- if you forget an mmiowb(), then two CPUs taking a
> spinlock and doing writel() inside the spinlock and then dropping the
> spinlock (which should be enough to "order" things) might see the
> writel() reach the final device "out of order" because the write has to
> travel through a routed system fabric.
> 
> Just like Einstein said, it really seems to me that the order of things
> depends on your frame of reference.

In my logdev tracer (see http://rostedt.homelinux.com/logdev) I used an 
atomic counter to keep "order". But what I would say to people what this 
order means, is that order is among multiple traces between multiple CPUS.
That is if you have.

   CPU 1                                CPU 2
trace_point_a                        trace_point_c
trace_point_b                        trace_point_d

If you see in the trace:

trace_point_a
trace_point_c

You really do not know which happened first. Simply because trace_point_c 
could have been hit first, but for interrupts and nmis and what not, 
trace_point_a could have easily been recorded first. But to me, 
trace_points are more like memory barriers.

If I see:

trace_point_c
trace_point_a
trace_point_b
trace_point_d

I can assume that everything before trace_point_c happened before 
everything after trace_point_a, and that all before trace_point_b happened 
before trace_point_d.

One can not assume that the trace points themselves are in order. But you 
can assume that the things outside the trace points are, like memory 
barriers. I have found lots of race conditions with my logdev, and it was 
due to this "memory barrier" likeness to be able to see the races.

Unfortunately, if you are using an out of sync TSC, you lose even the 
memory barrier characteristic of the trace.

-- Steve

