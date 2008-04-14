Return-Path: <linux-kernel-owner+w=401wt.eu-S1765886AbYDNSRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765886AbYDNSRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765098AbYDNSOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:14:52 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49298 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765079AbYDNSOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:14:51 -0400
Date: Mon, 14 Apr 2008 21:13:45 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>
Subject: [2.6 patch] mm/allocpercpu.c: make 4 functions static
Message-ID: <20080414181345.GJ6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- percpu_depopulate()
- __percpu_depopulate_mask()
- percpu_populate()
- __percpu_populate_mask()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Christoph Lameter <clameter@sgi.com>

---

This patch has been sent on:
- 31 Mar 2008
- 25 Feb 2008

 include/linux/percpu.h |   29 -----------------------------
 mm/allocpercpu.c       |   20 +++++++++++---------
 2 files changed, 11 insertions(+), 38 deletions(-)

d11f49caeadfdeef1b9e9c07103de2cdb5346e36 diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 1ac9697..4437b52 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -69,11 +69,6 @@ struct percpu_data {
         (__typeof__(ptr))__p->ptrs[(cpu)];	          \
 })
 
-extern void *percpu_populate(void *__pdata, size_t size, gfp_t gfp, int cpu);
-extern void percpu_depopulate(void *__pdata, int cpu);
-extern int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
-				  cpumask_t *mask);
-extern void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask);
 extern void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask);
 extern void percpu_free(void *__pdata);
 
@@ -81,26 +76,6 @@ extern void percpu_free(void *__pdata);
 
 #define percpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
 
-static inline void percpu_depopulate(void *__pdata, int cpu)
-{
-}
-
-static inline void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
-{
-}
-
-static inline void *percpu_populate(void *__pdata, size_t size, gfp_t gfp,
-				    int cpu)
-{
-	return percpu_ptr(__pdata, cpu);
-}
-
-static inline int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
-					 cpumask_t *mask)
-{
-	return 0;
-}
-
 static __always_inline void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask)
 {
 	return kzalloc(size, gfp);
@@ -113,10 +88,6 @@ static inline void percpu_free(void *__pdata)
 
 #endif /* CONFIG_SMP */
 
-#define percpu_populate_mask(__pdata, size, gfp, mask) \
-	__percpu_populate_mask((__pdata), (size), (gfp), &(mask))
-#define percpu_depopulate_mask(__pdata, mask) \
-	__percpu_depopulate_mask((__pdata), &(mask))
 #define percpu_alloc_mask(size, gfp, mask) \
 	__percpu_alloc_mask((size), (gfp), &(mask))
 
diff --git a/mm/allocpercpu.c b/mm/allocpercpu.c
index 7e58322..cbadbe2 100644
--- a/mm/allocpercpu.c
+++ b/mm/allocpercpu.c
@@ -14,27 +14,28 @@
  * Depopulating per-cpu data for a cpu going offline would be a typical
  * use case. You need to register a cpu hotplug handler for that purpose.
  */
-void percpu_depopulate(void *__pdata, int cpu)
+static void percpu_depopulate(void *__pdata, int cpu)
 {
 	struct percpu_data *pdata = __percpu_disguise(__pdata);
 
 	kfree(pdata->ptrs[cpu]);
 	pdata->ptrs[cpu] = NULL;
 }
-EXPORT_SYMBOL_GPL(percpu_depopulate);
 
 /**
  * percpu_depopulate_mask - depopulate per-cpu data for some cpu's
  * @__pdata: per-cpu data to depopulate
  * @mask: depopulate per-cpu data for cpu's selected through mask bits
  */
-void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
+static void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
 {
 	int cpu;
 	for_each_cpu_mask(cpu, *mask)
 		percpu_depopulate(__pdata, cpu);
 }
-EXPORT_SYMBOL_GPL(__percpu_depopulate_mask);
+
+#define percpu_depopulate_mask(__pdata, mask) \
+	__percpu_depopulate_mask((__pdata), &(mask))
 
 /**
  * percpu_populate - populate per-cpu data for given cpu
@@ -47,7 +48,7 @@ EXPORT_SYMBOL_GPL(__percpu_depopulate_mask);
  * use case. You need to register a cpu hotplug handler for that purpose.
  * Per-cpu object is populated with zeroed buffer.
  */
-void *percpu_populate(void *__pdata, size_t size, gfp_t gfp, int cpu)
+static void *percpu_populate(void *__pdata, size_t size, gfp_t gfp, int cpu)
 {
 	struct percpu_data *pdata = __percpu_disguise(__pdata);
 	int node = cpu_to_node(cpu);
@@ -59,7 +60,6 @@ void *percpu_populate(void *__pdata, size_t size, gfp_t gfp, int cpu)
 		pdata->ptrs[cpu] = kzalloc(size, gfp);
 	return pdata->ptrs[cpu];
 }
-EXPORT_SYMBOL_GPL(percpu_populate);
 
 /**
  * percpu_populate_mask - populate per-cpu data for more cpu's
@@ -70,8 +70,8 @@ EXPORT_SYMBOL_GPL(percpu_populate);
  *
  * Per-cpu objects are populated with zeroed buffers.
  */
-int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
-			   cpumask_t *mask)
+static int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
+				  cpumask_t *mask)
 {
 	cpumask_t populated = CPU_MASK_NONE;
 	int cpu;
@@ -84,7 +84,9 @@ int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
 			cpu_set(cpu, populated);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(__percpu_populate_mask);
+
+#define percpu_populate_mask(__pdata, size, gfp, mask) \
+	__percpu_populate_mask((__pdata), (size), (gfp), &(mask))
 
 /**
  * percpu_alloc_mask - initial setup of per-cpu data

