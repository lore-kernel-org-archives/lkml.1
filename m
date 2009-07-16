Return-Path: <linux-kernel-owner+w=401wt.eu-S933504AbZGPWen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504AbZGPWen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 18:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933495AbZGPWem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 18:34:42 -0400
Received: from smtpout.cs.fsu.edu ([128.186.122.75]:1904 "EHLO mail.cs.fsu.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932938AbZGPWel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 18:34:41 -0400
Date: Thu, 16 Jul 2009 18:34:40 -0400
From: Ted Baker <baker@cs.fsu.edu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Raistlin <raistlin@linux.it>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
Message-ID: <20090716223440.GD27757@cs.fsu.edu>
References: <4A594D2D.3080101@ittc.ku.edu> <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir> <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir> <4A5C9ABA.9070909@nortel.com> <1247590112.9086.936.camel@Palantir> <4A5CCD5A.80108@nortel.com> <20090715221410.GE14993@cs.fsu.edu> <4A5F3D5C.1070704@nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5F3D5C.1070704@nortel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 08:46:52AM -0600, Chris Friesen wrote:

> > So, it seems most logical and simplest to leave the charges where
> > they naturally occur, on B.  That is, if you allow priority
> > inheritance, you allow tasks to sometimes run at higher priority
> > than they originally were allocated, but not to execute more 
> > than originally budgeted.

> In this scenario, we're going to disrupt B's scheduling pattern by
> forcing it to borrow from its future cpu allocation in order to free up
> the lock.  It will then be forced to block for a while to make up for
> the over-use of it's cpu budget.

I guess by "disrupting" B's scheduling pattern, you mean only in
the sense of delayed budget enforcement.  That is, finishing the
critical sections is something that B would do next in any case,
and something that B would need to consume CPU time to do in any
case.  It is B doing its own normal work, but just getting
a chance to complete that work sooner than it might otherwise.

In this situation, you do want to allow B's budget to go negative
(borrowing against B's future CPU budget to do B's work) rather
than charging the task A who loaned B priority, since otherwise B
ends up getting a still bigger windfall (charging B's work to A's
budget).

Ted

BTW. I believe I understood what you are saying here, but I
noticed that we are using words in different ways, especially
"block" and "sleep", and I'm not sure about some of the other messages.

It would be helpful if we had some common terminology.  In
particular, it might be useful to agree on distinct names for the
following following different reasons for a task not to be
executing.

1) actively looping on spin-lock, using CPU cycles
2) waiting for a condition or event,
   like timer or I/O completion, not using CPU cycles,
   not allowed to execute until the event or condition occurs
3) waiting for a CPU budget replenishment,
   not using CPU cycles, 
4) conceptually allowed to execute, but preempted on all available
   processors (by higher priority or non-preemptable tasks)
5) conceptually allowed to execute, but prevented from executing
   by lower-priority tasks that are not currently preemptable

Ted
