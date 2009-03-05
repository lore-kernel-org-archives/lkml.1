Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbZCEOCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbZCEOCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZCEOBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:01:53 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:19281 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbZCEOBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:01:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sjEc/XhMDbtyrsvXn7Q+yrbxWpKIrbsZR/pO7L78HeQZhNcTupqLY0IF3Mm/jStGoV
         rswOJKMb7FgMJOfDSecS63tIyzrELBGQCUIGZ+qUbq02/gZynA7aZlsNqpr1rnBFWj73
         v6sy07lzIshmT2OtIRHQoDEoMn8DNISAp2lsA=
Date: Thu, 5 Mar 2009 15:01:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: use the more
	lightweight local clock
Message-ID: <20090305140141.GK5359@nowhere>
References: <49af243d.06e9300a.53ad.ffff840c@mx.google.com> <20090305011941.GA9821@nowhere> <1236238213.5330.10111.camel@laptop> <20090305084639.GC5359@nowhere> <20090305105652.GG32407@elte.hu> <20090305111646.GG5359@nowhere> <20090305115652.GA18745@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305115652.GA18745@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 12:56:52PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Thu, Mar 05, 2009 at 11:56:52AM +0100, Ingo Molnar wrote:
> > > 
> > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > 
> > > > On Thu, Mar 05, 2009 at 08:30:13AM +0100, Peter Zijlstra wrote:
> > > > > On Thu, 2009-03-05 at 02:19 +0100, Frederic Weisbecker wrote:
> > > > > 
> > > > > > It takes 1 ms to execute while tracing.
> > > > > > Considering my frequency is 250 Hz, it means 1/4 of the system is used
> > > > > > on timer interrupt while tracing.
> > > > > > 
> > > > > > For now the hang is fixed, but not the awful latency. And I'm just too frightened
> > > > > > to test it on 1000 Hz.
> > > > > > 
> > > > > > But I plan to add a kind of watchdog to check how many time we spent inside an
> > > > > > interrupt while graph tracing.
> > > > > > By checking this time against the current Hz value, I could decide to abort the tracing
> > > > > > for all irq.
> > > > > 
> > > > > That would basically render the thing useless :-(
> > > > 
> > > > 
> > > > It would be only for slow machines :-)
> > > > I'm talking about something that happened on a Pentium II.
> > > > 
> > > >  
> > > > > Is it specifically function_graph that is so expensive? If so, is that
> > > > > because of the function exit hook?
> > > > 
> > > > 
> > > > Yes, specifically the function_graph, the function tracer is 
> > > > not concerned. The function graph tracer takes more than 
> > > > double overhead compared to the function tracer.
> > > > 
> > > > Usually the function tracer hooks directly the the function 
> > > > that insert the event, it's pretty straightforward.
> > > > 
> > > > The function graph does much more work: 
> > > > 
> > > > entry: basic checks, take the time, push the infos on the stack, insert an event
> > > >        on the ring-buffer, hook the return value.
> > > > return: pop the infos from stack, insert an event on the ring-buffer, jump
> > > >         to the original caller.
> > > > 
> > > > It has a high cost... which makes me sad because I plan to 
> > > > port it in on Arm and I fear the little Arm boad I recently 
> > > > purshased will not let me trace the interrupts without 
> > > > hanging...
> > > > :-(
> > > > 
> > > > I guess I should start thinking on some optimizations, perhaps 
> > > > using perfcounter?
> > > 
> > > yeah. perfcounters and KernelTop might not work on a PII CPU out 
> > > of box though.
> > > 
> > > But hacking perfcounters and looking at perfstat/kerneltop 
> > > output is serious amount of fun so if you are interested you 
> > > could try to implement support for it. Do you have any box where 
> > > perfcounters work? (that would be Core2 Intel boxes or pretty 
> > > much any AMD box)
> > > 
> > > You could have a look at how oprofile works on your box - the 
> > > code for PII CPUs should be in 
> > > arch/x86/oprofile/op_model_ppro.c.
> > > 
> > > There's also hardcoded support for a single perfcounter in the 
> > > nmi_watchdog=2 code, in arch/x86/kernel/cpu/perfctr-watchdog.c, 
> > > for pretty much any x86 CPU that has a PMU.
> > > 
> > > Plus there's also the CPU documentation on Intel's site. It's 
> > > quite well written and pretty well structured. The URL for the 
> > > CPU's PMU ("Performance Monitoring") should be:
> > > 
> > >   http://download.intel.com/design/processor/manuals/253669.pdf
> > > 
> > > As a last resort ;-)
> > > 
> > > 	Ingo
> > 
> > Ah yes, That could be fun!
> > So, by reading your description, it should work on my labtop I guess?
> >
> > -> Intel(R) Pentium(R) Dual  CPU  T2310  @ 1.46GHz
> 
> Yeah, should work fine there - so that should be a good 
> reference point to start off. Let me know if you see any 
> bugs/problems.
> 
> > Anyway, I will give it a try and see what I can do.
> > Thanks for the pointers.
> 
> You are welcome.
> 
> 	Ingo

Ho, that's impressive:

$ ./perfstat /bin/echo 1
1

 Performance counter stats for '/bin/echo':

       5.681909  task clock ticks     (msecs)

              2  CPU migrations       (events)
              9  context switches     (events)
            422  pagefaults           (events)
        4986950  CPU cycles           (events)
        4870587  instructions         (events)
          62881  cache references     (events)
           4882  cache misses         (events)

 Wall-clock time elapsed:     9.046821 msecs


So I guess that for it to be useful on fine grained profiling,
it's better to include the percounters syscalls inside the application
to profile a single function for example?

I've parsed a bit the intel documentation and perfcounters source code.
It looks like the current implementation for intel and amd share enough similar
properties so that they have been factorized in a single file.

This similar property is the use of an msr, while P6 family use the pmc.

Perhaps I can expand the struct pmc_x86_ops to guess whether we want to use
rdmsr or rdpmc.

Hmm it seems the implementation would be enough different to deserve a new file for
P6.
Will see...

