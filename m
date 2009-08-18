Return-Path: <linux-kernel-owner+w=401wt.eu-S1759419AbZHRQxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419AbZHRQxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759232AbZHRQxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:53:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:42271 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932785AbZHRQxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:53:08 -0400
Date: Tue, 18 Aug 2009 16:52:39 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090818105614.GF29515@alberich.amd.com>
References: <20090818105614.GF29515@alberich.amd.com>
Subject: [tip:sched/domains] sched: Separate out build of MC sched domain from __build_sched_domains
Message-ID: <tip-410c408108bb85f32fe132aaf448388af0b6da64@git.kernel.org>
Git-Commit-ID: 410c408108bb85f32fe132aaf448388af0b6da64
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 16:52:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  410c408108bb85f32fe132aaf448388af0b6da64
Gitweb:     http://git.kernel.org/tip/410c408108bb85f32fe132aaf448388af0b6da64
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Tue, 18 Aug 2009 12:56:14 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 18:35:41 +0200

sched: Separate out build of MC sched domain from __build_sched_domains

... to further strip down __build_sched_domains().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090818105614.GF29515@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3d0666c..5c829d4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8529,6 +8529,23 @@ static struct sched_domain *__build_cpu_sched_domain(struct s_data *d,
 	return sd;
 }
 
+static struct sched_domain *__build_mc_sched_domain(struct s_data *d,
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+	struct sched_domain *parent, int i)
+{
+	struct sched_domain *sd = parent;
+#ifdef CONFIG_SCHED_MC
+	sd = &per_cpu(core_domains, i).sd;
+	SD_INIT(sd, MC);
+	set_domain_attribute(sd, attr);
+	cpumask_and(sched_domain_span(sd), cpu_map, cpu_coregroup_mask(i));
+	sd->parent = parent;
+	parent->child = sd;
+	cpu_to_core_group(i, cpu_map, &sd->groups, d->tmpmask);
+#endif
+	return sd;
+}
+
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
@@ -8559,18 +8576,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 
 		sd = __build_numa_sched_domains(&d, cpu_map, attr, i);
 		sd = __build_cpu_sched_domain(&d, cpu_map, attr, sd, i);
-
-#ifdef CONFIG_SCHED_MC
-		p = sd;
-		sd = &per_cpu(core_domains, i).sd;
-		SD_INIT(sd, MC);
-		set_domain_attribute(sd, attr);
-		cpumask_and(sched_domain_span(sd), cpu_map,
-						   cpu_coregroup_mask(i));
-		sd->parent = p;
-		p->child = sd;
-		cpu_to_core_group(i, cpu_map, &sd->groups, d.tmpmask);
-#endif
+		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
 
 #ifdef CONFIG_SCHED_SMT
 		p = sd;
