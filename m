Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbYCDJnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbYCDJnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYCDJm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:42:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:24870 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbYCDJm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:42:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,443,1199692800"; 
   d="scan'208";a="528359217"
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are
	dealocked when cpu is set to offline
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: ego@in.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080304090933.GA8997@in.ibm.com>
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com>
	 <20080303153154.GA11288@in.ibm.com>
	 <1204555505.3842.4.camel@yangyi-dev.bj.intel.com>
	 <20080304052613.GA28632@in.ibm.com>  <20080304090933.GA8997@in.ibm.com>
Content-Type: text/plain
Organization: Intel
Date: Tue, 04 Mar 2008 05:56:02 +0800
Message-Id: <1204581362.3842.34.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is the hung_task_timeout message after a couple of cpu-offlines.
> 
> This is on 2.6.25-rc3.
> 
> INFO: task bash:4467 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>        f3701dd0 00000046 f796aac0 f796aac0 f796abf8 cc434b80 00000000 f41ee940 
>        0180b046 0000026e 00000016 00000000 00000008 f796b080 f796aac0 00000002 
>        7fffffff 7fffffff f3701e1c f3701df8 c04e033a f3701e1c f3701dec c0139dec 
> Call Trace:
>  [<c04e033a>] schedule_timeout+0x16/0x8b
>  [<c0139dec>] ? trace_hardirqs_on+0xe9/0x111
>  [<c04e01c9>] wait_for_common+0xcf/0x12e
>  [<c011a3f0>] ? default_wake_function+0x0/0xd
>  [<c04e02aa>] wait_for_completion+0x12/0x14
>  [<c012ccbb>] flush_cpu_workqueue+0x50/0x66
>  [<c012cd28>] ? wq_barrier_func+0x0/0xd
>  [<c012cd14>] cleanup_workqueue_thread+0x43/0x57
>  [<c04c6f87>] workqueue_cpu_callback+0x8e/0xbd
>  [<c04e3975>] notifier_call_chain+0x2b/0x4a
>  [<c0132e9d>] __raw_notifier_call_chain+0xe/0x10
>  [<c0132eab>] raw_notifier_call_chain+0xc/0xe
>  [<c013e054>] _cpu_down+0x150/0x1ec
>  [<c013e133>] cpu_down+0x23/0x30
>  [<c02e3897>] store_online+0x27/0x5a
>  [<c02e3870>] ? store_online+0x0/0x5a
>  [<c02e09d8>] sysdev_store+0x20/0x25
>  [<c0196d2d>] sysfs_write_file+0xad/0xdf
>  [<c0196c80>] ? sysfs_write_file+0x0/0xdf
>  [<c0163da9>] vfs_write+0x8c/0x108
>  [<c0164333>] sys_write+0x3b/0x60
>  [<c01049da>] sysenter_past_esp+0x5f/0xa5
>  =======================
> 3 locks held by bash/4467:
>  #0:  (&buffer->mutex){--..}, at: [<c0196ca5>] sysfs_write_file+0x25/0xdf
>  #1:  (cpu_add_remove_lock){--..}, at: [<c013e10e>] cpu_maps_update_begin+0xf/0x11
>  #2:  (cpu_hotplug_lock){----}, at: [<c013df5b>] _cpu_down+0x57/0x1ec
> 
> So it's not just a not reaping of watchdog thread issue.
> 
> I doubt it's due to some locking dependency since we have lockdep checks
> in the workqueue code before we flush the cpu_workqueue.
You may "echo 1 > /proc/sys/kernel/sysrq" and "echo t
> /proc/sysrq-trigger", then check dmesg info, you can get
[watchdog/#]'s call stack which could give out where it is currently.

On my machine, that indicated [watchdog/1] is calling
sched_setscheduler. I doubt it is being killed before it is started and
woken up, this may result in some synchronization issues.

> 
> --
> Thanks and Regards
> gautham

