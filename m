Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbZDFU4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbZDFU4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 16:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZDFU4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 16:56:19 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45668 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbZDFU4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 16:56:18 -0400
Date: Mon, 6 Apr 2009 21:54:54 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Yuri Tikhonov <yur@emcraft.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] shmem: fix division by zero
Message-ID: <Pine.LNX.4.64.0904062151250.21044@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuri Tikhonov <yur@emcraft.com>

Fix a division by zero which we have in shmem_truncate_range() and
shmem_unuse_inode() when using big PAGE_SIZE values (e.g. 256kB on ppc44x).

With 256kB PAGE_SIZE, the ENTRIES_PER_PAGEPAGE constant becomes too large
(0x1.0000.0000) on a 32-bit kernel, so this patch just changes its type
from 'unsigned long' to 'unsigned long long'.

Hugh: reverted its unsigned long longs in shmem_truncate_range() and
shmem_getpage(): the pagecache index cannot be more than an unsigned long,
so the divisions by zero occurred in unreached code.  It's a pity we need
any ULL arithmetic here, but I found no pretty way to avoid it.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.29-git13/mm/shmem.c	2009-04-06 11:48:55.000000000 +0100
+++ 2.6.29-git13+/mm/shmem.c	2009-04-06 15:33:09.000000000 +0100
@@ -66,7 +66,7 @@ static struct vfsmount *shm_mnt;
 #include <asm/pgtable.h>
 
 #define ENTRIES_PER_PAGE (PAGE_CACHE_SIZE/sizeof(unsigned long))
-#define ENTRIES_PER_PAGEPAGE (ENTRIES_PER_PAGE*ENTRIES_PER_PAGE)
+#define ENTRIES_PER_PAGEPAGE ((unsigned long long)ENTRIES_PER_PAGE*ENTRIES_PER_PAGE)
 #define BLOCKS_PER_PAGE  (PAGE_CACHE_SIZE/512)
 
 #define SHMEM_MAX_INDEX  (SHMEM_NR_DIRECT + (ENTRIES_PER_PAGEPAGE/2) * (ENTRIES_PER_PAGE+1))
