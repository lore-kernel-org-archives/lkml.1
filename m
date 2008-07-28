Return-Path: <linux-kernel-owner+w=401wt.eu-S1759902AbYG1Cx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902AbYG1Cx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 22:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758615AbYG1CxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 22:53:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53780 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757966AbYG1CxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 22:53:23 -0400
Message-ID: <488D332A.1030008@cn.fujitsu.com>
Date: Mon, 28 Jul 2008 10:47:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] cpuset: clean up cpuset hierarchy traversal code
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cpuset.stack_list rather than kfifo, so we avoid memory allocation
for kfifo.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/cpuset.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3624dc0..d0c57ac 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -54,7 +54,6 @@
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
 #include <linux/mutex.h>
-#include <linux/kfifo.h>
 #include <linux/workqueue.h>
 #include <linux/cgroup.h>
 
@@ -532,7 +531,7 @@ update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
  * So the reverse nesting would risk an ABBA deadlock.
  *
  * The three key local variables below are:
- *    q  - a kfifo queue of cpuset pointers, used to implement a
+ *    q  - a linked-list queue of cpuset pointers, used to implement a
  *	   top-down scan of all cpusets.  This scan loads a pointer
  *	   to each cpuset marked is_sched_load_balance into the
  *	   array 'csa'.  For our purposes, rebuilding the schedulers
@@ -567,7 +566,7 @@ update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
 
 void rebuild_sched_domains(void)
 {
-	struct kfifo *q;	/* queue of cpusets to be scanned */
+	LIST_HEAD(q);		/* queue of cpusets to be scanned*/
 	struct cpuset *cp;	/* scans q */
 	struct cpuset **csa;	/* array of all cpuset ptrs */
 	int csn;		/* how many cpuset ptrs in csa so far */
@@ -577,7 +576,6 @@ void rebuild_sched_domains(void)
 	int ndoms;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] cpumask_t slot */
 
-	q = NULL;
 	csa = NULL;
 	doms = NULL;
 	dattr = NULL;
@@ -597,20 +595,19 @@ void rebuild_sched_domains(void)
 		goto rebuild;
 	}
 
-	q = kfifo_alloc(number_of_cpusets * sizeof(cp), GFP_KERNEL, NULL);
-	if (IS_ERR(q))
-		goto done;
 	csa = kmalloc(number_of_cpusets * sizeof(cp), GFP_KERNEL);
 	if (!csa)
 		goto done;
 	csn = 0;
 
-	cp = &top_cpuset;
-	__kfifo_put(q, (void *)&cp, sizeof(cp));
-	while (__kfifo_get(q, (void *)&cp, sizeof(cp))) {
+	list_add(&top_cpuset.stack_list, &q);
+	while (!list_empty(&q)) {
 		struct cgroup *cont;
 		struct cpuset *child;   /* scans child cpusets of cp */
 
+		cp = list_first_entry(&q, struct cpuset, stack_list);
+		list_del(q.next);
+
 		if (cpus_empty(cp->cpus_allowed))
 			continue;
 
@@ -619,7 +616,7 @@ void rebuild_sched_domains(void)
 
 		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
 			child = cgroup_cs(cont);
-			__kfifo_put(q, (void *)&child, sizeof(cp));
+			list_add_tail(&child->stack_list, &q);
 		}
   	}
 
@@ -702,8 +699,6 @@ rebuild:
 	put_online_cpus();
 
 done:
-	if (q && !IS_ERR(q))
-		kfifo_free(q);
 	kfree(csa);
 	/* Don't kfree(doms) -- partition_sched_domains() does that. */
 	/* Don't kfree(dattr) -- partition_sched_domains() does that. */
-- 
1.5.4.rc3
