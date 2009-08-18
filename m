Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbZHRQx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbZHRQx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759478AbZHRQx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:53:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:42322 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759476AbZHRQxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:53:55 -0400
Date: Tue, 18 Aug 2009 16:53:16 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090818105838.GI29515@alberich.amd.com>
References: <20090818105838.GI29515@alberich.amd.com>
Subject: [tip:sched/domains] sched: Separate out build of MC sched groups from __build_sched_domains
Message-ID: <tip-a2af04cdbb748158043e31799b28c48272081600@git.kernel.org>
Git-Commit-ID: a2af04cdbb748158043e31799b28c48272081600
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 16:53:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2af04cdbb748158043e31799b28c48272081600
Gitweb:     http://git.kernel.org/tip/a2af04cdbb748158043e31799b28c48272081600
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Tue, 18 Aug 2009 12:58:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 18:35:43 +0200

sched: Separate out build of MC sched groups from __build_sched_domains

... to further strip down __build_sched_domains().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090818105838.GI29515@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 43cfc6e..f2c202f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8577,6 +8577,15 @@ static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
 						d->send_covered, d->tmpmask);
 		break;
 #endif
+#ifdef CONFIG_SCHED_MC
+	case SD_LV_MC: /* set up multi-core groups */
+		cpumask_and(d->this_core_map, cpu_map, cpu_coregroup_mask(cpu));
+		if (cpu == cpumask_first(d->this_core_map))
+			init_sched_build_groups(d->this_core_map, cpu_map,
+						&cpu_to_core_group,
+						d->send_covered, d->tmpmask);
+		break;
+#endif
 	default:
 		break;
 	}
@@ -8618,21 +8627,9 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
 	for_each_cpu(i, cpu_map) {
 		build_sched_groups(&d, SD_LV_SIBLING, cpu_map, i);
+		build_sched_groups(&d, SD_LV_MC, cpu_map, i);
 	}
 
-#ifdef CONFIG_SCHED_MC
-	/* Set up multi-core groups */
-	for_each_cpu(i, cpu_map) {
-		cpumask_and(d.this_core_map, cpu_coregroup_mask(i), cpu_map);
-		if (i != cpumask_first(d.this_core_map))
-			continue;
-
-		init_sched_build_groups(d.this_core_map, cpu_map,
-					&cpu_to_core_group,
-					d.send_covered, d.tmpmask);
-	}
-#endif
-
 	/* Set up physical groups */
 	for (i = 0; i < nr_node_ids; i++) {
 		cpumask_and(d.nodemask, cpumask_of_node(i), cpu_map);
