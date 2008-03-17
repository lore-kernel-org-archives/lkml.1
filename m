Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbYCQJVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbYCQJVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYCQJVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:21:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbYCQJVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:21:44 -0400
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86 handle_vm86_trap cleanup
X-Fcc: ~/Mail/linus
X-Windows: foiled again.
Message-Id: <20080317092108.EC6C626F995@magilla.localdomain>
Date: Mon, 17 Mar 2008 02:21:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use force_sig in handle_vm86_trap like other machine traps do.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/vm86_32.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 738c210..fddb998 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -553,16 +553,9 @@ int handle_vm86_trap(struct kernel_vm86_regs * regs, long error_code, int trapno
 	}
 	if (trapno !=1)
 		return 1; /* we let this handle by the calling routine */
-	if (current->ptrace & PT_PTRACED) {
-		unsigned long flags;
-		spin_lock_irqsave(&current->sighand->siglock, flags);
-		sigdelset(&current->blocked, SIGTRAP);
-		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
-	}
-	send_sig(SIGTRAP, current, 1);
 	current->thread.trap_no = trapno;
 	current->thread.error_code = error_code;
+	force_sig(SIGTRAP, current);
 	return 0;
 }
 
