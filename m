Return-Path: <linux-kernel-owner+w=401wt.eu-S1762768AbXJMOrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762768AbXJMOrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761283AbXJMOmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:31 -0400
Received: from 1wt.eu ([62.212.114.60]:2974 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761871AbXJMOm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:29 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143459.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:41 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Kumar Gala <galak@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 19/35] POWERPC: Flush registers to proper task context
Content-Disposition: inline; filename=0064-POWERPC-Flush-registers-to-proper-task-context.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0ee6c15e7ba7b36a217cdadb292eeaf32a057a59 in mainline.

When we flush register state for FP, Altivec, or SPE in flush_*_to_thread
we need to respect the task_struct that the caller has passed to us.

Most cases we are called with current, however sometimes (ptrace) we may
be passed a different task_struct.

This showed up when using gdbserver debugging a simple program that used
floating point. When gdb tried to show the FP regs they all showed up as
0, because the child's FP registers were never properly flushed to memory.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/kernel/process.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

Index: 2.6/arch/powerpc/kernel/process.c
===================================================================
--- 2.6.orig/arch/powerpc/kernel/process.c
+++ 2.6/arch/powerpc/kernel/process.c
@@ -84,7 +84,7 @@ void flush_fp_to_thread(struct task_stru
 			 */
 			BUG_ON(tsk != current);
 #endif
-			giveup_fpu(current);
+			giveup_fpu(tsk);
 		}
 		preempt_enable();
 	}
@@ -144,7 +144,7 @@ void flush_altivec_to_thread(struct task
 #ifdef CONFIG_SMP
 			BUG_ON(tsk != current);
 #endif
-			giveup_altivec(current);
+			giveup_altivec(tsk);
 		}
 		preempt_enable();
 	}
@@ -183,7 +183,7 @@ void flush_spe_to_thread(struct task_str
 #ifdef CONFIG_SMP
 			BUG_ON(tsk != current);
 #endif
-			giveup_spe(current);
+			giveup_spe(tsk);
 		}
 		preempt_enable();
 	}

-- 
