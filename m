Return-Path: <linux-kernel-owner+w=401wt.eu-S1765212AbZGABCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765212AbZGABCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759368AbZGAAfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:00 -0400
Received: from kroah.org ([198.145.64.141]:60426 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756805AbZGAAe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:30 2009
Message-Id: <20090701002430.625001014@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nicolas Pitre <nico@marvell.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 056/108] ARM: 5545/2: add flush_kernel_dcache_page() for ARM
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=arm-5545-2-add-flush_kernel_dcache_page-for-arm.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nicolas Pitre <nico@cam.org>

commit 73be1591579084a8103a7005dd3172f3e9dd7362 upstream.

Without this, the default implementation is a no op which is completely
wrong with a VIVT cache, and usage of sg_copy_buffer() produces
unpredictable results.

Tested-by: Sebastian Andrzej Siewior <bigeasy@breakpoint.cc>

Signed-off-by: Nicolas Pitre <nico@marvell.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/include/asm/cacheflush.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -429,6 +429,14 @@ static inline void flush_anon_page(struc
 		__flush_anon_page(vma, page, vmaddr);
 }
 
+#define ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
+static inline void flush_kernel_dcache_page(struct page *page)
+{
+	/* highmem pages are always flushed upon kunmap already */
+	if ((cache_is_vivt() || cache_is_vipt_aliasing()) && !PageHighMem(page))
+		__cpuc_flush_dcache_page(page_address(page));
+}
+
 #define flush_dcache_mmap_lock(mapping) \
 	spin_lock_irq(&(mapping)->tree_lock)
 #define flush_dcache_mmap_unlock(mapping) \


