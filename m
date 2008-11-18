Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYKRIzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYKRIzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYKRIyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:54:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57599 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbYKRIya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:54:30 -0500
Message-ID: <49228208.4050106@cn.fujitsu.com>
Date: Tue, 18 Nov 2008 16:51:20 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, David Miller <davem@davemloft.net>,
       Dave Airlie <airlied@gmail.com>, Paul Menage <menage@google.com>,
       kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, dada1@cosmosbay.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <npiggin@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH V2 3/4] files: use kvmalloc()/kvfree()/kvfree_atomic()
References: <492162E4.9080902@cn.fujitsu.com> <20081117131440.GB29931@cmpxchg.org>
In-Reply-To: <20081117131440.GB29931@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


RCU callback here use vfree()
use kvmalloc()/kvfree()/kvfree_atomic() make it simple

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 fs/file.c               |  122 +++++++-----------------------------------------
 include/linux/fdtable.h |    1
 2 files changed, 19 insertions(+), 104 deletions(-)
diff --git a/fs/file.c b/fs/file.c
index f313314..a71fdf3 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -20,71 +20,13 @@
 #include <linux/rcupdate.h>
 #include <linux/workqueue.h>
 
-struct fdtable_defer {
-	spinlock_t lock;
-	struct work_struct wq;
-	struct fdtable *next;
-};
-
 int sysctl_nr_open __read_mostly = 1024*1024;
 int sysctl_nr_open_min = BITS_PER_LONG;
 int sysctl_nr_open_max = 1024 * 1024; /* raised later */
 
-/*
- * We use this list to defer free fdtables that have vmalloced
- * sets/arrays. By keeping a per-cpu list, we avoid having to embed
- * the work_struct in fdtable itself which avoids a 64 byte (i386) increase in
- * this per-task structure.
- */
-static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
-
-static inline void * alloc_fdmem(unsigned int size)
-{
-	if (size <= PAGE_SIZE)
-		return kmalloc(size, GFP_KERNEL);
-	else
-		return vmalloc(size);
-}
-
-static inline void free_fdarr(struct fdtable *fdt)
-{
-	if (fdt->max_fds <= (PAGE_SIZE / sizeof(struct file *)))
-		kfree(fdt->fd);
-	else
-		vfree(fdt->fd);
-}
-
-static inline void free_fdset(struct fdtable *fdt)
-{
-	if (fdt->max_fds <= (PAGE_SIZE * BITS_PER_BYTE / 2))
-		kfree(fdt->open_fds);
-	else
-		vfree(fdt->open_fds);
-}
-
-static void free_fdtable_work(struct work_struct *work)
-{
-	struct fdtable_defer *f =
-		container_of(work, struct fdtable_defer, wq);
-	struct fdtable *fdt;
-
-	spin_lock_bh(&f->lock);
-	fdt = f->next;
-	f->next = NULL;
-	spin_unlock_bh(&f->lock);
-	while(fdt) {
-		struct fdtable *next = fdt->next;
-		vfree(fdt->fd);
-		free_fdset(fdt);
-		kfree(fdt);
-		fdt = next;
-	}
-}
-
 void free_fdtable_rcu(struct rcu_head *rcu)
 {
 	struct fdtable *fdt = container_of(rcu, struct fdtable, rcu);
-	struct fdtable_defer *fddef;
 
 	BUG_ON(!fdt);
 
@@ -97,20 +39,9 @@ void free_fdtable_rcu(struct rcu_head *rcu)
 				container_of(fdt, struct files_struct, fdtab));
 		return;
 	}
