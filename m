Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbZGCC5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbZGCC5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZGCC5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:57:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62278 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbZGCC5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:57:17 -0400
Message-ID: <4A4D73C5.9000305@cn.fujitsu.com>
Date: Fri, 03 Jul 2009 10:58:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Benjamin Blum <bblum@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH v2] cgroups: fix pid namespace bug, fix
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add get_pid_ns()/put_pid_ns()
- remove prefix "pids_"

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 13dddb4..250dac0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2213,13 +2213,13 @@ struct cgroup_pids {
 	/* The cgroup those pids belong to */
 	struct cgroup *cgrp;
 	/* The namepsace those pids belong to */
-	struct pid_namespace *pid_ns;
+	struct pid_namespace *ns;
 	/* Array of process ids in the cgroup */
 	pid_t *tasks_pids;
 	/* How many files are using the this tasks_pids array */
-	int pids_use_count;
+	int use_count;
 	/* Length of the current tasks_pids array */
-	int pids_length;
+	int length;
 };
 
 static int cmppid(const void *a, const void *b)
@@ -2248,7 +2248,7 @@ static void *cgroup_tasks_start(struct seq_file *s, loff_t *pos)
 
 	down_read(&cgrp->pids_mutex);
 	if (pid) {
-		int end = cp->pids_length;
+		int end = cp->length;
 
 		while (index < end) {
 			int mid = (index + end) / 2;
@@ -2262,7 +2262,7 @@ static void *cgroup_tasks_start(struct seq_file *s, loff_t *pos)
 		}
 	}
 	/* If we're off the end of the array, we're done */
-	if (index >= cp->pids_length)
+	if (index >= cp->length)
 		return NULL;
 	/* Update the abstract position to be the actual pid that we found */
 	iter = cp->tasks_pids + index;
@@ -2281,7 +2281,7 @@ static void *cgroup_tasks_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct cgroup_pids *cp = s->private;
 	int *p = v;
-	int *end = cp->tasks_pids + cp->pids_length;
+	int *end = cp->tasks_pids + cp->length;
 
 	/*
 	 * Advance to the next pid in the array. If this goes off the
@@ -2313,9 +2313,10 @@ static void release_cgroup_pid_array(struct cgroup_pids *cp)
 	struct cgroup *cgrp = cp->cgrp;
 
 	down_write(&cgrp->pids_mutex);
-	BUG_ON(!cp->pids_use_count);
-	if (!--cp->pids_use_count) {
+	BUG_ON(!cp->use_count);
+	if (!--cp->use_count) {
 		list_del(&cp->list);
+		put_pid_ns(cp->ns);
 		kfree(cp->tasks_pids);
 		kfree(cp);
 	}
@@ -2352,7 +2353,7 @@ static struct file_operations cgroup_tasks_operations = {
 static int cgroup_tasks_open(struct inode *unused, struct file *file)
 {
 	struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
-	struct pid_namespace *pid_ns = task_active_pid_ns(current);
+	struct pid_namespace *ns = current->nsproxy->pid_ns;
 	struct cgroup_pids *cp;
 	pid_t *pidarray;
 	int npids;
@@ -2382,7 +2383,7 @@ static int cgroup_tasks_open(struct inode *unused, struct file *file)
 	down_write(&cgrp->pids_mutex);
 
 	list_for_each_entry(cp, &cgrp->pids_list, list) {
-		if (pid_ns == cp->pid_ns)
+		if (ns == cp->ns)
 			goto found;
 	}
 
@@ -2393,13 +2394,14 @@ static int cgroup_tasks_open(struct inode *unused, struct file *file)
 		return -ENOMEM;
 	}
 	cp->cgrp = cgrp;
-	cp->pid_ns = pid_ns;
+	cp->ns = ns;
+	get_pid_ns(ns);
 	list_add(&cp->list, &cgrp->pids_list);
 found:
 	kfree(cp->tasks_pids);
 	cp->tasks_pids = pidarray;
-	cp->pids_length = npids;
-	cp->pids_use_count++;
+	cp->length = npids;
+	cp->use_count++;
 	up_write(&cgrp->pids_mutex);
 
 	file->f_op = &cgroup_tasks_operations;
-- 
1.5.4.rc3

