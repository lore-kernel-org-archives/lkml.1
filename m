Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab0BBTA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:00:59 -0500
Received: from verein.lst.de ([213.95.11.210]:38056 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756905Ab0BBTAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:00:53 -0500
Date: Tue, 2 Feb 2010 20:00:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: roland@redhat.com, oleg@redhat.com, akpm@linux-foundation.org,
       starvik@axis.com, jesper.nilsson@axis.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 12/14] cris arch-v10: use generic ptrace_resume code
Message-ID: <20100202190031.GL3630@lst.de>
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

Index: linux-2.6/arch/cris/arch-v10/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v10/kernel/ptrace.c	2010-02-02 19:23:58.567254756 +0100
+++ linux-2.6/arch/cris/arch-v10/kernel/ptrace.c	2010-02-02 19:24:33.483004794 +0100
@@ -115,57 +115,6 @@ long arch_ptrace(struct task_struct *chi
 			ret = 0;
 			break;
 
-		case PTRACE_SYSCALL:
-		case PTRACE_CONT:
-			ret = -EIO;
-			
-			if (!valid_signal(data))
-				break;
-                        
-			if (request == PTRACE_SYSCALL) {
-				set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			}
-			else {
-				clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			}
-			
-			child->exit_code = data;
-			
-			/* TODO: make sure any pending breakpoint is killed */
-			wake_up_process(child);
-			ret = 0;
-			
-			break;
-		
- 		/* Make the child exit by sending it a sigkill. */
-		case PTRACE_KILL:
-			ret = 0;
-			
-			if (child->exit_state == EXIT_ZOMBIE)
-				break;
-			
-			child->exit_code = SIGKILL;
-			
-			/* TODO: make sure any pending breakpoint is killed */
-			wake_up_process(child);
-			break;
-
-		/* Set the trap flag. */
-		case PTRACE_SINGLESTEP:
-			ret = -EIO;
-			
-			if (!valid_signal(data))
-				break;
-			
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-
-			/* TODO: set some clever breakpoint mechanism... */
-
-			child->exit_code = data;
-			wake_up_process(child);
-			ret = 0;
-			break;
-
 		/* Get all GP registers from the child. */
 		case PTRACE_GETREGS: {
 		  	int i;
