Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbXH1KSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbXH1KSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbXH1KSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:18:13 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:55173 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbXH1KSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:18:13 -0400
Date: Tue, 28 Aug 2007 14:18:35 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] wait_task_stopped/continued: remove unneeded p->signal != NULL check
Message-ID: <20070828101835.GA369@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The child was found on ->children list under tasklist_lock, it must have a
valid ->signal. __exit_signal() both removes the task from parent->children
and clears ->signal "atomically" under write_lock(tasklist).

Remove unneeded checks.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- t/kernel/exit.c~	2007-08-28 14:07:53.000000000 +0400
+++ t/kernel/exit.c	2007-08-28 14:09:14.000000000 +0400
@@ -1348,7 +1348,7 @@ static int wait_task_stopped(struct task
 	if (!p->exit_code)
 		return 0;
 	if (delayed_group_leader && !(p->ptrace & PT_PTRACED) &&
-	    p->signal && p->signal->group_stop_count > 0)
+	    p->signal->group_stop_count > 0)
 		/*
 		 * A group stop is in progress and this is the group leader.
 		 * We won't report until all threads have stopped.
@@ -1462,9 +1462,6 @@ static int wait_task_continued(struct ta
 	pid_t pid;
 	uid_t uid;
 
-	if (unlikely(!p->signal))
-		return 0;
-
 	if (!(p->signal->flags & SIGNAL_STOP_CONTINUED))
 		return 0;
 

