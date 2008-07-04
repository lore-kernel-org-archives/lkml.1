Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbYGDGuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbYGDGuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 02:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYGDGur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 02:50:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49026 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbYGDGuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 02:50:46 -0400
Date: Fri, 4 Jul 2008 09:50:44 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, yoichi_yuasa@tripeaks.co.jp, mpm@selenic.com
Subject: [GIT PULL] SLUB fixes for 2.6.26
Message-ID: <Pine.LNX.4.64.0807040950180.14520@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

The tree has just one changeset that fixes SLUB boot-time warnings on MIPS as
reported by Yoichi Yuasa.

                Pekka

Christoph Lameter (1):
      slub: Do not use 192 byte sized cache if minimum alignment is 128 byte

 include/linux/slub_def.h |    2 ++
 mm/slub.c                |   12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 71e43a1..cef6f8f 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -137,10 +137,12 @@ static __always_inline int kmalloc_index(size_t size)
 	if (size <= KMALLOC_MIN_SIZE)
 		return KMALLOC_SHIFT_LOW;
 
+#if KMALLOC_MIN_SIZE <= 64
 	if (size > 64 && size <= 96)
 		return 1;
 	if (size > 128 && size <= 192)
 		return 2;
+#endif
 	if (size <=          8) return 3;
 	if (size <=         16) return 4;
 	if (size <=         32) return 5;
diff --git a/mm/slub.c b/mm/slub.c
index 0987d1c..2c9a62d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2995,8 +2995,6 @@ void __init kmem_cache_init(void)
 		create_kmalloc_cache(&kmalloc_caches[1],
 				"kmalloc-96", 96, GFP_KERNEL);
 		caches++;
-	}
-	if (KMALLOC_MIN_SIZE <= 128) {
 		create_kmalloc_cache(&kmalloc_caches[2],
 				"kmalloc-192", 192, GFP_KERNEL);
 		caches++;
@@ -3026,6 +3024,16 @@ void __init kmem_cache_init(void)
 	for (i = 8; i < KMALLOC_MIN_SIZE; i += 8)
 		size_index[(i - 1) / 8] = KMALLOC_SHIFT_LOW;
 
+	if (KMALLOC_MIN_SIZE == 128) {
+		/*
+		 * The 192 byte sized cache is not used if the alignment
+		 * is 128 byte. Redirect kmalloc to use the 256 byte cache
+		 * instead.
+		 */
+		for (i = 128 + 8; i <= 192; i += 8)
+			size_index[(i - 1) / 8] = 8;
+	}
+
 	slab_state = UP;
 
 	/* Provide the correct kmalloc names now that the caches are up */
