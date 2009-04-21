Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbZDUNNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbZDUNNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 09:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbZDUNNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 09:13:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54859 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZDUNNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 09:13:07 -0400
Date: Tue, 21 Apr 2009 09:13:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Tim Abbott <tabbott@mit.edu>
Subject: Re: [PATCH 1/5] ftrace: use module notifier for function tracer
In-Reply-To: <200904211445.42812.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.2.00.0904210910320.10097@gandalf.stny.rr.com>
References: <20090416021830.556671772@goodmis.org> <200904192055.04213.rusty@rustcorp.com.au> <alpine.DEB.2.00.0904200942350.15439@gandalf.stny.rr.com> <200904211445.42812.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 21 Apr 2009, Rusty Russell wrote:

> On Mon, 20 Apr 2009 11:27:35 pm Steven Rostedt wrote:
> > 
> > On Sun, 19 Apr 2009, Rusty Russell wrote:
> > 
> > > On Thu, 16 Apr 2009 11:48:31 am Steven Rostedt wrote:
> > > > From: Steven Rostedt <srostedt@redhat.com>
> > > > 
> > > > Impact: fix and clean up
> > > > 
> > > > The hooks in the module code for the function tracer must be called
> > > > before any of that module code runs. The function tracer hooks
> > > > modify the module (replacing calls to mcount to nops). If the code
> > > > is executed while the change occurs, then the CPU can take a GPF.
> > > > 
> > > > To handle the above with a bit of paranoia, I originally implemented
> > > > the hooks as calls directly from the module code.
> > > > 
> > > > After examining the notifier calls, it looks as though the start up
> > > > notify is called before any of the module's code is executed. This makes
> > > > the use of the notify safe with ftrace.
> > > 
> > > Hi Steven,
> > > 
> > >    Unfortunately not: we do parse_args, which can call into the module code.
> > > (Though it shouldn't do anything "significant", as it won't get a chance to
> > > clean up if module load fails later).
> > > 
> > > I think you need to do something else in general.  Share the module_mutex for
> > > the ftrace code?  The ksplice guys have a similar issue, so maybe we should
> > > generalize this into a "kernel_text" mutex?
> > 
> > Hi Rusty,
> > 
> > Thanks, for the update. I think we may still be OK.
> 
> Agreed, just wanted to make sure you were aware.
>  
> > Can those parse_args kick off threads? Hmm, probably. Sounds nasty to 
> > me.
> 
> Not without a bug.  Imagine you have a "create_threads" module_param, someone
> loads the module with two args "create_threads crap".  We call the
> create_threads parse function via parse_args, then hit the crap parameter
> and free the module.  Oops.
> 
> > The other thing is, if the parse_args code is only in "__init" then they 
> > also will not be touched.
> 
> It can be non-init for sysfs access.
> 
> FWIW:
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks Rusty!

Ingo,

This change also fixes a possible deadlock in mainline between the 
ftrace_lock and the module_mutex. Perhaps we should push this to Linus?

The possible deadlock is if a user unloads/loads modules at the same time 
starts the function graph tracer. Highly unlikely to happen, but it does 
spit out a lockdep warning.

-- Steve

