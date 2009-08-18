Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbZHRQxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbZHRQxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759232AbZHRQxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:53:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:42298 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759447AbZHRQxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:53:36 -0400
Date: Tue, 18 Aug 2009 16:53:04 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090818105751.GH29515@alberich.amd.com>
References: <20090818105751.GH29515@alberich.amd.com>
Subject: [tip:sched/domains] sched: Separate out build of SMT sched groups from __build_sched_domains
Message-ID: <tip-0e8e85c941d8f1b43bcc2e3b8b7026cdae476c53@git.kernel.org>
Git-Commit-ID: 0e8e85c941d8f1b43bcc2e3b8b7026cdae476c53
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 16:53:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e8e85c941d8f1b43bcc2e3b8b7026cdae476c53
Gitweb:     http://git.kernel.org/tip/0e8e85c941d8f1b43bcc2e3b8b7026cdae476c53
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Tue, 18 Aug 2009 12:57:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 18:35:42 +0200

sched: Separate out build of SMT sched groups from __build_sched_domains

... to further strip down __build_sched_domains().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090818105751.GH29515@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 2ecec06..43cfc6e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8563,6 +8563,25 @@ static struct sched_domain *__build_smt_sched_domain(struct s_data *d,
 	return sd;
 }
 
+static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
+			       const struct cpumask *cpu_map, int cpu)
+{
+	switch (l) {
+#ifdef CONFIG_SCHED_SMT
+	case SD_LV_SIBLING: /* set up CPU (sibling) groups */
+		cpumask_and(d->this_sibling_map, cpu_map,
+			    topology_thread_cpumask(cpu));
+		if (cpu == cpumask_first(d->this_sibling_map))
+			init_sched_build_groups(d->this_sibling_map, cpu_map,
+						&cpu_to_cpu_group,
+						d->send_covered, d->tmpmask);
+		break;
+#endif
+	default:
+		break;
+	}
+}
+
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
@@ -8597,19 +8616,9 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
 	}
 
-#ifdef CONFIG_SCHED_SMT
-	/* Set up CPU (sibling) groups */
 	for_each_cpu(i, cpu_map) {
-		cpumask_and(d.this_sibling_map,
-			    topology_thread_cpumask(i), cpu_map);
-		if (i != cpumask_first(d.this_sibling_map))
-			continue;
-
-		init_sched_build_groups(d.this_sibling_map, cpu_map,
-					&cpu_to_cpu_group,
-					d.send_covered, d.tmpmask);
+		build_sched_groups(&d, SD_LV_SIBLING, cpu_map, i);
 	}
-#endif
 
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
