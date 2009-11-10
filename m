Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbZKJKux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbZKJKux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbZKJKuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:50:50 -0500
Received: from sh.osrg.net ([192.16.179.4]:33824 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607AbZKJKur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:50:47 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, chrisw@sous-sol.org, wmw2@infradead.org,
       joerg.roedel@amd.com, muli@il.ibm.com, fujita.tomonori@lab.ntt.co.jp,
       hannes@cmpxchg.org, akpm@linux-foundation.org, tj@kernel.org
Subject: [PATCH -v2 6/9] bootmem: add free_bootmem_late
Date: Tue, 10 Nov 2009 19:46:17 +0900
Message-Id: <1257849980-22640-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 10 Nov 2009 19:49:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function for freeing bootmem after the bootmem allocator has
been released and the unreserved pages given to the page allocator.
This allows us to reserve bootmem and then release it if we later
discover it was not needed.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hannes@cmpxchg.org
Cc: akpm@linux-foundation.org
Cc: tj@kernel.org
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/bootmem.h |    1 +
 mm/bootmem.c            |   24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index dd97fb8..b10ec49 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -53,6 +53,7 @@ extern void free_bootmem_node(pg_data_t *pgdat,
 			      unsigned long addr,
 			      unsigned long size);
 extern void free_bootmem(unsigned long addr, unsigned long size);
+extern void free_bootmem_late(unsigned long addr, unsigned long size);
 
 /*
  * Flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
diff --git a/mm/bootmem.c b/mm/bootmem.c
index ca92991..30f1702 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -143,6 +143,30 @@ unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
 	return init_bootmem_core(NODE_DATA(0)->bdata, start, 0, pages);
 }
 
+/*
+ * free_bootmem_late - free bootmem pages directly to page allocator
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ *
+ * This is only useful when the bootmem allocator has already been torn
+ * down, but we are still initializing the system.  Pages are given directly
+ * to the page allocator, no bootmem metadata is updated because it is gone.
+ */
+void __init free_bootmem_late(unsigned long addr, unsigned long size)
+{
+	unsigned long cursor, end;
+
+	kmemleak_free_part(__va(addr), size);
+
+	cursor = PFN_UP(addr);
+	end = PFN_DOWN(addr + size);
+
+	for (; cursor < end; cursor++) {
+		__free_pages_bootmem(pfn_to_page(cursor), 0);
+		totalram_pages++;
+	}
+}
+
 static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 {
 	int aligned;
-- 
1.5.6.5

