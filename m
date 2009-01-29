Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbZA2EcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbZA2EcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758602AbZA2Ebf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:31:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33317 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758439AbZA2Ebe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:31:34 -0500
Date: Thu, 29 Jan 2009 05:29:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Roland McGrath <roland@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] ptrace: kill __ptrace_detach(), fix ->exit_state check
Message-ID: <20090129042913.GA5100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the code from __ptrace_detach() to its single caller and kill this
helper.

Also, fix the ->exit_state check, we shouldn't wake up EXIT_DEAD tasks.
Actually, I think task_is_stopped_or_traced() makes more sense, but this
needs another patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/ptrace.c~1_KILL_DETACH	2009-01-29 02:30:00.000000000 +0100
+++ 6.29-rc3/kernel/ptrace.c	2009-01-29 03:24:51.000000000 +0100
@@ -235,16 +235,6 @@ out:
 	return retval;
 }
 
-static inline void __ptrace_detach(struct task_struct *child, unsigned int data)
-{
-	child->exit_code = data;
-	/* .. re-parent .. */
-	__ptrace_unlink(child);
-	/* .. and wake it up. */
-	if (child->exit_state != EXIT_ZOMBIE)
-		wake_up_process(child);
-}
-
 int ptrace_detach(struct task_struct *child, unsigned int data)
 {
 	if (!valid_signal(data))
@@ -254,10 +244,16 @@ int ptrace_detach(struct task_struct *ch
 	ptrace_disable(child);
 	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 
-	write_lock_irq(&tasklist_lock);
 	/* protect against de_thread()->release_task() */
-	if (child->ptrace)
-		__ptrace_detach(child, data);
+	write_lock_irq(&tasklist_lock);
+	if (child->ptrace) {
+		child->exit_code = data;
+
+		__ptrace_unlink(child);
+
+		if (!child->exit_state)
+			wake_up_process(child);
+	}
 	write_unlock_irq(&tasklist_lock);
 
 	return 0;

