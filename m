Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZGUK2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZGUK2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbZGUK2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:28:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:37097 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187AbZGUK2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:28:08 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       benh@kernel.crashing.org, davem@davemloft.net, dhowells@redhat.com,
       npiggin@suse.de, JBeulich@novell.com, cl@linux-foundation.org,
       rusty@rustcorp.com.au, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, x86@kernel.org, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/20] percpu: build first chunk allocators selectively
Date: Tue, 21 Jul 2009 19:26:03 +0900
Message-Id: <1248171979-29166-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1248171979-29166-1-git-send-email-tj@kernel.org>
References: <1248171979-29166-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Jul 2009 10:26:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to build unused first chunk allocators in.  Define
CONFIG_NEED_PER_CPU_*_FIRST_CHUNK and let archs enable them
selectively.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/Kconfig       |   10 ++++++++++
 include/linux/percpu.h |   27 +++++----------------------
 mm/percpu.c            |   19 +++++++++++--------
 3 files changed, 26 insertions(+), 30 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 001ad1d..5c0a3b4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -149,6 +149,16 @@ config ARCH_HAS_CACHE_LINE_SIZE
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
+config NEED_PER_CPU_EMBED_FIRST_CHUNK
+	def_bool y
+
+config NEED_PER_CPU_PAGE_FIRST_CHUNK
+	def_bool y
+
+config NEED_PER_CPU_LPAGE_FIRST_CHUNK
+	def_bool y
+	depends on NEED_MULTIPLE_NODES
+
 config HAVE_CPUMASK_OF_CPU_MAP
 	def_bool X86_64_SMP
 
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 7989f61..e26788e 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -70,17 +70,21 @@ extern size_t __init pcpu_setup_first_chunk(
 				ssize_t dyn_size, size_t unit_size,
 				void *base_addr, const int *unit_map);
 
+#ifdef CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK
 extern ssize_t __init pcpu_embed_first_chunk(
 				size_t static_size, size_t reserved_size,
 				ssize_t dyn_size);
+#endif
 
+#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 extern ssize_t __init pcpu_page_first_chunk(
 				size_t static_size, size_t reserved_size,
 				pcpu_fc_alloc_fn_t alloc_fn,
 				pcpu_fc_free_fn_t free_fn,
 				pcpu_fc_populate_pte_fn_t populate_pte_fn);
+#endif
 
-#ifdef CONFIG_NEED_MULTIPLE_NODES
+#ifdef CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK
 extern int __init pcpu_lpage_build_unit_map(
 				size_t static_size, size_t reserved_size,
 				ssize_t *dyn_sizep, size_t *unit_sizep,
@@ -98,27 +102,6 @@ extern ssize_t __init pcpu_lpage_first_chunk(
 
 extern void *pcpu_lpage_remapped(void *kaddr);
 #else
-static inline int pcpu_lpage_build_unit_map(
-				size_t static_size, size_t reserved_size,
-				ssize_t *dyn_sizep, size_t *unit_sizep,
-				size_t lpage_size, int *unit_map,
-				pcpu_fc_cpu_distance_fn_t cpu_distance_fn)
-{
-	return -EINVAL;
-}
-
-static inline ssize_t __init pcpu_lpage_first_chunk(
-				size_t static_size, size_t reserved_size,
-				size_t dyn_size, size_t unit_size,
-				size_t lpage_size, const int *unit_map,
-				int nr_units,
-				pcpu_fc_alloc_fn_t alloc_fn,
-				pcpu_fc_free_fn_t free_fn,
-				pcpu_fc_map_fn_t map_fn)
-{
-	return -EINVAL;
-}
-
 static inline void *pcpu_lpage_remapped(void *kaddr)
 {
 	return NULL;
diff --git a/mm/percpu.c b/mm/percpu.c
index 27a3033..4d926d3 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1414,8 +1414,9 @@ size_t __init pcpu_setup_first_chunk(size_t static_size, size_t reserved_size,
 	return pcpu_unit_size;
 }
 
-static size_t pcpu_calc_fc_sizes(size_t static_size, size_t reserved_size,
-				 ssize_t *dyn_sizep)
+static inline size_t pcpu_calc_fc_sizes(size_t static_size,
+					size_t reserved_size,
+					ssize_t *dyn_sizep)
 {
 	size_t size_sum;
 
@@ -1427,6 +1428,8 @@ static size_t pcpu_calc_fc_sizes(size_t static_size, size_t reserved_size,
 	return size_sum;
 }
 
+#if defined(CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK) || \
+	!defined(CONFIG_HAVE_SETUP_PER_CPU_AREA)
 /**
  * pcpu_embed_first_chunk - embed the first percpu chunk into bootmem
  * @static_size: the size of static percpu area in bytes
@@ -1495,7 +1498,10 @@ ssize_t __init pcpu_embed_first_chunk(size_t static_size, size_t reserved_size,
 	return pcpu_setup_first_chunk(static_size, reserved_size, dyn_size,
 				      unit_size, base, NULL);
 }
+#endif /* CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK ||
+	  !CONFIG_HAVE_SETUP_PER_CPU_AREA */
 
+#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 /**
  * pcpu_page_first_chunk - map the first chunk using PAGE_SIZE pages
  * @static_size: the size of static percpu area in bytes
@@ -1598,12 +1604,9 @@ out_free_ar:
 	free_bootmem(__pa(pages), pages_size);
 	return ret;
 }
+#endif /* CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK */
 
-/*
- * Large page remapping first chunk setup helper
- */
-#ifdef CONFIG_NEED_MULTIPLE_NODES
-
+#ifdef CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK
 /**
  * pcpu_lpage_build_unit_map - build unit_map for large page remapping
  * @static_size: the size of static percpu area in bytes
@@ -1982,7 +1985,7 @@ void *pcpu_lpage_remapped(void *kaddr)
 
 	return NULL;
 }
-#endif
+#endif /* CONFIG_NEED_PER_CPU_LPAGE_FIRST_CHUNK */
 
 /*
  * Generic percpu area setup.
-- 
1.6.0.2

