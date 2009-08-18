Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbZHRK4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbZHRK4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbZHRK4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:56:00 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:41884 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754266AbZHRKz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:55:59 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMzz1202hzzz32i6bh203h63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KOKJNK-02-69Z-02
X-M-MSG: 
Date: Tue, 18 Aug 2009 12:54:55 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] sched: Seperate out build of CPU sched domain from
	__build_sched_domains
Message-ID: <20090818105455.GE29515@alberich.amd.com>
References: <20090818104944.GA29515@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090818104944.GA29515@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Aug 2009 10:54:56.0267 (UTC) FILETIME=[52A67DB0:01CA1FF2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... to further strip down __build_sched_domains().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 kernel/sched.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e696cd9..a2e09f4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8619,6 +8619,22 @@ static struct sched_domain *__build_numa_sched_domains(struct s_data *d,
 	return sd;
 }
 
+static struct sched_domain *__build_cpu_sched_domain(struct s_data *d,
+	const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+	struct sched_domain *parent, int i)
+{
+	struct sched_domain *sd;
+	sd = &per_cpu(phys_domains, i).sd;
+	SD_INIT(sd, CPU);
+	set_domain_attribute(sd, attr);
+	cpumask_copy(sched_domain_span(sd), d->nodemask);
+	sd->parent = parent;
+	if (parent)
+		parent->child = sd;
+	cpu_to_phys_group(i, cpu_map, &sd->groups, d->tmpmask);
+	return sd;
+}
+
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
@@ -8648,15 +8664,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 			    cpu_map);
 
 		sd = __build_numa_sched_domains(&d, cpu_map, attr, i);
-		p = sd;
-		sd = &per_cpu(phys_domains, i).sd;
-		SD_INIT(sd, CPU);
-		set_domain_attribute(sd, attr);
-		cpumask_copy(sched_domain_span(sd), d.nodemask);
-		sd->parent = p;
-		if (p)
-			p->child = sd;
-		cpu_to_phys_group(i, cpu_map, &sd->groups, d.tmpmask);
+		sd = __build_cpu_sched_domain(&d, cpu_map, attr, sd, i);
 
 #ifdef CONFIG_SCHED_MC
 		p = sd;
-- 
1.6.4



