Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbYFXIZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbYFXIZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759159AbYFXIZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:25:23 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:45701 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758996AbYFXIZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:25:20 -0400
Date: Tue, 24 Jun 2008 10:25:17 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: akinobu.mita@gmail.com, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 10/14] arch/um: Eliminate NULL test and memset after
 alloc_bootmem
Message-ID: <Pine.LNX.4.64.0806241024580.26777@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

As noted by Akinobu Mita in patch b1fceac2b9e04d278316b2faddf276015fc06e3b,
alloc_bootmem and related functions never return NULL and always return a
zeroed region of memory.  Thus a NULL test or memset after calls to these
functions is unnecessary.

 arch/um/drivers/net_kern.c |    4 ----
 arch/um/kernel/initrd.c    |    2 --
 arch/um/kernel/physmem.c   |    3 ---
 3 files changed, 9 deletions(-)

This was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E;
statement S;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
... when != E
(
- BUG_ON (E == NULL);
|
- if (E == NULL) S
)

@@
expression E,E1;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
... when != E
- memset(E,0,E1);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -668,10 +668,6 @@ static int __init eth_setup(char *str)
 	}
 
 	new = alloc_bootmem(sizeof(*new));
-	if (new == NULL) {
-		printk(KERN_ERR "eth_init : alloc_bootmem failed\n");
-		return 1;
-	}
 
 	INIT_LIST_HEAD(&new->list);
 	new->index = n;
diff -u -p a/arch/um/kernel/initrd.c b/arch/um/kernel/initrd.c
--- a/arch/um/kernel/initrd.c
+++ b/arch/um/kernel/initrd.c
@@ -37,8 +37,6 @@ static int __init read_initrd(void)
 	}
 
 	area = alloc_bootmem(size);
-	if (area == NULL)
-		return 0;
 
 	if (load_initrd(initrd, area, size) == -1)
 		return 0;
diff -u -p a/arch/um/kernel/physmem.c b/arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c
+++ b/arch/um/kernel/physmem.c
@@ -41,12 +41,9 @@ int __init init_maps(unsigned long physm
 	total_len = phys_len + iomem_len + highmem_len;
 
 	map = alloc_bootmem_low_pages(total_len);
-	if (map == NULL)
-		return -ENOMEM;
 
 	for (i = 0; i < total_pages; i++) {
 		p = &map[i];
-		memset(p, 0, sizeof(struct page));
 		SetPageReserved(p);
 		INIT_LIST_HEAD(&p->lru);
 	}
