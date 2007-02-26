Return-Path: <linux-kernel-owner+w=401wt.eu-S1030490AbXBZT3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030490AbXBZT3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 14:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030486AbXBZT3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 14:29:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:32786 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030490AbXBZT3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 14:29:37 -0500
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [RFC] div64_64 support
Date: Mon, 26 Feb 2007 11:28:18 -0800
Organization: OSDL
Message-ID: <20070226112818.1babf22a@freekitty>
References: <20070223170527.4ca695b2@freekitty>
	<20070224161916.GL3982@m.safari.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Trace: build.pdx.osdl.net 1172518099 10200 10.8.0.54 (26 Feb 2007 19:28:19 GMT)
X-Complaints-To: abuse@osdl.org
NNTP-Posting-Date: Mon, 26 Feb 2007 19:28:19 +0000 (UTC)
X-Newsreader: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

asm-i386.h/div64 and div64.o needs to move in Makefile to get this to work
on i386.



---
 include/asm-arm/div64.h      |    2 ++
 include/asm-generic/div64.h  |    8 ++++++++
 include/asm-i386/div64.h     |    5 +++++
 include/asm-m68k/div64.h     |    2 ++
 include/asm-mips/div64.h     |    8 ++++++++
 include/asm-um/div64.h       |    1 +
 include/asm-xtensa/div64.h   |    1 +
 lib/Makefile                 |    5 +++--
 lib/div64.c                  |   23 +++++++++++++++++++++++
 net/ipv4/tcp_cubic.c         |   22 ----------------------
 net/netfilter/xt_connbytes.c |   16 ----------------
 11 files changed, 53 insertions(+), 40 deletions(-)

--- sky2.orig/include/asm-arm/div64.h	2007-02-26 10:17:33.000000000 -0800
+++ sky2/include/asm-arm/div64.h	2007-02-26 10:17:50.000000000 -0800
@@ -221,6 +221,8 @@
 	__nr;								\
 })
 
+extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
+
 #endif
 
 #endif
--- sky2.orig/include/asm-generic/div64.h	2007-02-26 10:17:33.000000000 -0800
+++ sky2/include/asm-generic/div64.h	2007-02-26 10:17:50.000000000 -0800
@@ -30,9 +30,17 @@
 	__rem;							\
  })
 
+/*
+ * div64_64 - Divide two 64 bit numbers
+ */
+static inline uint64_t div64_64(uint64_t dividend, uint64_t divisor)
+{
+	return dividend / divisor;
+}
 #elif BITS_PER_LONG == 32
 
 extern uint32_t __div64_32(uint64_t *dividend, uint32_t divisor);
+extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
 
 /* The unnecessary pointer compare is there
  * to check for type safety (n must be 64bit)
--- sky2.orig/include/asm-m68k/div64.h	2007-02-26 10:17:33.000000000 -0800
+++ sky2/include/asm-m68k/div64.h	2007-02-26 10:17:50.000000000 -0800
@@ -23,4 +23,6 @@
 	__rem;							\
 })
 
+extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
+
 #endif /* _M68K_DIV64_H */
--- sky2.orig/include/asm-mips/div64.h	2007-02-26 10:17:33.000000000 -0800
+++ sky2/include/asm-mips/div64.h	2007-02-26 10:17:50.000000000 -0800
@@ -78,6 +78,9 @@
 	__quot = __quot << 32 | __low; \
 	(n) = __quot; \
 	__mod; })
+
+extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
+
 #endif /* (_MIPS_SZLONG == 32) */
 
 #if (_MIPS_SZLONG == 64)
@@ -101,6 +104,11 @@
 	(n) = __quot; \
 	__mod; })
 
+static inline uint64_t div64_64(uint64_t dividend, uint64_t divisor)
+{
+	return dividend / divisor;
+}
+
 #endif /* (_MIPS_SZLONG == 64) */
 
 #endif /* _ASM_DIV64_H */
--- sky2.orig/include/asm-um/div64.h	2007-02-26 10:17:33.000000000 -0800
+++ sky2/include/asm-um/div64.h	2007-02-26 10:17:50.000000000 -0800
@@ -3,4 +3,5 @@
 
 #include "asm/arch/div64.h"
 
+extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
 #endif
--- sky2.orig/include/asm-xtensa/div64.h	2007-02-26 10:17:33.000000000 -0800
+++ sky2/include/asm-xtensa/div64.h	2007-02-26 10:17:50.000000000 -0800
@@ -16,4 +16,5 @@
 	n /= (unsigned int) base; \
 	__res; })
 
+extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
 #endif
