Return-Path: <linux-kernel-owner+w=401wt.eu-S932611AbXLNRvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbXLNRvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 12:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbXLNRvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 12:51:17 -0500
Received: from smtp2e.orange.fr ([80.12.242.113]:10350 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbXLNRvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 12:51:17 -0500
X-ME-UUID: 20071214175113122.1DEEF70000A2@mwinf2e27.orange.fr
Message-ID: <4762C28A.4040002@cosmosbay.com>
Date: Fri, 14 Dec 2007 18:51:06 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] Use ilog2() in fs/namespace.c
Content-Type: multipart/mixed;
 boundary="------------060003020508070904060005"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060003020508070904060005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

We can use ilog2() in fs/namespace.c to compute hash_bits and hash_mask at
compile time, not runtime.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>


--------------060003020508070904060005
Content-Type: text/plain;
 name="namespace.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="namespace.patch"

diff --git a/fs/namespace.c b/fs/namespace.c
index 0608388..835f14a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -25,6 +25,7 @@
 #include <linux/security.h>
 #include <linux/mount.h>
 #include <linux/ramfs.h>
+#include <linux/log2.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -36,7 +37,8 @@ __cacheline_aligned_in_smp DEFINE_SPINLOCK(vfsmount_lock);
 static int event;
 
 static struct list_head *mount_hashtable __read_mostly;
-static int hash_mask __read_mostly, hash_bits __read_mostly;
+#define hash_bits ilog2(PAGE_SIZE / sizeof(struct list_head))
+#define hash_mask ((1UL << hash_bits) - 1)
 static struct kmem_cache *mnt_cache __read_mostly;
 static struct rw_semaphore namespace_sem;
 
@@ -1828,24 +1830,7 @@ void __init mnt_init(void)
 	if (!mount_hashtable)
 		panic("Failed to allocate mount hash table\n");
 
-	/*
-	 * Find the power-of-two list-heads that can fit into the allocation..
-	 * We don't guarantee that "sizeof(struct list_head)" is necessarily
-	 * a power-of-two.
-	 */
-	nr_hash = PAGE_SIZE / sizeof(struct list_head);
-	hash_bits = 0;
-	do {
-		hash_bits++;
-	} while ((nr_hash >> hash_bits) != 0);
-	hash_bits--;
-
-	/*
-	 * Re-calculate the actual number of entries and the mask
-	 * from the number of bits we can fit.
-	 */
 	nr_hash = 1UL << hash_bits;
-	hash_mask = nr_hash - 1;
 
 	printk("Mount-cache hash table entries: %d\n", nr_hash);
 

--------------060003020508070904060005--


