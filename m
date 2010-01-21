Return-Path: <linux-kernel-owner+w=401wt.eu-S932161Ab0AUTeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab0AUTeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 14:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130Ab0AUTeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 14:34:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:32977 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab0AUTeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 14:34:19 -0500
X-Authority-Analysis: v=1.0 c=1 a=LvvgB44tUwgA:10 a=7U3hwN5JcxgA:10 a=OIjbozEIWfTmjb7YNkQA:9 a=kQ4WGFup1W9nbtoZGogA:7 a=gu0YGKBbomRPw-43JY4RNGwHwlwA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Lots of bugs with current->state = TASK_*INTERRUPTIBLE
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: David Daney <ddaney@caviumnetworks.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Greg KH <greg@kroah.com>, Andy Whitcroft <apw@canonical.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       linux-mips <linux-mips@linux-mips.org>
In-Reply-To: <4B58A89A.8050405@caviumnetworks.com>
References: <1263932978.31321.53.camel@gandalf.stny.rr.com>
	 <4B58A89A.8050405@caviumnetworks.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 21 Jan 2010 14:34:15 -0500
Message-ID: <1264102455.31321.293.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 11:18 -0800, David Daney wrote:
> Steven Rostedt wrote:
> > Peter Zijlstra and I were doing a look over of places that assign
> > current->state = TASK_*INTERRUPTIBLE, by simply looking at places with:
> > 
> >  $ git grep -A1 'state[[:space:]]*=[[:space:]]*TASK_[^R]'
> > 
> > and it seems there are quite a few places that looks like bugs. To be on
> > the safe side, everything outside of a run queue lock that sets the
> > current state to something other than TASK_RUNNING (or dead) should be
> > using set_current_state().
> > 
> > 	current->state = TASK_INTERRUPTIBLE;
> > 	schedule();
> > 
> > is probably OK, but it would not hurt to be consistent. Here's a few
> > examples of likely bugs:
> > 
> [...]
> 
> This may be a bit off topic, but exactly which type of barrier should 
> set_current_state() be implying?
> 
> On MIPS, set_mb() (which is used by set_current_state()) has a full mb().
> 
> Some MIPS based processors have a much lighter weight wmb().  Could 
> wmb() be used in place of mb() here?

Nope, wmb() is not enough. Below is an explanation.

> 
> If not, an explanation of the required memory ordering semantics here 
> would be appreciated.
> 
> I know the documentation says:
> 
>      set_current_state() includes a barrier so that the write of
>      current->state is correctly serialised wrt the caller's subsequent
>      test of whether to actually sleep:
> 
>   	set_current_state(TASK_UNINTERRUPTIBLE);
>   	if (do_i_need_to_sleep())
>   		schedule();
> 
> 
> Since the current CPU sees the memory accesses in order, what can be 
> happening on other CPUs that would require a full mb()?

Lets look at a hypothetical situation with:

	add_wait_queue();
	current->state = TASK_UNINTERRUPTIBLE;
	smp_wmb();
	if (!x)
		schedule();



Then somewhere we probably have:

	x = 1;
	smp_wmb();
	wake_up(queue);



	   CPU 0			   CPU 1
	------------			-----------
	add_wait_queue();
	(cpu pipeline sees a load
	 of x ahead, and preloads it)
					x = 1;
					smp_wmb();
					wake_up(queue);
					(task on CPU 0 is still at
					 TASK_RUNNING);

	current->state = TASK_INTERRUPTIBLE;
	smp_wmb(); <<-- does not prevent early loading of x
	if (!x)  <<-- returns true
		schedule();

Now the task on CPU 0 missed the wake up.

Note, places that call schedule() are not fast paths, and probably not
called often. Adding the overhead of smp_mb() to ensure correctness is a
small price to pay compared to search for why you have a stuck task that
was never woken up.

Read Documentation/memory-barriers.txt, it will be worth the time you
spend doing so.

-- Steve