--- sky2.orig/lib/div64.c	2007-02-26 10:17:33.000000000 -0800
+++ sky2/lib/div64.c	2007-02-26 10:31:49.000000000 -0800
@@ -18,6 +18,7 @@
 
 #include <linux/types.h>
 #include <linux/module.h>
+#include <asm/bitops.h>
 #include <asm/div64.h>
 
 /* Not needed on 64bit architectures */
@@ -58,4 +59,26 @@
 
 EXPORT_SYMBOL(__div64_32);
 
+/* Use scaling to do a full 64 bit division  */
+uint64_t div64_64(uint64_t dividend, uint64_t divisor)
+{
+	uint32_t d = divisor;
+
+	if (divisor > 0xffffffffULL) {
+		unsigned int shift = fls(divisor >> 32);
+
+		d = divisor >> shift;
+		dividend >>= shift;
+	}
+
+	/* avoid 64 bit division if possible */
+	if (dividend >> 32)
+		do_div(dividend, d);
+	else
+		dividend = (uint32_t) dividend / d;
+
+	return dividend;
+}
+EXPORT_SYMBOL(div64_64);
+
 #endif /* BITS_PER_LONG == 32 */
--- sky2.orig/net/ipv4/tcp_cubic.c	2007-02-26 10:17:33.000000000 -0800
+++ sky2/net/ipv4/tcp_cubic.c	2007-02-26 10:17:50.000000000 -0800
@@ -51,7 +51,6 @@
 module_param(tcp_friendliness, int, 0644);
 MODULE_PARM_DESC(tcp_friendliness, "turn on/off tcp friendliness");
 
-#include <asm/div64.h>
 
 /* BIC TCP Parameters */
 struct bictcp {
@@ -93,27 +92,6 @@
 		tcp_sk(sk)->snd_ssthresh = initial_ssthresh;
 }
 
-/* 64bit divisor, dividend and result. dynamic precision */
-static inline u_int64_t div64_64(u_int64_t dividend, u_int64_t divisor)
-{
-	u_int32_t d = divisor;
-
-	if (divisor > 0xffffffffULL) {
-		unsigned int shift = fls(divisor >> 32);
-
-		d = divisor >> shift;
-		dividend >>= shift;
-	}
-
-	/* avoid 64 bit division if possible */
-	if (dividend >> 32)
-		do_div(dividend, d);
-	else
-		dividend = (uint32_t) dividend / d;
-
-	return dividend;
-}
-
 /*
  * calculate the cubic root of x using Newton-Raphson
  */
--- sky2.orig/net/netfilter/xt_connbytes.c	2007-02-26 10:17:33.000000000 -0800
+++ sky2/net/netfilter/xt_connbytes.c	2007-02-26 10:17:50.000000000 -0800
@@ -24,22 +24,6 @@
 MODULE_DESCRIPTION("iptables match for matching number of pkts/bytes per connection");
 MODULE_ALIAS("ipt_connbytes");
 
-/* 64bit divisor, dividend and result. dynamic precision */
-static u_int64_t div64_64(u_int64_t dividend, u_int64_t divisor)
-{
-	u_int32_t d = divisor;
-
-	if (divisor > 0xffffffffULL) {
-		unsigned int shift = fls(divisor >> 32);
-
-		d = divisor >> shift;
-		dividend >>= shift;
-	}
-
-	do_div(dividend, d);
-	return dividend;
-}
-
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
--- sky2.orig/include/asm-i386/div64.h	2007-02-26 10:36:29.000000000 -0800
+++ sky2/include/asm-i386/div64.h	2007-02-26 11:07:47.000000000 -0800
@@ -1,6 +1,8 @@
 #ifndef __I386_DIV64
 #define __I386_DIV64
 
+#include <linux/types.h>
+
 /*
  * do_div() is NOT a C function. It wants to return
  * two values (the quotient and the remainder), but
@@ -45,4 +47,7 @@
 	return dum2;
 
 }
+
+extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
+
 #endif
--- sky2.orig/lib/Makefile	2007-02-26 11:24:48.000000000 -0800
+++ sky2/lib/Makefile	2007-02-26 11:26:57.000000000 -0800
@@ -4,7 +4,7 @@
 
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
-	 idr.o div64.o int_sqrt.o bitmap.o extable.o prio_tree.o \
+	 idr.o int_sqrt.o bitmap.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o
 
 lib-$(CONFIG_MMU) += ioremap.o
@@ -12,7 +12,8 @@
 
 lib-y	+= kobject.o kref.o kobject_uevent.o klist.o
 
-obj-y += sort.o parser.o halfmd4.o debug_locks.o random32.o bust_spinlocks.o
+obj-y += sort.o parser.o div64.o halfmd4.o debug_locks.o random32.o \
+	 bust_spinlocks.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
