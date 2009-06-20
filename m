Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbZFTMtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbZFTMtL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 08:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZFTMs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 08:48:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55693 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbZFTMs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 08:48:56 -0400
Date: Sat, 20 Jun 2009 14:48:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org, mark.langsdorf@amd.com
Subject: Re: S06cpuspeed/2637 is trying to acquire lock
	(&(&dbs_info->work)->work (was: Re: [PATCH 4/6] x86/cpufreq: use
	cpumask_copy instead of =)
Message-ID: <20090620124817.GA22831@elte.hu>
References: <4A2835D8.6040903@kernel.org> <200906091627.45411.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906090842120.6847@localhost.localdomain> <200906101552.17397.rusty@rustcorp.com.au> <20090610111035.GG27724@elte.hu> <20090610205848.GA1445@redhat.com> <20090611105211.GA6760@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611105211.GA6760@elte.hu>
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

> 
> * Dave Jones <davej@redhat.com> wrote:
> 
> > On Wed, Jun 10, 2009 at 01:10:35PM +0200, Ingo Molnar wrote:
> >  > 
> >  > With a v2.6.30 based kernel i'm still getting a cpufreq lockdep 
> >  > warning:
> >  > 
> >  >  =======================================================
> >  >  [ INFO: possible circular locking dependency detected ]
> >  >  2.6.30-tip #10420
> >  >  -------------------------------------------------------
> >  >  S06cpuspeed/2637 is trying to acquire lock:
> >  >   (&(&dbs_info->work)->work){+.+...}, at: [<ffffffff8106553d>] __cancel_work_timer+0xd6/0x22a
> >  > 
> >  >  but task is already holding lock:
> >  >   (dbs_mutex){+.+.+.}, at: [<ffffffff8193d630>] cpufreq_governor_dbs+0x28f/0x335
> >  > 
> >  > This bug got introduced somewhere late in the .30-rc cycle, this box 
> >  > was fine before.
> > 
> > See the thread " [PATCH] remove rwsem lock from CPUFREQ_GOV_STOP 
> > call (second call site)" Though there's a report that the last 
> > patch posted still doesn't fix the problem, so we still don't have 
> > a quick fix suitable for -stable.
> 
> even with latest -git (which includes cpufreq fixes) i get:
> 
> [   54.819413] CPUFREQ: ondemand sampling_rate_max sysfs file is deprecated - used by: cat
> [   55.216665] 
> [   55.216668] =======================================================
> [   55.216963] [ INFO: possible circular locking dependency detected ]
> [   55.217134] 2.6.30-tip #5836
> [   55.217276] -------------------------------------------------------
> [   55.217428] S99local/4262 is trying to acquire lock:
> [   55.217577]  (&(&dbs_info->work)->work){+.+...}, at: [<4104261f>] __cancel_work_timer+0xb8/0x1e9
> [   55.218065] 
> [   55.218068] but task is already holding lock:
> [   55.218351]  (dbs_mutex){+.+.+.}, at: [<4157bd6b>] cpufreq_governor_dbs+0x25d/0x2e4
> [   55.218358] 
> 
> full bootlog below. Can test fixes.

Note, this bug warning still triggers rather frequently with latest 
-git (fb20871) during bootup on two test-systems - relevant portion 
of the bootlog attached below. As usual i can test any fix for this.

        Ingo

[  266.276061] 
[  266.276064] =======================================================
[  266.276243] [ INFO: possible circular locking dependency detected ]
[  266.276337] 2.6.30-tip #6165
[  266.276423] -------------------------------------------------------
[  266.276516] S99local/4038 is trying to acquire lock:
[  266.276608]  (&(&dbs_info->work)->work){+.+...}, at: [<c104b718>] __cancel_work_timer+0xa9/0x186
[  266.276883] 
[  266.276884] but task is already holding lock:
[  266.277055]  (dbs_mutex){+.+.+.}, at: [<c14f6241>] cpufreq_governor_dbs+0x24d/0x2d7
[  266.277322] 
[  266.277323] which lock already depends on the new lock.
[  266.277325] 
[  266.277577] 
[  266.277578] the existing dependency chain (in reverse order) is:
[  266.277752] 
[  266.277753] -> #2 (dbs_mutex){+.+.+.}:
[  266.278055]        [<c105fe5a>] validate_chain+0x810/0xa81
[  266.278193]        [<c106077f>] __lock_acquire+0x6b4/0x71f
[  266.278331]        [<c1061a58>] lock_acquire+0xb1/0xd5
[  266.278466]        [<c15ddbd2>] mutex_lock_nested+0x3e/0x363
[  266.278605]        [<c14f604d>] cpufreq_governor_dbs+0x59/0x2d7
[  266.278742]        [<c14f3d1b>] __cpufreq_governor+0x6a/0x74
[  266.278881]        [<c14f3e7f>] __cpufreq_set_policy+0x15a/0x1c8
[  266.279020]        [<c14f515f>] cpufreq_add_dev+0x36b/0x448
[  266.279158]        [<c12d6308>] sysdev_driver_register+0x9b/0xea
[  266.279299]        [<c14f3c25>] cpufreq_register_driver+0xa2/0x12e
[  266.279438]        [<c1b07f8e>] acpi_cpufreq_init+0x108/0x11d
[  266.279575]        [<c1001151>] _stext+0x69/0x176
[  266.279711]        [<c1b00741>] kernel_init+0x86/0xd7
[  266.279848]        [<c1004387>] kernel_thread_helper+0x7/0x10
[  266.279986]        [<ffffffff>] 0xffffffff
[  266.280023] 
[  266.280023] -> #1 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
[  266.280023]        [<c105fe5a>] validate_chain+0x810/0xa81
[  266.280023]        [<c106077f>] __lock_acquire+0x6b4/0x71f
[  266.280023]        [<c1061a58>] lock_acquire+0xb1/0xd5
[  266.280023]        [<c15dea5f>] down_write+0x24/0x63
[  266.280023]        [<c14f4933>] lock_policy_rwsem_write+0x38/0x64
[  266.280023]        [<c14f5d93>] do_dbs_timer+0x3b/0x29c
[  266.280023]        [<c104c124>] worker_thread+0x1ce/0x2c9
[  266.280023]        [<c104f4d8>] kthread+0x6b/0x73
[  266.280023]        [<c1004387>] kernel_thread_helper+0x7/0x10
[  266.280023]        [<ffffffff>] 0xffffffff
[  266.280023] 
[  266.280023] -> #0 (&(&dbs_info->work)->work){+.+...}:
[  266.280023]        [<c105fbea>] validate_chain+0x5a0/0xa81
[  266.280023]        [<c106077f>] __lock_acquire+0x6b4/0x71f
[  266.280023]        [<c1061a58>] lock_acquire+0xb1/0xd5
[  266.280023]        [<c104b72f>] __cancel_work_timer+0xc0/0x186
[  266.280023]        [<c104b805>] cancel_delayed_work_sync+0x10/0x12
[  266.280023]        [<c14f6252>] cpufreq_governor_dbs+0x25e/0x2d7
[  266.280023]        [<c14f3d1b>] __cpufreq_governor+0x6a/0x74
[  266.280023]        [<c14f3e69>] __cpufreq_set_policy+0x144/0x1c8
[  266.280023]        [<c14f446f>] store_scaling_governor+0x15e/0x18d
[  266.280023]        [<c14f4cbc>] store+0x47/0x60
[  266.280023]        [<c11114f1>] sysfs_write_file+0xba/0xe5
[  266.280023]        [<c10c9898>] vfs_write+0xc5/0x162
[  266.280023]        [<c10c9e65>] sys_write+0x41/0x7c
[  266.280023]        [<c10039a7>] sysenter_do_call+0x12/0x3c
[  266.280023]        [<ffffffff>] 0xffffffff
[  266.280023] 
[  266.280023] other info that might help us debug this:
[  266.280023] 
[  266.280023] 3 locks held by S99local/4038:
[  266.280023]  #0:  (&buffer->mutex){+.+.+.}, at: [<c1111460>] sysfs_write_file+0x29/0xe5
[  266.280023]  #1:  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<c14f4933>] lock_policy_rwsem_write+0x38/0x64
[  266.280023]  #2:  (dbs_mutex){+.+.+.}, at: [<c14f6241>] cpufreq_governor_dbs+0x24d/0x2d7
[  266.280023] 
[  266.280023] stack backtrace:
[  266.280023] Pid: 4038, comm: S99local Tainted: G        W  2.6.30-tip #6165
[  266.280023] Call Trace:
[  266.280023]  [<c105f562>] print_circular_bug_tail+0xa3/0xae
[  266.280023]  [<c105fbea>] validate_chain+0x5a0/0xa81
[  266.280023]  [<c106077f>] __lock_acquire+0x6b4/0x71f
[  266.280023]  [<c105dcd0>] ? mark_held_locks+0x42/0x5a
[  266.280023]  [<c1061a58>] lock_acquire+0xb1/0xd5
[  266.280023]  [<c104b718>] ? __cancel_work_timer+0xa9/0x186
[  266.280023]  [<c104b72f>] __cancel_work_timer+0xc0/0x186
[  266.280023]  [<c104b718>] ? __cancel_work_timer+0xa9/0x186
[  266.280023]  [<c15ddee6>] ? mutex_lock_nested+0x352/0x363
[  266.280023]  [<c14f6241>] ? cpufreq_governor_dbs+0x24d/0x2d7
[  266.280023]  [<c104b805>] cancel_delayed_work_sync+0x10/0x12
[  266.280023]  [<c14f6252>] cpufreq_governor_dbs+0x25e/0x2d7
[  266.280023]  [<c14f3d1b>] __cpufreq_governor+0x6a/0x74
[  266.280023]  [<c14f3e69>] __cpufreq_set_policy+0x144/0x1c8
[  266.280023]  [<c14f4311>] ? store_scaling_governor+0x0/0x18d
[  266.280023]  [<c14f446f>] store_scaling_governor+0x15e/0x18d
[  266.280023]  [<c14f4a9b>] ? handle_update+0x0/0x2d
[  266.280023]  [<c14f4311>] ? store_scaling_governor+0x0/0x18d
[  266.280023]  [<c14f4cbc>] store+0x47/0x60
[  266.280023]  [<c11114f1>] sysfs_write_file+0xba/0xe5
[  266.280023]  [<c1111437>] ? sysfs_write_file+0x0/0xe5
[  266.280023]  [<c10c9898>] vfs_write+0xc5/0x162
[  266.280023]  [<c10c9e65>] sys_write+0x41/0x7c
[  266.280023]  [<c10039a7>] sysenter_do_call+0x12/0x3c
[  272.000046] End ring buffer hammer

