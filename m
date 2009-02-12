Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZBLCNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZBLCNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 21:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbZBLCNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 21:13:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:44822 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbZBLCNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 21:13:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a6hW0GQuPcoa4iOaegGca3sRuZd28Cm63deneJV+Ejg2XvGS9HJkLsKQn6OJQLUaJM
         08+ggC0AclWQITOoqpp7IV25t+YpFYCnoSbmAVrFdBOKTi1cAyPOpDGa8PUVT8+TvgDg
         8cC5/y/6RvwFhmkakGne6Rn1Jvs8jQA+F2Fa4=
Date: Thu, 12 Feb 2009 03:12:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@tglx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: Re: [Announce] 2.6.29-rc4-rt1
Message-ID: <20090212021257.GB4697@nowhere>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <20090212005032.GA4788@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212005032.GA4788@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 01:50:32AM +0100, Frederic Weisbecker wrote:
> On Wed, Feb 11, 2009 at 11:43:44PM +0100, Thomas Gleixner wrote:
> > After a 1.5 years sabbatical from preempt-rt we are pleased to
> > announce a refactored preempt-rt patch against linux-2.6.29-rc4.
> > 
> > The patch is working on x86 (32 and 64bit) but we have not yet updated
> > ARM, PPC and MIPS (work in progress).
> > 
> > We also dropped some experimental features of the base preempt-rt
> > queue 2.6.26.8-rt15 simply because we wanted to survive the forward
> > port over 3 kernel releases with the least amount of surprises. These
> > features (e.g. multiple reader PI locks) are not essential for the
> > preempt-rt functionality and need some serious overhaul anyway.
> > 
> > The interested -rt observer might have noticed that we based our work
> > on the 2.6.26.8-rt15 patch queue and did not pick the git-rt tree
> > which is based on 2.6.28. The reason for this is that we wanted to pick
> > the most stable patch queue and the git-rt tree has a lot of rewritten
> > new code. Our work is not making the work which was done over the last
> > months in the git-rt tree obsolete, quite the contrary: we want to
> > provide a stable yet latest-kernel based foundation and integrate those
> > changes gradually, as they become ready.
> > 
> > The further plan for the new -rt series is to merge it fully into git
> > and integrate it into the -tip git tree so it gets the same treatment
> > as all of our -tip based work: fully automated compile and boot
> > testing. Furthermore an automated multi architecture -rt performance
> > regression test based on the same infrastructure is currently being
> > built.
> > 
> > The integration into the -tip tree also allows us to seperate out parts
> > of -rt which are ready for mainline more easily and integrate them
> > with our usual propagation to mainline.
> > 
> > The structure of the patches is likely to change over the next days
> > when we tackle the git integration, but we appreciate your feedback in
> > the form of comments, bugreports and patches.
> > 
> 
> 
> Hi!
> 
> I get some sleep while atomic warnings.
> I've put the log and my config in attachment.
> 
> 

Note, it's a wicked bug: I can't reproduce it anymore.
I would have been glad to give you an irqsoff trace but I can't :-)

Oh yes I have two other warnings, for the second one, I'm not sure
this is really only present in -rt.

The first one, a lockdep warning:

