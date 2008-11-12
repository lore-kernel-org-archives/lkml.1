Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbYKLXhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbYKLXhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbYKLXeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:34:18 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:48507 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506AbYKLXeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:34:15 -0500
Message-Id: <20081112232259.044418906@polymtl.ca>
References: <20081112231551.473569400@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 18:15:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-arch@vger.kernel.org
Subject: [patch 05/17] get_cycles() : MIPS HAVE_GET_CYCLES_32
Content-Disposition: inline; filename=get-cycles-mips-have-get-cycles.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 12 Nov 2008 23:33:01 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

partly reverts commit efb9ca08b5a2374b29938cdcab417ce4feb14b54. Selects
HAVE_GET_CYCLES_32 only on CPUs where it is safe to use it.

Currently consider the "_WORKAROUND" cases for 4000 and 4400 to be unsafe, but
should probably add other sub-architecture to the blacklist.

Do not define HAVE_GET_CYCLES because MIPS does not provide 64-bit tsc (only
32-bits).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: David Miller <davem@davemloft.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: linux-arch@vger.kernel.org
---
 arch/mips/Kconfig             |    4 ++++
 arch/mips/include/asm/timex.h |   25 +++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

Index: linux.trees.git/arch/mips/include/asm/timex.h
===================================================================
--- linux.trees.git.orig/arch/mips/include/asm/timex.h	2008-11-07 00:34:11.000000000 -0500
+++ linux.trees.git/arch/mips/include/asm/timex.h	2008-11-12 18:00:23.000000000 -0500
@@ -29,14 +29,39 @@
  * which isn't an evil thing.
  *
  * We know that all SMP capable CPUs have cycle counters.
+ *
+ * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ * HAVE_GET_CYCLES makes sure that this case is handled properly :
+ *
+ * Ralf Baechle <ralf@linux-mips.org> :
+ * This avoids us executing an mfc0 c0_count instruction on processors which
+ * don't have but also on certain R4000 and R4400 versions where reading from
+ * the count register just in the very moment when its value equals c0_compare
+ * will result in the timer interrupt getting lost.
  */
 
 typedef unsigned int cycles_t;
 
+#ifdef HAVE_GET_CYCLES_32
+static inline cycles_t get_cycles(void)
+{
+	return read_c0_count();
+}
+
+static inline void get_cycles_barrier(void)
+{
+}
+
+static inline cycles_t get_cycles_rate(void)
+{
+	return CLOCK_TICK_RATE;
+}
+#else
 static inline cycles_t get_cycles(void)
 {
 	return 0;
 }
+#endif
 
 #endif /* __KERNEL__ */
 
Index: linux.trees.git/arch/mips/Kconfig
===================================================================
--- linux.trees.git.orig/arch/mips/Kconfig	2008-11-07 00:34:11.000000000 -0500
+++ linux.trees.git/arch/mips/Kconfig	2008-11-12 18:00:23.000000000 -0500
@@ -1611,6 +1611,10 @@ config CPU_R4000_WORKAROUNDS
 config CPU_R4400_WORKAROUNDS
 	bool
 
+config HAVE_GET_CYCLES_32
+	def_bool y
+	depends on !CPU_R4400_WORKAROUNDS
+
 #
 # Use the generic interrupt handling code in kernel/irq/:
 #

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
