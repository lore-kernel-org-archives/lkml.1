Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZEJPWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZEJPWg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 11:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZEJPW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 11:22:27 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:51980 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbZEJPW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 11:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=ZNgsyFZZXl3ki/63/Y1r3+BJTK47E83/JU64Wv3rTS904JSEWgN6Cf30RpNrg5ogjq
         9VNI4hYlVspqLFqVPKTIbyLldxPWaN65LuJYpF88aLeklzF5Hk0FQxo+VnSr+LPnyzvv
         vnlL6ochKkjqAn6BA//r1PAWC1dNmKJ5mnfzU=
MIME-Version: 1.0
Date: Mon, 11 May 2009 00:22:26 +0900
X-Google-Sender-Auth: b6035aa5d3439ef8
Message-ID: <2f11576a0905100822y5507a9f7m6f9aa0fcc05ac18@mail.gmail.com>
Subject: lockdep warnings: cpufreq ondemand gorvernor possibly circular 
	locking
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ben Slusky <sluskyb@paranoiacs.org>,
       Dave Jones <davej@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

my box output following warnings.
it seems regression by commit 7ccc7608b836e58fbacf65ee4f8eefa288e86fac.

A: work -> do_dbs_timer()  -> cpu_policy_rwsem
B: store() -> cpu_policy_rwsem -> cpufreq_governor_dbs() -> work



=======================================================
nd cpu frequency[ INFO: possible circular locking dependency detected ]
 scaling: 2.6.30-rc4-mm1 #26
-------------------------------------------------------
K99cpuspeed/227488 is trying to acquire lock:
 (&(&dbs_info->work)->work){+.+...}, at: [<ffffffff81055bfd>]
__cancel_work_timer+0xde/0x227

but task is already holding lock:
 (dbs_mutex){+.+.+.}, at: [<ffffffffa0081af3>]
cpufreq_governor_dbs+0x241/0x2d2 [cpufreq_ondemand]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (dbs_mutex){+.+.+.}:
       [<ffffffff8106a15a>] __lock_acquire+0xa9d/0xc33
       [<ffffffff8106a3b1>] lock_acquire+0xc1/0xe5
       [<ffffffff81303aa5>] __mutex_lock_common+0x4d/0x34c
       [<ffffffff81303e5c>] mutex_lock_nested+0x3a/0x3f
       [<ffffffffa008193d>] cpufreq_governor_dbs+0x8b/0x2d2 [cpufreq_ondemand]	
       [<ffffffff812678bd>] __cpufreq_governor+0xa7/0xe4
       [<ffffffff81267acf>] __cpufreq_set_policy+0x19a/0x216
       [<ffffffff81268572>] store_scaling_governor+0x1ec/0x228
       [<ffffffff812691fb>] store+0x67/0x8c					
       [<ffffffff81129091>] sysfs_write_file+0xe9/0x11e				
       [<ffffffff810e64d8>] vfs_write+0xb0/0x10a
       [<ffffffff810e6600>] sys_write+0x4c/0x74
       [<ffffffff8100bc1b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}:
       [<ffffffff8106a15a>] __lock_acquire+0xa9d/0xc33
       [<ffffffff8106a3b1>] lock_acquire+0xc1/0xe5
       [<ffffffff813040d8>] down_write+0x4d/0x81
       [<ffffffff81268ad3>] lock_policy_rwsem_write+0x4d/0x7d			
       [<ffffffffa0081692>] do_dbs_timer+0x64/0x284 [cpufreq_ondemand]
       [<ffffffff81055395>] worker_thread+0x205/0x318				
       [<ffffffff8105933f>] kthread+0x8d/0x95
       [<ffffffff8100ccfa>] child_rip+0xa/0x20
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&(&dbs_info->work)->work){+.+...}:
       [<ffffffff8106a04e>] __lock_acquire+0x991/0xc33
       [<ffffffff8106a3b1>] lock_acquire+0xc1/0xe5
       [<ffffffff81055c36>] __cancel_work_timer+0x117/0x227
       [<ffffffff81055d58>] cancel_delayed_work_sync+0x12/0x14				
       [<ffffffffa0081b06>] cpufreq_governor_dbs+0x254/0x2d2
[cpufreq_ondemand]
       [<ffffffff812678bd>] __cpufreq_governor+0xa7/0xe4
       [<ffffffff81267ab9>] __cpufreq_set_policy+0x184/0x216
       [<ffffffff81268572>] store_scaling_governor+0x1ec/0x228
       [<ffffffff812691fb>] store+0x67/0x8c						
       [<ffffffff81129091>] sysfs_write_file+0xe9/0x11e				
       [<ffffffff810e64d8>] vfs_write+0xb0/0x10a
       [<ffffffff810e6600>] sys_write+0x4c/0x74
       [<ffffffff8100bc1b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

3 locks held by K99cpuspeed/227488:
 #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff81128fe5>]
sysfs_write_file+0x3d/0x11e
 #1:  (&per_cpu(cpu_policy_rwsem, cpu)){+++++.}, at:
[<ffffffff81268ad3>] lock_policy_rwsem_write+0x4d/0x7d
 #2:  (dbs_mutex){+.+.+.}, at: [<ffffffffa0081af3>]
cpufreq_governor_dbs+0x241/0x2d2 [cpufreq_ondemand]

stack backtrace:
Pid: 227488, comm: K99cpuspeed Not tainted 2.6.30-rc4-mm1 #26
Call Trace:
 [<ffffffff81069347>] print_circular_bug_tail+0x71/0x7c
 [<ffffffff8106a04e>] __lock_acquire+0x991/0xc33
 [<ffffffff8104e2f6>] ? lock_timer_base+0x2b/0x4f
 [<ffffffff8106a3b1>] lock_acquire+0xc1/0xe5
 [<ffffffff81055bfd>] ? __cancel_work_timer+0xde/0x227
 [<ffffffff81055c36>] __cancel_work_timer+0x117/0x227		
 [<ffffffff81055bfd>] ? __cancel_work_timer+0xde/0x227
 [<ffffffff81068a22>] ? mark_held_locks+0x4d/0x6b
 [<ffffffff81303d5a>] ? __mutex_lock_common+0x302/0x34c
 [<ffffffffa0081af3>] ? cpufreq_governor_dbs+0x241/0x2d2 [cpufreq_ondemand]	
 [<ffffffff81068a22>] ? mark_held_locks+0x4d/0x6b
 [<ffffffffa0081af3>] ? cpufreq_governor_dbs+0x241/0x2d2 [cpufreq_ondemand]
 [<ffffffff8100b956>] ? ftrace_call+0x5/0x2b
 [<ffffffff81055d58>] cancel_delayed_work_sync+0x12/0x14
 [<ffffffffa0081b06>] cpufreq_governor_dbs+0x254/0x2d2 [cpufreq_ondemand]
 [<ffffffff8105ce4d>] ? up_read+0x2b/0x2f
 [<ffffffff812678bd>] __cpufreq_governor+0xa7/0xe4
 [<ffffffff81267ab9>] __cpufreq_set_policy+0x184/0x216
 [<ffffffff81268572>] store_scaling_governor+0x1ec/0x228
 [<ffffffff81269354>] ? handle_update+0x0/0x39
 [<ffffffff812691fb>] store+0x67/0x8c
 [<ffffffff81129091>] sysfs_write_file+0xe9/0x11e
 [<ffffffff810e64d8>] vfs_write+0xb0/0x10a
 [<ffffffff810e6600>] sys_write+0x4c/0x74
 [<ffffffff8100bc1b>] system_call_fastpath+0x16/0x1b
[  OK  ]
Sending all processes th
