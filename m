Return-Path: <linux-kernel-owner+w=401wt.eu-S1161255AbXDWSkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161255AbXDWSkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 14:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161371AbXDWSkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 14:40:10 -0400
Received: from mail.screens.ru ([213.234.233.54]:51086 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161218AbXDWSkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 14:40:09 -0400
Date: Mon, 23 Apr 2007 22:39:56 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, vatsa@in.ibm.com,
       paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC PATCH(experimental) 2/2] Fix freezer-kthread_stop race
Message-ID: <20070423183956.GA265@tv-sign.ru>
References: <20070419120131.GB13435@in.ibm.com> <20070419120419.GB17069@in.ibm.com> <20070420211209.GA820@tv-sign.ru> <20070423103833.GB25144@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423103833.GB25144@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Gautham R Shenoy wrote:
>
> On Sat, Apr 21, 2007 at 01:12:09AM +0400, Oleg Nesterov wrote:
> > On 04/19, Gautham R Shenoy wrote:
> > >
> > > @@ -63,12 +74,16 @@ void refrigerator(void)
> > >  	recalc_sigpending(); /* We sent fake signal, clean it up */
> > >  	spin_unlock_irq(&current->sighand->siglock);
> > >  
> > > +	task_lock(current);
> > >  	for (;;) {
> > >  		set_current_state(TASK_UNINTERRUPTIBLE);
> > >  		if (!frozen(current))
> > >  			break;
> > > +		task_unlock(current);
> > >  		schedule();
> > > +		task_lock(current);
> > >  	}
> > > +	task_unlock(current);
> > >  	pr_debug("%s left refrigerator\n", current->comm);
> > >  	current->state = save;
> > 
> > Just curious, why this change?
>
> This can race with hold_freezer_for_task() calling thaw_process. Earlier
> thaw_process(p) was called only after the process 'p' was frozen.
> Now with hold_freezer_for_task(), we can as well call thaw_process(p)
> when 'p' is in the freezing stage. Hence the task_lock.

hold_freezer_for_task()->thaw_process(p) will wake up the task. Or the
caller of refrigerator will notice "!frozen()". Note that refrigerator()
sets PF_FROZEN under task_lock().

In fact we have the same issue when thaw_tasks()->thaw_process(p) happens
when the freezing fails. In that case 'p' may be not frozen.

> > Also, you are planning to add different freezing states (FE_HOTPLUG_CPU,
> > FE_SUSPEND, etc). In that case each of them needs a separate .count, because
> > it should be negative when try_to_freeze_tasks() returns. Now consider
> > the case when we are doing freeze_processes(FE_A | FE_B) ...
> 
> So can't we in that case find out the weight of the freeze_event variable and
> subtract that weight from the count (if the count is <=0 ) ?

Probably yes... but if we are speaking about kthrad_stop() only, this could
be afaics solved in more simple way, as Rafael suggests.

Oleg.

