Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbZDYAJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbZDYAJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 20:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756784AbZDYAJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 20:09:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823AbZDYAJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 20:09:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Russell King <rmk@arm.linux.org.uk>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Friday, 24 April 2009 17:06:34 -0700 <20090425000634.313E4FC3C8@magilla.sf.frob.com>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com>
Subject: [PATCH 01/17] arm: arch_ptrace clean-up
Message-Id: <20090425000732.ACB87FC3C8@magilla.sf.frob.com>
Date: Fri, 24 Apr 2009 17:07:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up arch_ptrace() on arm to use the generic ptrace_request()
for everything it can.  This gets rid of the non-arch ptrace internals
magic from the arch code.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/arm/kernel/ptrace.c |   66 ++++++++++-----------------------------------
 1 files changed, 15 insertions(+), 51 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 89882a1..825b7ab 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -706,76 +706,39 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	int ret;
 
 	switch (request) {
-		/*
-		 * read word at location "addr" in the child process.
-		 */
-		case PTRACE_PEEKTEXT:
-		case PTRACE_PEEKDATA:
-			ret = generic_ptrace_peekdata(child, addr, data);
-			break;
-
 		case PTRACE_PEEKUSR:
 			ret = ptrace_read_user(child, addr, (unsigned long __user *)data);
 			break;
 
-		/*
-		 * write the word at location addr.
-		 */
-		case PTRACE_POKETEXT:
-		case PTRACE_POKEDATA:
-			ret = generic_ptrace_pokedata(child, addr, data);
-			break;
-
 		case PTRACE_POKEUSR:
 			ret = ptrace_write_user(child, addr, data);
 			break;
 
 		/*
-		 * continue/restart and stop at next (return from) syscall
+		 * The generic code handles these mostly, but we have to
+		 * clear any previous single-step state first.  Note we
+		 * do single_step_disable() before even checking if the
+		 * ptrace request will fail for an invalid argument.
+		 * It's harmless in the error case, since we will have
+		 * come back through here or PTRACE_SINGLESTEP again
+		 * before it matters.
 		 */
 		case PTRACE_SYSCALL:
 		case PTRACE_CONT:
-			ret = -EIO;
-			if (!valid_signal(data))
-				break;
-			if (request == PTRACE_SYSCALL)
-				set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			else
-				clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			child->exit_code = data;
-			single_step_disable(child);
-			wake_up_process(child);
-			ret = 0;
-			break;
-
-		/*
-		 * make the child exit.  Best I can do is send it a sigkill.
-		 * perhaps it should be put in the status that it wants to
-		 * exit.
-		 */
 		case PTRACE_KILL:
 			single_step_disable(child);
-			if (child->exit_state != EXIT_ZOMBIE) {
-				child->exit_code = SIGKILL;
-				wake_up_process(child);
-			}
-			ret = 0;
-			break;
+			goto common;
 
 		/*
-		 * execute single instruction.
+		 * After we set up single-step state, the generic
+		 * PTRACE_CONT handling takes over and does the rest.
+		 * Note as above we don't bother with checking early
+		 * for the error case.
 		 */
 		case PTRACE_SINGLESTEP:
-			ret = -EIO;
-			if (!valid_signal(data))
-				break;
 			single_step_enable(child);
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			child->exit_code = data;
-			/* give it a chance to run. */
-			wake_up_process(child);
-			ret = 0;
-			break;
+			request = PTRACE_CONT;
+			goto common;
 
 		case PTRACE_GETREGS:
 			ret = ptrace_getregs(child, (void __user *)data);
@@ -834,6 +797,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 #endif
 
 		default:
+		common:
 			ret = ptrace_request(child, request, addr, data);
 			break;
 	}
