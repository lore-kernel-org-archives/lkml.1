Return-Path: <linux-kernel-owner+w=401wt.eu-S1767082AbXDTM0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767082AbXDTM0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 08:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767081AbXDTM0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 08:26:13 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33849 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767072AbXDTM0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 08:26:12 -0400
Date: Fri, 20 Apr 2007 17:56:09 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@in.ibm.com,
       paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC PATCH(experimental) 2/2] Fix freezer-kthread_stop race
Message-ID: <20070420122609.GA22325@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070419120131.GB13435@in.ibm.com> <200704201054.38037.rjw@sisk.pl> <20070420110520.GB11290@in.ibm.com> <200704201359.30490.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704201359.30490.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 01:59:29PM +0200, Rafael J. Wysocki wrote:
> 
> Actually, I thought about it for a while.  The thread that is going to stop
> another one may temporarily mark itself as freezable in all cases, which
> will have no effect on it, since it's not going to cally try_to_freeze(), but
> will make the freezer wait for it.  Next, after returning from
> wait_for_completion(), it should restore its old freezability status and that
> should make the freezer finish.

But that will have no affect if the thread to be stopped is already
frozen. The only affect might be that now, freezer will fail whether
the thread that is going to stop another one was freezeable or not.

Concern is whether we can somehow complete these wait_for_completion()'s in 
the freezing context and reduce the probabilty of freezer failing.

> 
> > However, I was attempting to solve the generic problem where
> > A waits on B and B is frozen. If A is freezeable (under one of the
> > events) then the freezer will fail. So a solution would be for A to
> > somehow inform B of the dependency and postpone it's freezing.
> 
> Well, I think it might be simpler to consider each case separately.  This way
> we may be able to avoid introducing the additional TIF_ flag.
> 

Makes sense.

> > Since akpm mentioned that flush_workqueue() needs to go, I guess, I am
> > ok with fixing only kthread_stop/kthread_should_stop for the moment.
> > Unless I can spot any other valid case :)
> 
> Sure. :-)
> 
> BTW, if it turns out that we need to introduce yet another freezer-related
> TIF_ flag, it may be acceptable (?) to move all of the freezer-related flags
> into a separate member of task_struct (eg. freezer_flags) that can only be
> manipulated under task_lock().
> 
> I mean, we already have four of them (PF_NOFREEZE, PF_FROZEN,
> PF_FREEZER_SKIP, TIF_FREEZE), and you will need to introduce two more for
> the freezer-based CPU hotplug, so if yet another one is needed, that will make
> up almost a separate u8 field ...

I am perfectly ok with it. But I am not sure if everybody would agree to have
another field in the task struct, though in this case it does make sense :-)

> 
> Greetings,
> Rafael
> -

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
