Return-Path: <linux-kernel-owner+w=401wt.eu-S1762629AbXLTMJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762629AbXLTMJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760776AbXLTMBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:01:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760355AbXLTMAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 29/43] x86 user_regset math_emu
Message-Id: <20071220115948.0D68F26F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:59:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the ptrace/signal accessors for i387 math_emu
state to the user_regset interface style, and calls these
from the old interfaces.

It also cleans up math_emulate's ptrace check to be a
single-step check, which is what it really wants.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/math-emu/fpu_entry.c |   86 +++++++++++++++++++++++++---------------
 1 files changed, 54 insertions(+), 32 deletions(-)

diff --git a/arch/x86/math-emu/fpu_entry.c b/arch/x86/math-emu/fpu_entry.c
index 377c60d..cfbdaa1 100644
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -25,10 +25,11 @@
  +---------------------------------------------------------------------------*/
 
 #include <linux/signal.h>
-#include <linux/ptrace.h>
+#include <linux/regset.h>
 
 #include <asm/uaccess.h>
 #include <asm/desc.h>
+#include <asm/user.h>
 
 #include "fpu_system.h"
 #include "fpu_emu.h"
@@ -198,9 +199,7 @@ asmlinkage void math_emulate(long arg)
 			code_limit = 0xffffffff;
 	}
 
-	FPU_lookahead = 1;
-	if (current->ptrace & PT_PTRACED)
-		FPU_lookahead = 0;
+	FPU_lookahead = !(FPU_EFLAGS & X86_EFLAGS_TF);
 
 	if (!valid_prefix(&byte1, (u_char __user **) & FPU_EIP,
 			  &addr_modes.override)) {
@@ -673,31 +672,37 @@ void math_abort(struct info *info, unsigned int signal)
 #define sstatus_word() \
   ((S387->swd & ~SW_Top & 0xffff) | ((S387->ftop << SW_Top_Shift) & SW_Top))
 
-int restore_i387_soft(void *s387, struct _fpstate __user *buf)
+int fpregs_soft_set(struct task_struct *target,
+		    const struct user_regset *regset,
+		    unsigned int pos, unsigned int count,
+		    const void *kbuf, const void __user *ubuf)
 {
-	u_char __user *d = (u_char __user *) buf;
+	struct i387_soft_struct *s387 = &target->thread.i387.soft;
+	void *space = s387->st_space;
+	int ret;
 	int offset, other, i, tags, regnr, tag, newtop;
 
 	RE_ENTRANT_CHECK_OFF;
-	FPU_access_ok(VERIFY_READ, d, 7 * 4 + 8 * 10);
-	if (__copy_from_user(&S387->cwd, d, 7 * 4))
-		return -1;
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, s387, 0,
+				 offsetof(struct i387_soft_struct, st_space));
 	RE_ENTRANT_CHECK_ON;
 
-	d += 7 * 4;
+	if (ret)
+		return ret;
 
 	S387->ftop = (S387->swd >> SW_Top_Shift) & 7;
 	offset = (S387->ftop & 7) * 10;
 	other = 80 - offset;
 
 	RE_ENTRANT_CHECK_OFF;
+
 	/* Copy all registers in stack order. */
-	if (__copy_from_user(((u_char *) & S387->st_space) + offset, d, other))
-		return -1;
-	if (offset)
-		if (__copy_from_user
-		    ((u_char *) & S387->st_space, d + other, offset))
-			return -1;
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+				 space + offset, 0, other);
+	if (!ret && offset)
+		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
+					 space, 0, offset);
+
 	RE_ENTRANT_CHECK_ON;
 
 	/* The tags may need to be corrected now. */
@@ -716,16 +721,21 @@ int restore_i387_soft(void *s387, struct _fpstate __user *buf)
 	}
 	S387->twd = tags;
 
-	return 0;
+	return ret;
 }
 
-int save_i387_soft(void *s387, struct _fpstate __user * buf)
+int fpregs_soft_get(struct task_struct *target,
+		    const struct user_regset *regset,
+		    unsigned int pos, unsigned int count,
+		    void *kbuf, void __user *ubuf)
 {
-	u_char __user *d = (u_char __user *) buf;
+	struct i387_soft_struct *s387 = &target->thread.i387.soft;
+	const void *space = s387->st_space;
+	int ret;
 	int offset = (S387->ftop & 7) * 10, other = 80 - offset;
 
 	RE_ENTRANT_CHECK_OFF;
-	FPU_access_ok(VERIFY_WRITE, d, 7 * 4 + 8 * 10);
+
 #ifdef PECULIAR_486
 	S387->cwd &= ~0xe080;
 	/* An 80486 sets nearly all of the reserved bits to 1. */
@@ -735,21 +745,33 @@ int save_i387_soft(void *s387, struct _fpstate __user * buf)
 	S387->fcs &= ~0xf8000000;
 	S387->fos |= 0xffff0000;
 #endif /* PECULIAR_486 */
-	if (__copy_to_user(d, &S387->cwd, 7 * 4))
-		return -1;
-	RE_ENTRANT_CHECK_ON;
 
-	d += 7 * 4;
+	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf, s387, 0,
+				  offsetof(struct i387_soft_struct, st_space));
 
-	RE_ENTRANT_CHECK_OFF;
 	/* Copy all registers in stack order. */
-	if (__copy_to_user(d, ((u_char *) & S387->st_space) + offset, other))
-		return -1;
-	if (offset)
-		if (__copy_to_user
-		    (d + other, (u_char *) & S387->st_space, offset))
-			return -1;
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					  space + offset, 0, other);
+	if (!ret)
+		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
+					  space, 0, offset);
+
 	RE_ENTRANT_CHECK_ON;
 
-	return 1;
+	return ret;
+}
+
+int save_i387_soft(void *s387, struct _fpstate __user *buf)
+{
+	return fpregs_soft_get(current, NULL,
+			       0, sizeof(struct user_i387_struct),
+			       NULL, buf) ? -1 : 1;
+}
+
+int restore_i387_soft(void *s387, struct _fpstate __user *buf)
+{
+	return fpregs_soft_set(current, NULL,
+			       0, sizeof(struct user_i387_struct),
+			       NULL, buf) ? -1 : 1;
 }
-- 
1.5.3.6

