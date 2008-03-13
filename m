Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYCMBDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYCMBDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 21:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbYCMBBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 21:01:44 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:53901 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113AbYCMBBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 21:01:40 -0400
Message-Id: <20080313004902.925717686@linux-m68k.org>
References: <20080313002235.351414762@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Thu, 13 Mar 2008 01:22:38 +0100
From: zippel@linux-m68k.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 3/4] rename div64_64 to div64_u64
Content-Disposition: inline; filename=div64_64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename div64_64 to div64_u64 to make it consistent with the other divide
functions, so it clearly includes the type of the divide.
Move its definition to math64.h as currently no architecture overrides
the generic implementation. They can still override it of course, but
the duplicated declarations are avoided.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 arch/x86/kvm/lapic.c         |    6 +++---
 include/asm-arm/div64.h      |    2 --
 include/asm-generic/div64.h  |    7 -------
 include/asm-m68k/div64.h     |    1 -
 include/asm-mips/div64.h     |    6 ------
 include/asm-mn10300/div64.h  |    3 ---
 include/asm-um/div64.h       |    1 -
 include/asm-x86/div64.h      |    2 --
 include/linux/math64.h       |   14 +++++++++++++-
 kernel/sched.c               |    7 ++++---
 kernel/sched_debug.c         |    4 ++--
 lib/div64.c                  |   12 ++++++------
 net/ipv4/tcp_cubic.c         |    4 ++--
 net/netfilter/xt_connbytes.c |    5 ++---
 14 files changed, 32 insertions(+), 42 deletions(-)

Index: linux-2.6/arch/x86/kvm/lapic.c
===================================================================
--- linux-2.6.orig/arch/x86/kvm/lapic.c	2008-03-11 17:15:14.000000000 +0100
+++ linux-2.6/arch/x86/kvm/lapic.c	2008-03-11 17:55:00.000000000 +0100
@@ -25,13 +25,13 @@
 #include <linux/hrtimer.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/math64.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
 #include <asm/page.h>
 #include <asm/current.h>
 #include <asm/apicdef.h>
 #include <asm/atomic.h>
-#include <asm/div64.h>
 #include "irq.h"
 
 #define PRId64 "d"
@@ -526,8 +526,8 @@ static u32 apic_get_tmcct(struct kvm_lap
 	} else
 		passed = ktime_sub(now, apic->timer.last_update);
 
-	counter_passed = div64_64(ktime_to_ns(passed),
-				  (APIC_BUS_CYCLE_NS * apic->timer.divide_count));
+	counter_passed = div64_u64(ktime_to_ns(passed),
+				   (APIC_BUS_CYCLE_NS * apic->timer.divide_count));
 
 	if (counter_passed > tmcct) {
 		if (unlikely(!apic_lvtt_period(apic))) {
Index: linux-2.6/include/asm-arm/div64.h
===================================================================
--- linux-2.6.orig/include/asm-arm/div64.h	2008-03-11 17:15:14.000000000 +0100
+++ linux-2.6/include/asm-arm/div64.h	2008-03-11 17:53:57.000000000 +0100
@@ -224,6 +224,4 @@
 
 #endif
 
-extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
-
 #endif
Index: linux-2.6/include/asm-generic/div64.h
===================================================================
--- linux-2.6.orig/include/asm-generic/div64.h	2008-03-11 17:15:21.000000000 +0100
+++ linux-2.6/include/asm-generic/div64.h	2008-03-11 17:53:57.000000000 +0100
@@ -30,11 +30,6 @@
 	__rem;							\
  })
 
-static inline uint64_t div64_64(uint64_t dividend, uint64_t divisor)
-{
-	return dividend / divisor;
-}
-
 #elif BITS_PER_LONG == 32
 
 extern uint32_t __div64_32(uint64_t *dividend, uint32_t divisor);
@@ -54,8 +49,6 @@ extern uint32_t __div64_32(uint64_t *div
 	__rem;						\
  })
 
-extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
-
 #else /* BITS_PER_LONG == ?? */
 
 # error do_div() does not yet support the C64
Index: linux-2.6/include/asm-m68k/div64.h
===================================================================
--- linux-2.6.orig/include/asm-m68k/div64.h	2008-03-11 17:15:14.000000000 +0100
+++ linux-2.6/include/asm-m68k/div64.h	2008-03-11 17:53:57.000000000 +0100
@@ -25,5 +25,4 @@
 	__rem;							\
 })
 
-extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
 #endif /* _M68K_DIV64_H */
Index: linux-2.6/include/asm-mips/div64.h
===================================================================
--- linux-2.6.orig/include/asm-mips/div64.h	2008-03-11 17:15:14.000000000 +0100
+++ linux-2.6/include/asm-mips/div64.h	2008-03-11 17:53:57.000000000 +0100
@@ -82,7 +82,6 @@
 	(n) = __quot; \
 	__mod; })
 
-extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
 #endif /* (_MIPS_SZLONG == 32) */
 
 #if (_MIPS_SZLONG == 64)
@@ -106,11 +105,6 @@ extern uint64_t div64_64(uint64_t divide
 	(n) = __quot; \
 	__mod; })
 
-static inline uint64_t div64_64(uint64_t dividend, uint64_t divisor)
-{
-	return dividend / divisor;
-}
-
 #endif /* (_MIPS_SZLONG == 64) */
 
 #endif /* _ASM_DIV64_H */
Index: linux-2.6/include/asm-mn10300/div64.h
===================================================================
--- linux-2.6.orig/include/asm-mn10300/div64.h	2008-03-11 17:15:14.000000000 +0100
+++ linux-2.6/include/asm-mn10300/div64.h	2008-03-11 17:53:57.000000000 +0100
@@ -97,7 +97,4 @@ signed __muldiv64s(signed val, signed mu
 	return result;
 }
 
-extern __attribute__((const))
-uint64_t div64_64(uint64_t dividend, uint64_t divisor);
-
 #endif /* _ASM_DIV64 */
Index: linux-2.6/include/asm-um/div64.h
===================================================================
--- linux-2.6.orig/include/asm-um/div64.h	2008-03-11 17:15:14.000000000 +0100
+++ linux-2.6/include/asm-um/div64.h	2008-03-11 17:53:57.000000000 +0100
@@ -3,5 +3,4 @@
 
 #include "asm/arch/div64.h"
 
-extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
 #endif
Index: linux-2.6/include/asm-x86/div64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/div64.h	2008-03-11 17:15:31.000000000 +0100
+++ linux-2.6/include/asm-x86/div64.h	2008-03-12 21:21:20.000000000 +0100
@@ -70,8 +70,6 @@ static inline u64 div_u64_rem(u64 divide
 }
 #define div_u64_rem	div_u64_rem
 
-extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
-
 #else
 # include <asm-generic/div64.h>
 #endif /* CONFIG_X86_32 */
Index: linux-2.6/include/linux/math64.h
===================================================================
--- linux-2.6.orig/include/linux/math64.h	2008-03-11 17:47:20.000000000 +0100
+++ linux-2.6/include/linux/math64.h	2008-03-11 19:59:58.000000000 +0100
@@ -21,12 +21,20 @@ static inline u64 div_u64_rem(u64 divide
 /**
  * div_s64_rem - signed 64bit divide with 32bit divisor with remainder
  */
-static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
+static inline s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder)
 {
 	*remainder = dividend % divisor;
 	return dividend / divisor;
 }
 
+/**
+ * div64_u64 - unsigned 64bit divide with 64bit divisor
+ */
+static inline u64 div64_u64(u64 dividend, u64 divisor)
+{
+	return dividend / divisor;
+}
+
 #elif BITS_PER_LONG == 32
 
 #ifndef div_u64_rem
@@ -69,4 +77,8 @@ static inline s64 div_s64(s64 dividend, 
 }
 #endif
 
+#ifndef div64_u64
+extern u64 div64_u64(u64 dividend, u64 divisor);
+#endif
+
 #endif /* _LINUX_MATH64_H */
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c	2008-03-11 17:15:14.000000000 +0100
+++ linux-2.6/kernel/sched.c	2008-03-11 17:55:57.000000000 +0100
@@ -7112,7 +7113,7 @@ static void init_tg_cfs_entry(struct rq 
 	se->cfs_rq = &rq->cfs;
 	se->my_q = cfs_rq;
 	se->load.weight = tg->shares;
-	se->load.inv_weight = div64_64(1ULL<<32, se->load.weight);
+	se->load.inv_weight = div64_u64(1ULL<<32, se->load.weight);
 	se->parent = NULL;
 }
 #endif
