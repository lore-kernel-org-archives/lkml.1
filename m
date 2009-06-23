Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbZFWSmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbZFWSmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZFWSlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:41:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44790 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbZFWSlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:41:51 -0400
Date: Tue, 23 Jun 2009 20:40:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Renninger <trenn@suse.de>
Cc: Dave Jones <davej@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org, mark.langsdorf@amd.com,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] cpufreq: remove dbs_mutex
Message-ID: <20090623184040.GA6908@elte.hu>
References: <4A2835D8.6040903@kernel.org> <20090611105211.GA6760@elte.hu> <20090620124817.GA22831@elte.hu> <200906212155.49849.trenn@suse.de> <20090623181748.GA31148@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623181748.GA31148@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Thomas Renninger <trenn@suse.de> wrote:
> 
> > > Note, this bug warning still triggers rather frequently with 
> > > latest -git (fb20871) during bootup on two test-systems - 
> > > relevant portion of the bootlog attached below. As usual i can 
> > > test any fix for this.
> >
> > Best rip out the dbs_mutex in drivers/cpufreq/cpufreq_ondemand.c 
> > totally. I can provide several locking cleanups for cpufreq for 
> > .31 the next days, including dbs_mutex removal, which I think is 
> > not needed. The dbs_mutex removal which should fix this could then 
> > be marked: CC: stable@kernel.org
> 
> drivers/cpufreq/cpufreq_conservative.c too i guess?
> 
> Something like the patch below?
> 
> Utterly untested and such.

i tested it and this blatant blind ripping out of a layer of locking 
uncovered the next layer:

[  144.961483] =======================================================
[  144.961685] [ INFO: possible circular locking dependency detected ]
[  144.961785] 2.6.30-tip-08973-gb747c8d-dirty #6295
[  144.961878] -------------------------------------------------------
[  144.961974] S99local/8461 is trying to acquire lock:
[  144.962016]  (&(&dbs_info->work)->work){+.+...}, at: [<c109962a>] wait_on_work+0x0/0xba
[  144.962016] 
[  144.962016] but task is already holding lock:
[  144.962016]  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<c1f5dd3f>] lock_policy_rwsem_write+0x73/0xec
[  144.962016] 
[  144.962016] which lock already depends on the new lock.

(see below for the full details)

I guess someone who knows the cpufreq code will have to fix the 
locking in this code for real.

	Ingo

