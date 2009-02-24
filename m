Return-Path: <linux-kernel-owner+w=401wt.eu-S1757696AbZBXDOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbZBXDOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 22:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757478AbZBXDNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 22:13:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:58450 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737AbZBXDNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 22:13:04 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH 03/10] bootmem: reorder interface functions and add a missing one
Date: Tue, 24 Feb 2009 12:11:34 +0900
Message-Id: <1235445101-7882-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1235445101-7882-1-git-send-email-tj@kernel.org>
References: <1235445101-7882-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 03:11:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup and addition of missing interface wrapper

The interface functions in bootmem.h was ordered in not so orderly
manner.  Reorder them such that

* functions allocating the same area group together -
  ie. alloc_bootmem group and alloc_bootmem_low group.

* functions w/o node parameter come before the ones w/ node parameter.

* nopanic variants are immediately below their panicky counterparts.

While at it, add alloc_bootmem_pages_node_nopanic() which was missing.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@saeurebad.de>
---
 include/linux/bootmem.h |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index 3a87f93..455d832 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -65,22 +65,20 @@ extern void free_bootmem(unsigned long addr, unsigned long size);
 #define BOOTMEM_DEFAULT		0
 #define BOOTMEM_EXCLUSIVE	(1<<0)
 
-extern int reserve_bootmem_node(pg_data_t *pgdat,
-				 unsigned long physaddr,
-				 unsigned long size,
-				 int flags);
 extern int reserve_bootmem(unsigned long addr,
 			   unsigned long size,
 			   int flags);
-extern void *__alloc_bootmem_nopanic(unsigned long size,
+extern int reserve_bootmem_node(pg_data_t *pgdat,
+				unsigned long physaddr,
+				unsigned long size,
+				int flags);
+
+extern void *__alloc_bootmem(unsigned long size,
 			     unsigned long align,
 			     unsigned long goal);
-extern void *__alloc_bootmem(unsigned long size,
+extern void *__alloc_bootmem_nopanic(unsigned long size,
 				     unsigned long align,
 				     unsigned long goal);
-extern void *__alloc_bootmem_low(unsigned long size,
-				 unsigned long align,
-				 unsigned long goal);
 extern void *__alloc_bootmem_node(pg_data_t *pgdat,
 				  unsigned long size,
 				  unsigned long align,
@@ -89,6 +87,9 @@ extern void *__alloc_bootmem_node_nopanic(pg_data_t *pgdat,
 				  unsigned long size,
 				  unsigned long align,
 				  unsigned long goal);
+extern void *__alloc_bootmem_low(unsigned long size,
+				 unsigned long align,
+				 unsigned long goal);
 extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
 				      unsigned long size,
 				      unsigned long align,
@@ -98,18 +99,21 @@ extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
 	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_nopanic(x) \
 	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
-#define alloc_bootmem_low(x) \
-	__alloc_bootmem_low(x, SMP_CACHE_BYTES, 0)
 #define alloc_bootmem_pages(x) \
 	__alloc_bootmem(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages_nopanic(x) \
 	__alloc_bootmem_nopanic(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
-#define alloc_bootmem_low_pages(x) \
-	__alloc_bootmem_low(x, PAGE_SIZE, 0)
 #define alloc_bootmem_node(pgdat, x) \
 	__alloc_bootmem_node(pgdat, x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_pages_node(pgdat, x) \
 	__alloc_bootmem_node(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_pages_node_nopanic(pgdat, x) \
+	__alloc_bootmem_node_nopanic(pgdat, x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+
+#define alloc_bootmem_low(x) \
+	__alloc_bootmem_low(x, SMP_CACHE_BYTES, 0)
+#define alloc_bootmem_low_pages(x) \
+	__alloc_bootmem_low(x, PAGE_SIZE, 0)
 #define alloc_bootmem_low_pages_node(pgdat, x) \
 	__alloc_bootmem_low_node(pgdat, x, PAGE_SIZE, 0)
 
-- 
1.6.0.2

