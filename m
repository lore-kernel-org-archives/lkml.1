Return-Path: <linux-kernel-owner+w=401wt.eu-S1758689AbZIPKWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbZIPKWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbZIPKWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:22:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:46487 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758616AbZIPKW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:22:29 -0400
Date: Wed, 16 Sep 2009 10:22:11 GMT
From: tip-bot for Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       darkshikari@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       darkshikari@gmail.com, mingo@elte.hu
In-Reply-To: <1253011667.9128.16.camel@marge.simson.net>
References: <1253011667.9128.16.camel@marge.simson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Improve latencies and throughput
Message-ID: <tip-0ec9fab3d186d9cbb00c0f694d4a260d07c198d9@git.kernel.org>
Git-Commit-ID: 0ec9fab3d186d9cbb00c0f694d4a260d07c198d9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:22:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ec9fab3d186d9cbb00c0f694d4a260d07c198d9
Gitweb:     http://git.kernel.org/tip/0ec9fab3d186d9cbb00c0f694d4a260d07c198d9
Author:     Mike Galbraith <efault@gmx.de>
AuthorDate: Tue, 15 Sep 2009 15:07:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:51:16 +0200

sched: Improve latencies and throughput

Make the idle balancer more agressive, to improve a
x264 encoding workload provided by Jason Garrett-Glaser:

 NEXT_BUDDY NO_LB_BIAS
 encoded 600 frames, 252.82 fps, 22096.60 kb/s
 encoded 600 frames, 250.69 fps, 22096.60 kb/s
 encoded 600 frames, 245.76 fps, 22096.60 kb/s

 NO_NEXT_BUDDY LB_BIAS
 encoded 600 frames, 344.44 fps, 22096.60 kb/s
 encoded 600 frames, 346.66 fps, 22096.60 kb/s
 encoded 600 frames, 352.59 fps, 22096.60 kb/s

 NO_NEXT_BUDDY NO_LB_BIAS
 encoded 600 frames, 425.75 fps, 22096.60 kb/s
 encoded 600 frames, 425.45 fps, 22096.60 kb/s
 encoded 600 frames, 422.49 fps, 22096.60 kb/s

Peter pointed out that this is better done via newidle_idx,
not via LB_BIAS, newidle balancing should look for where
there is load _now_, not where there was load 2 ticks ago.

Worst-case latencies are improved as well as no buddies
means less vruntime spread. (as per prior lkml discussions)

This change improves kbuild-peak parallelism as well.

Reported-by: Jason Garrett-Glaser <darkshikari@gmail.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1253011667.9128.16.camel@marge.simson.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/ia64/include/asm/topology.h    |    5 +++--
 arch/powerpc/include/asm/topology.h |    2 +-
 arch/sh/include/asm/topology.h      |    3 ++-
 arch/x86/include/asm/topology.h     |    4 +---
 include/linux/topology.h            |    2 +-
 kernel/sched_features.h             |    2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index 47f3c51..42f1673 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -61,7 +61,7 @@ void build_cpu_to_node_map(void);
 	.cache_nice_tries	= 2,			\
 	.busy_idx		= 2,			\
 	.idle_idx		= 1,			\
-	.newidle_idx		= 2,			\
+	.newidle_idx		= 0,			\
 	.wake_idx		= 0,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
@@ -87,10 +87,11 @@ void build_cpu_to_node_map(void);
 	.cache_nice_tries	= 2,			\
 	.busy_idx		= 3,			\
 	.idle_idx		= 2,			\
-	.newidle_idx		= 2,			\
+	.newidle_idx		= 0,			\
 	.wake_idx		= 0,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
+				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_WAKE	\
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index a6b220a..1a2c9eb 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -57,7 +57,7 @@ static inline int pcibus_to_node(struct pci_bus *bus)
 	.cache_nice_tries	= 1,			\
 	.busy_idx		= 3,			\
 	.idle_idx		= 1,			\
-	.newidle_idx		= 2,			\
+	.newidle_idx		= 0,			\
 	.wake_idx		= 0,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
index 9054e5c..c843677 100644
--- a/arch/sh/include/asm/topology.h
+++ b/arch/sh/include/asm/topology.h
@@ -15,13 +15,14 @@
 	.cache_nice_tries	= 2,			\
 	.busy_idx		= 3,			\
 	.idle_idx		= 2,			\
-	.newidle_idx		= 2,			\
+	.newidle_idx		= 0,			\
 	.wake_idx		= 0,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_WAKE	\
+				| SD_BALANCE_NEWIDLE	\
 				| SD_SERIALIZE,		\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 4b1b335..7fafd1b 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -116,14 +116,12 @@ extern unsigned long node_remap_size[];
 
 # define SD_CACHE_NICE_TRIES	1
 # define SD_IDLE_IDX		1
-# define SD_NEWIDLE_IDX		2
 # define SD_FORKEXEC_IDX	0
 
 #else
 
 # define SD_CACHE_NICE_TRIES	2
 # define SD_IDLE_IDX		2
-# define SD_NEWIDLE_IDX		2
 # define SD_FORKEXEC_IDX	1
 
 #endif
@@ -137,7 +135,7 @@ extern unsigned long node_remap_size[];
 	.cache_nice_tries	= SD_CACHE_NICE_TRIES,			\
 	.busy_idx		= 3,					\
 	.idle_idx		= SD_IDLE_IDX,				\
-	.newidle_idx		= SD_NEWIDLE_IDX,			\
+	.newidle_idx		= 0,					\
 	.wake_idx		= 0,					\
 	.forkexec_idx		= SD_FORKEXEC_IDX,			\
 									\
diff --git a/include/linux/topology.h b/include/linux/topology.h
index c87edcd..4298745 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -151,7 +151,7 @@ int arch_update_cpu_topology(void);
 	.cache_nice_tries	= 1,					\
 	.busy_idx		= 2,					\
 	.idle_idx		= 1,					\
-	.newidle_idx		= 2,					\
+	.newidle_idx		= 0,					\
 	.wake_idx		= 0,					\
 	.forkexec_idx		= 1,					\
 									\
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 891ea0f..e98c2e8 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -67,7 +67,7 @@ SCHED_FEAT(AFFINE_WAKEUPS, 1)
  * wakeup-preemption), since its likely going to consume data we
  * touched, increases cache locality.
  */
-SCHED_FEAT(NEXT_BUDDY, 1)
+SCHED_FEAT(NEXT_BUDDY, 0)
 
 /*
  * Prefer to schedule the task that ran last (when we did
