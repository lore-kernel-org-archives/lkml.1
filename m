Return-Path: <linux-kernel-owner+w=401wt.eu-S938222AbXGUORU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938222AbXGUORU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 10:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757619AbXGUORM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 10:17:12 -0400
Received: from mail.screens.ru ([213.234.233.54]:40480 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493AbXGUORK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 10:17:10 -0400
Date: Sat, 21 Jul 2007 18:18:14 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@mandriva.com>
Subject: Re: [PATCH] pi-futex: set PF_EXITING without taking ->pi_lock
Message-ID: <20070721141814.GA1013@tv-sign.ru>
References: <20070721115712.GA871@tv-sign.ru> <20070721123159.GB1769@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721123159.GB1769@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21, Ingo Molnar wrote:
> 
> * Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > It is a bit annoying that do_exit() takes ->pi_lock to set PF_EXITING.
> > All we need is to synchronize with lookup_pi_state() which saw this task
> > without PF_EXITING under ->pi_lock.
> > 
> > Change do_exit() to use spin_unlock_wait().
> > 
> > Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks!

> > -	spin_lock_irq(&tsk->pi_lock);
> > -	tsk->flags |= PF_EXITING;
> > -	spin_unlock_irq(&tsk->pi_lock);
> > +	smp_mb();
> > +	spin_unlock_wait(&tsk->pi_lock);
> 
> hm, isnt spin_unlock_wait() an SMP barrier in itself?

no, only barrier() due to cpu_relax()

> (if not then it should be.)

I think you are right, I can't imagine a valid usage of spin_unlock_wait()
without a barrier.

For example, from net/dccp/ccid.c

	static void ccids_write_lock(void)
	{
		spin_lock(&ccids_lock);
		while (atomic_read(&ccids_lockct) != 0) {
			spin_unlock(&ccids_lock);
			yield();
			spin_lock(&ccids_lock);
		}
	}

	static inline void ccids_read_lock(void)
	{
		atomic_inc(&ccids_lockct);
		spin_unlock_wait(&ccids_lock);
	}

This looks racy, in theory atomic_inc() and spin_unlock_wait() could be
re-ordered. However, in this particular case we have an "optimized"
smp_mb_after_atomic_inc(), perhaps it is good that the caller can choose
the "right" barrier by hand.

Oleg.

