Return-Path: <linux-kernel-owner+w=401wt.eu-S934847AbZAQCcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934847AbZAQCcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 21:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765026AbZAQC35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 21:29:57 -0500
Received: from smtp-out.google.com ([216.239.45.13]:20124 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760928AbZAQC3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 21:29:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=ZIf9XfvtdAG6/Cp3cedcXx5k1gLxxBPqXgoyUkT7pujpWz5ne7oWyZyYnznZ+BFHu
	lc0QlkfXzKK9Opx0LPvDg==
From: Mike Waychison <mikew@google.com>
Subject: [PATCH v1 3/8] Deferred batching of iput()
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Fri, 16 Jan 2009 18:29:52 -0800
Message-ID: <20090117022952.20425.91639.stgit@crlf.corp.google.com>
In-Reply-To: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
References: <20090117022936.20425.43248.stgit@crlf.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.35
X-GMailtapped: mikew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the postponed_inodes structure which is used to batch iputs so
that they can later be processed in parallel.

Each CPU gets an on-heap allocated postponed_inodes structure that is protected
by disabling pre-emption and ensuring that they are only ever accessed from
their respective CPU.

The idea is to enqueue inodes until we fill a postponed_inodes allocated on the
heap.  If we then see a postponed_inodes queue that is full, we try to allocate
a new one to replace it and process the full queue.  We handle page allocation
errors by processing pending inodes in place using a dummy on-stack structure
(iput_drain_slowpath).

Draining of the pending iput()s is tacked onto the draining of pending dput()s
instead of being kept seperate so that we don't have to schedule work on all
CPUs twice.

Processing of the actual final iput is still serial and will be addressed in a
later patch.

Signed-off-by: Mike Waychison <mikew@google.com>
---

 fs/dcache.c        |    1 
 fs/inode.c         |  211 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    2 
 3 files changed, 212 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 9760bdb..2c2ac62 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -545,6 +545,7 @@ static void dput_drain_per_cpu(struct work_struct *dummy)
 		dput_drain_slowpath();
 		put_cpu_var(postponed_dentries);
 	}
+	iput_drain_cpu();
 }
 
 void dput_drain_all(void)
diff --git a/fs/inode.c b/fs/inode.c
index 913ab2d..56cf6e2 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -23,6 +23,7 @@
 #include <linux/inotify.h>
 #include <linux/mount.h>
 #include <linux/async.h>
+#include <linux/cpu.h>
 
 /*
  * This is needed for the following functions:
@@ -384,6 +385,13 @@ int invalidate_inodes(struct super_block * sb)
 	LIST_HEAD(throw_away);
 
 	mutex_lock(&iprune_mutex);
+
+	/* We have to drain any pending iput()s as they will affect whether we
+	 * see inodes as busy or not (consider inodes put in put_super()). We
+	 * also have to do this while under iprune_mutex otherwise
+	 * shrink_icache_memory may stumble in and race with us. */
+	iput_drain_all();
+
 	spin_lock(&inode_lock);
 	inotify_unmount_inodes(&sb->s_inodes);
 	busy = invalidate_list(&sb->s_inodes, &throw_away);
@@ -1242,6 +1250,114 @@ static inline void iput_final(struct inode *inode)
 	drop(inode);
 }
 
