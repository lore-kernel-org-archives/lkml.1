Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbYCCMwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbYCCMwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbYCCMwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:52:09 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35106 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbYCCMwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:52:07 -0500
Date: Mon, 3 Mar 2008 14:52:05 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, clameter@sgi.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] mm: move cache_line_size() to <linux/cache.h>
Message-ID: <Pine.LNX.4.64.0803031450330.27319@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Not all architectures define cache_line_size() so as suggested by Andrew move
the private implementations in mm/slab.c and mm/slob.c to <linux/cache.h>.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/Kconfig      |    3 +++
 include/linux/cache.h |    4 ++++
 mm/slab.c             |    4 ----
 mm/slub.c             |    5 -----
 4 files changed, 7 insertions(+), 9 deletions(-)

Index: linux-2.6/include/linux/cache.h
===================================================================
--- linux-2.6.orig/include/linux/cache.h
+++ linux-2.6/include/linux/cache.h
@@ -60,4 +60,8 @@
 #endif
 #endif
 
+#ifndef CONFIG_ARCH_HAS_CACHE_LINE_SIZE
+#define cache_line_size()	L1_CACHE_BYTES
+#endif
+
 #endif /* __LINUX_CACHE_H */
Index: linux-2.6/mm/slab.c
===================================================================
--- linux-2.6.orig/mm/slab.c
+++ linux-2.6/mm/slab.c
@@ -139,10 +139,6 @@
 #define	BYTES_PER_WORD		sizeof(void *)
 #define	REDZONE_ALIGN		max(BYTES_PER_WORD, __alignof__(unsigned long long))
 
-#ifndef cache_line_size
-#define cache_line_size()	L1_CACHE_BYTES
-#endif
-
 #ifndef ARCH_KMALLOC_MINALIGN
 /*
  * Enforce a minimum alignment for the kmalloc caches.
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c
+++ linux-2.6/mm/slub.c
@@ -207,11 +207,6 @@ static inline void ClearSlabDebug(struct
 #define __KMALLOC_CACHE		0x20000000 /* objects freed using kfree */
 #define __PAGE_ALLOC_FALLBACK	0x10000000 /* Allow fallback to page alloc */
 
-/* Not all arches define cache_line_size */
-#ifndef cache_line_size
-#define cache_line_size()	L1_CACHE_BYTES
-#endif
-
 static int kmem_size = sizeof(struct kmem_cache);
 
 #ifdef CONFIG_SMP
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -118,6 +118,9 @@ config GENERIC_TIME_VSYSCALL
 config ARCH_HAS_CPU_RELAX
 	def_bool y
 
+config ARCH_HAS_CACHE_LINE_SIZE
+	def_bool y
+
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool X86_64
 
