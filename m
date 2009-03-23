Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbZCWTIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbZCWTIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759330AbZCWTIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:08:15 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57718 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbZCWTIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:08:13 -0400
Date: Tue, 24 Mar 2009 00:38:00 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 11/11] ftrace plugin for kernel symbol tracing using HW
	Breakpoint interfaces - v2
Message-ID: <20090323190800.GA12442@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090319234044.410725944@K.Prasad> <20090319235032.GL10517@in.ibm.com> <20090320090451.GC7820@nowhere> <20090321162417.GA9906@in.ibm.com> <alpine.DEB.2.00.0903211235390.13615@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903211235390.13615@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 12:39:08PM -0400, Steven Rostedt wrote:
> 
> On Sat, 21 Mar 2009, K.Prasad wrote:
> > > > 
> > 
> > > > +
> > > > +void ksym_collect_stats(unsigned long hbkpt_hit_addr)
> > > > +{
> > > > +	struct hlist_node *node;
> > > > +	struct trace_ksym *entry;
> > > > +
> > > > +	spin_lock(&ksym_stat_lock);
> > > 
> > > 
> > > I see that can be called from ksym_hbkpt_handler which in turn
> > > can be called from interrupt context, right?
> > > You can issue a deadlock if you don't disable interrupts here.
> > > 
> > > Thanks,
> > > Frederic.
> > > 
> > 
> > ksym_collect_stats<--ksym_hbkpt_handler<--hw_breakpoint_handler<--do_debug
> > invocation happens with interrupts enabled (IF bit is set). I do find
> > that a few plugins in kernel/trace enclose the
> > trace_buffer_lock_reserve()--trace_buffer_unlock_commit() invocation
> > within interrupt-disabled code. Is that a requirement there?
> > 
> > The potential deadlock scenario you foresee isn't obvious to me. Can you
> > explain?
> 
> Can that lock ever be taken in an interrupt? If not, document that (and 
> perhaps add a WARN_ON(in_interrupt()); ). Otherwise you have a possible:
> 
> 	spin_lock(&ksym_stat_lock);
> 
> 		===> take interrupt ...
> 
> 			(from interrupt)
> 			spin_lock(&ksym_stat_lock); <== deadlock.
> 
> 
> -- Steve
>

Given that the function pointed by the trigger() routine is invoked with
breakpoints disabled on that CPU, I don't think we'd enter into a loop
a cyclic dependancy as above.

On the other hand, my observation w.r.t. IF bit being set was misplaced
in the sense that it corresponded to the saved stack and not when inside
the breakpoint handler in which case interrupts were disabled.

So we are safe in either ways.

Thanks,
K.Prasad
 
