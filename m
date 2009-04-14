Return-Path: <linux-kernel-owner+w=401wt.eu-S1756594AbZDNKEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbZDNKEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbZDNKCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:02:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:45819 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbZDNKCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:02:41 -0400
Date: Tue, 14 Apr 2009 10:01:56 GMT
From: tip-bot for Gautham R Shenoy <ego@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090414045535.7645.31641.stgit@sofia.in.ibm.com>
References: <20090414045535.7645.31641.stgit@sofia.in.ibm.com>
Subject: [tip:sched/core] sched: Nominate a power-efficient ilb in select_nohz_balancer()
Message-ID: <tip-e790fb0ba64bfec158e1219d899cb588275d12ab@git.kernel.org>
Git-Commit-ID: e790fb0ba64bfec158e1219d899cb588275d12ab
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 10:01:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e790fb0ba64bfec158e1219d899cb588275d12ab
Gitweb:     http://git.kernel.org/tip/e790fb0ba64bfec158e1219d899cb588275d12ab
Author:     Gautham R Shenoy <ego@in.ibm.com>
AuthorDate: Tue, 14 Apr 2009 10:25:35 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 11:49:19 +0200

sched: Nominate a power-efficient ilb in select_nohz_balancer()

The CPU that first goes idle becomes the idle-load-balancer and remains
that until either it picks up a task or till all the CPUs of the system
goes idle.

Optimize this further to allow it to relinquish it's post
once all it's siblings in the power-aware sched_domain go idle, thereby
allowing the whole package-core to go idle. While relinquising the post,
nominate another an idle-load balancer from a semi-idle core/package.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090414045535.7645.31641.stgit@sofia.in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b0fefa3..36d213b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4414,8 +4414,24 @@ int select_nohz_load_balancer(int stop_tick)
 			/* make me the ilb owner */
 			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) == -1)
 				return 1;
-		} else if (atomic_read(&nohz.load_balancer) == cpu)
+		} else if (atomic_read(&nohz.load_balancer) == cpu) {
+			int new_ilb;
+
+			if (!(sched_smt_power_savings ||
+						sched_mc_power_savings))
+				return 1;
+			/*
+			 * Check to see if there is a more power-efficient
+			 * ilb.
+			 */
+			new_ilb = find_new_ilb(cpu);
+			if (new_ilb < nr_cpu_ids && new_ilb != cpu) {
+				atomic_set(&nohz.load_balancer, -1);
+				resched_cpu(new_ilb);
+				return 0;
+			}
 			return 1;
+		}
 	} else {
 		if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
 			return 0;
