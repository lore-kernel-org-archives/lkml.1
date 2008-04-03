Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbYDCVTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbYDCVTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729AbYDCVTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:19:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756814AbYDCVTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:19:31 -0400
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.25-rc8] x86 ptrace: avoid unnecessary wrmsr
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Perspicacious pronunciations
   (2) Spontaneous liver scenarios
   (3) Symmetrical fashions
Message-Id: <20080403211855.5BD3126F98D@magilla.localdomain>
Date: Thu,  3 Apr 2008 14:18:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids using wrmsr on MSR_IA32_DEBUGCTLMSR when it's not needed.
No wrmsr ever needs to be done if noone has ever used block stepping.

Without this change, using ptrace on 2.6.25 on an x86 KVM guest
will tickle KVM's missing support for the MSR and crash the guest
kernel.  Though host KVM is the buggy one, this makes for a regression
in the guest behavior from 2.6.24->2.6.25 that we can easily avoid.

I also corrected some bad whitespace.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/step.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 9d406cd..071ff47 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -140,6 +140,9 @@ static int enable_single_step(struct task_struct *child)
  */
 static void write_debugctlmsr(struct task_struct *child, unsigned long val)
 {
+	if (child->thread.debugctlmsr == val)
+		return;
+
 	child->thread.debugctlmsr = val;
 
 	if (child != current)
@@ -165,11 +168,11 @@ static void enable_step(struct task_struct *child, bool block)
 		write_debugctlmsr(child,
 				  child->thread.debugctlmsr | DEBUGCTLMSR_BTF);
 	} else {
-	    write_debugctlmsr(child,
-			      child->thread.debugctlmsr & ~DEBUGCTLMSR_BTF);
+		write_debugctlmsr(child,
+				  child->thread.debugctlmsr & ~DEBUGCTLMSR_BTF);
 
-	    if (!child->thread.debugctlmsr)
-		    clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
+		if (!child->thread.debugctlmsr)
+			clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
 	}
 }
 
