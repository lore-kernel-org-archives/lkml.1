Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752807AbYLRCuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbYLRCuw (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 21:50:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYLRCue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 21:50:34 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:45678 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbYLRCud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 21:50:33 -0500
Message-ID: <4949BA78.2060002@ct.jp.nec.com>
Date: Wed, 17 Dec 2008 18:50:32 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] x86: signal: move sigframe.h to arch/x86/include/asm
References: <4949B9B5.2050701@ct.jp.nec.com>
In-Reply-To: <4949B9B5.2050701@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: move header file

Move arch/x86/kernel/sigframe.h to arch/x86/include/asm/sigframe.h.
It will be used in arch/x86/ia32/ia32_signal.c.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/sigframe.h  |   43 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/asm-offsets_32.c |    2 +-
 arch/x86/kernel/sigframe.h       |   43 --------------------------------------
 arch/x86/kernel/signal.c         |    2 +-
 4 files changed, 45 insertions(+), 45 deletions(-)
 create mode 100644 arch/x86/include/asm/sigframe.h
 delete mode 100644 arch/x86/kernel/sigframe.h

diff --git a/arch/x86/include/asm/sigframe.h b/arch/x86/include/asm/sigframe.h
new file mode 100644
index 0000000..6718ed0
--- /dev/null
+++ b/arch/x86/include/asm/sigframe.h
@@ -0,0 +1,43 @@
+#ifdef CONFIG_X86_32
+#define sigframe_ia32		sigframe
+#define rt_sigframe_ia32	rt_sigframe
+#define sigcontext_ia32		sigcontext
+#define _fpstate_ia32		_fpstate
+#define ucontext_ia32		ucontext
+
+struct sigframe_ia32 {
+	u32 pretcode;
+	int sig;
+	struct sigcontext_ia32 sc;
+	/*
+	 * fpstate is unused. fpstate is moved/allocated after
+	 * retcode[] below. This movement allows to have the FP state and the
+	 * future state extensions (xsave) stay together.
+	 * And at the same time retaining the unused fpstate, prevents changing
+	 * the offset of extramask[] in the sigframe and thus prevent any
+	 * legacy application accessing/modifying it.
+	 */
+	struct _fpstate_ia32 fpstate_unused;
+	unsigned long extramask[_NSIG_WORDS-1];
+	char retcode[8];
+	/* fp state follows here */
+};
+
+struct rt_sigframe_ia32 {
+	u32 pretcode;
+	int sig;
+	u32 pinfo;
+	u32 puc;
+	struct siginfo info;
+	struct ucontext_ia32 uc;
+	char retcode[8];
+	/* fp state follows here */
+};
+#else /* !CONFIG_X86_32 */
+struct rt_sigframe {
+	char __user *pretcode;
+	struct ucontext uc;
+	struct siginfo info;
+	/* fp state follows here */
+};
+#endif /* CONFIG_X86_32 */
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index 6649d09..ee4df08 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -11,7 +11,7 @@
 #include <linux/suspend.h>
 #include <linux/kbuild.h>
 #include <asm/ucontext.h>
-#include "sigframe.h"
+#include <asm/sigframe.h>
 #include <asm/pgtable.h>
 #include <asm/fixmap.h>
 #include <asm/processor.h>
diff --git a/arch/x86/kernel/sigframe.h b/arch/x86/kernel/sigframe.h
deleted file mode 100644
index 6718ed0..0000000
--- a/arch/x86/kernel/sigframe.h
+++ /dev/null
@@ -1,43 +0,0 @@
-#ifdef CONFIG_X86_32
-#define sigframe_ia32		sigframe
-#define rt_sigframe_ia32	rt_sigframe
-#define sigcontext_ia32		sigcontext
-#define _fpstate_ia32		_fpstate
-#define ucontext_ia32		ucontext
-
-struct sigframe_ia32 {
-	u32 pretcode;
-	int sig;
-	struct sigcontext_ia32 sc;
-	/*
-	 * fpstate is unused. fpstate is moved/allocated after
-	 * retcode[] below. This movement allows to have the FP state and the
-	 * future state extensions (xsave) stay together.
-	 * And at the same time retaining the unused fpstate, prevents changing
-	 * the offset of extramask[] in the sigframe and thus prevent any
-	 * legacy application accessing/modifying it.
-	 */
-	struct _fpstate_ia32 fpstate_unused;
-	unsigned long extramask[_NSIG_WORDS-1];
-	char retcode[8];
-	/* fp state follows here */
-};
-
-struct rt_sigframe_ia32 {
-	u32 pretcode;
-	int sig;
-	u32 pinfo;
-	u32 puc;
-	struct siginfo info;
-	struct ucontext_ia32 uc;
-	char retcode[8];
-	/* fp state follows here */
-};
-#else /* !CONFIG_X86_32 */
-struct rt_sigframe {
-	char __user *pretcode;
-	struct ucontext uc;
-	struct siginfo info;
-	/* fp state follows here */
-};
-#endif /* CONFIG_X86_32 */
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 78202a1..4fa5243 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -35,7 +35,7 @@
 #include <asm/syscall.h>
 #include <asm/syscalls.h>
 
-#include "sigframe.h"
+#include <asm/sigframe.h>
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
-- 
1.6.0.4

