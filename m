Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYG1Cx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYG1Cx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 22:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbYG1CxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 22:53:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55755 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbYG1CxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 22:53:19 -0400
Message-ID: <488D3325.8030203@cn.fujitsu.com>
Date: Mon, 28 Jul 2008 10:47:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Jackson <pj@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpuset: a bit cleanup for scan_for_empty_cpusets()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean up hierarchy traversal code

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 91cf85b..3624dc0 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1833,24 +1833,21 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
  */
 static void scan_for_empty_cpusets(const struct cpuset *root)
 {
+	LIST_HEAD(queue);
 	struct cpuset *cp;	/* scans cpusets being updated */
 	struct cpuset *child;	/* scans child cpusets of cp */
-	struct list_head queue;
 	struct cgroup *cont;
 	nodemask_t oldmems;
 
-	INIT_LIST_HEAD(&queue);
-
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
 	while (!list_empty(&queue)) {
-		cp = container_of(queue.next, struct cpuset, stack_list);
+		cp = list_first_entry(&queue, struct cpuset, stack_list);
 		list_del(queue.next);
 		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
 			child = cgroup_cs(cont);
 			list_add_tail(&child->stack_list, &queue);
 		}
-		cont = cp->css.cgroup;
 
 		/* Continue past cpusets with all cpus, mems online */
 		if (cpus_subset(cp->cpus_allowed, cpu_online_map) &&
-- 
1.5.4.rc3
