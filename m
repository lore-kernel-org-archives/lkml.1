Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbZFOHyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbZFOHyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 03:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZFOHyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 03:54:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:39956 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZFOHyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 03:54:43 -0400
Subject: Re: perfcounters: lockdep warning
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Cc: Ingo Molnar <mingo@elte.hu>, Paulus Mackerras <paulus@samba.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1244921989.12341.487.camel@odie.local>
References: <1244921989.12341.487.camel@odie.local>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Jun 2009 09:54:35 +0200
Message-Id: <1245052475.6800.35.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-13 at 21:39 +0200, Simon Holm Thøgersen wrote:
> Just tried kicking the tires of performance counters and perf and got
> the following warning that doesn't look like have been reported already.
> 
> [ 7765.594591] [ INFO: possible circular locking dependency detected ]
> [ 7765.594602] 2.6.30debug-03217-gf3ad116 #47
> [ 7765.594609] -------------------------------------------------------
> [ 7765.594619] perf/14176 is trying to acquire lock:
> [ 7765.594628]  (&ctx->mutex){+.+.+.}, at: [<c016f366>] perf_counter_for_each_sibling+0x50/0x7e
> [ 7765.594660] 
> [ 7765.594663] but task is already holding lock:
> [ 7765.594672]  (&counter->child_mutex){+.+...}, at: [<c0172180>] perf_ioctl+0x184/0x1de
> [ 7765.594696] 
> [ 7765.594699] which lock already depends on the new lock.
> [ 7765.594703] 
> [ 7765.594711] 
> [ 7765.594714] the existing dependency chain (in reverse order) is:
> [ 7765.594723] 
> [ 7765.594726] -> #1 (&counter->child_mutex){+.+...}:
> [ 7765.594744]        [<c0146f79>] __lock_acquire+0x9a5/0xb11
> [ 7765.594765]        [<c014719e>] lock_acquire+0xb9/0xdb
> [ 7765.594779]        [<c0340664>] __mutex_lock_common+0x42/0x3c8
> [ 7765.594798]        [<c0340a82>] mutex_lock_nested+0x2e/0x36
> [ 7765.594814]        [<c016f8ad>] inherit_counter+0xdb/0x112
> [ 7765.594830]        [<c01705bd>] perf_counter_init_task+0x15b/0x23f
> [ 7765.594847]        [<c0124338>] copy_process+0x4fb/0xfc8
> [ 7765.594865]        [<c0124f1c>] do_fork+0x117/0x2b4
> [ 7765.594881]        [<c0101f4f>] sys_clone+0x29/0x30
> [ 7765.594897]        [<c01032e8>] sysenter_do_call+0x12/0x3c
> [ 7765.594913]        [<ffffffff>] 0xffffffff
> [ 7765.594967] 
> [ 7765.594970] -> #0 (&ctx->mutex){+.+.+.}:
> [ 7765.594987]        [<c0146e8c>] __lock_acquire+0x8b8/0xb11
> [ 7765.595004]        [<c014719e>] lock_acquire+0xb9/0xdb
> [ 7765.595018]        [<c0340664>] __mutex_lock_common+0x42/0x3c8
> [ 7765.595035]        [<c0340a82>] mutex_lock_nested+0x2e/0x36
> [ 7765.595050]        [<c016f366>] perf_counter_for_each_sibling+0x50/0x7e
> [ 7765.595067]        [<c0172189>] perf_ioctl+0x18d/0x1de
> [ 7765.595083]        [<c019fa6e>] vfs_ioctl+0x27/0x6e
> [ 7765.595100]        [<c019ff4f>] do_vfs_ioctl+0x45a/0x48c
> [ 7765.595116]        [<c019ffb2>] sys_ioctl+0x31/0x4a
> [ 7765.595132]        [<c01032e8>] sysenter_do_call+0x12/0x3c
> [ 7765.595147]        [<ffffffff>] 0xffffffff
> [ 7765.595163] 
> [ 7765.595166] other info that might help us debug this:
> [ 7765.595170] 
> [ 7765.595180] 1 lock held by perf/14176:
> [ 7765.595188]  #0:  (&counter->child_mutex){+.+...}, at: [<c0172180>] perf_ioctl+0x184/0x1de
> [ 7765.595215] 
> [ 7765.595218] stack backtrace:
> [ 7765.595230] Pid: 14176, comm: perf Not tainted 2.6.30debug-03217-gf3ad116 #47
> [ 7765.595240] Call Trace:
> [ 7765.595254]  [<c033f7f9>] ? printk+0x14/0x16
> [ 7765.595271]  [<c0146310>] print_circular_bug_tail+0x5c/0x67
> [ 7765.595289]  [<c0146e8c>] __lock_acquire+0x8b8/0xb11
> [ 7765.595306]  [<c014719e>] lock_acquire+0xb9/0xdb
> [ 7765.595322]  [<c016f366>] ? perf_counter_for_each_sibling+0x50/0x7e
> [ 7765.595338]  [<c0340664>] __mutex_lock_common+0x42/0x3c8
> [ 7765.595354]  [<c016f366>] ? perf_counter_for_each_sibling+0x50/0x7e
> [ 7765.595371]  [<c034099b>] ? __mutex_lock_common+0x379/0x3c8
> [ 7765.595387]  [<c0340a82>] mutex_lock_nested+0x2e/0x36
> [ 7765.595402]  [<c016f366>] ? perf_counter_for_each_sibling+0x50/0x7e
> [ 7765.595419]  [<c016f366>] perf_counter_for_each_sibling+0x50/0x7e
> [ 7765.595434]  [<c0170f78>] ? perf_counter_enable+0x0/0xad
> [ 7765.595449]  [<c0171ffc>] ? perf_ioctl+0x0/0x1de
> [ 7765.595464]  [<c0170f78>] ? perf_counter_enable+0x0/0xad
> [ 7765.595479]  [<c0172189>] perf_ioctl+0x18d/0x1de
> [ 7765.595494]  [<c0171ffc>] ? perf_ioctl+0x0/0x1de
> [ 7765.595509]  [<c019fa6e>] vfs_ioctl+0x27/0x6e
> [ 7765.595525]  [<c019ff4f>] do_vfs_ioctl+0x45a/0x48c
> [ 7765.595540]  [<c0107003>] ? native_sched_clock+0x45/0x5e
> [ 7765.595556]  [<c0144a37>] ? put_lock_stats+0x1e/0x29
> [ 7765.595572]  [<c0144af8>] ? lock_release_holdtime+0xb6/0xbb
> [ 7765.595589]  [<c0105e7b>] ? sys_mmap2+0x67/0x7f
> [ 7765.595604]  [<c0103321>] ? sysenter_exit+0xf/0x1a
> [ 7765.595620]  [<c019ffb2>] sys_ioctl+0x31/0x4a
> [ 7765.595635]  [<c01032e8>] sysenter_do_call+0x12/0x3c