+static void real_iput(struct inode *inode)
+{
+	if (atomic_dec_and_lock(&inode->i_count, &inode_lock))
+		iput_final(inode);
+}
+
+struct postponed_inodes {
+	unsigned size;
+	unsigned nr;
+	struct inode **inodes;
+};
+
+static DEFINE_PER_CPU(struct postponed_inodes *, postponed_inodes);
+
+static unsigned postponed_inodes_per_page(void)
+{
+	return (PAGE_SIZE - sizeof(struct postponed_inodes)) /
+		(sizeof(struct inode *));
+}
+
+static struct postponed_inodes *new_postponed_inodes(void)
+{
+	struct postponed_inodes *ppi;
+	struct page *page;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return NULL;
+
+	ppi = page_address(page);
+
+	ppi->size = postponed_inodes_per_page();
+	ppi->nr = 0;
+	ppi->inodes = (struct inode **)(ppi + 1);
+
+	return ppi;
+}
+
+struct postponed_inodes_onstack {
+	struct postponed_inodes ppi;
+	struct inode *inode;
+};
+
+static struct postponed_inodes *init_ppi_onstack(
+		struct postponed_inodes_onstack *ppi_onstack)
+{
+	struct postponed_inodes *ppi;
+	ppi = &ppi_onstack->ppi;
+	ppi->size = 1;
+	ppi->nr = 0;
+	ppi->inodes = &ppi_onstack->inode;
+	return ppi;
+}
+
+static int pending_iput_full(struct postponed_inodes *ppi)
+{
+	return ppi->nr == ppi->size;
+}
+
+static void add_pending_iput(struct postponed_inodes *ppi, struct inode *inode)
+{
+	ppi->inodes[ppi->nr++] = inode;
+}
+
+static void process_postponed_inodes(struct postponed_inodes *ppi)
+{
+	unsigned i;
+	for (i = 0; i < ppi->nr; i++)
+		real_iput(ppi->inodes[i]);
+}
+
+static void release_postponed_inodes(struct postponed_inodes *ppi)
+{
+	process_postponed_inodes(ppi);
+	free_page((unsigned long)ppi);
+}
+
+static void postpone_iput(struct inode *inode)
+{
+	struct postponed_inodes *ppi, *new_ppi;
+
+again:
+	ppi = get_cpu_var(postponed_inodes);
+	if (!pending_iput_full(ppi)) {
+		add_pending_iput(ppi, inode);
+		put_cpu_var(postponed_inodes);
+		return;
+	}
+
+	/* Need to flush out existing pending inodes */
+	put_cpu_var(postponed_inodes);
+	/* Allocate more space.. */
+	new_ppi = new_postponed_inodes();
+	if (!new_ppi) {
+		struct postponed_inodes_onstack ppi_onstack;
+
+		ppi = init_ppi_onstack(&ppi_onstack);
+		add_pending_iput(ppi, inode);
+		process_postponed_inodes(ppi);
+		return;
+	}
+	ppi = get_cpu_var(postponed_inodes);
+	__get_cpu_var(postponed_inodes) = new_ppi;
+	put_cpu_var(postponed_inodes);
+	process_postponed_inodes(ppi);
+	goto again;
+}
+
 /**
  *	iput	- put an inode 
  *	@inode: inode to put
@@ -1256,8 +1372,8 @@ void iput(struct inode *inode)
 	if (inode) {
 		BUG_ON(inode->i_state == I_CLEAR);
 
-		if (atomic_dec_and_lock(&inode->i_count, &inode_lock))
-			iput_final(inode);
+		if (!atomic_add_unless(&inode->i_count, -1, 1))
+			postpone_iput(inode);
 	}
 }
 
@@ -1468,6 +1584,88 @@ static int __init set_ihash_entries(char *str)
 }
 __setup("ihash_entries=", set_ihash_entries);
 
+static int __cpuinit cpuup_callback(struct notifier_block *nfb,
+				    unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+	struct postponed_inodes **pppi = &per_cpu(postponed_inodes, cpu);
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+		*pppi = new_postponed_inodes();
+		if (*pppi == NULL)
+			return NOTIFY_STOP;
+		break;
+	case CPU_DEAD:
+		release_postponed_inodes(*pppi);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata inode_put_cache_notifier = {
+	&cpuup_callback, NULL, 0
+};
+
+/**
+ * iput_drain_slowpath - drain out the postponed inodes on this cpu
+ *
+ * Iterates through and loops until all pending inodes on this cpu are iput.
+ * Must be called with pre-emption disabled, but may re-enable pre-emtion.
+ * Returns with pre-emption disabled.  Caller is required to ensure that this
+ * thread is affine to the cpu.
+ */
+static void iput_drain_cpu_slowpath(void)
+{
+	struct postponed_inodes *ppi;
+
+	ppi = __get_cpu_var(postponed_inodes);
+	while (ppi->nr) {
+		struct postponed_inodes_onstack ppi_onstack;
+		struct postponed_inodes *tmp_ppi;
+		struct inode *inode;
+
+		inode = ppi->inodes[--ppi->nr];
+
+		tmp_ppi = init_ppi_onstack(&ppi_onstack);
+		add_pending_iput(ppi, inode);
+		put_cpu_var(postponed_inodes);
+		process_postponed_inodes(ppi);
+		ppi = get_cpu_var(postponed_inodes);
+	}
+}
+
+/**
+ * iput_drain_cpu - Drain all pending iputs on this CPU
+ *
+ * Must be called affine to the CPU.
+ */
+void iput_drain_cpu(void)
+{
+	struct postponed_inodes *ppi, *new_ppi;
+
+	new_ppi = new_postponed_inodes();
+	ppi = get_cpu_var(postponed_inodes);
+	if (new_ppi) {
+		__get_cpu_var(postponed_inodes) = new_ppi;
+		put_cpu_var(postponed_inodes);
+		release_postponed_inodes(ppi);
+	} else {
+		iput_drain_cpu_slowpath();
+		put_cpu_var(postponed_inodes);
+	}
+}
+
+static void iput_drain_per_cpu_cb(struct work_struct *dummy)
+{
+	iput_drain_cpu();
+}
+
+void iput_drain_all(void)
+{
+	schedule_on_each_cpu(iput_drain_per_cpu_cb);
+}
+
 /*
  * Initialize the waitqueues and inode hash table.
  */
@@ -1498,6 +1696,7 @@ void __init inode_init_early(void)
 void __init inode_init(void)
 {
 	int loop;
+	long cpu;
 
 	/* inode slab cache */
 	inode_cachep = kmem_cache_create("inode_cache",
@@ -1508,6 +1707,14 @@ void __init inode_init(void)
 					 init_once);
 	register_shrinker(&icache_shrinker);
 
+	for_each_online_cpu(cpu) {
+		struct postponed_inodes *ppi = new_postponed_inodes();
+		if (!ppi)
+			panic("Couldn't allocate initial iput caches\n");
+		per_cpu(postponed_inodes, cpu) = ppi;
+	}
+	register_cpu_notifier(&inode_put_cache_notifier);
+
 	/* Hash may have been set up in inode_init_early */
 	if (!hashdist)
 		return;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6022f44..47eaa71 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1908,6 +1908,8 @@ extern ino_t iunique(struct super_block *, ino_t);
 extern int inode_needs_sync(struct inode *inode);
 extern void generic_delete_inode(struct inode *inode);
 extern void generic_drop_inode(struct inode *inode);
+extern void iput_drain_cpu(void);
+extern void iput_drain_all(void);
 
 extern struct inode *ilookup5_nowait(struct super_block *sb,
 		unsigned long hashval, int (*test)(struct inode *, void *),

