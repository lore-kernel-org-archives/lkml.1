Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbYLXLSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbYLXLSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 06:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYLXLRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 06:17:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59648 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbYLXLRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 06:17:50 -0500
Date: Wed, 24 Dec 2008 12:17:38 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       <oleg@redhat.com>
Subject: Re: [PATCH, RESEND3] getrusage: fill ru_maxrss value
Message-ID: <20081224121738.68c5d1e6@psychotron.englab.brq.redhat.com>
In-Reply-To: <20081224153229.6800.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081218135945.4f8b87ed@psychotron.englab.brq.redhat.com>
	<20081224153229.6800.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Dec 2008 16:37:55 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi
Hi yourself.
> 
> > diff --git a/fs/exec.c b/fs/exec.c
> > index ec5df9a..8d3d0f9 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -870,6 +870,7 @@ static int de_thread(struct task_struct *tsk)
> >  	sig->notify_count = 0;
> >  
> >  no_thread_group:
> > +	sig->maxrss = 0;
> >  	exit_itimers(sig);
> >  	flush_itimer_signals();
> >  	if (leader)
> 
> I don't know getrusage correct behavior so detail.
> Why don't update parent process's sig->cmaxrss ?
Because exec affects only this task and we want to forgot maxrss value.
That does not implicate that we want to forgot highest maxrss value of
our childs because exec does not affect them. I think this is right
behavior.


> 
> 
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index f4c70dc..41b04ee 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -563,6 +563,7 @@ struct signal_struct {
> >  	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
> >  	unsigned long inblock, oublock, cinblock, coublock;
> >  	struct task_io_accounting ioac;
> > +	unsigned long maxrss, cmaxrss;
> 
> 	unsigned long inblock, oublock, cinblock, coublock;
> 	unsigned long maxrss, cmaxrss;
> 	struct task_io_accounting ioac;
> 
> is better.
> I like related member sit on nearly place.
No problem with this.


> 
> 
> 
> > diff --git a/kernel/exit.c b/kernel/exit.c
> > index 81b6372..61d622d 100644
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -1053,6 +1053,8 @@ NORET_TYPE void do_exit(long code)
> >  	if (group_dead) {
> >  		hrtimer_cancel(&tsk->signal->real_timer);
> >  		exit_itimers(tsk->signal);
> > +		if (tsk->mm)
> > +			tsk->signal->maxrss = get_mm_hiwater_rss(tsk->mm);
> >  	}
> >  	acct_collect(code, group_dead);
> >  	if (group_dead)
> 
> At first look, I think "hm, group_dead mean this thread is last thread.
> hehe, this assignment is obiously meaningless".
> but it is wrong. you inserted maxrss usage in wait_task_zombie().
> 
> I think this is a bit confusable code.
> I hope you add kindly comment here.
> 
Ok I will add comment here.


> 
> 
> > @@ -1351,6 +1353,8 @@ static int wait_task_zombie(struct task_struct *p, int options,
> >  			sig->oublock + sig->coublock;
> >  		task_io_accounting_add(&psig->ioac, &p->ioac);
> >  		task_io_accounting_add(&psig->ioac, &sig->ioac);
> > +		if (psig->cmaxrss < sig->maxrss)
> > +			psig->cmaxrss = sig->maxrss;
> >  		spin_unlock_irq(&p->parent->sighand->siglock);
> >  	}
> 
> ditto. I like following order.
> 
> 			sig->oublock + sig->coublock;
> 		if (psig->cmaxrss < sig->maxrss)
> 			psig->cmaxrss = sig->maxrss;
> 		task_io_accounting_add(&psig->ioac, &p->ioac);
> 		task_io_accounting_add(&psig->ioac, &sig->ioac);
No problem with this.


> 
> 
> 
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 495da2e..36ac3e5 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -850,6 +850,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
> >  	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
> >  	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
> >  	task_io_accounting_init(&sig->ioac);
> > +	sig->maxrss = sig->cmaxrss = 0;
> >  	taskstats_tgid_init(sig);
> >  
> >  	task_lock(current->group_leader);
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index 31deba8..f369099 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -1569,6 +1569,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
> >  			r->ru_majflt = p->signal->cmaj_flt;
> >  			r->ru_inblock = p->signal->cinblock;
> >  			r->ru_oublock = p->signal->coublock;
> > +			r->ru_maxrss = p->signal->cmaxrss;
> >  
> >  			if (who == RUSAGE_CHILDREN)
> >  				break;
> > @@ -1583,6 +1584,8 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
> >  			r->ru_majflt += p->signal->maj_flt;
> >  			r->ru_inblock += p->signal->inblock;
> >  			r->ru_oublock += p->signal->oublock;
> > +			if (r->ru_maxrss < p->signal->maxrss)
> > +				r->ru_maxrss = p->signal->maxrss;
> >  			t = p;
> >  			do {
> >  				accumulate_thread_rusage(t, r);
> > @@ -1598,6 +1601,18 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
> >  out:
> >  	cputime_to_timeval(utime, &r->ru_utime);
> >  	cputime_to_timeval(stime, &r->ru_stime);
> > +
> > +	if (who != RUSAGE_CHILDREN) {
> > +		task_lock(p);
> > +		if (p->mm) {
> > +			unsigned long maxrss = get_mm_hiwater_rss(p->mm);
> > +
> > +			if (r->ru_maxrss < maxrss)
> > +				r->ru_maxrss = maxrss;
> > +		}
> > +		task_unlock(p);
> 
> get_task_mm() and mmput() instead task_lock() is better?
Maybe it's better looking. I wanted to use these too. Oleg suggested to
optimize the way it is in the patch. I can change it, no problem.


> 
> and, why don't this code move to "case RUSAGE_SELF" processing point?
Because we need this to be done for RUSAGE_THREAD too. Or don't we?


> 
> 
> > +	}
> > +	r->ru_maxrss <<= PAGE_SHIFT - 10;
> >  }
> 
> using local variable is better because local variable can stay on
> register by compiler easily, but indirect access doesn't.
OK


> 
> r->ru_maxrss = maxrss << PAGE_SHIFT - 10;
> (similar utime and r->ru_utime)
> 
> and we need good comment. e.g. /* Convert to KB */
> or good macros (likely linux/fs/proc/meminfo.c::K() macro)
OK


> 
> 
> >  
> >  int getrusage(struct task_struct *p, int who, struct rusage __user *ru)
> > -- 
> > 1.6.0.4
> > 
> 
> In addision, you also need change man pages and notice to linux-api mailing list.
I cc'ed this list while I was sending the patch. I was not aware I
should change the man page. Will do that too.


Thanks a lot for comments Kosaki

Regards.

Jirka
> 
> 
> 
> 
