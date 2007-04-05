Return-Path: <linux-kernel-owner+w=401wt.eu-S1767245AbXDETkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767245AbXDETkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 15:40:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767254AbXDETkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 15:40:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767245AbXDETkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 15:40:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
X-Fcc: ~/Mail/utrace
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4: ia64:  scheduling while atomic - utrace?
In-Reply-To: Lee Schermerhorn's message of  Thursday, 5 April 2007 14:20:29 -0400 <1175797229.5335.22.camel@localhost>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070405193955.1D812180055@magilla.sf.frob.com>
Date: Thu,  5 Apr 2007 12:39:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the report.  I introduced this bug recently when I changed
around some of the locking but forgot about the writeback issue.  I don't
think this is directly related to any other crash you might have seen.

I've moved the call out of the lock-holding region, where it didn't need to
be.  I'm updating my patch series now; I've appended the incremental patch.


Thanks,
Roland

---
 kernel/ptrace.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index fb6c3fb..c31d744 100644  
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -1473,16 +1473,6 @@ ptrace_report(struct utrace_attached_eng
 	 */
 	utrace_set_flags(tsk, engine, engine->flags | UTRACE_ACTION_QUIESCE);
 
-	/*
-	 * If regset 0 has a writeback call, do it now.  On register window
-	 * machines, this makes sure the user memory backing the register
-	 * data is up to date by the time wait_task_inactive returns to
-	 * ptrace_start in our tracer doing a PTRACE_PEEKDATA or the like.
-	 */
-	regset = utrace_regset(tsk, engine, utrace_native_view(tsk), 0);
-	if (regset->writeback)
-		(*regset->writeback)(tsk, regset, 0);
-
 	BUG_ON(code == 0);
 	tsk->exit_code = code;
 	do_notify(tsk, state->parent, CLD_TRAPPED);
@@ -1494,6 +1484,16 @@ ptrace_report(struct utrace_attached_eng
 
 	NO_LOCKS;
 
+	/*
+	 * If regset 0 has a writeback call, do it now.  On register window
+	 * machines, this makes sure the user memory backing the register
+	 * data is up to date by the time wait_task_inactive returns to
+	 * ptrace_start in our tracer doing a PTRACE_PEEKDATA or the like.
+	 */
+	regset = utrace_regset(tsk, engine, utrace_native_view(tsk), 0);
+	if (regset->writeback)
+		(*regset->writeback)(tsk, regset, 0);
+
 	return UTRACE_ACTION_RESUME;
 }
 
