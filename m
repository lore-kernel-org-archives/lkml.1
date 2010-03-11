Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682Ab0CKFqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 00:46:20 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:32882 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0CKFqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 00:46:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpuset: current_cpuset_is_being_rebound() need rcu lock
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100311142035.94FD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 11 Mar 2010 14:46:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rcu lockdep detected cpuset have wrong rcu usage.
the fixing is trivial. but I wonder why don't cpuset_being_rebound assignment
and read need a memory barrier pairing?


=============== CUT HERE ==========================================
Subject: [PATCH] cpuset: current_cpuset_is_being_rebound() need rcu lock.

Currently, rcu-lockdep display following warning.
because current_cpuset_is_being_rebound() call task_cs(), but it isn't
protected by rcu lock.

This patch fixes it.

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
include/linux/cgroup.h:534 invoked rcu_dereference_check() without
protection!

other info that might help us debug this:

no locks held by swapper/0.

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.34-rc1-mm1+ #94
Call Trace:
 [<ffffffff81086961>] lockdep_rcu_dereference+0xa1/0xb0
 [<ffffffff810a8cba>] current_cpuset_is_being_rebound+0x7a/0x80
 [<ffffffff8112ae0a>] __mpol_dup+0x3a/0xa0
 [<ffffffff8143b9e9>] ? sub_preempt_count+0x9/0xa0
 [<ffffffff81438105>] ? _raw_spin_unlock+0x35/0x60
 [<ffffffff810a29dd>] ? cgroup_fork+0x4d/0x70
 [<ffffffff8104d1b0>] copy_process+0x530/0x1360
 [<ffffffff8104e067>] do_fork+0x87/0x470
 [<ffffffff8100a8a7>] ? native_sched_clock+0x27/0x80
 [<ffffffff81078adf>] ? cpu_clock+0x4f/0x60
 [<ffffffff81435b2e>] ? mutex_unlock+0xe/0x10
 [<ffffffff81084c09>] ? trace_hardirqs_off_caller+0x29/0xe0
 [<ffffffff8143b9e9>] ? sub_preempt_count+0x9/0xa0
 [<ffffffff8108579e>] ? put_lock_stats+0xe/0x30
 [<ffffffff8100b5c1>] kernel_thread+0x71/0x80
 [<ffffffff81b465b3>] ? kernel_init+0x0/0x253
 [<ffffffff81003f10>] ? kernel_thread_helper+0x0/0x10
 [<ffffffff8106ea24>] ? rcu_scheduler_starting+0x24/0x60
 [<ffffffff8141c6a6>] rest_init+0x26/0x110
 [<ffffffff81b46dea>] start_kernel+0x3b9/0x3c5
 [<ffffffff81b46310>] x86_64_start_reservations+0x120/0x124
 [<ffffffff81b463f8>] x86_64_start_kernel+0xe4/0xeb

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
---
 kernel/cpuset.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index b15c01c..4d44f76 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1129,7 +1129,14 @@ done:
 
 int current_cpuset_is_being_rebound(void)
 {
-	return task_cs(current) == cpuset_being_rebound;
+	int being_rebound = 0;
+
+	rcu_read_lock();
+	if (task_cs(current) == cpuset_being_rebound)
+		being_rebound = 1;
+	rcu_read_unlock();
+
+	return being_rebound;
 }
 
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
-- 
1.6.5.2



