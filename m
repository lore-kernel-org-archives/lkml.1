Return-Path: <linux-kernel-owner+w=401wt.eu-S1765624AbYCGJUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765624AbYCGJUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764185AbYCGJL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:11:28 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:44190 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763892AbYCGJLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:11:23 -0500
Date: Fri, 7 Mar 2008 14:40:49 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Yi Yang <yi.y.yang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are
	dealocked when cpu is set to offline
Message-ID: <20080307091049.GA8827@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com> <20080303153154.GA11288@in.ibm.com> <1204555505.3842.4.camel@yangyi-dev.bj.intel.com> <20080304052613.GA28632@in.ibm.com> <20080304150107.GA564@tv-sign.ru> <20080306134400.GA1915@in.ibm.com> <20080307025451.GA201@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307025451.GA201@tv-sign.ru>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 05:54:51AM +0300, Oleg Nesterov wrote:
> On 03/06, Gautham R Shenoy wrote:
> >
> > On Tue, Mar 04, 2008 at 06:01:07PM +0300, Oleg Nesterov wrote:
> > > +static void check_running_task(struct task_struct *t, unsigned long now)
> > > +{
> > > +	if (!sysctl_hung_task_timeout_secs)
> > > +		return;
> > > +
> > 
> > This function gets called only when t->xxx == 0,
> > so the if below doesn't mean much, does it? :)
> > 
> > > +	if (time_before(now, t->xxx + HZ * sysctl_hung_task_timeout_secs)
> > > +		return;
> > .......
> >
> > > @@ -192,15 +214,17 @@ static void check_hung_uninterruptible_t
> > >  	if ((tainted & TAINT_DIE) || did_panic)
> > >  		return;
> > > 
> > > -	read_lock(&tasklist_lock);
> > > +	rcu_read_lock();
> > >  	do_each_thread(g, t) {
> > >  		if (!--max_count)
> > >  			goto unlock;
> > >  		if (t->state & TASK_UNINTERRUPTIBLE)
> > >  			check_hung_task(t, now);
> > > +		if (!t->xxx)
> > > +			check_running_task(t, jiff);
> 
> Of course, the check above should be
> 
> 		if (1t->xxx)
> 			check_running_task(t, jiff);
> 
> Thanks!
> 
> >From another message,
> >
> > Me too. With your patch applied there were quite a few tasks in the
> > running state which didn't get the cpu for more than 120 seconds.
> 
> (I assume you fixed the patch before using it ;)
No! Conversely, I fixed the patch because I found this behaviour a bit
odd. Couldn't run the tests again as it was a tad bit late.

> 
> Just to be sure, there were no "bad ->cpu..." messages, yes?

Hopefully should be able to catch them now. If yes, it's a problem in
the way we do migration after cpu-hotplug as Yi suggested in an earlier
mail.

http://lkml.org/lkml/2008/3/6/437

This mail from akpm says the same thing.

> 
> Oleg.

-- 
Thanks and Regards
gautham
