Return-Path: <linux-kernel-owner+w=401wt.eu-S1751705AbZDUFQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbZDUFQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 01:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbZDUFPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 01:15:54 -0400
Received: from ozlabs.org ([203.10.76.45]:35255 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbZDUFPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 01:15:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/5] ftrace: use module notifier for function tracer
Date: Tue, 21 Apr 2009 14:45:41 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Tim Abbott <tabbott@mit.edu>
References: <20090416021830.556671772@goodmis.org> <200904192055.04213.rusty@rustcorp.com.au> <alpine.DEB.2.00.0904200942350.15439@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0904200942350.15439@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904211445.42812.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 11:27:35 pm Steven Rostedt wrote:
> 
> On Sun, 19 Apr 2009, Rusty Russell wrote:
> 
> > On Thu, 16 Apr 2009 11:48:31 am Steven Rostedt wrote:
> > > From: Steven Rostedt <srostedt@redhat.com>
> > > 
> > > Impact: fix and clean up
> > > 
> > > The hooks in the module code for the function tracer must be called
> > > before any of that module code runs. The function tracer hooks
> > > modify the module (replacing calls to mcount to nops). If the code
> > > is executed while the change occurs, then the CPU can take a GPF.
> > > 
> > > To handle the above with a bit of paranoia, I originally implemented
> > > the hooks as calls directly from the module code.
> > > 
> > > After examining the notifier calls, it looks as though the start up
> > > notify is called before any of the module's code is executed. This makes
> > > the use of the notify safe with ftrace.
> > 
> > Hi Steven,
> > 
> >    Unfortunately not: we do parse_args, which can call into the module code.
> > (Though it shouldn't do anything "significant", as it won't get a chance to
> > clean up if module load fails later).
> > 
> > I think you need to do something else in general.  Share the module_mutex for
> > the ftrace code?  The ksplice guys have a similar issue, so maybe we should
> > generalize this into a "kernel_text" mutex?
> 
> Hi Rusty,
> 
> Thanks, for the update. I think we may still be OK.

Agreed, just wanted to make sure you were aware.
 
> Can those parse_args kick off threads? Hmm, probably. Sounds nasty to 
> me.

Not without a bug.  Imagine you have a "create_threads" module_param, someone
loads the module with two args "create_threads crap".  We call the
create_threads parse function via parse_args, then hit the crap parameter
and free the module.  Oops.

> The other thing is, if the parse_args code is only in "__init" then they 
> also will not be touched.

It can be non-init for sysfs access.

FWIW:
Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
