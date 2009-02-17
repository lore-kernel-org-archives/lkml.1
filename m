Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbZBQWDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbZBQWDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 17:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbZBQWDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 17:03:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57145 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZBQWDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 17:03:19 -0500
Message-Id: <20090217220053.410275566@chello.nl>
References: <20090217215904.059250145@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 22:59:05 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/3] generic-ipi: simplify the barriers
Content-Disposition: inline; filename=nick-simplify-generic-smp-barriers.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <npiggin@suse.de>

Firstly, just unconditionally take the lock and check the list in the
generic_call_function_single_interrupt IPI handler. As we've just taken
an IPI here, the chances are fairly high that there will be work on the
list for us, so do the locking unconditionally. This removes the tricky
lockless list_empty check and dubious barriers. The change looks bigger
than it is because it is just removing an outer loop.

Secondly, clarify architecture specific IPI locking rules. Generic code
has no tools to impose any sane ordering on IPIs if they go outside
normal cache coherency, ergo the arch code must make them appear to
obey cache coherency as a "memory operation" to initiate an IPI, and
a "memory operation" to receive one. This way at least they can be
reasoned about in generic code, and smp_mb used to provide ordering.

The combination of these two changes means that explict barriers can
be taken out of queue handling for the single case -- shared data is
explicitly locked, and ipi ordering must conform to that, so no
barriers needed. An extra barrier is needed in the many handler, so
as to ensure we load the list element after the IPI is received.

Does any architecture actually needs barriers? For the initiator I
could see it, but for the handler I would be surprised. The other
thing we could do for simplicity is just to require that a full
barrier is required before generating an IPI, and after receiving an
IPI. We can't just do that in generic code without auditing
architectures. There have been subtle hangs here on some archs in
the past.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/smp.c |   83 +++++++++++++++++++++++++++++++----------------------------
 1 file changed, 44 insertions(+), 39 deletions(-)

Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c
+++ linux-2.6/kernel/smp.c
@@ -74,9 +74,16 @@ static void generic_exec_single(int cpu,
 	spin_unlock_irqrestore(&dst->lock, flags);
 
 	/*
-	 * Make the list addition visible before sending the ipi.
+	 * The list addition should be visible before sending the IPI
+	 * handler locks the list to pull the entry off it because of
+	 * normal cache coherency rules implied by spinlocks.
+	 *
+	 * If IPIs can go out of order to the cache coherency protocol
+	 * in an architecture, sufficient synchronisation should be added
+	 * to arch code to make it appear to obey cache coherency WRT
+	 * locking and barrier primitives. Generic code isn't really equipped
+	 * to do the right thing...
 	 */
-	smp_mb();
 
 	if (ipi)
 		arch_send_call_function_single_ipi(cpu);
@@ -104,6 +111,14 @@ void generic_smp_call_function_interrupt
 	int cpu = get_cpu();
 
 	/*
+	 * Ensure entry is visible on call_function_queue after we have
+	 * entered the IPI. See comment in smp_call_function_many.
+	 * If we don't have this, then we may miss an entry on the list
+	 * and never get another IPI to process it.
+	 */
+	smp_mb();
+
+	/*
 	 * It's ok to use list_for_each_rcu() here even though we may delete
 	 * 'pos', since list_del_rcu() doesn't clear ->next
 	 */
@@ -154,49 +169,37 @@ void generic_smp_call_function_single_in
 {
 	struct call_single_queue *q = &__get_cpu_var(call_single_queue);
 	LIST_HEAD(list);
+	unsigned int data_flags;
 
-	/*
-	 * Need to see other stores to list head for checking whether
-	 * list is empty without holding q->lock
-	 */
-	smp_read_barrier_depends();
-	while (!list_empty(&q->list)) {
-		unsigned int data_flags;
-
-		spin_lock(&q->lock);
-		list_replace_init(&q->list, &list);
-		spin_unlock(&q->lock);
-
-		while (!list_empty(&list)) {
-			struct call_single_data *data;
-
-			data = list_entry(list.next, struct call_single_data,
-						list);
-			list_del(&data->list);
+	spin_lock(&q->lock);
+	list_replace_init(&q->list, &list);
+	spin_unlock(&q->lock);
 
-			/*
-			 * 'data' can be invalid after this call if
-			 * flags == 0 (when called through
-			 * generic_exec_single(), so save them away before
-			 * making the call.
-			 */
-			data_flags = data->flags;
+	while (!list_empty(&list)) {
+		struct call_single_data *data;
 
-			data->func(data->info);
+		data = list_entry(list.next, struct call_single_data,
+					list);
+		list_del(&data->list);
 
-			if (data_flags & CSD_FLAG_WAIT) {
-				smp_wmb();
-				data->flags &= ~CSD_FLAG_WAIT;
-			} else if (data_flags & CSD_FLAG_LOCK) {
-				smp_wmb();
-				data->flags &= ~CSD_FLAG_LOCK;
-			} else if (data_flags & CSD_FLAG_ALLOC)
-				kfree(data);
-		}
 		/*
-		 * See comment on outer loop
+		 * 'data' can be invalid after this call if
+		 * flags == 0 (when called through
+		 * generic_exec_single(), so save them away before
+		 * making the call.
 		 */
-		smp_read_barrier_depends();
+		data_flags = data->flags;
+
+		data->func(data->info);
+
+		if (data_flags & CSD_FLAG_WAIT) {
+			smp_wmb();
+			data->flags &= ~CSD_FLAG_WAIT;
+		} else if (data_flags & CSD_FLAG_LOCK) {
+			smp_wmb();
+			data->flags &= ~CSD_FLAG_LOCK;
+		} else if (data_flags & CSD_FLAG_ALLOC)
+			kfree(data);
 	}
 }
 
@@ -375,6 +378,8 @@ void smp_call_function_many(const struct
 
 	/*
 	 * Make the list addition visible before sending the ipi.
+	 * (IPIs must obey or appear to obey normal Linux cache coherency
+	 * rules -- see comment in generic_exec_single).
 	 */
 	smp_mb();
 

-- 

