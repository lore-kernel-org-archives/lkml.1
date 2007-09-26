Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbXIZEjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbXIZEjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 00:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbXIZEjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 00:39:40 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49912 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbXIZEjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 00:39:39 -0400
Date: Wed, 26 Sep 2007 10:09:33 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Avishay Traeger <atraeger@cs.sunysb.edu>
Cc: prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: KPROBES: Instrumenting a function's call site
Message-ID: <20070926043933.GA6460@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1190758358.30061.13.camel@rockstar.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190758358.30061.13.camel@rockstar.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 06:12:38PM -0400, Avishay Traeger wrote:
> Hello,
> I am trying to use kprobes to measure the latency of a function by
> instrumenting its call site.  Basically, I find the call instruction,
> and insert a kprobe with a pre-handler and post-handler at that point.
> The pre-handler measures the latency (reads the TSC counter).  The
> post-handler measures the latency again, and subtracts the value that
> was read in the pre-handler to compute the total latency of the called
> function.

This sounds ok...

> So to measure the latency of foo(), I basically want kprobes to do this:
> pre_handler();
> foo();
> post_handler();
> 
> The problem is that the latencies that I am getting are consistently low
> (~10,000 cycles).  When I manually instrument the functions, the latency
> is about 20,000,000 cycles.  Clearly something is not right here.

Is foo() called from too many different places? If so, are you
interested with only the invocation of foo() from a specific callsite?
 
> Is this a known issue?  Instead of using the post-handler, I can try to
> add a kprobe to the following instruction with a pre-handler.  I was
> just curious if there was something fundamentally wrong with the
> approach I took, or maybe a bug that you should be made aware of.

I am not too sure... single-stepping a "call" instruction from a
different memory location (single-stepping out of line) requires some
fixups and kprobes handles such fixups just fine (see resume_execution()
in arch/<arch>/kernel/kprobes.c)

You could try a a couple of approaches for starters.

a. As you mention above, a kprobe on the function invocation and the
other on the instruction following the call; both need just pre_handlers. 

b.
- Insert a kprobe and a kretprobe on foo()
- The kprobe needs to have only a pre_handler that'll measure the latency
- A similar handler for the kretprobe handler can measure the latency
again and their difference will give you foo()'s latency.

<b> though will require you to do some housekeeping in case foo() is
reentrant to track which return instance corresponds to which call.

Ananth

PS: There was a thought of providing a facility to run a handler at
function entry even when just a kretprobe is used. Maybe we need to
relook at that; it'd have been useful in this case.
