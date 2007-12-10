Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbXLJKED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbXLJKED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 05:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbXLJKDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 05:03:52 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:49387 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbXLJKDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 05:03:52 -0500
Date: Mon, 10 Dec 2007 13:49:52 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
Message-ID: <20071210081952.GA7215@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <47595A0A.5000502@gmail.com> <20071207151150.GB24254@elte.hu> <20071207175134.GA18916@elte.hu> <475A5188.6070809@gmail.com> <20071208083939.GD30997@elte.hu> <475A629C.7010408@gmail.com> <20071208152447.GA30270@elte.hu> <475B24F4.3090904@gmail.com> <20071209074647.GE22981@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209074647.GE22981@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2007 at 08:46:47AM +0100, Ingo Molnar wrote:
> 
> * Jiri Slaby <jirislaby@gmail.com> wrote:
> 
> > On 12/08/2007 04:24 PM, Ingo Molnar wrote:
> > > i'm wondering why it had no effect now
> > 
> > diff --git a/kernel/cpu.c b/kernel/cpu.c
> > index e0d3a4f..a46c252 100644
> > --- a/kernel/cpu.c
> > +++ b/kernel/cpu.c
> > @@ -47,15 +47,21 @@ void __init cpu_hotplug_init(void)
> >  }
> > 
> >  #ifdef CONFIG_HOTPLUG_CPU
> > -
> > +#include <asm/io.h>
> >  void get_online_cpus(void)
> >  {
> > +       outb(0x20, 0x80);
> >         might_sleep();
> > +       outb(0x21, 0x80);
> 
> ah. If you comment out get_online_cpus()/put_online_cpus() from 
> kernel/softlockup.c, does it start working?
> 
> Gautham, any ideas?
Hi Ingo, 

>From the code I fail to see how get_online_cpus() can help us. 

+		/*
+		 * Only do the hung-tasks check on one CPU:
+		 */
+		get_online_cpus();
+		check_cpu = any_online_cpu(cpu_online_map);
+		put_online_cpus();

check_cpu can go offline here, no?

+
+		if (this_cpu != check_cpu)
+			continue;
+
+		if (sysctl_hung_task_timeout_secs)
+			check_hung_uninterruptible_tasks(this_cpu);

Further more this can cause a deadlock since we're calling 
get_online_cpus() from the watchdog thread's context, 
which is going to be kthread_stop'ed from a cpu-hotplug context.
This is what I think was happening in the case reported by Jiri.

Please find the patch below.

Thanks and Regards
gautham.

commit 15bfb662b35c609490185fba2fd4713d230b9374
Author: Gautham R Shenoy <ego@in.ibm.com>
Date:   Mon Dec 10 13:41:45 2007 +0530

softlockup: remove get_online_cpus() which doesn't help here.

The get_online_cpus() protection seems to be bogus
in kernel/softlockup.c as cpu cached in check_cpu can go offline
once we do a put_online_cpus().

This can also cause deadlock during a cpu offline as follows:

WATCHDOG_THREAD:		OFFLINE_CPU:
				mutex_down(&cpu_hotplug.lock);
				/* All subsequent get_online_cpus
				 * will be blocked till we're
				 * done with this cpu-hotplug
				 * operation.
				 */

get_online_cpus();
/* watchdog is blocked
   Thus we cannot
   go further until
   the cpu-hotplug
   operation completes
 */
 				CPU_DEAD:
    				kthread_stop(watchdog_thread);

    				/* we're trying to stop a
    				 * thread which is blocked
    				 * waiting for us to finish.
    				 *
    				 * Since we cannot finish until
    				 * the thread stops, we deadlock here!
    				 */
    
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linuxtronix.de>
Cc: Arjan van de Van <arjan@linux.intel.com>
Cc: Jiri Slaby <jirislaby@gmail.com>

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index e50b44a..576eb9c 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -219,9 +219,7 @@ static int watchdog(void *__bind_cpu)
 		/*
 		 * Only do the hung-tasks check on one CPU:
 		 */
-		get_online_cpus();
 		check_cpu = any_online_cpu(cpu_online_map);
-		put_online_cpus();
 
 		if (this_cpu != check_cpu)
 			continue;

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
