Return-Path: <linux-kernel-owner+w=401wt.eu-S1762246AbYEMUPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762246AbYEMUPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761841AbYEMUNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:13:46 -0400
Received: from mail.suse.de ([195.135.220.2]:37770 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761819AbYEMUNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:13:45 -0400
Date: Tue, 13 May 2008 13:11:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 07/37] sparc: Fix SA_ONSTACK signal handling.
Message-ID: <20080513201147.GH31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc-fix-sa_onstack-signal-handling.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit: dc5dc7e6d71ca9fd1ea01a1418150af3b2937489 ]

We need to be more liberal about the alignment of the buffer given to
us by sigaltstack().  The user should not need to be mindful of all of
the alignment constraints we have for the stack frame.

This mirrors how we handle this situation in clone() as well.

Also, we align the stack even in non-SA_ONSTACK cases so that signals
due to bad stack alignment can be delivered properly.  This makes such
errors easier to debug and recover from.

Finally, add the sanity check x86 has to make sure we won't overflow
the signal stack.

This fixes glibc testcases nptl/tst-cancel20.c and
nptl/tst-cancelx20.c

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/kernel/signal.c     |   20 +++++++++++++++++---
 arch/sparc64/kernel/signal.c   |   21 +++++++++++++++++----
 arch/sparc64/kernel/signal32.c |   18 +++++++++++++++++-
 3 files changed, 51 insertions(+), 8 deletions(-)

--- a/arch/sparc64/kernel/signal32.c
+++ b/arch/sparc64/kernel/signal32.c
@@ -497,11 +497,27 @@ static void __user *get_sigframe(struct 
 	regs->u_regs[UREG_FP] &= 0x00000000ffffffffUL;
 	sp = regs->u_regs[UREG_FP];
 	
+	/*
+	 * If we are on the alternate signal stack and would overflow it, don't.
+	 * Return an always-bogus address instead so we will die with SIGSEGV.
+	 */
+	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - framesize)))
+		return (void __user *) -1L;
+
 	/* This is the X/Open sanctioned signal stack switching.  */
 	if (sa->sa_flags & SA_ONSTACK) {
-		if (!on_sig_stack(sp) && !((current->sas_ss_sp + current->sas_ss_size) & 7))
+		if (sas_ss_flags(sp) == 0)
 			sp = current->sas_ss_sp + current->sas_ss_size;
 	}
+
+	/* Always align the stack frame.  This handles two cases.  First,
+	 * sigaltstack need not be mindful of platform specific stack
+	 * alignment.  Second, if we took this signal because the stack
+	 * is not aligned properly, we'd like to take the signal cleanly
+	 * and report that.
+	 */
+	sp &= ~7UL;
+
 	return (void __user *)(sp - framesize);
 }
 
--- a/arch/sparc64/kernel/signal.c
+++ b/arch/sparc64/kernel/signal.c
@@ -377,16 +377,29 @@ save_fpu_state(struct pt_regs *regs, __s
 
 static inline void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, unsigned long framesize)
 {
-	unsigned long sp;
+	unsigned long sp = regs->u_regs[UREG_FP] + STACK_BIAS;
 
-	sp = regs->u_regs[UREG_FP] + STACK_BIAS;
+	/*
+	 * If we are on the alternate signal stack and would overflow it, don't.
+	 * Return an always-bogus address instead so we will die with SIGSEGV.
+	 */
+	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - framesize)))
+		return (void __user *) -1L;
 
 	/* This is the X/Open sanctioned signal stack switching.  */
 	if (ka->sa.sa_flags & SA_ONSTACK) {
-		if (!on_sig_stack(sp) &&
-		    !((current->sas_ss_sp + current->sas_ss_size) & 7))
+		if (sas_ss_flags(sp) == 0)
 			sp = current->sas_ss_sp + current->sas_ss_size;
 	}
+
+	/* Always align the stack frame.  This handles two cases.  First,
+	 * sigaltstack need not be mindful of platform specific stack
+	 * alignment.  Second, if we took this signal because the stack
+	 * is not aligned properly, we'd like to take the signal cleanly
+	 * and report that.
+	 */
+	sp &= ~7UL;
+
 	return (void __user *)(sp - framesize);
 }
 
--- a/arch/sparc/kernel/signal.c
+++ b/arch/sparc/kernel/signal.c
@@ -345,15 +345,29 @@ static inline int invalid_frame_pointer(
 
 static inline void __user *get_sigframe(struct sigaction *sa, struct pt_regs *regs, unsigned long framesize)
 {
-	unsigned long sp;
+	unsigned long sp = regs->u_regs[UREG_FP];
 
-	sp = regs->u_regs[UREG_FP];
+	/*
+	 * If we are on the alternate signal stack and would overflow it, don't.
+	 * Return an always-bogus address instead so we will die with SIGSEGV.
+	 */
+	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - framesize)))
+		return (void __user *) -1L;
 
 	/* This is the X/Open sanctioned signal stack switching.  */
 	if (sa->sa_flags & SA_ONSTACK) {
-		if (!on_sig_stack(sp) && !((current->sas_ss_sp + current->sas_ss_size) & 7))
+		if (sas_ss_flags(sp) == 0)
 			sp = current->sas_ss_sp + current->sas_ss_size;
 	}
+
+	/* Always align the stack frame.  This handles two cases.  First,
+	 * sigaltstack need not be mindful of platform specific stack
+	 * alignment.  Second, if we took this signal because the stack
+	 * is not aligned properly, we'd like to take the signal cleanly
+	 * and report that.
+	 */
+	sp &= ~7UL;
+
 	return (void __user *)(sp - framesize);
 }
 

-- 
