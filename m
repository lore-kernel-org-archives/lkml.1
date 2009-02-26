Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbZBZHE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbZBZHE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 02:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbZBZHEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 02:04:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61484 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbZBZHEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 02:04:08 -0500
Message-ID: <49A63EFB.8070701@cn.fujitsu.com>
Date: Thu, 26 Feb 2009 15:04:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] cpuset: remove struct cpuset_hotplug_scanner
References: <49A63E77.9060603@cn.fujitsu.com>
In-Reply-To: <49A63E77.9060603@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cgroup_scanner.data, instead of introducing cpuset_hotplug_scanner.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3202364..a46d693 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -128,10 +128,6 @@ static inline struct cpuset *task_cs(struct task_struct *task)
 	return container_of(task_subsys_state(task, cpuset_subsys_id),
 			    struct cpuset, css);
 }
-struct cpuset_hotplug_scanner {
-	struct cgroup_scanner scan;
-	struct cgroup *to;
-};
 
 /* bits in struct cpuset flags field */
 typedef enum {
@@ -1889,10 +1885,9 @@ int __init cpuset_init(void)
 static void cpuset_do_move_task(struct task_struct *tsk,
 				struct cgroup_scanner *scan)
 {
-	struct cpuset_hotplug_scanner *chsp;
+	struct cgroup *new_cgroup = scan->data;
 
-	chsp = container_of(scan, struct cpuset_hotplug_scanner, scan);
-	cgroup_attach_task(chsp->to, tsk);
+	cgroup_attach_task(new_cgroup, tsk);
 }
 
 /**
@@ -1908,15 +1903,15 @@ static void cpuset_do_move_task(struct task_struct *tsk,
  */
 static void move_member_tasks_to_cpuset(struct cpuset *from, struct cpuset *to)
 {
-	struct cpuset_hotplug_scanner scan;
+	struct cgroup_scanner scan;
 
-	scan.scan.cg = from->css.cgroup;
-	scan.scan.test_task = NULL; /* select all tasks in cgroup */
-	scan.scan.process_task = cpuset_do_move_task;
-	scan.scan.heap = NULL;
-	scan.to = to->css.cgroup;
+	scan.cg = from->css.cgroup;
+	scan.test_task = NULL; /* select all tasks in cgroup */
+	scan.process_task = cpuset_do_move_task;
+	scan.heap = NULL;
+	scan.data = to->css.cgroup;
 
-	if (cgroup_scan_tasks(&scan.scan))
+	if (cgroup_scan_tasks(&scan))
 		printk(KERN_ERR "move_member_tasks_to_cpuset: "
 				"cgroup_scan_tasks failed\n");
 }
-- 1.5.4.rc3 
