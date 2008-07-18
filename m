Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYGRJaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYGRJaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756456AbYGRJa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:30:28 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:57414 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161AbYGRJa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:30:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=CyfzDRvfIx1LXxckOytW7hAXbnkX5eWy5A0+yzXnJC+lW3ahteR3Efxv9a9UkEQcoM
         fFfdbdlYiZlh1sdxdSoFLbtNpf/mALJvro6xp83LO8mWGLf+3C5Gr7kaNBHp21Ki2CMG
         fRI/GEG0IM+ixk3UK1qoxyseE/M08BTJSMff4=
Date: Fri, 18 Jul 2008 13:30:14 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/3] ARM: support generic per-device coherent dma mem
References: <f19d3499bb927f743672952b035895441e6bcafd.1216373338.git.dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f19d3499bb927f743672952b035895441e6bcafd.1216373338.git.dbaryshkov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Message-ID: <488062b1.28054e0a.4418.fffffb3d@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
---
 arch/arm/Kconfig              |    1 +
 arch/arm/mm/consistent.c      |    8 ++++++++
 include/asm-arm/dma-mapping.h |    2 ++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b786e68..828e09d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -14,6 +14,7 @@ config ARM
 	select HAVE_OPROFILE
 	select HAVE_KPROBES if (!XIP_KERNEL)
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
+	select HAVE_GENERIC_DMA_COHERENT
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/arm/mm/consistent.c b/arch/arm/mm/consistent.c
index 333a82a..db7b3e3 100644
--- a/arch/arm/mm/consistent.c
+++ b/arch/arm/mm/consistent.c
@@ -274,6 +274,11 @@ __dma_alloc(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp,
 void *
 dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp)
 {
+	void *memory;
+
+	if (dma_alloc_from_coherent(dev, size, handle, &memory))
+		return memory;
+
 	if (arch_is_coherent()) {
 		void *virt;
 
@@ -362,6 +367,9 @@ void dma_free_coherent(struct device *dev, size_t size, void *cpu_addr, dma_addr
 
 	WARN_ON(irqs_disabled());
 
+	if (dma_release_from_coherent(dev, get_order(size), cpu_addr))
+		return;
+
 	if (arch_is_coherent()) {
 		kfree(cpu_addr);
 		return;
diff --git a/include/asm-arm/dma-mapping.h b/include/asm-arm/dma-mapping.h
index e99406a..943f23b 100644
--- a/include/asm-arm/dma-mapping.h
+++ b/include/asm-arm/dma-mapping.h
@@ -7,6 +7,8 @@
 
 #include <linux/scatterlist.h>
 
+#include <asm-generic/dma-coherent.h>
+
 /*
  * DMA-consistent mapping functions.  These allocate/free a region of
  * uncached, unwrite-buffered mapped memory space for use with DMA
-- 
1.5.6.2


-- 
With best wishes
Dmitry

