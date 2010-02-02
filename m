Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab0BBTA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:00:29 -0500
Received: from verein.lst.de ([213.95.11.210]:38038 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878Ab0BBTAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:00:19 -0500
Date: Tue, 2 Feb 2010 19:59:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org,
       ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 9/14] mips: use generic ptrace_resume code
Message-ID: <20100202185958.GI3630@lst.de>
References: <20100202185755.GA3630@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202185755.GA3630@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic ptrace_resume code for PTRACE_SYSCALL, PTRACE_CONT and
PTRACE_KILL.  

Also the TIF_SYSCALL_TRACE thread flag is now cleared on PTRACE_KILL
which it previously wasn't which is consistent with all architectures
using the modern ptrace code.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/mips/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/ptrace.c	2010-02-02 11:00:50.011010089 +0100
+++ linux-2.6/arch/mips/kernel/ptrace.c	2010-02-02 19:18:27.564005697 +0100
@@ -481,36 +481,6 @@ long arch_ptrace(struct task_struct *chi
 		ret = ptrace_setfpregs(child, (__u32 __user *) data);
 		break;
 
-	case PTRACE_SYSCALL: /* continue and stop at next (return from) syscall */
-	case PTRACE_CONT: { /* restart after signal. */
-		ret = -EIO;
-		if (!valid_signal(data))
-			break;
-		if (request == PTRACE_SYSCALL) {
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		}
-		else {
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		}
-		child->exit_code = data;
-		wake_up_process(child);
-		ret = 0;
-		break;
-	}
-
-	/*
-	 * make the child exit.  Best I can do is send it a sigkill.
-	 * perhaps it should be put in the status that it wants to
-	 * exit.
-	 */
-	case PTRACE_KILL:
-		ret = 0;
-		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
-			break;
-		child->exit_code = SIGKILL;
-		wake_up_process(child);
-		break;
-
 	case PTRACE_GET_THREAD_AREA:
 		ret = put_user(task_thread_info(child)->tp_value,
 				(unsigned long __user *) data);
