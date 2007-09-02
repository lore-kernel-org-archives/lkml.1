Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbXIBSg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbXIBSg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 14:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbXIBSgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 14:36:21 -0400
Received: from mail.suse.de ([195.135.220.2]:46360 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbXIBSgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 14:36:20 -0400
Date: Sun, 2 Sep 2007 20:36:19 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Paul McKenney <paulmck@us.ibm.com>
Subject: Re: [rfc][patch] dynamic data structure switching
Message-ID: <20070902183618.GB13145@wotan.suse.de>
References: <20070902182738.GA13145@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070902182738.GA13145@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dumb, slightly incomplete, dynamic pidhash resizing. I'm just sending this
as a reference and testing tool. While the pid-hash might be the least
problematic one we have, RAM saving / collision minimisation aren't the
only reasons to size a hash optimally: in a really lookup intensive
workload, a small dense hash table will have between 4-32x better cache
efficiency than a very sparse one, depending on line size and pointer
size. So it is possible that resizing even reasonably small hashes can
be a good idea.

Index: linux-2.6/kernel/pid.c
===================================================================
--- linux-2.6.orig/kernel/pid.c
+++ linux-2.6/kernel/pid.c
@@ -28,13 +28,25 @@
 #include <linux/hash.h>
 #include <linux/pid_namespace.h>
 #include <linux/init_task.h>
+#include <linux/dyndata.h>
 
-#define pid_hashfn(nr) hash_long((unsigned long)nr, pidhash_shift)
-static struct hlist_head *pid_hash;
-static int pidhash_shift;
+struct pid_hash {
+	struct hlist_head *table;
+	unsigned int shift;
+};
+
+static struct pid_hash pid_hashes[2];
+static unsigned int ph_cur_idx;
+static struct dyn_data dyn_pidhash;
+static unsigned int nr_pids;
+
+/* cur_pid_hash should be used under rcu_read_lock() */
+#define cur_pid_hash	((struct pid_hash *)dyn_data_current_dstruct(&dyn_pidhash))
+#define pid_hashfn(ph, nr) hash_long((unsigned long)nr, ph->shift)
 static struct kmem_cache *pid_cachep;
 struct pid init_struct_pid = INIT_STRUCT_PID;
 
+
 int pid_max = PID_MAX_DEFAULT;
 
 #define RESERVED_PIDS		300
@@ -190,21 +202,91 @@ static void delayed_put_pid(struct rcu_h
 	put_pid(pid);
 }
 
+int dd_transfer_pids(void *old_ds, void *new_ds)
+{
+	struct pid_hash *old = old_ds;
+	struct pid_hash *new = new_ds;
+	unsigned int size, i;
+
+	size = 1UL << old->shift;
+
+	BUG_ON(old == new);
+
+	for (i = 0; i < size; i++) {
+		struct hlist_node *elem;
+		struct pid *pid;
+
+		spin_lock_irq(&pidmap_lock);
+again:
+		hlist_for_each_entry_rcu(pid, elem, &old->table[i], pid_chain) {
+			hlist_del_rcu(&pid->pid_chain);
+			hlist_add_head_rcu(&pid->pid_chain,
+					&new->table[pid_hashfn(new, pid->nr)]);
+			goto again; /* XXX: no _safe variant */
+		}
+		spin_unlock_irq(&pidmap_lock);
+	}
+
+	return 1;
+}
+
+static int init_pid_hash(struct pid_hash *ph, unsigned int pidhash_shift);
+
+static void resize_pid_hash(void)
+{
+	unsigned int old_shift, new_shift;
+
+	if (system_state != SYSTEM_RUNNING)
+		return;
+
+	old_shift = cur_pid_hash->shift;
+	new_shift = ilog2(nr_pids * 2 - 1);
+	if (new_shift == old_shift)
+		return;
+
+	if (!mutex_trylock(&dyn_pidhash.resize_mutex))
+		return;
+
+	old_shift = cur_pid_hash->shift;
+	new_shift = ilog2(nr_pids * 2 - 1);
+	if (new_shift != old_shift) {
+		struct pid_hash *ph, *ret;
+		unsigned int idx = ph_cur_idx ^ 1;
+		ph = &pid_hashes[idx];
+		if (!init_pid_hash(ph, new_shift)) {
+			ph_cur_idx = idx;
+
+			ret = dyn_data_replace(&dyn_pidhash, dd_transfer_pids, ph);
+			BUG_ON(ret == ph);
+			BUG_ON(ret != &pid_hashes[idx ^ 1]);
+			/* XXX: kfree(ret->table) */
+			ret->shift = -1;
+			ret->table = NULL;
+		}
+	}
+	mutex_unlock(&dyn_pidhash.resize_mutex);
+}
+
 fastcall void free_pid(struct pid *pid)
 {
 	/* We can be called with write_lock_irq(&tasklist_lock) held */
 	unsigned long flags;
 
 	spin_lock_irqsave(&pidmap_lock, flags);
+	nr_pids--;
 	hlist_del_rcu(&pid->pid_chain);
 	spin_unlock_irqrestore(&pidmap_lock, flags);
 
 	free_pidmap(&init_pid_ns, pid->nr);
 	call_rcu(&pid->rcu, delayed_put_pid);
+
+//	if (nr_pids <= (1UL << cur_pid_hash->shift) / 2)
+//		resize_pid_hash();
 }
 
 struct pid *alloc_pid(void)
 {
+	struct pid_hash *ph;
 	struct pid *pid;
 	enum pid_type type;
 	int nr = -1;
@@ -223,9 +305,13 @@ struct pid *alloc_pid(void)
 		INIT_HLIST_HEAD(&pid->tasks[type]);
 
 	spin_lock_irq(&pidmap_lock);
-	hlist_add_head_rcu(&pid->pid_chain, &pid_hash[pid_hashfn(pid->nr)]);
+	nr_pids++;
+	ph = cur_pid_hash;
+	hlist_add_head_rcu(&pid->pid_chain, &ph->table[pid_hashfn(ph, nr)]);
 	spin_unlock_irq(&pidmap_lock);
 
+//	if (nr_pids >= 3 * (1UL << cur_pid_hash->shift) / 2)
+		resize_pid_hash();
 out:
 	return pid;
 
@@ -235,18 +321,25 @@ out_free:
 	goto out;
 }
 
-struct pid * fastcall find_pid(int nr)
+static void *dd_lookup_pid(void *dstruct, void *arg)
 {
+	struct pid_hash *ph = dstruct;
+	int nr = (unsigned long)arg;
 	struct hlist_node *elem;
 	struct pid *pid;
 
 	hlist_for_each_entry_rcu(pid, elem,
-			&pid_hash[pid_hashfn(nr)], pid_chain) {
+				&ph->table[pid_hashfn(ph, nr)], pid_chain) {
 		if (pid->nr == nr)
 			return pid;
 	}
 	return NULL;
 }
+
+struct pid * fastcall find_pid(int nr)
+{
+	return dyn_data_lookup(&dyn_pidhash, dd_lookup_pid, (void *)(unsigned long)nr);
+}
 EXPORT_SYMBOL_GPL(find_pid);
 
 /*
@@ -380,6 +473,28 @@ void free_pid_ns(struct kref *kref)
 	kfree(ns);
 }
 
+static int init_pid_hash(struct pid_hash *ph, unsigned int pidhash_shift)
+{
+	unsigned int i, pidhash_size;
+
+	ph->shift = pidhash_shift;
+	pidhash_size = 1 << pidhash_shift;
+
+	printk("PID hash table entries: %d (order: %d, %Zd bytes)\n",
+		pidhash_size, pidhash_shift,
+		pidhash_size * sizeof(struct hlist_head));
+
+	ph->table = kmalloc(pidhash_size * sizeof(struct hlist_head), GFP_KERNEL);
+	if (!ph->table) {
+		printk("Could not alloc pidhash!\n");
+		return -ENOMEM;
+	}
+	for (i = 0; i < pidhash_size; i++)
+		INIT_HLIST_HEAD(&ph->table[i]);
+
+	return 0;
+}
+
 /*
  * The pid hash table is scaled according to the amount of memory in the
  * machine.  From a minimum of 16 slots up to 4096 slots at one gigabyte or
@@ -387,22 +502,28 @@ void free_pid_ns(struct kref *kref)
  */
 void __init pidhash_init(void)
 {
-	int i, pidhash_size;
+	struct pid_hash *ph;
+	int i, pidhash_shift, pidhash_size;
 	unsigned long megabytes = nr_kernel_pages >> (20 - PAGE_SHIFT);
 
+	ph_cur_idx = 0;
+	ph = &pid_hashes[ph_cur_idx];
 	pidhash_shift = max(4, fls(megabytes * 4));
 	pidhash_shift = min(12, pidhash_shift);
+	ph->shift = pidhash_shift;
 	pidhash_size = 1 << pidhash_shift;
 
 	printk("PID hash table entries: %d (order: %d, %Zd bytes)\n",
 		pidhash_size, pidhash_shift,
 		pidhash_size * sizeof(struct hlist_head));
 
-	pid_hash = alloc_bootmem(pidhash_size *	sizeof(*(pid_hash)));
-	if (!pid_hash)
+	ph->table = alloc_bootmem(pidhash_size * sizeof(struct hlist_head));
+	if (!ph->table)
 		panic("Could not alloc pidhash!\n");
 	for (i = 0; i < pidhash_size; i++)
-		INIT_HLIST_HEAD(&pid_hash[i]);
+		INIT_HLIST_HEAD(&ph->table[i]);
+
+	dyn_data_init(&dyn_pidhash, ph);
 }
 
 void __init pidmap_init(void)
