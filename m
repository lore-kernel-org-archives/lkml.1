Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbZIPKWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbZIPKWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbZIPKWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:22:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:46473 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486AbZIPKWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:22:16 -0400
Date: Wed, 16 Sep 2009 10:21:43 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Tweak wake_idx
Message-ID: <tip-78e7ed53c9f42f04f9401ada6f7047db60781676@git.kernel.org>
Git-Commit-ID: 78e7ed53c9f42f04f9401ada6f7047db60781676
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:21:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  78e7ed53c9f42f04f9401ada6f7047db60781676
Gitweb:     http://git.kernel.org/tip/78e7ed53c9f42f04f9401ada6f7047db60781676
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 3 Sep 2009 13:16:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:01:07 +0200

sched: Tweak wake_idx

When merging select_task_rq_fair() and sched_balance_self() we lost
the use of wake_idx, restore that and set them to 0 to make wake
balancing more aggressive.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/ia64/include/asm/topology.h     |    5 +++--
 arch/powerpc/include/asm/topology.h  |    3 ++-
 arch/sh/include/asm/topology.h       |    2 +-
 arch/sparc/include/asm/topology_64.h |    2 +-
 arch/x86/include/asm/topology.h      |    2 +-
 include/linux/topology.h             |    4 ++--
 kernel/sched_fair.c                  |   21 ++++++++++++++++++---
 7 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index cf6053b..47f3c51 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -62,11 +62,12 @@ void build_cpu_to_node_map(void);
 	.busy_idx		= 2,			\
 	.idle_idx		= 1,			\
 	.newidle_idx		= 2,			\
-	.wake_idx		= 1,			\
+	.wake_idx		= 0,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_EXEC	\
+				| SD_BALANCE_FORK	\
 				| SD_BALANCE_WAKE	\
 				| SD_WAKE_AFFINE,	\
 	.last_balance		= jiffies,		\
@@ -87,7 +88,7 @@ void build_cpu_to_node_map(void);
 	.busy_idx		= 3,			\
 	.idle_idx		= 2,			\
 	.newidle_idx		= 2,			\
-	.wake_idx		= 1,			\
+	.wake_idx		= 0,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index c634331..a6b220a 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -58,9 +58,10 @@ static inline int pcibus_to_node(struct pci_bus *bus)
 	.busy_idx		= 3,			\
 	.idle_idx		= 1,			\
 	.newidle_idx		= 2,			\
-	.wake_idx		= 1,			\
+	.wake_idx		= 0,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
+				| SD_BALANCE_FORK	\
 				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_WAKE	\
 				| SD_SERIALIZE,		\
diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
index dc1531e..9054e5c 100644
--- a/arch/sh/include/asm/topology.h
+++ b/arch/sh/include/asm/topology.h
@@ -16,7 +16,7 @@
 	.busy_idx		= 3,			\
 	.idle_idx		= 2,			\
 	.newidle_idx		= 2,			\
-	.wake_idx		= 1,			\
+	.wake_idx		= 0,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_FORK	\
diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index 1d091ab..bc3a093 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -52,7 +52,7 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 	.busy_idx		= 3,			\
 	.idle_idx		= 2,			\
 	.newidle_idx		= 0, 			\
-	.wake_idx		= 1,			\
+	.wake_idx		= 0,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_FORK	\
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 966d58d..4b1b335 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -138,7 +138,7 @@ extern unsigned long node_remap_size[];
 	.busy_idx		= 3,					\
 	.idle_idx		= SD_IDLE_IDX,				\
 	.newidle_idx		= SD_NEWIDLE_IDX,			\
-	.wake_idx		= 1,					\
+	.wake_idx		= 0,					\
 	.forkexec_idx		= SD_FORKEXEC_IDX,			\
 									\
 	.flags			= 1*SD_LOAD_BALANCE			\
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 6a8cd15..fef5704 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -120,7 +120,7 @@ int arch_update_cpu_topology(void);
 	.imbalance_pct		= 125,					\
 	.cache_nice_tries	= 1,					\
 	.busy_idx		= 2,					\
-	.wake_idx		= 1,					\
+	.wake_idx		= 0,					\
 	.forkexec_idx		= 1,					\
 									\
 	.flags			= 1*SD_LOAD_BALANCE			\
@@ -152,7 +152,7 @@ int arch_update_cpu_topology(void);
 	.busy_idx		= 2,					\
 	.idle_idx		= 1,					\
 	.newidle_idx		= 2,					\
-	.wake_idx		= 1,					\
+	.wake_idx		= 0,					\
 	.forkexec_idx		= 1,					\
 									\
 	.flags			= 1*SD_LOAD_BALANCE			\
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8b3eddb..1959356 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1232,12 +1232,27 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
  * domain.
  */
 static struct sched_group *
-find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
+find_idlest_group(struct sched_domain *sd, struct task_struct *p,
+		  int this_cpu, int flag)
 {
 	struct sched_group *idlest = NULL, *this = NULL, *group = sd->groups;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
-	int load_idx = sd->forkexec_idx;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
+	int load_idx = 0;
+
+	switch (flag) {
+	case SD_BALANCE_FORK:
+	case SD_BALANCE_EXEC:
+		load_idx = sd->forkexec_idx;
+		break;
+
+	case SD_BALANCE_WAKE:
+		load_idx = sd->wake_idx;
+		break;
+
+	default:
+		break;
+	}
 
 	do {
 		unsigned long load, avg_load;
@@ -1392,7 +1407,7 @@ static int select_task_rq_fair(struct task_struct *p, int flag, int sync)
 			continue;
 		}
 
-		group = find_idlest_group(sd, p, cpu);
+		group = find_idlest_group(sd, p, cpu, flag);
 		if (!group) {
 			sd = sd->child;
 			continue;
