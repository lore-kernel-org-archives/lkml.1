Return-Path: <linux-kernel-owner+w=401wt.eu-S1759077AbZB0Saq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbZB0Saq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 13:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbZB0Saf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 13:30:35 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:2629 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbZB0Sae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 13:30:34 -0500
Message-ID: <49A83148.6070500@ct.jp.nec.com>
Date: Fri, 27 Feb 2009 10:30:32 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] x86: signal: introduce helper align_sigframe()
References: <49A83078.3020207@ct.jp.nec.com>
In-Reply-To: <49A83078.3020207@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Introduce helper align_sigframe() to align stack pointer for signal frame.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 83212e3..ceeb466 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -191,6 +191,20 @@ setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 /*
  * Determine which stack to use..
  */
+static unsigned long align_sigframe(unsigned long sp)
+{
+#ifdef CONFIG_X86_32
+	/*
+	 * Align the stack pointer according to the i386 ABI,
+	 * i.e. so that on function entry ((sp + 4) & 15) == 0.
+	 */
+	sp = ((sp + 4) & -16ul) - 4;
+#else /* !CONFIG_X86_32 */
+	sp = round_down(sp, 16) - 8;
+#endif
+	return sp;
+}
+
 static inline void __user *
 get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 	     void __user **fpstate)
@@ -236,18 +250,7 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
 			return (void __user *)-1L;
 	}
 
-	sp -= frame_size;
-#ifdef CONFIG_X86_32
-	/*
-	 * Align the stack pointer according to the i386 ABI,
-	 * i.e. so that on function entry ((sp + 4) & 15) == 0.
-	 */
-	sp = ((sp + 4) & -16ul) - 4;
-#else /* !CONFIG_X86_32 */
-	sp = round_down(sp, 16) - 8;
-#endif
-
-	return (void __user *) sp;
+	return (void __user *)align_sigframe(sp - frame_size);
 }
 
 #ifdef CONFIG_X86_32
-- 
1.6.1.2

