Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbXIZRhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbXIZRhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 13:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbXIZRhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 13:37:31 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:39138 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbXIZRha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 13:37:30 -0400
Subject: Re: KPROBES: Instrumenting a function's call site
From: Avishay Traeger <atraeger@cs.sunysb.edu>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>, prasanna@in.ibm.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070926172856.GA22038@askeshav-devel.jf.intel.com>
References: <1190758358.30061.13.camel@rockstar.fsl.cs.sunysb.edu>
	 <20070926043933.GA6460@in.ibm.com>
	 <20070926172856.GA22038@askeshav-devel.jf.intel.com>
Content-Type: text/plain
Date: Wed, 26 Sep 2007 13:37:08 -0400
Message-Id: <1190828228.16768.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 10:28 -0700, Keshavamurthy, Anil S wrote:
> On Wed, Sep 26, 2007 at 10:09:33AM +0530, Ananth N Mavinakayanahalli wrote:
> > On Tue, Sep 25, 2007 at 06:12:38PM -0400, Avishay Traeger wrote:
> > > Hello,
> > > I am trying to use kprobes to measure the latency of a function by
> > > instrumenting its call site.  Basically, I find the call instruction,
> > > and insert a kprobe with a pre-handler and post-handler at that point.
> > > The pre-handler measures the latency (reads the TSC counter).  The
> > > post-handler measures the latency again, and subtracts the value that
> > > was read in the pre-handler to compute the total latency of the called
> > > function.
> > 
> > This sounds ok...
> 
> So what you are really measuring is the latency of just that single 
> instruction where you have inserted the probe i.e. because your
> pre-handler is called just before the probed instruction is executed and
> your post-handler is called right after you probed instruction is single-stepped.

Exactly - I want to profile that single instance of the call.

> > 
> > > So to measure the latency of foo(), I basically want kprobes to do this:
> > > pre_handler();
> > > foo();
> When you insert a probe, you are inserting  probe on an instruction boundary
> and not at function level.
> > > post_handler();
> 
> Hence the above looks like
> 
> pre-handler()
> Probed-instruction; // most likely the first instruction in the foo();
> post-hanlder()
> rest-of-foo()

I see.

> > > 
> > > The problem is that the latencies that I am getting are consistently low
> > > (~10,000 cycles).  When I manually instrument the functions, the latency
> > > is about 20,000,000 cycles.  Clearly something is not right here.
> As I mentioned above what you are seeing is the latency of just the
> probed instruction and hence it is very very low compared to
> the latency of the function foo().
> 
> > You could try a a couple of approaches for starters.
> I agree with Ananth, you can try the below approaches
> for your measurements.
> 
> > 
> > a. As you mention above, a kprobe on the function invocation and the
> > other on the instruction following the call; both need just pre_handlers. 
> > 
> > b.
> > - Insert a kprobe and a kretprobe on foo()
> > - The kprobe needs to have only a pre_handler that'll measure the latency
> > - A similar handler for the kretprobe handler can measure the latency
> > again and their difference will give you foo()'s latency.
> > 
> > <b> though will require you to do some housekeeping in case foo() is
> > reentrant to track which return instance corresponds to which call.
> > 
> > Ananth
> > 
> > PS: There was a thought of providing a facility to run a handler at
> > function entry even when just a kretprobe is used. Maybe we need to
> > relook at that; it'd have been useful in this case.

Thanks for the clarifications!

Avishay

