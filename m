Return-Path: <linux-kernel-owner+w=401wt.eu-S1759909AbZKFVVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909AbZKFVVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 16:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759900AbZKFVVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 16:21:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759887AbZKFVV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 16:21:29 -0500
Date: Fri, 6 Nov 2009 22:16:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: [PATCH] ptrace: copy_thread() should clear TIF_SINGLESTEP and
	X86_EFLAGS_TF
Message-ID: <20091106211637.GA1696@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes x86, other machines need the similar fix. Hopefully
maintainers can help.

If the tracee calls fork() after PTRACE_SINGLESTEP, the forked child starts
with TIF_SINGLESTEP/X86_EFLAGS_TF bits copied from ptraced parent. This is
not right, especially when the new child is not auto-attaced: in this case
it is killed by SIGTRAP.

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

Tested on x86_64, hopefully the change in process_32.c is right too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/x86/kernel/process_32.c |    3 +++
 arch/x86/kernel/process_64.c |    3 +++
 2 files changed, 6 insertions(+)

--- V1/arch/x86/kernel/process_32.c~FORK_CLEAR_TIF_SINGLESTEP	2009-09-15 08:45:40.000000000 +0200
+++ V1/arch/x86/kernel/process_32.c	2009-11-06 21:51:57.000000000 +0100
@@ -252,6 +252,8 @@ int copy_thread(unsigned long clone_flag
 	childregs->ax = 0;
 	childregs->sp = sp;
 
+	childregs->flags &= ~X86_EFLAGS_TF;
+
 	p->thread.sp = (unsigned long) childregs;
 	p->thread.sp0 = (unsigned long) (childregs+1);
 
@@ -287,6 +289,7 @@ int copy_thread(unsigned long clone_flag
 	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
 	p->thread.ds_ctx = NULL;
 
+	clear_tsk_thread_flag(p, TIF_SINGLESTEP);
 	clear_tsk_thread_flag(p, TIF_DEBUGCTLMSR);
 	p->thread.debugctlmsr = 0;
 
--- V1/arch/x86/kernel/process_64.c~FORK_CLEAR_TIF_SINGLESTEP	2009-09-15 08:45:40.000000000 +0200
+++ V1/arch/x86/kernel/process_64.c	2009-11-06 21:45:16.000000000 +0100
@@ -289,6 +289,8 @@ int copy_thread(unsigned long clone_flag
 	if (sp == ~0UL)
 		childregs->sp = (unsigned long)childregs;
 
+	childregs->flags &= ~X86_EFLAGS_TF;
+
 	p->thread.sp = (unsigned long) childregs;
 	p->thread.sp0 = (unsigned long) (childregs+1);
 	p->thread.usersp = me->thread.usersp;
@@ -332,6 +334,7 @@ int copy_thread(unsigned long clone_flag
 	clear_tsk_thread_flag(p, TIF_DS_AREA_MSR);
 	p->thread.ds_ctx = NULL;
 
+	clear_tsk_thread_flag(p, TIF_SINGLESTEP);
 	clear_tsk_thread_flag(p, TIF_DEBUGCTLMSR);
 	p->thread.debugctlmsr = 0;
 

