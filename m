Return-Path: <linux-kernel-owner+w=401wt.eu-S937372AbZAQCa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937372AbZAQCa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 21:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759362AbZAQC3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 21:29:49 -0500
Received: from smtp-out.google.com ([216.239.33.17]:20672 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbZAQC3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 21:29:46 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=m6M6r8BsBTAKZ3HTjmSIEf1TVCTE9k7NtbvVQQIbwEwjiWh5xgDFtRkyA8CH28/US
	kB7KGXElVjsOMqdPQNLkQ==
From: Mike Waychison <mikew@google.com>
Subject: [PATCH v1 1/8] Deferred batching of dput()
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Fri, 16 Jan 2009 18:29:42 -0800
Message-ID: <20090117022942.20425.15217.stgit@crlf.corp.google.com>
In-Reply-To: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.147
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the notion of postponed dputs to the VFS.   We do this by
introducing struct postponed_dentries, a data structure that maintains a list
of dentries that are pending a final dput.

Each CPU gets an on-heap allocated postponed_dentries structure that is
protected by disabling pre-emption and ensuring that they are only ever
accessed from the respective CPU.   When a queue gets full, we allocate a new
one to replace it and swap them atomically, afterwhich we release the previous
queue.  In the case where we fail to allocate a new queue, we go down a slow
path and iterate processing a single dentry at a time until the queue is empty.

The structure itself has three lists embedded in it.  We maintain:

- Dentries pending for dput.
- Dentries and their associated inodes pending dentry_iput.

We reuse the first list as we discover parents.

Currently, postponed dputs are still handled in a serialized fashion, but we
defer them into struct postponed_dentries.  The lock consolidation will come in
a later patch.

Lastly, we introduce a way to flush any pending dput()s via dput_drain_all() to
ensure that all dentries are finalized before fs shutdown.

Signed-off-by: Mike Waychison <mikew@google.com>
---

 fs/dcache.c            |  289 +++++++++++++++++++++++++++++++++++++++++++-----
 fs/super.c             |    2 
 include/linux/dcache.h |    1 
 3 files changed, 261 insertions(+), 31 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 4547f66..ea6b8f0 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -32,6 +32,7 @@
 #include <linux/seqlock.h>
 #include <linux/swap.h>
 #include <linux/bootmem.h>
+#include <linux/cpu.h>
 #include "internal.h"
 
 int sysctl_vfs_cache_pressure __read_mostly = 100;
@@ -182,6 +183,175 @@ static struct dentry *d_kill(struct dentry *dentry)
 	return parent;
 }
 
