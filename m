Return-Path: <linux-kernel-owner+w=401wt.eu-S1758430AbXKLK15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430AbXKLK15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 05:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757098AbXKLK1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 05:27:49 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34736 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043AbXKLK1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 05:27:48 -0500
Date: Mon, 12 Nov 2007 15:57:34 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Avishay Traeger <atraeger@cs.sunysb.edu>
Cc: prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org,
       Ivan de Jesus Deras Tabora <ideras@gmail.com>
Subject: Re: KPROBES: Instrumenting a function's call site
Message-ID: <20071112102734.GA18341@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1190758358.30061.13.camel@rockstar.fsl.cs.sunysb.edu> <20070926043933.GA6460@in.ibm.com> <1194550953.22695.15.camel@rockstar.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194550953.22695.15.camel@rockstar.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 02:42:33PM -0500, Avishay Traeger wrote:
> Sorry for reviving a thread from two months ago... :)
> 
> On Wed, 2007-09-26 at 10:09 +0530, Ananth N Mavinakayanahalli wrote:
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
> > 
> > > So to measure the latency of foo(), I basically want kprobes to do this:
> > > pre_handler();
> > > foo();
> > > post_handler();
> > > 
> > > The problem is that the latencies that I am getting are consistently low
> > > (~10,000 cycles).  When I manually instrument the functions, the latency
> > > is about 20,000,000 cycles.  Clearly something is not right here.
> > 
> > Is foo() called from too many different places? If so, are you
> > interested with only the invocation of foo() from a specific callsite?
> >  
> > > Is this a known issue?  Instead of using the post-handler, I can try to
> > > add a kprobe to the following instruction with a pre-handler.  I was
> > > just curious if there was something fundamentally wrong with the
> > > approach I took, or maybe a bug that you should be made aware of.
> > 
> > I am not too sure... single-stepping a "call" instruction from a
> > different memory location (single-stepping out of line) requires some
> > fixups and kprobes handles such fixups just fine (see resume_execution()
> > in arch/<arch>/kernel/kprobes.c)
> > 
> > You could try a a couple of approaches for starters.
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
> 
> The approach that we took until now is (a):
> 
> kprobe1.pre_handler();
> foo();
> kprobe2.pre_handler();
> 
> However, my colleague Ivan has come up with another approach that I
> think it pretty novel:
> - kprob1.pre-handler is placed at the call site as before.
> - A post-handler is also added to this same kprobe, which saves foo's
> return value, and modifies it to point to a new function.  This new
> function contains the code that used to be in kprobe2.pre_handler
> (reading the TSC register a second time and computing the latency).
> This new function then returns to the original return location.

Modifying the return address is analogous to how kretprobes are
implemented.

> The only caveat is that to handle recursion, you need to save a stack of
> return addresses.
> 
> This has 2 main benefits:
> 1. It guarantees that the code contained in the second kprobe is
> executed only when the first is (in case there is a jump in the code to
> the location of the 2nd kprobe).
> 2. We only need one kprobe instead of two, which speeds things up.
> 
> We have tested this, and it works great.  Just wanted to let you know
> about this technique in case this issue comes up again.

Thanks! Maybe it'll be useful if you could code this up as an
independent module and post it to lkml so others can use it? If its
deemed useful, we could add it to the kprobes samples/ modules.

> Have you ever seen kprobes used in this way?

I've heard of people doing things similar to what you've described. (I
think someone had also implemented a "hot-patching" mechanism too, using
kprobes).

Ananth
