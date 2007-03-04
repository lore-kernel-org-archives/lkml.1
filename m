Return-Path: <linux-kernel-owner+w=401wt.eu-S1750912AbXCDLOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912AbXCDLOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 06:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbXCDLOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 06:14:46 -0500
Received: from mail.queued.net ([207.210.101.209]:3070 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbXCDLOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 06:14:46 -0500
Message-ID: <45EAAA21.4040803@debian.org>
Date: Sun, 04 Mar 2007 06:14:41 -0500
From: Andres Salomon <dilinger@debian.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dynticks: don't unlock spinlock twice
References: <45E8E2F8.1030102@debian.org> <1172912540.24738.108.camel@localhost.localdomain>
In-Reply-To: <1172912540.24738.108.camel@localhost.localdomain>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 2007-03-02 at 21:52 -0500, Andres Salomon wrote:
[...]
> 
> The BUG is somewhere else. the tick timer should never be seen in
> hrtimer_run_queues. The tick timer is operated solely from the timer
> interrupt. 
> 
> The question is, how the tick timer gets enqueued in the softirq queue.
> Can you isolate the codepath, where this happens ?
> 

Only 4 functions call timer->function; hrtimer_enequeue_reprogram,
hrtimer_interrupt, run_hrtimer_softirq, and run_hrtimer_queue.

- hrtimer_enqueue_reprogram will not call CB_IRQSAFE_NO_SOFTIRQ; this
function is not the culprit.  It does move CB_SOFTIRQs onto the
cb_pending list.

- hrtimer_interrupt is called from a hardirq context, and only runs
CB_IRQSAFE*.  CB_SOFTIRQs are moved onto the cb_pending list.  Since
irqs are disabled, this function is not the culprit.

- run_hrtimer_softirq is called from the HRTIMER_SOFTIRQ, and only
operates on softirqs (via the cb_pending list).  CB_IRQSAFE_NO_SOFTIRQ
callbacks are never added to the cb_pending list, so this function is
not the culprit.

- run_hrtimer_queue is called from TIMER_SOFTIRQ, and runs on all
timers.  This function is what shows up in the backtrace, and should not
be calling tick_sched_timer.

Now, the question is; what *should* it be doing?  Since it is only ever
run from a softirq context, should it be checking for
!CB_IRQSAFE_NO_SOFTIRQ before running the timers?  Should it only be
processing timers that have been added to cb_pending (which are
guaranteed to be softirq-friendly)?   Is there even a reason why we have
a run_hrtimer_softirq that processes cb_pending, as well as a
run_timer_softirq that calls hrtimer_run_queues?  Why should the timer
softirq (which is raised by, amongst other things, update_process_times,
which is called by our friend tick_sched_timer) care about the hrtimer
queues?


