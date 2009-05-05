Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbZEEV2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbZEEV2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 17:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbZEEV17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 17:27:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55312 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbZEEV17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 17:27:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/3] NOMMU: Clamp zone_batchsize() to 0 under NOMMU conditions
To: torvalds@osdl.org, akpm@linux-foundation.org, npiggin@suse.de
Cc: gerg@snapgear.com, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Tue, 05 May 2009 22:26:43 +0100
Message-ID: <20090505212643.17034.80569.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090505212638.17034.10989.stgit@warthog.procyon.org.uk>
References: <20090505212638.17034.10989.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clamp zone_batchsize() to 0 under NOMMU conditions to stop free_hot_cold_page()
from queueing and batching frees.

The problem is that under NOMMU conditions it is really important to be able to
allocate large contiguous chunks of memory, but when munmap() or exit_mmap()
releases big stretches of memory, return of these to the buddy allocator can be
deferred, and when it does finally happen, it can be in small chunks.

Whilst the fragmentation this incurs isn't so much of a problem under MMU
conditions as userspace VM is glued together from individual pages with the aid
of the MMU, it is a real problem if there isn't an MMU.

By clamping the page freeing queue size to 0, pages are returned to the
allocator immediately, and the buddy detector is more likely to be able to glue
them together into large chunks immediately, and fragmentation is less likely
to occur.

By disabling batching of frees, and by turning off the trimming of excess space
during boot, Coldfire can manage to boot.

Reported-by: Lanttor Guo <lanttor.guo@freescale.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Lanttor Guo <lanttor.guo@freescale.com>
---

 mm/page_alloc.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)


diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8add7da..fe753ec 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2681,6 +2681,7 @@ static void __meminit zone_init_free_lists(struct zone *zone)
 
 static int zone_batchsize(struct zone *zone)
 {
+#ifdef CONFIG_MMU
 	int batch;
 
 	/*
@@ -2709,6 +2710,23 @@ static int zone_batchsize(struct zone *zone)
 	batch = rounddown_pow_of_two(batch + batch/2) - 1;
 
 	return batch;
+
+#else
+	/* The deferral and batching of frees should be suppressed under NOMMU
+	 * conditions.
+	 *
+	 * The problem is that NOMMU needs to be able to allocate large chunks
+	 * of contiguous memory as there's no hardware page translation to
+	 * assemble apparent contiguous memory from discontiguous pages.
+	 *
+	 * Queueing large contiguous runs of pages for batching, however,
+	 * causes the pages to actually be freed in smaller chunks.  As there
+	 * can be a significant delay between the individual batches being
+	 * recycled, this leads to the once large chunks of space being
+	 * fragmented and becoming unavailable for high-order allocations.
+	 */
+	return 0;
+#endif
 }
 
 static void setup_pageset(struct per_cpu_pageset *p, unsigned long batch)