+struct postponed_dentries {
+	unsigned size;
+	struct {
+		unsigned nr;
+		struct dentry **dentries;
+	} pending_dput;
+	struct {
+		unsigned nr;
+		struct dentry **dentries;
+		struct inode **inodes;
+	} pending_dentry_iput;
+};
+
+struct postponed_dentries_onstack {
+	struct postponed_dentries ppd;
+	struct dentry *dentry_pending_dput;
+	struct dentry *dentry_pending_dentry_iput;
+	struct inode *inode_pending_dentry_iput;
+};
+
+static struct postponed_dentries *init_ppd_onstack(
+		struct postponed_dentries_onstack *ppd_onstack)
+{
+	struct postponed_dentries *ppd;
+	ppd = &ppd_onstack->ppd;
+	ppd->size = 1;
+	ppd->pending_dput.nr = 0;
+	ppd->pending_dput.dentries = &ppd_onstack->dentry_pending_dput;
+	ppd->pending_dentry_iput.nr = 0;
+	ppd->pending_dentry_iput.dentries =
+		&ppd_onstack->dentry_pending_dentry_iput;
+	ppd->pending_dentry_iput.inodes =
+		&ppd_onstack->inode_pending_dentry_iput;
+	return ppd;
+}
+
+static unsigned postponed_dentries_per_page(void)
+{
+	return (PAGE_SIZE - sizeof(struct postponed_dentries)) /
+		(3 * sizeof(void *));
+}
+
+/* Allocate a postponed_dentries structure on the heap. */
+struct postponed_dentries *new_postponed_dentries(void)
+{
+	struct postponed_dentries *ppd;
+	struct page *page;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return NULL;
+
+	ppd = page_address(page);
+
+	/* Create an set of three arrays immediately after the structure. */
+	ppd->size = postponed_dentries_per_page();
+	ppd->pending_dput.nr = 0;
+	ppd->pending_dput.dentries = (struct dentry **)(ppd + 1);
+	ppd->pending_dentry_iput.nr = 0;
+	ppd->pending_dentry_iput.dentries =
+		ppd->pending_dput.dentries + ppd->size;
+	ppd->pending_dentry_iput.inodes = (struct inode **)
+		(ppd->pending_dentry_iput.dentries + ppd->size);
+
+	return ppd;
+}
+
+static int pending_dput_full(struct postponed_dentries *ppd)
+{
+	return ppd->pending_dput.nr == ppd->size;
+}
+
+static void add_pending_dput(struct postponed_dentries *ppd,
+			     struct dentry *dentry)
+{
+	ppd->pending_dput.dentries[ppd->pending_dput.nr++] = dentry;
+}
+
+static DEFINE_PER_CPU(struct postponed_dentries *, postponed_dentries);
+
+static int initialize_postponed_dentries(long cpu)
+{
+	struct postponed_dentries **pppd = &per_cpu(postponed_dentries, cpu);
+	*pppd = new_postponed_dentries();
+	if (!*pppd)
+		return 1;
+	return 0;
+}
+
+static void process_postponed_dentries(struct postponed_dentries *ppd);
+static void release_postponed_dentries(struct postponed_dentries *ppd)
+{
+	process_postponed_dentries(ppd);
+	free_page((unsigned long)ppd);
+}
+
+static int __cpuinit cpuup_callback(struct notifier_block *nfb,
+				    unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+		if (initialize_postponed_dentries(cpu))
+			return NOTIFY_STOP;
+		break;
+	case CPU_DEAD:
+		release_postponed_dentries(per_cpu(postponed_dentries, cpu));
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata dentry_put_cache_notifier = {
+	&cpuup_callback, NULL, 0
+};
+
+static void real_dput(struct dentry *dentry)
+{
+	/* Legacy: */
+repeat:
+	spin_lock(&dcache_lock);
+	if (atomic_dec_and_test(&dentry->d_count)) {
+		spin_unlock(&dcache_lock);
+		return;
+	}
+
+	spin_lock(&dentry->d_lock);
+	if (atomic_read(&dentry->d_count)) {
+		spin_unlock(&dentry->d_lock);
+		spin_unlock(&dcache_lock);
+		return;
+	}
+
+	/*
+	 * AV: ->d_delete() is _NOT_ allowed to block now.
+	 */
+	if (dentry->d_op && dentry->d_op->d_delete) {
+		if (dentry->d_op->d_delete(dentry))
+			goto unhash_it;
+	}
+	/* Unreachable? Get rid of it */
+	if (d_unhashed(dentry))
+		goto kill_it;
+	if (list_empty(&dentry->d_lru)) {
+		dentry->d_flags |= DCACHE_REFERENCED;
+		dentry_lru_add(dentry);
+	}
+	spin_unlock(&dentry->d_lock);
+	spin_unlock(&dcache_lock);
+	return;
+
+unhash_it:
+	__d_drop(dentry);
+kill_it:
+	/* if dentry was on the d_lru list delete it from there */
+	dentry_lru_del(dentry);
+	dentry = d_kill(dentry);
+	if (dentry)
+		goto repeat;
+}
+
+static void process_postponed_dentries(struct postponed_dentries *ppd)
+{
+	unsigned i;
+
+	for (i = 0; i < ppd->pending_dput.nr; i++)
+		real_dput(ppd->pending_dput.dentries[i]);
+}
 /* 
  * This is dput
  *
@@ -199,6 +369,40 @@ static struct dentry *d_kill(struct dentry *dentry)
  * Real recursion would eat up our stack space.
  */
 
+static void postpone_dput(struct dentry *dentry)
+{
+	struct postponed_dentries *ppd, *new_ppd;
+
+again:
+	ppd = get_cpu_var(postponed_dentries);
+	if (!pending_dput_full(ppd)) {
+		add_pending_dput(ppd, dentry);
+		put_cpu_var(postponed_dentries);
+		return;
+	}
+
+	/* need to flush out existing pending dentries. */
+	put_cpu_var(postponed_dentries);
+	/* Allocate more space.. */
+	new_ppd = new_postponed_dentries();
+	if (!new_ppd) {
+		/* Take the slow path, memory is low */
+		struct postponed_dentries_onstack ppd_onstack;
+		struct postponed_dentries *ppd;
+
+		ppd = init_ppd_onstack(&ppd_onstack);
+		add_pending_dput(ppd, dentry);
+		process_postponed_dentries(ppd);
+		return;
+	}
+	ppd = get_cpu_var(postponed_dentries);
+	__get_cpu_var(postponed_dentries) = new_ppd;
+	put_cpu_var(postponed_dentries);
+	process_postponed_dentries(ppd);
+	goto again;
+}
+
+
 /*
  * dput - release a dentry
  * @dentry: dentry to release 
@@ -216,45 +420,62 @@ void dput(struct dentry *dentry)
 	if (!dentry)
 		return;
 
-repeat:
 	if (atomic_read(&dentry->d_count) == 1)
 		might_sleep();
-	if (!atomic_dec_and_lock(&dentry->d_count, &dcache_lock))
+	/* Decrement the count unless we would hit zero */
+	if (atomic_add_unless(&dentry->d_count, -1, 1))
 		return;
+	postpone_dput(dentry);
+}
 
