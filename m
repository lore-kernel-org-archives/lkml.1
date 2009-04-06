Return-Path: <linux-kernel-owner+w=401wt.eu-S1758659AbZDFU5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659AbZDFU5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 16:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbZDFU50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 16:57:26 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:51764 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbZDFU5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 16:57:25 -0400
Date: Mon, 6 Apr 2009 21:56:13 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Yuri Tikhonov <yur@emcraft.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] shmem: respect MAX_LFS_FILESIZE
In-Reply-To: <Pine.LNX.4.64.0904062151250.21044@blonde.anvils>
Message-ID: <Pine.LNX.4.64.0904062155090.21044@blonde.anvils>
References: <Pine.LNX.4.64.0904062151250.21044@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SHMEM_MAX_BYTES was derived from the maximum size of its triple-indirect
swap vector, forgetting to take the MAX_LFS_FILESIZE limit into account.
Never mind 256kB pages, even 8kB pages on 32-bit kernels allowed files
to grow slightly bigger than that supposed maximum.

Fix this by using the min of both (at build time not run time).  And it
happens that this calculation is good as far as 8MB pages on 32-bit or
16MB pages on 64-bit: though SHMSWP_MAX_INDEX gets truncated before that,
it's truncated to such large numbers that we don't need to care.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Question: couldn't the 32-bit kernel's MAX_LFS_FILESIZE be almost doubled?
It limits the pagecache index to a signed long, but we use an unsigned long.

 mm/shmem.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- 2.6.29-git13+/mm/shmem.c	2009-04-06 15:33:09.000000000 +0100
+++ linux/mm/shmem.c	2009-04-06 18:18:47.000000000 +0100
@@ -65,13 +65,28 @@ static struct vfsmount *shm_mnt;
 #include <asm/div64.h>
 #include <asm/pgtable.h>
 
+/*
+ * The maximum size of a shmem/tmpfs file is limited by the maximum size of
+ * its triple-indirect swap vector - see illustration at shmem_swp_entry().
+ *
+ * With 4kB page size, maximum file size is just over 2TB on a 32-bit kernel,
+ * but one eighth of that on a 64-bit kernel.  With 8kB page size, maximum
+ * file size is just over 4TB on a 64-bit kernel, but 16TB on a 32-bit kernel,
+ * MAX_LFS_FILESIZE being then more restrictive than swap vector layout.
+ *
+ * We use / and * instead of shifts in the definitions below, so that the swap
+ * vector can be tested with small even values (e.g. 20) for ENTRIES_PER_PAGE.
+ */
 #define ENTRIES_PER_PAGE (PAGE_CACHE_SIZE/sizeof(unsigned long))
 #define ENTRIES_PER_PAGEPAGE ((unsigned long long)ENTRIES_PER_PAGE*ENTRIES_PER_PAGE)
-#define BLOCKS_PER_PAGE  (PAGE_CACHE_SIZE/512)
 
-#define SHMEM_MAX_INDEX  (SHMEM_NR_DIRECT + (ENTRIES_PER_PAGEPAGE/2) * (ENTRIES_PER_PAGE+1))
-#define SHMEM_MAX_BYTES  ((unsigned long long)SHMEM_MAX_INDEX << PAGE_CACHE_SHIFT)
+#define SHMSWP_MAX_INDEX (SHMEM_NR_DIRECT + (ENTRIES_PER_PAGEPAGE/2) * (ENTRIES_PER_PAGE+1))
+#define SHMSWP_MAX_BYTES (SHMSWP_MAX_INDEX << PAGE_CACHE_SHIFT)
+
+#define SHMEM_MAX_BYTES  min(SHMSWP_MAX_BYTES, (unsigned long long)MAX_LFS_FILESIZE)
+#define SHMEM_MAX_INDEX  ((unsigned long)((SHMEM_MAX_BYTES+1) >> PAGE_CACHE_SHIFT))
 
+#define BLOCKS_PER_PAGE  (PAGE_CACHE_SIZE/512)
 #define VM_ACCT(size)    (PAGE_CACHE_ALIGN(size) >> PAGE_SHIFT)
 
 /* info->flags needs VM_flags to handle pagein/truncate races efficiently */
@@ -2581,7 +2596,7 @@ int shmem_unuse(swp_entry_t entry, struc
 #define shmem_get_inode(sb, mode, dev, flags)	ramfs_get_inode(sb, mode, dev)
 #define shmem_acct_size(flags, size)		0
 #define shmem_unacct_size(flags, size)		do {} while (0)
-#define SHMEM_MAX_BYTES				LLONG_MAX
+#define SHMEM_MAX_BYTES				MAX_LFS_FILESIZE
 
 #endif /* CONFIG_SHMEM */
 
