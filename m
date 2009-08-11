Return-Path: <linux-kernel-owner+w=401wt.eu-S1751723AbZHKLyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbZHKLyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbZHKLyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:54:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:37432 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbZHKLyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:31 -0400
Message-Id: <20090811111606.997443191@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Tue, 11 Aug 2009 21:09:04 +1000
From: npiggin@suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: [patch 2/4] ipc: sem use list operations
References: <20090811110902.255877673@suse.de>
Content-Disposition: inline; filename=ipc-sem-use-list-ops.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@suse.de>
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
 


