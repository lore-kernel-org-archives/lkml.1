Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbZDQLJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbZDQLJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 07:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbZDQLJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 07:09:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50264 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897AbZDQLJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 07:09:44 -0400
Date: Fri, 17 Apr 2009 07:09:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 2/2] tracing/events/lockdep: move tracepoints within
 recursive protection
In-Reply-To: <20090417045229.GA30001@Krystal>
Message-ID: <alpine.DEB.2.00.0904170706510.20429@gandalf.stny.rr.com>
References: <20090416161543.199331330@goodmis.org> <20090416161746.831882528@goodmis.org> <1239900469.23397.3128.camel@laptop> <alpine.DEB.2.00.0904161343110.20429@gandalf.stny.rr.com> <1239904428.23397.3278.camel@laptop> <alpine.DEB.2.00.0904162254270.20429@gandalf.stny.rr.com>
 <alpine.DEB.2.00.0904170002030.20429@gandalf.stny.rr.com> <20090417045229.GA30001@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Apr 2009, Mathieu Desnoyers wrote:
> > ---[ end trace 03d889e04bc7a9a7 ]---
> > possible reason: unannotated irqs-on.
> > irq event stamp: 12569
> > hardirqs last  enabled at (12567): [<ffffffff8026206a>] local_bh_enable+0xaa/0x110
> > hardirqs last disabled at (12569): [<ffffffff80610c76>] int3+0x16/0x40
> > softirqs last  enabled at (12566): [<ffffffff80514d2b>] lock_sock_nested+0xfb/0x110
> > softirqs last disabled at (12568): [<ffffffff8058454e>] tcp_prequeue_process+0x2e/0xa0
> > 
> > 
> > Note, for some reason we hit int3 ??
> > 
> > Tracepoints do not use int3 does it?
> > 
> 
> Not in your ftrace tree. My LTTng tree includes the immediate values,
> which brienfly uses the int3 handler when enabling/disabling
> tracepoints. But this seems unrelated to your problem.

Maybe something else is adding it :-/

> 
> > I have kprobes defined but not any kprobe self tests on.
> > 
> 
> Could this be a userspace breakpoint then ?

Nope, it happens right in the kernel. And the path I describe below points 
out that we have a bug in irq tracing when we take a int3 in kernel space.

> 
> > Anyway, let me describe what the above is and what I found in my 
> > investigation.
> > 
> > The lockdep took a check_flags error when it noticed that interrupts were 
> > enabled, but the current->hardirqs_enabled was 0. Lockdep thought 
> > interrupts were disabled but they were in fact enabled.
> > 
> > 
> > The last 4 lines of the warning have the numbers in the parenthesis 
> > annotate the order of events: (Here they are in order)
> > 
> > softirqs last  enabled at (12566): [<ffffffff80514d2b>] lock_sock_nested+0xfb/0x110
> > hardirqs last  enabled at (12567): [<ffffffff8026206a>] local_bh_enable+0xaa/0x110
> > softirqs last disabled at (12568): [<ffffffff8058454e>] tcp_prequeue_process+0x2e/0xa0
> > hardirqs last disabled at (12569): [<ffffffff80610c76>] int3+0x16/0x40
> > 
> > The last change that lockdep saw was interrupts being disabled by int3. I 
> > still don't understand why int3 was enabled. I have startup tests for 
> > ftrace and the event tracer, but this blob happened when I first ssh'd 
> > into the box.
> 
> Also note that maybe some entry.S annotation could be missing, making
> kallsyms think it was running within int3 when in fact it was running in
> a different function. I would double-check with objdump givin the
> ffffffff80610c76 address to make sure.

Actually, that was the first thing I did. Because I thought int3 was 
weird.


> 
> Just giving my 2 cents before going to bed. I don't have any more brain
> left for tonight.

Thanks,

-- Steve
