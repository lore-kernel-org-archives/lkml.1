Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYFDAbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYFDAbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbYFDAaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:30:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38241 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751714AbYFDAaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:30:21 -0400
Message-Id: <20080604003019.299510000@polaris-admin.engr.sgi.com>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jun 2008 17:30:20 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86: Extend percpu ops to 64 bit
Content-Disposition: inline; filename=zero_based_percpu_64bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * x86 percpu ops now will work on 64 bit too, so add the missing 8 byte cases.

  * Add a few atomic ops that will be useful in the future:

	x86_xchg_percpu()
	x86_cmpxchg_percpu().

	x86_inc_percpu() - Increment by one can generate more efficient
	x86_dec_percpu()   instructions and inc/dec will be supported by
			   cpu ops later.

  * Use per_cpu_var() instead of per_cpu__##xxx.

Based on linux-2.6.tip

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/asm-x86/percpu.h |   83 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 78 insertions(+), 5 deletions(-)

--- linux-2.6.tip.orig/include/asm-x86/percpu.h
+++ linux-2.6.tip/include/asm-x86/percpu.h
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
@@ -131,16 +136,84 @@ do {							\
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
 #endif /* !CONFIG_X86_64 */
 

-- 
