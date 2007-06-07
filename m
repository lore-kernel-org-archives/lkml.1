Return-Path: <linux-kernel-owner+w=401wt.eu-S1764426AbXFGQvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764426AbXFGQvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760768AbXFGQvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:51:16 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46434 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbXFGQvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:51:13 -0400
Message-Id: <20070607165555.155173000@bull.net>
References: <20070607165302.917616000@bull.net>
User-Agent: quilt/0.45-1
Date: Thu, 07 Jun 2007 18:53:03 +0200
From: Nadia.Derbey@bull.net
To: linux-kernel@vger.kernel.org
Cc: ebiederm@xmission.com, ak@suse.de, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [RFC][PATCH 1/6] Storing ipcs into radix trees
Content-Disposition: inline; filename=ipc_radix_tree.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 01/06]


This patch introduces ipcs storage into radix trees. The main changes are:
  . This ipc_ids structure is changed: the entries array is changed into a
    root radix_tree structure.
  . The grow_ary() routine is removed: it is not needed anymore when adding
    an ipc structure, due to radix trees introduction


Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>


---
 include/linux/ipc.h |    1 
 include/linux/msg.h |    1 
 include/linux/sem.h |    1 
 include/linux/shm.h |    1 
 ipc/msg.c           |   64 ++++++-------
 ipc/sem.c           |   63 ++++++------
 ipc/shm.c           |   63 ++++++------
 ipc/util.c          |  253 ++++++++++++++++++++++++++++------------------------
 ipc/util.h          |   30 +-----
 9 files changed, 248 insertions(+), 229 deletions(-)

Index: linux-2.6.21/ipc/util.h
===================================================================
--- linux-2.6.21.orig/ipc/util.h	2007-06-07 11:00:30.000000000 +0200
+++ linux-2.6.21/ipc/util.h	2007-06-07 11:07:22.000000000 +0200
@@ -13,6 +13,8 @@
 #define USHRT_MAX 0xffff
 #define SEQ_MULTIPLIER	(IPCMNI)
 
+#define IPCS_MAX_SCAN_ENTRIES 256
+
 void sem_init (void);
 void msg_init (void);
 void shm_init (void);
@@ -25,19 +27,15 @@ void sem_exit_ns(struct ipc_namespace *n
 void msg_exit_ns(struct ipc_namespace *ns);
 void shm_exit_ns(struct ipc_namespace *ns);
 
-struct ipc_id_ary {
-	int size;
-	struct kern_ipc_perm *p[0];
-};
-
 struct ipc_ids {
 	int in_use;
 	int max_id;
+	int first_free;
 	unsigned short seq;
 	unsigned short seq_max;
 	struct mutex mutex;
-	struct ipc_id_ary nullentry;
-	struct ipc_id_ary* entries;
+	struct radix_tree_root id_tree;
+	DECLARE_BITMAP(in_use_bitmap, IPCMNI);
 };
 
 struct seq_file;
@@ -46,7 +44,7 @@ struct seq_file;
 #else
 #define __ipc_init	__init
 #endif
-void __ipc_init ipc_init_ids(struct ipc_ids *ids, int size);
+void __ipc_init ipc_init_ids(struct ipc_ids *);
 #ifdef CONFIG_PROC_FS
 void __init ipc_init_proc_interface(const char *path, const char *header,
 		int ids, int (*show)(struct seq_file *, void *));
@@ -59,8 +57,8 @@ void __init ipc_init_proc_interface(cons
 #define IPC_SHM_IDS	2
 
 /* must be called with ids->mutex acquired.*/
-int ipc_findkey(struct ipc_ids* ids, key_t key);
-int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size);
+struct kern_ipc_perm *ipc_findkey(struct ipc_ids *, key_t);
+int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int);
 
 /* must be called with both locks acquired. */
 struct kern_ipc_perm* ipc_rmid(struct ipc_ids* ids, int id);
@@ -83,18 +81,6 @@ void* ipc_rcu_alloc(int size);
 void ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
-static inline void __ipc_fini_ids(struct ipc_ids *ids,
-		struct ipc_id_ary *entries)
-{
-	if (entries != &ids->nullentry)
-		ipc_rcu_putref(entries);
-}
-
-static inline void ipc_fini_ids(struct ipc_ids *ids)
-{
-	__ipc_fini_ids(ids, ids->entries);
-}
-
 struct kern_ipc_perm* ipc_get(struct ipc_ids* ids, int id);
 struct kern_ipc_perm* ipc_lock(struct ipc_ids* ids, int id);
 void ipc_lock_by_ptr(struct kern_ipc_perm *ipcp);
Index: linux-2.6.21/ipc/util.c
===================================================================
--- linux-2.6.21.orig/ipc/util.c	2007-06-07 11:00:30.000000000 +0200
+++ linux-2.6.21/ipc/util.c	2007-06-07 11:29:43.000000000 +0200
@@ -33,6 +33,7 @@
 #include <linux/proc_fs.h>
 #include <linux/audit.h>
 #include <linux/nsproxy.h>
