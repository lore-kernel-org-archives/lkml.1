Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZKFHKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZKFHKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 02:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbZKFHKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 02:10:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:44963 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbZKFHKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 02:10:16 -0500
Date: Fri, 6 Nov 2009 07:09:44 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, stable@kernel.org, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1257415066.12867.1.camel@marge.simson.net>
References: <1257415066.12867.1.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix affinity logic in select_task_rq_fair()
Message-ID: <tip-fd210738f6601d0fb462df9a2fe5a41896ff6a8f@git.kernel.org>
Git-Commit-ID: fd210738f6601d0fb462df9a2fe5a41896ff6a8f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd210738f6601d0fb462df9a2fe5a41896ff6a8f
Gitweb:     http://git.kernel.org/tip/fd210738f6601d0fb462df9a2fe5a41896ff6a8f
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Thu, 5 Nov 2009 10:57:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Nov 2009 11:01:39 +0100

sched: Fix affinity logic in select_task_rq_fair()

Ingo Molnar reported:

[   26.804000] BUG: using smp_processor_id() in preemptible [00000000] code: events/1/10
[   26.808000] caller is vmstat_update+0x26/0x70
[   26.812000] Pid: 10, comm: events/1 Not tainted 2.6.32-rc5 #6887
[   26.816000] Call Trace:
[   26.820000]  [<c1924a24>] ? printk+0x28/0x3c
[   26.824000]  [<c13258a0>] debug_smp_processor_id+0xf0/0x110
[   26.824000] mount used greatest stack depth: 1464 bytes left
[   26.828000]  [<c111d086>] vmstat_update+0x26/0x70
[   26.832000]  [<c1086418>] worker_thread+0x188/0x310
[   26.836000]  [<c10863b7>] ? worker_thread+0x127/0x310
[   26.840000]  [<c108d310>] ? autoremove_wake_function+0x0/0x60
[   26.844000]  [<c1086290>] ? worker_thread+0x0/0x310
[   26.848000]  [<c108cf0c>] kthread+0x7c/0x90
[   26.852000]  [<c108ce90>] ? kthread+0x0/0x90
[   26.856000]  [<c100c0a7>] kernel_thread_helper+0x7/0x10
[   26.860000] BUG: using smp_processor_id() in preemptible [00000000] code: events/1/10
[   26.864000] caller is vmstat_update+0x3c/0x70

Because this commit:

  a1f84a3: sched: Check for an idle shared cache in select_task_rq_fair()

broke ->cpus_allowed.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: arjan@infradead.org
Cc: <stable@kernel.org>
LKML-Reference: <1257415066.12867.1.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index da87385..e4d4483 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1389,6 +1389,8 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 
 				if (candidate == -1 || candidate == cpu) {
 					for_each_cpu(i, sched_domain_span(tmp)) {
+						if (!cpumask_test_cpu(i, &p->cpus_allowed))
+							continue;
 						if (!cpu_rq(i)->cfs.nr_running) {
 							candidate = i;
 							break;
