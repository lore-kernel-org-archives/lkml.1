Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240AbZHKL4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbZHKL4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbZHKL4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:56:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbZHKLye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:34 -0400
Message-Id: <20090811111606.852771184@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Tue, 11 Aug 2009 21:09:03 +1000
From: npiggin@suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: [patch 1/4] ipc: sem optimise undo list search
References: <20090811110902.255877673@suse.de>
Content-Disposition: inline; filename=ipc-sem-undo-optimise.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move last looked up sem_undo struct to the head of the task's undo list.
Attempt to move common entries to the front of the list so search time is
reduced. This reduces lookup_undo on oprofile of problematic SAP workload
by 30% (see patch 4 for a description of SAP workload).

Signed-off-by: Nick Piggin <npiggin@suse.de>
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


