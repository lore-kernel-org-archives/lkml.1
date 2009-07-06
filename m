Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZGFEHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZGFEHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 00:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbZGFEG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 00:06:59 -0400
Received: from qmta03.westchester.pa.mail.comcast.net ([76.96.62.32]:35785
	"EHLO QMTA03.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750695AbZGFEG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 00:06:58 -0400
To: Dave Jones <davej@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: lockdep warns about deadlock in cpufreq 
X-Message-Flag: Warning: May contain useful information
X-Priority: 1
X-MSMail-Priority: High
From: Roland Dreier <roland@digitalvampire.org>
Date: Sun, 05 Jul 2009 21:06:44 -0700
Message-ID: <87eisuo3or.fsf@shaolin.home.digitalvampire.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I got the lockdep warning below about the cpufreq ondemand module.
It looks as if there is a real deadlock window; if I'm interpreting
the lockdep output correctly, the issue is the following conflicting
chains of locking dependencies:

    dbs_info->work -> do_dbs_timer() -> lock_policy_rwsem_write()

vs.

    store() -> lock_policy_rwsem_write() -> store_scaling_governor() ->
      cpufreq_governor_dbs() -> cancel_delayed_work_sync() -> dbs_info->work

It seems this issue was introduced in b14893a6 ("[CPUFREQ] fix timer
teardown in ondemand governor") and only partially addressed in
42a06f21 ("[CPUFREQ] remove rwsem lock from CPUFREQ_GOV_STOP call").
That patch moved the unlock_policy_rwsem_write() up so it didn't cover
the call to CPUFREQ_GOV_STOP in __cpufreq_remove_dev(); but the policy
rwsem is still held across the call to CPUFREQ_GOV_STOP in
__cpufreq_set_policy() when called from store()/store_scaling_governor().

It's not immediately clear to me what the best way to fix this is;
I'll look at it some more tomorrow but if someone else wants to beat
me to it, that's great.

Full lockdep output below; the kernel I'm running is basically
Ubuntu's tree with mainline pulled in, but the issue appears to be
there in pure mainline code.

Thanks,
  Roland


=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.31-2-generic #14~rbd4gitd960eea9
-------------------------------------------------------
94cpufreq/26300 is trying to acquire lock:
 (&(&dbs_info->work)->work){+.+...}, at: [<ffffffff81073480>] wait_on_work+0x0/0x150

but task is already holding lock:
 (dbs_mutex){+.+.+.}, at: [<ffffffff81425011>] cpufreq_governor_dbs+0xe1/0x390

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (dbs_mutex){+.+.+.}:
       [<ffffffff8108c8a7>] check_prev_add+0x2a7/0x370
       [<ffffffff8108cfd1>] validate_chain+0x661/0x750
       [<ffffffff8108d2f7>] __lock_acquire+0x237/0x430
       [<ffffffff8108d595>] lock_acquire+0xa5/0x150
       [<ffffffff8155344d>] __mutex_lock_common+0x4d/0x3d0
       [<ffffffff815538d6>] mutex_lock_nested+0x46/0x60
       [<ffffffff8142509c>] cpufreq_governor_dbs+0x16c/0x390
       [<ffffffff81421bb6>] __cpufreq_governor+0x66/0xf0
       [<ffffffff81422603>] __cpufreq_set_policy+0x133/0x170
       [<ffffffff81422cc6>] store_scaling_governor+0xc6/0xf0
       [<ffffffff81423057>] store+0x67/0xa0
       [<ffffffff811990a9>] sysfs_write_file+0xd9/0x160
       [<ffffffff8112fe08>] vfs_write+0xb8/0x1a0
       [<ffffffff811308d1>] sys_write+0x51/0x90
       [<ffffffff81013132>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
       [<ffffffff8108c8a7>] check_prev_add+0x2a7/0x370
       [<ffffffff8108cfd1>] validate_chain+0x661/0x750
       [<ffffffff8108d2f7>] __lock_acquire+0x237/0x430
       [<ffffffff8108d595>] lock_acquire+0xa5/0x150
       [<ffffffff81553c27>] down_write+0x47/0x60
       [<ffffffff81422fb2>] lock_policy_rwsem_write+0x52/0x90
       [<ffffffff814256fa>] do_dbs_timer+0x6a/0x110
       [<ffffffff81071cc8>] run_workqueue+0xf8/0x240
       [<ffffffff81071ec4>] worker_thread+0xb4/0x130
       [<ffffffff810773ce>] kthread+0x9e/0xb0
       [<ffffffff8101430a>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&(&dbs_info->work)->work){+.+...}:
       [<ffffffff8108c685>] check_prev_add+0x85/0x370
       [<ffffffff8108cfd1>] validate_chain+0x661/0x750
       [<ffffffff8108d2f7>] __lock_acquire+0x237/0x430
       [<ffffffff8108d595>] lock_acquire+0xa5/0x150
       [<ffffffff810734d5>] wait_on_work+0x55/0x150
       [<ffffffff81073619>] __cancel_work_timer+0x49/0x110
       [<ffffffff810736f2>] cancel_delayed_work_sync+0x12/0x20
       [<ffffffff81425021>] cpufreq_governor_dbs+0xf1/0x390
       [<ffffffff81421bb6>] __cpufreq_governor+0x66/0xf0
       [<ffffffff814225ed>] __cpufreq_set_policy+0x11d/0x170
       [<ffffffff81422cc6>] store_scaling_governor+0xc6/0xf0
       [<ffffffff81423057>] store+0x67/0xa0
       [<ffffffff811990a9>] sysfs_write_file+0xd9/0x160
       [<ffffffff8112fe08>] vfs_write+0xb8/0x1a0
       [<ffffffff811308d1>] sys_write+0x51/0x90
       [<ffffffff81013132>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

3 locks held by 94cpufreq/26300:
 #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff81199014>] sysfs_write_file+0x44/0x160
 #1:  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at: [<ffffffff81422fb2>] lock_policy_rwsem_write+0x52/0x90
 #2:  (dbs_mutex){+.+.+.}, at: [<ffffffff81425011>] cpufreq_governor_dbs+0xe1/0x390

stack backtrace:
Pid: 26300, comm: 94cpufreq Tainted: G         C 2.6.31-2-generic #14~rbd4gitd960eea9
Call Trace:
 [<ffffffff8108b998>] print_circular_bug_tail+0xa8/0xf0
 [<ffffffff8108c685>] check_prev_add+0x85/0x370
 [<ffffffff8108cfd1>] validate_chain+0x661/0x750
 [<ffffffff8108d2f7>] __lock_acquire+0x237/0x430
 [<ffffffff8108d595>] lock_acquire+0xa5/0x150
 [<ffffffff81073480>] ? wait_on_work+0x0/0x150
 [<ffffffff810734d5>] wait_on_work+0x55/0x150
 [<ffffffff81073480>] ? wait_on_work+0x0/0x150
 [<ffffffff8108c03c>] ? mark_held_locks+0x6c/0xa0
 [<ffffffff81554e30>] ? _spin_unlock_irqrestore+0x40/0x70
 [<ffffffff8108c35d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff8108c3ad>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81073619>] __cancel_work_timer+0x49/0x110
 [<ffffffff810736f2>] cancel_delayed_work_sync+0x12/0x20
 [<ffffffff81425021>] cpufreq_governor_dbs+0xf1/0x390
 [<ffffffff8107c11b>] ? up_read+0x2b/0x40
 [<ffffffff81421bb6>] __cpufreq_governor+0x66/0xf0
 [<ffffffff814225ed>] __cpufreq_set_policy+0x11d/0x170
 [<ffffffff81422cc6>] store_scaling_governor+0xc6/0xf0
 [<ffffffff81423190>] ? handle_update+0x0/0x20
 [<ffffffff81553c2f>] ? down_write+0x4f/0x60
 [<ffffffff81423057>] store+0x67/0xa0
 [<ffffffff811990a9>] sysfs_write_file+0xd9/0x160
 [<ffffffff8112fe08>] vfs_write+0xb8/0x1a0
 [<ffffffff811308d1>] sys_write+0x51/0x90
 [<ffffffff81013132>] system_call_fastpath+0x16/0x1b
