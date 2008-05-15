Return-Path: <linux-kernel-owner+w=401wt.eu-S1762765AbYEOSDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762765AbYEOSDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYEOSDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:03:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162AbYEOSDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:03:06 -0400
Date: Thu, 15 May 2008 11:02:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bugme-new] [Bug 10701] New: snd_pcsp lockdep warning
Message-Id: <20080515110244.6e15d4c3.akpm@linux-foundation.org>
In-Reply-To: <bug-10701-10286@http.bugzilla.kernel.org/>
References: <bug-10701-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu, 15 May 2008 03:43:36 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=10701
> 
>            Summary: snd_pcsp lockdep warning
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.26-rc2
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Sound(ALSA)
>         AssignedTo: perex@perex.cz
>         ReportedBy: nuclearcat@nuclearcat.com
> 
> 
> Latest working kernel version: unknown
> Earliest failing kernel version: 2.6.26-rc2
> Distribution: Gentoo
> Hardware Environment: Intel 965 chipset, Core 2 Duo
> Software Environment: mplayer
> Problem Description: Just lockdep warning in dmesg

This looks like a problem in the core hrtimers code?

> Steps to reproduce: while playing HD video got this.
> [52478.405955] =======================================================
> [52478.405955] [ INFO: possible circular locking dependency detected ]
> [52478.405955] 2.6.26-rc2-devel #1
> [52478.405955] -------------------------------------------------------
> [52478.405955] mplayer/4814 is trying to acquire lock:
> [52478.405955]  (&pcsp_chip.substream_lock){++..}, at: [<f88af285>]
> pcsp_do_timer+0x51/0x2a8 [snd_pcsp]
> [52478.405955]
> [52478.405955] but task is already holding lock:
> [52478.405955]  (&cpu_base->lock){++..}, at: [<c0136ac4>]
> hrtimer_interrupt+0x6c/0x154
> [52478.405955]
> [52478.405955] which lock already depends on the new lock.
> [52478.405955]
> [52478.405955]
> [52478.405955] the existing dependency chain (in reverse order) is:
> [52478.405955]
> [52478.405955] -> #5 (&cpu_base->lock){++..}:
> [52478.405955]        [<c013fc8e>] __lock_acquire+0x982/0xb37
> [52478.405955]        [<c013feaf>] lock_acquire+0x6c/0x89
> [52478.405955]        [<c030783a>] _spin_lock_irqsave+0x25/0x55
> [52478.405955]        [<c01366c2>] lock_hrtimer_base+0x18/0x33
> [52478.405955]        [<c01367aa>] hrtimer_start+0x19/0x100
> [52478.405955]        [<c011b656>] enqueue_rt_entity+0xf7/0x10e
> [52478.405955]        [<c011b6cb>] enqueue_task_rt+0x36/0x4a
> [52478.405955]        [<c0118235>] enqueue_task+0x4c/0x58
> [52478.405955]        [<c011825a>] activate_task+0x19/0x1f
> [52478.405955]        [<c011a9f7>] try_to_wake_up+0x17c/0x1be
> [52478.405955]        [<c011aa61>] wake_up_process+0xf/0x11
> [52478.405955]        [<c0303060>] migration_call+0xb4/0x403
> [52478.405955]        [<c0440d1b>] migration_init+0x38/0x45
> [52478.405955]        [<c043439b>] kernel_init+0x49/0x22a
> [52478.405955]        [<c01045af>] kernel_thread_helper+0x7/0x10
> [52478.405955]        [<ffffffff>] 0xffffffff
> [52478.405955]
> [52478.405955] -> #4 (&rt_b->rt_runtime_lock){++..}:
> [52478.405955]        [<c013fc8e>] __lock_acquire+0x982/0xb37
> [52478.405955]        [<c013feaf>] lock_acquire+0x6c/0x89
> [52478.405955]        [<c030748f>] _spin_lock+0x1c/0x49
> [52478.405955]        [<c011b613>] enqueue_rt_entity+0xb4/0x10e
> [52478.405955]        [<c011b6cb>] enqueue_task_rt+0x36/0x4a
> [52478.405955]        [<c0118235>] enqueue_task+0x4c/0x58
> [52478.405955]        [<c011825a>] activate_task+0x19/0x1f
> [52478.405955]        [<c011a9f7>] try_to_wake_up+0x17c/0x1be
> [52478.405955]        [<c011aa61>] wake_up_process+0xf/0x11
> [52478.405955]        [<c0303060>] migration_call+0xb4/0x403
> [52478.405955]        [<c0440d1b>] migration_init+0x38/0x45
> [52478.405955]        [<c043439b>] kernel_init+0x49/0x22a
> [52478.405955]        [<c01045af>] kernel_thread_helper+0x7/0x10
> [52478.405955]        [<ffffffff>] 0xffffffff
> [52478.405955]
> [52478.405955] -> #3 (&rq->rq_lock_key){++..}:
> [52478.405955]        [<c013fc8e>] __lock_acquire+0x982/0xb37
> [52478.405955]        [<c013feaf>] lock_acquire+0x6c/0x89
> [52478.405955]        [<c030748f>] _spin_lock+0x1c/0x49
> [52478.405955]        [<c011a634>] task_rq_lock+0x36/0x5d
> [52478.405955]        [<c011a8a5>] try_to_wake_up+0x2a/0x1be
> [52478.405955]        [<c011aa44>] default_wake_function+0xb/0xd
> [52478.405955]        [<c0117dad>] __wake_up_common+0x2f/0x5a
> [52478.405955]        [<c0119c2a>] complete+0x2b/0x3e
> [52478.405955]        [<c0133b93>] kthread+0x1f/0x64
> [52478.405955]        [<c01045af>] kernel_thread_helper+0x7/0x10
> [52478.405955]        [<ffffffff>] 0xffffffff
> [52478.405955]
> [52478.405955] -> #2 (&q->lock){++..}:
> [52478.405955]        [<c013fc8e>] __lock_acquire+0x982/0xb37
> [52478.405955]        [<c013feaf>] lock_acquire+0x6c/0x89
> [52478.405955]        [<c030783a>] _spin_lock_irqsave+0x25/0x55
> [52478.405955]        [<c0119c96>] __wake_up+0x15/0x3b
> [52478.405955]        [<f88c6f2d>] snd_pcm_post_stop+0x51/0x5a [snd_pcm]
> [52478.405955]        [<f88c6353>] snd_pcm_action_single+0x33/0x4b [snd_pcm]
> [52478.405955]        [<f88c7238>] snd_pcm_action+0x68/0x74 [snd_pcm]
> [52478.405955]        [<f88c7268>] snd_pcm_stop+0x11/0x13 [snd_pcm]
> [52478.405955]        [<f88c7302>] snd_pcm_drop+0x98/0xbb [snd_pcm]
> [52478.405955]        [<f88c9cf0>] snd_pcm_common_ioctl1+0xe7c/0xf6d [snd_pcm]
> [52478.405955]        [<f88ca4a3>] snd_pcm_playback_ioctl1+0x355/0x36c
> [snd_pcm]
> [52478.405955]        [<f88ca4f2>] snd_pcm_kernel_ioctl+0x38/0x5d [snd_pcm]
> [52478.405955]        [<f89fc93e>] snd_pcm_oss_change_params+0xaee/0xea7
> [snd_pcm_oss]
> [52478.405955]        [<f89fd04f>] snd_pcm_oss_get_active_substream+0x34/0x4c
> [snd_pcm_oss]
> [52478.405955]        [<f89fd075>] snd_pcm_oss_get_format+0xe/0x20
> [snd_pcm_oss]
> [52478.405955]        [<f89fe246>] snd_pcm_oss_ioctl+0x3c0/0x9a5 [snd_pcm_oss]
> [52478.405955]        [<c0179202>] vfs_ioctl+0x22/0x67
> [52478.405955]        [<c01794ab>] do_vfs_ioctl+0x264/0x27b
> [52478.405955]        [<c01794ee>] sys_ioctl+0x2c/0x46
> [52478.405955]        [<c01038b9>] sysenter_past_esp+0x6a/0xb1
> [52478.405955]        [<ffffffff>] 0xffffffff
> [52478.405955]
> [52478.405955] -> #1 (&substream->self_group.lock){.+..}:
> [52478.405955]        [<c013fc8e>] __lock_acquire+0x982/0xb37
> [52478.405955]        [<c013feaf>] lock_acquire+0x6c/0x89
> [52478.405955]        [<c030748f>] _spin_lock+0x1c/0x49
> [52478.405955]        [<f88af2b3>] pcsp_do_timer+0x7f/0x2a8 [snd_pcsp]
> [52478.405955]        [<c0136372>] run_hrtimer_pending+0x3a/0xcb
> [52478.405955]        [<c0136419>] run_hrtimer_softirq+0x16/0x18
> [52478.405955]        [<c0127f51>] __do_softirq+0x6f/0xe9
> [52478.405955]        [<c01059c3>] do_softirq+0x5e/0xa8
> [52478.405955]        [<ffffffff>] 0xffffffff
> [52478.405955]
> [52478.405955] -> #0 (&pcsp_chip.substream_lock){++..}:
> [52478.405955]        [<c013fbb5>] __lock_acquire+0x8a9/0xb37
> [52478.405955]        [<c013feaf>] lock_acquire+0x6c/0x89
> [52478.405955]        [<c030783a>] _spin_lock_irqsave+0x25/0x55
> [52478.405955]        [<f88af285>] pcsp_do_timer+0x51/0x2a8 [snd_pcsp]
> [52478.405955]        [<c0136311>] __run_hrtimer+0x49/0x70
> [52478.405955]        [<c0136b43>] hrtimer_interrupt+0xeb/0x154
> [52478.405955]        [<c0110670>] smp_apic_timer_interrupt+0x6c/0x80
> [52478.405955]        [<c0104417>] apic_timer_interrupt+0x33/0x38
> [52478.405955]        [<f89ff159>] snd_pcm_plug_write_transfer+0x75/0x9f
> [snd_pcm_oss]
> [52478.405955]        [<f89fb6d8>] snd_pcm_oss_write2+0x82/0xc0 [snd_pcm_oss]
> [52478.405955]        [<f89fcfb6>] snd_pcm_oss_write+0x165/0x1ca [snd_pcm_oss]
> [52478.405955]        [<c016f557>] vfs_write+0x8c/0x108
> [52478.405955]        [<c016faee>] sys_write+0x3b/0x60
> [52478.405955]        [<c01038b9>] sysenter_past_esp+0x6a/0xb1
> [52478.405955]        [<ffffffff>] 0xffffffff
> [52478.405955]
> [52478.405955] other info that might help us debug this:
> [52478.405955]
> [52478.405955] 2 locks held by mplayer/4814:
> [52478.405955]  #0:  (&runtime->oss.params_lock){--..}, at: [<f89fceb7>]
> snd_pcm_oss_write+0x66/0x1ca [snd_pcm_oss]
> [52478.405955]  #1:  (&cpu_base->lock){++..}, at: [<c0136ac4>]
> hrtimer_interrupt+0x6c/0x154
> [52478.405955]
> [52478.405955] stack backtrace:
> [52478.405955] Pid: 4814, comm: mplayer Not tainted 2.6.26-rc2-devel #1
> [52478.405955]  [<c013de71>] print_circular_bug_tail+0x5b/0x66
> [52478.405955]  [<c013fbb5>] __lock_acquire+0x8a9/0xb37
> [52478.405955]  [<c013feaf>] lock_acquire+0x6c/0x89
> [52478.405955]  [<f88af285>] ? pcsp_do_timer+0x51/0x2a8 [snd_pcsp]
> [52478.405955]  [<c030783a>] _spin_lock_irqsave+0x25/0x55
> [52478.405955]  [<f88af285>] ? pcsp_do_timer+0x51/0x2a8 [snd_pcsp]
> [52478.405955]  [<f88af234>] ? pcsp_do_timer+0x0/0x2a8 [snd_pcsp]
> [52478.405955]  [<f88af285>] pcsp_do_timer+0x51/0x2a8 [snd_pcsp]
> [52478.405955]  [<c0136134>] ? __remove_hrtimer+0x62/0x6a
> [52478.405955]  [<f88af234>] ? pcsp_do_timer+0x0/0x2a8 [snd_pcsp]
> [52478.405955]  [<c0136311>] __run_hrtimer+0x49/0x70
> [52478.405955]  [<c0136b43>] hrtimer_interrupt+0xeb/0x154
> [52478.405955]  [<c0110670>] smp_apic_timer_interrupt+0x6c/0x80
> [52478.405955]  [<c0104417>] apic_timer_interrupt+0x33/0x38
> [52478.405955]  [<f8a0022d>] ? linear_transfer+0xce/0x155 [snd_pcm_oss]
> [52478.405955]  [<f89ff159>] snd_pcm_plug_write_transfer+0x75/0x9f
> [snd_pcm_oss]
> [52478.405955]  [<f89fb6d8>] snd_pcm_oss_write2+0x82/0xc0 [snd_pcm_oss]
> [52478.405955]  [<f89fcfb6>] snd_pcm_oss_write+0x165/0x1ca [snd_pcm_oss]
> [52478.405955]  [<f89fce51>] ? snd_pcm_oss_write+0x0/0x1ca [snd_pcm_oss]
> [52478.405955]  [<c016f557>] vfs_write+0x8c/0x108
> [52478.405955]  [<c016faee>] sys_write+0x3b/0x60
> [52478.405955]  [<c01038b9>] sysenter_past_esp+0x6a/0xb1
> [52478.405955]  =======================

