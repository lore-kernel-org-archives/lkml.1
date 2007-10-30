Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbXJ3PAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbXJ3PAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbXJ3PA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:00:28 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:63761 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287AbXJ3PA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:00:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAJLjJkdMQWvU/2dsb2JhbACBWg
Date: Tue, 30 Oct 2007 10:55:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Add asm-compat.h to x86
Message-ID: <20071030145523.GA28026@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:48:58 up 92 days, 15:07,  4 users,  load average: 1.09, 0.96, 0.96
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add asm-compat.h to x86

In assembly code and in gcc inline assembly, we need .long to express a "c long"
type on i386 and a .quad to express the same on x86_64. Use macros similar to
powerpc "PPC_LONG" to express those. Name chosen: ASM_LONG. (didn't feel like
X86_LONG was required).

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
+++ linux-2.6-lttng/include/asm-x86/asm-compat.h	2007-10-24 09:41:09.000000000 -0400
@@ -0,0 +1,29 @@
+#ifndef _ASM_X86_ASM_COMPAT_H
+#define _ASM_X86_ASM_COMPAT_H
+
+#include <asm/types.h>
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