[    2.975320] ---------------------------------
[    2.975320] inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
[    2.975320] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[    2.975320]  (per_cpu__lock_slab_irq_locks_locked#2){+-..}, at: [<ffffffff802f6823>] kfree+0x43/0xc0
[    2.975320] {hardirq-on-W} state was registered at:
[    2.975320]   [<ffffffff802822c5>] __lock_acquire+0x6f5/0x1b20
[    2.975320]   [<ffffffff8028378f>] lock_acquire+0x9f/0xe0
[    2.975320]   [<ffffffff8077c7f5>] rt_spin_lock+0x85/0xb0
[    2.975320]   [<ffffffff802f8251>] kmem_cache_alloc+0x51/0x1f0
[    2.975320]   [<ffffffff80253eab>] copy_process+0x9b/0x1500
[    2.975320]   [<ffffffff802553a0>] do_fork+0x90/0x4a0
[    2.975320]   [<ffffffff80213552>] kernel_thread+0x82/0xe0
[    2.975320]   [<ffffffff802135ba>] child_rip+0xa/0x20
[    2.975320]   [<ffffffffffffffff>] 0xffffffffffffffff
[    2.975320] irq event stamp: 18114
[    2.975320] hardirqs last  enabled at (18113): [<ffffffff8021a935>] default_idle+0x55/0x60
[    2.975320] hardirqs last disabled at (18114): [<ffffffff8021222a>] save_args+0x6a/0x70
[    2.975320] softirqs last  enabled at (0): [<ffffffff8025449d>] copy_process+0x68d/0x1500
[    2.975320] softirqs last disabled at (0): [<(null)>] (null)
[    2.975320] 
[    2.975320] other info that might help us debug this:
[    2.975320] no locks held by swapper/0.
[    2.975320] 
[    2.975320] stack backtrace:
[    2.975320] Pid: 0, comm: swapper Not tainted 2.6.29-rc4-rt1-tip #1
[    2.975320] Call Trace:
[    2.975320]  <IRQ>  [<ffffffff8027fcbc>] print_usage_bug+0x19c/0x200
[    2.975320]  [<ffffffff8021e6af>] ? save_stack_trace+0x2f/0x50
[    2.975320]  [<ffffffff80280315>] mark_lock+0x2a5/0xcd0
[    2.975320]  [<ffffffff8028245e>] __lock_acquire+0x88e/0x1b20
[    2.975320]  [<ffffffff8028216b>] ? __lock_acquire+0x59b/0x1b20
[    2.975320]  [<ffffffff802243e4>] ? post_set+0x64/0x70
[    2.975320]  [<ffffffff8028378f>] lock_acquire+0x9f/0xe0
[    2.975320]  [<ffffffff802f6823>] ? kfree+0x43/0xc0
[    2.975320]  [<ffffffff8077c7f5>] rt_spin_lock+0x85/0xb0
[    2.975320]  [<ffffffff802f6823>] ? kfree+0x43/0xc0
[    2.975320]  [<ffffffff802f6823>] kfree+0x43/0xc0
[    2.975320]  [<ffffffff8027f2fd>] ? trace_hardirqs_off+0xd/0x10
[    2.975320]  [<ffffffff8028a156>] generic_smp_call_function_single_interrupt+0x106/0x110
[    2.975320]  [<ffffffff80227144>] smp_call_function_single_interrupt+0x24/0x40
[    2.975320]  [<ffffffff80213223>] call_function_single_interrupt+0x13/0x20
[    2.975320]  <EOI>  [<ffffffff8022df7b>] ? native_safe_halt+0xb/0x10
[    2.975320]  [<ffffffff8022df79>] ? native_safe_halt+0x9/0x10
[    2.975320]  [<ffffffff8021a93a>] ? default_idle+0x5a/0x60
[    2.975320]  [<ffffffff8021136e>] ? cpu_idle+0x7e/0x100
[    2.975320]  [<ffffffff80775b6c>] ? start_secondary+0x197/0x1eb


The second, a sysfs warning:

[    8.042459] ------------[ cut here ]------------
[    8.054763] WARNING: at fs/sysfs/dir.c:462 sysfs_add_one+0x51/0x60()
[    8.066777] Hardware name: AMILO Li 2727                  
[    8.078555] sysfs: duplicate filename '14:4' can not be created
[    8.090353] Pid: 33, comm: work_on_cpu/0 Not tainted 2.6.29-rc4-rt1-tip #1
[    8.102482] Call Trace:
[    8.102492]  [<ffffffff80255ea3>] warn_slowpath+0xd3/0x130
[    8.102500]  [<ffffffff8077cbeb>] ? _mutex_unlock+0x2b/0x40
[    8.102508]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[    8.102513]  [<ffffffff8035c835>] ? sysfs_find_dirent+0x35/0x50
[    8.102518]  [<ffffffff8035c9f4>] ? __sysfs_add_one+0x24/0xe0
[    8.102523]  [<ffffffff8035cb01>] sysfs_add_one+0x51/0x60
[    8.102528]  [<ffffffff8035dcb3>] sysfs_do_create_link+0x103/0x170
[    8.102533]  [<ffffffff8035dd53>] sysfs_create_link+0x13/0x20
[    8.102540]  [<ffffffff8051d739>] device_add+0x209/0x620
[    8.102547]  [<ffffffff80289128>] ? __rt_spin_lock_init+0x48/0x60
[    8.102552]  [<ffffffff8051db6e>] device_register+0x1e/0x30
[    8.102557]  [<ffffffff8051dc64>] device_create_vargs+0xe4/0x100
[    8.102563]  [<ffffffff8051dcd0>] device_create+0x50/0x60
[    8.102570]  [<ffffffff80612a25>] ? sound_insert_unit+0x55/0x1e0
[    8.102575]  [<ffffffff8077c843>] ? rt_spin_unlock+0x23/0x80
[    8.102579]  [<ffffffff80612a25>] ? sound_insert_unit+0x55/0x1e0
[    8.102584]  [<ffffffff80612afa>] sound_insert_unit+0x12a/0x1e0
[    8.102590]  [<ffffffff80612d35>] register_sound_special_device+0xa5/0x220
[    8.102595]  [<ffffffff8077c112>] ? rt_mutex_lock+0x22/0x60
[    8.102601]  [<ffffffff80625499>] snd_register_oss_device+0x239/0x2c0
[    8.102608]  [<ffffffff8063b2b0>] register_oss_dsp+0x60/0x90
[    8.102613]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[    8.102618]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[    8.102623]  [<ffffffff80212096>] ? ftrace_call+0x5/0x2b
[    8.102629]  [<ffffffff8063f5e7>] snd_pcm_oss_register_minor+0x167/0x260
[    8.102634]  [<ffffffff80627955>] ? snd_timer_dev_register+0x35/0x130
[    8.102640]  [<ffffffff80627a0b>] ? snd_timer_dev_register+0xeb/0x130
[    8.102645]  [<ffffffff80624855>] ? snd_device_register+0x65/0x80
[    8.102650]  [<ffffffff806365af>] ? snd_pcm_timer_init+0x14f/0x1a0
[    8.102656]  [<ffffffff8062b79d>] snd_pcm_dev_register+0x1ad/0x2c0
[    8.102661]  [<ffffffff80212000>] ? sys_rt_sigreturn+0x250/0x290
[    8.102667]  [<ffffffff806247c9>] snd_device_register_all+0x39/0x60
[    8.102672]  [<ffffffff8061f25a>] snd_card_register+0x3a/0x3d0
[    8.102678]  [<ffffffff8076e5a6>] azx_probe+0x7b6/0xa90
[    8.102685]  [<ffffffff80677960>] ? azx_send_cmd+0x0/0x120
[    8.102690]  [<ffffffff80677a80>] ? azx_get_response+0x0/0x240
[    8.102695]  [<ffffffff80676eb0>] ? azx_attach_pcm_stream+0x0/0x1c0
[    8.102701]  [<ffffffff8026a5c0>] ? do_work_for_cpu+0x0/0x30
[    8.102708]  [<ffffffff80455847>] local_pci_probe+0x17/0x20
[    8.102713]  [<ffffffff8026a5d8>] do_work_for_cpu+0x18/0x30
[    8.102718]  [<ffffffff8026a88d>] run_workqueue+0x16d/0x2c0
[    8.102722]  [<ffffffff8026a83a>] ? run_workqueue+0x11a/0x2c0
[    8.102727]  [<ffffffff8026aa8f>] worker_thread+0xaf/0x130
[    8.102733]  [<ffffffff8026f5f0>] ? autoremove_wake_function+0x0/0x40
[    8.102738]  [<ffffffff8026a9e0>] ? worker_thread+0x0/0x130
[    8.102742]  [<ffffffff8026a9e0>] ? worker_thread+0x0/0x130
[    8.102747]  [<ffffffff8026f0ee>] kthread+0x4e/0x90
[    8.102752]  [<ffffffff802135ba>] child_rip+0xa/0x20
[    8.102757]  [<ffffffff80212f54>] ? restore_args+0x0/0x30
[    8.102762]  [<ffffffff8026f0a0>] ? kthread+0x0/0x90
[    8.102766]  [<ffffffff802135b0>] ? child_rip+0x0/0x20
[    8.102777] ---[ end trace 57b9b5741e12ebf7 ]---

