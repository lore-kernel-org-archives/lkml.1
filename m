Return-Path: <linux-kernel-owner+w=401wt.eu-S1752683AbXKVQO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbXKVQO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 11:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbXKVQOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 11:14:48 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:57681 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbXKVQOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 11:14:48 -0500
Date: Thu, 22 Nov 2007 19:15:02 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 3/2] do_wait: factor out "retval != 0" checks
Message-ID: <20071122161502.GA5979@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every branch if the main "if" statement does the same code at the end. Move it
down. Also, fix the indentation.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- PT/kernel/exit.c~3_result	2007-11-22 18:06:01.000000000 +0300
+++ PT/kernel/exit.c	2007-11-22 19:08:43.000000000 +0300
@@ -1508,6 +1508,7 @@ repeat:
 			}
 			allowed = 1;
 
+			retval = 0;
 			if (is_task_stopped_or_traced(p)) {
 				/*
 				 * It's stopped now, so it might later
@@ -1521,8 +1522,6 @@ repeat:
 				retval = wait_task_stopped(p, ret == 2,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
-				if (retval != 0) /* He released the lock.  */
-					goto end;
 			} else if (p->exit_state == EXIT_ZOMBIE) {
 				/*
 				 * Eligible but we cannot release it yet:
@@ -1534,9 +1533,6 @@ repeat:
 				retval = wait_task_zombie(p,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
-				/* He released the lock.  */
-				if (retval != 0)
-					goto end;
 			} else if (p->exit_state != EXIT_DEAD) {
 check_continued:
 				/*
@@ -1549,9 +1545,9 @@ check_continued:
 				retval = wait_task_continued(p,
 						(options & WNOWAIT), infop,
 						stat_addr, ru);
-				if (retval != 0) /* He released the lock.  */
-					goto end;
 			}
+			if (retval != 0) /* tasklist_lock released */
+				goto end;
 		}
 		if (!flag) {
 			list_for_each_entry(p, &tsk->ptrace_children,
@@ -1587,7 +1583,7 @@ end:
 	remove_wait_queue(&current->signal->wait_chldexit,&wait);
 	if (infop) {
 		if (retval > 0)
-		retval = 0;
+			retval = 0;
 		else {
 			/*
 			 * For a WNOHANG return, clear out all the fields

