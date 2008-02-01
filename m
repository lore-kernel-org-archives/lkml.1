Return-Path: <linux-kernel-owner+w=401wt.eu-S1760801AbYBALwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760801AbYBALwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbYBALw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:52:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58511 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbYBALwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:52:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Regression] 2.6.24-git9: RT sched mishandles artswrapper (bisected)
Date: Fri, 1 Feb 2008 12:50:17 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200802010237.59320.rjw@sisk.pl> <1201851896.32654.34.camel@lappy> <1201859458.32654.41.camel@lappy>
In-Reply-To: <1201859458.32654.41.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011250.18699.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 1 of February 2008, Peter Zijlstra wrote:
> 
> On Fri, 2008-02-01 at 08:44 +0100, Peter Zijlstra wrote:
> > On Fri, 2008-02-01 at 03:04 +0100, Rafael J. Wysocki wrote:
> > > On Friday, 1 of February 2008, Rafael J. Wysocki wrote:
> > > > Hi,
> > > > 
> > > > This is related to the problem I reported earlier this week:
> > > > http://lkml.org/lkml/2008/1/30/554
> > > > 
> > > > Apparently artswrapper, run by KDE in openSUSE 10.3 with a real time priority,
> > > > is mishandled by the scheduler.  The problem is that after the user logs out,
> > > > artswrapper stays in TASK_RUNNING forever and prevents other tasks from being
> > > > scheduled on the CPU occupied by it.  In this state it also breaks suspend and
> > > > hibernation (it cannot be frozen).
> > > > 
> > > > Since the problem is 100% reproducible on my test boxes, I carried out a
> > > > bisection which turned out the following commit:
> > > > 
> > > > commit 6f505b16425a51270058e4a93441fe64de3dd435
> > > > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > Date:   Fri Jan 25 21:08:30 2008 +0100
> > > > 
> > > >     sched: rt group scheduling
> > > > 
> > > > I'm now checking if the problem disappears after reverting this patch (along a
> > > > couple of dependent ones).
> > > 
> > > Yes, it does.
> > > 
> > > Please let me know what I can do to debug it further.
> > 
> > It arts run as root, or does it use RLIMIT_RTPRIO to allow users to
> > execute realtime tasks?

artswrapper is setuid root and RLIMIT_RTPRIO is apparently not used.
Still, artswrapper is running as a regular user, so it most probably drops
privileges early.

BTW, it fails while running the artsmessage utility used for displaying arts
error messages, so I guess there's an error in arts that this thing tries to
display and deadlocks (or something like that).

Should I test the patch nevertheless?

> If the latter, does this help:
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index ba4c880..bb76cbc 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4563,6 +4563,15 @@ recheck:
>  			return -EPERM;
>  	}
>  
> +#ifdef CONFIG_FAIR_GROUP_SCHED
> +	/*
> +	 * Do not allow realtime tasks into groups that have no runtime
> +	 * assigned.
> +	 */
> +	if (rt_policy(policy) && task_group(p)->rt_ratio == 0)
> +		return -EPERM;
> +#endif
> +
>  	retval = security_task_setscheduler(p, policy, param);
>  	if (retval)
>  		return retval;
> 