-	if (fdt->max_fds <= (PAGE_SIZE / sizeof(struct file *))) {
-		kfree(fdt->fd);
-		kfree(fdt->open_fds);
-		kfree(fdt);
-	} else {
-		fddef = &get_cpu_var(fdtable_defer_list);
-		spin_lock(&fddef->lock);
-		fdt->next = fddef->next;
-		fddef->next = fdt;
-		/* vmallocs are handled from the workqueue context */
-		schedule_work(&fddef->wq);
-		spin_unlock(&fddef->lock);
-		put_cpu_var(fdtable_defer_list);
-	}
+	kvfree_atomic(fdt->fd);
+	kvfree_atomic(fdt->open_fds);
+	kfree(fdt);
 }
 
 /*
@@ -166,30 +97,36 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	if (!fdt)
 		goto out;
 	fdt->max_fds = nr;
-	data = alloc_fdmem(nr * sizeof(struct file *));
+	data = kvmalloc(nr * sizeof(struct file *), GFP_KERNEL);
 	if (!data)
 		goto out_fdt;
 	fdt->fd = (struct file **)data;
-	data = alloc_fdmem(max_t(unsigned int,
-				 2 * nr / BITS_PER_BYTE, L1_CACHE_BYTES));
+	data = kvmalloc(max_t(unsigned int, 2 * nr / BITS_PER_BYTE,
+			      L1_CACHE_BYTES), GFP_KERNEL);
 	if (!data)
 		goto out_arr;
 	fdt->open_fds = (fd_set *)data;
 	data += nr / BITS_PER_BYTE;
 	fdt->close_on_exec = (fd_set *)data;
 	INIT_RCU_HEAD(&fdt->rcu);
-	fdt->next = NULL;
 
 	return fdt;
 
 out_arr:
-	free_fdarr(fdt);
+	kvfree(fdt->fd);
 out_fdt:
 	kfree(fdt);
 out:
 	return NULL;
 }
 
+static void immediate_free_fdtable(struct fdtable *fdt)
+{
+	kvfree(fdt->fd);
+	kvfree(fdt->open_fds);
+	kfree(fdt);
+}
+
 /*
  * Expand the file descriptor table.
  * This function will allocate a new fdtable and both fd array and fdset, of
@@ -213,9 +150,7 @@ static int expand_fdtable(struct files_struct *files, int nr)
 	 * caller and alloc_fdtable().  Cheaper to catch it here...
 	 */
 	if (unlikely(new_fdt->max_fds <= nr)) {
-		free_fdarr(new_fdt);
-		free_fdset(new_fdt);
-		kfree(new_fdt);
+		immediate_free_fdtable(new_fdt);
 		return -EMFILE;
 	}
 	/*
@@ -231,9 +166,7 @@ static int expand_fdtable(struct files_struct *files, int nr)
 			free_fdtable(cur_fdt);
 	} else {
 		/* Somebody else expanded, so undo our attempt */
-		free_fdarr(new_fdt);
-		free_fdset(new_fdt);
-		kfree(new_fdt);
+		immediate_free_fdtable(new_fdt);
 	}
 	return 1;
 }
@@ -312,7 +245,6 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	new_fdt->open_fds = (fd_set *)&newf->open_fds_init;
 	new_fdt->fd = &newf->fd_array[0];
 	INIT_RCU_HEAD(&new_fdt->rcu);
-	new_fdt->next = NULL;
 
 	spin_lock(&oldf->file_lock);
 	old_fdt = files_fdtable(oldf);
@@ -324,11 +256,8 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	while (unlikely(open_files > new_fdt->max_fds)) {
 		spin_unlock(&oldf->file_lock);
 
-		if (new_fdt != &newf->fdtab) {
-			free_fdarr(new_fdt);
-			free_fdset(new_fdt);
-			kfree(new_fdt);
-		}
+		if (new_fdt != &newf->fdtab)
+			immediate_free_fdtable(new_fdt);
 
 		new_fdt = alloc_fdtable(open_files - 1);
 		if (!new_fdt) {
@@ -338,9 +267,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 
 		/* beyond sysctl_nr_open; nothing to do */
 		if (unlikely(new_fdt->max_fds < open_files)) {
-			free_fdarr(new_fdt);
-			free_fdset(new_fdt);
-			kfree(new_fdt);
+			immediate_free_fdtable(new_fdt);
 			*errorp = -EMFILE;
 			goto out_release;
 		}
@@ -404,19 +331,8 @@ out:
 	return NULL;
 }
 
-static void __devinit fdtable_defer_list_init(int cpu)
-{
-	struct fdtable_defer *fddef = &per_cpu(fdtable_defer_list, cpu);
-	spin_lock_init(&fddef->lock);
-	INIT_WORK(&fddef->wq, free_fdtable_work);
-	fddef->next = NULL;
-}
-
 void __init files_defer_init(void)
 {
-	int i;
-	for_each_possible_cpu(i)
-		fdtable_defer_list_init(i);
 	sysctl_nr_open_max = min((size_t)INT_MAX, ~(size_t)0/sizeof(void *)) &
 			     -BITS_PER_LONG;
 }
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 4aab6f1..cacdae6 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -32,7 +32,6 @@ struct fdtable {
 	fd_set *close_on_exec;
 	fd_set *open_fds;
 	struct rcu_head rcu;
-	struct fdtable *next;
 };
 
 /*

