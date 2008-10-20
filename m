Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbYJTRT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbYJTRT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbYJTREw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:04:52 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55350 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753348AbYJTRDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:03:25 -0400
Message-Id: <20081020170323.736089000@polaris-admin.engr.sgi.com>
References: <20081020170319.539427000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Oct 2008 10:03:49 -0700
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
Subject: [PATCH 30/35] cpumask: CONFIG_BITS_ALL, CONFIG_BITS_NONE and CONFIG_BITS_CPU0
Content-Disposition: inline; filename=cpumask:CPU_BITS_ALL-and-CPU_BITS_NONE.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we're now preferring raw bitmaps for (eventually rare) static
cpumasks, we replace CPU_MASK_X with CPU_BITS_X.

From: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |   44 ++++++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 20 deletions(-)

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -53,8 +53,9 @@
  *
  * size_t cpumask_size()		Length of cpumask in bytes.
  * const struct cpumask *cpumask_of(cpu) Return cpumask with bit 'cpu' set
- * CPU_MASK_ALL				Initializer - all bits set
- * CPU_MASK_NONE			Initializer - no bits set
+ * CPU_BITS_ALL				Initializer - all bits set
+ * CPU_BITS_NONE			Initializer - no bits set
+ * CPU_BITS_CPU0			Initializer - first bit set
  * unsigned long *cpumask_bits(mask)	Array of unsigned long's in mask
  *
  * struct cpumask *to_cpumask(const unsigned long[])
@@ -116,6 +117,9 @@ struct cpumask
 typedef struct cpumask cpumask_t;
 extern cpumask_t _unused_cpumask_arg_;
 
+#define CPU_MASK_ALL		((cpumask_t){ CPU_BITS_ALL })
+#define CPU_MASK_NONE		((cpumask_t){ CPU_BITS_NONE })
+#define CPU_MASK_CPU0		((cpumask_t){ CPU_BITS_CPU0 })
 #define cpu_set(cpu, dst) cpumask_set_cpu((cpu), &(dst))
 #define cpu_clear(cpu, dst) cpumask_clear_cpu((cpu), &(dst))
 #define cpu_test_and_set(cpu, mask) cpumask_test_and_set_cpu((cpu), &(mask))
@@ -397,20 +401,20 @@ static inline const struct cpumask *cpum
 
 #if NR_CPUS <= BITS_PER_LONG
 
-#define CPU_MASK_ALL							\
-(cpumask_t) { {								\
-	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
-} }
+#define CPU_BITS_ALL						\
+{								\
+	[BITS_TO_LONGS(CONFIG_NR_CPUS)-1] = CPU_MASK_LAST_WORD	\
+}
 
 #define CPU_MASK_ALL_PTR	(&CPU_MASK_ALL)
 
 #else
 
-#define CPU_MASK_ALL							\
-(cpumask_t) { {								\
-	[0 ... BITS_TO_LONGS(NR_CPUS)-2] = ~0UL,			\
-	[BITS_TO_LONGS(NR_CPUS)-1] = CPU_MASK_LAST_WORD			\
-} }
+#define CPU_BITS_ALL						\
+{								\
+	[0 ... BITS_TO_LONGS(CONFIG_NR_CPUS)-2] = ~0UL,		\
+	[BITS_TO_LONGS(CONFIG_NR_CPUS)-1] = CPU_MASK_LAST_WORD	\
+}
 
 /* cpu_mask_all is in init/main.c */
 extern cpumask_t cpu_mask_all;
@@ -418,15 +422,15 @@ extern cpumask_t cpu_mask_all;
 
 #endif
 
-#define CPU_MASK_NONE							\
-(cpumask_t) { {								\
-	[0 ... BITS_TO_LONGS(NR_CPUS)-1] =  0UL				\
-} }
-
-#define CPU_MASK_CPU0							\
-(cpumask_t) { {								\
-	[0] =  1UL							\
-} }
+#define CPU_BITS_NONE						\
+{								\
+	[0 ... BITS_TO_LONGS(CONFIG_NR_CPUS)-1] = 0UL		\
+}
+
+#define CPU_BITS_CPU0						\
+{								\
+	[0] =  1UL						\
+}
 
 #if NR_CPUS == 1
 

-- 
