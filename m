Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbZKSJBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbZKSJBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 04:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbZKSJBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 04:01:23 -0500
Received: from ozlabs.org ([203.10.76.45]:46621 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252AbZKSJBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 04:01:22 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911191931.25847.rusty@rustcorp.com.au>
Date: Thu, 19 Nov 2009 19:31:25 +1030
Subject: [PATCH 5/6] cpumask: remove struct cpumask definition when CONFIG_CPUMASK_OFFSTACK=y
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We're about to change CONFIG_CPUMASK_OFFSTACK so it only allocate
nr_cpu_ids bits for all cpumasks.  We need to make sure that when
CONFIG_CPUMASK_OFFSTACK is set:

1) Noone uses the old bitmap ops, which use NR_CPUS bits (use cpumask_*)
2) Noone uses assignment of struct cpumask (use cpumask_copy)
3) Noone passes a struct cpumask (pass a pointer)
4) Noone declares them on the stack (use cpumask_var_t)

So we finally remove the definition of struct cpumask when
CONFIG_CPUMASK_OFFSTACK=y.  This means that these usages will hit a compile
error the moment that config option is turned on.

Note that it also means you can't declare a static cpumask.  You
should avoid this anyway (use cpumask_var_t), but there's a
deliberately-ugly workaround for special cases, using DECLARE_BITMAP()
and to_cpumask().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/cpumask.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -10,7 +10,15 @@
 #include <linux/threads.h>
 #include <linux/bitmap.h>
 
+#ifdef CONFIG_CPUMASK_OFFSTACK
+/*
+ * This is never declared, so you can't accidentally create one (see
+ * cpumask_var_t) or copy them by assignment (see cpumask_copy).
+ */
+struct cpumask;
+#else
 typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
+#endif /* CONFIG_CPUMASK_OFFSTACK */
 
 /**
  * cpumask_bits - get the bits in a cpumask
@@ -19,7 +28,14 @@ typedef struct cpumask { DECLARE_BITMAP(
  * You should only assume nr_cpu_ids bits of this mask are valid.  This is
  * a macro so it's const-correct.
  */
+#ifdef CONFIG_CPUMASK_OFFSTACK
+static inline unsigned long *cpumask_bits(const struct cpumask *mask)
+{
+	return (unsigned long *)mask;
+}
+#else
 #define cpumask_bits(maskp) ((maskp)->bits)
+#endif
 
 #if NR_CPUS == 1
 #define nr_cpu_ids		1