@@ -7649,7 +7650,7 @@ static void set_se_shares(struct sched_e
 		dequeue_entity(cfs_rq, se, 0);
 
 	se->load.weight = shares;
-	se->load.inv_weight = div64_64((1ULL<<32), shares);
+	se->load.inv_weight = div64_u64((1ULL<<32), shares);
 
 	if (on_rq)
 		enqueue_entity(cfs_rq, se, 0);
@@ -7722,7 +7723,7 @@ static unsigned long to_ratio(u64 period
 	if (runtime == RUNTIME_INF)
 		return 1ULL << 16;
 
-	return div64_64(runtime << 16, period);
+	return div64_u64(runtime << 16, period);
 }
 
 static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c	2008-03-11 17:15:14.000000000 +0100
+++ linux-2.6/kernel/sched_debug.c	2008-03-11 17:53:57.000000000 +0100
@@ -331,8 +331,8 @@ void proc_sched_show_task(struct task_st
 
 		avg_per_cpu = p->se.sum_exec_runtime;
 		if (p->se.nr_migrations) {
-			avg_per_cpu = div64_64(avg_per_cpu,
-					       p->se.nr_migrations);
+			avg_per_cpu = div64_u64(avg_per_cpu,
+						p->se.nr_migrations);
 		} else {
 			avg_per_cpu = -1LL;
 		}
Index: linux-2.6/lib/div64.c
===================================================================
--- linux-2.6.orig/lib/div64.c	2008-03-11 17:48:17.000000000 +0100
+++ linux-2.6/lib/div64.c	2008-03-11 17:53:57.000000000 +0100
@@ -78,9 +78,10 @@ EXPORT_SYMBOL(div_s64_rem);
 #endif
 
 /* 64bit divisor, dividend and result. dynamic precision */
-uint64_t div64_64(uint64_t dividend, uint64_t divisor)
+#ifndef div64_u64
+u64 div64_u64(u64 dividend, u64 divisor)
 {
-	uint32_t high, d;
+	u32 high, d;
 
 	high = divisor >> 32;
 	if (high) {
@@ -91,10 +92,9 @@ uint64_t div64_64(uint64_t dividend, uin
 	} else
 		d = divisor;
 
-	do_div(dividend, d);
-
-	return dividend;
+	return div_u64(dividend, d);
 }
-EXPORT_SYMBOL(div64_64);
+EXPORT_SYMBOL(div64_u64);
+#endif
 
 #endif /* BITS_PER_LONG == 32 */
Index: linux-2.6/net/ipv4/tcp_cubic.c
===================================================================
--- linux-2.6.orig/net/ipv4/tcp_cubic.c	2008-03-11 17:15:14.000000000 +0100
+++ linux-2.6/net/ipv4/tcp_cubic.c	2008-03-11 17:53:57.000000000 +0100
@@ -14,8 +14,8 @@
 
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/math64.h>
 #include <net/tcp.h>
-#include <asm/div64.h>
 
 #define BICTCP_BETA_SCALE    1024	/* Scale factor beta calculation
 					 * max_cwnd = snd_cwnd * beta
@@ -134,7 +134,7 @@ static u32 cubic_root(u64 a)
 	 * x    = ( 2 * x  +  a / x  ) / 3
 	 *  k+1          k         k
 	 */
-	x = (2 * x + (u32)div64_64(a, (u64)x * (u64)(x - 1)));
+	x = (2 * x + (u32)div64_u64(a, (u64)x * (u64)(x - 1)));
 	x = ((x * 341) >> 10);
 	return x;
 }
Index: linux-2.6/net/netfilter/xt_connbytes.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_connbytes.c	2008-03-11 17:15:14.000000000 +0100
+++ linux-2.6/net/netfilter/xt_connbytes.c	2008-03-11 17:53:57.000000000 +0100
@@ -4,12 +4,11 @@
 #include <linux/module.h>
 #include <linux/bitops.h>
 #include <linux/skbuff.h>
+#include <linux/math64.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_connbytes.h>
 #include <net/netfilter/nf_conntrack.h>
 
-#include <asm/div64.h>
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: Number of packets/bytes per connection matching");
@@ -82,7 +81,7 @@ connbytes_mt(const struct sk_buff *skb, 
 			break;
 		}
 		if (pkts != 0)
-			what = div64_64(bytes, pkts);
+			what = div64_u64(bytes, pkts);
 		break;
 	}
 

-- 

