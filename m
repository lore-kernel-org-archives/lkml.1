Return-Path: <linux-kernel-owner+w=401wt.eu-S1759851AbYE3EGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851AbYE3EGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301AbYE3EAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:46 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45468 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753286AbYE3EAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:25 -0400
Message-Id: <20080530040023.716388781@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:58 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 38/41] x86: Extend percpu ops to 64 bit
Content-Disposition: inline; filename=zero_based_percpu_64bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 percpu ops now will work on 64 bit too. So add the missing 8 byte cases.
Also add a number of atomic ops that will be useful in the future:
x86_xchg_percpu() and x86_cmpxchg_percpu().

Add x86_inc_percpu and x86_dec_percpu. Increment by one can generate more
efficient instructions and inc/dec will be supported by cpu ops later.

Also use per_cpu_var() instead of per_cpu__##xxx.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/percpu.h |   83 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 78 insertions(+), 5 deletions(-)

Index: linux-2.6/include/asm-x86/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu.h	2008-05-29 20:29:40.000000000 -0700
+++ linux-2.6/include/asm-x86/percpu.h	2008-05-29 20:32:03.000000000 -0700
@@ -108,6 +108,11 @@ do {							\
 		    : "+m" (var)			\
 		    : "ri" ((T__)val));			\
 		break;					\
+	case 8:						\
+		asm(op "q %1,"__percpu_seg"%0"		\
+		    : "+m" (var)			\
+		    : "ri" ((T__)val));			\
+		break;					\
 	default: __bad_percpu_size();			\
 	}						\
 } while (0)
@@ -131,15 +136,83 @@ do {							\
 		    : "=r" (ret__)			\
 		    : "m" (var));			\
 		break;					\
+	case 8:						\
+		asm(op "q "__percpu_seg"%1,%0"		\
+		    : "=r" (ret__)			\
+		    : "m" (var));			\
+		break;					\
 	default: __bad_percpu_size();			\
 	}						\
 	ret__;						\
 })
 
-#define x86_read_percpu(var) percpu_from_op("mov", per_cpu__##var)
-#define x86_write_percpu(var, val) percpu_to_op("mov", per_cpu__##var, val)
-#define x86_add_percpu(var, val) percpu_to_op("add", per_cpu__##var, val)
-#define x86_sub_percpu(var, val) percpu_to_op("sub", per_cpu__##var, val)
-#define x86_or_percpu(var, val) percpu_to_op("or", per_cpu__##var, val)
+#define percpu_addr_op(op, var)				\
+({							\
+	switch (sizeof(var)) {				\
+	case 1:						\
+		asm(op "b "__percpu_seg"%0"		\
+				: : "m"(var));		\
+		break;					\
+	case 2:						\
+		asm(op "w "__percpu_seg"%0"		\
+				: : "m"(var));		\
+		break;					\
+	case 4:						\
+		asm(op "l "__percpu_seg"%0"		\
+				: : "m"(var));		\
+		break;					\
+	case 8:						\
+		asm(op "q "__percpu_seg"%0"		\
+				: : "m"(var));		\
+		break;					\
+	default: __bad_percpu_size();			\
+	}						\
+})
+
+#define percpu_cmpxchg_op(var, old, new)				\
+({									\
+	typeof(var) prev;						\
+	switch (sizeof(var)) {						\
+	case 1:								\
+		asm("cmpxchgb %b1, "__percpu_seg"%2"			\
+				     : "=a"(prev)			\
+				     : "q"(new), "m"(var), "0"(old)	\
+				     : "memory");			\
+		break;							\
+	case 2:								\
+		asm("cmpxchgw %w1, "__percpu_seg"%2"			\
+				     : "=a"(prev)			\
+				     : "r"(new), "m"(var), "0"(old)	\
+				     : "memory");			\
+		break;							\
+	case 4:								\
+		asm("cmpxchgl %k1, "__percpu_seg"%2"			\
+				     : "=a"(prev)			\
+				     : "r"(new), "m"(var), "0"(old)	\
+				     : "memory");			\
+		break;							\
+	case 8:								\
+		asm("cmpxchgq %1, "__percpu_seg"%2"			\
+				     : "=a"(prev)			\
+				     : "r"(new), "m"(var), "0"(old)	\
+				     : "memory");			\
+		break;							\
+	default:							\
+		__bad_percpu_size();					\
+	}								\
+	return prev;							\
+})
+
+#define x86_read_percpu(var) percpu_from_op("mov", per_cpu_var(var))
+#define x86_write_percpu(var, val) percpu_to_op("mov", per_cpu_var(var), val)
+#define x86_add_percpu(var, val) percpu_to_op("add", per_cpu_var(var), val)
+#define x86_sub_percpu(var, val) percpu_to_op("sub", per_cpu_var(var), val)
+#define x86_inc_percpu(var) percpu_addr_op("inc", per_cpu_var(var))
+#define x86_dec_percpu(var) percpu_addr_op("dec", per_cpu_var(var))
+#define x86_or_percpu(var, val) percpu_to_op("or", per_cpu_var(var), val)
+#define x86_xchg_percpu(var, val) percpu_to_op("xchg", per_cpu_var(var), val)
+#define x86_cmpxchg_percpu(var, old, new) \
+				percpu_cmpxchg_op(per_cpu_var(var), old, new)
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASM_X86_PERCPU_H_ */

-- 
