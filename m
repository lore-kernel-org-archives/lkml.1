Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbZHRPzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbZHRPzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 11:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759123AbZHRPzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 11:55:22 -0400
Received: from [195.33.99.132] ([195.33.99.132]:46960 "EHLO vpn.id2.novell.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759033AbZHRPzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 11:55:21 -0400
Message-Id: <4A8AEB0B0200007800010570@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 18 Aug 2009 16:55:23 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] also use alloc_large_system_hash() for the PID hash
	 table
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is being done by allowing boot time allocations to specify that
they may want a sub-page sized amount of memory.

Overall this seems more consistent with the other hash table
allocations, and allows making two supposedly mm-only variables really
mm-only (nr_{kernel,all}_pages).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 include/linux/bootmem.h |    5 ++---
 kernel/pid.c            |   15 ++++-----------
 mm/page_alloc.c         |   13 ++++++++++---
 3 files changed, 16 insertions(+), 17 deletions(-)

--- linux-2.6.31-rc6/include/linux/bootmem.h	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.31-rc6-alloc-small-hash/include/linux/bootmem.h	2009-08-17 15:21:17.000000000 +0200
@@ -132,9 +132,6 @@ static inline void *alloc_remap(int nid,
 }
 #endif /* CONFIG_HAVE_ARCH_ALLOC_REMAP */
 
-extern unsigned long __meminitdata nr_kernel_pages;
-extern unsigned long __meminitdata nr_all_pages;
-
 extern void *alloc_large_system_hash(const char *tablename,
 				     unsigned long bucketsize,
 				     unsigned long numentries,
@@ -145,6 +142,8 @@ extern void *alloc_large_system_hash(con
 				     unsigned long limit);
 
 #define HASH_EARLY	0x00000001	/* Allocating during early boot? */
+#define HASH_SMALL	0x00000002	/* sub-page allocation allowed, min
+					 * shift passed via *_hash_shift */
 
 /* Only NUMA needs hash distribution. 64bit NUMA architectures have
  * sufficient vmalloc space.
--- linux-2.6.31-rc6/kernel/pid.c	2009-08-18 15:31:56.000000000 +0200
+++ 2.6.31-rc6-alloc-small-hash/kernel/pid.c	2009-08-17 15:21:17.000000000 +0200
@@ -40,7 +40,7 @@
 #define pid_hashfn(nr, ns)	\
 	hash_long((unsigned long)nr + (unsigned long)ns, pidhash_shift)
 static struct hlist_head *pid_hash;
-static int pidhash_shift;
+static unsigned int pidhash_shift = 4;
 struct pid init_struct_pid = INIT_STRUCT_PID;
 
 int pid_max = PID_MAX_DEFAULT;
@@ -499,19 +499,12 @@ struct pid *find_ge_pid(int nr, struct p
 void __init pidhash_init(void)
 {
 	int i, pidhash_size;
-	unsigned long megabytes = nr_kernel_pages >> (20 - PAGE_SHIFT);
 
-	pidhash_shift = max(4, fls(megabytes * 4));
-	pidhash_shift = min(12, pidhash_shift);
+	pid_hash = alloc_large_system_hash("PID", sizeof(*pid_hash), 0, 18,
+					   HASH_EARLY | HASH_SMALL,
+					   &pidhash_shift, NULL, 4096);
 	pidhash_size = 1 << pidhash_shift;
 
-	printk("PID hash table entries: %d (order: %d, %Zd bytes)\n",
-		pidhash_size, pidhash_shift,
-		pidhash_size * sizeof(struct hlist_head));
-
-	pid_hash = alloc_bootmem(pidhash_size *	sizeof(*(pid_hash)));
-	if (!pid_hash)
-		panic("Could not alloc pidhash!\n");
 	for (i = 0; i < pidhash_size; i++)
 		INIT_HLIST_HEAD(&pid_hash[i]);
 }
--- linux-2.6.31-rc6/mm/page_alloc.c	2009-08-18 15:31:56.000000000 +0200
+++ 2.6.31-rc6-alloc-small-hash/mm/page_alloc.c	2009-08-17 15:21:17.000000000 +0200
@@ -123,8 +123,8 @@ static char * const zone_names[MAX_NR_ZO
 
 int min_free_kbytes = 1024;
 
-unsigned long __meminitdata nr_kernel_pages;
-unsigned long __meminitdata nr_all_pages;
+static unsigned long __meminitdata nr_kernel_pages;
+static unsigned long __meminitdata nr_all_pages;
 static unsigned long __meminitdata dma_reserve;
 
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
@@ -4728,7 +4728,14 @@ void *__init alloc_large_system_hash(con
 			numentries <<= (PAGE_SHIFT - scale);
 
 		/* Make sure we've got at least a 0-order allocation.. */
-		if (unlikely((numentries * bucketsize) < PAGE_SIZE))
+		if (unlikely(flags & HASH_SMALL)) {
+			/* Makes no sense without HASH_EARLY */
+			WARN_ON(!(flags & HASH_EARLY));
+			if (!(numentries >> *_hash_shift)) {
+				numentries = 1UL << *_hash_shift;
+				BUG_ON(!numentries);
+			}
+		} else if (unlikely((numentries * bucketsize) < PAGE_SIZE))
 			numentries = PAGE_SIZE / bucketsize;
 	}
 	numentries = roundup_pow_of_two(numentries);



