Return-Path: <linux-kernel-owner+w=401wt.eu-S933349AbYEVHcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349AbYEVHcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 03:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758048AbYEVHcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 03:32:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51925 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754795AbYEVHcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 03:32:16 -0400
Message-ID: <48352127.20804@cn.fujitsu.com>
Date: Thu, 22 May 2008 15:30:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] remove unnecessary memmove() in cgroup_path()
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memmove() is unnecessary in cgroup_path(), the following patch will remove it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e155aa7..6efa4a0 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -281,7 +281,7 @@ int cgroup_add_files(struct cgroup *cgrp,
 
 int cgroup_is_removed(const struct cgroup *cgrp);
 
-int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
+int cgroup_path(const struct cgroup *cgrp, char **buf, int buflen);
 
 int cgroup_task_count(const struct cgroup *cgrp);
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index fbc6fc8..db65898 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1151,13 +1151,14 @@ static inline struct cftype *__d_cft(struct dentry *dentry)
 /**
  * cgroup_path - generate the path of a cgroup
  * @cgrp: the cgroup in question
- * @buf: the buffer to write the path into
+ * @buf: *buf is the buffer to write the path into, and it was set
+ *       to the start of the path when return
  * @buflen: the length of the buffer
  *
  * Called with cgroup_mutex held. Writes path of cgroup into buf.
  * Returns 0 on success, -errno on error.
  */
-int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
+int cgroup_path(const struct cgroup *cgrp, char **buf, int buflen)
 {
 	char *start;
 
@@ -1166,16 +1167,16 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 		 * Inactive subsystems have no dentry for their root
 		 * cgroup
 		 */
-		strcpy(buf, "/");
+		strcpy(*buf, "/");
 		return 0;
 	}
 
-	start = buf + buflen;
+	start = *buf + buflen;
 
 	*--start = '\0';
 	for (;;) {
 		int len = cgrp->dentry->d_name.len;
-		if ((start -= len) < buf)
+		if ((start -= len) < *buf)
 			return -ENAMETOOLONG;
 		memcpy(start, cgrp->dentry->d_name.name, len);
 		cgrp = cgrp->parent;
@@ -1183,11 +1184,11 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 			break;
 		if (!cgrp->parent)
 			continue;
-		if (--start < buf)
+		if (--start < *buf)
 			return -ENAMETOOLONG;
 		*start = '/';
 	}
-	memmove(buf, start, buf + buflen - start);
+	*buf = start;
 	return 0;
 }
 
@@ -2637,6 +2638,7 @@ static int proc_cgroup_show(struct seq_file *m, void *v)
 		struct cgroup *cgrp;
 		int subsys_id;
 		int count = 0;
+		char *path = buf;
 
 		/* Skip this hierarchy if it has no active subsystems */
 		if (!root->actual_subsys_bits)
@@ -2647,10 +2649,10 @@ static int proc_cgroup_show(struct seq_file *m, void *v)
 		seq_putc(m, ':');
 		get_first_subsys(&root->top_cgroup, NULL, &subsys_id);
 		cgrp = task_cgroup(tsk, subsys_id);
-		retval = cgroup_path(cgrp, buf, PAGE_SIZE);
+		retval = cgroup_path(cgrp, &path, PAGE_SIZE);
 		if (retval < 0)
 			goto out_unlock;
-		seq_puts(m, buf);
+		seq_puts(m, path);
 		seq_putc(m, '\n');
 	}
 
@@ -3078,19 +3080,19 @@ static void cgroup_release_agent(struct work_struct *work)
 	while (!list_empty(&release_list)) {
 		char *argv[3], *envp[3];
 		int i;
-		char *pathbuf;
+		char *pathbuf, *path;
 		struct cgroup *cgrp = list_entry(release_list.next,
 						    struct cgroup,
 						    release_list);
 		list_del_init(&cgrp->release_list);
 		spin_unlock(&release_list_lock);
-		pathbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		pathbuf = path = kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!pathbuf) {
 			spin_lock(&release_list_lock);
 			continue;
 		}
 
-		if (cgroup_path(cgrp, pathbuf, PAGE_SIZE) < 0) {
+		if (cgroup_path(cgrp, &path, PAGE_SIZE) < 0) {
 			kfree(pathbuf);
 			spin_lock(&release_list_lock);
 			continue;
@@ -3098,7 +3100,7 @@ static void cgroup_release_agent(struct work_struct *work)
 
 		i = 0;
 		argv[i++] = cgrp->root->release_agent_path;
-		argv[i++] = (char *)pathbuf;
+		argv[i++] = path;
 		argv[i] = NULL;
 
 		i = 0;
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 86ea9e3..59ff9cb 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2290,12 +2290,12 @@ static int proc_cpuset_show(struct seq_file *m, void *unused_v)
 {
 	struct pid *pid;
 	struct task_struct *tsk;
-	char *buf;
+	char *buf, *path;
 	struct cgroup_subsys_state *css;
 	int retval;
 
 	retval = -ENOMEM;
-	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	buf = path = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!buf)
 		goto out;
 
@@ -2308,10 +2308,10 @@ static int proc_cpuset_show(struct seq_file *m, void *unused_v)
 	retval = -EINVAL;
 	cgroup_lock();
 	css = task_subsys_state(tsk, cpuset_subsys_id);
-	retval = cgroup_path(css->cgroup, buf, PAGE_SIZE);
+	retval = cgroup_path(css->cgroup, &path, PAGE_SIZE);
 	if (retval < 0)
 		goto out_unlock;
-	seq_puts(m, buf);
+	seq_puts(m, path);
 	seq_putc(m, '\n');
 out_unlock:
 	cgroup_unlock();
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 5f06118..4fe01b2 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -78,9 +78,10 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
 
 #ifdef CONFIG_CGROUP_SCHED
 	{
-		char path[64];
+		char buf[64];
+		char *path = buf;
 
-		cgroup_path(task_group(p)->css.cgroup, path, sizeof(path));
+		cgroup_path(task_group(p)->css.cgroup, &path, sizeof(buf));
 		SEQ_printf(m, " %s", path);
 	}
 #endif
@@ -122,7 +123,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 #if !defined(CONFIG_CGROUP_SCHED) || !defined(CONFIG_USER_SCHED)
 	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
 #else
-	char path[128] = "";
+	char buf[128] = "";
+	char *path = buf;
 	struct cgroup *cgroup = NULL;
 	struct task_group *tg = cfs_rq->tg;
 
@@ -130,7 +132,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 		cgroup = tg->css.cgroup;
 
 	if (cgroup)
-		cgroup_path(cgroup, path, sizeof(path));
+		cgroup_path(cgroup, &path, sizeof(buf));
 
 	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
 #endif