-	spin_lock(&dentry->d_lock);
-	if (atomic_read(&dentry->d_count)) {
-		spin_unlock(&dentry->d_lock);
-		spin_unlock(&dcache_lock);
-		return;
+/**
+ * dput_drain_slowpath - drain out the postponed dentries on this cpu
+ *
+ * Iterates through and loops until there are no dentries pending dput on the
+ * invoked CPU.   Must be called with pre-emption disabled, but may re-enable
+ * pre-emption.  Returns with pre-emption disabled.  Caller is required to
+ * ensure that this thread will not change CPUs in the meantime.
+ */
+static void dput_drain_slowpath(void)
+{
+	struct postponed_dentries *ppd;
+
+	ppd = __get_cpu_var(postponed_dentries);
+	while (ppd->pending_dput.nr) {
+		struct postponed_dentries_onstack ppd_onstack;
+		struct postponed_dentries *tmp_ppd;
+		struct dentry *dentry;
+
+		dentry = ppd->pending_dput.dentries[--ppd->pending_dput.nr];
+
+		tmp_ppd = init_ppd_onstack(&ppd_onstack);
+		add_pending_dput(tmp_ppd, dentry);
+		put_cpu_var(postponed_dentries);
+		process_postponed_dentries(tmp_ppd);
+		ppd = get_cpu_var(postponed_dentries);
 	}
+}
 
-	/*
-	 * AV: ->d_delete() is _NOT_ allowed to block now.
-	 */
-	if (dentry->d_op && dentry->d_op->d_delete) {
-		if (dentry->d_op->d_delete(dentry))
-			goto unhash_it;
+static void dput_drain_per_cpu(struct work_struct *dummy)
+{
+	struct postponed_dentries *ppd, *new_ppd;
+
+	new_ppd = new_postponed_dentries();
+
+	ppd = get_cpu_var(postponed_dentries);
+	if (new_ppd) {
+		__get_cpu_var(postponed_dentries) = new_ppd;
+		put_cpu_var(postponed_dentries);
+		release_postponed_dentries(ppd);
+	} else {
+		dput_drain_slowpath();
+		put_cpu_var(postponed_dentries);
 	}
-	/* Unreachable? Get rid of it */
- 	if (d_unhashed(dentry))
-		goto kill_it;
-  	if (list_empty(&dentry->d_lru)) {
-  		dentry->d_flags |= DCACHE_REFERENCED;
-		dentry_lru_add(dentry);
-  	}
- 	spin_unlock(&dentry->d_lock);
-	spin_unlock(&dcache_lock);
-	return;
+}
 
-unhash_it:
-	__d_drop(dentry);
-kill_it:
-	/* if dentry was on the d_lru list delete it from there */
-	dentry_lru_del(dentry);
-	dentry = d_kill(dentry);
-	if (dentry)
-		goto repeat;
+void dput_drain_all(void)
+{
+	schedule_on_each_cpu(dput_drain_per_cpu);
 }
 
 /**
@@ -2321,6 +2542,7 @@ void __init vfs_caches_init_early(void)
 void __init vfs_caches_init(unsigned long mempages)
 {
 	unsigned long reserve;
+	long cpu;
 
 	/* Base hash sizes on available memory, with a reserve equal to
            150% of current kernel size */
@@ -2337,6 +2559,11 @@ void __init vfs_caches_init(unsigned long mempages)
 	mnt_init();
 	bdev_cache_init();
 	chrdev_init();
+
+	for_each_online_cpu(cpu)
+		if (initialize_postponed_dentries(cpu))
+			panic("Couldn't init postponed dentries\n");
+	register_cpu_notifier(&dentry_put_cache_notifier);
 }
 
 EXPORT_SYMBOL(d_alloc);
diff --git a/fs/super.c b/fs/super.c
index ed080c4..534840f 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -292,6 +292,8 @@ void generic_shutdown_super(struct super_block *sb)
 	const struct super_operations *sop = sb->s_op;
 
 
+	dput_drain_all();
+
 	if (sb->s_root) {
 		shrink_dcache_for_umount(sb);
 		fsync_super(sb);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index c66d224..c9f7c95 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -362,6 +362,7 @@ static inline struct dentry *dget_parent(struct dentry *dentry)
 }
 
 extern void dput(struct dentry *);
+void dput_drain_all(void);
 
 static inline int d_mountpoint(struct dentry *dentry)
 {

