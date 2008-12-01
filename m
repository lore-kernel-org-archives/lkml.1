Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbYLAGSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbYLAGSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 01:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbYLAGRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 01:17:45 -0500
Received: from ozlabs.org ([203.10.76.45]:42921 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbYLAGRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 01:17:44 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 16:47:41 +1030
Subject: [PATCH 4/4] cpumask: Replace cpu_coregroup_map with cpu_coregroup_map()
Cc: Mike Travis <travis@sgi.com>, Jens Axboe <axboe@kernel.dk>,
       Ingo Molnar <mingo@redhat.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       David Miller <davem@davemloft.net>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ingo Molnar <mingo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011647.42020.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_coregroup_map returned a cpumask_t: it's going away.

(Note, the sched part of this patch won't apply meaningfully to the
sched tree, but I'm posting it to show the goal).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ingo Molnar <mingo@redhat.com>
---
 block/blk.h    |    4 ++--
 kernel/sched.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk.h b/block/blk.h
--- a/block/blk.h
+++ b/block/blk.h
@@ -99,8 +99,8 @@ static inline int blk_cpu_to_group(int c
 static inline int blk_cpu_to_group(int cpu)
 {
 #ifdef CONFIG_SCHED_MC
-	cpumask_t mask = cpu_coregroup_map(cpu);
-	return first_cpu(mask);
+	const struct cpumask *mask = cpu_coregroup_mask(cpu);
+	return cpumask_first(mask);
 #elif defined(CONFIG_SCHED_SMT)
 	return first_cpu(per_cpu(cpu_sibling_map, cpu));
 #else
diff --git a/kernel/sched.c b/kernel/sched.c
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7116,7 +7116,7 @@ cpu_to_phys_group(int cpu, const cpumask
 {
 	int group;
 #ifdef CONFIG_SCHED_MC
-	*mask = cpu_coregroup_map(cpu);
+	*mask = *cpu_coregroup_mask(cpu);
 	cpus_and(*mask, *mask, *cpu_map);
 	group = first_cpu(*mask);
 #elif defined(CONFIG_SCHED_SMT)
@@ -7482,7 +7482,7 @@ static int __build_sched_domains(const c
 		sd = &per_cpu(core_domains, i);
 		SD_INIT(sd, MC);
 		set_domain_attribute(sd, attr);
-		sd->span = cpu_coregroup_map(i);
+		sd->span = *cpu_coregroup_mask(i);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
@@ -7525,7 +7525,7 @@ static int __build_sched_domains(const c
 		SCHED_CPUMASK_VAR(this_core_map, allmasks);
 		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
-		*this_core_map = cpu_coregroup_map(i);
+		*this_core_map = *cpu_coregroup_mask(i);
 		cpus_and(*this_core_map, *this_core_map, *cpu_map);
 		if (i != first_cpu(*this_core_map))
 			continue;


