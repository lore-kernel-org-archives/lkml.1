Return-Path: <linux-kernel-owner+w=401wt.eu-S1765427AbXJTRvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765427AbXJTRvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 13:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757203AbXJTRvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 13:51:38 -0400
Received: from quark.didntduck.org ([69.55.226.66]:53632 "EHLO
	quark.didntduck.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052AbXJTRvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 13:51:37 -0400
Message-ID: <471A3DD5.4000501@didntduck.org>
Date: Sat, 20 Oct 2007 13:41:41 -0400
From: Brian Gerst <bgerst@didntduck.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: merge required-features.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <bgerst@didntduck.org>
---
 include/asm-x86/required-features.h    |   73 ++++++++++++++++++++++++++++++-
 include/asm-x86/required-features_32.h |   55 ------------------------
 include/asm-x86/required-features_64.h |   46 --------------------
 3 files changed, 70 insertions(+), 104 deletions(-)
 delete mode 100644 include/asm-x86/required-features_32.h
 delete mode 100644 include/asm-x86/required-features_64.h

diff --git a/include/asm-x86/required-features.h b/include/asm-x86/required-features.h
index 8b64f3e..7400d3a 100644
--- a/include/asm-x86/required-features.h
+++ b/include/asm-x86/required-features.h
@@ -1,5 +1,72 @@
-#ifdef CONFIG_X86_32
-# include "required-features_32.h"
+#ifndef _ASM_REQUIRED_FEATURES_H
+#define _ASM_REQUIRED_FEATURES_H 1
+
+/* Define minimum CPUID feature set for kernel These bits are checked
+   really early to actually display a visible error message before the
+   kernel dies.  Make sure to assign features to the proper mask!
+
+   Some requirements that are not in CPUID yet are also in the
+   CONFIG_X86_MINIMUM_CPU_FAMILY which is checked too.
+
+   The real information is in arch/x86/Kconfig.cpu, this just converts
+   the CONFIGs into a bitmask */
+
+#ifndef CONFIG_MATH_EMULATION
+# define NEED_FPU	(1<<(X86_FEATURE_FPU & 31))
 #else
-# include "required-features_64.h"
+# define NEED_FPU	0
+#endif
+
+#if defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
+# define NEED_PAE	(1<<(X86_FEATURE_PAE & 31))
+# define NEED_CX8	(1<<(X86_FEATURE_CX8 & 31))
+#else
+# define NEED_PAE	0
+# define NEED_CX8	0
+#endif
+
+#if defined(CONFIG_X86_CMOV) || defined(CONFIG_X86_64)
+# define NEED_CMOV	(1<<(X86_FEATURE_CMOV & 31))
+#else
+# define NEED_CMOV	0
+#endif
+
+#ifdef CONFIG_X86_USE_3DNOW
+# define NEED_3DNOW	(1<<(X86_FEATURE_3DNOW & 31))
+#else
+# define NEED_3DNOW	0
+#endif
+
+#ifdef CONFIG_X86_64
+#define NEED_PSE	(1<<(X86_FEATURE_PSE & 31))
+#define NEED_MSR	(1<<(X86_FEATURE_MSR & 31))
+#define NEED_PGE	(1<<(X86_FEATURE_PGE & 31))
+#define NEED_FXSR	(1<<(X86_FEATURE_FXSR & 31))
+#define NEED_XMM	(1<<(X86_FEATURE_XMM & 31))
+#define NEED_XMM2	(1<<(X86_FEATURE_XMM2 & 31))
+#define NEED_LM		(1<<(X86_FEATURE_LM & 31))
+#else
+#define NEED_PSE	0
+#define NEED_MSR	0
+#define NEED_PGE	0
+#define NEED_FXSR	0
+#define NEED_XMM	0
+#define NEED_XMM2	0
+#define NEED_LM		0
+#endif
+
+#define REQUIRED_MASK0	(NEED_FPU|NEED_PSE|NEED_MSR|NEED_PAE|\
+			 NEED_CX8|NEED_PGE|NEED_FXSR|NEED_CMOV|\
+			 NEED_XMM|NEED_XMM2)
+#define SSE_MASK	(NEED_XMM|NEED_XMM2)
+
+#define REQUIRED_MASK1	(NEED_LM|NEED_3DNOW)
+
+#define REQUIRED_MASK2	0
+#define REQUIRED_MASK3	0
+#define REQUIRED_MASK4	0
+#define REQUIRED_MASK5	0
+#define REQUIRED_MASK6	0
+#define REQUIRED_MASK7	0
+
 #endif
