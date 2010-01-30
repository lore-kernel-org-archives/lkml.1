Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790Ab0A3UVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0A3UVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 15:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070Ab0A3UVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 15:21:05 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:57622 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0A3UVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 15:21:04 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: linuxppc-dev@ozlabs.org
Subject: [PATCH] powerpc: TIF_ABI_PENDING bit removal
CC: linux-kernel@vger.kernel.org
X-Yow: Yow!  Now we can become alcoholics!
Date: Sat, 30 Jan 2010 21:20:59 +0100
Message-ID: <m2zl3v5opg.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the powerpc bits to remove TIF_ABI_PENDING now that
set_personality() is called at the appropriate place in exec.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
 arch/powerpc/include/asm/elf.h         |    8 ++------
 arch/powerpc/include/asm/thread_info.h |    2 --
 arch/powerpc/kernel/process.c          |   12 ------------
 3 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/include/asm/elf.h b/arch/powerpc/include/asm/elf.h
index 17828ad..c376eda 100644
--- a/arch/powerpc/include/asm/elf.h
+++ b/arch/powerpc/include/asm/elf.h
@@ -235,14 +235,10 @@ typedef elf_vrregset_t elf_fpxregset_t;
 #ifdef __powerpc64__
 # define SET_PERSONALITY(ex)					\
 do {								\
-	unsigned long new_flags = 0;				\
 	if ((ex).e_ident[EI_CLASS] == ELFCLASS32)		\
-		new_flags = _TIF_32BIT;				\
-	if ((current_thread_info()->flags & _TIF_32BIT)		\
-	    != new_flags)					\
-		set_thread_flag(TIF_ABI_PENDING);		\
+		set_thread_flag(TIF_32BIT);			\
 	else							\
-		clear_thread_flag(TIF_ABI_PENDING);		\
+		clear_thread_flag(TIF_32BIT);			\
 	if (personality(current->personality) != PER_LINUX32)	\
 		set_personality(PER_LINUX |			\
 			(current->personality & (~PER_MASK)));	\
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index c8b3292..aa9d383 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -111,7 +111,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NOTIFY_RESUME	13	/* callback before returning to user */
 #define TIF_FREEZE		14	/* Freezing for suspend */
 #define TIF_RUNLATCH		15	/* Is the runlatch enabled? */
-#define TIF_ABI_PENDING		16	/* 32/64 bit switch needed */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -129,7 +128,6 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
-#define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
 #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
 
 #define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index c930ac3..7b816da 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -554,18 +554,6 @@ void exit_thread(void)
 
 void flush_thread(void)
 {
-#ifdef CONFIG_PPC64
-	struct thread_info *t = current_thread_info();
-
-	if (test_ti_thread_flag(t, TIF_ABI_PENDING)) {
-		clear_ti_thread_flag(t, TIF_ABI_PENDING);
-		if (test_ti_thread_flag(t, TIF_32BIT))
-			clear_ti_thread_flag(t, TIF_32BIT);
-		else
-			set_ti_thread_flag(t, TIF_32BIT);
-	}
-#endif
-
 	discard_lazy_cpu_state();
 
 	if (current->thread.dabr) {
-- 
1.6.6.1


Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
