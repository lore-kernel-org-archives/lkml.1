Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZBHSuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZBHSuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 13:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZBHStw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 13:49:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36116 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbZBHStu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 13:49:50 -0500
Date: Sun, 8 Feb 2009 19:47:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Roland McGrath <roland@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ptrace_detach: the wrong wakeup breaks the ERESTARTxxx
	logic
Message-ID: <20090208184724.GA27074@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another ancient bug. Consider this trivial test-case,

	int main(void)
	{
		int pid = fork();

		if (pid) {
			ptrace(PTRACE_ATTACH, pid, NULL, NULL);
			wait(NULL);
			ptrace(PTRACE_DETACH, pid, NULL, NULL);
		} else {
			pause();
			printf("WE HAVE A KERNEL BUG!!!\n");
		}

		return 0;
	}

the child must not "escape" for sys_pause(), but it can and this was seen
in practice.

This is because ptrace_detach does:

	if (!child->exit_state)
		wake_up_process(child);

this wakeup can happen after this child has already restarted sys_pause(),
because it gets another wakeup from ptrace_untrace().

It is not clear to me what was the rationale, but this is obviously wrong.
Remove this wakeup. The caller saw this task in TASK_TRACED state, and
unless it was SIGKILL'ed in between __ptrace_unlink()->ptrace_untrace()
should handle this case correctly. If it was SIGKILL'ed, we don't need
to wakup the dying tracee too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/ptrace.c~1_KILL_WAKE	2009-02-08 04:26:57.000000000 +0100
+++ 6.29-rc3/kernel/ptrace.c	2009-02-08 05:11:52.000000000 +0100
@@ -250,11 +250,7 @@ int ptrace_detach(struct task_struct *ch
 	/* protect against de_thread()->release_task() */
 	if (child->ptrace) {
 		child->exit_code = data;
-
 		dead = __ptrace_detach(current, child);
-
-		if (!child->exit_state)
-			wake_up_process(child);
 	}
 	write_unlock_irq(&tasklist_lock);
 

