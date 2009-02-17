Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZBQL1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZBQL1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbZBQL1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:27:03 -0500
Received: from ns2.suse.de ([195.135.220.15]:50960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbZBQL1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:27:01 -0500
Date: Tue, 17 Feb 2009 12:26:57 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove single ipi fallback for smp_call_function_many())
Message-ID: <20090217112657.GE26402@wotan.suse.de>
References: <20090216204902.GA6924@redhat.com> <1234818201.30178.386.camel@laptop> <20090216213205.GA9098@redhat.com> <1234820704.30178.396.camel@laptop> <20090216220214.GA10093@redhat.com> <1234823097.30178.406.camel@laptop> <20090216231946.GA12009@redhat.com> <1234862974.4744.31.camel@laptop> <20090217101130.GA8660@wotan.suse.de> <1234866453.4744.58.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234866453.4744.58.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc linux-arch

On Tue, Feb 17, 2009 at 11:27:33AM +0100, Peter Zijlstra wrote:
> > But hmm, why even bother with all this complexity? Why not just
> > remove the outer loop completely? Do the lock and the list_replace_init
> > unconditionally. It would turn tricky lockless code into simple locked
> > code... we've already taken an interrupt anyway, so chances are pretty
> > high that we have work here to do, right?
> 
> Well, that's a practical suggestion, and I agree.

How's this?

--
Simplify the barriers in generic remote function call interrupt code.

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
 
