Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbZF0Adh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbZF0Adh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 20:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbZF0Ada
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 20:33:30 -0400
Received: from [65.98.92.6] ([65.98.92.6]:2538 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbZF0Ad3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 20:33:29 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: <linux-kernel@vger.kernel.org>
Date: Fri, 26 Jun 2009 17:13:20 -0700
Subject: [PATCH] Fix virt_to_phys() warnings
Message-Id: <910ba280decc9ee53d9971ba04f73fab@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These warnings were observed on MIPS32 using 2.6.31-rc1 and gcc-4.2.0:

mm/page_alloc.c: In function 'alloc_pages_exact':
mm/page_alloc.c:1986: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast

drivers/usb/mon/mon_bin.c: In function 'mon_alloc_buff':
drivers/usb/mon/mon_bin.c:1264: warning: passing argument 1 of 'virt_to_phys' makes pointer from integer without a cast

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index f8d9045..0f7a30b 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1261,7 +1261,7 @@ static int mon_alloc_buff(struct mon_pgmap *map, int npages)
 			return -ENOMEM;
 		}
 		map[n].ptr = (unsigned char *) vaddr;
-		map[n].pg = virt_to_page(vaddr);
+		map[n].pg = virt_to_page((void *) vaddr);
 	}
 	return 0;
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5d714f8..f6180db 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1983,7 +1983,7 @@ void *alloc_pages_exact(size_t size, gfp_t gfp_mask)
 		unsigned long alloc_end = addr + (PAGE_SIZE << order);
 		unsigned long used = addr + PAGE_ALIGN(size);
 
-		split_page(virt_to_page(addr), order);
+		split_page(virt_to_page((void *)addr), order);
 		while (used < alloc_end) {
 			free_page(used);
 			used += PAGE_SIZE;
--
