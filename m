Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbZDBEkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbZDBEkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbZDBEkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:40:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:48667 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbZDBEkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:40:11 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       akinobu.mita@gmail.com
Subject: [PATCH v2] Fix highmem build failure
Date: Wed,  1 Apr 2009 23:38:49 -0500
Message-Id: <1238647129-27417-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit breaks PPC builds with CONFIG_HIGHMEM=y

commit f4112de6b679d84bd9b9681c7504be7bdfb7c7d5
Author: Akinobu Mita <akinobu.mita@gmail.com>
Date:   Tue Mar 31 15:23:25 2009 -0700

    mm: introduce debug_kmap_atomic

We get:

 CC      init/main.o
In file included from include/linux/highmem.h:25,
                 from include/linux/pagemap.h:11,
                 from include/linux/mempolicy.h:63,
                 from init/main.c:53:
linux-2.6/arch/powerpc/include/asm/highmem.h: In function 'kmap_atomic_prot':
linux-2.6/arch/powerpc/include/asm/highmem.h:98: error: implicit declaration of function 'debug_kmap_atomic'
In file included from include/linux/pagemap.h:11,
                 from include/linux/mempolicy.h:63,
                 from init/main.c:53:
include/linux/highmem.h: At top level:
include/linux/highmem.h:196: warning: conflicting types for 'debug_kmap_atomic'
include/linux/highmem.h:196: error: static declaration of 'debug_kmap_atomic' follows non-static declaration
linux-2.6/include/asm/highmem.h:98: error: previous implicit declaration of 'debug_kmap_atomic' was here
make[1]: *** [init/main.o] Error 1
make: *** [init] Error 2

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---

Should address Akinobu issues w/having this build properly on x86

- k

 include/linux/highmem.h |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 7ff5c55..1fcb712 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -19,8 +19,21 @@ static inline void flush_kernel_dcache_page(struct page *page)
 }
 #endif
 
-#ifdef CONFIG_HIGHMEM
+#include <asm/kmap_types.h>
+
+#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
+
+void debug_kmap_atomic(enum km_type type);
+
+#else
 
+static inline void debug_kmap_atomic(enum km_type type)
+{
+}
+
+#endif
+
+#ifdef CONFIG_HIGHMEM
 #include <asm/highmem.h>
 
 /* declarations for linux/mm/highmem.c */
@@ -44,8 +57,6 @@ static inline void *kmap(struct page *page)
 
 #define kunmap(page) do { (void) (page); } while (0)
 
-#include <asm/kmap_types.h>
-
 static inline void *kmap_atomic(struct page *page, enum km_type idx)
 {
 	pagefault_disable();
@@ -187,16 +198,4 @@ static inline void copy_highpage(struct page *to, struct page *from)
 	kunmap_atomic(vto, KM_USER1);
 }
 
-#if defined(CONFIG_DEBUG_HIGHMEM) && defined(CONFIG_TRACE_IRQFLAGS_SUPPORT)
-
-void debug_kmap_atomic(enum km_type type);
-
-#else
-
-static inline void debug_kmap_atomic(enum km_type type)
-{
-}
-
-#endif
-
 #endif /* _LINUX_HIGHMEM_H */
-- 
1.5.6.6

