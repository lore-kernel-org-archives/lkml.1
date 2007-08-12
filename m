Return-Path: <linux-kernel-owner+w=401wt.eu-S937758AbXHLPln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937758AbXHLPln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964885AbXHLPho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:37:44 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:50276 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935274AbXHLPhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:37:31 -0400
Message-Id: <20070812145835.883846016@polymtl.ca>
References: <20070812145434.520271946@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 10:54:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, hskinnemoen@atmel.com
Subject: [patch 04/23] Add cmpxchg_local to avr32
Content-Disposition: inline; filename=add-cmpxchg-local-to-avr32.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:37:11 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic cmpxchg_local (disables interrupt) for 8, 16 and 64 bits
cmpxchg_local. Use the __cmpxchg_u32 primitive for 32 bits cmpxchg_local.

Note that cmpxchg only uses the __cmpxchg_u32 or __cmpxchg_u64 and will cause
a linker error if called with 8 or 16 bits argument.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
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
