Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbXLHShk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbXLHShk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 13:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbXLHShT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 13:37:19 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:42408 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbXLHShR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 13:37:17 -0500
Date: Sat, 8 Dec 2007 21:38:01 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ptrace_stop: remove the wrong ->group_stop_count bookkeeping
Message-ID: <20071208183801.GA9943@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_stop() decrements ->group_stop_count to "participate" in group stop.
This looks very wrong to me, the task can in fact decrement this counter twice.
If the tracee returns to the user-space before other threads complete the group
stop, it will notice TIF_SIGPENDING and do it again.

Another problem is that we don't set SIGNAL_STOP_STOPPED if the counter becomes
zero.

I must admit, I don't undestand the reason why this code was added, it is very
old.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/signal.c~5_ptrace_stop	2007-12-08 16:46:37.000000000 +0300
+++ PT/kernel/signal.c	2007-12-08 16:47:53.000000000 +0300
@@ -1579,13 +1579,6 @@ static inline int may_ptrace_stop(void)
  */
 static void ptrace_stop(int exit_code, int clear_code, siginfo_t *info)
 {
-	/*
-	 * If there is a group stop in progress,
-	 * we must participate in the bookkeeping.
-	 */
-	if (current->signal->group_stop_count > 0)
-		--current->signal->group_stop_count;
-
 	current->last_siginfo = info;
 	current->exit_code = exit_code;
 

