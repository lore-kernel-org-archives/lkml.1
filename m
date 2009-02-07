Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbZBGQez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbZBGQez (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 11:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZBGQes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 11:34:48 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:33878 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbZBGQer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 11:34:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h7qkDXWR/afvuHcD71bKz3Fz5e2lNomD762kekRsqAGe9qPe8pFV9aHK2y3z8kHYe+
         3mm0Qh2LlRmkX40tIMk8agaSKJf67ZaxnV0NNWk6+bAcFu08kH1FgsFarcoJ17V5Wtb7
         fBIx4RiA/HAGMTIdiWLXs6PxdMhoTVUS6zmQc=
Date: Sat, 7 Feb 2009 17:34:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mandeep Singh Baines <msb@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rientjes@google.com,
       mbligh@google.com, thockin@google.com, akpm@linux-foundation.org
Subject: Re: [PATCH] softlockup: remove timestamp checking from hung_task
Message-ID: <20090207163440.GB5779@nowhere>
References: <20090206233747.GA8747@google.com> <20090207162328.GA5779@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090207162328.GA5779@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 05:23:28PM +0100, Frederic Weisbecker wrote:
> Hi Mandeep,
> 
> On Fri, Feb 06, 2009 at 03:37:47PM -0800, Mandeep Singh Baines wrote:
> > Patch against tip/core/softlockup
> > 
> > ---
> > Impact: saves sizeof(long) bytes per task_struct
> > 
> > By guaranteeing that sysctl_hung_task_timeout_secs have elapsed between
> > tasklist scans we can avoid using timestamps.
> > 
> > Signed-off-by: Mandeep Singh Baines <msb@google.com>
> 
> 
> Good idea.
> BTW, why haven't you put your name on top of this file?
> That would help those who will send patches knowing to whom they have to
> route their mails.
> 
> I made some comments below about small things...
> 
> > ---
> >  include/linux/sched.h |    1 -
> >  kernel/fork.c         |    8 +++-----
> >  kernel/hung_task.c    |   48 +++++++++---------------------------------------
> >  3 files changed, 12 insertions(+), 45 deletions(-)
> > 
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 2a2811c..e0d723f 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1241,7 +1241,6 @@ struct task_struct {
> >  #endif
> >  #ifdef CONFIG_DETECT_HUNG_TASK
> >  /* hung task detection */
> > -	unsigned long last_switch_timestamp;
> >  	unsigned long last_switch_count;
> >  #endif
> >  /* CPU-specific state of this task */
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index fb94442..bf582f7 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -639,6 +639,9 @@ static int copy_mm(unsigned long clone_flags, struct task_struct * tsk)
> >  
> >  	tsk->min_flt = tsk->maj_flt = 0;
> >  	tsk->nvcsw = tsk->nivcsw = 0;
> > +#ifdef CONFIG_DETECT_HUNG_TASK
> > +	tsk->last_switch_count = tsk->nvcsw + tsk->nivcsw;
> > +#endif
> 
> 
> I think you can directly assign a zero here :-)
> Or you want to let it as is to give some sense and explanation
> about the role of this field?
> Why not, I guess gcc will optimize it anyway.
> 
> 
> >  	tsk->mm = NULL;
> >  	tsk->active_mm = NULL;
> > @@ -1041,11 +1044,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> >  
> >  	p->default_timer_slack_ns = current->timer_slack_ns;
> >  
> > -#ifdef CONFIG_DETECT_HUNG_TASK
> > -	p->last_switch_count = 0;
> > -	p->last_switch_timestamp = 0;
> > -#endif
> > -
> >  	task_io_accounting_init(&p->ioac);
> >  	acct_clear_integrals(p);
> >  
> > diff --git a/kernel/hung_task.c b/kernel/hung_task.c
> > index 3951a80..4a10756 100644
> > --- a/kernel/hung_task.c
> > +++ b/kernel/hung_task.c
> > @@ -34,7 +34,6 @@ unsigned long __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
> >   * Zero means infinite timeout - no checking done:
> >   */
> >  unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;
> > -static unsigned long __read_mostly hung_task_poll_jiffies;
> >  
> >  unsigned long __read_mostly sysctl_hung_task_warnings = 10;
> >  
> > @@ -69,33 +68,17 @@ static struct notifier_block panic_block = {
> >  	.notifier_call = hung_task_panic,
> >  };
> >  
> > -/*
> > - * Returns seconds, approximately.  We don't need nanosecond
> > - * resolution, and we don't need to waste time with a big divide when
> > - * 2^30ns == 1.074s.
> > - */
> > -static unsigned long get_timestamp(void)
> > -{
> > -	int this_cpu = raw_smp_processor_id();
> > -
> > -	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
> > -}
> > -
> > -static void check_hung_task(struct task_struct *t, unsigned long now,
> > -			    unsigned long timeout)
> > +static void check_hung_task(struct task_struct *t, unsigned long timeout)
> >  {
> >  	unsigned long switch_count = t->nvcsw + t->nivcsw;
> >  
> >  	if (t->flags & PF_FROZEN)
> >  		return;
> >  
> > -	if (switch_count != t->last_switch_count || !t->last_switch_timestamp) {
> > +	if (switch_count != t->last_switch_count) {
> >  		t->last_switch_count = switch_count;
> > -		t->last_switch_timestamp = now;
> >  		return;
> >  	}
> 
> 
> 
> What happens here if khungtaskd is scheduled in after tsk is inserted on the task_list
> in copy_process() but before tsk has been scheduled once?
> 
> tsk->last_switch_count and  tsk->nvcsw + tsk->nivcsw will still be equal to zero right?
> 
> Perhaps you could add another check such as
> 
> if (!switch_count)
> 	return;
> 
> 
> > -	if ((long)(now - t->last_switch_timestamp) < timeout)
> > -		return;
> >  	if (!sysctl_hung_task_warnings)
> >  		return;
> >  	sysctl_hung_task_warnings--;
> > @@ -111,7 +94,6 @@ static void check_hung_task(struct task_struct *t, unsigned long now,
> >  	sched_show_task(t);
> >  	__debug_show_held_locks(t);
> >  
> > -	t->last_switch_timestamp = now;
> >  	touch_nmi_watchdog();
> >  
> >  	if (sysctl_hung_task_panic)
> > @@ -145,7 +127,6 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
> >  {
> >  	int max_count = sysctl_hung_task_check_count;
> >  	int batch_count = HUNG_TASK_BATCHING;
> > -	unsigned long now = get_timestamp();
> >  	struct task_struct *g, *t;
> >  
> >  	/*
> > @@ -168,19 +149,16 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
> >  		}
> >  		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
> >  		if (t->state == TASK_UNINTERRUPTIBLE)
> > -			check_hung_task(t, now, timeout);
> > +			check_hung_task(t, timeout);
> >  	} while_each_thread(g, t);
> >   unlock:
> >  	rcu_read_unlock();
> >  }
> >  
> > -static void update_poll_jiffies(void)
> > +static unsigned long timeout_jiffies(unsigned long timeout)
> >  {
> >  	/* timeout of 0 will disable the watchdog */
> > -	if (sysctl_hung_task_timeout_secs == 0)
> > -		hung_task_poll_jiffies = MAX_SCHEDULE_TIMEOUT;
> > -	else
> > -		hung_task_poll_jiffies = sysctl_hung_task_timeout_secs * HZ / 2;
> > +	return (timeout ? timeout * HZ : MAX_SCHEDULE_TIMEOUT);
> >  }
> >  
> >  /*
> > @@ -197,8 +175,6 @@ int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
> >  	if (ret || !write)
> >  		goto out;
> >  
> > -	update_poll_jiffies();
> > -
> >  	wake_up_process(watchdog_task);
> 
> 
> I'm not sure what does this function now that you dropped update_poll_jiffies()
> So if the user sets up a new timeout value, the only effect will be that khungtaskd will
> be awakened?
> 
> But actually the /sys file doesn't seem to be set up.


Oops, I should have grep on proc_dohung_task_timeout_secs which is set on kernel/sysctl.
Sorry.
But still, sysctl_hung_task_timeout_secs doesn't seem to be set :-)


> 
> Other than these comments, that looks good!
> Thanks.
> 
> Frederic.
> 
> 
> >  
> >   out:
> > @@ -211,20 +187,14 @@ int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
> >  static int watchdog(void *dummy)
> >  {
> >  	set_user_nice(current, 0);
> > -	update_poll_jiffies();
> >  
> >  	for ( ; ; ) {
> > -		unsigned long timeout;
> > +		unsigned long timeout = sysctl_hung_task_timeout_secs;
> >  
> > -		while (schedule_timeout_interruptible(hung_task_poll_jiffies));
> > +		while (schedule_timeout_interruptible(timeout_jiffies(timeout)))
> > +			timeout = sysctl_hung_task_timeout_secs;
> >  
> > -		/*
> > -		 * Need to cache timeout here to avoid timeout being set
> > -		 * to 0 via sysctl while inside check_hung_*_tasks().
> > -		 */
> > -		timeout = sysctl_hung_task_timeout_secs;
> > -		if (timeout)
> > -			check_hung_uninterruptible_tasks(timeout);
> > +		check_hung_uninterruptible_tasks(timeout);
> >  	}
> >  
> >  	return 0;
> > -- 
> > 1.5.4.5
> > 

