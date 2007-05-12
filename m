Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbXELKN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbXELKN0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 06:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbXELKNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 06:13:20 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38119 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242AbXELKNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 06:13:19 -0400
Date: Sat, 12 May 2007 15:43:17 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Message-ID: <20070512101317.GB8860@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200705110035.32229.rjw@sisk.pl> <200705120201.42619.rjw@sisk.pl> <20070512081622.GA26265@in.ibm.com> <200705121127.37655.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705121127.37655.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 11:27:36AM +0200, Rafael J. Wysocki wrote:
> On Saturday, 12 May 2007 10:16, Gautham R Shenoy wrote:
> > 
> > But I am not sure if this is the case with suspend/hibernate, since we
> > need to do a sys_sync() between try_freeze_tasks(FREEZE_USER_SPACE) and
> > try_to_freeze_tasks(FREEZE_KERNEL_THREADS).
> 
> From the point of view of syncing it's only necessary to make sure that we
> won't freeze a kernel thread that's needed for the syncing.  We can have an
> additional user space task running at this point.

Ok. Say we're might have an additional user space task which is not
frozen (say A).

> > 
> > So should we perform that check in reparent_to_kthreadd() ?
> > We are protected by the tasklist_lock there, no?
> 
> Yes.  Still, I think the daemonize()ed threads should clear their TIF_FREEZE
> flag unconditionally right after they have called exit_mm().  So that would be
> in daemonize().
> 
> Or, perhaps, it's better to clear TIF_FREEZE (unconditionally) in exit_mm(),
> after we've done tsk->mm = NULL?  Oleg, what do you think?
>
Is the following scenario possible? 

FREEZE_KERNEL_THREADS: 
1) Mark all leftover threads as freezeable. That would include 'A'.
2) 'A' is now daemonised and we clear TIF_FREEZE in exit_mm().
3) 'A' calls try_to_freeze() but doesn't enter the refrigerator.

Hmm, on second thought, this shouldn't matter .
The subsequent iteration will set A's TIF_FREEZE flag anyway, right? 
So I think it should be ok to unconditionally clear the TIF_FREEZE flag
in exit_mm() after tsk->mm = NULL.


> Greetings,
> Rafael 

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
