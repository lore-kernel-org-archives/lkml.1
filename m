Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZGXQNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZGXQNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 12:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZGXQNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 12:13:36 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:51180 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753312AbZGXQMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 12:12:19 -0400
Subject: [PATCH 3/8] kmemleak: Mark the early log buffer as __initdata
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 24 Jul 2009 17:12:18 +0100
Message-ID: <20090724161218.5752.49773.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
References: <20090724161026.5752.52503.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc1-9-gd8846
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2009 16:12:19.0018 (UTC) FILETIME=[84AFF2A0:01CA0C79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This buffer isn't needed after kmemleak was initialised so it can be
freed together with the .init.data section. This patch also marks
functions conditionally accessing the early log variables with __ref.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 include/linux/kmemleak.h |   18 +++++++++---------
 mm/kmemleak.c            |   26 ++++++++++++++------------
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/include/linux/kmemleak.h b/include/linux/kmemleak.h
index 6a63807..3c7497d 100644
--- a/include/linux/kmemleak.h
+++ b/include/linux/kmemleak.h
@@ -23,18 +23,18 @@
 
 #ifdef CONFIG_DEBUG_KMEMLEAK
 
-extern void kmemleak_init(void);
+extern void kmemleak_init(void) __ref;
 extern void kmemleak_alloc(const void *ptr, size_t size, int min_count,
-			   gfp_t gfp);
-extern void kmemleak_free(const void *ptr);
-extern void kmemleak_free_part(const void *ptr, size_t size);
+			   gfp_t gfp) __ref;
+extern void kmemleak_free(const void *ptr) __ref;
+extern void kmemleak_free_part(const void *ptr, size_t size) __ref;
 extern void kmemleak_padding(const void *ptr, unsigned long offset,
-			     size_t size);
-extern void kmemleak_not_leak(const void *ptr);
-extern void kmemleak_ignore(const void *ptr);
+			     size_t size) __ref;
+extern void kmemleak_not_leak(const void *ptr) __ref;
+extern void kmemleak_ignore(const void *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, unsigned long offset,
-			       size_t length, gfp_t gfp);
-extern void kmemleak_no_scan(const void *ptr);
+			       size_t length, gfp_t gfp) __ref;
+extern void kmemleak_no_scan(const void *ptr) __ref;
 
 static inline void kmemleak_alloc_recursive(const void *ptr, size_t size,
 					    int min_count, unsigned long flags,
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index c665626..8eab0a7 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -232,8 +232,9 @@ struct early_log {
 };
 
 /* early logging buffer and current position */
-static struct early_log early_log[CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE];
-static int crt_early_log;
+static struct early_log
+	early_log[CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE] __initdata;
+static int crt_early_log __initdata;
 
 static void kmemleak_disable(void);
 
@@ -717,8 +718,8 @@ static void object_no_scan(unsigned long ptr)
  * Log an early kmemleak_* call to the early_log buffer. These calls will be
  * processed later once kmemleak is fully initialized.
  */
-static void log_early(int op_type, const void *ptr, size_t size,
-		      int min_count, unsigned long offset, size_t length)
+static void __init log_early(int op_type, const void *ptr, size_t size,
+			     int min_count, unsigned long offset, size_t length)
 {
 	unsigned long flags;
 	struct early_log *log;
@@ -750,7 +751,8 @@ static void log_early(int op_type, const void *ptr, size_t size,
  * kernel allocators when a new block is allocated (kmem_cache_alloc, kmalloc,
  * vmalloc etc.).
  */
-void kmemleak_alloc(const void *ptr, size_t size, int min_count, gfp_t gfp)
+void __ref kmemleak_alloc(const void *ptr, size_t size, int min_count,
+			  gfp_t gfp)
 {
 	pr_debug("%s(0x%p, %zu, %d)\n", __func__, ptr, size, min_count);
 
@@ -765,7 +767,7 @@ EXPORT_SYMBOL_GPL(kmemleak_alloc);
  * Memory freeing function callback. This function is called from the kernel
  * allocators when a block is freed (kmem_cache_free, kfree, vfree etc.).
  */
-void kmemleak_free(const void *ptr)
+void __ref kmemleak_free(const void *ptr)
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
@@ -780,7 +782,7 @@ EXPORT_SYMBOL_GPL(kmemleak_free);
  * Partial memory freeing function callback. This function is usually called
  * from bootmem allocator when (part of) a memory block is freed.
  */
-void kmemleak_free_part(const void *ptr, size_t size)
+void __ref kmemleak_free_part(const void *ptr, size_t size)
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
@@ -795,7 +797,7 @@ EXPORT_SYMBOL_GPL(kmemleak_free_part);
  * Mark an already allocated memory block as a false positive. This will cause
  * the block to no longer be reported as leak and always be scanned.
  */
-void kmemleak_not_leak(const void *ptr)
+void __ref kmemleak_not_leak(const void *ptr)
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
@@ -811,7 +813,7 @@ EXPORT_SYMBOL(kmemleak_not_leak);
  * corresponding block is not a leak and does not contain any references to
  * other allocated memory blocks.
  */
-void kmemleak_ignore(const void *ptr)
+void __ref kmemleak_ignore(const void *ptr)
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
@@ -825,8 +827,8 @@ EXPORT_SYMBOL(kmemleak_ignore);
 /*
  * Limit the range to be scanned in an allocated memory block.
  */
-void kmemleak_scan_area(const void *ptr, unsigned long offset, size_t length,
-			gfp_t gfp)
+void __ref kmemleak_scan_area(const void *ptr, unsigned long offset,
+			      size_t length, gfp_t gfp)
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 
@@ -840,7 +842,7 @@ EXPORT_SYMBOL(kmemleak_scan_area);
 /*
  * Inform kmemleak not to scan the given memory block.
  */
-void kmemleak_no_scan(const void *ptr)
+void __ref kmemleak_no_scan(const void *ptr)
 {
 	pr_debug("%s(0x%p)\n", __func__, ptr);
 

