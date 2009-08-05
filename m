Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbZHEFLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbZHEFLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 01:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbZHEFLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 01:11:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:38960 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbZHEFKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 01:10:14 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org
Cc: galak@kernel.crashing.orga, beckyb@kernel.crashing.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH -v2 7/7] powerpc: add CONFIG_DMA_API_DEBUG support
Date: Wed,  5 Aug 2009 14:08:28 +0900
Message-Id: <1249448908-18985-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 05 Aug 2009 14:09:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/powerpc/Kconfig                   |    1 +
 arch/powerpc/include/asm/dma-mapping.h |   11 ++++++++++-
 arch/powerpc/kernel/dma.c              |   11 +++++++++++
 3 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index fb3f4ff..4459b78 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -121,6 +121,7 @@ config PPC
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_LMB
 	select HAVE_DMA_ATTRS
+	select HAVE_DMA_API_DEBUG
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_OPROFILE
 	select HAVE_SYSCALL_WRAPPERS if PPC64
diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index 4bd41b4..cb2ca41 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -127,9 +127,15 @@ static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag)
 {
 	struct dma_map_ops *dma_ops = get_dma_ops(dev);
+	void *cpu_addr;
 
 	BUG_ON(!dma_ops);
-	return dma_ops->alloc_coherent(dev, size, dma_handle, flag);
+
+	cpu_addr = dma_ops->alloc_coherent(dev, size, dma_handle, flag);
+
+	debug_dma_alloc_coherent(dev, size, *dma_handle, cpu_addr);
+
+	return cpu_addr;
 }
 
 static inline void dma_free_coherent(struct device *dev, size_t size,
@@ -138,6 +144,9 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
 	BUG_ON(!dma_ops);
+
+	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
+
 	dma_ops->free_coherent(dev, size, cpu_addr, dma_handle);
 }
 
diff --git a/arch/powerpc/kernel/dma.c b/arch/powerpc/kernel/dma.c
index 3e8bb9a..c6d730e 100644
--- a/arch/powerpc/kernel/dma.c
+++ b/arch/powerpc/kernel/dma.c
@@ -7,6 +7,7 @@
 
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
+#include <linux/dma-debug.h>
 #include <asm/bug.h>
 #include <asm/abs_addr.h>
 
@@ -156,3 +157,13 @@ struct dma_map_ops dma_direct_ops = {
 #endif
 };
 EXPORT_SYMBOL(dma_direct_ops);
+
+#define PREALLOC_DMA_DEBUG_ENTRIES (1 << 16)
+
+static int __init dma_init(void)
+{
+       dma_debug_init(PREALLOC_DMA_DEBUG_ENTRIES);
+
+       return 0;
+}
+fs_initcall(dma_init);
-- 
1.6.0.6

