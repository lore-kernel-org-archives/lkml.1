Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbYIFXuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbYIFXuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYIFXuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:50:39 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59378 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752995AbYIFXui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:50:38 -0400
Message-Id: <20080906235037.471203000@polaris-admin.engr.sgi.com>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 06 Sep 2008 16:50:40 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RFC 04/13] cpumask: add cpumask_ptr operations
Content-Disposition: inline; filename=get_cpumask_ptr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * Define a generic cpumask_ptr type and some helper functions that
 * do not add any overhead to low count NR_CPUS systems.  Essentially
 * for NR_CPUS <= BITS_PER_LONG, an array of one cpumask is created on
 * the stack.  For larger count systems, a pointer is defined.  In both
 * cases the pointer variable can be used as C will optimize out the
 * pointer derefence in the small system case.
 *
 * Add a simple kmalloc to allocate a temporary cpumask variable.
 * (Note, kmalloc should be defined before including this file.)
 *
 * Add a simple per_cpu variable to facilitate those cases where a
 * kmalloc failure cannot be reasonable handled (or we're using it
 * before the mm system is initialized.)
 *
 * This is useful for getting temporary per_cpu cpumask_t variables.
 * Note there are no locks, so these are _extremely_ temporary cpumask
 * vars, with only preemption disabled, while in use.
 *
 * Many thanks to Linus Torvalds for the typedef/alloc idea.
 *
 * Adds the following cpumask_ptr operations for NR_CPUS > BITS_PER_LONG:
 *
 *   cpumask_ptr p;		Declares p to be a cpumask_t pointer
 *
 *   alloc_cpumask_ptr(p);	allocates and assigns memory to p
 *   free_cpumask_ptr(p);	frees memory used by p
 *
 *   DEFINE_PER_CPUMASK(p, v)	Defines a PER_CPUMASK variable v
 *   DECLARE_PER_CPUMASK(p, v)	Declares a PER_CPUMASK variable v
 *   get_cpumask_var(p, v)	Obtains possession of PER_CPUMASK variable v
 *   				and assignes it to p
 *   put_cpumask_var(p, v)	Relenquishs possession of PER_CPUMASK variable v
 *
 * If NR_CPUS <= BITS_PER_LONG then the above are all essentially NOP's.

Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask_ptr.h |   78 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

--- /dev/null
+++ linux-2.6.tip/include/linux/cpumask_ptr.h
@@ -0,0 +1,78 @@
+#ifndef __LINUX_CPUMASK_PTR_H
+#define __LINUX_CPUMASK_PTR_H
+
+/*
+ * Define a generic cpumask_ptr type and some helper functions that
+ * do not add any overhead to low count NR_CPUS systems.  Essentially
+ * for NR_CPUS <= BITS_PER_LONG, an array of one cpumask is created on
+ * the stack.  For larger count systems, a pointer is defined.  In both
+ * cases the pointer variable can be used as C will optimize out the
+ * pointer derefence in the small system case.
+ *
+ * Add a simple kmalloc to allocate a temporary cpumask variable.
+ * (Note, kmalloc should be defined before including this file.)
+ *
+ * Add a simple per_cpu variable to facilitate those cases where a
+ * kmalloc failure cannot be reasonable handled (or we're using it
+ * before the mm system is initialized.)
+ *
+ * This is useful for getting temporary per_cpu cpumask_t variables.
+ * Note there are no locks, so these are _extremely_ temporary cpumask
+ * vars, with only preemption disabled, while in use.
+ *
+ * Many thanks to Linus Torvalds for the typedef/alloc idea.
+ *
+ * Adds the following cpumask_ptr operations for NR_CPUS > BITS_PER_LONG:
+ *
+ *   cpumask_ptr p;		Declares p to be a cpumask_t pointer
+ *
+ *   alloc_cpumask_ptr(p);	allocates and assigns memory to p
+ *   free_cpumask_ptr(p);	frees memory used by p
+ *
+ *   DEFINE_PER_CPUMASK(p, v)	Defines a PER_CPUMASK variable v
+ *   DECLARE_PER_CPUMASK(p, v)	Declares a PER_CPUMASK variable v
+ *   get_cpumask_var(p, v)	Obtains possession of PER_CPUMASK variable v
+ *   				and assignes it to p
+ *   put_cpumask_var(p, v)	Relenquishs possession of PER_CPUMASK variable v
+ *
+ * If NR_CPUS <= BITS_PER_LONG then the above are all essentially NOP's.
+ */
+
+#if NR_CPUS <= BITS_PER_LONG
+
+typedef cpumask_t cpumask_ptr[1];
+static inline void alloc_cpumask_ptr(cpumask_ptr *p)
+{
+}
+static inline void free_cpumask_ptr(cpumask_ptr *p)
+{
+}
+#define	DEFINE_PER_CPUMASK(v)	void *unused_##v __maybe_unused
+#define	DECLARE_PER_CPUMASK(v)
+#define get_cpumask_var(p, v)	do { } while(0)
+#define put_cpumask_var(p, v)	do { } while(0)
+
+#else /* NR_CPUS > BITS_PER_LONG */
+
+#include <linux/slab.h>
+typedef cpumask_t *cpumask_ptr;
+static inline void _get_cpumask_ptr(cpumask_ptr *p, cpumask_t *m)
+{
+	*p = m;
+}
+static inline void alloc_cpumask_ptr(cpumask_ptr *p)
+{
+	_get_cpumask_ptr(p, kmalloc(sizeof(cpumask_t), GFP_KERNEL));
+}
+static inline void free_cpumask_ptr(cpumask_ptr *p)
+{
+	kfree(*p);
+}
+#define	DEFINE_PER_CPUMASK(v)	DEFINE_PER_CPU(cpumask_t, v)
+#define	DECLARE_PER_CPUMASK(v)	DECLARE_PER_CPU(cpumask_t, v)
+#define	get_cpumask_var(p, v)	_get_cpumask_ptr(&(p), &get_cpu_var(v))
+#define	put_cpumask_var(p, v)	put_cpu_var(v)
+
+#endif /* NR_CPUS > BITS_PER_LONG */
+
+#endif /* __LINUX_CPUMASK_PTR_H */

-- 
