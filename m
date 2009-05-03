Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbZECTBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbZECTBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 15:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbZECTAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 15:00:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59469 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbZECTAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 15:00:47 -0400
Date: Sun, 3 May 2009 20:55:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [RFC, PATCH 0/2] utrace/ptrace: simplify/cleanup ptrace attach
Message-ID: <20090503185537.GA17071@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shouldn't be applied without Roland's ack.

I just don't know how to merge the second patch properly. I think it would be
really nice to cleanup ptrace attach before "ptracee data structures cleanup",
but this depends on utrace-core.patch which adds exclude_ptrace().

With the first patch, the second one (and hopefully the further cleanups) does
not depend on utrace.

Or, we can start with something like the patch below. Or, instead we can move
the "already traced" check into exclude_ptrace, this way only this helper will
depend on utrace changes. But personally I'd prefer to remove exclude_ptrace()
for now and add the correct checks later.

Roland, what do you think?

Oleg.

--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -190,6 +190,9 @@ int ptrace_attach(struct task_struct *ta
 
 	audit_ptrace(task);
 
+	if (exclude_ptrace(task))
+		return -EBUSY;
+
 	retval = -EPERM;
 	if (same_thread_group(task, current))
 		goto out;
@@ -221,11 +224,6 @@ repeat:
 		goto repeat;
 	}
 
-	if (exclude_ptrace(task)) {
-		retval = -EBUSY;
-		goto bad;
-	}
-
 	if (!task->mm)
 		goto bad;
 	/* the same process cannot be attached many times */
@@ -597,14 +595,14 @@ int ptrace_traceme(void)
 {
 	int ret = -EPERM;
 
+	if (exclude_ptrace(current))
+		return -EBUSY;
 	/*
 	 * Are we already being traced?
 	 */
 repeat:
 	task_lock(current);
-	if (exclude_ptrace(current)) {
-		ret = -EBUSY;
-	} else if (!(current->ptrace & PT_PTRACED)) {
+	if (!(current->ptrace & PT_PTRACED)) {
 		/*
 		 * See ptrace_attach() comments about the locking here.
 		 */

