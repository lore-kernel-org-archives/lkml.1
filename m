Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYJTRMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYJTRMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbYJTREL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:04:11 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55400 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753454AbYJTRD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:03:28 -0400
Message-Id: <20081020170324.280990000@polaris-admin.engr.sgi.com>
References: <20081020170319.539427000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Oct 2008 10:03:53 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       peterz@infradead.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, IA64 <linux-ia64@vger.kernel.org>,
       PowerPC <linuxppc-dev@ozlabs.org>, S390 <linux-s390@vger.kernel.org>,
       SPARC <sparclinux@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 34/35] cpumask: debug options for cpumasks
Content-Disposition: inline; filename=cpumask:check-all-ops-for-limits.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's useful to check that no one is accessing > nr_cpumask_bits for
cpumasks.  This also allows you to turn on CONFIG_CPUMASKS_OFFSTACK
even for smaller CONFIG_NR_CPUS.

From: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |   23 +++++++++++++++++------
 lib/Kconfig.debug       |    6 ++++++
 lib/cpumask.c           |    3 +++
 3 files changed, 26 insertions(+), 6 deletions(-)

--- test-compile.orig/include/linux/cpumask.h
+++ test-compile/include/linux/cpumask.h
@@ -217,23 +217,34 @@ extern cpumask_t _unused_cpumask_arg_;
 }
 #endif /* CONFIG_NR_CPUS > BITS_PER_LONG */
 
+/* verify cpu argument to cpumask_* operators */
+static inline unsigned int cpumask_check(unsigned int cpu)
+{
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+	/* This breaks at runtime. */
+	BUG_ON(cpu >= nr_cpumask_bits);
+#endif /* CONFIG_DEBUG_PER_CPU_MAPS */
+	return cpu;
+}
+
 /* cpumask_* operators */
 static inline void cpumask_set_cpu(int cpu, volatile struct cpumask *dstp)
 {
-	set_bit(cpu, cpumask_bits(dstp));
+	set_bit(cpumask_check(cpu), cpumask_bits(dstp));
 }
 
 static inline void cpumask_clear_cpu(int cpu, volatile struct cpumask *dstp)
 {
-	clear_bit(cpu, cpumask_bits(dstp));
+	clear_bit(cpumask_check(cpu), cpumask_bits(dstp));
 }
 
 /* No static inline type checking - see Subtlety (1) above. */
-#define cpumask_test_cpu(cpu, cpumask) test_bit((cpu), (cpumask)->bits)
+#define cpumask_test_cpu(cpu, cpumask) \
+	test_bit(cpumask_check(cpu), (cpumask)->bits)
 
 static inline int cpumask_test_and_set_cpu(int cpu, struct cpumask *addr)
 {
-	return test_and_set_bit(cpu, cpumask_bits(addr));
+	return test_and_set_bit(cpumask_check(cpu), cpumask_bits(addr));
 }
 
 static inline void cpumask_setall(struct cpumask *dstp)
@@ -367,8 +378,8 @@ static inline int cpumask_cpuremap(int o
 				   const struct cpumask *oldp,
 				   const struct cpumask *newp)
 {
-	return bitmap_bitremap(oldbit, cpumask_bits(oldp), cpumask_bits(newp),
-							   nr_cpumask_bits);
+	return bitmap_bitremap(cpumask_check(oldbit), cpumask_bits(oldp),
+				cpumask_bits(newp), nr_cpumask_bits);
 }
 
 static inline void cpumask_remap(struct cpumask *dstp,
--- test-compile.orig/lib/Kconfig.debug
+++ test-compile/lib/Kconfig.debug
@@ -766,6 +766,12 @@ config SYSCTL_SYSCALL_CHECK
 	  to properly maintain and use. This enables checks that help
 	  you to keep things correct.
 
+config DEBUG_PER_CPU_MAPS
+	bool "Cpumask debug checks"
+	---help---
+	  Extra debugging for cpumasks.
+	  eg. to make sure accesses to cpumasks are < nr_cpu_ids.
+
 source kernel/trace/Kconfig
 
 config PROVIDE_OHCI1394_DMA_INIT
--- test-compile.orig/lib/cpumask.c
+++ test-compile/lib/cpumask.c
@@ -11,6 +11,9 @@ EXPORT_SYMBOL(cpumask_first);
 
 int cpumask_next(int n, const cpumask_t *srcp)
 {
+	/* -1 is a legal arg here. */
+	if (n != -1)
+		cpumask_check(n);
 	return find_next_bit(cpumask_bits(srcp), nr_cpumask_bits, n+1);
 }
 EXPORT_SYMBOL(cpumask_next);

-- 
