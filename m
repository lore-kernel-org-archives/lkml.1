Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbXI3PCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbXI3PCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbXI3PCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:02:24 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:21650 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbXI3PCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:02:23 -0400
Subject: [PATCH] robust futex thread exit race
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: mingo@elte.hu
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Sun, 30 Sep 2007 17:02:19 +0200
Message-Id: <1191164539.4047.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
I finally found the bug that causes tst-robust8 from the glibc to fail
on s390x. Turned out to be a common code problem with the processing of
the robust futex list. The patch below fixes the bug for me.

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
The next point need to be read before calling handle_futex_death.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

diff -urpN linux-2.6/kernel/futex.c linux-2.6-patched/kernel/futex.c
--- linux-2.6/kernel/futex.c	2007-08-23 11:14:33.000000000 +0200
+++ linux-2.6-patched/kernel/futex.c	2007-09-30 16:31:57.000000000 +0200
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
@@ -1965,12 +1966,13 @@ void exit_robust_list(struct task_struct
 	if (fetch_robust_entry(&pending, &head->list_op_pending, &pip))
 		return;
 
-	if (pending)
-		handle_futex_death((void __user *)pending + futex_offset,
-				   curr, pip);
-
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
@@ -1978,11 +1980,10 @@ void exit_robust_list(struct task_struct
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
@@ -1991,6 +1992,10 @@ void exit_robust_list(struct task_struct
 
 		cond_resched();
 	}
+
+	if (pending)
+		handle_futex_death((void __user *)pending + futex_offset,
+				   curr, pip);
 }
 
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,


