Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbZJBG1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbZJBG1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 02:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756795AbZJBG1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 02:27:05 -0400
Received: from lucia.q-ag.de ([88.198.75.226]:47427 "EHLO lucia.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784AbZJBG1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 02:27:05 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: npiggin@suse.de
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 1 Oct 2009 10:00:00 +0200
Subject: [PATCH 2/7] ipc/sem.c: sem use list operations
Message-Id: <E1MtbcT-000519-So@lucia.q-ag.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@suse.de>

Merged with my own patches, no changes.

The patch replaces the handcoded list operations in update_queue() with the
standard list_for_each_entry macros.
list_for_each_entry_safe() must be used, because list entries can disappear
immediately uppon the wakeup event.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c |   79 +++++++++++++++++++++++++-------------------------------------
 1 file changed, 33 insertions(+), 46 deletions(-)

Index: linux-2.6/ipc/sem.c
===================================================================
--- linux-2.6.orig/ipc/sem.c
+++ linux-2.6/ipc/sem.c
@@ -402,58 +402,45 @@ undo:
  */
 static void update_queue (struct sem_array * sma)
 {
-	int error;
-	struct sem_queue * q;
+	struct sem_queue *q, *tq;
+
+again:
+	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
+		int error;
+		int alter;
 
-	q = list_entry(sma->sem_pending.next, struct sem_queue, list);
-	while (&q->list != &sma->sem_pending) {
 		error = try_atomic_semop(sma, q->sops, q->nsops,
 					 q->undo, q->pid);
 
 		/* Does q->sleeper still need to sleep? */
-		if (error <= 0) {
-			struct sem_queue *n;
+		if (error > 0)
+			continue;
+
+		list_del(&q->list);
+
+		/*
+		 * The next operation that must be checked depends on the type
+		 * of the completed operation:
+		 * - if the operation modified the array, then restart from the
+		 *   head of the queue and check for threads that might be
+		 *   waiting for semaphore values to become 0.
+		 * - if the operation didn't modify the array, then just
+		 *   continue.
+		 */
+		alter = q->alter;
+
+		/* wake up the waiting thread */
+		q->status = IN_WAKEUP;
+
+		wake_up_process(q->sleeper);
+		/* hands-off: q will disappear immediately after
+		 * writing q->status.
+		 */
+		smp_wmb();
+		q->status = error;
 
-			/*
-			 * Continue scanning. The next operation
-			 * that must be checked depends on the type of the
-			 * completed operation:
-			 * - if the operation modified the array, then
-			 *   restart from the head of the queue and
-			 *   check for threads that might be waiting
-			 *   for semaphore values to become 0.
-			 * - if the operation didn't modify the array,
-			 *   then just continue.
-			 * The order of list_del() and reading ->next
-			 * is crucial: In the former case, the list_del()
-			 * must be done first [because we might be the
-			 * first entry in ->sem_pending], in the latter
-			 * case the list_del() must be done last
-			 * [because the list is invalid after the list_del()]
-			 */
-			if (q->alter) {
-				list_del(&q->list);
-				n = list_entry(sma->sem_pending.next,
-						struct sem_queue, list);
-			} else {
-				n = list_entry(q->list.next, struct sem_queue,
-						list);
-				list_del(&q->list);
-			}
-
-			/* wake up the waiting thread */
-			q->status = IN_WAKEUP;
-
-			wake_up_process(q->sleeper);
-			/* hands-off: q will disappear immediately after
-			 * writing q->status.
-			 */
-			smp_wmb();
-			q->status = error;
-			q = n;
-		} else {
-			q = list_entry(q->list.next, struct sem_queue, list);
-		}
+		if (alter)
+			goto again;
 	}
 }
 

