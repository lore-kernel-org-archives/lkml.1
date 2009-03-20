Return-Path: <linux-kernel-owner+w=401wt.eu-S1758877AbZCTSEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877AbZCTSEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757275AbZCTSEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:04:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:42163 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959AbZCTSEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:04:12 -0400
Date: Fri, 20 Mar 2009 18:03:28 GMT
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, h-shimamoto@ct.jp.nec.com, hpa@zytor.com,
       mingo@redhat.com, roland@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
       linux-kernel@vger.kernel.org, roland@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49C2874D.3080002@ct.jp.nec.com>
References: <49C2874D.3080002@ct.jp.nec.com>
Subject: [tip:x86/signal] x86: signal: check signal stack overflow properly
Message-ID: <tip-14fc9fbc700dc95b4f46ebd588169324fe6deff8@git.kernel.org>
Git-Commit-ID: 14fc9fbc700dc95b4f46ebd588169324fe6deff8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 20 Mar 2009 18:03:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14fc9fbc700dc95b4f46ebd588169324fe6deff8
Gitweb:     http://git.kernel.org/tip/14fc9fbc700dc95b4f46ebd588169324fe6deff8
Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
AuthorDate: Thu, 19 Mar 2009 10:56:29 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 20 Mar 2009 19:01:31 +0100

x86: signal: check signal stack overflow properly

Impact: cleanup

Check alternate signal stack overflow with proper stack pointer.
The stack pointer of the next signal frame is different if that
task has i387 state.

On x86_64, redzone would be included.

No need to check SA_ONSTACK if we're already using alternate signal stack.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Roland McGrath <roland@redhat.com>
LKML-Reference: <49C2874D.3080002@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/signal.c |   48 +++++++++++++++++++++++++--------------------
 1 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index d2cc642..dfcc74a 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -211,31 +211,27 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 {
 	/* Default to using normal stack */
 	unsigned long sp = regs->sp;
+	int onsigstack = on_sig_stack(sp);
 
 #ifdef CONFIG_X86_64
 	/* redzone */
 	sp -= 128;
 #endif /* CONFIG_X86_64 */
 
-	/*
-	 * If we are on the alternate signal stack and would overflow it, don't.
-	 * Return an always-bogus address instead so we will die with SIGSEGV.
-	 */
-	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - frame_size)))
-		return (void __user *) -1L;
-
-	/* This is the X/Open sanctioned signal stack switching.  */
-	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (sas_ss_flags(sp) == 0)
-			sp = current->sas_ss_sp + current->sas_ss_size;
-	} else {
+	if (!onsigstack) {
+		/* This is the X/Open sanctioned signal stack switching.  */
+		if (ka->sa.sa_flags & SA_ONSTACK) {
+			if (sas_ss_flags(sp) == 0)
+				sp = current->sas_ss_sp + current->sas_ss_size;
+		} else {
 #ifdef CONFIG_X86_32
-		/* This is the legacy signal stack switching. */
-		if ((regs->ss & 0xffff) != __USER_DS &&
-			!(ka->sa.sa_flags & SA_RESTORER) &&
-				ka->sa.sa_restorer)
-			sp = (unsigned long) ka->sa.sa_restorer;
+			/* This is the legacy signal stack switching. */
+			if ((regs->ss & 0xffff) != __USER_DS &&
+				!(ka->sa.sa_flags & SA_RESTORER) &&
+					ka->sa.sa_restorer)
+				sp = (unsigned long) ka->sa.sa_restorer;
 #endif /* CONFIG_X86_32 */
+		}
 	}
 
 	if (used_math()) {
@@ -244,12 +240,22 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 		sp = round_down(sp, 64);
 #endif /* CONFIG_X86_64 */
 		*fpstate = (void __user *)sp;
-
-		if (save_i387_xstate(*fpstate) < 0)
-			return (void __user *)-1L;
 	}
 
-	return (void __user *)align_sigframe(sp - frame_size);
+	sp = align_sigframe(sp - frame_size);
+
+	/*
+	 * If we are on the alternate signal stack and would overflow it, don't.
+	 * Return an always-bogus address instead so we will die with SIGSEGV.
+	 */
+	if (onsigstack && !likely(on_sig_stack(sp)))
+		return (void __user *)-1L;
+
+	/* save i387 state */
+	if (used_math() && save_i387_xstate(*fpstate) < 0)
+		return (void __user *)-1L;
+
+	return (void __user *)sp;
 }
 
 #ifdef CONFIG_X86_32
