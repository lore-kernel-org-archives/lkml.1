Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbZHRQyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbZHRQyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbZHRQyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:54:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:42344 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759491AbZHRQyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:54:12 -0400
Date: Tue, 18 Aug 2009 16:53:28 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090818105928.GJ29515@alberich.amd.com>
References: <20090818105928.GJ29515@alberich.amd.com>
Subject: [tip:sched/domains] sched: Separate out build of CPU sched groups from __build_sched_domains
Message-ID: <tip-86548096f252bfe2065f1ea2d301e7319a16375d@git.kernel.org>
Git-Commit-ID: 86548096f252bfe2065f1ea2d301e7319a16375d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 16:53:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  86548096f252bfe2065f1ea2d301e7319a16375d
Gitweb:     http://git.kernel.org/tip/86548096f252bfe2065f1ea2d301e7319a16375d
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Tue, 18 Aug 2009 12:59:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 18:35:43 +0200

sched: Separate out build of CPU sched groups from __build_sched_domains

... to further strip down __build_sched_domains().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090818105928.GJ29515@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f2c202f..b09a41c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8586,6 +8586,13 @@ static void build_sched_groups(struct s_data *d, enum sched_domain_level l,
 						d->send_covered, d->tmpmask);
 		break;
 #endif
+	case SD_LV_CPU: /* set up physical groups */
+		cpumask_and(d->nodemask, cpumask_of_node(cpu), cpu_map);
+		if (!cpumask_empty(d->nodemask))
+			init_sched_build_groups(d->nodemask, cpu_map,
+						&cpu_to_phys_group,
+						d->send_covered, d->tmpmask);
+		break;
 	default:
 		break;
 	}
@@ -8631,15 +8638,8 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	}
 
 	/* Set up physical groups */
-	for (i = 0; i < nr_node_ids; i++) {
-		cpumask_and(d.nodemask, cpumask_of_node(i), cpu_map);
-		if (cpumask_empty(d.nodemask))
-			continue;
-
-		init_sched_build_groups(d.nodemask, cpu_map,
-					&cpu_to_phys_group,
-					d.send_covered, d.tmpmask);
-	}
+	for (i = 0; i < nr_node_ids; i++)
+		build_sched_groups(&d, SD_LV_CPU, cpu_map, i);
 
 #ifdef CONFIG_NUMA
 	/* Set up node groups */
