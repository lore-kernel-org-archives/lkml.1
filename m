Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbYLHCMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbYLHCMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 21:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYLHCMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 21:12:34 -0500
Received: from fmailhost03.isp.att.net ([207.115.11.53]:60473 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbYLHCMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 21:12:32 -0500
X-Originating-IP: [72.155.109.65]
From: "Dan Terpstra" <terpstra@eecs.utk.edu>
To: <eranian@gmail.com>, "'Thomas Gleixner'" <tglx@linutronix.de>
Cc: <linux-arch@vger.kernel.org>, "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>,
       "'David Miller'" <davem@davemloft.net>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Eric Dumazet'" <dada1@cosmosbay.com>,
       "'Paul Mackerras'" <paulus@samba.org>, "'Peter Anvin'" <hpa@zytor.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'perfmon2-devel'" <perfmon2-devel@lists.sourceforge.net>,
       "'Arjan van de Veen'" <arjan@infradead.org>
References: <20081204225345.654705757@linutronix.de> <7c86c4470812051836t37e86565w3b92fd06fc905430@mail.gmail.com>
Subject: RE: [perfmon2] [patch 0/3] [Announcement] Performance Counters forLinux
Date: Sun, 7 Dec 2008 21:12:25 -0500
Message-ID: <04009AA71D2343CF8DCD0E607DC58225@terpstrat60p>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <7c86c4470812051836t37e86565w3b92fd06fc905430@mail.gmail.com>
Thread-Index: AclXS/Mhu159ZOFATF6ljy/ODolxewBjV0eQ
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm reminded of the quote attributed to Einstein: "Make things as simple as
possible, but no simpler".
In that regard, it appears that Stephane's perfmon is closer to the mark
than this proposal.
If Stephane's observations below are even close to correct, it would make
PAPI's first-person event-set caliper model essentially useless. We must be
able to start and stop multiple counter values simultaneously and quickly to
infer any validity even for derived measurements as simple as
instructions-per-cycle.
dan terpstra
for the PAPI team


> -----Original Message-----
> From: stephane eranian [mailto:eranian@googlemail.com]
> Sent: Friday, December 05, 2008 9:37 PM
> To: Thomas Gleixner
> Cc: linux-arch@vger.kernel.org; Peter Zijlstra; David Miller; LKML; Steven
> Rostedt; Eric Dumazet; Paul Mackerras; Peter Anvin; Andrew Morton; Ingo
> Molnar; perfmon2-devel; Arjan van de Veen
> Subject: Re: [perfmon2] [patch 0/3] [Announcement] Performance Counters
> forLinux
> 
> Hello,
> 
> I have been reading all the threads after this unexpected announcement
> of a competing proposal for an interface to access the performance
> counters.
> I would like to respond to some of the things I have seen.
> 
> * ptrace: as Paul just pointed out, ptrace() is a limitation of the
>   current perfmon implementation. This is not a limitation of the
>   interface as has been insinuated earlier. In my mind, this does
>   not justify starting from scratch. There is nothing that precludes
>   removing ptrace and using the IPI to chase down the PMU state,
>   like you are doing. And in fact I believe we can do it more efficiently
>   because we would potentially collect multiple values in one IPI,
>   something your API cannot allow because it is single event oriented.
> 
> * There is more to perfmon than what you have looked at on LKML. There
>    is advanced sampling support with a kernel level buffer which is
> remapped
>    to user space. So there is no such thing as a couple of ptrace() calls
> per
>    sample. In fact, there is zero copy export to user space. In the
> case of PEBS,
>    there is even zero-copy from HW to user space.
> 
> * The proposed API exposes events as individual entities. To measure N
>    events, you need N file descriptors. There is no coordination of
> actions
>    between the various events. If you want to start/stop all events, it
> seems
>    you have to close the  file descriptors and start over. That is not
> how people
>    use this, especially people doing self monitoring. They want to
> start/stop
>    around critical loops or functions and they want this to be fast.
> 
> * To read N events you need N syscalls and potentially N IPIs. There
>    is no guarantee of atomicity between the reads. The argument of raising
>    the priority to prevent preemption is bogus and unrealistic. We want
> regular
>    users to be able to measure their own applications without having to
> have
>    special privileges. This is especially unpractical when you want to
> read from
>    another thread. It is important to get a view of the counters that
> is as consistent
>    as possible and for that you want to read the registers are closely
> as possible
>    from each other.
> 
> * As mentioned by Paul, Corey, the API inevitably forces the kernel to
> know about
>   ALL the events and how they map onto counters. People who have been
> doing this
>   in userland, and I am one of them, can tell you that this is a very
> hard problem.
>   Looking at it just on the Intel and AMD x86 is misleading. It is not
> the number of
>   events that matters, even it contributes to the kernel bloat, it is
> managing the constraints
>   between events (event A and B cannot be measured together, if event
> A uses counter X
>   then B cannot be measured on counter Y). Sometimes, the value of a
> config register depends
>   on which register you load it on. With the proposed API, all this
> complexity would have to go in
>   the kernel. I don't think it belongs here and it will leads to
> maintenance problems, and longer
>   delays to enable support of new hardware. The argument for doing
> this was that it would
>   facilitate writing tools. But all that complexity does not belong in
> the tools but in a user library.
>   This is what libpfm is designed for and it has worked nicely so far.
> The role of the kernel
>   is to control access to the PMU resource and to make sure incorrect
> programming of the registers
>   cannot crash the kernel. If you do this, then providing support for
> new hardware is for the most part
>   simply exposing the registers. Something which can even be
> discovered automatically on newer
>   processors, e.g., ones supporting Intel architectural perfmon.
> 
> * Tools usually manage monitoring as a session. There was criticism
>    about the perfmon context abstraction and vectors. A context is  merely
>    a synonym for session.  I believe having a file descriptor per session
> is
>    a natural thing to have. Vectors are used to access multiple registers
> in
>    one syscall. Vector have variable sizes, it depends on what you want to
>    access. The size is not mandated by the number of registers of the
>    underlying hardware.
> 
> * As mentioned by Paul, with certain PMUs, it is not possible to solve
>   the event -> counter problem without having a global view
>   of all the events. Your API being single-event oriented, it is not
>   clear to me how this can be solved.
> 
> * It is not because you run a per thread session, that you should be
>   limited to measuring at priv level 3.
> 
> * Modern PMU, including AMD Barcelona. Itanium2, expose more than
>   counters. Any API than assumes PMU export only
>   counters is going to be limited, e.g. Oprofile. Perfmon does not
>   make that mistake, the interface does not know anything
>   about counters nor sampling periods. It sees registers with values
>   you can read or write. That has allowed us to support
>   advanced features such as Itanium2 Opcode filter, Itanium2
>   Code/Data range restrictions (hosted in debug regs), AMD
>   Barcelona IBS which has no event associated with it, Itanium2
>   BranchTraceBuffer, Intel Core 2 LBR, Intel Core i7 uncore PMU.
>   Some of those features have no ties with counters, they do not even
>   overflow (e.g., LBR). They must be used in combination with
>   counters, e.g., LBRs. I don't think you will be able to do this
>   with your API.
> 
> * With regards to sampling, advanced users have long been collecting
>   more than just the IP. They want to collect the values of other
>   PMU registers or even values of other non-PMU resources. With your
>   API, it seems for every new need, you'd have to create a new
>   perf_record_type, which translates into a kernel patch. This is not
>   what people want. With perfmon, you have a choice of doing user
>   level sampling (users gets notification for each sample) but you can
>   also use a kernel sampling buffer. In that case, you can express
>   what you want recorded in the buffer using simple bitmasks of PMU
>   registers. There is no predefined set, no kernel patch.
>   To make this even more flexible the buffer format is not part of the
>   interface, you can define your own and record whatever you want
>   in whatever format you want. All is provided by kernel modules. You
>   want double-buffer, cyclic buffer, just add your kernel module. It
>   seems this feature has been overlooked by LKML reviewers but it is
>   really powerful.
> 
> * It is not clear to me how you would add a sampling buffer and
>   remapping using your API given the number of file descriptors you will
>   end up using and the fact that you do not have the notion of a session.
> 
> * When sampling, you want to freeze the counters on overflow to get an
>   as consistent as possible view. There is no such guarantee in
>   your API nor implementation. On some hardware platforms, e.g.,
>   Itanium, you have no choice this is the behavior.
> 
> * Multiple counters can overflow at the same time and generate a
>   single interrupt. With your approach, if two counters overflow
>   simultaneously, then you need to enqueue two messages, yet only
>   one SIGIO wil be generated, it seems. Wonder how that works when
>   self-monitoring.
> 
> 
> In summary, although the idea of simplifying tools by moving the
> complexity elsewhere is legitimate, pushing it down to the kernel
> is the wrong approach in my opinion, perfmon has avoided that as much
> as possible for good reasons. We have shown , with libpfm,
> that a large part of complexity can easily be encapsulated into a user
> library. I also don't think the approach of managing events
> independently of each others works for all processors. As pointed out
> by others, there are other factors at stake and they may not
> even be on the same core.
> 
> S. Eranian
> 
> --------------------------------------------------------------------------
> ----
> SF.Net email is Sponsored by MIX09, March 18-20, 2009 in Las Vegas,
> Nevada.
> The future of the web can't happen without you.  Join us at MIX09 to help
> pave the way to the Next Web now. Learn more and register at
> http://ad.doubleclick.net/clk;208669438;13503038;i?http://2009.visitmix.co
> m/
> _______________________________________________
> perfmon2-devel mailing list
> perfmon2-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/perfmon2-devel

