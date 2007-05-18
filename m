Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbXERJzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbXERJzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbXERJy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:54:58 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:47609 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbXERJy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:54:58 -0400
Date: Fri, 18 May 2007 11:54:54 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: [PATCH] MM : alloc_large_system_hash() can free some memory for non
 power-of-two bucketsize
Message-Id: <20070518115454.d3e32f4d.dada1@cosmosbay.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_large_system_hash() is called at boot time to allocate space for several large hash tables.

Lately, TCP hash table was changed and its bucketsize is not a power-of-two anymore.

On most setups, alloc_large_system_hash() allocates one big page (order > 0) with __get_free_pages(GFP_ATOMIC, order). This single high_order page has a power-of-two size, bigger than the needed size.

We can free all pages that wont be used by the hash table.

On a 1GB i386 machine, this patch saves 128 KB of LOWMEM memory.

TCP established hash table entries: 32768 (order: 6, 393216 bytes)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ae96dd8..2e0ba08 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3350,6 +3350,20 @@ void *__init alloc_large_system_hash(const char *tablename,
 			for (order = 0; ((1UL << order) << PAGE_SHIFT) < size; order++)
 				;
 			table = (void*) __get_free_pages(GFP_ATOMIC, order);
+			/*
+			 * If bucketsize is not a power-of-two, we may free
+			 * some pages at the end of hash table.
+			 */
+			if (table) {
+				unsigned long alloc_end = (unsigned long)table +
+						(PAGE_SIZE << order);
+				unsigned long used = (unsigned long)table +
+						PAGE_ALIGN(size);
+				while (used < alloc_end) {
+					free_page(used);
+					used += PAGE_SIZE;
+				}
+			}
 		}
 	} while (!table && size > PAGE_SIZE && --log2qty);
 
