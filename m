Return-Path: <linux-kernel-owner+w=401wt.eu-S1751054AbYKGFpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054AbYKGFpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 00:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYKGFoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 00:44:06 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:60902 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbYKGFoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 00:44:05 -0500
Message-Id: <20081107053350.852969114@polymtl.ca>
References: <20081107052336.652868737@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 07 Nov 2008 00:23:50 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [RFC patch 14/18] MIPS use tsc_sync.c
Content-Disposition: inline; filename=mips-use-tsc_sync.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri,  7 Nov 2008 05:43:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tsc-sync.c is now available to test if TSC is synchronized across cores. Given
I currently don't have access to a MIPS board myself, help trying to use it
when CPUs go online and testing the implementation would be welcome.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ralf Baechle <ralf@linux-mips.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/mips/include/asm/timex.h |   26 ++++++++++++++++++++++++++
 arch/mips/kernel/smp.c        |    1 +
 2 files changed, 27 insertions(+)

Index: linux.trees.git/arch/mips/kernel/smp.c
===================================================================
--- linux.trees.git.orig/arch/mips/kernel/smp.c	2008-11-07 00:06:06.000000000 -0500
+++ linux.trees.git/arch/mips/kernel/smp.c	2008-11-07 00:16:05.000000000 -0500
@@ -178,6 +178,7 @@ void __init smp_cpus_done(unsigned int m
 {
 	mp_ops->cpus_done();
 	synchronise_count_master();
+	test_tsc_synchronization();
 }
 
 /* called from main before smp_init() */
Index: linux.trees.git/arch/mips/include/asm/timex.h
===================================================================
--- linux.trees.git.orig/arch/mips/include/asm/timex.h	2008-11-07 00:10:10.000000000 -0500
+++ linux.trees.git/arch/mips/include/asm/timex.h	2008-11-07 00:16:05.000000000 -0500
@@ -56,13 +56,39 @@ static inline cycles_t get_cycles_rate(v
 {
 	return CLOCK_TICK_RATE;
 }
+
+extern int test_tsc_synchronization(void);
+extern int _tsc_is_sync;
+static inline int tsc_is_sync(void)
+{
+	return _tsc_is_sync;
+}
 #else
 static inline cycles_t get_cycles(void)
 {
 	return 0;
 }
+static inline int test_tsc_synchronization(void)
+{
+	return 0;
+}
+static inline int tsc_is_sync(void)
+{
+	return 0;
+}
 #endif
 
+#define DELAY_INTERRUPT 100
+/*
+ * Only updates 32 LSB.
+ */
+static inline void write_tsc(u32 val1, u32 val2)
+{
+	write_c0_count(val1);
+	/* Arrange for an interrupt in a short while */
+	write_c0_compare(read_c0_count() + DELAY_INTERRUPT);
+}
+
 #endif /* __KERNEL__ */
 
 #endif /*  _ASM_TIMEX_H */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
