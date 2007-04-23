Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbXDWKkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbXDWKkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 06:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbXDWKkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 06:40:18 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45860 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbXDWKkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 06:40:17 -0400
Date: Mon, 23 Apr 2007 16:08:33 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, vatsa@in.ibm.com,
       paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC PATCH(experimental) 2/2] Fix freezer-kthread_stop race
Message-ID: <20070423103833.GB25144@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070419120131.GB13435@in.ibm.com> <20070419120419.GB17069@in.ibm.com> <20070420211209.GA820@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420211209.GA820@tv-sign.ru>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2007 at 01:12:09AM +0400, Oleg Nesterov wrote:
> On 04/19, Gautham R Shenoy wrote:
> >
> > @@ -63,12 +74,16 @@ void refrigerator(void)
> >  	recalc_sigpending(); /* We sent fake signal, clean it up */
> >  	spin_unlock_irq(&current->sighand->siglock);
> >  
> > +	task_lock(current);
> >  	for (;;) {
> >  		set_current_state(TASK_UNINTERRUPTIBLE);
> >  		if (!frozen(current))
> >  			break;
> > +		task_unlock(current);
> >  		schedule();
> > +		task_lock(current);
> >  	}
> > +	task_unlock(current);
> >  	pr_debug("%s left refrigerator\n", current->comm);
> >  	current->state = save;
> 
> Just curious, why this change?
This can race with hold_freezer_for_task() calling thaw_process. Earlier
thaw_process(p) was called only after the process 'p' was frozen.
Now with hold_freezer_for_task(), we can as well call thaw_process(p)
when 'p' is in the freezing stage. Hence the task_lock.
I know it's ugly, but couldn't think of any other alternative at that time.

> 
> > +int hold_freezer_for_task(struct task_struct *p)
> > +{
> > +	int ret = 0;
> > +	spin_lock(&freezer_status.lock);
> > +	if (freezer_status.count >= 0)
> > +	{
> > +		set_tsk_thread_flag(p, TIF_FREEZER_HELD);
> > +		thaw_process(p);
> > +		freezer_status.count++;
> > +		ret = 1;
> > +	}
> > +	spin_unlock(&freezer_status.lock);
> > +
> > +	return ret;
> > +}
> 
> I think this can work if it is used only in kthread_stop(). But what if
> another task wants to do hold_freezer_for_task(p) ? freezer_status.count
> is recursive, but TIF_FREEZER_HELD is not. IOW, I believe this is not
> generic enough.

Yes. If more than one tasks want another task to be temporarily thawed, this
won't work. I hadn't anticipated such a case. 
> 
> Also, you are planning to add different freezing states (FE_HOTPLUG_CPU,
> FE_SUSPEND, etc). In that case each of them needs a separate .count, because
> it should be negative when try_to_freeze_tasks() returns. Now consider
> the case when we are doing freeze_processes(FE_A | FE_B) ...

So can't we in that case find out the weight of the freeze_event variable and
subtract that weight from the count (if the count is <=0 ) ?
> 
> Oleg.
> 

Thanks for the review.
Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
