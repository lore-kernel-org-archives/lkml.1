Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbZCUQjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbZCUQjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZCUQjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:39:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48869 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZCUQjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:39:11 -0400
Date: Sat, 21 Mar 2009 12:39:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 11/11] ftrace plugin for kernel symbol tracing using HW
 Breakpoint interfaces - v2
In-Reply-To: <20090321162417.GA9906@in.ibm.com>
Message-ID: <alpine.DEB.2.00.0903211235390.13615@gandalf.stny.rr.com>
References: <20090319234044.410725944@K.Prasad> <20090319235032.GL10517@in.ibm.com> <20090320090451.GC7820@nowhere> <20090321162417.GA9906@in.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 21 Mar 2009, K.Prasad wrote:
> > > 
> 
> > > +
> > > +void ksym_collect_stats(unsigned long hbkpt_hit_addr)
> > > +{
> > > +	struct hlist_node *node;
> > > +	struct trace_ksym *entry;
> > > +
> > > +	spin_lock(&ksym_stat_lock);
> > 
> > 
> > I see that can be called from ksym_hbkpt_handler which in turn
> > can be called from interrupt context, right?
> > You can issue a deadlock if you don't disable interrupts here.
> > 
> > Thanks,
> > Frederic.
> > 
> 
> ksym_collect_stats<--ksym_hbkpt_handler<--hw_breakpoint_handler<--do_debug
> invocation happens with interrupts enabled (IF bit is set). I do find
> that a few plugins in kernel/trace enclose the
> trace_buffer_lock_reserve()--trace_buffer_unlock_commit() invocation
> within interrupt-disabled code. Is that a requirement there?
> 
> The potential deadlock scenario you foresee isn't obvious to me. Can you
> explain?

Can that lock ever be taken in an interrupt? If not, document that (and 
perhaps add a WARN_ON(in_interrupt()); ). Otherwise you have a possible:

	spin_lock(&ksym_stat_lock);

		===> take interrupt ...

			(from interrupt)
			spin_lock(&ksym_stat_lock); <== deadlock.


-- Steve