[  144.767335] CPUFREQ: ondemand sampling_rate_max sysfs file is deprecated - used by: cat
[  144.961480] 
[  144.961483] =======================================================
[  144.961685] [ INFO: possible circular locking dependency detected ]
[  144.961785] 2.6.30-tip-08973-gb747c8d-dirty #6295
[  144.961878] -------------------------------------------------------
[  144.961974] S99local/8461 is trying to acquire lock:
[  144.962016]  (&(&dbs_info->work)->work){+.+...}, at: [<c109962a>] wait_on_work+0x0/0xba
[  144.962016] 
[  144.962016] but task is already holding lock:
[  144.962016]  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<c1f5dd3f>] lock_policy_rwsem_write+0x73/0xec
[  144.962016] 
[  144.962016] which lock already depends on the new lock.
[  144.962016] 
[  144.962016] 
[  144.962016] the existing dependency chain (in reverse order) is:
[  144.962016] 
[  144.962016] -> #1 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
[  144.962016]        [<c10bcd0d>] check_prev_add+0xf0/0x151
[  144.962016]        [<c10bcdd3>] check_prevs_add+0x65/0xbf
[  144.962016]        [<c10bce9e>] validate_chain+0x71/0x99
[  144.962016]        [<c10bd184>] __lock_acquire+0x2be/0x33d
[  144.962016]        [<c10bd27f>] lock_acquire+0x7c/0x9f
[  144.962016]        [<c23b1b36>] down_write+0x32/0x95
[  144.962016]        [<c1f5dd3f>] lock_policy_rwsem_write+0x73/0xec
[  144.962016]        [<c1f627cd>] do_dbs_timer+0x50/0x160
[  144.962016]        [<c1098de1>] run_workqueue+0xec/0x243
[  144.962016]        [<c109badf>] worker_thread+0x13b/0x14c
[  144.962016]        [<c10a05ed>] kthread+0x89/0x92
[  144.962016]        [<c10064a7>] kernel_thread_helper+0x7/0x10
[  144.962016]        [<ffffffff>] 0xffffffff
[  144.962016] 
[  144.962016] -> #0 (&(&dbs_info->work)->work){+.+...}:
[  144.962016]        [<c10bcc50>] check_prev_add+0x33/0x151
[  144.962016]        [<c10bcdd3>] check_prevs_add+0x65/0xbf
[  144.962016]        [<c10bce9e>] validate_chain+0x71/0x99
[  144.962016]        [<c10bd184>] __lock_acquire+0x2be/0x33d
[  144.962016]        [<c10bd27f>] lock_acquire+0x7c/0x9f
[  144.962016]        [<c1099662>] wait_on_work+0x38/0xba
[  144.962016]        [<c109975c>] __cancel_work_timer+0x78/0x99
[  144.962016]        [<c109978d>] cancel_delayed_work_sync+0x10/0x12
[  144.962016]        [<c1f62710>] dbs_timer_exit+0x17/0x19
[  144.962016]        [<c1f62d68>] cpufreq_governor_dbs+0x23f/0x2df
[  144.962016]        [<c1f5e7cb>] __cpufreq_governor+0x9a/0xde
[  144.962016]        [<c1f5ea3c>] __cpufreq_set_policy+0x22d/0x2fa
[  144.967630]        [<c1f5ebce>] store_scaling_governor+0xc5/0x108
[  144.967630]        [<c1f5e11d>] store+0xa4/0xbd
[  144.967630]        [<c11fa00f>] flush_write_buffer+0x6d/0x81
[  144.967630]        [<c11fb23f>] sysfs_write_file+0x66/0xa6
[  144.967630]        [<c11814e0>] vfs_write+0x1ad/0x1f9
[  144.967630]        [<c1181fc6>] sys_write+0x5e/0x80
[  144.967630]        [<c100582b>] sysenter_do_call+0x12/0x38
[  144.967630]        [<ffffffff>] 0xffffffff
[  144.967630] 
[  144.967630] other info that might help us debug this:
[  144.967630] 
[  144.967630] 2 locks held by S99local/8461:
[  144.967630]  #0:  (&buffer->mutex){+.+.+.}, at: [<c11fb201>] sysfs_write_file+0x28/0xa6
[  144.967630]  #1:  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<c1f5dd3f>] lock_policy_rwsem_write+0x73/0xec
[  144.967630] 
[  144.967630] stack backtrace:
[  144.967630] Pid: 8461, comm: S99local Tainted: G        W  2.6.30-tip-08973-gb747c8d-dirty #6295
[  144.967630] Call Trace:
[  144.967630]  [<c10bb9d8>] print_circular_bug_tail+0x5d/0x68
[  144.967630]  [<c10bcc50>] check_prev_add+0x33/0x151
[  144.967630]  [<c10b8974>] ? list_add_tail_rcu+0xd/0xf
[  144.967630]  [<c10bcdd3>] check_prevs_add+0x65/0xbf
[  144.967630]  [<c10bce9e>] validate_chain+0x71/0x99
[  144.967630]  [<c10bd184>] __lock_acquire+0x2be/0x33d
[  144.967630]  [<c10bd27f>] lock_acquire+0x7c/0x9f
[  144.967630]  [<c109962a>] ? wait_on_work+0x0/0xba
[  144.967630]  [<c1099662>] wait_on_work+0x38/0xba
[  144.967630]  [<c109962a>] ? wait_on_work+0x0/0xba
[  144.967630]  [<c110c292>] ? ftrace_likely_update+0x11/0x22
[  144.967630]  [<c109975c>] __cancel_work_timer+0x78/0x99
[  144.967630]  [<c109978d>] cancel_delayed_work_sync+0x10/0x12
[  144.967630]  [<c1f62710>] dbs_timer_exit+0x17/0x19
[  144.967630]  [<c1f62d68>] cpufreq_governor_dbs+0x23f/0x2df
[  144.967630]  [<c1f5e7cb>] __cpufreq_governor+0x9a/0xde
[  144.967630]  [<c1f5ea3c>] __cpufreq_set_policy+0x22d/0x2fa
[  144.967630]  [<c1f5ebce>] store_scaling_governor+0xc5/0x108
[  144.967630]  [<c1f60123>] ? handle_update+0x0/0x2d
[  144.967630]  [<c1f5dd6f>] ? lock_policy_rwsem_write+0xa3/0xec
[  144.967630]  [<c1f5e11d>] store+0xa4/0xbd
[  144.967630]  [<c11fa00f>] flush_write_buffer+0x6d/0x81
[  144.967630]  [<c11fb23f>] sysfs_write_file+0x66/0xa6
[  144.967630]  [<c11814e0>] vfs_write+0x1ad/0x1f9
[  144.967630]  [<c1181fc6>] sys_write+0x5e/0x80
[  144.967630]  [<c100582b>] sysenter_do_call+0x12/0x38
[  146.085749] PM: Adding info for No Bus:vcs4
[  146.085864] PM: Adding info for No Bus:vcsa4
[  146.090924] PM: Adding info for No Bus:vcs9
[  146.091077] PM: Adding info for No Bus:vcsa9
[  146.092977] PM: Adding info for No Bus:vcs3
