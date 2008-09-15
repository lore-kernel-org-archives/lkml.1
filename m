Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbYIORvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbYIORvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbYIORvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:51:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:52149 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYIORvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:51:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=IAgIGrSw1g/Bx5qsiTgqHvYV3v7dimgmLlMRQii1yfXfXpS7sM8GApKiwsH7AGZAV
	YhPv/qZe9j9I/socQz6lA==
Subject: Re: + itimers-fix-itimer-many-thread-hang.patch added to -mm tree
From: Frank Mayhar <fmayhar@google.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       adobriyan@gmail.com, mingo@elte.hu, roland@redhat.com,
       tglx@linutronix.de
In-Reply-To: <20080914175040.GA819@tv-sign.ru>
References: <200809122353.m8CNrCmR011310@imap1.linux-foundation.org>
	 <20080914175040.GA819@tv-sign.ru>
Content-Type: text/plain
Organization: Google, Inc.
Date: Mon, 15 Sep 2008 10:49:43 -0700
Message-Id: <1221500983.19012.21.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-09-14 at 21:50 +0400, Oleg Nesterov wrote:
> s/mm-commits/lkml/
> 
> (Frank, please don't forget to CC me ;)

Did I forget last time?  Oops.

> Really minor nit. Suppose that task_cputime_zero(tsk) == T and
> task_cputime_zero(sig) == F. In that case task_cputime_expired(&task_sample)
> is not needed, perhaps it makes sense to reformat this function a bit
> 
> 	static inline int fastpath_timer_check(struct task_struct *tsk,
> 						struct signal_struct *sig)
> 	{
> 		if (!task_cputime_zero(&tsk->cputime_expires)) {
> 			struct task_cputime task_sample = {
> 				.utime = tsk->utime,
> 				.stime = tsk->stime,
> 				.sum_exec_runtime = tsk->se.sum_exec_runtime
> 			};
> 			if (task_cputime_expired(&task_sample, &tsk->cputime_expires))
> 				return 1;
> 		}
> 
> 		if (!task_cputime_zero(&sig->cputime_expires)) {
> 			struct task_cputime group_sample;
> 			thread_group_cputime(tsk, &group_sample);
> 			if (task_cputime_expired(&group_sample, &sig->cputime_expires))
> 				return 1;
> 		}
> 
> 		return 0;
> 	}
> this way it also looks more symmetrical.

Yeah, I like it better this way myself.  Also...

> I'd suggest to move the "if (!sig)" check into fastpath_timer_check(),
> run_posix_cpu_timers() doesn't use sig, but this is matter a of taste.

...I agree with this.  It looks better and removes the sig dereference
from run_posix_cpu_timers() where it is otherwise unused.

> This is a bit misleading, lock_task_sighand() can't fail or we have a bug.
> We already checked ->signal != NULL, and the task is current, we can use
> spin_lock(&tsk->sighand->siglock).
> 
> To clarify, if lock_task_sighand() could fail, fastpath_timer_check()
> is not safe. So I'd suggest the next patch:

Okay, I get it.  (This actually matches an iteration of the code but I
decided that I wasn't sure enough of my understanding to depend on
lock_task_sighand() not failing.  Things have now changed enough,
though, that it makes sense again.)

> > +unsigned long long thread_group_sched_runtime(struct task_struct *p)
> > +{
> > +	unsigned long flags;
> > +	u64 ns;
> > +	struct rq *rq;
> > +	struct task_cputime totals;
> > +
> > +	rq = task_rq_lock(p, &flags);
> > +	thread_group_cputime(p, &totals);
> > +	ns = totals.sum_exec_runtime + task_delta_exec(p, rq);
> >  	task_rq_unlock(rq, &flags);
> 
> Hmm. This is used by cpu_clock_sample_group_locked() which has already
> called thread_group_cputime(). Yes, without task_rq_lock(), but
> thread_group_cputime() is not "atomic" anyway. And please note that
> thread_group_sched_runtime() is not that "group", we don't account
> task_delta_exec() for other threads. Perhaps we can kill this function?
> Or, at least, perhaps we can simplify this:

Deferring to your superior knowledge, I've made the suggested changes.
My original intent was to retain the original structure of the code but,
as you say, this code is now redundant.

> BTW, with or without this patch cpu_clock_sample_group() doesn't need
> ->siglock, afaics.

Fixed.  I removed cpu_clock_sample_group_locked() entirely and moved the
guts of it to cpu_clock_sample_group().

I have a few more things to do; expect a new iteration of the patch
tonight or tomorrow.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

