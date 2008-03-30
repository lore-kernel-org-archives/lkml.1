Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYC3Uux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYC3Uux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 16:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbYC3Uun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 16:50:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:5211 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbYC3Uum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 16:50:42 -0400
Message-ID: <47EFFD1C.5020204@colorfullife.com>
Date: Sun, 30 Mar 2008 22:50:36 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: [RFC, PATCH] fix SEM_UNDO with namespaces
Content-Type: multipart/mixed;
 boundary="------------070407000604090609070507"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070407000604090609070507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

the attached patch should fix the combination of CLONE_NEWIPC with 
shared sysv undo structures (the common case, just 
sys_unshare(CLONE_NEWIPC)):
lookup_undo() now locates the undo array based on both semid and the 
namespace pointer.
Additionally, the patch tries to clean the code up by using the linked 
list macros from <linux/list.h> instead of single linked lists.

The patch passes a few quick tests, I'm interested in feedback. Are 
there test apps for testing the IPC namespace code?

--
    Manfred

--------------070407000604090609070507
Content-Type: text/plain;
 name="patch-semundo-namespace"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-semundo-namespace"

diff --git a/include/linux/sem.h b/include/linux/sem.h
index c8eaad9..8c110ec 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -95,7 +95,7 @@ struct sem_array {
 	struct sem		*sem_base;	/* ptr to first semaphore in array */
 	struct sem_queue	*sem_pending;	/* pending operations to be processed */
 	struct sem_queue	**sem_pending_last; /* last pending operation */
-	struct sem_undo		*undo;		/* undo requests on this array */
+	struct list_head	list_id;	/* undo requests on this array */
 	unsigned long		sem_nsems;	/* no. of semaphores in array */
 };
 
