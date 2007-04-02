Return-Path: <linux-kernel-owner+w=401wt.eu-S965475AbXDBOQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965475AbXDBOQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 10:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965489AbXDBOQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 10:16:17 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:41645 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965475AbXDBOQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 10:16:16 -0400
Date: Mon, 2 Apr 2007 19:46:03 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Message-ID: <20070402141603.GA25958@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402061612.GA7072@elte.hu> <20070402092818.GE2456@in.ibm.com> <20070402111828.GA14771@elte.hu> <20070402124200.GA9566@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402124200.GA9566@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 06:12:00PM +0530, Srivatsa Vaddagiri wrote:
> On Mon, Apr 02, 2007 at 01:18:28PM +0200, Ingo Molnar wrote:
> > > 	if (freezing(current))
> > > 		freeze_process(p);	/* function exported by freezer */
> > 
> > yeah. (is that safe with tasklist_lock held?)
> 
> from my scan of the code, it appears to be safe ..

I quickly coded this up and ran my tests again. Unfortunately, the
results are negative. I printk'd the state of the unfrozen task and 
this is how the serial console output looks like:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Stopping user space processes timed out after 20 seconds (7 tasks
refusing to freeze)
make:TASK_UNINTERRUPTIBLE
make:TASK_UNINTERRUPTIBLE
make:TASK_UNINTERRUPTIBLE
make:TASK_UNINTERRUPTIBLE
make:TASK_UNINTERRUPTIBLE
make:TASK_UNINTERRUPTIBLE
make:TASK_UNINTERRUPTIBLE
Restarting tasks ... done.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I couldn't see any reduction in the number of
freeze-failures. Thus Ingo right.  These failures are due
to the TASK_UNINTERRUPTIBLE tasks which fail to freeze within the
timeout period and not because of the fork race.

> 
> > i'm wondering whether we could do even better than the signal approach. 
> > I _think_ the best approach would be to only wait for tasks that are _on 
> > the runqueue_. I.e. any task that has scheduled away with 
> > TASK_UNINTERRUPTIBLE (and might not be able to process signal events for 
> > a long time) is still freezable because it scheduled away.
> 
> I am slightly uncomfortable with "not waiting for tasks inside the
> kernel to get out" part, even if it that is done only for
> TASK_UNINTERRUPTIBLE tasks. For ex: consider this:
> 
> flush_workqueue() <- One of biggest offenders of lock_cpu_hotplug() to date
> 	for_each_online_cpu(cpu)
> 		flush_cpu_workqueue
> 			TASK_UNINTERRUPTIBLE sleep
> 
> If we don't wait for this thread from being frozen "voluntarily" (because it is 
> in TASK_UNINTERRUPTIBLE sleep), then flush_workqueue is clearly racy wrt
> cpu hotplug.
> 

The other option would be to have another state equivalent to 
TASK_UNINTERRUPTIBLE_NOFREEZE, so that Ingo's solution can be applied
for regular TASK_UNINTERRUPTIBLE tasks. Thus TASK_UNINTERRUPTBLE tasks
from a for_each_online_cpu context should now do a
TASK_UNINTERRUPTIBLE_NOFREEZE instead. 

Hmm, lots of audit and hence defeats the purpose.

> I would imagine other situations like this are possible where "not waiting
> for everyone to /voluntarily/ quiece" can break cpu hotplug. In fact,
> the biggest reason why we are moving to freezer based hotplug is the
> fact that it quiesces everyone, leading to (hopefully) zero race conditions.
> 
> -- 
> Regards,
> vatsa

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
