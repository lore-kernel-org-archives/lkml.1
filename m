Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYIFXwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYIFXwI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbYIFXun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:50:43 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59391 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752986AbYIFXuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:50:39 -0400
Message-Id: <20080906235037.608279000@polaris-admin.engr.sgi.com>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 06 Sep 2008 16:50:41 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RFC 05/13] cpumask: add get_cpumask_var debug operations
Content-Disposition: inline; filename=get_cpumask_var-debug
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Adds debugging to the get_cpumask_var operations.  It uses a primitive
    per_cpu lock variable and will only discover nested get_cpumask_var
    operations on the same variable.

Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/Kconfig.debug      |   12 ++++++++++++
 include/linux/cpumask_ptr.h |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

--- linux-2.6.tip.orig/arch/x86/Kconfig.debug
+++ linux-2.6.tip/arch/x86/Kconfig.debug
@@ -92,6 +92,18 @@ config DEBUG_PER_CPU_MAPS
 
 	  Say N if unsure.
 
+config DEBUG_PER_CPUMASK_VAR
+	bool "Debug per_cpumask variables"
+	depends on DEBUG_KERNEL
+	depends on X86_SMP
+	default n
+	help
+	  Say Y to verify that the per_cpumask variables being accessed
+	  are available.  Adds a fair amount of code to kernel memory
+	  and decreases performance.
+
+	  Say N if unsure.
+
 config X86_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
--- linux-2.6.tip.orig/include/linux/cpumask_ptr.h
+++ linux-2.6.tip/include/linux/cpumask_ptr.h
@@ -53,11 +53,45 @@ static inline void free_cpumask_ptr(cpum
 {
 	kfree(*p);
 }
+
+#ifndef CONFIG_DEBUG_CPUMASK_VAR
 #define	DEFINE_PER_CPUMASK(v)	DEFINE_PER_CPU(cpumask_t, v)
 #define	DECLARE_PER_CPUMASK(v)	DECLARE_PER_CPU(cpumask_t, v)
 #define	get_cpumask_var(p, v)	_get_cpumask_ptr(&(p), &get_cpu_var(v))
 #define	put_cpumask_var(p, v)	put_cpu_var(v)
 
+#else /* CONFIG_DEBUG_CPUMASK_VAR */
+#define	DEFINE_PER_CPUMASK(v)	DEFINE_PER_CPU(cpumask_t, v);	\
+				DEFINE_PER_CPU(char, lock_##v)
+#define	DECLARE_PER_CPUMASK(v)	DECLARE_PER_CPU(cpumask_t, v);	\
+				DECLARE_PER_CPU(char, lock_##v)
+
+#define	get_cpumask_var(p, v)	{				\
+	char *lock = &get_cpu_var(lock_##v);			\
+	if (*lock) {						\
+		printk(KERN_NOTICE "get_cpumask_var(" v "): "	\
+			"already locked!\n");			\
+		dump_stack();					\
+		BUG();						\
+	}							\
+	*lock = 1;						\
+	_get_cpumask_ptr(&(p), &get_cpu_var(v))			\
+	put_cpu_var(lock_##v);					\
+}
+
+#define	put_cpumask_var(p, v)	{				\
+	char *lock = &get_cpu_var(lock_##v);			\
+	if (!*lock) {						\
+		printk(KERN_NOTICE "put_cpumask_var(" v "): "	\
+			"not locked!\n");			\
+		dump_stack();					\
+	}							\
+	*lock = 0;						\
+	put_cpu_var(lock_##v);					\
+	put_cpu_var(v);						\
+}
+#endif /* CONFIG_DEBUG_CPUMASK_VAR */
+
 #endif /* NR_CPUS > BITS_PER_LONG */
 
 #endif /* __LINUX_CPUMASK_PTR_H */

-- 
