Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbYIXAVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbYIXAVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 20:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYIXAVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 20:21:46 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:6583 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYIXAVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 20:21:45 -0400
Message-ID: <48D98819.9060409@ct.jp.nec.com>
Date: Tue, 23 Sep 2008 17:21:45 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: signal: cosmetic unification of do_notify_resume()
References: <48D987A0.50508@ct.jp.nec.com>
In-Reply-To: <48D987A0.50508@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Make do_notify_resume() same.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |    8 ++++++++
 arch/x86/kernel/signal_64.c |   16 ++++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index da3cf32..b94463f 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -663,6 +663,12 @@ static void do_signal(struct pt_regs *regs)
 void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
+#if defined(CONFIG_X86_64) && defined(CONFIG_X86_MCE)
+	/* notify userspace of pending MCEs */
+	if (thread_info_flags & _TIF_MCE_NOTIFY)
+		mce_notify_user();
+#endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
+
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
@@ -672,7 +678,9 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 		tracehook_notify_resume(regs);
 	}
 
+#ifdef CONFIG_X86_32
 	clear_thread_flag(TIF_IRET);
+#endif /* CONFIG_X86_32 */
 }
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 5a5fbc3..9087752 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -460,14 +460,18 @@ static void do_signal(struct pt_regs *regs)
 	}
 }
 
-void do_notify_resume(struct pt_regs *regs, void *unused,
-		      __u32 thread_info_flags)
+/*
+ * notification of userspace execution resumption
+ * - triggered by the TIF_WORK_MASK flags
+ */
+void
+do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
-#ifdef CONFIG_X86_MCE
+#if defined(CONFIG_X86_64) && defined(CONFIG_X86_MCE)
 	/* notify userspace of pending MCEs */
 	if (thread_info_flags & _TIF_MCE_NOTIFY)
 		mce_notify_user();
-#endif /* CONFIG_X86_MCE */
+#endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
 
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
@@ -477,6 +481,10 @@ void do_notify_resume(struct pt_regs *regs, void *unused,
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
 	}
+
+#ifdef CONFIG_X86_32
+	clear_thread_flag(TIF_IRET);
+#endif /* CONFIG_X86_32 */
 }
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
-- 
1.5.6

