Return-Path: <linux-kernel-owner+w=401wt.eu-S1763259AbXJEOqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763259AbXJEOqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 10:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbXJEOqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 10:46:15 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:33231 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015AbXJEOqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 10:46:13 -0400
Date: Fri, 5 Oct 2007 16:46:06 +0200
From: Pierre Peiffer <Pierre.Peiffer@bull.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] IPC: cleanup some code and wrong comments about semundo
 list managment
Message-Id: <20071005164606.284341c9.Pierre.Peiffer@bull.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 05/10/2007 16:52:25,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 05/10/2007 16:52:26,
	Serialize complete at 05/10/2007 16:52:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pierre Peiffer <pierre.peiffer@bull.net>

Some comments about sem_undo_list seem wrong.
About the comment above unlock_semundo:
"... If task2 now exits before task1 releases the lock (by calling
unlock_semundo()), then task1 will never call spin_unlock(). ..."

This is just wrong, I see no reason for which task1 will not call
spin_unlock... The rest of this comment is also wrong... Unless I
miss something (of course).

Finally, (un)lock_semundo functions are useless, so remove them
for simplification. (this avoids an useless if statement)

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>

---

 ipc/sem.c |   46 ++++++----------------------------------------
 1 files changed, 6 insertions(+), 40 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index b676fef..5585817 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -957,36 +957,6 @@ asmlinkage long sys_semctl (int semid, int semnum, int cmd, union semun arg)
 	}
 }
 
-static inline void lock_semundo(void)
-{
-	struct sem_undo_list *undo_list;
-
-	undo_list = current->sysvsem.undo_list;
-	if (undo_list)
-		spin_lock(&undo_list->lock);
-}
-
-/* This code has an interaction with copy_semundo().
- * Consider; two tasks are sharing the undo_list. task1
- * acquires the undo_list lock in lock_semundo().  If task2 now
- * exits before task1 releases the lock (by calling
- * unlock_semundo()), then task1 will never call spin_unlock().
- * This leave the sem_undo_list in a locked state.  If task1 now creats task3
- * and once again shares the sem_undo_list, the sem_undo_list will still be
- * locked, and future SEM_UNDO operations will deadlock.  This case is
- * dealt with in copy_semundo() by having it reinitialize the spin lock when 
- * the refcnt goes from 1 to 2.
- */
-static inline void unlock_semundo(void)
-{
-	struct sem_undo_list *undo_list;
-
-	undo_list = current->sysvsem.undo_list;
-	if (undo_list)
-		spin_unlock(&undo_list->lock);
-}
-
-
 /* If the task doesn't already have a undo_list, then allocate one
  * here.  We guarantee there is only one thread using this undo list,
  * and current is THE ONE
@@ -1047,9 +1017,9 @@ static struct sem_undo *find_undo(struct ipc_namespace *ns, int semid)
 	if (error)
 		return ERR_PTR(error);
 
-	lock_semundo();
+	spin_lock(&ulp->lock);
 	un = lookup_undo(ulp, semid);
-	unlock_semundo();
+	spin_unlock(&ulp->lock);
 	if (likely(un!=NULL))
 		goto out;
 
@@ -1077,10 +1047,10 @@ static struct sem_undo *find_undo(struct ipc_namespace *ns, int semid)
 	new->semadj = (short *) &new[1];
 	new->semid = semid;
 
-	lock_semundo();
+	spin_lock(&ulp->lock);
 	un = lookup_undo(ulp, semid);
 	if (un) {
-		unlock_semundo();
+		spin_unlock(&ulp->lock);
 		kfree(new);
 		ipc_lock_by_ptr(&sma->sem_perm);
 		ipc_rcu_putref(sma);
@@ -1091,7 +1061,7 @@ static struct sem_undo *find_undo(struct ipc_namespace *ns, int semid)
 	ipc_rcu_putref(sma);
 	if (sma->sem_perm.deleted) {
 		sem_unlock(sma);
-		unlock_semundo();
+		spin_unlock(&ulp->lock);
 		kfree(new);
 		un = ERR_PTR(-EIDRM);
 		goto out;
@@ -1102,7 +1072,7 @@ static struct sem_undo *find_undo(struct ipc_namespace *ns, int semid)
 	sma->undo = new;
 	sem_unlock(sma);
 	un = new;
-	unlock_semundo();
+	spin_unlock(&ulp->lock);
 out:
 	return un;
 }
@@ -1279,10 +1249,6 @@ asmlinkage long sys_semop (int semid, struct sembuf __user *tsops, unsigned nsop
 
 /* If CLONE_SYSVSEM is set, establish sharing of SEM_UNDO state between
  * parent and child tasks.
- *
- * See the notes above unlock_semundo() regarding the spin_lock_init()
- * in this code.  Initialize the undo_list->lock here instead of get_undo_list()
- * because of the reasoning in the comment above unlock_semundo.
  */
 
 int copy_semundo(unsigned long clone_flags, struct task_struct *tsk)


Pierre Peiffer
