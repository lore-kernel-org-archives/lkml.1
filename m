Return-Path: <linux-kernel-owner+w=401wt.eu-S1763221AbXHTUxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763221AbXHTUxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763225AbXHTUvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:51:38 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:32823 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762805AbXHTUvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:51:37 -0400
Message-Id: <20070820201823.780084453@polymtl.ca>
References: <20070820201519.512791382@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 16:15:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, clameter@sgi.com
Subject: [patch 04/23] Add cmpxchg_local to avr32
Content-Disposition: inline; filename=add-cmpxchg-local-to-avr32.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 20 Aug 2007 20:51:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic cmpxchg_local (disables interrupt) for 8, 16 and 64 bits
cmpxchg_local. Use the __cmpxchg_u32 primitive for 32 bits cmpxchg_local.

Note that cmpxchg only uses the __cmpxchg_u32 or __cmpxchg_u64 and will cause
a linker error if called with 8 or 16 bits argument.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: clameter@sgi.com
CC: hskinnemoen@atmel.com
---
 include/asm-avr32/system.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

Index: linux-2.6-lttng/include/asm-avr32/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-avr32/system.h	2007-07-20 19:10:57.000000000 -0400
+++ linux-2.6-lttng/include/asm-avr32/system.h	2007-07-20 19:32:36.000000000 -0400
@@ -140,6 +140,29 @@ static inline unsigned long __cmpxchg(vo
 				   (unsigned long)(new),	\
 				   sizeof(*(ptr))))
 
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32(ptr, old, new);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new, size);
+	}
+
+	return old;
+}
+
+#define cmpxchg_local(ptr, old, new)					\
+	((typeof(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(old),	\
+				   (unsigned long)(new),		\
+				   sizeof(*(ptr))))
+
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
+
 struct pt_regs;
 void NORET_TYPE die(const char *str, struct pt_regs *regs, long err);
 void _exception(long signr, struct pt_regs *regs, int code,

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
