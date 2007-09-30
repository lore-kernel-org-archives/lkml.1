Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbXI3Rcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbXI3Rcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 13:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757852AbXI3RcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 13:32:23 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:7706 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbXI3RcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:32:22 -0400
Subject: Re: [PATCH] robust futex thread exit race
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070930171121.GA10025@elte.hu>
References: <1191164539.4047.5.camel@localhost>
	 <20070930151827.GB23127@elte.hu> <20070930160601.GA31506@elte.hu>
	 <1191168625.19010.0.camel@localhost>  <20070930171121.GA10025@elte.hu>
Content-Type: text/plain
Organization: IBM Corporation
Date: Sun, 30 Sep 2007 19:32:10 +0200
Message-Id: <1191173530.19010.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-30 at 19:11 +0200, Ingo Molnar wrote:
> > > > good catch! A quick preliminary review of your patch indicates it's 
> > > > fine - and it might be v2.6.23 material.
> > > 
> > > there's a symmetric bug in kernel/compat_futex.c too.
> > 
> > True. I'll update the patch and send it again with the Acked-bys.
> 
> thanks! Logistics-wise: given that v2.6.22 has this same bug too, it's 
> not a .23 regression per se and could in theory be merged after the 
> 2.6.23 release too, into 2.6.23.1.

Here we go. Tested with current git and latest glibc tst-robust8 on
s390-64, native and compat.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.

--
Subject: [PATCH] robust futex thread exit race

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Calling handle_futex_death in exit_robust_list for the different
robust mutexes of a thread basically frees the mutex. Another
thread might grab the lock immediately which updates the next
pointer of the mutex. fetch_robust_entry over the next pointer
might therefore branch into the robust mutex list of a different
thread. This can cause two problems: 1) some mutexes held by
the dead thread are not getting freed and 2) some mutexs held by
a different thread are freed.
The next pointer need to be read before calling fetch_robust_entry.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---

 kernel/futex.c        |   26 ++++++++++++++++----------
 kernel/futex_compat.c |   28 ++++++++++++++++++----------
 2 files changed, 34 insertions(+), 20 deletions(-)

diff -urpN linux-2.6/kernel/futex.c linux-2.6-patched/kernel/futex.c
--- linux-2.6/kernel/futex.c	2007-08-23 11:14:33.000000000 +0200
+++ linux-2.6-patched/kernel/futex.c	2007-09-30 19:23:12.000000000 +0200
@@ -1943,9 +1943,10 @@ static inline int fetch_robust_entry(str
 void exit_robust_list(struct task_struct *curr)
 {
 	struct robust_list_head __user *head = curr->robust_list;
-	struct robust_list __user *entry, *pending;
-	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
+	struct robust_list __user *entry, *next_entry, *pending;
+	unsigned int limit = ROBUST_LIST_LIMIT, pi, next_pi, pip;
 	unsigned long futex_offset;
+	int rc;
 
 	/*
 	 * Fetch the list head (which was registered earlier, via
@@ -1965,12 +1966,14 @@ void exit_robust_list(struct task_struct
 	if (fetch_robust_entry(&pending, &head->list_op_pending, &pip))
 		return;
 
-	if (pending)
-		handle_futex_death((void __user *)pending + futex_offset,
-				   curr, pip);
-
+	next_entry = NULL;	/* avoid warning with gcc */
 	while (entry != &head->list) {
 		/*
+		 * Fetch the next entry in the list before calling
+		 * handle_futex_death:
+		 */
+		rc = fetch_robust_entry(&next_entry, &entry->next, &next_pi);
+		/*
 		 * A pending lock might already be on the list, so
 		 * don't process it twice:
 		 */
@@ -1978,11 +1981,10 @@ void exit_robust_list(struct task_struct
 			if (handle_futex_death((void __user *)entry + futex_offset,
 						curr, pi))
 				return;
-		/*
-		 * Fetch the next entry in the list:
-		 */
-		if (fetch_robust_entry(&entry, &entry->next, &pi))
+		if (rc)
 			return;
+		entry = next_entry;
+		pi = next_pi;
 		/*
 		 * Avoid excessively long or circular lists:
 		 */
@@ -1991,6 +1993,10 @@ void exit_robust_list(struct task_struct
 
 		cond_resched();
 	}
+
+	if (pending)
+		handle_futex_death((void __user *)pending + futex_offset,
+				   curr, pip);
 }
 
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
diff -urpN linux-2.6/kernel/futex_compat.c linux-2.6-patched/kernel/futex_compat.c
--- linux-2.6/kernel/futex_compat.c	2007-09-12 10:29:09.000000000 +0200
+++ linux-2.6-patched/kernel/futex_compat.c	2007-09-30 18:29:16.000000000 +0200
@@ -38,10 +38,11 @@ fetch_robust_entry(compat_uptr_t *uentry
 void compat_exit_robust_list(struct task_struct *curr)
 {
 	struct compat_robust_list_head __user *head = curr->compat_robust_list;
-	struct robust_list __user *entry, *pending;
-	unsigned int limit = ROBUST_LIST_LIMIT, pi, pip;
-	compat_uptr_t uentry, upending;
+	struct robust_list __user *entry, *next_entry, *pending;
+	unsigned int limit = ROBUST_LIST_LIMIT, pi, next_pi, pip;
+	compat_uptr_t uentry, next_uentry, upending;
 	compat_long_t futex_offset;
+	int rc;
 
 	/*
 	 * Fetch the list head (which was registered earlier, via
@@ -61,11 +62,16 @@ void compat_exit_robust_list(struct task
 	if (fetch_robust_entry(&upending, &pending,
 			       &head->list_op_pending, &pip))
 		return;
-	if (pending)
-		handle_futex_death((void __user *)pending + futex_offset, curr, pip);
 
+	next_entry = NULL;	/* avoid warning with gcc */
 	while (entry != (struct robust_list __user *) &head->list) {
 		/*
+		 * Fetch the next entry in the list before calling
+		 * handle_futex_death:
+		 */
+		rc = fetch_robust_entry(&next_uentry, &next_entry,
+			(compat_uptr_t __user *)&entry->next, &next_pi);
+		/*
 		 * A pending lock might already be on the list, so
 		 * dont process it twice:
 		 */
@@ -74,12 +80,11 @@ void compat_exit_robust_list(struct task
 						curr, pi))
 				return;
 
-		/*
-		 * Fetch the next entry in the list:
-		 */
-		if (fetch_robust_entry(&uentry, &entry,
-				       (compat_uptr_t __user *)&entry->next, &pi))
+		if (rc)
 			return;
+		uentry = next_uentry;
+		entry = next_entry;
+		pi = next_pi;
 		/*
 		 * Avoid excessively long or circular lists:
 		 */
@@ -88,6 +93,9 @@ void compat_exit_robust_list(struct task
 
 		cond_resched();
 	}
+	if (pending)
+		handle_futex_death((void __user *)pending + futex_offset,
+				   curr, pip);
 }
 
 asmlinkage long


