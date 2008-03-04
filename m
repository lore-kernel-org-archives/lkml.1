Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYCDJKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYCDJKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYCDJKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:10:03 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:57462 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYCDJJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:09:58 -0500
Date: Tue, 4 Mar 2008 14:39:33 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Yi Yang <yi.y.yang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are
	dealocked when cpu is set to offline
Message-ID: <20080304090933.GA8997@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com> <20080303153154.GA11288@in.ibm.com> <1204555505.3842.4.camel@yangyi-dev.bj.intel.com> <20080304052613.GA28632@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304052613.GA28632@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 10:56:13AM +0530, Gautham R Shenoy wrote:
> On Mon, Mar 03, 2008 at 10:45:04PM +0800, Yi Yang wrote:
> > On Mon, 2008-03-03 at 21:01 +0530, Gautham R Shenoy wrote:
> > > > This issue seems such one, but i tried to change it to follow this rule but
> > > > the issue is still there.
> > > > 
> > > > Why isn't the kernel thread [watchdog/1] reaped by its parent? its state
> > > > is TASK_RUNNING with high priority (R< means this), why it isn't done?
> > > > 
> > > > Anyone ever met such a problem? Your thought?
> > > 
> > > Hi Yi,
> > > 
> > > This is indeed strange. I am able to reproduce this problem on my 4-way
> > > box. From what I see in the past two runs, we're waiting in the
> > > cpu-hotplug callback path for the watchdog/1 thread to stop.
> > > 
> > > During cpu-offline, once the cpu goes offline, in the migration_call(), 
> > > we migrate any tasks associated with the offline cpus
> > > to some other cpu. This also mean breaking affinity for tasks which were
> > > affined to the cpu which went down. So watchdog/1 has been migrated to
> > > some other cpu.
> > No, [watchdog/1] is just for CPU #1, if CPU #1 has been offline, it
> > should be killed but not migrated to other CPU because other CPU has
> > such a kthread.
> 
> Yes, it is killed once it gets a chance to run *after* cpu goes offline.
> The moment it runs on some other cpu, it will see the kthread_should_stop()
> because in the cpu-hotplug callback path we've issues a 
> kthread_stop(watchdog/1)
> 
> Again, we can argue that we could issue a kthread_stop() 
> in CPU_DOWN_PREPARE, rather than in CPU_DEAD and restart 
> it in CPU_DOWN_FAILED if the cpu-hotplug operation does fail.
> 
> > 
> > Maybe migration_call was doing such a bad thing. :-)
> 
> Nope, from what I see migration call is not having any problems. It is
> behaving the way it is supposed to behave :)
> 
> The other observation I noted was the WARN_ON_ONCE() in hrtick() [1]
> that I am consistently hitting after the first cpu goes offline.
> 
> So at times, the callback thread is blocked on kthread_stop(k) in
> softlockup.c, while other time, it was blocked in
> cleanup_workqueue_threads() in workqueue.c. 

This is the hung_task_timeout message after a couple of cpu-offlines.

This is on 2.6.25-rc3.

INFO: task bash:4467 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
       f3701dd0 00000046 f796aac0 f796aac0 f796abf8 cc434b80 00000000 f41ee940 
       0180b046 0000026e 00000016 00000000 00000008 f796b080 f796aac0 00000002 
       7fffffff 7fffffff f3701e1c f3701df8 c04e033a f3701e1c f3701dec c0139dec 
Call Trace:
 [<c04e033a>] schedule_timeout+0x16/0x8b
 [<c0139dec>] ? trace_hardirqs_on+0xe9/0x111
 [<c04e01c9>] wait_for_common+0xcf/0x12e
 [<c011a3f0>] ? default_wake_function+0x0/0xd
 [<c04e02aa>] wait_for_completion+0x12/0x14
 [<c012ccbb>] flush_cpu_workqueue+0x50/0x66
 [<c012cd28>] ? wq_barrier_func+0x0/0xd
 [<c012cd14>] cleanup_workqueue_thread+0x43/0x57
 [<c04c6f87>] workqueue_cpu_callback+0x8e/0xbd
 [<c04e3975>] notifier_call_chain+0x2b/0x4a
 [<c0132e9d>] __raw_notifier_call_chain+0xe/0x10
 [<c0132eab>] raw_notifier_call_chain+0xc/0xe
 [<c013e054>] _cpu_down+0x150/0x1ec
 [<c013e133>] cpu_down+0x23/0x30
 [<c02e3897>] store_online+0x27/0x5a
 [<c02e3870>] ? store_online+0x0/0x5a
 [<c02e09d8>] sysdev_store+0x20/0x25
 [<c0196d2d>] sysfs_write_file+0xad/0xdf
 [<c0196c80>] ? sysfs_write_file+0x0/0xdf
 [<c0163da9>] vfs_write+0x8c/0x108
 [<c0164333>] sys_write+0x3b/0x60
 [<c01049da>] sysenter_past_esp+0x5f/0xa5
 =======================
3 locks held by bash/4467:
 #0:  (&buffer->mutex){--..}, at: [<c0196ca5>] sysfs_write_file+0x25/0xdf
 #1:  (cpu_add_remove_lock){--..}, at: [<c013e10e>] cpu_maps_update_begin+0xf/0x11
 #2:  (cpu_hotplug_lock){----}, at: [<c013df5b>] _cpu_down+0x57/0x1ec

So it's not just a not reaping of watchdog thread issue.

I doubt it's due to some locking dependency since we have lockdep checks
in the workqueue code before we flush the cpu_workqueue.

--
Thanks and Regards
gautham
