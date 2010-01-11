Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132Ab0AKJrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0AKJrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 04:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062Ab0AKJrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 04:47:47 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:57948 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0AKJrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 04:47:47 -0500
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jan 2010 04:47:47 EST
From: Alexander Shishkin <virtuoso@slind.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Alexander Shishkin <virtuoso@slind.org>,
       viro@zeniv.linux.org.uk
Subject: [RFC][PATCHv3] List per-process file descriptor consumption when hitting file-max
Date: Mon, 11 Jan 2010 11:38:07 +0200
Message-Id: <1263202687-18529-1-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <28675.1248957636@turing-police.cc.vt.edu>
References: <28675.1248957636@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a file descriptor limit is hit, display the top consumers of
descriptors so that it is possible to identify and fix those which
leak them.

Two new sysctl tunables are introduced:
  * file-max-consumers -- number of processes to display (defaults
    to 10);
  * file-max-rate-limit -- time interval between subsequent dumps
    (defaults to 10 seconds).

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: viro@zeniv.linux.org.uk
CC: linux-fsdevel@vger.kernel.org
---
Changes:
v3 -- fix a couple of silly checkpatch errors
v2 -- add rate-limiting and reduce number of processes to be output
v1 -- initial implementation.

 fs/file_table.c    |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/fs.h |    5 +++
 kernel/sysctl.c    |   14 ++++++++
 3 files changed, 107 insertions(+), 1 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 69652c5..26666fd 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -9,6 +9,7 @@
 #include <linux/slab.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
+#include <linux/sort.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/fs.h>
@@ -29,7 +30,8 @@
 
 /* sysctl tunables... */
 struct files_stat_struct files_stat = {
-	.max_files = NR_FILE
+	.max_files = NR_FILE,
+	.max_consumers = NR_CONSUMERS,
 };
 
 /* public. Not pretty! */
@@ -90,6 +92,80 @@ int proc_nr_files(ctl_table *table, int write,
 }
 #endif
 
+/*
+ * Number of open file descriptors per task_struct
+ */
+struct fd_consumer {
+	struct task_struct *task;
+	int fd_count;
+};
+
+static int cmp_fd_consumers(const void *a, const void *b)
+{
+	const struct fd_consumer *x = a, *y = b;
+
+	return y->fd_count - x->fd_count;
+}
+
+static void dump_fd_consumers(void)
+{
+	struct task_struct *p;
+	struct files_struct *files;
+	struct fdtable *fdt;
+	int proc_limit = files_stat.max_consumers;
+	int i, nproc;
+	struct fd_consumer *procs, *tmp;
+
+	if (!files_stat.max_consumers)
+		return;
+
+	read_lock(&tasklist_lock);
+
+	/* build an array of per-task file descriptor usage */
+	nproc = nr_processes();
+	procs = kzalloc(nproc * sizeof(struct fd_consumer), GFP_KERNEL);
+	if (!procs)
+		goto out;
+
+	tmp = procs;
+
+	for_each_process(p) {
+		tmp->task = p;
+
+		files = get_files_struct(p);
+		if (!files)
+			continue;
+
+		spin_lock(&files->file_lock);
+		fdt = files_fdtable(files);
+
+		/* we have to actually *count* the fds */
+		for (tmp->fd_count = i = 0; i < fdt->max_fds; i++)
+			tmp->fd_count += !!fcheck_files(files, i);
+
+		spin_unlock(&files->file_lock);
+		put_files_struct(files);
+
+		tmp++;
+	}
+
+	/* sort by number of used descriptor in descending order */
+	sort(procs, nproc, sizeof(struct fd_consumer), cmp_fd_consumers, NULL);
+
+	if (proc_limit > nproc)
+		proc_limit = nproc;
+
+	/* output the 'proc_limit' first entries */
+	for (i = 0, tmp = procs; i < proc_limit; i++, tmp++)
+		printk(KERN_INFO "=> %s [%d]: open=%d\n", tmp->task->comm,
+		       tmp->task->pid, tmp->fd_count);
+
+	kfree(procs);
+
+out:
+	read_unlock(&tasklist_lock);
+}
+
 /* Find an unused file structure and return a pointer to it.
  * Returns NULL, if there are no more free file structures or
  * we run out of memory.
@@ -105,6 +181,7 @@ struct file *get_empty_filp(void)
 	const struct cred *cred = current_cred();
 	static int old_max;
 	struct file * f;
+	static unsigned long next_dump;
 
 	/*
 	 * Privileged users can go above max_files
@@ -140,6 +217,14 @@ over:
 	if (get_nr_files() > old_max) {
 		printk(KERN_INFO "VFS: file-max limit %d reached\n",
 					get_max_files());
+
+		/* dump the biggest file descriptor users */
+		if (!next_dump || time_after(jiffies, next_dump)) {
+			next_dump = jiffies + files_stat.rate_limit;
+
+			dump_fd_consumers();
+		}
+
 		old_max = get_nr_files();
 	}
 	goto fail;
@@ -425,6 +510,8 @@ void __init files_init(unsigned long mempages)
 	files_stat.max_files = n; 
 	if (files_stat.max_files < NR_FILE)
 		files_stat.max_files = NR_FILE;
+
+	files_stat.rate_limit = DUMP_RATE_LIMIT;
 	files_defer_init();
 	percpu_counter_init(&nr_files, 0);
 } 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9147ca8..291beb3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -36,6 +36,8 @@ struct files_stat_struct {
 	int nr_files;		/* read only */
 	int nr_free_files;	/* read only */
 	int max_files;		/* tunable */
+	int max_consumers;	/* tunable */
+	unsigned long rate_limit;	/* tunable */
 };
 
 struct inodes_stat_t {
@@ -46,6 +48,9 @@ struct inodes_stat_t {
 
 
 #define NR_FILE  8192	/* this can well be larger on a larger system */
+#define NR_CONSUMERS 10 /* dump this many tasks when file-max is hit */
+#define DUMP_RATE_LIMIT msecs_to_jiffies(10000) /* wait this long between
+						   dumps */
 
 #define MAY_EXEC 1
 #define MAY_WRITE 2
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8a68b24..dfb08fc 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1325,6 +1325,20 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "file-max-consumers",
+		.data		= &files_stat.max_consumers,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "file-max-rate-limit",
+		.data		= &files_stat.rate_limit,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_ms_jiffies_minmax,
+	},
+	{
 		.procname	= "nr_open",
 		.data		= &sysctl_nr_open,
 		.maxlen		= sizeof(int),
-- 
1.6.5

