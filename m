Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbYIKKcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbYIKKcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 06:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYIKKcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 06:32:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61256 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbYIKKcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 06:32:46 -0400
Message-ID: <48C8F32E.2020004@cn.fujitsu.com>
Date: Thu, 11 Sep 2008 18:30:06 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] cgroup,cpuset: use alternative malloc to allocate large
 memory buf for tasks
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new alternative allocation implementation can allocate memory
up to 64M in 32bits system or 512M in 64bits system.

This patch fix the problem for a really large cgroup.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index bb298de..974e898 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -403,6 +403,18 @@ void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it);
 int cgroup_scan_tasks(struct cgroup_scanner *scan);
 int cgroup_attach_task(struct cgroup *, struct task_struct *);
 
+/*
+ * Basic struct of cgroup huge memory allocation,
+ * use typedef to hide its implementation.
+ */
+typedef struct {
+	struct page **page_array;
+	size_t page_count;
+} cgroup_huge_mem_t;
+
+void *cgroup_huge_mem_alloc(size_t size, cgroup_huge_mem_t *huge);
+void cgroup_huge_mem_free(void *ptr, cgroup_huge_mem_t *huge);
+
 #else /* !CONFIG_CGROUPS */
 
 static inline int cgroup_init_early(void) { return 0; }
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 996865a..3ad4ff0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -142,6 +142,55 @@ static int notify_on_release(const struct cgroup *cgrp)
 	return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
 }
 
+#define CGROUP_HUGE_PAGES_THRESHOLD 4
+
+void *cgroup_huge_mem_alloc(size_t size, cgroup_huge_mem_t *huge)
+{
+	unsigned int i, j, n_pages;
+	struct page **pages;
+	void *mem;
+
+	huge->page_array = NULL;
+	huge->page_count = 0;
+	if (size < PAGE_SIZE * CGROUP_HUGE_PAGES_THRESHOLD)
+		return kmalloc(size, GFP_KERNEL);
+
+	n_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	pages = kmalloc(sizeof(*pages) * n_pages, GFP_KERNEL);
+	if (!pages)
+		return NULL;
+
+	for (i = 0; i < n_pages; i++) {
+		pages[i] = alloc_page(GFP_KERNEL);
+		if (unlikely(!pages[i]))
+			goto depopulate;
+	}
+	mem = vmap(pages, n_pages, VM_MAP, PAGE_KERNEL);
+	if (mem) {
+		huge->page_array = pages;
+		huge->page_count = n_pages;
+		return mem;
+	}
+
+depopulate:
+	for (j = 0; j < i; j++)
+		__free_page(pages[j]);
+	kfree(pages);
+	return NULL;
+}
+
+void cgroup_huge_mem_free(void *ptr, cgroup_huge_mem_t *huge)
+{
+	if (huge->page_count) {
+		unsigned int i;
+		vunmap(ptr);
+		for (i = 0; i < huge->page_count; i++)
+			__free_page(huge->page_array[i]);
+		kfree(huge->page_array);
+	} else
+		kfree(ptr);
+}
+
 /*
  * for_each_subsys() allows you to iterate on each subsystem attached to
  * an active hierarchy
@@ -2106,7 +2155,6 @@ static void *cgroup_tasks_start(struct seq_file *s, loff_t *pos)
 	down_read(&cgrp->pids_mutex);
 	if (pid) {
 		int end = cgrp->pids_length;
-		int i;
 		while (index < end) {
 			int mid = (index + end) / 2;
 			if (cgrp->tasks_pids[mid] == pid) {
@@ -2164,12 +2212,35 @@ static struct seq_operations cgroup_tasks_seq_operations = {
 	.show = cgroup_tasks_show,
 };
 
+
+static void *cgroup_pid_array_alloc(size_t size)
+{
+	cgroup_huge_mem_t huge;
+	void *mem = cgroup_huge_mem_alloc(size + sizeof(huge), &huge);
+	if (mem) {
+		*(cgroup_huge_mem_t *)mem = huge;
+		return mem + sizeof(huge);
+	}
+	return NULL;
+}
+
+static void cgroup_pid_array_free(void *ptr)
+{
+	if (ptr) {
+		cgroup_huge_mem_t huge;
+		void *mem = ptr - sizeof(huge);
+
+		huge = *(cgroup_huge_mem_t *)mem;
+		cgroup_huge_mem_free(mem, &huge);
+	}
+}
+
 static void release_cgroup_pid_array(struct cgroup *cgrp)
 {
 	down_write(&cgrp->pids_mutex);
 	BUG_ON(!cgrp->pids_use_count);
 	if (!--cgrp->pids_use_count) {
-		kfree(cgrp->tasks_pids);
+		cgroup_pid_array_free(cgrp->tasks_pids);
 		cgrp->tasks_pids = NULL;
 		cgrp->pids_length = 0;
 	}
@@ -2217,7 +2288,7 @@ static int cgroup_tasks_open(struct inode *unused, struct file *file)
 	 * show up until sometime later on.
 	 */
 	npids = cgroup_task_count(cgrp);
-	pidarray = kmalloc(npids * sizeof(pid_t), GFP_KERNEL);
+	pidarray = cgroup_pid_array_alloc(npids * sizeof(pid_t));
 	if (!pidarray)
 		return -ENOMEM;
 	npids = pid_array_load(pidarray, npids, cgrp);
@@ -2228,7 +2299,7 @@ static int cgroup_tasks_open(struct inode *unused, struct file *file)
 	 * array if necessary
 	 */
 	down_write(&cgrp->pids_mutex);
-	kfree(cgrp->tasks_pids);
+	cgroup_pid_array_free(cgrp->tasks_pids);
 	cgrp->tasks_pids = pidarray;
 	cgrp->pids_length = npids;
 	cgrp->pids_use_count++;
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index f227bc1..38fde1e 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -999,6 +999,7 @@ static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)
 {
 	struct task_struct *p;
 	struct mm_struct **mmarray;
+	cgroup_huge_mem_t huge;
 	int i, n, ntasks;
 	int migrate;
 	int fudge;
@@ -1021,14 +1022,15 @@ static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)
 	while (1) {
 		ntasks = cgroup_task_count(cs->css.cgroup);  /* guess */
 		ntasks += fudge;
-		mmarray = kmalloc(ntasks * sizeof(*mmarray), GFP_KERNEL);
+		mmarray = cgroup_huge_mem_alloc(ntasks * sizeof(*mmarray),
+				&huge);
 		if (!mmarray)
 			goto done;
 		read_lock(&tasklist_lock);		/* block fork */
 		if (cgroup_task_count(cs->css.cgroup) <= ntasks)
 			break;				/* got enough */
 		read_unlock(&tasklist_lock);		/* try again */
-		kfree(mmarray);
+		cgroup_huge_mem_free(mmarray, &huge);
 	}
 
 	n = 0;
@@ -1075,7 +1077,7 @@ static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)
 	}
 
 	/* We're done rebinding vmas to this cpuset's new mems_allowed. */
-	kfree(mmarray);
+	cgroup_huge_mem_free(mmarray, &huge);
 	cpuset_being_rebound = NULL;
 	retval = 0;
 done:

