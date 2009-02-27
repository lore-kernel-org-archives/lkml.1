Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbZB0Pat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbZB0Pat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 10:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbZB0Pak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 10:30:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64166 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbZB0Pak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 10:30:40 -0500
Date: Fri, 27 Feb 2009 10:30:37 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arjan van de Ven <arjan@infradead.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, jonathan@jonmasters.org
Subject: Re: [patch 4/4] genirq: add support for threaded interrupt
 handlers
In-Reply-To: <20090227070633.2c3fc04e@infradead.org>
Message-ID: <alpine.DEB.2.00.0902271024160.25593@gandalf.stny.rr.com>
References: <20090226131336.423054348@linutronix.de> <20090226131719.760899560@linutronix.de> <20090226153216.5db66bc3.akpm@linux-foundation.org> <20090226212752.332ba546@infradead.org> <20090226214514.f8a58731.akpm@linux-foundation.org> <1235719113.4948.1252.camel@laptop>
 <20090226234800.4977fca5.akpm@linux-foundation.org> <1235721910.4948.1321.camel@laptop> <20090227070633.2c3fc04e@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 27 Feb 2009, Arjan van de Ven wrote:

> On Fri, 27 Feb 2009 09:05:10 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > 
> > Right, Thomas did the EHCI usb driver, the network driver you propose
> > is a tad hard since it relies on the whole network stack softirq
> > stuff. Re-working the whole net-stack to make use of threaded
> > handlers is a massive undertaking -- although I seem to remember
> > someone doing it a few years back and seeing a general performance
> > improvement, Thomas still got a link to that work?
> 
> 
> we shouldn't have to; just running the softirq handler from the irq
> thread should work, and not lose real performance.
> Sure you're not going to get a performance gain that you could get
> but it still works.
> or am I missing something?

The way softirqs are currently designed, you can not run them from
the irq thread. We discovered this (the hard way) in the preempt-rt 
kernel. The issue is that each softirq (threaded in preempt-rt, with a 
thread for every CPU. ie. net-rx/0 net-rx/1 net-rx/2 net-rx/3 for a 4 CPU 
box) is bound to a specific CPU. The design is to modify per cpu data. If 
a IRQ thread were to run the softirq code and migrate to another CPU, you 
will have very hard to debug crashes on your hands.

We also tried to bind the IRQ thread to the CPU if it were to run a 
softirq. But that too had issues. If the IRQ thread was bound to a CPU and 
a higher priority process preempted it, that IRQ handler could not migrate 
to another CPU to finish the work. Now the IRQ handler would need to wait 
for that high priority process to give up the CPU in order to continue.

The solution is to redesign the softirq code to handle migration.

-- Steve



> 
> (and esp for things like wireless drivers, that should be just fine; I
> can understand hesitation to do 10g ethernet drivers right away ;-)
> 
> 
> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org
> 
