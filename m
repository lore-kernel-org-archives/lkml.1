Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbZBRMGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbZBRMGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZBRMFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:05:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:50725 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbZBRMFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:05:34 -0500
From: Tejun Heo <tj@kernel.org>
To: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/10] percpu: kill percpu_alloc() and friends
Date: Wed, 18 Feb 2009 21:04:32 +0900
Message-Id: <1234958676-27618-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234958676-27618-1-git-send-email-tj@kernel.org>
References: <1234958676-27618-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Feb 2009 12:05:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: kill unused functions

percpu_alloc() and its friends never saw much action.  It was supposed
to replace the cpu-mask unaware __alloc_percpu() but it never happened
and in fact __percpu_alloc_mask() itself never really grew proper
up/down handling interface either (no exported interface for
populate/depopulate).

percpu allocation is about to go through major reimplementation and
there's no reason to carry this unused interface around.  Replace it
with __alloc_percpu() and free_percpu().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/percpu.h |   47 ++++++++++++++++++++++-------------------------
 mm/allocpercpu.c       |   32 +++++++++++++++++++-------------
 2 files changed, 41 insertions(+), 38 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 1fdaee9..d99e24a 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -82,46 +82,43 @@ struct percpu_data {
 
 #define __percpu_disguise(pdata) (struct percpu_data *)~(unsigned long)(pdata)
 
-extern void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask);
-extern void percpu_free(void *__pdata);
+/*
+ * Use this to get to a cpu's version of the per-cpu object
+ * dynamically allocated. Non-atomic access to the current CPU's
+ * version should probably be combined with get_cpu()/put_cpu().
+ */
+#define per_cpu_ptr(ptr, cpu)						\
+({									\
+        struct percpu_data *__p = __percpu_disguise(ptr);		\
+        (__typeof__(ptr))__p->ptrs[(cpu)];				\
+})
+
+extern void *__alloc_percpu(size_t size, size_t align);
+extern void free_percpu(void *__pdata);
 
 #else /* CONFIG_SMP */
 
 #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
 
-static __always_inline void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask)
+static inline void *__alloc_percpu(size_t size, size_t align)
 {
+	/*
+	 * Can't easily make larger alignment work with kmalloc.  WARN
+	 * on it.  Larger alignment should only be used for module
+	 * percpu sections on SMP for which this path isn't used.
+	 */
+	WARN_ON_ONCE(align > __alignof__(unsigned long long));
 	return kzalloc(size, gfp);
 }
 
-static inline void percpu_free(void *__pdata)
+static inline void free_percpu(void *p)
 {
-	kfree(__pdata);
+	kfree(p);
 }
 
 #endif /* CONFIG_SMP */
 
-#define percpu_alloc_mask(size, gfp, mask) \
-	__percpu_alloc_mask((size), (gfp), &(mask))
-
-#define percpu_alloc(size, gfp) percpu_alloc_mask((size), (gfp), cpu_online_map)
-
-/* (legacy) interface for use without CPU hotplug handling */
-
-#define __alloc_percpu(size, align)	percpu_alloc_mask((size), GFP_KERNEL, \
-						  cpu_possible_map)
 #define alloc_percpu(type)	(type *)__alloc_percpu(sizeof(type), \
 						       __alignof__(type))
-#define free_percpu(ptr)	percpu_free((ptr))
-/*
- * Use this to get to a cpu's version of the per-cpu object dynamically
- * allocated. Non-atomic access to the current CPU's version should
- * probably be combined with get_cpu()/put_cpu().
- */
-#define per_cpu_ptr(ptr, cpu)						\
-({									\
-        struct percpu_data *__p = __percpu_disguise(ptr);		\
-        (__typeof__(ptr))__p->ptrs[(cpu)];				\
-})
 
 #endif /* __LINUX_PERCPU_H */
diff --git a/mm/allocpercpu.c b/mm/allocpercpu.c
index 4297bc4..3653c57 100644
--- a/mm/allocpercpu.c
+++ b/mm/allocpercpu.c
@@ -99,45 +99,51 @@ static int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
 	__percpu_populate_mask((__pdata), (size), (gfp), &(mask))
 
 /**
- * percpu_alloc_mask - initial setup of per-cpu data
+ * alloc_percpu - initial setup of per-cpu data
  * @size: size of per-cpu object
- * @gfp: may sleep or not etc.
- * @mask: populate per-data for cpu's selected through mask bits
+ * @align: alignment
  *
- * Populating per-cpu data for all online cpu's would be a typical use case,
- * which is simplified by the percpu_alloc() wrapper.
- * Per-cpu objects are populated with zeroed buffers.
+ * Allocate dynamic percpu area.  Percpu objects are populated with
+ * zeroed buffers.
  */
-void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask)
+void *__alloc_percpu(size_t size, size_t align)
 {
 	/*
 	 * We allocate whole cache lines to avoid false sharing
 	 */
 	size_t sz = roundup(nr_cpu_ids * sizeof(void *), cache_line_size());
-	void *pdata = kzalloc(sz, gfp);
+	void *pdata = kzalloc(sz, GFP_KERNEL);
 	void *__pdata = __percpu_disguise(pdata);
 
+	/*
+	 * Can't easily make larger alignment work with kmalloc.  WARN
+	 * on it.  Larger alignment should only be used for module
+	 * percpu sections on SMP for which this path isn't used.
+	 */
+	WARN_ON_ONCE(align > __alignof__(unsigned long long));
+
 	if (unlikely(!pdata))
 		return NULL;
-	if (likely(!__percpu_populate_mask(__pdata, size, gfp, mask)))
+	if (likely(!__percpu_populate_mask(__pdata, size, GFP_KERNEL,
+					   &cpu_possible_map)))
 		return __pdata;
 	kfree(pdata);
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(__percpu_alloc_mask);
+EXPORT_SYMBOL_GPL(__alloc_percpu);
 
 /**
- * percpu_free - final cleanup of per-cpu data
+ * free_percpu - final cleanup of per-cpu data
  * @__pdata: object to clean up
  *
  * We simply clean up any per-cpu object left. No need for the client to
  * track and specify through a bis mask which per-cpu objects are to free.
  */
-void percpu_free(void *__pdata)
+void free_percpu(void *__pdata)
 {
 	if (unlikely(!__pdata))
 		return;
 	__percpu_depopulate_mask(__pdata, &cpu_possible_map);
 	kfree(__percpu_disguise(__pdata));
 }
-EXPORT_SYMBOL_GPL(percpu_free);
+EXPORT_SYMBOL_GPL(free_percpu);
-- 
1.6.0.2

