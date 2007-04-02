Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbXDBLTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbXDBLTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 07:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbXDBLTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 07:19:10 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:65359 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbXDBLTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 07:19:09 -0400
Date: Mon, 2 Apr 2007 16:49:00 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Message-ID: <20070402111900.GA30946@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402061612.GA7072@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402061612.GA7072@elte.hu>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 08:16:12AM +0200, Ingo Molnar wrote:
> 
> * Gautham R Shenoy <ego@in.ibm.com> wrote:
> 
> > Hello Everybody,
> > 
> > This is another attempt towards process-freezer based cpu-hotplug. 
> > This patchset covers just about everything that was discussed on the 
> > LKML with respect to the freezer-based cpu-hotplug.
> 
> wow - you have made really nice progress!

The discussions on the list helped clear up a lot of issues.

> 
> > I believe that the reasons for freezer failing as N increases are :
> > - 'make -jN' keeps forking new tasks every now and then, thereby resulting
> >   in a never-ending catching up game in the do_while loop inside
> >   try_to_freeze_tasks (kernel/power/process.c)
> 
> hm, shouldnt the make be frozen immediately?
> 
> doesnt the 'please freeze ASAP' flag get propagated to all tasks, 
> immediately? After that point any cloning activity should duplicate that 
> flag too, resulting in any new child freezing immediately too.
> 
> > Instead of waiting for all the tasks to call try_to_freeze in the 
> > above mentioned do_while loop, I wonder if we can put some hooks in 
> > sched.c so asto not schedule the task marked PF_FREEZING/PF_FROZEN.
> 
> we could definitely do that - but i think it should be unnecessary: if 
> we mark all tasks as PF_FREEZING atomically, that should result in 
> _every_ task immediately dropping dead (once they get back from 
> TASK_UNINTERRUPTIBLE). No excuses. If there's some longer delay then 
> that can only be explained by some new cloned task/thread slipping 
> through the net somehow. (i.e. the PF_FREEZING flag not being duplicated 
> across fork?)
> 

I will try again  Vatsa's suggestion of having a 

if (freezing(current))
	freeze_process(p);

in copy processes() and check if we can do away with the fork race. 
That sounds lot simpler than the scheduler hooks.

> i'm wondering about how TASK_UNINTERRUPTIBLE tasks are handled by the 
> freezer: are they assumed frozen immediately, or do we wait until they 
> notice their PF_FREEZING and go into try_to_freeze()? I'd expect 
> TASK_UNINTERRUPTIBLE to be the largest source of latency. (and hence be 
> the primary source for freezing 'failures')

>From what I can make out, we fail to freeze if we have some task in
the TASK_UNINTERRUPTIBLE state for more than the timeout period. 

The kernel threads have to call try_to_freeze() explicitly and for the
userspace tasks, try_to_freeze() is called in get_signal_to_deliver().
The system is considered frozen only when *all* the freezeable tasks
call try_to_freeze() one way or the other. This is unlikely in case of
a TASK_UNINTERRUPTIBLE task.

Question is can we have some task in TASK_UNINTERRUPTIBLE state for such
a long duration (20sec) ??

> 
> 	Ingo

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