Right, good catch ;-)

Does this fix it?

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index e914daf..35fa30b 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1658,14 +1658,18 @@ static void perf_counter_for_each_child(struct perf_counter *counter,
 static void perf_counter_for_each(struct perf_counter *counter,
 				  void (*func)(struct perf_counter *))
 {
-	struct perf_counter *child;
+	struct perf_counter_context *ctx = counter->ctx;
+	struct perf_counter *sibling;
 
-	WARN_ON_ONCE(counter->ctx->parent_ctx);
-	mutex_lock(&counter->child_mutex);
-	perf_counter_for_each_sibling(counter, func);
-	list_for_each_entry(child, &counter->child_list, child_list)
-		perf_counter_for_each_sibling(child, func);
-	mutex_unlock(&counter->child_mutex);
+	WARN_ON_ONCE(ctx->parent_ctx);
+	mutex_lock(&ctx->mutex);
+	counter = counter->group_leader;
+
+	perf_counter_for_each_child(counter, func)
+	func(counter);
+	list_for_each_entry(sibling, &counter->sibling_list, list_entry)
+		perf_counter_for_each_child(counter, func)
+	mutex_unlock(&ctx->mutex);
 }
 
 static int perf_counter_period(struct perf_counter *counter, u64 __user *arg)




> Peter: I guess you read both so it is probably not a real problem,
> but you're listed in MAINTAINERS with two different emails.

Yeah, they all end up in the same mailbox ;-)



