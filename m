Return-Path: <linux-kernel-owner+w=401wt.eu-S1763605AbXKMTCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763605AbXKMTCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759515AbXKMTBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:01:32 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:38490 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762798AbXKMTBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:01:31 -0500
Message-Id: <20071113190040.426268972@polymtl.ca>
References: <20071113185800.436425570@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 13:58:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 4/8] Add asm-compat.h to x86
Content-Disposition: inline; filename=add-asm-compat-to-x86.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 19:00:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In assembly code and in gcc inline assembly, we need .long to express a "c long"
type on i386 and a .quad to express the same on x86_64. Use macros similar to
powerpc "PPC_LONG" to express those. Name chosen: ASM_LONG. (didn't feel like
X86_LONG was required)

This is useful in inline assembly within code shared between 32 and 64
bits architectures in x86.

More compatible assembly macros could be added in this header later when
needed.

I had to create this to implement a merged optimized immediate values
header for x86.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>
---
 include/asm-x86/asm-compat.h |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

Index: linux-2.6-lttng/include/asm-x86/asm-compat.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-x86/asm-compat.h	2007-11-01 22:43:09.000000000 -0400
@@ -0,0 +1,29 @@
+#ifndef _ASM_X86_ASM_COMPAT_H
+#define _ASM_X86_ASM_COMPAT_H
+
+#include <linux/types.h>
+
+#ifdef __ASSEMBLY__
+#  define stringify_in_c(...)	__VA_ARGS__
+#  define ASM_CONST(x)		x
+#else
+/* This version of stringify will deal with commas... */
+#  define __stringify_in_c(...)	#__VA_ARGS__
+#  define stringify_in_c(...)	__stringify_in_c(__VA_ARGS__) " "
+#  define __ASM_CONST(x)	x##UL
+#  define ASM_CONST(x)		__ASM_CONST(x)
+#endif
+
+#ifdef CONFIG_X86_64
+
+/* operations for longs and pointers */
+#define ASM_LONG	stringify_in_c(.quad)
+
+#else /* 32-bit */
+
+/* operations for longs and pointers */
+#define ASM_LONG	stringify_in_c(.long)
+
+#endif
+
+#endif /* _ASM_X86_ASM_COMPAT_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
