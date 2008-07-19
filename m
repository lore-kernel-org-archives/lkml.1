Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbYGSBN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbYGSBN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 21:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbYGSBLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 21:11:32 -0400
Received: from relay2.sgi.com ([192.48.171.30]:60229 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753823AbYGSBL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 21:11:28 -0400
Message-Id: <20080719011127.968788000@polaris-admin.engr.sgi.com>
References: <20080719011126.745278000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jul 2008 18:11:33 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Paul Jackson <pj@sgi.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>
Subject: [PATCH 7/8] cpumask: Provide a generic set of CPUMASK_ALLOC macros, FIXUP
Content-Disposition: inline; filename=fix-CPUMASK_ALLOC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Rename CPUMASK_VAR --> CPUMASK_PTR (and simplify)

  * Fix a semantic error in CPUMASK_ALLOC

  * Add a bit of commentry to cpumask.h

Based on linux-2.6.tip/master with the following commit:

    commit 77586c2bdad0798cb24e35de5a878e7c6b200574
    Author: Mike Travis <travis@sgi.com>  2008-07-15 14:14:37
    Committer: Ingo Molnar <mingo@elte.hu>  2008-07-18 13:03:00
    Parent: 77586c2bdad0798cb24e35de5a878e7c6b200574 (cpumask: Provide a generic set of CPUMASK_ALLOC macros)
    Child:  06f8d00e9eecb738c99b737ac38a585ea7583ad5 (cpumask: Optimize cpumask_of_cpu in lib/smp_processor_id.c, fix)
    Child:  32650cb6a8665a7635d025e52d9bf1905981ed11 (Merge branch 'cpus4096')
    Branches: -, devel, remotes/tip/cpus4096, remotes/tip/master, tip-latest

    cpumask: Provide a generic set of CPUMASK_ALLOC macros


Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Bert Wesarg <bert.wesarg@googlemail.com>
---
 include/linux/cpumask.h |   33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

--- linux-2.6.tip.orig/include/linux/cpumask.h
+++ linux-2.6.tip/include/linux/cpumask.h
@@ -75,16 +75,36 @@
  * CPU_MASK_NONE			Initializer - no bits set
  * unsigned long *cpus_addr(mask)	Array of unsigned long's in mask
  *
+ * CPUMASK_ALLOC kmalloc's a structure that is a composite of many cpumask_t
+ * variables, and CPUMASK_PTR provides pointers to each field.
+ *
+ * The structure should be defined something like this:
+ * struct my_cpumasks {
+ *	cpumask_t mask1;
+ *	cpumask_t mask2;
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
+ * References are now pointers to the cpumask_t variables (*mask1, ...)
+ *
  *if NR_CPUS > BITS_PER_LONG
  *   CPUMASK_ALLOC(m)			Declares and allocates struct m *m =
- *					   (struct m *)kmalloc(sizeof(*m), ...)
- *   CPUMASK_FREE(m)			Macro for kfree(v)
+ *						kmalloc(sizeof(*m), GFP_KERNEL)
+ *   CPUMASK_FREE(m)			Macro for kfree(m)
  *else
  *   CPUMASK_ALLOC(m)			Declares struct m _m, *m = &_m
  *   CPUMASK_FREE(m)			Nop
  *endif
- *   CPUMASK_VAR(v, m)			Declares cpumask_t *v =
- *						m + offset(struct m, v)
+ *   CPUMASK_PTR(v, m)			Declares cpumask_t *v = &(m->v)
+ * ------------------------------------------------------------------------
  *
  * int cpumask_scnprintf(buf, len, mask) Format cpumask for printing
  * int cpumask_parse_user(ubuf, ulen, mask)	Parse ascii string as cpumask
@@ -326,11 +346,10 @@ extern cpumask_t cpu_mask_all;
 #define	CPUMASK_ALLOC(m)	struct m *m = kmalloc(sizeof(*m), GFP_KERNEL)
 #define	CPUMASK_FREE(m)		kfree(m)
 #else
-#define	CPUMASK_ALLOC(m)	struct allmasks _m, *m = &_m
+#define	CPUMASK_ALLOC(m)	struct m _m, *m = &_m
 #define	CPUMASK_FREE(m)
 #endif
-#define	CPUMASK_VAR(v, m) 	cpumask_t *v = (cpumask_t *)		\
-				((unsigned long)(m) + offsetof(struct m, v))
+#define	CPUMASK_PTR(v, m) 	cpumask_t *v = &(m->v)
 
 #define cpumask_scnprintf(buf, len, src) \
 			__cpumask_scnprintf((buf), (len), &(src), NR_CPUS)

-- 
