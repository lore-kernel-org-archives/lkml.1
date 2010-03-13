Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935516Ab0CMAcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:32:17 -0500
Received: from kroah.org ([198.145.64.141]:46780 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935386Ab0CMAbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:09 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:08 2010
Message-Id: <20100313002708.215028751@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [034/145] sparc: Align clone and signal stacks to 16 bytes.
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commits f036d9f3985a529a81e582f68aa984eb7b20d54d
  and 440ab7ac2d6b735fb278a1ff1674f6716314c6bb ]

This is mandatory for 64-bit processes, and doing it also for 32-bit
processes saves a conditional in the compat case.

This fixes the glibc/nptl/tst-stdio1 test case, as well
as many others, on 64-bit.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/kernel/process_32.c |    2 +-
 arch/sparc/kernel/process_64.c |    8 ++++----
 arch/sparc/kernel/signal32.c   |   10 ++++++----
 arch/sparc/kernel/signal_32.c  |    6 ++++--
 arch/sparc/kernel/signal_64.c  |    8 +++++---
 5 files changed, 20 insertions(+), 14 deletions(-)

--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -526,7 +526,7 @@ int copy_thread(unsigned long clone_flag
 			 * Set some valid stack frames to give to the child.
 			 */
 			childstack = (struct sparc_stackf __user *)
-				(sp & ~0x7UL);
+				(sp & ~0xfUL);
 			parentstack = (struct sparc_stackf __user *)
 				regs->u_regs[UREG_FP];
 
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -398,11 +398,11 @@ static unsigned long clone_stackframe(un
 	} else
 		__get_user(fp, &(((struct reg_window32 __user *)psp)->ins[6]));
 
-	/* Now 8-byte align the stack as this is mandatory in the
-	 * Sparc ABI due to how register windows work.  This hides
-	 * the restriction from thread libraries etc.  -DaveM
+	/* Now align the stack as this is mandatory in the Sparc ABI
+	 * due to how register windows work.  This hides the
+	 * restriction from thread libraries etc.
 	 */
-	csp &= ~7UL;
+	csp &= ~15UL;
 
 	distance = fp - psp;
 	rval = (csp - distance);
--- a/arch/sparc/kernel/signal32.c
+++ b/arch/sparc/kernel/signal32.c
@@ -120,8 +120,8 @@ struct rt_signal_frame32 {
 };
 
 /* Align macros */
-#define SF_ALIGNEDSZ  (((sizeof(struct signal_frame32) + 7) & (~7)))
-#define RT_ALIGNEDSZ  (((sizeof(struct rt_signal_frame32) + 7) & (~7)))
+#define SF_ALIGNEDSZ  (((sizeof(struct signal_frame32) + 15) & (~15)))
+#define RT_ALIGNEDSZ  (((sizeof(struct rt_signal_frame32) + 15) & (~15)))
 
 int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 {
@@ -420,15 +420,17 @@ static void __user *get_sigframe(struct
 			sp = current->sas_ss_sp + current->sas_ss_size;
 	}
 
+	sp -= framesize;
+
 	/* Always align the stack frame.  This handles two cases.  First,
 	 * sigaltstack need not be mindful of platform specific stack
 	 * alignment.  Second, if we took this signal because the stack
 	 * is not aligned properly, we'd like to take the signal cleanly
 	 * and report that.
 	 */
-	sp &= ~7UL;
+	sp &= ~15UL;
 
-	return (void __user *)(sp - framesize);
+	return (void __user *) sp;
 }
 
 static int save_fpu_state32(struct pt_regs *regs, __siginfo_fpu_t __user *fpu)
--- a/arch/sparc/kernel/signal_32.c
+++ b/arch/sparc/kernel/signal_32.c
@@ -267,15 +267,17 @@ static inline void __user *get_sigframe(
 			sp = current->sas_ss_sp + current->sas_ss_size;
 	}
 
+	sp -= framesize;
+
 	/* Always align the stack frame.  This handles two cases.  First,
 	 * sigaltstack need not be mindful of platform specific stack
 	 * alignment.  Second, if we took this signal because the stack
 	 * is not aligned properly, we'd like to take the signal cleanly
 	 * and report that.
 	 */
-	sp &= ~7UL;
+	sp &= ~15UL;
 
-	return (void __user *)(sp - framesize);
+	return (void __user *) sp;
 }
 
 static inline int
--- a/arch/sparc/kernel/signal_64.c
+++ b/arch/sparc/kernel/signal_64.c
@@ -353,7 +353,7 @@ segv:
 /* Checks if the fp is valid */
 static int invalid_frame_pointer(void __user *fp, int fplen)
 {
-	if (((unsigned long) fp) & 7)
+	if (((unsigned long) fp) & 15)
 		return 1;
 	return 0;
 }
@@ -396,15 +396,17 @@ static inline void __user *get_sigframe(
 			sp = current->sas_ss_sp + current->sas_ss_size;
 	}
 
+	sp -= framesize;
+
 	/* Always align the stack frame.  This handles two cases.  First,
 	 * sigaltstack need not be mindful of platform specific stack
 	 * alignment.  Second, if we took this signal because the stack
 	 * is not aligned properly, we'd like to take the signal cleanly
 	 * and report that.
 	 */
-	sp &= ~7UL;
+	sp &= ~15UL;
 
-	return (void __user *)(sp - framesize);
+	return (void __user *) sp;
 }
 
 static inline void


