Return-Path: <linux-kernel-owner+w=401wt.eu-S933293AbZDHL5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933293AbZDHL5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764759AbZDHLdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:33:33 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:33808 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764763AbZDHLd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:33:28 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/3] x86: unify restore_fpu_checking
Date: Wed,  8 Apr 2009 13:31:59 +0200
Message-Id: <1239190320-23952-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1239190320-23952-1-git-send-email-jirislaby@gmail.com>
References: <1239190320-23952-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_32, separate f*rstor to an inline function which makes
restore_fpu_checking the same on both platforms -> move it outside
the ifdefs.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/i387.h |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 09a2d6d..7a6f21d 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -75,14 +75,6 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 	return err;
 }
 
-static inline int restore_fpu_checking(struct task_struct *tsk)
-{
-	if (task_thread_info(tsk)->status & TS_XSAVE)
-		return xrstor_checking(&tsk->thread.xstate->xsave);
-	else
-		return fxrstor_checking(&tsk->thread.xstate->fxsave);
-}
-
 /* AMD CPUs don't save/restore FDP/FIP/FOP unless an exception
    is pending. Clear the x87 state here by setting it to fixed
    values. The kernel data segment can be sometimes 0 and sometimes
@@ -185,10 +177,9 @@ static inline void tolerant_fwait(void)
 	asm volatile("fnclex ; fwait");
 }
 
-static inline int restore_fpu_checking(struct task_struct *tsk)
+/* perform fxrstor iff the processor has extended states, otherwise frstor */
+static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 {
-	if (task_thread_info(tsk)->status & TS_XSAVE)
-		return xrstor_checking(&tsk->thread.xstate->xsave);
 	/*
 	 * The "nop" is needed to make the instructions the same
 	 * length.
@@ -197,7 +188,8 @@ static inline int restore_fpu_checking(struct task_struct *tsk)
 		"nop ; frstor %1",
 		"fxrstor %1",
 		X86_FEATURE_FXSR,
-		"m" (tsk->thread.xstate->fxsave));
+		"m" (*fx));
+
 	return 0;
 }
 
@@ -261,6 +253,14 @@ end:
 
 #endif	/* CONFIG_X86_64 */
 
+static inline int restore_fpu_checking(struct task_struct *tsk)
+{
+	if (task_thread_info(tsk)->status & TS_XSAVE)
+		return xrstor_checking(&tsk->thread.xstate->xsave);
+	else
+		return fxrstor_checking(&tsk->thread.xstate->fxsave);
+}
+
 /*
  * Signal frame handlers...
  */
-- 
1.6.2

