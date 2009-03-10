Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbZCJQ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbZCJQ7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbZCJQ7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:59:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39480 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbZCJQ7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:59:06 -0400
Date: Tue, 10 Mar 2009 17:58:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 06/11] Use virtual debug registers in process/thread
	handling code
Message-ID: <20090310165828.GA22897@elte.hu>
References: <20090310144933.GH3850@elte.hu> <Pine.LNX.4.44L0.0903101155000.3979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903101155000.3979-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 10 Mar 2009, Ingo Molnar wrote:
> 
> > > @@ -595,6 +596,12 @@ __switch_to(struct task_struct *prev_p, 
> > >  
> > >  	percpu_write(current_task, next_p);
> > >  
> > > +	/*
> > > +	 * Handle debug registers.  This must be done _after_ current
> > > +	 * is updated.
> > > +	 */
> > > +	if (unlikely(test_tsk_thread_flag(next_p, TIF_DEBUG)))
> > > +		switch_to_thread_hw_breakpoint(next_p);
> > 
> > why does this have to be called after 'current' has been 
> > updated? AFAICS switch_to_thread_hw_breakpoint() does not take a 
> > look at 'current'.
> 
> There was a discussion about this on LKML last October 17, and 
> you were in the CC list. [...]

I am on the Cc: list of thousands of messages per month. 
Consider it a very volatile form of storage.

Instead put these:

> There's a problem with moving the 
> switch_to_thread_hw_breakpoint() call before current is 
> updated.  Suppose a kernel breakpoint is triggered in between 
> the two.  The hw-breakpoint handler will see that current is 
> different from the task pointer stored in the chbi area, so it 
> will think the task pointer is leftover from an old task (lazy 
> switching) and will erase it.  Then until the next context 
> switch, no user-breakpoints will be installed.
> 
> The real problem is that it's impossible to update both 
> current and chbi->bp_task at the same instant, so there will 
> always be a window in which they disagree and a breakpoint 
> might get triggered.  Since we use lazy switching, we are 
> forced to assume that a disagreement means that current is 
> correct and chbi->bp_task is old.  But if you move the code 
> above then you'll create a window in which current is old and 
> chbi->bp_task is correct.

inside these:

  /*
   * ......
   */

Thanks,

        Ingo

