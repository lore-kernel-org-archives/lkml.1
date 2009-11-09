Return-Path: <linux-kernel-owner+w=401wt.eu-S1751497AbZKIRck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbZKIRck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbZKIRcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:32:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZKIRcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:32:39 -0500
Date: Mon, 9 Nov 2009 18:27:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: utime/stime decreasing on thread exit
Message-ID: <20091109172737.GA8719@redhat.com>
References: <4AF0C97F.7000603@bluehost.com> <4AF123F5.50407@jp.fujitsu.com> <4AF26176.4080307@jp.fujitsu.com> <1257778154.4108.341.camel@laptop> <20091109172020.GA7751@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109172020.GA7751@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, forgot to cc Stanislaw...

On 11/09, Peter Zijlstra wrote:
>
> On Thu, 2009-11-05 at 14:24 +0900, Hidetoshi Seto wrote:
>
> > Problem [1]:
> >   thread_group_cputime() vs exit
> >
> > +void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
> > +{
> > +       struct sighand_struct *sighand;
> > +       struct signal_struct *sig;
> > +       struct task_struct *t;
> > +
> > +       *times = INIT_CPUTIME;
> > +
> > +       rcu_read_lock();
> > +       sighand = rcu_dereference(tsk->sighand);
> > +       if (!sighand)
> > +               goto out;
> > +
> > +       sig = tsk->signal;
> > +
> > +       t = tsk;
> > +       do {
> > +               times->utime = cputime_add(times->utime, t->utime);
> > +               times->stime = cputime_add(times->stime, t->stime);
> > +               times->sum_exec_runtime += t->se.sum_exec_runtime;
> > +
> > +               t = next_thread(t);
> > +       } while (t != tsk);
> > +
> > +       times->utime = cputime_add(times->utime, sig->utime);
> > +       times->stime = cputime_add(times->stime, sig->stime);
> > +       times->sum_exec_runtime += sig->sum_sched_runtime;
> > +out:
> > +       rcu_read_unlock();
> > +}
> >
> > If one of (thousands) threads do exit while a thread is doing do-while
> > above, the s/utime of exited thread can be accounted twice, at do-while
> > (before exit) and at cputime_add() at last (after exit).
> >
> > I suppose this is hard to fix: Taking lock on signal would solve this
> > problem, but it could block all other threads long and cause serious
> > performance issue and so on...
>
> I just checked .22 and there we seem to hold p->sighand->siglock over
> the full task iteration.

Yes. Then thread_group_cputime() was changed so that it didn't itearate
over sub-threads, then this callsite was move outside of ->siglock, now
it does while_each_thread() again.

> So we might as well revert back to that if
> people really mind counting things twice :-)

Stanislaw has already sent the patch, but I don't know what happened
with this patch:

	[PATCH 1/2] posix-cpu-timers: avoid do_sys_times() races with __exit_signal()
	http://marc.info/?l=linux-kernel&m=124505545131145

Oleg.

