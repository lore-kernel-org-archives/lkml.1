Return-Path: <linux-kernel-owner+w=401wt.eu-S933286AbZIDI4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286AbZIDI4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933272AbZIDI4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:56:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:36653 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932984AbZIDI4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:56:10 -0400
Date: Fri, 4 Sep 2009 08:55:36 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, andreas.herrmann3@amd.com, a.p.zijlstra@chello.nl,
       balbir@in.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: balbir@in.ibm.com, mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090901083826.073345955@chello.nl>
References: <20090901083826.073345955@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/balancing] sched: Add smt_gain
Message-ID: <tip-a52bfd73589eaf88d9c95ad2c1de0b38a6b27972@git.kernel.org>
Git-Commit-ID: a52bfd73589eaf88d9c95ad2c1de0b38a6b27972
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 08:55:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a52bfd73589eaf88d9c95ad2c1de0b38a6b27972
Gitweb:     http://git.kernel.org/tip/a52bfd73589eaf88d9c95ad2c1de0b38a6b27972
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 1 Sep 2009 10:34:35 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 10:09:54 +0200

sched: Add smt_gain

The idea is that multi-threading a core yields more work
capacity than a single thread, provide a way to express a
static gain for threads.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
LKML-Reference: <20090901083826.073345955@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h    |    1 +
 include/linux/topology.h |    1 +
 kernel/sched.c           |    8 +++++++-
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 651dded..9c81c92 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -921,6 +921,7 @@ struct sched_domain {
 	unsigned int newidle_idx;
 	unsigned int wake_idx;
 	unsigned int forkexec_idx;
+	unsigned int smt_gain;
 	int flags;			/* See SD_* */
 	enum sched_domain_level level;
 
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 7402c1a..6203ae5 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -99,6 +99,7 @@ int arch_update_cpu_topology(void);
 				| SD_SHARE_CPUPOWER,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
+	.smt_gain		= 1178,	/* 15% */	\
 }
 #endif
 #endif /* CONFIG_SCHED_SMT */
diff --git a/kernel/sched.c b/kernel/sched.c
index ecb4a47..5511226 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8523,9 +8523,15 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 		weight = cpumask_weight(sched_domain_span(sd));
 		/*
 		 * SMT siblings share the power of a single core.
+		 * Usually multiple threads get a better yield out of
+		 * that one core than a single thread would have,
+		 * reflect that in sd->smt_gain.
 		 */
-		if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1)
+		if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
+			power *= sd->smt_gain;
 			power /= weight;
+			power >>= SCHED_LOAD_SHIFT;
+		}
 		sg_inc_cpu_power(sd->groups, power);
 		return;
 	}
