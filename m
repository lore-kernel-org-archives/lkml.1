Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbYJWCOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbYJWCOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbYJWCIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:42 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46603 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753875AbYJWCI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:28 -0400
Message-Id: <20081023020828.291817000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:36 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/35] cpumask: introduce cpumask_var_t for local cpumask vars From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:cpumask_var_t.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to move cpumasks off the stack: no local decls, no passing by
copy.  Linus suggested we use the array-or-pointer trick for on-stack
vars; we introduce a new cpumask_var_t for this.

Rather than pick an arbitrary limit, I chose a new config option so
arch maintainers can decide where their threshold is.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |   36 ++++++++++++++++++++++++++++++++++++
 kernel/Kconfig.preempt  |   10 ++++++++++
 lib/cpumask.c           |   31 +++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+)

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -485,6 +485,42 @@ int __next_cpu_nr(int n, const cpumask_t
 #endif /* NR_CPUS > 64 */
 
 /*
+ * cpumask_var_t: struct cpumask for stack usage.
+ *
+ * Oh, the wicked games we play!  In order to make kernel coding a
+ * little more difficult, we typedef cpumask_var_t to an array or a
+ * pointer: doing &mask on an array is a noop, so it still works.
+ *
+ * ie.
+ *	cpumask_var_t tmpmask;
+ *	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL))
+ *		return -ENOMEM;
+ *
+ *	  ... use 'tmpmask' like a normal struct cpumask * ...
+ *
+ *	free_cpumask_var(tmpmask);
+ */
+#ifdef CONFIG_CPUMASK_OFFSTACK
+typedef struct cpumask *cpumask_var_t;
+
+bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags);
+void free_cpumask_var(cpumask_var_t mask);
+
+#else
+typedef struct cpumask cpumask_var_t[1];
+
+static inline bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
+{
+	return true;
+}
+
+static inline void free_cpumask_var(cpumask_var_t mask)
+{
+}
+
+#endif /* CONFIG_CPUMASK_OFFSTACK */
+
+/*
  * The following particular system cpumasks and operations manage
  * possible, present, active and online cpus.  Each of them is a fixed size
  * bitmap of size NR_CPUS.
--- linux-2.6.28.orig/kernel/Kconfig.preempt
+++ linux-2.6.28/kernel/Kconfig.preempt
@@ -77,3 +77,13 @@ config RCU_TRACE
 
 	  Say Y here if you want to enable RCU tracing
 	  Say N if you are unsure.
+
+# FIXME - does not need to be in this Kconfig file but putting it here puts it
+# on the processors menu.  To fix means changing all arch Kconfig's.
+config CPUMASK_OFFSTACK
+	bool
+	prompt "Force CPU masks off stack" if DEBUG_PER_CPU_MAPS
+	help
+	  Use dynamic allocation for cpumask_var_t, instead of putting
+	  them on the stack.  This is a bit more expensive, but avoids
+	  stack overflow.
--- linux-2.6.28.orig/lib/cpumask.c
+++ linux-2.6.28/lib/cpumask.c
@@ -43,3 +43,34 @@ int __any_online_cpu(const cpumask_t *ma
 	return cpu;
 }
 EXPORT_SYMBOL(__any_online_cpu);
+
+/* These are not inline because of header tangles. */
+#ifdef CONFIG_CPUMASK_OFFSTACK
+bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags)
+{
+	if (likely(slab_is_available()))
+		*mask = kmalloc(cpumask_size(), flags);
+	else {
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+		printk(KERN_ERR
+			"=> alloc_cpumask_var: kmalloc not available!\n");
+		dump_stack();
+#endif
+		*mask = NULL;
+	}
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+	if (!*mask) {
+		printk(KERN_ERR "=> alloc_cpumask_var: failed!\n");
+		dump_stack();
+	}
+#endif
+	return *mask != NULL;
+}
+EXPORT_SYMBOL(alloc_cpumask_var);
+
+void free_cpumask_var(cpumask_var_t mask)
+{
+	kfree(mask);
+}
+EXPORT_SYMBOL(free_cpumask_var);
+#endif

-- 
