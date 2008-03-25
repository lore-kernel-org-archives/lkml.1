Return-Path: <linux-kernel-owner+w=401wt.eu-S1761766AbYCYVlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761766AbYCYVlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760683AbYCYVim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:38:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760668AbYCYVil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:38:41 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: [PATCH 12/20] x86: move alloc and free coherent to common header
Date: Tue, 25 Mar 2008 18:36:31 -0300
Message-Id: <1206480999-21767-13-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206480999-21767-12-git-send-email-gcosta@redhat.com>
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com>
 <1206480999-21767-2-git-send-email-gcosta@redhat.com>
 <1206480999-21767-3-git-send-email-gcosta@redhat.com>
 <1206480999-21767-4-git-send-email-gcosta@redhat.com>
 <1206480999-21767-5-git-send-email-gcosta@redhat.com>
 <1206480999-21767-6-git-send-email-gcosta@redhat.com>
 <1206480999-21767-7-git-send-email-gcosta@redhat.com>
 <1206480999-21767-8-git-send-email-gcosta@redhat.com>
 <1206480999-21767-9-git-send-email-gcosta@redhat.com>
 <1206480999-21767-10-git-send-email-gcosta@redhat.com>
 <1206480999-21767-11-git-send-email-gcosta@redhat.com>
 <1206480999-21767-12-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

they are the same between architectures (except for the fact
that x86_64 has duplicate code)

move them to dma-mapping.h

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/dma-mapping.h    |   10 ++++++++++
 include/asm-x86/dma-mapping_32.h |    9 ---------
 include/asm-x86/dma-mapping_64.h |   11 -----------
 3 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 53a404b..3ea3802 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -52,6 +52,16 @@ struct dma_mapping_ops {
 
 extern const struct dma_mapping_ops *dma_ops;
 
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
+void *dma_alloc_coherent(struct device *dev, size_t size,
+			   dma_addr_t *dma_handle, gfp_t flag);
+
+void dma_free_coherent(struct device *dev, size_t size,
+			 void *vaddr, dma_addr_t dma_handle);
+
+
 #ifdef CONFIG_X86_32
 # include "dma-mapping_32.h"
 #else
diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
index eff42f4..d8f6420 100644
--- a/include/asm-x86/dma-mapping_32.h
+++ b/include/asm-x86/dma-mapping_32.h
@@ -8,15 +8,6 @@
 #include <asm/io.h>
 #include <asm/bug.h>
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
-void *dma_alloc_coherent(struct device *dev, size_t size,
-			   dma_addr_t *dma_handle, gfp_t flag);
-
-void dma_free_coherent(struct device *dev, size_t size,
-			 void *vaddr, dma_addr_t dma_handle);
-
 static inline dma_addr_t
 dma_map_page(struct device *dev, struct page *page, unsigned long offset,
 	     size_t size, enum dma_data_direction direction)
diff --git a/include/asm-x86/dma-mapping_64.h b/include/asm-x86/dma-mapping_64.h
index 707dbbe..ce881d9 100644
--- a/include/asm-x86/dma-mapping_64.h
+++ b/include/asm-x86/dma-mapping_64.h
@@ -12,17 +12,6 @@ static inline int dma_mapping_error(dma_addr_t dma_addr)
 	return (dma_addr == bad_dma_address);
 }
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
-extern void *dma_alloc_coherent(struct device *dev, size_t size,
-				dma_addr_t *dma_handle, gfp_t gfp);
-extern void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
-			      dma_addr_t dma_handle);
-
 #define dma_map_page(dev,page,offset,size,dir) \
 	dma_map_single((dev), page_address(page)+(offset), (size), (dir))
 
-- 
1.5.0.6

