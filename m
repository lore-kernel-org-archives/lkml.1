Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbZKYPqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbZKYPqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 10:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbZKYPqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 10:46:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbZKYPqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 10:46:15 -0500
Date: Wed, 25 Nov 2009 16:40:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 0/14] utrace/ptrace
Message-ID: <20091125154052.GA6734@redhat.com>
References: <20091124200127.GA5751@redhat.com> <20091125080342.GD2660@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125080342.GD2660@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25, Ananth N Mavinakayanahalli wrote:
>
> I ran the ptrace-tests testsuite [1] on powerpc on the vanilla ptrace
> and then with ptrace/utrace. The results for ptrace/utrace look better
> :-)

Great! thanks a lot Ananth for doing this.

ptrace-utrace still fails 2 tests,

> FAIL: syscall-reset

I'll take a look later. Since unpatched kernel fails this test too
I am not going to worry right now. I think this is ppc specific, x86
passes this test.

> step-fork: step-fork.c:56: handler_fail: Assertion `0' failed.
> /bin/sh: line 5: 24803 Aborted                 ${dir}$tst
> FAIL: step-fork

This is expected. Should be fixed by

	ptrace-copy_process-should-disable-stepping.patch

in -mm tree. (I am attaching this patch below just in case)
I din't mention this patch in this series because this bug
is "ortogonal" to utrace/ptrace.

Oleg.

------------------------------------------------------
If the tracee calls fork() after PTRACE_SINGLESTEP, the forked child
starts with TIF_SINGLESTEP/X86_EFLAGS_TF bits copied from ptraced parent.
This is not right, especially when the new child is not auto-attaced: in
this case it is killed by SIGTRAP.

Change copy_process() to call user_disable_single_step(). Tested on x86.

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
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/fork.c~ptrace-copy_process-should-disable-stepping kernel/fork.c
--- a/kernel/fork.c~ptrace-copy_process-should-disable-stepping
+++ a/kernel/fork.c
@@ -1203,9 +1203,10 @@ static struct task_struct *copy_process(
 		p->sas_ss_sp = p->sas_ss_size = 0;
 
 	/*
-	 * Syscall tracing should be turned off in the child regardless
-	 * of CLONE_PTRACE.
+	 * Syscall tracing and stepping should be turned off in the
+	 * child regardless of CLONE_PTRACE.
 	 */
+	user_disable_single_step(p);
 	clear_tsk_thread_flag(p, TIF_SYSCALL_TRACE);
 #ifdef TIF_SYSCALL_EMU
 	clear_tsk_thread_flag(p, TIF_SYSCALL_EMU);

