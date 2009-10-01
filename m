Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbZJBG0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbZJBG0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 02:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbZJBG0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 02:26:36 -0400
Received: from lucia.q-ag.de ([88.198.75.226]:44301 "EHLO lucia.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbZJBG0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 02:26:36 -0400
X-Greylist: delayed 863 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2009 02:26:36 EDT
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: npiggin@suse.de
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 1 Oct 2009 10:00:00 +0200
Subject: [PATCH 1/7] ipc/sem.c: sem optimise undo list search
Message-Id: <E1Mtbbx-000510-Ej@lucia.q-ag.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move last looked up sem_undo struct to the head of the task's undo list.
Attempt to move common entries to the front of the list so search time is
reduced. This reduces lookup_undo on oprofile of problematic SAP workload
by 30% (see patch 4 for a description of SAP workload).

Signed-off-by: Nick Piggin <npiggin@suse.de>

Merged with my own patches, no changes.
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

Index: linux-2.6/ipc/sem.c
===================================================================
--- linux-2.6.orig/ipc/sem.c
+++ linux-2.6/ipc/sem.c
@@ -961,17 +961,31 @@ static inline int get_undo_list(struct s
 	return 0;
 }
 
-static struct sem_undo *lookup_undo(struct sem_undo_list *ulp, int semid)
+static struct sem_undo *__lookup_undo(struct sem_undo_list *ulp, int semid)
 {
-	struct sem_undo *walk;
+	struct sem_undo *un;
 
-	list_for_each_entry_rcu(walk, &ulp->list_proc, list_proc) {
-		if (walk->semid == semid)
-			return walk;
+	list_for_each_entry_rcu(un, &ulp->list_proc, list_proc) {
+		if (un->semid == semid)
+			return un;
 	}
 	return NULL;
 }
 
+static struct sem_undo *lookup_undo(struct sem_undo_list *ulp, int semid)
+{
+	struct sem_undo *un;
+
+  	assert_spin_locked(&ulp->lock);
+
+	un = __lookup_undo(ulp, semid);
+	if (un) {
+		list_del_rcu(&un->list_proc);
+		list_add_rcu(&un->list_proc, &ulp->list_proc);
+	}
+	return un;
+}
+
 /**
  * find_alloc_undo - Lookup (and if not present create) undo array
  * @ns: namespace
@@ -1307,7 +1321,7 @@ void exit_sem(struct task_struct *tsk)
 		if (IS_ERR(sma))
 			continue;
 
-		un = lookup_undo(ulp, semid);
+		un = __lookup_undo(ulp, semid);
 		if (un == NULL) {
 			/* exit_sem raced with IPC_RMID+semget() that created
 			 * exactly the same semid. Nothing to do.

