Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbXJVCrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbXJVCrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 22:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXJVCrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 22:47:01 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47829 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751396AbXJVCrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 22:47:01 -0400
Date: Mon, 22 Oct 2007 04:47:30 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ralf Baechle <ralf@linux-mips.org>, lethal@linux-sh.org
Cc: linuxsh-shmedia-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sh64: fix dma_cache_sync() compilation
Message-ID: <20071022024730.GH30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error caused by
commit 622a9edd919de98ef59571ae6c40c7458244e3f2:

<--  snip  -->

...
  CC      init/main.o
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/dma-mapping.h:52,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/dmaengine.h:29,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/skbuff.h:29,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/netlink.h:155,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/genetlink.h:4,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/net/genetlink.h:4,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/taskstats_kern.h:12,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/init/main.c:46:
include2/asm/dma-mapping.h: In function 'dma_cache_sync':
include2/asm/dma-mapping.h:46: error: invalid operands to binary & (have 'void *' and 'int')
make[2]: *** [init/main.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
e4e74353f092fa502d4c7e9c3c16a0d7a3bcf85e 
diff --git a/include/asm-sh64/dma-mapping.h b/include/asm-sh64/dma-mapping.h
index e661857..e57f129 100644
--- a/include/asm-sh64/dma-mapping.h
+++ b/include/asm-sh64/dma-mapping.h
@@ -42,8 +42,9 @@ static inline void dma_free_coherent(struct device *dev, size_t size,
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 				  enum dma_data_direction dir)
 {
-	unsigned long s = (unsigned long) vaddr & L1_CACHE_ALIGN_MASK;
-	unsigned long e = (vaddr + size) & L1_CACHE_ALIGN_MASK;
+	unsigned long start = (unsigned long) vaddr;
+	unsigned long s = start & L1_CACHE_ALIGN_MASK;
+	unsigned long e = (start + size) & L1_CACHE_ALIGN_MASK;
 
 	for (; s <= e; s += L1_CACHE_BYTES)
 		asm volatile ("ocbp	%0, 0" : : "r" (s));
