Return-Path: <linux-kernel-owner+w=401wt.eu-S1759759AbYG1Cxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759759AbYG1Cxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 22:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbYG1CxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 22:53:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63676 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756474AbYG1CxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 22:53:20 -0400
Message-ID: <488D332D.3000501@cn.fujitsu.com>
Date: Mon, 28 Jul 2008 10:47:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] cpuset: speed up sched domain partition
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Mon, 28 Jul 2008 10:38:22 +0800
Subject: [PATCH 2/3] cpuset: speed up sched domain partition

All child cpusets contain a subset of the parent's cpus, so we can skip
them when partitioning sched domains. This decreases 'csa' greately for
cpusets with multi-level hierarchy.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |   41 +++++++++++++++++++++++++++++++++++++----
 1 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index d0c57ac..d274a94 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -485,13 +485,38 @@ static int cpusets_overlap(struct cpuset *a, struct cpuset *b)
 static void
 update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
 {
-	if (!dattr)
-		return;
 	if (dattr->relax_domain_level < c->relax_domain_level)
 		dattr->relax_domain_level = c->relax_domain_level;
 	return;
 }
 
+static void
+update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
+{
+	LIST_HEAD(q);
+
+	list_add(&c->stack_list, &q);
+	while (!list_empty(&q)) {
+		struct cpuset *cp;
+		struct cgroup *cont;
+		struct cpuset *child;
+
+		cp = list_first_entry(&q, struct cpuset, stack_list);
+		list_del(q.next);
+
+		if (cpus_empty(cp->cpus_allowed))
+			continue;
+
+		if (is_sched_load_balance(cp))
+			update_domain_attr(dattr, cp);
+
+		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
+			child = cgroup_cs(cont);
+			list_add_tail(&child->stack_list, &q);
+		}
+	}
+}
+
 /*
  * rebuild_sched_domains()
  *
@@ -611,8 +636,16 @@ void rebuild_sched_domains(void)
 		if (cpus_empty(cp->cpus_allowed))
 			continue;
 
-		if (is_sched_load_balance(cp))
+		/*
+		 * All child cpusets contain a subset of the parent's cpus, so
+		 * just skip them, and then we call update_domain_attr_tree()
+		 * to calc relax_domain_level of the corresponding sched
+		 * domain.
+		 */
+		if (is_sched_load_balance(cp)) {
 			csa[csn++] = cp;
+			continue;
+		}
 
 		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
 			child = cgroup_cs(cont);
@@ -683,7 +716,7 @@ restart:
 					cpus_or(*dp, *dp, b->cpus_allowed);
 					b->pn = -1;
 					if (dattr)
-						update_domain_attr(dattr
+						update_domain_attr_tree(dattr
 								   + nslot, b);
 				}
 			}
-- 
1.5.4.rc3
