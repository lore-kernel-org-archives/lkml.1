Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbZHRX6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbZHRX6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZHRX6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:58:23 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10491 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbZHRX6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:58:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=pIWfcsqRuDHCEVPNMZwPDPeNqErV+tATQVyqWTLeDw3dL6dQGAkPcolyk8KUiQ/DE
	trEFua81aLiVwfRlcVTnw==
From: Paul Menage <menage@google.com>
Subject: [PATCH 1/8] Revert commit 8827c288feb7810185aa7c2e37537202fc709869
To: akpm@linux-foundation.org, bblum@andrew.cmu.edu, lizf@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Date: Tue, 18 Aug 2009 16:58:12 -0700
Message-ID: <20090818235812.22531.76212.stgit@menage.mtv.corp.google.com>
In-Reply-To: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Revert commit 8827c288feb7810185aa7c2e37537202fc709869

This is in preparation for some clashing cgroups changes that subsume
the original commit's functionaliy.

Signed-off-by: Paul Menage <menage@google.com>

--

The original commit fixed a pid namespace bug which Ben Blum fixed
independently (in the same way, but with different code) as part of a
series of patches. I played around with trying to reconcile Ben's
patch series with Li's patch, but concluded that it was simpler to
just revert Li's, given that Ben's patch series contained essentially
the same fix.

---

 include/linux/cgroup.h |   11 ++++--
 kernel/cgroup.c        |   95 ++++++++++++------------------------------------
 2 files changed, 31 insertions(+), 75 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 90bba9e..c833d6f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -179,11 +179,14 @@ struct cgroup {
 	 */
 	struct list_head release_list;
 
-	/* pids_mutex protects pids_list and cached pid arrays. */
+	/* pids_mutex protects the fields below */
 	struct rw_semaphore pids_mutex;
-
-	/* Linked list of struct cgroup_pids */
-	struct list_head pids_list;
+	/* Array of process ids in the cgroup */
+	pid_t *tasks_pids;
+	/* How many files are using the current tasks_pids array */
+	int pids_use_count;
+	/* Length of the current tasks_pids array */
+	int pids_length;
 
 	/* For RCU-protected deletion */
 	struct rcu_head rcu_head;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 89d63eb..cea36c3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1121,7 +1121,6 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	INIT_LIST_HEAD(&cgrp->children);
 	INIT_LIST_HEAD(&cgrp->css_sets);
 	INIT_LIST_HEAD(&cgrp->release_list);
-	INIT_LIST_HEAD(&cgrp->pids_list);
 	init_rwsem(&cgrp->pids_mutex);
 }
 
@@ -2431,30 +2430,12 @@ err:
 	return ret;
 }
 
-/*
- * Cache pids for all threads in the same pid namespace that are
- * opening the same "tasks" file.
- */
-struct cgroup_pids {
-	/* The node in cgrp->pids_list */
-	struct list_head list;
-	/* The cgroup those pids belong to */
-	struct cgroup *cgrp;
-	/* The namepsace those pids belong to */
-	struct pid_namespace *ns;
-	/* Array of process ids in the cgroup */
-	pid_t *tasks_pids;
-	/* How many files are using the this tasks_pids array */
-	int use_count;
-	/* Length of the current tasks_pids array */
-	int length;
-};
-
 static int cmppid(const void *a, const void *b)
 {
 	return *(pid_t *)a - *(pid_t *)b;
 }
 
+
 /*
  * seq_file methods for the "tasks" file. The seq_file position is the
  * next pid to display; the seq_file iterator is a pointer to the pid
@@ -2469,47 +2450,45 @@ static void *cgroup_tasks_start(struct seq_file *s, loff_t *pos)
 	 * after a seek to the start). Use a binary-search to find the
 	 * next pid to display, if any
 	 */
-	struct cgroup_pids *cp = s->private;
-	struct cgroup *cgrp = cp->cgrp;
+	struct cgroup *cgrp = s->private;
 	int index = 0, pid = *pos;
 	int *iter;
 
 	down_read(&cgrp->pids_mutex);
 	if (pid) {
-		int end = cp->length;
+		int end = cgrp->pids_length;
 
 		while (index < end) {
 			int mid = (index + end) / 2;
-			if (cp->tasks_pids[mid] == pid) {
+			if (cgrp->tasks_pids[mid] == pid) {
 				index = mid;
 				break;
-			} else if (cp->tasks_pids[mid] <= pid)
+			} else if (cgrp->tasks_pids[mid] <= pid)
 				index = mid + 1;
 			else
 				end = mid;
 		}
 	}
 	/* If we're off the end of the array, we're done */
