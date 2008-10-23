Return-Path: <linux-kernel-owner+w=401wt.eu-S1760555AbYJWCUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555AbYJWCUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbYJWCJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:09:03 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46600 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754606AbYJWCIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:31 -0400
Message-Id: <20081023020831.090442000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:50 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 24/35] cpumask: Deprecate CPUMASK_ALLOC etc in favor of cpumask_var_t. From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:deprecate-CPUMASK_ALLOC.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove CPUMASK_ALLOC() in favor of alloc_cpumask_var().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |   46 ++++++++--------------------------------------
 1 file changed, 8 insertions(+), 38 deletions(-)

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -57,35 +57,6 @@
  * CPU_MASK_NONE			Initializer - no bits set
  * unsigned long *cpumask_bits(mask)	Array of unsigned long's in mask
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
  * ------------------------------------------------------------------------
  *
  * int cpumask_scnprintf(buf, len, mask) Format cpumask for printing
@@ -183,6 +154,14 @@ extern cpumask_t _unused_cpumask_arg_;
 #define first_cpu(src)		cpumask_first(&(src))
 #define next_cpu(n, src)	cpumask_next((n), &(src))
 #define any_online_cpu(mask)	cpumask_any_and(&(mask), &cpu_online_map)
+#if NR_CPUS > BITS_PER_LONG
+#define	CPUMASK_ALLOC(m)	struct m *m = kmalloc(sizeof(*m), GFP_KERNEL)
+#define	CPUMASK_FREE(m)		kfree(m)
+#else
+#define	CPUMASK_ALLOC(m)	struct m _m, *m = &_m
+#define	CPUMASK_FREE(m)
+#endif
+#define	CPUMASK_PTR(v, m) 	cpumask_t *v = &(m->v)
 /* End deprecated region. */
 
 #if NR_CPUS > 1
@@ -438,15 +417,6 @@ extern cpumask_t cpu_mask_all;
 	[0] =  1UL							\
 } }
 
-#if NR_CPUS > BITS_PER_LONG
-#define	CPUMASK_ALLOC(m)	struct m *m = kmalloc(sizeof(*m), GFP_KERNEL)
-#define	CPUMASK_FREE(m)		kfree(m)
-#else
-#define	CPUMASK_ALLOC(m)	struct m _m, *m = &_m
-#define	CPUMASK_FREE(m)
-#endif
-#define	CPUMASK_PTR(v, m) 	cpumask_t *v = &(m->v)
-
 #if NR_CPUS == 1
 
 #define cpumask_first(src)		({ (void)(src); 0; })

-- 
