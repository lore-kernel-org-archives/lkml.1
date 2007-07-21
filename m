Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbXGUQjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbXGUQjD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 12:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbXGUQiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 12:38:52 -0400
Received: from mail.screens.ru ([213.234.233.54]:36859 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbXGUQiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 12:38:52 -0400
Date: Sat, 21 Jul 2007 20:39:47 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] pi-futex: set PF_EXITING without taking ->pi_lock
Message-ID: <20070721163947.GA1129@tv-sign.ru>
References: <20070721115712.GA871@tv-sign.ru> <20070721123159.GB1769@elte.hu> <20070721141814.GA1013@tv-sign.ru> <20070721150547.GA23560@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721150547.GA23560@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21, Ingo Molnar wrote:
> 
> * Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > 	static inline void ccids_read_lock(void)
> > 	{
> > 		atomic_inc(&ccids_lockct);
> > 		spin_unlock_wait(&ccids_lock);
> > 	}
> > 
> > This looks racy, in theory atomic_inc() and spin_unlock_wait() could 
> > be re-ordered. However, in this particular case we have an "optimized" 
> > smp_mb_after_atomic_inc(), perhaps it is good that the caller can 
> > choose the "right" barrier by hand.
> 
> _all_ default locking and atomic APIs should be barrier-safe i believe. 
> (and that includes atomic_inc() too) Most people dont have barriers on 
> their mind when their code. _If_ someone is barrier-conscious then we 
> should have barrier-less APIs too for that purpose of squeezing the last 
> half cycle out of the code, but it should be a non-default choice. The 
> reason: nobody notices an unnecessary barrier, but a missing barrier can 
> be nasty.

Personally, I agree (but I am not sure the idea to make atomic_inc()
barrier-safe would be very popular).

Question: should we make spinlock_t barrier-safe?

Suppose that the task "p" does

	current->state = TASK_INTERRUPIBLE;
	mb();

	if (CONDITION)
		break;

	schedule();

and another CPU does

	CONDITION = 1;
	try_to_wake_up(p);


This is commonly used, but not correct _in theory_. If wake_up() happens
when p->array != NULL, we have

	CONDITION = 1;			// [1]
	spin_lock(rq->lock);
	task->state = TASK_RUNNING;	// [2]

and we can miss an event. Because in theory [1] may leak into the critical
section, and could be re-ordered with [2].

Another problem is that try_to_wake_up() first checks task->state and does
nothing if it is TASK_RUNNING, so we need a full mb(), not just wmb().

Should we change spin_lock(), or introduce smp_mb_before_spinlock(), or I
missed something?

NOTE: I do not pretend to know what kind of barrier spin_lock() provides
in practice, but according to the documentation lock() is only a one-way
barrier.

(I am glad I have an opportunity to raise this issue again :)

Oleg.

