Return-Path: <linux-kernel-owner+w=401wt.eu-S932109Ab0AEWFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab0AEWFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240Ab0AEWFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:05:44 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40227 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab0AEWFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:05:43 -0500
Message-Id: <20100105220439.030792114@quilx.com>
References: <20100105220417.400092933@quilx.com>
User-Agent: quilt/0.46-1
Date: Tue, 05 Jan 2010 16:04:20 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC local_t removal V1 3/4] Optimized add_local()
Content-Disposition: inline; filename=remove_local_t_add_local_x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use XADD to implement add_local().

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 arch/x86/include/asm/add-local.h |   56 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/include/asm/add-local.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/add-local.h	2010-01-05 15:29:11.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/add-local.h	2010-01-05 15:33:59.000000000 -0600
@@ -1,2 +1,56 @@
-#include <asm-generic/add-local.h>
+#ifndef __ASM_X86_ADD_LOCAL_H
+#define __ASM_X86_ADD_LOCAL_H
+
+#include <linux/types.h>
+#include <asm-generic/add-local-generic.h>
+
+static inline unsigned long __add_return_local(volatile void *ptr,
+		unsigned long value, int size)
+{
+	unsigned long r;
+
+#ifdef CONFIG_M386
+	if (unlikely(boot_cpu_data.x86 <= 3))
+                return __add_return_local_generic(ptr, value, size);
+#endif
+
+	/*
+	 * Sanity checking, compile-time.
+	 */
+	if (size == 8 && sizeof(unsigned long) != 8)
+		wrong_size_add_local(ptr);
+
+	r = value;
+	switch (size) {
+	case 1:
+		asm volatile("xaddb %0, %1;": "+r" (r), "+m" (*((u8 *)ptr)):
+			 : "memory");
+		break;
+	case 2:
+		asm volatile("xaddw %0, %1;": "+r" (r), "+m" (*((u16 *)ptr)):
+			 : "memory");
+		break;
+	case 4:
+		asm volatile("xaddl %0, %1;": "+r" (r), "+m" (*((u32 *)ptr)):
+			 : "memory");
+		break;
+	case 8:
+		asm volatile("xaddq %0, %1;": "+r" (r), "+m" (*((u64 *)ptr)):
+			 : "memory");
+		break;
+	default:
+		wrong_size_add_local(ptr);
+	}
+	return r + value;
+}
+
+#define add_return_local(ptr, v)				  	\
+	((__typeof__(*(ptr)))__add_return_local((ptr), (unsigned long)(v), \
+			sizeof(*(ptr))))
+
+#define add_local(ptr, v) (void)__add_return_local((ptr), (unsigned long)(v), \
+			sizeof(*(ptr)))
+
+
+#endif
 

-- 
