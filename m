Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbYJWCQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbYJWCQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbYJWCIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:51 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46606 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754643AbYJWCIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:31 -0400
Message-Id: <20081023020831.491718000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:52 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 26/35] cpumask: to_cpumask() From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:to_cpumask.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are times when we really want a static cpumask.  Yet we don't
want to expose the struct cpumask definition, to avoid casual on-stack
usage and assignment.

So this macro allows you to do DECLARE_BITMAP(map, CONFIG_NR_CPUS); then use
to_cpumask() to turn it into a cpumask as needed.

Ugly?  Yes, but as we move to fewer static cpumasks these calls vanish.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -57,6 +57,9 @@
  * CPU_MASK_NONE			Initializer - no bits set
  * unsigned long *cpumask_bits(mask)	Array of unsigned long's in mask
  *
+ * struct cpumask *to_cpumask(const unsigned long[])
+ *					Convert a bitmap to a cpumask.
+ *
  * ------------------------------------------------------------------------
  *
  * int cpumask_scnprintf(buf, len, mask) Format cpumask for printing
@@ -365,6 +368,17 @@ static inline void cpumask_copy(struct c
 #define cpumask_any(srcp) cpumask_first(srcp)
 #define cpumask_any_and(mask1, mask2) cpumask_first_and((mask1), (mask2))
 
+/* Used for static bitmaps of CONFIG_NR_CPUS bits.  Must be a constant to use
+ * as an initializer. */
+#define to_cpumask(bitmap)						\
+	((struct cpumask *)(1 ? (bitmap)				\
+			    : (void *)sizeof(__check_is_bitmap(bitmap))))
+
+static inline int __check_is_bitmap(const unsigned long *bitmap)
+{
+	return 1;
+}
+
 /*
  * Special-case data structure for "single bit set only" constant CPU masks.
  *

-- 
