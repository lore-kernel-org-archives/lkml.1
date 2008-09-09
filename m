Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbYIIUbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbYIIUbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYIIUaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:30:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:22361 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbYIIUay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:30:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=DeY0rySojx1ensGXo/A8hyN2VQMGOoI3exdChG40p8zV1iBL3Kqm/pXGdLHdbQcDh
	Ti0CW5hhMKrhkL52ca4oQ==
Subject: Re: [PATCH 2.6.27-rc5] Fix itimer/many thread hang.
From: Frank Mayhar <fmayhar@google.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080909160152.GA714@tv-sign.ru>
References: <1220906643.31846.21.camel@bobble.smo.corp.google.com>
	 <20080909070329.GD2086@elte.hu>  <20080909160152.GA714@tv-sign.ru>
Content-Type: text/plain
Organization: Google, Inc.
Date: Tue, 09 Sep 2008 13:29:32 -0700
Message-Id: <1220992172.23059.20.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 20:01 +0400, Oleg Nesterov wrote:
> The patch has a lot of
> 
> 	rcu_read_lock();
> 	sig = rcu_dereference(tsk->signal);
> 
> This is bogus, task_struct->signal is not protected by RCU.

Roland suggested this approach; I just want to snapshot the field
atomically.  I guess I can just do an atomic read...

> However, at first glance the code (this and other funcs) looks correct...
> Either tsk == current, or the code runs under ->siglock. Or we know that
> ->signal can't go away (wait_task_zombie).
> 
> As for this particular function, it seems to me that ->signal == NULL
> is not possible, no?

That's not completely clear to me.  I'm allowing for the possibility
that it might be called during, say, process teardown.  It's used in so
many places that I'm uncomfortable leaving the == NULL check out.

> Please remove the false RCU stuff.

OK.

> Btw, this function has a lot of callers, perhaps it is better to
> uninline it.

If that's the consensus I'll do so.  I assumed that speed was more
important than space in this case.  Am I mistaken?

> >  static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
> >  {
> >  	struct signal_struct *sig;
> >  	int ret;
> >
> >  	if (clone_flags & CLONE_THREAD) {
> > -		atomic_inc(&current->signal->count);
> > -		atomic_inc(&current->signal->live);
> > -		return 0;
> > +		ret = thread_group_cputime_clone_thread(current, tsk);
> > +		if (likely(!ret)) {
> > +			atomic_inc(&current->signal->count);
> > +			atomic_inc(&current->signal->live);
> > +		}
> 
> So, the first CLONE_THREAD creates ->cputime.totals. After that
> thread_group_cputime_account_xxx() start to use it even if the task
> doesn't have the attached cpu timers.
> 
> Stupid question: can't we allocate .totals in posix_cpu_timer_create() /
> set_process_cpu_timer() ?

That was the original plan but we (that is, Roland and I) decided to
eliminate the separate storage for the dead-threads totals.  It's now
all kept in the totals field, for the whole thread group.  Note that
this doesn't affect single-threaded processes at all.  Multithreaded
processes, though, now keep their times in the new field, eliminating
the old dead-thread fields from the signal structure, reducing the bloat
this patch generates by just a bit.

> Let's suppose the task doesn't have cpu timers. Currently, in this case
> run_posix_cpu_timers() quickly checks UNEXPIRED() and returns. With this
> patch we call fastpath_timer_check(). The first task_cputime_expired()
> returns 0, so we are doing thread_group_cputime()->for_each_possible_cpu().
> 
> Not good, this code runs every timer tick. Perhaps it makes sense
> to add a fastpath check.

After looking at the code again, you're right.  I paid so much attention
to fast-pathing the unexpired timer case that I forgot to handle the
_no_-timer case.  I've added code to fastpath_timer_check() to handle
that case.

I'll be addressing the rest of your comments (particularly the RCU
stuff) and producing a new patch fairly shortly.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

