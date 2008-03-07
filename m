Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbYCGPuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbYCGPuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 10:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbYCGPuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 10:50:10 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:37849 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbYCGPuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 10:50:08 -0500
Date: Fri, 7 Mar 2008 21:20:02 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Yi Yang <yi.y.yang@intel.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are
	dealocked when cpu is set to offline
Message-ID: <20080307155002.GA22664@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20080303153154.GA11288@in.ibm.com> <1204555505.3842.4.camel@yangyi-dev.bj.intel.com> <20080304052613.GA28632@in.ibm.com> <20080304150107.GA564@tv-sign.ru> <20080306134400.GA1915@in.ibm.com> <20080307025451.GA201@tv-sign.ru> <20080307091049.GA8827@in.ibm.com> <20080307105138.GA10576@in.ibm.com> <b647ffbd0803070502m28355751rd526ed8ca4dd90a@mail.gmail.com> <20080307135537.GB10576@in.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <20080307135537.GB10576@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 07, 2008 at 07:25:37PM +0530, Gautham R Shenoy wrote:
> On Fri, Mar 07, 2008 at 02:02:20PM +0100, Dmitry Adamushko wrote:
> > Hi,
> > 
> > 'watchdog' is of SCHED_FIFO class. The standard load-balancer doesn't
> > move RT tasks between cpus anymore and there is a special mechanism in
> > scher_rt.c instead (I think, it's .25 material).
> > 
> > So I wonder, whether __migrate_task() is still capable of properly
> > moving a RT task to another CPU (e.g. for the case when it's in
> > TASK_RUNNING state) without breaking something in the rt migration
> > mechanism (or whatever else) that would leave us with a runqueue in
> > the 'inconsistent' state...
> > (I've taken a quick look at the relevant code so can't confirm it yet)
> > 
> > maybe it'd be faster if somebody could do a quick test now with the
> > following line commented out in kernel/softlockup.c :: watchdog()
> > 
> > -         sched_setscheduler(current, SCHED_FIFO, &param);
> 
> Commenting out that like seems to work. Passed 500 iterations of
> cpu-hotplug without any problems.

This seems to unearth another problem. After some 850 successful
cpu-hotplug iterations I got this message.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
------------[ cut here ]------------
BUG: spinlock recursion on CPU#2, kstopmachine/32521
BUG: spinlock lockup on CPU#1, kstopmachine/32517, cc43db80
Pid: 32517, comm: kstopmachine Not tainted 2.6.25-rc3 #44
 [<c0284ebb>] <0>BUG: spinlock lockup on CPU#0, kstopmachine/32520, cc43db80
_raw_spin_lock+0xd5/0xf9
 [<c04e1a33>] <0>BUG: spinlock lockup on CPU#3, kstopmachine/32522, cc43db80
_spin_lock+0x20/0x28
Pid: 32522, comm: kstopmachine Not tainted 2.6.25-rc3 #44
 [<c04dfa41>] ?  [<c0284ebb>] schedule+0xb0/0x5ab
 [<c04dfa41>] schedule+0xb0/0x5ab
_raw_spin_lock+0xd5/0xf9
 [<c04e1d58>] ?  [<c04e1a33>] _spin_unlock_irqrestore+0x36/0x3c
 [<c0119fdc>] ? _spin_lock+0x20/0x28
 [<c0119806>] ? complete+0x34/0x3e
 [<c0143646>] double_lock_balance+0x3a/0x57
 [<c0119806>] do_stop+0xd4/0xfe
double_lock_balance+0x3a/0x57
 [<c0143572>] ?  [<c0119af9>] do_stop+0x0/0xfe
pull_rt_task+0x79/0x164
 [<c012f77f>]  [<c011ca9d>] kthread+0x3b/0x64
pre_schedule_rt+0x18/0x1a
 [<c012f744>] ?  [<c04dfaa4>] kthread+0x0/0x64
schedule+0x113/0x5ab
 [<c01056eb>]  [<c04e1923>] ? kernel_thread_helper+0x7/0x10
_write_unlock_irq+0x22/0x26
 =======================
 [<c0139dec>] ? trace_hardirqs_on+0xe9/0x111
 [<c012262a>] do_exit+0x5a6/0x5aa
 [<c013007b>] ? sample_to_timespec+0x16/0x35
 [<c0143670>] ? stopmachine+0x0/0x98
 [<c01056f1>] kernel_thread_helper+0xd/0x10
 =======================
BUG: spinlock lockup on CPU#2, kstopmachine/32521, c065eb00
Pid: 32521, comm: kstopmachine Not tainted 2.6.25-rc3 #44
 [<c0284ebb>] _raw_spin_lock+0xd5/0xf9
 [<c04e1cb5>] _spin_lock_irqsave+0x29/0x32
 [<c011a03f>] ? __wake_up+0x15/0x3b
 [<c011a03f>] __wake_up+0x15/0x3b
 [<c011fa68>] wake_up_klogd+0x2e/0x31
 [<c011fc1e>] release_console_sem+0x1b3/0x1bb
 [<c012002c>] vprintk+0x2a8/0x301
 [<c013ac74>] ? __lock_acquire+0xaae/0xaf6
 [<c012009a>] printk+0x15/0x17
 [<c0284c6f>] spin_bug+0x47/0xbd
 [<c0284e1b>] _raw_spin_lock+0x35/0xf9
 [<c04e1a33>] _spin_lock+0x20/0x28
 [<c011a09b>] ? task_rq_lock+0x36/0x5d
 [<c011a09b>] task_rq_lock+0x36/0x5d
 [<c011a338>] try_to_wake_up+0x19/0xd1
 [<c011a3fb>] default_wake_function+0xb/0xd
 [<c012f850>] autoremove_wake_function+0xf/0x33
 [<c0117ec9>] __wake_up_common+0x2f/0x5a
 [<c011a052>] __wake_up+0x28/0x3b
 [<c011fa68>] wake_up_klogd+0x2e/0x31
 [<c011fc1e>] release_console_sem+0x1b3/0x1bb
 [<c012002c>] vprintk+0x2a8/0x301
 [<c04e196c>] ? _read_unlock+0x1d/0x20
 [<c0441a43>] ? sock_def_readable+0x61/0x69
 [<c048dde8>] ? unix_dgram_sendmsg+0x399/0x410
 [<c012009a>] printk+0x15/0x17
 [<c011f40d>] warn_on_slowpath+0x2a/0x51
 [<c0130066>] ? sample_to_timespec+0x1/0x35
 [<c013ac74>] ? __lock_acquire+0xaae/0xaf6
 [<c011a446>] ? resched_cpu+0x2c/0x6f
 [<c0111691>] native_smp_send_reschedule+0x22/0x3f
 [<c01186c7>] __resched_task+0x5f/0x63
 [<c011a479>] resched_cpu+0x5f/0x6f
 [<c011bb6d>] scheduler_tick+0x214/0x28f
 [<c012737b>] update_process_times+0x3d/0x49
 [<c013751d>] tick_sched_timer+0x6e/0xa6
 [<c01374af>] ? tick_sched_timer+0x0/0xa6
 [<c0131e8c>] __run_hrtimer+0x39/0x70
 [<c0132668>] hrtimer_interrupt+0xeb/0x154
 [<c01127bc>] smp_apic_timer_interrupt+0x6c/0x80
 [<c0143670>] ? stopmachine+0x0/0x98
 [<c0105553>] apic_timer_interrupt+0x33/0x38
 [<c0143670>] ? stopmachine+0x0/0x98
 [<c013007b>] ? sample_to_timespec+0x16/0x35
 [<c0143701>] ? stopmachine+0x91/0x98
 [<c01056eb>] kernel_thread_helper+0x7/0x10
 =======================

BUG: spinlock lockup on CPU#0, kstopmachine/32520, c065eb00

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.config attached.


> 
> > 
> > 
> > -- 
> > Best regards,
> > Dmitry Adamushko
> 
> -- 
> Thanks and Regards
> gautham

-- 
Thanks and Regards
gautham

--/9DWx/yDrRhgMJTb
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="config.gz"
Content-Transfer-Encoding: base64

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
hCOJE5hlijw/WgRs1jDl/wez4sMtvZgAAA==

--/9DWx/yDrRhgMJTb--
