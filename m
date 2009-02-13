Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbZBMK5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbZBMK5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 05:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZBMK5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 05:57:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51380 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbZBMK5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 05:57:22 -0500
Date: Fri, 13 Feb 2009 11:54:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Roland McGrath <roland@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/2] ptrace_detach: the wrong wakeup breaks the
	ERESTARTxxx logic
Message-ID: <20090213105437.GA24320@redhat.com>
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

With or without this patch, perhaps sys_pause() needs a fix. But this
wakeup also breaks the SIGNAL_STOP_STOPPED logic in ptrace_untrace().

Remove this wakeup. The caller saw this task in TASK_TRACED state, and
unless it was SIGKILL'ed in between __ptrace_unlink()->ptrace_untrace()
should handle this case correctly. If it was SIGKILL'ed, we don't need
to wakup the dying tracee too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- 6.29-rc3/kernel/ptrace.c~1_KILL_WAKE	2009-02-13 11:06:04.000000000 +0100
+++ 6.29-rc3/kernel/ptrace.c	2009-02-13 11:06:56.000000000 +0100
@@ -301,11 +301,7 @@ int ptrace_detach(struct task_struct *ch
 	 */
 	if (child->ptrace) {
 		child->exit_code = data;
-
 		dead = __ptrace_detach(current, child);
-
-		if (!child->exit_state)
-			wake_up_process(child);
 	}
 	write_unlock_irq(&tasklist_lock);
 

