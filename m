Return-Path: <linux-kernel-owner+w=401wt.eu-S1423685AbXEAUgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423685AbXEAUgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423662AbXEAUf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:35:59 -0400
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:40839 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423649AbXEAUfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:35:04 -0400
Message-Id: <20070501203338.870786427@mail.of.borg>
References: <20070501203234.252205858@mail.of.borg>
User-Agent: quilt/0.45-1
Date: Tue, 01 May 2007 22:33:07 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 33/33] Convert non-highmem kmap_atomic() to static inline function
Content-Disposition: inline; filename=kmap_atomic-inline.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert kmap_atomic() in the non-highmem case from a macro to a static
inline function, for better type-checking and the ability to pass void
pointers instead of struct page pointers.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/linux/highmem.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- linux-m68k-2.6.21.orig/include/linux/highmem.h
+++ linux-m68k-2.6.21/include/linux/highmem.h
@@ -42,8 +42,14 @@ static inline void *kmap(struct page *pa
 
 #define kunmap(page) do { (void) (page); } while (0)
 
-#define kmap_atomic(page, idx) \
-	({ pagefault_disable(); page_address(page); })
+#include <asm/kmap_types.h>
+
+static inline void *kmap_atomic(struct page *page, enum km_type idx)
+{
+	pagefault_disable();
+	return page_address(page);
+}
+
 #define kunmap_atomic(addr, idx)	do { pagefault_enable(); } while (0)
 #define kmap_atomic_pfn(pfn, idx)	kmap_atomic(pfn_to_page(pfn), (idx))
 #define kmap_atomic_to_page(ptr)	virt_to_page(ptr)

--
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

