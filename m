Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbZHSMKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbZHSMKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 08:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZHSMKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 08:10:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:47245 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbZHSMKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 08:10:18 -0400
Date: Wed, 19 Aug 2009 12:09:38 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, josht@linux.vnet.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, josht@linux.vnet.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090819060614.GA14383@linux.vnet.ibm.com>
References: <20090819060614.GA14383@linux.vnet.ibm.com>
Subject: [tip:core/rcu] rcu: Delay rcu_barrier() wait until beginning of next CPU-hotunplug operation.
Message-ID: <tip-1423cc033df017c762a9155eec470da77a460141@git.kernel.org>
Git-Commit-ID: 1423cc033df017c762a9155eec470da77a460141
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 19 Aug 2009 12:09:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1423cc033df017c762a9155eec470da77a460141
Gitweb:     http://git.kernel.org/tip/1423cc033df017c762a9155eec470da77a460141
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Tue, 18 Aug 2009 23:06:14 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 19 Aug 2009 13:58:54 +0200

rcu: Delay rcu_barrier() wait until beginning of next CPU-hotunplug operation.

Ingo Molnar reported this lockup:

 [  200.380003] Hangcheck: hangcheck value past margin!
 [  248.192003] INFO: task S99local:2974 blocked for more than 120 seconds.
 [  248.194532] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 [  248.202330] S99local      D 0000000c  6256  2974   2687 0x00000000
 [  248.208929]  9c7ebe90 00000086 6b67ef8b 0000000c 9f25a610 81a69869 00000001 820b6990
 [  248.216123]  820b6990 820b6990 9c6e4c20 9c6e4eb4 82c78990 00000000 6b993559 0000000c
 [  248.220616]  9c7ebe90 8105f22a 9c6e4eb4 9c6e4c20 00000001 9c7ebe98 9c7ebeb4 81a65cb3
 [  248.229990] Call Trace:
 [  248.234049]  [<81a69869>] ? _spin_unlock_irqrestore+0x22/0x37
 [  248.239769]  [<8105f22a>] ? prepare_to_wait+0x48/0x4e
 [  248.244796]  [<81a65cb3>] rcu_barrier_cpu_hotplug+0xaa/0xc9
 [  248.250343]  [<8105f029>] ? autoremove_wake_function+0x0/0x38
 [  248.256063]  [<81062cf2>] notifier_call_chain+0x49/0x71
 [  248.261263]  [<81062da0>] raw_notifier_call_chain+0x11/0x13
 [  248.266809]  [<81a0b475>] _cpu_down+0x272/0x288
 [  248.271316]  [<81a0b4d5>] cpu_down+0x4a/0xa2
 [  248.275563]  [<81a0c48a>] store_online+0x2a/0x5e
 [  248.280156]  [<81a0c460>] ? store_online+0x0/0x5e
 [  248.284836]  [<814ddc35>] sysdev_store+0x20/0x28
 [  248.289429]  [<8112e403>] sysfs_write_file+0xb8/0xe3
 [  248.294369]  [<8112e34b>] ? sysfs_write_file+0x0/0xe3
 [  248.299396]  [<810e4c8f>] vfs_write+0x91/0x120
 [  248.303817]  [<810e4dc1>] sys_write+0x40/0x65
 [  248.308150]  [<81002d73>] sysenter_do_call+0x12/0x28

This change moves an RCU grace period delay off of the
critical path for CPU-hotunplug operations.

Since RCU callback migration is only performed on
CPU-hotunplug operations, and since the rcu_barrier() race is
provoked only by consecutive CPU-hotunplug operations, it is
not necessary to delay the end of a given CPU-hotunplug
operation.

We can instead choose to delay the beginning of the next
CPU-hotunplug operation.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: akpm@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: hugh.dickins@tiscali.co.uk
Cc: benh@kernel.crashing.org
LKML-Reference: <20090819060614.GA14383@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcupdate.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 8df1156..bd5d5c8 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -238,7 +238,8 @@ static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 		call_rcu_bh(rcu_migrate_head, rcu_migrate_callback);
 		call_rcu_sched(rcu_migrate_head + 1, rcu_migrate_callback);
 		call_rcu(rcu_migrate_head + 2, rcu_migrate_callback);
-	} else if (action == CPU_POST_DEAD) {
+	} else if (action == CPU_DOWN_PREPARE) {
+		/* Don't need to wait until next removal operation. */
 		/* rcu_migrate_head is protected by cpu_add_remove_lock */
 		wait_migrated_callbacks();
 	}
