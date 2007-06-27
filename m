Return-Path: <linux-kernel-owner+w=401wt.eu-S1763801AbXF0X5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763801AbXF0X5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 19:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763187AbXF0X5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 19:57:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59410 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761839AbXF0X5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 19:57:11 -0400
Date: Wed, 27 Jun 2007 16:56:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mel@skynet.ie (Mel Gorman)
Cc: alexn@telia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow PAGE_OWNER to be set on any architecture
Message-Id: <20070627165651.1ffb72d7.akpm@linux-foundation.org>
In-Reply-To: <20070608125349.GA8444@skynet.ie>
References: <20070608125349.GA8444@skynet.ie>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 13:53:49 +0100
mel@skynet.ie (Mel Gorman) wrote:

> Currently PAGE_OWNER depends on CONFIG_X86. This appears to be due to
> pfn_to_page() being called in an inappropriate for many memory models
> and the presense of memory holes. This patch ensures that pfn_valid()
> and pfn_valid_within() is called at the appropriate places and the offsets
> correctly updated so that PAGE_OWNER is safe on any architecture.
> 
> In situations where CONFIG_HOLES_IN_ZONES is set (IA64 with VIRTUAL_MEM_MAP),
> there may be cases where pages allocated within a MAX_ORDER_NR_PAGES block
> of pages may not be displayed in /proc/page_owner if the hole is at the
> start of the block. Addressing this would be quite complex, perform slowly
> and is of no clear benefit.
> 
> Once PAGE_OWNER is allowed on all architectures, the statistics for grouping
> pages by mobility that declare how many pageblocks contain mixed page types
> becomes optionally available on all arches.
> 
> This patch was tested successfully on x86, x86_64, ppc64 and IA64 machines.

I'm kinda mystified about how you successfully tested this on ppc64 and
ia64.  They don't assemble and execute i386 opcodes?


--- a/mm/page_alloc.c~allow-page_owner-to-be-set-on-any-architecture-fix
+++ a/mm/page_alloc.c
@@ -1498,13 +1498,15 @@ static inline void __stack_trace(struct 
 #endif
 }
 
-static inline void set_page_owner(struct page *page,
-			unsigned int order, unsigned int gfp_mask)
+static void set_page_owner(struct page *page, unsigned int order,
+			unsigned int gfp_mask)
 {
-	unsigned long address, bp;
+	unsigned long address;
+	unsigned long bp = 0;
 #ifdef CONFIG_X86_64
 	asm ("movq %%rbp, %0" : "=r" (bp) : );
-#else
+#endif
+#ifdef CONFIG_X86_32
 	asm ("movl %%ebp, %0" : "=r" (bp) : );
 #endif
 	page->order = (int) order;
_

that'll make it build, but it won't work...
