Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYHDNfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYHDNfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYHDNfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:35:04 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:19069 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYHDNfD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:35:03 -0400
Message-Id: <489721D1.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 04 Aug 2008 14:35:45 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: <dhowells@redhat.com>
Subject: [PATCH] use no-panic variant of alloc_bootmem() in
	alloc_large_system_hash()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. since a failed allocation is being (initially) handled gracefully,
and panic()-ed upon failure explicitly in the function if retries with
smaller sizes failed.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: David Howells <dhowells@redhat.com>

---
 include/linux/bootmem.h |    4 ++++
 mm/page_alloc.c         |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- linux-2.6.27-rc1/include/linux/bootmem.h	2008-07-31 17:08:35.000000000 +0200
+++ 2.6.27-rc1-alloc-large-system-hash/include/linux/bootmem.h	2008-07-31 17:56:18.000000000 +0200
@@ -97,10 +97,14 @@ extern void *__alloc_bootmem_low_node(pg
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
 #define alloc_bootmem(x) \
 	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_nopanic(x) \
+	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low(x) \
 	__alloc_bootmem_low(x, SMP_CACHE_BYTES, 0)
 #define alloc_bootmem_pages(x) \
 	__alloc_bootmem(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
+#define alloc_bootmem_pages_nopanic(x) \
+	__alloc_bootmem_nopanic(x, PAGE_SIZE, __pa(MAX_DMA_ADDRESS))
 #define alloc_bootmem_low_pages(x) \
 	__alloc_bootmem_low(x, PAGE_SIZE, 0)
 #define alloc_bootmem_node(pgdat, x) \
--- linux-2.6.27-rc1/mm/page_alloc.c	2008-07-31 17:08:36.000000000 +0200
+++ 2.6.27-rc1-alloc-large-system-hash/mm/page_alloc.c	2008-07-31 17:56:37.000000000 +0200
@@ -4454,7 +4454,7 @@ void *__init alloc_large_system_hash(con
 	do {
 		size = bucketsize << log2qty;
 		if (flags & HASH_EARLY)
-			table = alloc_bootmem(size);
+			table = alloc_bootmem_nopanic(size);
 		else if (hashdist)
 			table = __vmalloc(size, GFP_ATOMIC, PAGE_KERNEL);
 		else {



