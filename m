Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbXGRGZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbXGRGZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 02:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXGRGZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 02:25:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:54287 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbXGRGZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 02:25:45 -0400
Subject: [PATCH] vmalloc_32 should use GFP_KERNEL
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Dave Airlie <airlied@gmail.com>,
       Andrew Morton <akpm@osdl.org>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 16:25:34 +1000
Message-Id: <1184739934.25235.220.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed lots of failures of vmalloc_32 on machines where it
shouldn't have failed unless it was doing an atomic operation.

Looking closely, I noticed that:

#if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
#define GFP_VMALLOC32 GFP_DMA32
#elif defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA)
#define GFP_VMALLOC32 GFP_DMA
#else
#define GFP_VMALLOC32 GFP_KERNEL
#endif

Which seems to be incorrect, it should always -or- in the DMA flags
on top of GFP_KERNEL, thus this patch.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

This fixes frequent errors launchin X with the nouveau DRM for example.

Index: linux-work/mm/vmalloc.c
===================================================================
--- linux-work.orig/mm/vmalloc.c	2007-07-18 16:22:00.000000000 +1000
+++ linux-work/mm/vmalloc.c	2007-07-18 16:22:11.000000000 +1000
@@ -578,9 +578,9 @@ void *vmalloc_exec(unsigned long size)
 }
 
 #if defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA32)
-#define GFP_VMALLOC32 GFP_DMA32
+#define GFP_VMALLOC32 GFP_DMA32 | GFP_KERNEL
 #elif defined(CONFIG_64BIT) && defined(CONFIG_ZONE_DMA)
-#define GFP_VMALLOC32 GFP_DMA
+#define GFP_VMALLOC32 GFP_DMA | GFP_KERNEL
 #else
 #define GFP_VMALLOC32 GFP_KERNEL
 #endif