-	if (index >= cp->length)
+	if (index >= cgrp->pids_length)
 		return NULL;
 	/* Update the abstract position to be the actual pid that we found */
-	iter = cp->tasks_pids + index;
+	iter = cgrp->tasks_pids + index;
 	*pos = *iter;
 	return iter;
 }
 
 static void cgroup_tasks_stop(struct seq_file *s, void *v)
 {
-	struct cgroup_pids *cp = s->private;
-	struct cgroup *cgrp = cp->cgrp;
+	struct cgroup *cgrp = s->private;
 	up_read(&cgrp->pids_mutex);
 }
 
 static void *cgroup_tasks_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct cgroup_pids *cp = s->private;
+	struct cgroup *cgrp = s->private;
 	int *p = v;
-	int *end = cp->tasks_pids + cp->length;
+	int *end = cgrp->tasks_pids + cgrp->pids_length;
 
 	/*
 	 * Advance to the next pid in the array. If this goes off the
@@ -2536,33 +2515,26 @@ static const struct seq_operations cgroup_tasks_seq_operations = {
 	.show = cgroup_tasks_show,
 };
 
-static void release_cgroup_pid_array(struct cgroup_pids *cp)
+static void release_cgroup_pid_array(struct cgroup *cgrp)
 {
-	struct cgroup *cgrp = cp->cgrp;
-
 	down_write(&cgrp->pids_mutex);
-	BUG_ON(!cp->use_count);
-	if (!--cp->use_count) {
-		list_del(&cp->list);
-		put_pid_ns(cp->ns);
-		kfree(cp->tasks_pids);
-		kfree(cp);
+	BUG_ON(!cgrp->pids_use_count);
+	if (!--cgrp->pids_use_count) {
+		kfree(cgrp->tasks_pids);
+		cgrp->tasks_pids = NULL;
+		cgrp->pids_length = 0;
 	}
 	up_write(&cgrp->pids_mutex);
 }
 
 static int cgroup_tasks_release(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq;
-	struct cgroup_pids *cp;
+	struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
 
 	if (!(file->f_mode & FMODE_READ))
 		return 0;
 
-	seq = file->private_data;
-	cp = seq->private;
-
-	release_cgroup_pid_array(cp);
+	release_cgroup_pid_array(cgrp);
 	return seq_release(inode, file);
 }
 
@@ -2581,8 +2553,6 @@ static struct file_operations cgroup_tasks_operations = {
 static int cgroup_tasks_open(struct inode *unused, struct file *file)
 {
 	struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
-	struct pid_namespace *ns = current->nsproxy->pid_ns;
-	struct cgroup_pids *cp;
 	pid_t *pidarray;
 	int npids;
 	int retval;
@@ -2609,37 +2579,20 @@ static int cgroup_tasks_open(struct inode *unused, struct file *file)
 	 * array if necessary
 	 */
 	down_write(&cgrp->pids_mutex);
-
-	list_for_each_entry(cp, &cgrp->pids_list, list) {
-		if (ns == cp->ns)
-			goto found;
-	}
-
-	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
-	if (!cp) {
-		up_write(&cgrp->pids_mutex);
-		kfree(pidarray);
-		return -ENOMEM;
-	}
-	cp->cgrp = cgrp;
-	cp->ns = ns;
-	get_pid_ns(ns);
-	list_add(&cp->list, &cgrp->pids_list);
-found:
-	kfree(cp->tasks_pids);
-	cp->tasks_pids = pidarray;
-	cp->length = npids;
-	cp->use_count++;
+	kfree(cgrp->tasks_pids);
+	cgrp->tasks_pids = pidarray;
+	cgrp->pids_length = npids;
+	cgrp->pids_use_count++;
 	up_write(&cgrp->pids_mutex);
 
 	file->f_op = &cgroup_tasks_operations;
 
 	retval = seq_open(file, &cgroup_tasks_seq_operations);
 	if (retval) {
-		release_cgroup_pid_array(cp);
+		release_cgroup_pid_array(cgrp);
 		return retval;
 	}
-	((struct seq_file *)file->private_data)->private = cp;
+	((struct seq_file *)file->private_data)->private = cgrp;
 	return 0;
 }
 

