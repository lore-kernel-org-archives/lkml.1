Return-Path: <linux-kernel-owner+w=401wt.eu-S1758538AbZIPKVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbZIPKVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758391AbZIPKVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:21:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:46436 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757563AbZIPKVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:21:44 -0400
Date: Wed, 16 Sep 2009 10:21:17 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: for_each_domain() vs RCU
Message-ID: <tip-83f54960c11a14942ab00b54c51e91906b9d8235@git.kernel.org>
Git-Commit-ID: 83f54960c11a14942ab00b54c51e91906b9d8235
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:21:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  83f54960c11a14942ab00b54c51e91906b9d8235
Gitweb:     http://git.kernel.org/tip/83f54960c11a14942ab00b54c51e91906b9d8235
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 10 Sep 2009 18:18:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:01:06 +0200

sched: for_each_domain() vs RCU

for_each_domain() uses RCU to serialize the sched_domains, except
it doesn't actually use rcu_read_lock() and instead relies on
disabling preemption -> FAIL.

XXX: audit other sched_domain code.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index eaa0001..43dc6d1 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1331,6 +1331,7 @@ static int select_task_rq_fair(struct task_struct *p, int flag, int sync)
 		new_cpu = prev_cpu;
 	}
 
+	rcu_read_lock();
 	for_each_domain(cpu, tmp) {
 		/*
 		 * If power savings logic is enabled for a domain, see if we
@@ -1369,8 +1370,10 @@ static int select_task_rq_fair(struct task_struct *p, int flag, int sync)
 		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
 		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
 
-			if (wake_affine(tmp, p, sync))
-				return cpu;
+			if (wake_affine(tmp, p, sync)) {
+				new_cpu = cpu;
+				goto out;
+			}
 
 			want_affine = 0;
 		}
@@ -1416,6 +1419,8 @@ static int select_task_rq_fair(struct task_struct *p, int flag, int sync)
 		/* while loop will break here if sd == NULL */
 	}
 
+out:
+	rcu_read_unlock();
 	return new_cpu;
 }
 #endif /* CONFIG_SMP */
