Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbZGXIWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbZGXIWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 04:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZGXIWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 04:22:34 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:57498 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787AbZGXIWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 04:22:33 -0400
From: Thomas Hellstrom <thellstrom@vmware.com>
To: dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>
Subject: [PATCH] ttm: powerpc: Fix Highmem cache flushing.
Date: Fri, 24 Jul 2009 10:22:36 +0200
Message-Id: <1248423756-1564-1-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Temporarily maps highmem pages while flushing to get a valid virtual
address to flush.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
---
 drivers/gpu/drm/ttm/ttm_tt.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 914a756..44f53a1 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -86,10 +86,16 @@ void ttm_tt_cache_flush(struct page *pages[], unsigned long num_pages)
 	unsigned long i;
 
 	for (i = 0; i < num_pages; ++i) {
-		if (pages[i]) {
-			unsigned long start = (unsigned long)page_address(pages[i]);
-			flush_dcache_range(start, start + PAGE_SIZE);
-		}
+		struct page *page = pages[i];
+		void *page_virtual;
+
+		if (unlikely(page == NULL))
+			continue;
+
+		page_virtual = kmap_atomic(page, KM_USER0);
+		flush_dcache_range((unsigned long) page_virtual,
+				   (unsigned long) page_virtual + PAGE_SIZE);
+		kunmap_atomic(page_virtual, KM_USER0);
 	}
 #else
 	if (on_each_cpu(ttm_tt_ipi_handler, NULL, 1) != 0)
-- 
1.5.4.3

