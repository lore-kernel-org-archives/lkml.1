Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbZKGWAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbZKGWAr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 17:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbZKGWAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 17:00:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbZKGWAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 17:00:45 -0500
Date: Sat, 7 Nov 2009 22:55:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: [PATCH] ptrace: copy_process() should disable stepping
Message-ID: <20091107215547.GA25335@redhat.com>
References: <20091106211637.GA1696@redhat.com> <20091106212554.BD731CF@magilla.sf.frob.com> <20091106215004.GA2232@redhat.com> <20091106221002.8057DCF@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091106221002.8057DCF@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the tracee calls fork() after PTRACE_SINGLESTEP, the forked child starts
with TIF_SINGLESTEP/X86_EFLAGS_TF bits copied from ptraced parent. This is
not right, especially when the new child is not auto-attaced: in this case
it is killed by SIGTRAP.

Change copy_process() to call user_disable_single_step() if TIF_SINGLESTEP
is set. Tested on x86, hopefully this is correct on any architecture.

Test-case:

	#include <stdio.h>
	#include <unistd.h>
	#include <signal.h>
	#include <sys/ptrace.h>
	#include <sys/wait.h>
	#include <assert.h>

	int main(void)
	{
		int pid, status;

		if (!(pid = fork())) {
			assert(ptrace(PTRACE_TRACEME) == 0);
			kill(getpid(), SIGSTOP);

			if (!fork()) {
				/* kernel bug: this child will be killed by SIGTRAP */
				printf("Hello world\n");
				return 43;
			}

			wait(&status);
			return WEXITSTATUS(status);
		}

		for (;;) {
			assert(pid == wait(&status));
			if (WIFEXITED(status))
				break;
			assert(ptrace(PTRACE_SINGLESTEP, pid, 0,0) == 0);
		}

		assert(WEXITSTATUS(status) == 43);
		return 0;
	}

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/fork.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- V1/kernel/fork.c~FORK_DISABLE_STEP	2009-10-09 19:52:23.000000000 +0200
+++ V1/kernel/fork.c	2009-11-07 22:15:15.000000000 +0100
@@ -1199,10 +1199,14 @@ static struct task_struct *copy_process(
 		p->sas_ss_sp = p->sas_ss_size = 0;
 
 	/*
-	 * Syscall tracing should be turned off in the child regardless
-	 * of CLONE_PTRACE.
+	 * Syscall tracing and stepping hould be turned off in the
+	 * child regardless of CLONE_PTRACE.
 	 */
 	clear_tsk_thread_flag(p, TIF_SYSCALL_TRACE);
+#ifdef TIF_SINGLESTEP
+	if (unlikely(test_tsk_thread_flag(p, TIF_SINGLESTEP)))
+		user_disable_single_step(p);
+#endif
 #ifdef TIF_SYSCALL_EMU
 	clear_tsk_thread_flag(p, TIF_SYSCALL_EMU);
 #endif