+#include <linux/radix-tree.h>
 
 #include <asm/unistd.h>
 
@@ -51,6 +52,8 @@ struct ipc_namespace init_ipc_ns = {
 	},
 };
 
+static void ipc_set_max_id(struct ipc_ids *);
+
 #ifdef CONFIG_IPC_NS
 static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
 {
@@ -172,23 +175,18 @@ __initcall(ipc_init);
 /**
  *	ipc_init_ids		-	initialise IPC identifiers
  *	@ids: Identifier set
- *	@size: Number of identifiers
  *
- *	Given a size for the ipc identifier range (limited below IPCMNI)
- *	set up the sequence range to use then allocate and initialise the
- *	array itself. 
+ *	Set up the sequence range to use for the ipc identifier range (limited
+ *	below IPCMNI) then initialise the ids radix tree.
  */
  
-void __ipc_init ipc_init_ids(struct ipc_ids* ids, int size)
+void __ipc_init ipc_init_ids(struct ipc_ids *ids)
 {
-	int i;
-
 	mutex_init(&ids->mutex);
 
-	if(size > IPCMNI)
-		size = IPCMNI;
 	ids->in_use = 0;
 	ids->max_id = -1;
+	ids->first_free = 0;
 	ids->seq = 0;
 	{
 		int seq_limit = INT_MAX/SEQ_MULTIPLIER;
@@ -198,17 +196,8 @@ void __ipc_init ipc_init_ids(struct ipc_
 		 	ids->seq_max = seq_limit;
 	}
 
-	ids->entries = ipc_rcu_alloc(sizeof(struct kern_ipc_perm *)*size +
-				     sizeof(struct ipc_id_ary));
-
-	if(ids->entries == NULL) {
-		printk(KERN_ERR "ipc_init_ids() failed, ipc service disabled.\n");
-		size = 0;
-		ids->entries = &ids->nullentry;
-	}
-	ids->entries->size = size;
-	for(i=0;i<size;i++)
-		ids->entries->p[i] = NULL;
+	INIT_RADIX_TREE(&ids->id_tree, GFP_KERNEL);
+	bitmap_zero(ids->in_use_bitmap, IPCMNI);
 }
 
 #ifdef CONFIG_PROC_FS
@@ -252,72 +241,94 @@ void __init ipc_init_proc_interface(cons
  *	@key: The key to find
  *	
  *	Requires ipc_ids.mutex locked.
- *	Returns the identifier if found or -1 if not.
+ *	Returns the LOCKED pointer to the ipc structure if found or NULL
+ *	if not.
+ *      If key is found ipc contains its ipc structure
  */
  
-int ipc_findkey(struct ipc_ids* ids, key_t key)
+struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key)
 {
-	int id;
-	struct kern_ipc_perm* p;
-	int max_id = ids->max_id;
+	struct kern_ipc_perm *ipc;
+	struct kern_ipc_perm *ipcs[IPCS_MAX_SCAN_ENTRIES];
+	int next_id;
+	int nb_ipcs, i;
+	int total;
+
+	next_id = 0;
+	for (total = 0; total < ids->in_use; total += nb_ipcs) {
+		nb_ipcs = radix_tree_gang_lookup(&ids->id_tree,
+			(void **) ipcs, next_id, IPCS_MAX_SCAN_ENTRIES);
+		if (nb_ipcs <= 0)
+			return NULL;
+		for (i = 0; i < nb_ipcs; i++) {
+			ipc = ipcs[i];
+			if (ipc->key == key) {
+				ipc_lock_by_ptr(ipc);
+				BUG_ON(ipc->key != key);
+				return ipc;
+			}
+		}
 
-	/*
-	 * rcu_dereference() is not needed here
-	 * since ipc_ids.mutex is held
-	 */
-	for (id = 0; id <= max_id; id++) {
-		p = ids->entries->p[id];
-		if(p==NULL)
-			continue;
-		if (key == p->key)
-			return id;
+		/* prepare for next id gang lookup */
+		next_id = (ipcs[nb_ipcs - 1]->id % SEQ_MULTIPLIER) + 1;
 	}
-	return -1;
+
+	return NULL;
 }
 
-/*
- * Requires ipc_ids.mutex locked
+/**
+ *	ipc_set_max_id 	-	set the last assigned id
+ *	@ids: IPC identifier set
+ *
+ *	Sets the new value for ids->max_id after max_id has been removed
+ *	during ipc_rmid().
+ *	When this routine is called ids->in_use has already been updated.
+ *
+ *	Called with ipc_ids.mutex held.
  */
-static int grow_ary(struct ipc_ids* ids, int newsize)
+
+static void ipc_set_max_id(struct ipc_ids *ids)
 {
-	struct ipc_id_ary* new;
-	struct ipc_id_ary* old;
-	int i;
-	int size = ids->entries->size;
-
-	if(newsize > IPCMNI)
-		newsize = IPCMNI;
-	if(newsize <= size)
-		return newsize;
-
-	new = ipc_rcu_alloc(sizeof(struct kern_ipc_perm *)*newsize +
-			    sizeof(struct ipc_id_ary));
-	if(new == NULL)
-		return size;
-	new->size = newsize;
-	memcpy(new->p, ids->entries->p, sizeof(struct kern_ipc_perm *)*size);
-	for(i=size;i<newsize;i++) {
-		new->p[i] = NULL;
+	unsigned long next_bit;
+	unsigned long next_zero;
+
+
+	if (ids->in_use == 0) {
+		ids->max_id = -1;
+		return;
 	}
-	old = ids->entries;
 
-	/*
-	 * Use rcu_assign_pointer() to make sure the memcpyed contents
-	 * of the new array are visible before the new array becomes visible.
-	 */
-	rcu_assign_pointer(ids->entries, new);
+	if (ids->in_use == ids->max_id) {
+		/* No hole in the ids */
+		ids->max_id--;
+		return;
+	}
 
-	__ipc_fini_ids(ids, old);
-	return newsize;
+	/* Look for the last assigned id */
+	next_bit = find_first_bit(ids->in_use_bitmap, ids->max_id);
+
+	do {
+		next_zero = find_next_zero_bit(ids->in_use_bitmap,
+						ids->max_id, next_bit);
+		if (next_zero >= ids->max_id) {
+			ids->max_id--;
+			return;
+		} else
+			next_bit = find_next_bit(ids->in_use_bitmap,
+					ids->max_id, next_zero);
+	} while (next_bit < ids->max_id);
+
+	ids->max_id = next_zero - 1;
+	return;
 }
 
 /**
  *	ipc_addid 	-	add an IPC identifier
  *	@ids: IPC identifier set
  *	@new: new IPC permission set
- *	@size: new size limit for the id array
+ *	@size: limit for the number of used ids
  *
- *	Add an entry 'new' to the IPC arrays. The permissions object is
+ *	Add an entry 'new' to the IPC radix tree. The permissions object is
  *	initialised and the first free entry is set up and the id assigned
  *	is returned. The list is returned in a locked state on success.
  *	On failure the list is not locked and -1 is returned.
@@ -329,22 +340,33 @@ int ipc_addid(struct ipc_ids* ids, struc
 {
 	int id;
 
-	size = grow_ary(ids,size);
-
 	/*
 	 * rcu_dereference()() is not needed here since
 	 * ipc_ids.mutex is held
 	 */
-	for (id = 0; id < size; id++) {
-		if(ids->entries->p[id] == NULL)
-			goto found;
-	}
-	return -1;
-found:
+	if (size > IPCMNI)
+		size = IPCMNI;
+
+	if (ids->in_use >= size)
+		return -1;
+
+	id = ids->first_free;
+
+	if (radix_tree_insert(&ids->id_tree, id, new))
+		return -1;
+
+	set_bit(id, ids->in_use_bitmap);
 	ids->in_use++;
 	if (id > ids->max_id)
 		ids->max_id = id;
 
+	if (ids->in_use == ids->max_id + 1) {
+		/* No hole in the ids */
+		ids->first_free = ids->in_use;
+	} else
+		ids->first_free = find_next_zero_bit(ids->in_use_bitmap,
+			ids->max_id, id);
+
 	new->cuid = new->uid = current->euid;
 	new->gid = new->cgid = current->egid;
 
@@ -356,7 +378,6 @@ found:
 	new->deleted = 0;
 	rcu_read_lock();
 	spin_lock(&new->lock);
-	ids->entries->p[id] = new;
 	return id;
 }
 
@@ -377,26 +398,27 @@ struct kern_ipc_perm* ipc_rmid(struct ip
 {
 	struct kern_ipc_perm* p;
 	int lid = id % SEQ_MULTIPLIER;
-	BUG_ON(lid >= ids->entries->size);
+	BUG_ON(lid > ids->max_id);
 
 	/* 
 	 * do not need a rcu_dereference()() here to force ordering
 	 * on Alpha, since the ipc_ids.mutex is held.
 	 */	
-	p = ids->entries->p[lid];
-	ids->entries->p[lid] = NULL;
-	BUG_ON(p==NULL);
+	p = radix_tree_delete(&ids->id_tree, lid);
+	BUG_ON(p == NULL);
+
+	BUG_ON(ids->in_use <= 0);
 	ids->in_use--;
 
-	if (lid == ids->max_id) {
-		do {
-			lid--;
-			if(lid == -1)
-				break;
-		} while (ids->entries->p[lid] == NULL);
-		ids->max_id = lid;
-	}
+	clear_bit(lid, ids->in_use_bitmap);
+	if (lid < ids->first_free)
+		ids->first_free = lid;
+
+	if (lid == ids->max_id)
+		ipc_set_max_id(ids);
+
 	p->deleted = 1;
+
 	return p;
 }
 
@@ -492,6 +514,7 @@ static inline int rcu_use_vmalloc(int si
 void* ipc_rcu_alloc(int size)
 {
 	void* out;
+
 	/* 
 	 * We prepend the allocation with the rcu struct, and
 	 * workqueue if necessary (for vmalloc). 
@@ -660,9 +683,9 @@ struct kern_ipc_perm* ipc_get(struct ipc
 {
 	struct kern_ipc_perm* out;
 	int lid = id % SEQ_MULTIPLIER;
-	if(lid >= ids->entries->size)
+	if (lid > ids->max_id)
 		return NULL;
-	out = ids->entries->p[lid];
+	out = radix_tree_lookup(&ids->id_tree, lid);
 	return out;
 }
 
@@ -670,15 +693,13 @@ struct kern_ipc_perm* ipc_lock(struct ip
 {
 	struct kern_ipc_perm* out;
 	int lid = id % SEQ_MULTIPLIER;
-	struct ipc_id_ary* entries;
 
 	rcu_read_lock();
-	entries = rcu_dereference(ids->entries);
-	if(lid >= entries->size) {
+	if (lid > ids->max_id) {
 		rcu_read_unlock();
 		return NULL;
 	}
-	out = entries->p[lid];
+	out = radix_tree_lookup(&ids->id_tree, lid);
 	if(out == NULL) {
 		rcu_read_unlock();
 		return NULL;
@@ -755,8 +776,9 @@ static void *sysvipc_proc_next(struct se
 	struct ipc_proc_iter *iter = s->private;
 	struct ipc_proc_iface *iface = iter->iface;
 	struct kern_ipc_perm *ipc = it;
-	loff_t p;
 	struct ipc_ids *ids;
+	struct kern_ipc_perm *ipcs[1];
+	int nb_ipcs;
 
 	ids = iter->ns->ids[iface->ids];
 
@@ -764,19 +786,18 @@ static void *sysvipc_proc_next(struct se
 	if (ipc && ipc != SEQ_START_TOKEN)
 		ipc_unlock(ipc);
 
-	/*
-	 * p = *pos - 1 (because id 0 starts at position 1)
-	 *          + 1 (because we increment the position by one)
-	 */
-	for (p = *pos; p <= ids->max_id; p++) {
-		if ((ipc = ipc_lock(ids, p)) != NULL) {
-			*pos = p + 1;
-			return ipc;
-		}
-	}
+	nb_ipcs = radix_tree_gang_lookup(&ids->id_tree, (void **) ipcs,
+					*pos, 1);
 
 	/* Out of range - return NULL to terminate iteration */
-	return NULL;
+	if (nb_ipcs <= 0)
+		return NULL;
+
+	ipc = ipcs[0];
+	ipc_lock_by_ptr(ipc);
+	*pos = (ipc->id % SEQ_MULTIPLIER) + 1;
+
+	return ipc;
 }
 
 /*
@@ -788,8 +809,9 @@ static void *sysvipc_proc_start(struct s
 	struct ipc_proc_iter *iter = s->private;
 	struct ipc_proc_iface *iface = iter->iface;
 	struct kern_ipc_perm *ipc;
-	loff_t p;
 	struct ipc_ids *ids;
+	struct kern_ipc_perm *ipcs[1];
+	int nb_ipcs;
 
 	ids = iter->ns->ids[iface->ids];
 
@@ -808,13 +830,16 @@ static void *sysvipc_proc_start(struct s
 		return SEQ_START_TOKEN;
 
 	/* Find the (pos-1)th ipc */
-	for (p = *pos - 1; p <= ids->max_id; p++) {
-		if ((ipc = ipc_lock(ids, p)) != NULL) {
-			*pos = p + 1;
-			return ipc;
-		}
-	}
-	return NULL;
+	nb_ipcs = radix_tree_gang_lookup(&ids->id_tree, (void **) ipcs,
+					*pos - 1, 1);
+	if (nb_ipcs <= 0)
+		return NULL;
+
+	ipc = ipcs[0];
+	ipc_lock_by_ptr(ipc);
+	*pos = (ipc->id % SEQ_MULTIPLIER) + 1;
+
+	return ipc;
 }
 
 static void sysvipc_proc_stop(struct seq_file *s, void *it)
Index: linux-2.6.21/ipc/msg.c
===================================================================
--- linux-2.6.21.orig/ipc/msg.c	2007-06-07 11:00:30.000000000 +0200
+++ linux-2.6.21/ipc/msg.c	2007-06-07 11:28:16.000000000 +0200
@@ -93,7 +93,7 @@ static void __ipc_init __msg_init_ns(str
 	ns->msg_ctlmax = MSGMAX;
 	ns->msg_ctlmnb = MSGMNB;
 	ns->msg_ctlmni = MSGMNI;
-	ipc_init_ids(ids, ns->msg_ctlmni);
+	ipc_init_ids(ids);
 }
 
 #ifdef CONFIG_IPC_NS
@@ -124,7 +124,6 @@ void msg_exit_ns(struct ipc_namespace *n
 	}
 	mutex_unlock(&msg_ids(ns).mutex);
 
-	ipc_fini_ids(ns->ids[IPC_MSG_IDS]);
 	kfree(ns->ids[IPC_MSG_IDS]);
 	ns->ids[IPC_MSG_IDS] = NULL;
 }
@@ -164,7 +163,7 @@ static int newque (struct ipc_namespace 
 		return -ENOSPC;
 	}
 
-	msq->q_id = msg_buildid(ns, id, msq->q_perm.seq);
+	msq->q_perm.id = msg_buildid(ns, id, msq->q_perm.seq);
 	msq->q_stime = msq->q_rtime = 0;
 	msq->q_ctime = get_seconds();
 	msq->q_cbytes = msq->q_qnum = 0;
@@ -175,7 +174,7 @@ static int newque (struct ipc_namespace 
 	INIT_LIST_HEAD(&msq->q_senders);
 	msg_unlock(msq);
 
-	return msq->q_id;
+	return msq->q_perm.id;
 }
 
 static inline void ss_add(struct msg_queue *msq, struct msg_sender *mss)
@@ -227,9 +226,9 @@ static void expunge_all(struct msg_queue
 /*
  * freeque() wakes up waiters on the sender and receiver waiting queue,
  * removes the message queue from message queue ID
- * array, and cleans up all the messages associated with this queue.
+ * radix tree, and cleans up all the messages associated with this queue.
  *
- * msg_ids.mutex and the spinlock for this message queue is hold
+ * msg_ids.mutex and the spinlock for this message queue are held
  * before freeque() is called. msg_ids.mutex remains locked on exit.
  */
 static void freeque(struct ipc_namespace *ns, struct msg_queue *msq, int id)
@@ -257,7 +256,7 @@ static void freeque(struct ipc_namespace
 asmlinkage long sys_msgget(key_t key, int msgflg)
 {
 	struct msg_queue *msq;
-	int id, ret = -EPERM;
+	int ret = -EPERM;
 	struct ipc_namespace *ns;
 
 	ns = current->nsproxy->ipc_ns;
@@ -265,26 +264,31 @@ asmlinkage long sys_msgget(key_t key, in
 	mutex_lock(&msg_ids(ns).mutex);
 	if (key == IPC_PRIVATE) 
 		ret = newque(ns, key, msgflg);
-	else if ((id = ipc_findkey(&msg_ids(ns), key)) == -1) { /* key not used */
-		if (!(msgflg & IPC_CREAT))
-			ret = -ENOENT;
-		else
-			ret = newque(ns, key, msgflg);
-	} else if (msgflg & IPC_CREAT && msgflg & IPC_EXCL) {
-		ret = -EEXIST;
-	} else {
-		msq = msg_lock(ns, id);
-		BUG_ON(msq == NULL);
-		if (ipcperms(&msq->q_perm, msgflg))
-			ret = -EACCES;
-		else {
-			int qid = msg_buildid(ns, id, msq->q_perm.seq);
+	else  {
+		msq = (struct msg_queue *) ipc_findkey(&msg_ids(ns), key);
+		if (msq == NULL) {
+			/* key not used */
+			if (!(msgflg & IPC_CREAT))
+				ret = -ENOENT;
+			else
+				ret = newque(ns, key, msgflg);
+		} else {
+			/* msq has been locked by ipc_findkey() */
 
-			ret = security_msg_queue_associate(msq, msgflg);
-			if (!ret)
-				ret = qid;
+			if (msgflg & IPC_CREAT && msgflg & IPC_EXCL)
+				ret = -EEXIST;
+			else {
+				if (ipcperms(&msq->q_perm, msgflg))
+					ret = -EACCES;
+				else {
+					ret = security_msg_queue_associate(
+								msq, msgflg);
+					if (!ret)
+						ret = msq->q_perm.id;
+				}
+			}
+			msg_unlock(msq);
 		}
-		msg_unlock(msq);
 	}
 	mutex_unlock(&msg_ids(ns).mutex);
 
@@ -446,7 +450,7 @@ asmlinkage long sys_msgctl(int msqid, in
 
 		if (!buf)
 			return -EFAULT;
-		if (cmd == MSG_STAT && msqid >= msg_ids(ns).entries->size)
+		if (cmd == MSG_STAT && msqid > msg_ids(ns).max_id)
 			return -EINVAL;
 
 		memset(&tbuf, 0, sizeof(tbuf));
@@ -455,9 +459,9 @@ asmlinkage long sys_msgctl(int msqid, in
 		if (msq == NULL)
 			return -EINVAL;
 
-		if (cmd == MSG_STAT) {
-			success_return = msg_buildid(ns, msqid, msq->q_perm.seq);
-		} else {
+		if (cmd == MSG_STAT)
+			success_return = msq->q_perm.id;
+		else {
 			err = -EIDRM;
 			if (msg_checkid(ns, msq, msqid))
 				goto out_unlock;
@@ -928,7 +932,7 @@ static int sysvipc_msg_proc_show(struct 
 	return seq_printf(s,
 			"%10d %10d  %4o  %10lu %10lu %5u %5u %5u %5u %5u %5u %10lu %10lu %10lu\n",
 			msq->q_perm.key,
-			msq->q_id,
+			msq->q_perm.id,
 			msq->q_perm.mode,
 			msq->q_cbytes,
 			msq->q_qnum,
Index: linux-2.6.21/ipc/sem.c
===================================================================
--- linux-2.6.21.orig/ipc/sem.c	2007-06-07 11:00:30.000000000 +0200
+++ linux-2.6.21/ipc/sem.c	2007-06-07 11:25:20.000000000 +0200
@@ -130,7 +130,7 @@ static void __ipc_init __sem_init_ns(str
 	ns->sc_semopm = SEMOPM;
 	ns->sc_semmni = SEMMNI;
 	ns->used_sems = 0;
-	ipc_init_ids(ids, ns->sc_semmni);
+	ipc_init_ids(ids);
 }
 
 #ifdef CONFIG_IPC_NS
@@ -161,7 +161,6 @@ void sem_exit_ns(struct ipc_namespace *n
 	}
 	mutex_unlock(&sem_ids(ns).mutex);
 
-	ipc_fini_ids(ns->ids[IPC_SEM_IDS]);
 	kfree(ns->ids[IPC_SEM_IDS]);
 	ns->ids[IPC_SEM_IDS] = NULL;
 }
@@ -246,7 +245,7 @@ static int newary (struct ipc_namespace 
 	}
 	ns->used_sems += nsems;
 
-	sma->sem_id = sem_buildid(ns, id, sma->sem_perm.seq);
+	sma->sem_perm.id = sem_buildid(ns, id, sma->sem_perm.seq);
 	sma->sem_base = (struct sem *) &sma[1];
 	/* sma->sem_pending = NULL; */
 	sma->sem_pending_last = &sma->sem_pending;
@@ -255,12 +254,12 @@ static int newary (struct ipc_namespace 
 	sma->sem_ctime = get_seconds();
 	sem_unlock(sma);
 
-	return sma->sem_id;
+	return sma->sem_perm.id;
 }
 
 asmlinkage long sys_semget (key_t key, int nsems, int semflg)
 {
-	int id, err = -EINVAL;
+	int err = -EINVAL;
 	struct sem_array *sma;
 	struct ipc_namespace *ns;
 
@@ -272,27 +271,33 @@ asmlinkage long sys_semget (key_t key, i
 	
 	if (key == IPC_PRIVATE) {
 		err = newary(ns, key, nsems, semflg);
-	} else if ((id = ipc_findkey(&sem_ids(ns), key)) == -1) {  /* key not used */
-		if (!(semflg & IPC_CREAT))
-			err = -ENOENT;
-		else
-			err = newary(ns, key, nsems, semflg);
-	} else if (semflg & IPC_CREAT && semflg & IPC_EXCL) {
-		err = -EEXIST;
 	} else {
-		sma = sem_lock(ns, id);
-		BUG_ON(sma==NULL);
-		if (nsems > sma->sem_nsems)
-			err = -EINVAL;
-		else if (ipcperms(&sma->sem_perm, semflg))
-			err = -EACCES;
-		else {
-			int semid = sem_buildid(ns, id, sma->sem_perm.seq);
-			err = security_sem_associate(sma, semflg);
-			if (!err)
-				err = semid;
+		sma = (struct sem_array *) ipc_findkey(&sem_ids(ns), key);
+		if (sma == NULL) {
+			/* key not used */
+			if (!(semflg & IPC_CREAT))
+				err = -ENOENT;
+			else
+				err = newary(ns, key, nsems, semflg);
+		} else {
+			/* sma has been locked by ipc_findkey() */
+
+			if (semflg & IPC_CREAT && semflg & IPC_EXCL)
+				err = -EEXIST;
+			else {
+				if (nsems > sma->sem_nsems)
+					err = -EINVAL;
+				else if (ipcperms(&sma->sem_perm, semflg))
+					err = -EACCES;
+				else {
+					err = security_sem_associate(sma,
+								semflg);
+					if (!err)
+						err = sma->sem_perm.id;
+				}
+			}
+			sem_unlock(sma);
 		}
-		sem_unlock(sma);
 	}
 
 	mutex_unlock(&sem_ids(ns).mutex);
@@ -498,7 +503,6 @@ static void freeary (struct ipc_namespac
 {
 	struct sem_undo *un;
 	struct sem_queue *q;
-	int size;
 
 	/* Invalidate the existing undo structures for this semaphore set.
 	 * (They will be freed without any further action in exit_sem()
@@ -521,12 +525,11 @@ static void freeary (struct ipc_namespac
 		q = n;
 	}
 
-	/* Remove the semaphore set from the ID array*/
+	/* Remove the semaphore set from the ID radix tree */
 	sma = sem_rmid(ns, id);
 	sem_unlock(sma);
 
 	ns->used_sems -= sma->sem_nsems;
-	size = sizeof (*sma) + sma->sem_nsems * sizeof (struct sem);
 	security_sem_free(sma);
 	ipc_rcu_putref(sma);
 }
@@ -598,7 +601,7 @@ static int semctl_nolock(struct ipc_name
 		struct semid64_ds tbuf;
 		int id;
 
-		if(semid >= sem_ids(ns).entries->size)
+		if (semid > sem_ids(ns).max_id)
 			return -EINVAL;
 
 		memset(&tbuf,0,sizeof(tbuf));
@@ -615,7 +618,7 @@ static int semctl_nolock(struct ipc_name
 		if (err)
 			goto out_unlock;
 
-		id = sem_buildid(ns, semid, sma->sem_perm.seq);
+		id = sma->sem_perm.id;
 
 		kernel_to_ipc64_perm(&sma->sem_perm, &tbuf.sem_perm);
 		tbuf.sem_otime  = sma->sem_otime;
@@ -1405,7 +1408,7 @@ static int sysvipc_sem_proc_show(struct 
 	return seq_printf(s,
 			  "%10d %10d  %4o %10lu %5u %5u %5u %5u %10lu %10lu\n",
 			  sma->sem_perm.key,
-			  sma->sem_id,
+			  sma->sem_perm.id,
 			  sma->sem_perm.mode,
 			  sma->sem_nsems,
 			  sma->sem_perm.uid,
Index: linux-2.6.21/ipc/shm.c
===================================================================
--- linux-2.6.21.orig/ipc/shm.c	2007-06-07 11:00:30.000000000 +0200
+++ linux-2.6.21/ipc/shm.c	2007-06-07 11:20:50.000000000 +0200
@@ -84,7 +84,7 @@ static void __ipc_init __shm_init_ns(str
 	ns->shm_ctlall = SHMALL;
 	ns->shm_ctlmni = SHMMNI;
 	ns->shm_tot = 0;
-	ipc_init_ids(ids, 1);
+	ipc_init_ids(ids);
 }
 
 static void do_shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *shp)
@@ -126,7 +126,6 @@ void shm_exit_ns(struct ipc_namespace *n
 	}
 	mutex_unlock(&shm_ids(ns).mutex);
 
-	ipc_fini_ids(ns->ids[IPC_SHM_IDS]);
 	kfree(ns->ids[IPC_SHM_IDS]);
 	ns->ids[IPC_SHM_IDS] = NULL;
 }
@@ -186,7 +185,7 @@ static void shm_open(struct vm_area_stru
 static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
 {
 	ns->shm_tot -= (shp->shm_segsz + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	shm_rmid(ns, shp->id);
+	shm_rmid(ns, shp->shm_perm.id);
 	shm_unlock(shp);
 	if (!is_file_hugepages(shp->shm_file))
 		shmem_lock(shp->shm_file, 0, shp->mlock_user);
@@ -395,12 +394,13 @@ static int newseg (struct ipc_namespace 
 	shp->shm_ctim = get_seconds();
 	shp->shm_segsz = size;
 	shp->shm_nattch = 0;
-	shp->id = shm_buildid(ns, id, shp->shm_perm.seq);
+	shp->shm_perm.id = shm_buildid(ns, id, shp->shm_perm.seq);
 	shp->shm_file = file;
 
 	ns->shm_tot += numpages;
+	error = shp->shm_perm.id;
 	shm_unlock(shp);
-	return shp->id;
+	return error;
 
 no_id:
 	fput(file);
@@ -413,7 +413,7 @@ no_file:
 asmlinkage long sys_shmget (key_t key, size_t size, int shmflg)
 {
 	struct shmid_kernel *shp;
-	int err, id = 0;
+	int err;
 	struct ipc_namespace *ns;
 
 	ns = current->nsproxy->ipc_ns;
@@ -421,27 +421,32 @@ asmlinkage long sys_shmget (key_t key, s
 	mutex_lock(&shm_ids(ns).mutex);
 	if (key == IPC_PRIVATE) {
 		err = newseg(ns, key, shmflg, size);
-	} else if ((id = ipc_findkey(&shm_ids(ns), key)) == -1) {
-		if (!(shmflg & IPC_CREAT))
-			err = -ENOENT;
-		else
-			err = newseg(ns, key, shmflg, size);
-	} else if ((shmflg & IPC_CREAT) && (shmflg & IPC_EXCL)) {
-		err = -EEXIST;
 	} else {
-		shp = shm_lock(ns, id);
-		BUG_ON(shp==NULL);
-		if (shp->shm_segsz < size)
-			err = -EINVAL;
-		else if (ipcperms(&shp->shm_perm, shmflg))
-			err = -EACCES;
-		else {
-			int shmid = shm_buildid(ns, id, shp->shm_perm.seq);
-			err = security_shm_associate(shp, shmflg);
-			if (!err)
-				err = shmid;
+		shp = (struct shmid_kernel *) ipc_findkey(&shm_ids(ns), key);
+		if (shp == NULL) {
+			if (!(shmflg & IPC_CREAT))
+				err = -ENOENT;
+			else
+				err = newseg(ns, key, shmflg, size);
+		} else {
+			/* shp has been locked by ipc_findkey() */
+
+			if ((shmflg & IPC_CREAT) && (shmflg & IPC_EXCL))
+				err = -EEXIST;
+			else {
+				if (shp->shm_segsz < size)
+					err = -EINVAL;
+				else if (ipcperms(&shp->shm_perm, shmflg))
+					err = -EACCES;
+				else {
+					err = security_shm_associate(shp,
+								shmflg);
+					if (!err)
+						err = shp->shm_perm.id;
+				}
+			}
+			shm_unlock(shp);
 		}
-		shm_unlock(shp);
 	}
 	mutex_unlock(&shm_ids(ns).mutex);
 
@@ -645,9 +650,7 @@ asmlinkage long sys_shmctl (int shmid, i
 			goto out;
 		} else if(cmd==SHM_STAT) {
 			err = -EINVAL;
-			if (shmid > shm_ids(ns).max_id)
-				goto out_unlock;
-			result = shm_buildid(ns, shmid, shp->shm_perm.seq);
+			result = shp->shm_perm.id;
 		} else {
 			err = shm_checkid(ns, shp,shmid);
 			if(err)
@@ -919,7 +922,7 @@ long do_shmat(int shmid, char __user *sh
 	file->f_path = path;
 	file->f_mapping = shp->shm_file->f_mapping;
 	file->f_mode = f_mode;
-	sfd->id = shp->id;
+	sfd->id = shp->shm_perm.id;
 	sfd->ns = get_ipc_ns(ns);
 	sfd->file = shp->shm_file;
 	sfd->vm_ops = NULL;
@@ -1089,7 +1092,7 @@ static int sysvipc_shm_proc_show(struct 
 		format = BIG_STRING;
 	return seq_printf(s, format,
 			  shp->shm_perm.key,
-			  shp->id,
+			  shp->shm_perm.id,
 			  shp->shm_perm.mode,
 			  shp->shm_segsz,
 			  shp->shm_cprid,
Index: linux-2.6.21/include/linux/ipc.h
===================================================================
--- linux-2.6.21.orig/include/linux/ipc.h	2007-06-07 11:00:29.000000000 +0200
+++ linux-2.6.21/include/linux/ipc.h	2007-06-07 11:14:20.000000000 +0200
@@ -60,6 +60,7 @@ struct kern_ipc_perm
 {
 	spinlock_t	lock;
 	int		deleted;
+	int		id;
 	key_t		key;
 	uid_t		uid;
 	gid_t		gid;
Index: linux-2.6.21/include/linux/sem.h
===================================================================
--- linux-2.6.21.orig/include/linux/sem.h	2007-06-07 11:00:29.000000000 +0200
+++ linux-2.6.21/include/linux/sem.h	2007-06-07 11:15:16.000000000 +0200
@@ -90,7 +90,6 @@ struct sem {
 /* One sem_array data structure for each set of semaphores in the system. */
 struct sem_array {
 	struct kern_ipc_perm	sem_perm;	/* permissions .. see ipc.h */
-	int			sem_id;
 	time_t			sem_otime;	/* last semop time */
 	time_t			sem_ctime;	/* last change time */
 	struct sem		*sem_base;	/* ptr to first semaphore in array */
Index: linux-2.6.21/include/linux/shm.h
===================================================================
--- linux-2.6.21.orig/include/linux/shm.h	2007-06-07 11:00:29.000000000 +0200
+++ linux-2.6.21/include/linux/shm.h	2007-06-07 11:16:06.000000000 +0200
@@ -77,7 +77,6 @@ struct shmid_kernel /* private to the ke
 {	
 	struct kern_ipc_perm	shm_perm;
 	struct file *		shm_file;
-	int			id;
 	unsigned long		shm_nattch;
 	unsigned long		shm_segsz;
 	time_t			shm_atim;
Index: linux-2.6.21/include/linux/msg.h
===================================================================
--- linux-2.6.21.orig/include/linux/msg.h	2007-06-07 11:00:29.000000000 +0200
+++ linux-2.6.21/include/linux/msg.h	2007-06-07 11:16:31.000000000 +0200
@@ -77,7 +77,6 @@ struct msg_msg {
 /* one msq_queue structure for each present queue on the system */
 struct msg_queue {
 	struct kern_ipc_perm q_perm;
-	int q_id;
 	time_t q_stime;			/* last msgsnd time */
 	time_t q_rtime;			/* last msgrcv time */
 	time_t q_ctime;			/* last change time */

--
