Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZFXGr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZFXGr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZFXGqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:46:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:57073 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbZFXGqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:46:13 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, cl@linux-foundation.org,
       Jesper.Nilsson@axis.com, benh@kernel.crashing.org,
       paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>, Mike Frysinger <vapier@gentoo.org>,
       Tony Luck <tony.luck@intel.com>, Andy Grover <andy.grover@oracle.com>
Subject: [PATCH 05/10] percpu: use DEFINE_PER_CPU_SHARED_ALIGNED()
Date: Wed, 24 Jun 2009 15:45:19 +0900
Message-Id: <1245825924-30412-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1245825924-30412-1-git-send-email-tj@kernel.org>
References: <1245825924-30412-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 24 Jun 2009 06:45:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few places where ___cacheline_aligned* is used with
DEFINE_PER_CPU().  Use DEFINE_PER_CPU_SHARED_ALIGNED() instead.

DEFINE_PER_CPU_SHARED_ALIGNED() applies alignment only on SMPs.  While
all other converted places used _in_smp variant or only get compiled
for SMP, net/rds used unconditional ____cacheline_aligned.  I don't
see any reason these data structures should be aligned on UP and thus
converted together.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Andy Grover <andy.grover@oracle.com>
---
 arch/blackfin/mm/sram-alloc.c |    6 +++---
 arch/ia64/kernel/smp.c        |    3 ++-
 kernel/sched.c                |    4 ++--
 net/rds/ib_stats.c            |    2 +-
 net/rds/iw_stats.c            |    2 +-
 net/rds/page.c                |    2 +-
 6 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/blackfin/mm/sram-alloc.c b/arch/blackfin/mm/sram-alloc.c
index 0bc3c4e..99e4dbb 100644
--- a/arch/blackfin/mm/sram-alloc.c
+++ b/arch/blackfin/mm/sram-alloc.c
@@ -42,9 +42,9 @@
 #include <asm/mem_map.h>
 #include "blackfin_sram.h"
 
-static DEFINE_PER_CPU(spinlock_t, l1sram_lock) ____cacheline_aligned_in_smp;
-static DEFINE_PER_CPU(spinlock_t, l1_data_sram_lock) ____cacheline_aligned_in_smp;
-static DEFINE_PER_CPU(spinlock_t, l1_inst_sram_lock) ____cacheline_aligned_in_smp;
+static DEFINE_PER_CPU_SHARED_ALIGNED(spinlock_t, l1sram_lock);
+static DEFINE_PER_CPU_SHARED_ALIGNED(spinlock_t, l1_data_sram_lock);
+static DEFINE_PER_CPU_SHARED_ALIGNED(spinlock_t, l1_inst_sram_lock);
 static spinlock_t l2_sram_lock ____cacheline_aligned_in_smp;
 
 /* the data structure for L1 scratchpad and DATA SRAM */
diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index 94cf78b..93ebfea 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -58,7 +58,8 @@ static struct local_tlb_flush_counts {
 	unsigned int count;
 } __attribute__((__aligned__(32))) local_tlb_flush_counts[NR_CPUS];
 
-static DEFINE_PER_CPU(unsigned short [NR_CPUS], shadow_flush_counts) ____cacheline_aligned;
+static DEFINE_PER_CPU_SHARED_ALIGNED(unsigned short [NR_CPUS],
+				     shadow_flush_counts);
 
 #define IPI_CALL_FUNC		0
 #define IPI_CPU_STOP		1
diff --git a/kernel/sched.c b/kernel/sched.c
index 7c9098d..34fd81d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -318,12 +318,12 @@ struct task_group root_task_group;
 /* Default task group's sched entity on each cpu */
 static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
 /* Default task group's cfs_rq on each cpu */
-static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct cfs_rq, init_cfs_rq);
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
-static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct rt_rq, init_rt_rq);
 #endif /* CONFIG_RT_GROUP_SCHED */
 #else /* !CONFIG_USER_SCHED */
 #define root_task_group init_task_group
diff --git a/net/rds/ib_stats.c b/net/rds/ib_stats.c
index 02e3e3d..301ae51 100644
--- a/net/rds/ib_stats.c
+++ b/net/rds/ib_stats.c
@@ -37,7 +37,7 @@
 #include "rds.h"
 #include "ib.h"
 
-DEFINE_PER_CPU(struct rds_ib_statistics, rds_ib_stats) ____cacheline_aligned;
+DEFINE_PER_CPU_SHARED_ALIGNED(struct rds_ib_statistics, rds_ib_stats);
 
 static char *rds_ib_stat_names[] = {
 	"ib_connect_raced",
diff --git a/net/rds/iw_stats.c b/net/rds/iw_stats.c
index ccc7e8f..fafea3c 100644
--- a/net/rds/iw_stats.c
+++ b/net/rds/iw_stats.c
@@ -37,7 +37,7 @@
 #include "rds.h"
 #include "iw.h"
 
-DEFINE_PER_CPU(struct rds_iw_statistics, rds_iw_stats) ____cacheline_aligned;
+DEFINE_PER_CPU_SHARED_ALIGNED(struct rds_iw_statistics, rds_iw_stats);
 
 static char *rds_iw_stat_names[] = {
 	"iw_connect_raced",
diff --git a/net/rds/page.c b/net/rds/page.c
index c460743..de7bb84 100644
--- a/net/rds/page.c
+++ b/net/rds/page.c
@@ -39,7 +39,7 @@ struct rds_page_remainder {
 	unsigned long	r_offset;
 };
 
-DEFINE_PER_CPU(struct rds_page_remainder, rds_page_remainders) ____cacheline_aligned;
+DEFINE_PER_CPU_SHARED_ALIGNED(struct rds_page_remainder, rds_page_remainders);
 
 /*
  * returns 0 on success or -errno on failure.
-- 
1.6.0.2

