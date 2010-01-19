Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996Ab0ASO61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0ASO61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153Ab0ASO60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:58:26 -0500
Received: from f0.cmpxchg.org ([85.214.51.133]:54412 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab0ASO60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:58:26 -0500
X-Greylist: delayed 1456 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jan 2010 09:58:25 EST
Date: Tue, 19 Jan 2010 15:33:55 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Ralf Baechle <ralf@linux-mips.org>, x86@kernel.org
Subject: Re: [RFC 1/1] bootmem: move big allocations behing 4G
Message-ID: <20100119143355.GB7932@cmpxchg.org>
References: <1263855390-32497-1-git-send-email-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263855390-32497-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jiri,

On Mon, Jan 18, 2010 at 11:56:30PM +0100, Jiri Slaby wrote:
> Hi, I'm fighting a bug where Grub loads the kernel just fine, whereas
> isolinux doesn't. I found out, it's due to different addresses of
> loaded initrd. On a machine with 128G of memory, grub loads the
> initrd at 895M in our case and flat mem_map (2G long) is allocated
> above 4G due to 2-4G BIOS reservation.
> 
> On the other hand, with isolinux, the 0-2G is free and mem_map is
> placed there leaving no space for others, hence kernel panics for
> swiotlb which needs to be below 4G.

Bootmem already protects the lower 16MB DMA zone for the obvious reasons,
how about shifting the default bootmem goal above the DMA32 zone if it exists?

I added Ralf and the x86 Team on Cc as this only affects x86 and mips, afaics.

> Any ideas?

I tested the below on a rather dull x86_64 machine and it seems to work.  Would
this work in your case as well?  The goal for mem_map should now be above 4G.

	Hannes

>From 1c11ce1e82c6209f0eda72e3340ab0c55cd6f330 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <jw@emlix.com>
Date: Tue, 19 Jan 2010 14:14:44 +0100
Subject: [patch] bootmem: avoid DMA32 zone, if any, by default

x86_64 and mips define a DMA32 zone additionally to the old DMA
zone of 16MB.  Bootmem already avoids the old DMA zone if the
allocation site did not request otherwise.

But since DMA32 is also a limited resource, avoid using it as well
by default, if defined.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/bootmem.h |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index b10ec49..f21ac4b 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -96,20 +96,26 @@ extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
 				      unsigned long align,
 				      unsigned long goal);
 
+#ifdef MAX_DMA32_PFN
+#define BOOTMEM_DEFAULT_GOAL	(__pa(MAX_DMA32_PFN << PAGE_SHIFT))
+#else
+#define BOOTMEM_DEFAULT_GOAL	MAX_DMA_ADDRESS
+#endif
+
 #define alloc_bootmem(x) \
-	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem(x, SMP_CACHE_BYTES, BOOTMEM_DEFAULT_GOAL)
 #define alloc_bootmem_nopanic(x) \
-	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, BOOTMEM_DEFAULT_GOAL)
 #define alloc_bootmem_pages(x) \
-	__alloc_bootmem(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem(x, PAGE_SIZE, BOOTMEM_DEFAULT_GOAL)
 #define alloc_bootmem_pages_nopanic(x) \
-	__alloc_bootmem_nopanic(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_nopanic(x, PAGE_SIZE, BOOTMEM_DEFAULT_GOAL)
 #define alloc_bootmem_node(pgdat, x) \
-	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, BOOTMEM_DEFAULT_GOAL)
 #define alloc_bootmem_pages_node(pgdat, x) \
-	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, BOOTMEM_DEFAULT_GOAL)
 #define alloc_bootmem_pages_node_nopanic(pgdat, x) \
-	__alloc_bootmem_node_nopanic(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+	__alloc_bootmem_node_nopanic(pgdat, x, PAGE_SIZE, BOOTMEM_DEFAULT_GOAL)
 
 #define alloc_bootmem_low(x) \
 	__alloc_bootmem_low(x, SMP_CACHE_BYTES, 0)
-- 
1.6.5.4

