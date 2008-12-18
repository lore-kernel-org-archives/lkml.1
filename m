Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753984AbYLRCvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbYLRCvX (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 21:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947AbYLRCvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 21:51:10 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:46015 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYLRCvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 21:51:08 -0500
Message-ID: <4949BA9C.8020806@ct.jp.nec.com>
Date: Wed, 17 Dec 2008 18:51:08 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] x86: signal: prepare to include from ia32_signal.c
References: <4949B9B5.2050701@ct.jp.nec.com>
In-Reply-To: <4949B9B5.2050701@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: prepare to use from ia32_signal.c

Make struct sigframe_ia32 and rt_sigframe_ia32 visible to ia32_signal.c.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/sigframe.h |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/sigframe.h b/arch/x86/include/asm/sigframe.h
index 6718ed0..491a087 100644
--- a/arch/x86/include/asm/sigframe.h
+++ b/arch/x86/include/asm/sigframe.h
@@ -4,7 +4,15 @@
 #define sigcontext_ia32		sigcontext
 #define _fpstate_ia32		_fpstate
 #define ucontext_ia32		ucontext
+#else /* !CONFIG_X86_32 */
+
+#ifdef CONFIG_IA32_EMULATION
+#include <asm/ia32.h>
+#endif /* CONFIG_IA32_EMULATION */
+
+#endif /* CONFIG_X86_32 */
 
+#if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
 struct sigframe_ia32 {
 	u32 pretcode;
 	int sig;
@@ -18,7 +26,11 @@ struct sigframe_ia32 {
 	 * legacy application accessing/modifying it.
 	 */
 	struct _fpstate_ia32 fpstate_unused;
+#ifdef CONFIG_IA32_EMULATION
+	unsigned int extramask[_COMPAT_NSIG_WORDS-1];
+#else /* !CONFIG_IA32_EMULATION */
 	unsigned long extramask[_NSIG_WORDS-1];
+#endif /* CONFIG_IA32_EMULATION */
 	char retcode[8];
 	/* fp state follows here */
 };
@@ -28,16 +40,22 @@ struct rt_sigframe_ia32 {
 	int sig;
 	u32 pinfo;
 	u32 puc;
+#ifdef CONFIG_IA32_EMULATION
+	compat_siginfo_t info;
+#else /* !CONFIG_IA32_EMULATION */
 	struct siginfo info;
+#endif /* CONFIG_IA32_EMULATION */
 	struct ucontext_ia32 uc;
 	char retcode[8];
 	/* fp state follows here */
 };
-#else /* !CONFIG_X86_32 */
+#endif /* defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION) */
+
+#ifdef CONFIG_X86_64
 struct rt_sigframe {
 	char __user *pretcode;
 	struct ucontext uc;
 	struct siginfo info;
 	/* fp state follows here */
 };
-#endif /* CONFIG_X86_32 */
+#endif /* CONFIG_X86_64 */
-- 
1.6.0.4

