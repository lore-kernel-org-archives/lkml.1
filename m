Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZCUQYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZCUQYh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 12:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZCUQY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 12:24:28 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:59984 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbZCUQY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 12:24:27 -0400
Date: Sat, 21 Mar 2009 21:54:17 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Patch 11/11] ftrace plugin for kernel symbol tracing using HW
	Breakpoint interfaces - v2
Message-ID: <20090321162417.GA9906@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090319234044.410725944@K.Prasad> <20090319235032.GL10517@in.ibm.com> <20090320090451.GC7820@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320090451.GC7820@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 10:04:52AM +0100, Frederic Weisbecker wrote:
> On Fri, Mar 20, 2009 at 05:20:32AM +0530, K.Prasad wrote:
> > This patch adds an ftrace plugin to detect and profile memory access over
> > kernel variables. It uses HW Breakpoint interfaces to 'watch memory
> > addresses.
> > 
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com> 
> > ---
> >  kernel/trace/Kconfig          |   21 +
> >  kernel/trace/Makefile         |    1 
> >  kernel/trace/trace.h          |   25 +
> >  kernel/trace/trace_ksym.c     |  555 ++++++++++++++++++++++++++++++++++++++++++
> >  kernel/trace/trace_selftest.c |   36 ++
> >  5 files changed, 638 insertions(+)
> > 

> > +
> > +void ksym_collect_stats(unsigned long hbkpt_hit_addr)
> > +{
> > +	struct hlist_node *node;
> > +	struct trace_ksym *entry;
> > +
> > +	spin_lock(&ksym_stat_lock);
> 
> 
> I see that can be called from ksym_hbkpt_handler which in turn
> can be called from interrupt context, right?
> You can issue a deadlock if you don't disable interrupts here.
> 
> Thanks,
> Frederic.
> 

ksym_collect_stats<--ksym_hbkpt_handler<--hw_breakpoint_handler<--do_debug
invocation happens with interrupts enabled (IF bit is set). I do find
that a few plugins in kernel/trace enclose the
trace_buffer_lock_reserve()--trace_buffer_unlock_commit() invocation
within interrupt-disabled code. Is that a requirement there?

The potential deadlock scenario you foresee isn't obvious to me. Can you
explain?

Thanks,
K.Prasad

