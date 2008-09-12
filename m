Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbYILL60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbYILL60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 07:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYILL54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 07:57:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55359 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbYILL5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 07:57:55 -0400
Message-ID: <48CA58A9.4010508@cn.fujitsu.com>
Date: Fri, 12 Sep 2008 19:55:21 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 2/2] cgroup: use multibuf for tasks file
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when we open a really large cgroup for read, we may failed
for kmalloc() is not reliable for allocate a big buffer.

the patch use multibuf for tasks file, every buf is a page
apart from we need only a small buffer.

we use obj_sort() to sort this pids, so we don't need to map this
pages to an continuous memory region.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index bb298de..3d3c3bb 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -141,8 +141,8 @@ struct cgroup {
 
 	/* pids_mutex protects the fields below */
 	struct rw_semaphore pids_mutex;
-	/* Array of process ids in the cgroup */
-	pid_t *tasks_pids;
+	/* Multi-array of process ids in the cgroup */
+	const pid_t *const *tasks_pids;
 	/* How many files are using the current tasks_pids array */
 	int pids_use_count;
 	/* Length of the current tasks_pids array */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 996865a..f61b152 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2004,6 +2004,8 @@ int cgroup_scan_tasks(struct cgroup_scanner *scan)
  *
  */
 
+const static int pid_per_page = PAGE_SIZE / sizeof(pid_t);
+
 /*
  * Load into 'pidarray' up to 'npids' of the tasks using cgroup
  * 'cgrp'.  Return actual number of pids loaded.  No need to
@@ -2011,16 +2013,22 @@ int cgroup_scan_tasks(struct cgroup_scanner *scan)
  * read section, so the css_set can't go away, and is
  * immutable after creation.
  */
-static int pid_array_load(pid_t *pidarray, int npids, struct cgroup *cgrp)
+static int pid_array_load(pid_t **pidarray, int npids, struct cgroup *cgrp)
 {
-	int n = 0;
+	int n = 0, i = 0, j = 0;
 	struct cgroup_iter it;
 	struct task_struct *tsk;
 	cgroup_iter_start(cgrp, &it);
 	while ((tsk = cgroup_iter_next(cgrp, &it))) {
 		if (unlikely(n == npids))
 			break;
-		pidarray[n++] = task_pid_vnr(tsk);
+		pidarray[i][j] = task_pid_vnr(tsk);
+		n++;
+		j++;
+		if (j == pid_per_page) {
+			i++;
+			j = 0;
+		}
 	}
 	cgroup_iter_end(cgrp, &it);
 	return n;
@@ -2079,11 +2087,27 @@ err:
 	return ret;
 }
 
-static int cmppid(const void *a, const void *b)
+static inline pid_t getpidofmbuf(const pid_t *const *multibuf, int index)
+{
+	return multibuf[index / pid_per_page][index % pid_per_page];
+}
+
+static int cmppid(const void *c, size_t left, size_t right)
 {
-	return *(pid_t *)a - *(pid_t *)b;
+	return getpidofmbuf(c, left) - getpidofmbuf(c, right);
 }
 
+static inline pid_t *getpidptr(pid_t *const *multibuf, int index)
+{
+	return &multibuf[index / pid_per_page][index % pid_per_page];
+}
+
+static void swappid(void *c, size_t left, size_t right)
+{
+	pid_t rpid = getpidofmbuf(c, right);
+	*getpidptr(c, right) = getpidofmbuf(c, left);
+	*getpidptr(c, left) = rpid;
+}
 
 /*
  * seq_file methods for the "tasks" file. The seq_file position is the
@@ -2100,19 +2124,19 @@ static void *cgroup_tasks_start(struct seq_file *s, loff_t *pos)
 	 * next pid to display, if any
 	 */
 	struct cgroup *cgrp = s->private;
-	int index = 0, pid = *pos;
-	int *iter;
+	int index = 0;
+	pid_t pid = *pos;
 
 	down_read(&cgrp->pids_mutex);
 	if (pid) {
 		int end = cgrp->pids_length;
-		int i;
 		while (index < end) {
 			int mid = (index + end) / 2;
-			if (cgrp->tasks_pids[mid] == pid) {
+			pid_t mpid = getpidofmbuf(cgrp->tasks_pids, mid);
+			if (mpid == pid) {
 				index = mid;
 				break;
-			} else if (cgrp->tasks_pids[mid] <= pid)
+			} else if (mpid <= pid)
 				index = mid + 1;
 			else
 				end = mid;
@@ -2122,9 +2146,8 @@ static void *cgroup_tasks_start(struct seq_file *s, loff_t *pos)
 	if (index >= cgrp->pids_length)
 		return NULL;
 	/* Update the abstract position to be the actual pid that we found */
-	iter = cgrp->tasks_pids + index;
-	*pos = *iter;
-	return iter;
+	*pos = getpidofmbuf(cgrp->tasks_pids, index);
+	return (void *)(index ^ -0x10000); /* we cannot return 0 */
 }
 
 static void cgroup_tasks_stop(struct seq_file *s, void *v)
@@ -2136,25 +2159,26 @@ static void cgroup_tasks_stop(struct seq_file *s, void *v)
 static void *cgroup_tasks_next(struct seq_file *s, void *v, loff_t *pos)
 {
 	struct cgroup *cgrp = s->private;
-	int *p = v;
-	int *end = cgrp->tasks_pids + cgrp->pids_length;
+	int index = (int)v ^ -0x10000;
 
 	/*
 	 * Advance to the next pid in the array. If this goes off the
 	 * end, we're done
 	 */
-	p++;
-	if (p >= end) {
+	index++;
+	if (index >= cgrp->pids_length) {
 		return NULL;
 	} else {
-		*pos = *p;
-		return p;
+		*pos = getpidofmbuf(cgrp->tasks_pids, index);
+		return (void *)(index ^ -0x10000); /* we cannot return 0 */
 	}
 }
 
 static int cgroup_tasks_show(struct seq_file *s, void *v)
 {
-	return seq_printf(s, "%d\n", *(int *)v);
+	struct cgroup *cgrp = s->private;
+	int index = (int)v ^ -0x10000;
+	return seq_printf(s, "%d\n", getpidofmbuf(cgrp->tasks_pids, index));
 }
 
 static struct seq_operations cgroup_tasks_seq_operations = {
@@ -2164,12 +2188,60 @@ static struct seq_operations cgroup_tasks_seq_operations = {
 	.show = cgroup_tasks_show,
 };
 
+static void *alloc_mutibufs(size_t npids)
+{
+	int i, j, npages = (npids + pid_per_page - 1) / pid_per_page;
+	unsigned long *pages;
+
+	if (npids <= pid_per_page - sizeof(pid_t *) / sizeof(pid_t)) {
+		void *pids = kmalloc(sizeof(pid_t *) + sizeof(pid_t) * npids,
+				GFP_KERNEL);
+		if (!pids)
+			return NULL;
+		/* make single buf fake multi-buf */
+		*(void **)pids = pids + sizeof(pid_t *);
+		return pids;
+	}
+
+	pages = kmalloc(sizeof(*pages) * npages, GFP_KERNEL);
+	if (!pages)
+		return NULL;
+
+	for (i = 0; i < npages; i++) {
+		pages[i] = __get_free_page(GFP_KERNEL);
+		if (unlikely(!pages[i]))
+			goto depopulate;
+	}
+	return pages;
+
+depopulate:
+	for (j = 0; j < i; j++)
+		free_page(pages[j]);
+	kfree(pages);
+	return NULL;
+}
+
+static void free_multibufs(void *ptr, size_t npids)
+{
+	if (!ptr)
+		return;
+
+	if (npids > pid_per_page - sizeof(pid_t *) / sizeof(pid_t)) {
+		int i, npages = (npids + pid_per_page - 1) / pid_per_page;
+		unsigned long *pages = ptr;
+		for (i = 0; i < npages; i++)
+			free_page(pages[i]);
+	}
+
+	kfree(ptr);
+}
+
 static void release_cgroup_pid_array(struct cgroup *cgrp)
 {
 	down_write(&cgrp->pids_mutex);
 	BUG_ON(!cgrp->pids_use_count);
 	if (!--cgrp->pids_use_count) {
-		kfree(cgrp->tasks_pids);
+		free_multibufs((void *)cgrp->tasks_pids, cgrp->pids_length);
 		cgrp->tasks_pids = NULL;
 		cgrp->pids_length = 0;
 	}
@@ -2202,7 +2274,7 @@ static struct file_operations cgroup_tasks_operations = {
 static int cgroup_tasks_open(struct inode *unused, struct file *file)
 {
 	struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
-	pid_t *pidarray;
+	pid_t **pidarray;
 	int npids;
 	int retval;
 
@@ -2217,19 +2289,19 @@ static int cgroup_tasks_open(struct inode *unused, struct file *file)
 	 * show up until sometime later on.
 	 */
 	npids = cgroup_task_count(cgrp);
-	pidarray = kmalloc(npids * sizeof(pid_t), GFP_KERNEL);
+	pidarray = alloc_mutibufs(npids);
 	if (!pidarray)
 		return -ENOMEM;
 	npids = pid_array_load(pidarray, npids, cgrp);
-	sort(pidarray, npids, sizeof(pid_t), cmppid, NULL);
+	obj_sort(pidarray, 0, npids, cmppid, swappid);
 
 	/*
 	 * Store the array in the cgroup, freeing the old
 	 * array if necessary
 	 */
 	down_write(&cgrp->pids_mutex);
-	kfree(cgrp->tasks_pids);
-	cgrp->tasks_pids = pidarray;
+	free_multibufs((void *)cgrp->tasks_pids, cgrp->pids_length);
+	cgrp->tasks_pids = (const pid_t *const *)pidarray;
 	cgrp->pids_length = npids;
 	cgrp->pids_use_count++;
 	up_write(&cgrp->pids_mutex);