diff --git a/include/asm-x86/required-features_32.h b/include/asm-x86/required-features_32.h
deleted file mode 100644
index 618feb9..0000000
--- a/include/asm-x86/required-features_32.h
+++ /dev/null
@@ -1,55 +0,0 @@
-#ifndef _ASM_REQUIRED_FEATURES_H
-#define _ASM_REQUIRED_FEATURES_H 1
-
-/* Define minimum CPUID feature set for kernel These bits are checked
-   really early to actually display a visible error message before the
-   kernel dies.  Make sure to assign features to the proper mask!
-
-   Some requirements that are not in CPUID yet are also in the
-   CONFIG_X86_MINIMUM_CPU_FAMILY which is checked too.
-
-   The real information is in arch/i386/Kconfig.cpu, this just converts
-   the CONFIGs into a bitmask */
-
-#ifndef CONFIG_MATH_EMULATION
-# define NEED_FPU	(1<<(X86_FEATURE_FPU & 31))
-#else
-# define NEED_FPU	0
-#endif
-
-#ifdef CONFIG_X86_PAE
-# define NEED_PAE	(1<<(X86_FEATURE_PAE & 31))
-#else
-# define NEED_PAE	0
-#endif
-
-#ifdef CONFIG_X86_CMOV
-# define NEED_CMOV	(1<<(X86_FEATURE_CMOV & 31))
-#else
-# define NEED_CMOV	0
-#endif
-
-#ifdef CONFIG_X86_PAE
-# define NEED_CX8	(1<<(X86_FEATURE_CX8 & 31))
-#else
-# define NEED_CX8	0
-#endif
-
-#define REQUIRED_MASK0	(NEED_FPU|NEED_PAE|NEED_CMOV|NEED_CX8)
-
-#ifdef CONFIG_X86_USE_3DNOW
-# define NEED_3DNOW	(1<<(X86_FEATURE_3DNOW & 31))
-#else
-# define NEED_3DNOW	0
-#endif
-
-#define REQUIRED_MASK1	(NEED_3DNOW)
-
-#define REQUIRED_MASK2	0
-#define REQUIRED_MASK3	0
-#define REQUIRED_MASK4	0
-#define REQUIRED_MASK5	0
-#define REQUIRED_MASK6	0
-#define REQUIRED_MASK7	0
-
-#endif
diff --git a/include/asm-x86/required-features_64.h b/include/asm-x86/required-features_64.h
deleted file mode 100644
index e80d576..0000000
--- a/include/asm-x86/required-features_64.h
+++ /dev/null
@@ -1,46 +0,0 @@
-#ifndef _ASM_REQUIRED_FEATURES_H
-#define _ASM_REQUIRED_FEATURES_H 1
-
-/* Define minimum CPUID feature set for kernel These bits are checked
-   really early to actually display a visible error message before the
-   kernel dies.  Make sure to assign features to the proper mask!
-
-   The real information is in arch/x86_64/Kconfig.cpu, this just converts
-   the CONFIGs into a bitmask */
-
-/* x86-64 baseline features */
-#define NEED_FPU	(1<<(X86_FEATURE_FPU & 31))
-#define NEED_PSE	(1<<(X86_FEATURE_PSE & 31))
-#define NEED_MSR	(1<<(X86_FEATURE_MSR & 31))
-#define NEED_PAE	(1<<(X86_FEATURE_PAE & 31))
-#define NEED_CX8	(1<<(X86_FEATURE_CX8 & 31))
-#define NEED_PGE	(1<<(X86_FEATURE_PGE & 31))
-#define NEED_FXSR	(1<<(X86_FEATURE_FXSR & 31))
-#define NEED_CMOV	(1<<(X86_FEATURE_CMOV & 31))
-#define NEED_XMM	(1<<(X86_FEATURE_XMM & 31))
-#define NEED_XMM2	(1<<(X86_FEATURE_XMM2 & 31))
-
-#define REQUIRED_MASK0	(NEED_FPU|NEED_PSE|NEED_MSR|NEED_PAE|\
-			 NEED_CX8|NEED_PGE|NEED_FXSR|NEED_CMOV|\
-			 NEED_XMM|NEED_XMM2)
-#define SSE_MASK	(NEED_XMM|NEED_XMM2)
-
-/* x86-64 baseline features */
-#define NEED_LM		(1<<(X86_FEATURE_LM & 31))
-
-#ifdef CONFIG_X86_USE_3DNOW
-# define NEED_3DNOW	(1<<(X86_FEATURE_3DNOW & 31))
-#else
-# define NEED_3DNOW	0
-#endif
-
-#define REQUIRED_MASK1	(NEED_LM|NEED_3DNOW)
-
-#define REQUIRED_MASK2	0
-#define REQUIRED_MASK3	0
-#define REQUIRED_MASK4	0
-#define REQUIRED_MASK5	0
-#define REQUIRED_MASK6	0
-#define REQUIRED_MASK7	0
-
-#endif
-- 
1.5.3.GIT



