Return-Path: <linux-kernel-owner+w=401wt.eu-S932780AbZHRQxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbZHRQxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932756AbZHRQxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:53:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:42254 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717AbZHRQw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:52:59 -0400
Date: Tue, 18 Aug 2009 16:52:26 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090818105455.GE29515@alberich.amd.com>
References: <20090818105455.GE29515@alberich.amd.com>
Subject: [tip:sched/domains] sched: Separate out build of CPU sched domain from __build_sched_domains
Message-ID: <tip-87cce6622c2ab2f0e96ecc2a37133378a7db3177@git.kernel.org>
Git-Commit-ID: 87cce6622c2ab2f0e96ecc2a37133378a7db3177
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 16:52:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  87cce6622c2ab2f0e96ecc2a37133378a7db3177
Gitweb:     http://git.kernel.org/tip/87cce6622c2ab2f0e96ecc2a37133378a7db3177
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Tue, 18 Aug 2009 12:54:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 18:35:40 +0200

sched: Separate out build of CPU sched domain from __build_sched_domains

... to further strip down __build_sched_domains().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20090818105455.GE29515@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dd95a47..3d0666c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8513,6 +8513,22 @@ static struct sched_domain *__build_numa_sched_domains(struct s_data *d,
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
@@ -8542,15 +8558,7 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
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
