Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbZEFFhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbZEFFhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 01:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZEFFhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 01:37:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44503 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbZEFFhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 01:37:12 -0400
Date: Wed, 6 May 2009 07:33:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [FOR REVIEW, PATCH 1/2] shift "ptrace implies WUNTRACED" from
	ptrace_do_wait() to wait_task_stopped()
Message-ID: <20090506053322.GA31981@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, preparation for the next patch.

ptrace_do_wait() adds WUNTRACED to options for wait_task_stopped()
which should always accept the stopped tracee, even if do_wait() was
called without WUNTRACED.

Change wait_task_stopped() to check "ptrace || WUNTRACED" instead.
This makes the code more explicit, and "int options" argument becomes
const in do_wait() pathes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- PTRACE/kernel/exit.c~1_WUNTRACED	2009-05-03 23:24:14.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-05-06 01:48:51.000000000 +0200
@@ -1330,7 +1330,8 @@ static int wait_task_stopped(int ptrace,
 	uid_t uid = 0; /* unneeded, required by compiler */
 	pid_t pid;
 
-	if (!(options & WUNTRACED))
+	/* Traditionally we see ptrace'd stopped tasks regardless of options */
+	if (!ptrace && !(options & WUNTRACED))
 		return 0;
 
 	exit_code = 0;
@@ -1548,11 +1549,6 @@ static int ptrace_do_wait(struct task_st
 {
 	struct task_struct *p;
 
-	/*
-	 * Traditionally we see ptrace'd stopped tasks regardless of options.
-	 */
-	options |= WUNTRACED;
-
 	list_for_each_entry(p, &tsk->ptraced, ptrace_entry) {
 		int ret = wait_consider_task(tsk, 1, p, notask_error,
 					     type, pid, options,

