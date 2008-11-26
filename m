Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbYKZNCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbYKZNCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbYKZM62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:58:28 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:46281 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508AbYKZM60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:58:26 -0500
Message-Id: <20081126124634.777757087@polymtl.ca>
References: <20081126124246.800751190@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 26 Nov 2008 07:42:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: [patch 03/17] get_cycles() : sparc64 HAVE_GET_CYCLES
Content-Disposition: inline; filename=get-cycles-sparc64-have-get-cycles.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 26 Nov 2008 12:57:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch selects HAVE_GET_CYCLES and makes sure get_cycles_barrier() and
get_cycles_rate() are implemented.

Changelog :
- Use tb_ticks_per_usec * 1000000 in get_cycles_rate().

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: David S. Miller <davem@davemloft.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: linux-arch@vger.kernel.org
---
 arch/sparc/include/asm/timex_64.h |   19 ++++++++++++++++++-
 arch/sparc64/Kconfig              |    1 +
 arch/sparc64/kernel/time.c        |    3 ++-
 3 files changed, 21 insertions(+), 2 deletions(-)

Index: linux.trees.git/arch/sparc64/Kconfig
===================================================================
--- linux.trees.git.orig/arch/sparc64/Kconfig	2008-11-12 18:15:48.000000000 -0500
+++ linux.trees.git/arch/sparc64/Kconfig	2008-11-26 06:48:52.000000000 -0500
@@ -13,6 +13,7 @@ config SPARC64
 	default y
 	select HAVE_FUNCTION_TRACER
 	select HAVE_IDE
+	select HAVE_GET_CYCLES
 	select HAVE_LMB
 	select HAVE_ARCH_KGDB
 	select USE_GENERIC_SMP_HELPERS if SMP
Index: linux.trees.git/arch/sparc/include/asm/timex_64.h
===================================================================
--- linux.trees.git.orig/arch/sparc/include/asm/timex_64.h	2008-11-12 18:15:48.000000000 -0500
+++ linux.trees.git/arch/sparc/include/asm/timex_64.h	2008-11-26 06:48:52.000000000 -0500
@@ -12,7 +12,24 @@
 
 /* Getting on the cycle counter on sparc64. */
 typedef unsigned long cycles_t;
-#define get_cycles()	tick_ops->get_tick()
+
+static inline cycles_t get_cycles(void)
+{
+	return tick_ops->get_tick();
+}
+
+/* get_cycles instruction is synchronized on sparc64 */
+static inline void get_cycles_barrier(void)
+{
+	return;
+}
+
+extern unsigned long tb_ticks_per_usec;
+
+static inline cycles_t get_cycles_rate(void)
+{
+	return (cycles_t)tb_ticks_per_usec * 1000000UL;
+}
 
 #define ARCH_HAS_READ_CURRENT_TIMER
 
Index: linux.trees.git/arch/sparc64/kernel/time.c
===================================================================
--- linux.trees.git.orig/arch/sparc64/kernel/time.c	2008-11-12 18:15:48.000000000 -0500
+++ linux.trees.git/arch/sparc64/kernel/time.c	2008-11-26 06:48:52.000000000 -0500
@@ -793,7 +793,8 @@ static void __init setup_clockevent_mult
 	sparc64_clockevent.mult = mult;
 }
 
-static unsigned long tb_ticks_per_usec __read_mostly;
+unsigned long tb_ticks_per_usec __read_mostly;
+EXPORT_SYMBOL_GPL(tb_ticks_per_usec);
 
 void __delay(unsigned long loops)
 {

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
