Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbZEGGwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbZEGGwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 02:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbZEGGvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 02:51:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36271 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366AbZEGGvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 02:51:19 -0400
Date: Thu, 7 May 2009 08:46:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] do_wait: simplify retval/tsk_result/notask_error mess
Message-ID: <20090507064641.GA15864@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we don't pass &retval down to other helpers we can simplify
the code more.

- kill tsk_result, just use retval

- add the "notask" label right after the main loop, and
  s/got end/goto notask/ after the fastpath pid check.

  This way we don't need to initialize retval before this
  check and the code becomes a bit more clean, if this pid
  has no attached tasks we should just skip the list search.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- PTRACE/kernel/exit.c~3_RETVAL	2009-05-07 04:37:49.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-05-07 05:09:51.000000000 +0200
@@ -1576,27 +1576,22 @@ repeat:
 	 * might later match our criteria, even if we are not able to reap
 	 * it yet.
 	 */
-	retval = wo->notask_error = -ECHILD;
+	wo->notask_error = -ECHILD;
 	if ((wo->wo_type < PIDTYPE_MAX) &&
 	   (!wo->wo_pid || hlist_empty(&wo->wo_pid->tasks[wo->wo_type])))
-		goto end;
+		goto notask;
 
 	current->state = TASK_INTERRUPTIBLE;
 	read_lock(&tasklist_lock);
 	tsk = current;
 	do {
-		int tsk_result = do_wait_thread(wo, tsk);
-
-		if (!tsk_result)
-			tsk_result = ptrace_do_wait(wo, tsk);
+		retval = do_wait_thread(wo, tsk);
+		if (retval)
+			goto end;
 
-		if (tsk_result) {
-			/*
-			 * tasklist_lock is unlocked and we have a final result.
-			 */
-			retval = tsk_result;
+		retval = ptrace_do_wait(wo, tsk);
+		if (retval)
 			goto end;
-		}
 
 		if (wo->wo_flags & __WNOTHREAD)
 			break;
@@ -1605,6 +1600,7 @@ repeat:
 	} while (tsk != current);
 	read_unlock(&tasklist_lock);
 
+notask:
 	retval = wo->notask_error;
 	if (!retval && !(wo->wo_flags & WNOHANG)) {
 		retval = -ERESTARTSYS;

