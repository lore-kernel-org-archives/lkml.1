Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbXELIQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbXELIQi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 04:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbXELIQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 04:16:26 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51528 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877AbXELIQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 04:16:25 -0400
Date: Sat, 12 May 2007 13:46:22 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Message-ID: <20070512081622.GA26265@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200705110035.32229.rjw@sisk.pl> <200705120122.07177.rjw@sisk.pl> <alpine.LFD.0.98.0705111625300.3986@woody.linux-foundation.org> <200705120201.42619.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705120201.42619.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 02:01:41AM +0200, Rafael J. Wysocki wrote:
> 
> > So you migt as well not return any value at all, since the returned value 
> > is apparently meaningless once the lock has been released.
> 
> No, it is not meaningless.

Right.

Agreed that the returned value might not necessarily reflect the
current state of thread in question. Can it pose any problems?

Case : is_user_space() returns 0: 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
We think the thread is a kernel thread.
So we don't count this thread when the case is FREEZER_USER_SPACE. 

Now this thread can perform an execve() and enter the 
userspace. It might not freeze.
So we would be declaring that all the userspace threads have been frozen,
when actually we might have this one li'l unfrozen devil from the 
userspace. 

Do we care? 
For cpu hotplug, I don't think so.

Because, like Oleg pointed out,  we know we'll anyway freeze all the 
leftover threads while handling the case FREEZER_KERNEL_THREADS.

But I am not sure if this is the case with suspend/hibernate, since we
need to do a sys_sync() between try_freeze_tasks(FREEZE_USER_SPACE) and
try_to_freeze_tasks(FREEZE_KERNEL_THREADS).


Case:is_user_space() returns 1:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
We think the thread is from userspace.
We count this thread when the case is FREEZER_USER_SPACE. Now the
thread enters the kernel space by either doing a daemonize() or exit().

The freezer code loops *atleast* twice before declaring the system
frozen. So if this metamorphosis occurs between iteration i and
iteration i+1, in i+1, we note that this thread is now a kernel thread,
and don't count it anymore.

However, between the 'i'th and 'i+1'th interation, if this thread calls
try_to_freeze(), it'll enter the refrigerator. We now have a cold
kernel thread when we were trying to freeze only userspace.

So, the question should be, are we clearing the TIF_FREEZING flag in places
where the thread can become a kernel thread and eventually call try_to_freeze.
I won't expect an exiting thread to call try_to_freeze, but a
daemonize()ed thread can.

So should we perform that check in reparent_to_kthreadd() ?
We are protected by the tasklist_lock there, no?

> 
> Rafael

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
