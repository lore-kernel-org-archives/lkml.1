Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab0BBTAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:00:25 -0500
Received: from verein.lst.de ([213.95.11.210]:38030 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756887Ab0BBTAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:00:08 -0500
Date: Tue, 2 Feb 2010 19:59:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org,
       monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 8/14] microblaze: use generic ptrace_resume code
Message-ID: <20100202185946.GH3630@lst.de>
References: <20100202185755.GA3630@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202185755.GA3630@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the generic ptrace_resume code for PTRACE_SYSCALL, PTRACE_CONT and
PTRACE_KILL.  This also makes PTRACE_SINGLESTEP return -EIO while it
previously succeeded despite not actually causing any kind of single
stepping.

Also the TIF_SYSCALL_TRACE thread flag is now cleared on PTRACE_KILL
which it previously wasn't which is consistent with all architectures
using the modern ptrace code.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/microblaze/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/microblaze/kernel/ptrace.c	2010-02-02 11:23:56.002003861 +0100
+++ linux-2.6/arch/microblaze/kernel/ptrace.c	2010-02-02 19:20:16.997254566 +0100
@@ -110,43 +110,6 @@ long arch_ptrace(struct task_struct *chi
 		if (rval == 0 && request == PTRACE_PEEKUSR)
 			rval = put_user(val, (unsigned long *)data);
 		break;
-	/* Continue and stop at next (return from) syscall */
-	case PTRACE_SYSCALL:
-		pr_debug("PTRACE_SYSCALL\n");
-	case PTRACE_SINGLESTEP:
-		pr_debug("PTRACE_SINGLESTEP\n");
-	/* Restart after a signal.  */
-	case PTRACE_CONT:
-		pr_debug("PTRACE_CONT\n");
-		rval = -EIO;
-		if (!valid_signal(data))
-			break;
-
-		if (request == PTRACE_SYSCALL)
-			set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-		else
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-
-		child->exit_code = data;
-		pr_debug("wakeup_process\n");
-		wake_up_process(child);
-		rval = 0;
-		break;
-
-	/*
-	 * make the child exit.  Best I can do is send it a sigkill.
-	 * perhaps it should be put in the status that it wants to
-	 * exit.
-	 */
-	case PTRACE_KILL:
-		pr_debug("PTRACE_KILL\n");
-		rval = 0;
-		if (child->exit_state == EXIT_ZOMBIE)	/* already dead */
-			break;
-		child->exit_code = SIGKILL;
-		wake_up_process(child);
-		break;
-
 	default:
 		rval = ptrace_request(child, request, addr, data);
 	}