@@ -118,9 +118,10 @@ struct sem_queue {
  * when the process exits.
  */
 struct sem_undo {
-	struct sem_undo *	proc_next;	/* next entry on this process */
-	struct sem_undo *	id_next;	/* next entry on this semaphore set */
+	struct list_head	list_proc;	/* per-process list: all undos from one process */
+	struct list_head	list_id;	/* per semaphore array list: all undos for one array */
 	int			semid;		/* semaphore set identifier */
+	struct ipc_namespace	*ns;		/* namespace */
 	short *			semadj;		/* array of adjustments, one per semaphore */
 };
 
@@ -128,9 +129,9 @@ struct sem_undo {
  * that may be shared among all a CLONE_SYSVSEM task group.
  */ 
 struct sem_undo_list {
-	atomic_t	refcnt;
-	spinlock_t	lock;
-	struct sem_undo	*proc_list;
+	atomic_t		refcnt;
+	spinlock_t		lock;
+	struct list_head	list_proc;
 };
 
 struct sysv_sem {
diff --git a/ipc/sem.c b/ipc/sem.c
index 0b45a4d..2986817 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -272,7 +272,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	sma->sem_base = (struct sem *) &sma[1];
 	/* sma->sem_pending = NULL; */
 	sma->sem_pending_last = &sma->sem_pending;
-	/* sma->undo = NULL; */
+	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
 	sma->sem_ctime = get_seconds();
 	sem_unlock(sma);
@@ -534,7 +534,8 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	 * (They will be freed without any further action in exit_sem()
 	 * or during the next semop.)
 	 */
-	for (un = sma->undo; un; un = un->id_next)
+	assert_spin_locked(&sma->sem_perm.lock);
+	list_for_each_entry(un, &sma->list_id, list_id)
 		un->semid = -1;
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
@@ -773,9 +774,12 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 
 		for (i = 0; i < nsems; i++)
 			sma->sem_base[i].semval = sem_io[i];
-		for (un = sma->undo; un; un = un->id_next)
+
+		assert_spin_locked(&sma->sem_perm.lock);
+		list_for_each_entry(un, &sma->list_id, list_id) {
 			for (i = 0; i < nsems; i++)
 				un->semadj[i] = 0;
+		}
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
 		update_queue(sma);
@@ -807,12 +811,15 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 	{
 		int val = arg.val;
 		struct sem_undo *un;
+
 		err = -ERANGE;
 		if (val > SEMVMX || val < 0)
 			goto out_unlock;
 
-		for (un = sma->undo; un; un = un->id_next)
+		assert_spin_locked(&sma->sem_perm.lock);
+		list_for_each_entry(un, &sma->list_id, list_id)
 			un->semadj[semnum] = 0;
+
 		curr->semval = val;
 		curr->sempid = task_tgid_vnr(current);
 		sma->sem_ctime = get_seconds();
@@ -994,33 +1001,40 @@ static inline int get_undo_list(struct sem_undo_list **undo_listp)
 			return -ENOMEM;
 		spin_lock_init(&undo_list->lock);
 		atomic_set(&undo_list->refcnt, 1);
+		INIT_LIST_HEAD(&undo_list->list_proc);
+		
 		current->sysvsem.undo_list = undo_list;
 	}
 	*undo_listp = undo_list;
 	return 0;
 }
 
-static struct sem_undo *lookup_undo(struct sem_undo_list *ulp, int semid)
+static struct sem_undo *lookup_undo(struct sem_undo_list *ulp, struct ipc_namespace *ns, int semid)
 {
-	struct sem_undo **last, *un;
-
-	last = &ulp->proc_list;
-	un = *last;
-	while(un != NULL) {
-		if(un->semid==semid)
-			break;
-		if(un->semid==-1) {
-			*last=un->proc_next;
-			kfree(un);
-		} else {
-			last=&un->proc_next;
+	struct sem_undo *walk, *tmp;
+
+	assert_spin_locked(&ulp->lock);
+	list_for_each_entry_safe(walk, tmp, &ulp->list_proc, list_proc) {
+		if(walk->semid==semid && walk->ns == ns)
+			return walk;
+		if(walk->semid==-1) {
+			list_del(&walk->list_proc);
+			kfree(walk);
 		}
-		un=*last;
 	}
-	return un;
+	return NULL;
 }
 
-static struct sem_undo *find_undo(struct ipc_namespace *ns, int semid)
+/**
+ * find_alloc_undo - Lookup (and if not present create) undo array
+ * @ns: namespace
+ * @semid: semaphore array id
+ *
+ * The function looks up (and if not present creates) the undo structure.
+ * The size of the undo structure depends on the size of the semaphore
+ * array, thus the alloc path is not that straightforward.
+ */
+static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 {
 	struct sem_array *sma;
 	struct sem_undo_list *ulp;
@@ -1033,12 +1047,13 @@ static struct sem_undo *find_undo(struct ipc_namespace *ns, int semid)
 		return ERR_PTR(error);
 
 	spin_lock(&ulp->lock);
-	un = lookup_undo(ulp, semid);
+	un = lookup_undo(ulp, ns, semid);
 	spin_unlock(&ulp->lock);
 	if (likely(un!=NULL))
 		goto out;
 
 	/* no undo structure around - allocate one. */
+	/* step 1: figure out the size of the semaphore array */
 	sma = sem_lock_check(ns, semid);
 	if (IS_ERR(sma))
 		return ERR_PTR(PTR_ERR(sma));
@@ -1047,41 +1062,43 @@ static struct sem_undo *find_undo(struct ipc_namespace *ns, int semid)
 	ipc_rcu_getref(sma);
 	sem_unlock(sma);
 
+	/* step 2: allocate new undo structure */
 	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
-	if (!new) {
-		ipc_lock_by_ptr(&sma->sem_perm);
-		ipc_rcu_putref(sma);
-		sem_unlock(sma);
-		return ERR_PTR(-ENOMEM);
-	}
-	new->semadj = (short *) &new[1];
-	new->semid = semid;
 
+	/* step 3: reacquire all locks */
 	spin_lock(&ulp->lock);
-	un = lookup_undo(ulp, semid);
-	if (un) {
-		spin_unlock(&ulp->lock);
-		kfree(new);
-		ipc_lock_by_ptr(&sma->sem_perm);
-		ipc_rcu_putref(sma);
-		sem_unlock(sma);
-		goto out;
-	}
 	ipc_lock_by_ptr(&sma->sem_perm);
 	ipc_rcu_putref(sma);
-	if (sma->sem_perm.deleted) {
-		sem_unlock(sma);
-		spin_unlock(&ulp->lock);
+
+	/* step 4: check for failures: out of memory, array got removed */
+	un = ERR_PTR(-ENOMEM);
+	if (!new)
+		goto out_unlock;
+
+	un = ERR_PTR(-EIDRM);
+	if (sma->sem_perm.deleted)
+		goto out_unlock_free;
+
+	un = lookup_undo(ulp, ns, semid);
+	if (un) {
+out_unlock_free:
+		/* step 5a: another thread was faster, discard our structure */
 		kfree(new);
-		un = ERR_PTR(-EIDRM);
-		goto out;
+	} else {
+		/* step 5b: initialize & insert the new undo structure into all lists */
+		new->semadj = (short *) &new[1];
+		new->semid = semid;
+		new->ns = ns;
+
+		assert_spin_locked(&ulp->lock);
+		list_add(&new->list_proc, &ulp->list_proc);
+		assert_spin_locked(&sma->sem_perm.lock);
+		list_add(&new->list_id, &sma->list_id);
+
+		un = new;
 	}
-	new->proc_next = ulp->proc_list;
-	ulp->proc_list = new;
-	new->id_next = sma->undo;
-	sma->undo = new;
+out_unlock:
 	sem_unlock(sma);
-	un = new;
 	spin_unlock(&ulp->lock);
 out:
 	return un;
@@ -1138,9 +1155,8 @@ asmlinkage long sys_semtimedop(int semid, struct sembuf __user *tsops,
 			alter = 1;
 	}
 
-retry_undos:
 	if (undos) {
-		un = find_undo(ns, semid);
+		un = find_alloc_undo(ns, semid);
 		if (IS_ERR(un)) {
 			error = PTR_ERR(un);
 			goto out_free;
@@ -1155,14 +1171,14 @@ retry_undos:
 	}
 
 	/*
-	 * semid identifiers are not unique - find_undo may have
+	 * semid identifiers are not unique - find_alloc_undo may have
 	 * allocated an undo structure, it was invalidated by an RMID
-	 * and now a new array with received the same id. Check and retry.
+	 * and now a new array with received the same id. Check and fail.
 	 */
-	if (un && un->semid == -1) {
-		sem_unlock(sma);
-		goto retry_undos;
-	}
+	error = -EIDRM;
+	if (un && un->semid == -1)
+		goto out_unlock_free;
+
 	error = -EFBIG;
 	if (max >= sma->sem_nsems)
 		goto out_unlock_free;
@@ -1291,55 +1307,41 @@ int copy_semundo(unsigned long clone_flags, struct task_struct *tsk)
  */
 void exit_sem(struct task_struct *tsk)
 {
-	struct sem_undo_list *undo_list;
-	struct sem_undo *u, **up;
-	struct ipc_namespace *ns;
+	struct sem_undo_list *ulp;
+	struct sem_undo *un, *tmp;
 
-	undo_list = tsk->sysvsem.undo_list;
-	if (!undo_list)
+	ulp = tsk->sysvsem.undo_list;
+	if (!ulp)
 		return;
 
-	if (!atomic_dec_and_test(&undo_list->refcnt))
+	if (!atomic_dec_and_test(&ulp->refcnt))
 		return;
 
-	ns = tsk->nsproxy->ipc_ns;
-	/* There's no need to hold the semundo list lock, as current
-         * is the last task exiting for this undo list.
-	 */
-	for (up = &undo_list->proc_list; (u = *up); *up = u->proc_next, kfree(u)) {
+	spin_lock(&ulp->lock);
+	list_for_each_entry_safe(un, tmp, &ulp->list_proc, list_proc) {
 		struct sem_array *sma;
-		int nsems, i;
-		struct sem_undo *un, **unp;
-		int semid;
-	       
-		semid = u->semid;
-
-		if(semid == -1)
-			continue;
-		sma = sem_lock(ns, semid);
+		int i;
+
+		if(un->semid == -1)
+			goto free;
+		sma = sem_lock(un->ns, un->semid);
 		if (IS_ERR(sma))
-			continue;
+			goto free;
 
-		if (u->semid == -1)
+		if (un->semid == -1)
 			goto next_entry;
 
-		BUG_ON(sem_checkid(sma, u->semid));
+		BUG_ON(sem_checkid(sma, un->semid));
 
-		/* remove u from the sma->undo list */
-		for (unp = &sma->undo; (un = *unp); unp = &un->id_next) {
-			if (u == un)
-				goto found;
-		}
-		printk ("exit_sem undo list error id=%d\n", u->semid);
-		goto next_entry;
-found:
-		*unp = un->id_next;
-		/* perform adjustments registered in u */
-		nsems = sma->sem_nsems;
-		for (i = 0; i < nsems; i++) {
+		/* remove un from sma->list_id */
+		assert_spin_locked(&sma->sem_perm.lock);
+		list_del(&un->list_id);
+
+		/* perform adjustments registered in un */
+		for (i = 0; i < sma->sem_nsems; i++) {
 			struct sem * semaphore = &sma->sem_base[i];
-			if (u->semadj[i]) {
-				semaphore->semval += u->semadj[i];
+			if (un->semadj[i]) {
+				semaphore->semval += un->semadj[i];
 				/*
 				 * Range checks of the new semaphore value,
 				 * not defined by sus:
@@ -1365,8 +1367,12 @@ found:
 		update_queue(sma);
 next_entry:
 		sem_unlock(sma);
+free:
+		list_del(&un->list_proc);
+		kfree(un);
 	}
-	kfree(undo_list);
+	spin_unlock(&ulp->lock);
+	kfree(ulp);
 }
 
 #ifdef CONFIG_PROC_FS

--------------070407000604090609070507--
