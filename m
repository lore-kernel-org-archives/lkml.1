Return-Path: <linux-kernel-owner+w=401wt.eu-S1761382AbYHEPip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761382AbYHEPip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759039AbYHEPie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:38:34 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:56411 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbYHEPie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:38:34 -0400
Date: Tue, 5 Aug 2008 18:37:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] fix SH7705_CACHE_32KB compilation
Message-ID: <20080805153711.GA22895@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches compile errors like the following caused by
commit 51f3547d619956e9b428bfff17004d8f4d259a02
(sh: Allow SH-3 and SH-5 to use common headers):

<--  snip  -->

...
  CC      arch/sh/mm/init.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/mm/init.c: In function 'mem_init':
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/mm/init.c:232: error: implicit declaration of function 'p3_cache_init'
make[2]: *** [arch/sh/mm/init.o] Error 1
make[1]: *** [arch/sh/mm] Error 2
...
  CC      kernel/fork.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/fork.c: In function 'dup_mmap':
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/fork.c:323: error: implicit declaration of function 'flush_dcache_mmap_lock'
/home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/fork.c:325: error: implicit declaration of function 'flush_dcache_mmap_unlock'
make[2]: *** [kernel/fork.o] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
4c8f23b049a9725bba4d84a68988077bd7fdc2c5 
diff --git a/arch/sh/include/cpu-sh3/cpu/cacheflush.h b/arch/sh/include/cpu-sh3/cpu/cacheflush.h
index abc9098..1ac27aa 100644
--- a/arch/sh/include/cpu-sh3/cpu/cacheflush.h
+++ b/arch/sh/include/cpu-sh3/cpu/cacheflush.h
@@ -29,6 +29,16 @@ void flush_cache_page(struct vm_area_struct *vma, unsigned long addr, unsigned l
 void flush_dcache_page(struct page *pg);
 void flush_icache_range(unsigned long start, unsigned long end);
 void flush_icache_page(struct vm_area_struct *vma, struct page *page);
+
+#define flush_dcache_mmap_lock(mapping)		do { } while (0)
+#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
+
+/* SH3 has unified cache so no special action needed here */
+#define flush_cache_sigtramp(vaddr)		do { } while (0)
+#define flush_icache_user_range(vma,pg,adr,len)	do { } while (0)
+
+#define p3_cache_init()				do { } while (0)
+
 #else
 #include <cpu-common/cpu/cacheflush.h>
 #endif

