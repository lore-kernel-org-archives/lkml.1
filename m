Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753498AbYLRCuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbYLRCuK (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 21:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYLRCt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 21:49:57 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:45429 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYLRCt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 21:49:56 -0500
Message-ID: <4949BA53.8050702@ct.jp.nec.com>
Date: Wed, 17 Dec 2008 18:49:55 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] x86: signal: rename sigframe and rt_sigframe on 32-bit
References: <4949B9B5.2050701@ct.jp.nec.com>
In-Reply-To: <4949B9B5.2050701@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: prepare to move sigframe.h

On 32-bit, rename struct sigrame to struct sigframe_ia32, struct rt_sigframe
to struct rt_sigframe_ia32 and several structures.
And add helper macros to access the above data in arch/x86/kernel/signal.c.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/sigframe.h |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/sigframe.h b/arch/x86/kernel/sigframe.h
index 6dd7e2b..6718ed0 100644
--- a/arch/x86/kernel/sigframe.h
+++ b/arch/x86/kernel/sigframe.h
@@ -1,8 +1,14 @@
 #ifdef CONFIG_X86_32
-struct sigframe {
-	char __user *pretcode;
+#define sigframe_ia32		sigframe
+#define rt_sigframe_ia32	rt_sigframe
+#define sigcontext_ia32		sigcontext
+#define _fpstate_ia32		_fpstate
+#define ucontext_ia32		ucontext
+
+struct sigframe_ia32 {
+	u32 pretcode;
 	int sig;
-	struct sigcontext sc;
+	struct sigcontext_ia32 sc;
 	/*
 	 * fpstate is unused. fpstate is moved/allocated after
 	 * retcode[] below. This movement allows to have the FP state and the
@@ -11,27 +17,27 @@ struct sigframe {
 	 * the offset of extramask[] in the sigframe and thus prevent any
 	 * legacy application accessing/modifying it.
 	 */
-	struct _fpstate fpstate_unused;
+	struct _fpstate_ia32 fpstate_unused;
 	unsigned long extramask[_NSIG_WORDS-1];
 	char retcode[8];
 	/* fp state follows here */
 };
 
-struct rt_sigframe {
-	char __user *pretcode;
+struct rt_sigframe_ia32 {
+	u32 pretcode;
 	int sig;
-	struct siginfo __user *pinfo;
-	void __user *puc;
+	u32 pinfo;
+	u32 puc;
 	struct siginfo info;
-	struct ucontext uc;
+	struct ucontext_ia32 uc;
 	char retcode[8];
 	/* fp state follows here */
 };
-#else
+#else /* !CONFIG_X86_32 */
 struct rt_sigframe {
 	char __user *pretcode;
 	struct ucontext uc;
 	struct siginfo info;
 	/* fp state follows here */
 };
-#endif
+#endif /* CONFIG_X86_32 */
-- 
1.6.0.4

