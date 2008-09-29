Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbYI2SEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbYI2SEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbYI2SC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:02:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58603 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751207AbYI2SCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:51 -0400
Message-Id: <20080929180250.691707000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:02:54 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 04/31] cpumask: move cpu_alloc to separate file
Content-Disposition: inline; filename=mv-cpumask-alloc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h       |   40 -------------
 include/linux/cpumask_alloc.h |  127 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 127 insertions(+), 40 deletions(-)

--- struct-cpumasks.orig/include/linux/cpumask.h
+++ struct-cpumasks/include/linux/cpumask.h
@@ -67,37 +67,6 @@
  * CPU_MASK_NONE			Initializer - no bits set
  * unsigned long *cpus_addr(mask)	Array of unsigned long's in mask
  *
- * CPUMASK_ALLOC kmalloc's a structure that is a composite of many cpumask_t
- * variables, and CPUMASK_PTR provides pointers to each field.
- *
- * The structure should be defined something like this:
- * struct my_cpumasks {
- *	cpumask_t mask1;
- *	cpumask_t mask2;
- * };
- *
- * Usage is then:
- *	CPUMASK_ALLOC(my_cpumasks);
- *	CPUMASK_PTR(mask1, my_cpumasks);
- *	CPUMASK_PTR(mask2, my_cpumasks);
- *
- *	--- DO NOT reference cpumask_t pointers until this check ---
- *	if (my_cpumasks == NULL)
- *		"kmalloc failed"...
- *
- * References are now pointers to the cpumask_t variables (*mask1, ...)
- *
- *if NR_CPUS > BITS_PER_LONG
- *   CPUMASK_ALLOC(m)			Declares and allocates struct m *m =
- *						kmalloc(sizeof(*m), GFP_KERNEL)
- *   CPUMASK_FREE(m)			Macro for kfree(m)
- *else
- *   CPUMASK_ALLOC(m)			Declares struct m _m, *m = &_m
- *   CPUMASK_FREE(m)			Nop
- *endif
- *   CPUMASK_PTR(v, m)			Declares cpumask_t *v = &(m->v)
- * ------------------------------------------------------------------------
- *
  * int cpumask_scnprintf(buf, len, mask) Format cpumask for printing
  * int cpumask_parse_user(ubuf, ulen, mask)	Parse ascii string as cpumask
  * int cpulist_scnprintf(buf, len, mask) Format cpumask as list for printing
@@ -327,15 +296,6 @@ extern cpumask_t cpu_mask_all;
 
 #define cpus_addr(src) ((src).bits)
 
-#if NR_CPUS > BITS_PER_LONG
-#define	CPUMASK_ALLOC(m)	struct m *m = kmalloc(sizeof(*m), GFP_KERNEL)
-#define	CPUMASK_FREE(m)		kfree(m)
-#else
-#define	CPUMASK_ALLOC(m)	struct m _m, *m = &_m
-#define	CPUMASK_FREE(m)
-#endif
-#define	CPUMASK_PTR(v, m) 	cpumask_t *v = &(m->v)
-
 #define cpumask_scnprintf(buf, len, src) \
 			__cpumask_scnprintf((buf), (len), &(src), NR_CPUS)
 static inline int __cpumask_scnprintf(char *buf, int len,
--- /dev/null
+++ struct-cpumasks/include/linux/cpumask_alloc.h
@@ -0,0 +1,127 @@
+#ifndef __LINUX_CPUMASK_ALLOC_H
+#define __LINUX_CPUMASK_ALLOC_H
+
+/*
+ * Simple alloc/free of cpumask structs
+ */
+
+#if NR_CPUS > BITS_PER_LONG
+
+#include <linux/slab.h>
+
+/* Allocates a cpumask large enough to contain nr_cpu_ids cpus */
+static inline int cpumask_alloc(cpumask_t *m)
+{
+	cpumask_t d = kmalloc(CPUMASK_SIZE, GFP_KERNEL);
+
+	*m = d;
+	return (d != NULL);
+}
+
+static inline void cpumask_free_(cpumask_t *m)
+{
+	kfree(*m);
+}
+
+#else
+static inline cpumask_val cpumask_alloc(cpumask_t *m)
+{
+}
+
+static inline void cpumask_free(cpumask_t *m)
+{
+}
+
+#endif
+
+/*
+ * Manage a pool of percpu temp cpumask's
+ */
+struct cpumask_pool_s {
+	unsigned long	length;
+	unsigned long	allocated;
+	cpumask_fixed	pool;
+};
+
+#if 0
+#define DEFINE_PER_CPUMASK_POOL(name, size)		\
+	struct __pool_##name##_s {			\
+		unsigned long	allocated;		\
+		cpumask_data	pool[size];		\
+	}						\
+	DEFINE_PER_CPU(struct __pool_##name##_s, name)
+#else
+#define DEFINE_PER_CPUMASK_POOL(name, size)		\
+	DEFINE_PER_CPU(					\
+		struct {				\
+			unsigned long	length;		\
+			unsigned long	allocated;	\
+			cpumask_data	pool[size];	\
+		}, name ) = { .length = size, }
+#endif
+
+#define	cpumask_pool_get(m, p)	__cpumask_pool_get(m, &__get_cpu_var(p))
+#define	cpumask_pool_put(m, p)	__cpumask_pool_put(m, &__get_cpu_var(p));
+
+static inline int __cpumask_pool_get(cpumask_t *m,
+				     struct cpumask_pool_s *p)
+{
+	int n;
+
+	preempt_disable();
+	while ((n = find_first_bit(&p->allocated, p->length)) < p->length &&
+		!test_and_set_bit(n, &p->allocated)) {
+
+		*m = &(p->pool[n]);
+		preempt_enable();
+		return 1;
+	}
+	preempt_enable();
+	return 0;
+}
+
+static inline void __cpumask_pool_put(cpumask_t *m,
+				      struct cpumask_pool_s *p)
+{
+	int n = *m - p->pool;
+
+	BUG_ON(n >= p->length);
+
+	preempt_disable();
+	clear_bit(n, &p->allocated);
+	preempt_enable();
+}
+
+/*
+ * CPUMASK_ALLOC kmalloc's a structure that is a composite of many cpumask_t
+ * variables, and CPUMASK_PTR provides pointers to each field.
+ *
+ * The structure should be defined something like this:
+ * struct my_cpumasks {
+ *	cpumask_fixed mask1;
+ *	cpumask_fixed mask2;
+ * };
+ *
+ * Usage is then:
+ *	CPUMASK_ALLOC(my_cpumasks);
+ *	CPUMASK_PTR(mask1, my_cpumasks);
+ *	CPUMASK_PTR(mask2, my_cpumasks);
+ *
+ *	--- DO NOT reference cpumask_t pointers until this check ---
+ *	if (my_cpumasks == NULL)
+ *		"kmalloc failed"...
+ *
+ * References are now cpumask_var variables (*mask1, ...)
+ */
+
+#if NR_CPUS > BITS_PER_LONG
+#define	CPUMASK_ALLOC(m)	struct m *m = kmalloc(sizeof(*m), GFP_KERNEL)
+#define	CPUMASK_FREE(m)		kfree(m)
+#define	CPUMASK_PTR(v, m) 	cpumask_var v = (m->v)
+#else
+#define	CPUMASK_ALLOC(m)	struct m m
+#define	CPUMASK_FREE(m)
+#define	CPUMASK_PTR(v, m) 	cpumask_var v
+#endif
+
+#endif /* __LINUX_CPUMASK_ALLOC_H */

-- 
