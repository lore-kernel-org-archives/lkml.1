Return-Path: <linux-kernel-owner+w=401wt.eu-S933516AbZDHMEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516AbZDHMEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932575AbZDHLzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:55:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:37376 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764927AbZDHLzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:55:21 -0400
Date: Wed, 8 Apr 2009 11:54:44 GMT
From: Jiri Slaby <jirislaby@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jirislaby@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1239190320-23952-2-git-send-email-jirislaby@gmail.com>
References: <1239190320-23952-2-git-send-email-jirislaby@gmail.com>
Subject: [tip:x86/fpu] x86: unify restore_fpu_checking
Message-ID: <tip-34ba476a01e128aad51e02f9be854584e9ec73cf@git.kernel.org>
Git-Commit-ID: 34ba476a01e128aad51e02f9be854584e9ec73cf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 11:54:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  34ba476a01e128aad51e02f9be854584e9ec73cf
Gitweb:     http://git.kernel.org/tip/34ba476a01e128aad51e02f9be854584e9ec73cf
Author:     Jiri Slaby <jirislaby@gmail.com>
AuthorDate: Wed, 8 Apr 2009 13:31:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 13:46:01 +0200

x86: unify restore_fpu_checking

Impact: cleanup

On x86_32, separate f*rstor to an inline function which makes
restore_fpu_checking the same on both platforms -> move it
outside the ifdefs.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
LKML-Reference: <1239190320-23952-2-git-send-email-jirislaby@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
