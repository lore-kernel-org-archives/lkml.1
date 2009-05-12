Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbZELUDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbZELUDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 16:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZELUDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 16:03:08 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42241 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZELUDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 16:03:05 -0400
Date: Wed, 13 May 2009 01:32:54 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Patch 11/12] ftrace plugin for kernel symbol tracing
	usingHWBreakpoint interfaces - v4
Message-ID: <20090512200254.GD6033@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090511114422.133566343@prasadkr_t60p.in.ibm.com> <20090511115502.GL25673@in.ibm.com> <20090511221427.GB5965@nowhere> <20090512141944.GB6033@in.ibm.com> <20090512151504.GB6255@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512151504.GB6255@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 05:15:05PM +0200, Frederic Weisbecker wrote:
> On Tue, May 12, 2009 at 07:49:44PM +0530, K.Prasad wrote:
> > On Tue, May 12, 2009 at 12:14:29AM +0200, Frederic Weisbecker wrote:
> > > On Mon, May 11, 2009 at 05:25:02PM +0530, K.Prasad wrote:
> > > 
> > > > +static int ksym_trace_init(struct trace_array *tr)
> > > > +{
> > > > +	int cpu, ret = 0;
> > > > +
> > > > +	for_each_online_cpu(cpu)
> > > > +		tracing_reset(tr, cpu);
> > > > +
> > > > +	ksym_tracing_enabled = 1;
> > > > +	ksym_trace_array = tr;
> > > > +
> > > > +#ifdef CONFIG_FTRACE_SELFTEST
> > > > +	/* Check if we are re-entering self-test code during initialisation */
> > > > +	if (ksym_selftest_dummy)
> > > > +		goto ret_path;
> > > > +
> > > > +	ksym_selftest_dummy = 0;
> > > > +
> > > > +	/* Register the read-write tracing request */
> > > > +	ret = process_new_ksym_entry(KSYM_SELFTEST_ENTRY, HW_BREAKPOINT_RW,
> > > > +					(unsigned long)(&ksym_selftest_dummy));
> > > > +
> > > > +	if (ret < 0) {
> > > > +		printk(KERN_CONT "ksym_trace read-write startup test failed\n");
> > > > +		goto ret_path;
> > > > +	}
> > > > +	/* Perform a read and a write operation over the dummy variable to
> > > > +	 * trigger the tracer
> > > > +	 */
> > > > +	if (ksym_selftest_dummy == 0)
> > > > +		ksym_selftest_dummy++;
> > > > +ret_path:
> > > > +#endif /* CONFIG_FTRACE_SELFTEST */
> > > 
> > > 
> > > It means that each time your tracer is selected, it will perform a selftest.
> > > I think we only need this selftest once during the boot.
> > > I would rather see that in the real selftest callback (trace_selftest_startup_kysm).
> > >
> > 
> > > > +   if (ksym_selftest_dummy)
> > > > +           goto ret_path;
> > 
> > The above check will help prevent a re-run of the test everytime init is
> > executed.
> > 
> > A part of the selftest was kept in trace_ksym.c (and hence in
> > ksym_trace_init()) in order to use functions local to this file, such as
> > process_new_ksym_entry().
> 
> 
> 
> Ok.
> May be you could just compute your selftests on the breakpoint themselves,
> not on the entries in the ring buffer.
> 
> That's what do other tracers because it's usually convenient, but the main
> focuse is the event itself, because the ring buffer is already tested.
> The only thing you need to test is the hardware breakpoint triggering, then
> you wouldn't need anymore the trace_selftest.c helpers and you could
> implement your selftest directly in your tracer file.
> 
> I remember such thing has been discussed recently but I'm not sure
> whether it concerned the kprobe tracer or yours.
>

I agree that the ring buffer infrastructure need not be tested itself,
but to just check the trigger of HW Breakpoint without populating the
ring buffer will need a new breakpoint handler defined exclusively for
startup self-test, or additional checks in ksym_hbp_handler() that
executes everytime for normal exceptions too.

I will move all code from ksym_trace_init() to
trace_selftest_startup_kysm() though.

Thanks,
K.Prasad

