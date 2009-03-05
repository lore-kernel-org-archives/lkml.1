Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbZCEL5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbZCEL5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 06:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbZCEL5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 06:57:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44415 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbZCEL5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 06:57:06 -0500
Date: Thu, 5 Mar 2009 12:56:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: use the more
	lightweight local clock
Message-ID: <20090305115652.GA18745@elte.hu>
References: <49af243d.06e9300a.53ad.ffff840c@mx.google.com> <20090305011941.GA9821@nowhere> <1236238213.5330.10111.camel@laptop> <20090305084639.GC5359@nowhere> <20090305105652.GG32407@elte.hu> <20090305111646.GG5359@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305111646.GG5359@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Mar 05, 2009 at 11:56:52AM +0100, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > On Thu, Mar 05, 2009 at 08:30:13AM +0100, Peter Zijlstra wrote:
> > > > On Thu, 2009-03-05 at 02:19 +0100, Frederic Weisbecker wrote:
> > > > 
> > > > > It takes 1 ms to execute while tracing.
> > > > > Considering my frequency is 250 Hz, it means 1/4 of the system is used
> > > > > on timer interrupt while tracing.
> > > > > 
> > > > > For now the hang is fixed, but not the awful latency. And I'm just too frightened
> > > > > to test it on 1000 Hz.
> > > > > 
> > > > > But I plan to add a kind of watchdog to check how many time we spent inside an
> > > > > interrupt while graph tracing.
> > > > > By checking this time against the current Hz value, I could decide to abort the tracing
> > > > > for all irq.
> > > > 
> > > > That would basically render the thing useless :-(
> > > 
> > > 
> > > It would be only for slow machines :-)
> > > I'm talking about something that happened on a Pentium II.
> > > 
> > >  
> > > > Is it specifically function_graph that is so expensive? If so, is that
> > > > because of the function exit hook?
> > > 
> > > 
> > > Yes, specifically the function_graph, the function tracer is 
> > > not concerned. The function graph tracer takes more than 
> > > double overhead compared to the function tracer.
> > > 
> > > Usually the function tracer hooks directly the the function 
> > > that insert the event, it's pretty straightforward.
> > > 
> > > The function graph does much more work: 
> > > 
> > > entry: basic checks, take the time, push the infos on the stack, insert an event
> > >        on the ring-buffer, hook the return value.
> > > return: pop the infos from stack, insert an event on the ring-buffer, jump
> > >         to the original caller.
> > > 
> > > It has a high cost... which makes me sad because I plan to 
> > > port it in on Arm and I fear the little Arm boad I recently 
> > > purshased will not let me trace the interrupts without 
> > > hanging...
> > > :-(
> > > 
> > > I guess I should start thinking on some optimizations, perhaps 
> > > using perfcounter?
> > 
> > yeah. perfcounters and KernelTop might not work on a PII CPU out 
> > of box though.
> > 
> > But hacking perfcounters and looking at perfstat/kerneltop 
> > output is serious amount of fun so if you are interested you 
> > could try to implement support for it. Do you have any box where 
> > perfcounters work? (that would be Core2 Intel boxes or pretty 
> > much any AMD box)
> > 
> > You could have a look at how oprofile works on your box - the 
> > code for PII CPUs should be in 
> > arch/x86/oprofile/op_model_ppro.c.
> > 
> > There's also hardcoded support for a single perfcounter in the 
> > nmi_watchdog=2 code, in arch/x86/kernel/cpu/perfctr-watchdog.c, 
> > for pretty much any x86 CPU that has a PMU.
> > 
> > Plus there's also the CPU documentation on Intel's site. It's 
> > quite well written and pretty well structured. The URL for the 
> > CPU's PMU ("Performance Monitoring") should be:
> > 
> >   http://download.intel.com/design/processor/manuals/253669.pdf
> > 
> > As a last resort ;-)
> > 
> > 	Ingo
> 
> Ah yes, That could be fun!
> So, by reading your description, it should work on my labtop I guess?
>
> -> Intel(R) Pentium(R) Dual  CPU  T2310  @ 1.46GHz

Yeah, should work fine there - so that should be a good 
reference point to start off. Let me know if you see any 
bugs/problems.

> Anyway, I will give it a try and see what I can do.
> Thanks for the pointers.

You are welcome.

	Ingo
