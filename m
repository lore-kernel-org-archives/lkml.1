Return-Path: <linux-kernel-owner+w=401wt.eu-S1763114AbYGOVQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763114AbYGOVQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbYGOVOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:14:35 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33441 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755650AbYGOVOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:14:31 -0400
Message-Id: <20080715211430.448714000@polaris-admin.engr.sgi.com>
References: <20080715211429.454823000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 14:14:36 -0700
From: Mike Travis <travis@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Paul Jackson <pj@sgi.com>
Subject: [PATCH 7/8] cpumask: Provide a generic set of CPUMASK_ALLOC macros
Content-Disposition: inline; filename=add-CPUMASK_ALLOC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Provide a generic set of CPUMASK_ALLOC macros patterned after the
    SCHED_CPUMASK_ALLOC macros.  This is used where multiple cpumask_t
    variables are declared on the stack to reduce the amount of stack
    space required.

Based on linux-2.6.tip/master at the following commit:

    commit 0a91813e16ebd5c2d9b5c2acd5b7c91742112c4f
    Merge: 9a635fa... 724dce0...
    Author: Ingo Molnar <mingo@elte.hu>
    Date:   Tue Jul 15 14:55:17 2008 +0200

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Paul Jackson <pj@sgi.com>
---
 include/linux/cpumask.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- linux-2.6.tip.orig/include/linux/cpumask.h
+++ linux-2.6.tip/include/linux/cpumask.h
@@ -75,6 +75,17 @@
  * CPU_MASK_NONE			Initializer - no bits set
  * unsigned long *cpus_addr(mask)	Array of unsigned long's in mask
  *
+ *if NR_CPUS > BITS_PER_LONG
+ *   CPUMASK_ALLOC(m)			Declares and allocates struct m *m =
+ *					   (struct m *)kmalloc(sizeof(*m), ...)
+ *   CPUMASK_FREE(m)			Macro for kfree(v)
+ *else
+ *   CPUMASK_ALLOC(m)			Declares struct m _m, *m = &_m
+ *   CPUMASK_FREE(m)			Nop
+ *endif
+ *   CPUMASK_VAR(v, m)			Declares cpumask_t *v =
+ *						m + offset(struct m, v)
+ *
  * int cpumask_scnprintf(buf, len, mask) Format cpumask for printing
  * int cpumask_parse_user(ubuf, ulen, mask)	Parse ascii string as cpumask
  * int cpulist_scnprintf(buf, len, mask) Format cpumask as list for printing
@@ -311,6 +322,16 @@ extern cpumask_t cpu_mask_all;
 
 #define cpus_addr(src) ((src).bits)
 
+#if NR_CPUS > BITS_PER_LONG
+#define	CPUMASK_ALLOC(m)	struct m *m = kmalloc(sizeof(*m), GFP_KERNEL)
+#define	CPUMASK_FREE(m)		kfree(m)
+#else
+#define	CPUMASK_ALLOC(m)	struct allmasks _m, *m = &_m
+#define	CPUMASK_FREE(m)
+#endif
+#define	CPUMASK_VAR(v, m) 	cpumask_t *v = (cpumask_t *)		\
+				((unsigned long)(m) + offsetof(struct m, v))
+
 #define cpumask_scnprintf(buf, len, src) \
 			__cpumask_scnprintf((buf), (len), &(src), NR_CPUS)
 static inline int __cpumask_scnprintf(char *buf, int len,

-- 
