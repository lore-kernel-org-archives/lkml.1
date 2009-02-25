Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbZBYCLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbZBYCLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 21:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbZBYCLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 21:11:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:47769 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbZBYCLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 21:11:11 -0500
Message-ID: <49A4A8A5.7030400@kernel.org>
Date: Wed, 25 Feb 2009 11:10:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       jeremy@goop.org, cpw@sgi.com, nickpiggin@yahoo.com.au,
       ink@jurassic.park.msu.ru
Subject: [PATCH x86/core/percpu 2/2] x86: convert cacheflush macros inline
 functions
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224201718.GE28772@elte.hu> <20090224205105.GA19460@elte.hu> <20090224211659.GA3687@elte.hu>
In-Reply-To: <20090224211659.GA3687@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Feb 2009 02:10:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Unused macro parameters cause spurious unused variable warnings.
Convert all cacheflush macros to inline functions to avoid the
warnings and achieve better type checking.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/cacheflush.h |   53 +++++++++++++++++++++++++------------
 1 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index 2f84665..5b301b7 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -5,24 +5,43 @@
 #include <linux/mm.h>
 
 /* Caches aren't brain-dead on the intel. */
-#define flush_cache_all()			do { } while (0)
-#define flush_cache_mm(mm)			do { } while (0)
-#define flush_cache_dup_mm(mm)			do { } while (0)
-#define flush_cache_range(vma, start, end)	do { } while (0)
-#define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
-#define flush_dcache_page(page)			do { } while (0)
-#define flush_dcache_mmap_lock(mapping)		do { } while (0)
-#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
-#define flush_icache_range(start, end)		do { } while (0)
-#define flush_icache_page(vma, pg)		do { } while (0)
-#define flush_icache_user_range(vma, pg, adr, len)	do { } while (0)
-#define flush_cache_vmap(start, end)		do { } while (0)
-#define flush_cache_vunmap(start, end)		do { } while (0)
+static inline void flush_cache_all(void) { }
+static inline void flush_cache_mm(struct mm_struct *mm) { }
+static inline void flush_cache_dup_mm(struct mm_struct *mm) { }
+static inline void flush_cache_range(struct vm_area_struct *vma,
+				     unsigned long start, unsigned long end) { }
+static inline void flush_cache_page(struct vm_area_struct *vma,
+				    unsigned long vmaddr, unsigned long pfn) { }
+static inline void flush_dcache_page(struct page *page) { }
+static inline void flush_dcache_mmap_lock(struct address_space *mapping) { }
+static inline void flush_dcache_mmap_unlock(struct address_space *mapping) { }
+static inline void flush_icache_range(unsigned long start,
+				      unsigned long end) { }
+static inline void flush_icache_page(struct vm_area_struct *vma,
+				     struct page *page) { }
+static inline void flush_icache_user_range(struct vm_area_struct *vma,
+					   struct page *page,
+					   unsigned long addr,
+					   unsigned long len) { }
+static inline void flush_cache_vmap(unsigned long start, unsigned long end) { }
+static inline void flush_cache_vunmap(unsigned long start,
+				      unsigned long end) { }
 
-#define copy_to_user_page(vma, page, vaddr, dst, src, len)	\
-	memcpy((dst), (src), (len))
-#define copy_from_user_page(vma, page, vaddr, dst, src, len)	\
-	memcpy((dst), (src), (len))
+static inline void copy_to_user_page(struct vm_area_struct *vma,
+				     struct page *page, unsigned long vaddr,
+				     void *dst, const void *src,
+				     unsigned long len)
+{
+	memcpy(dst, src, len);
+}
+
+static inline void copy_from_user_page(struct vm_area_struct *vma,
+				       struct page *page, unsigned long vaddr,
+				       void *dst, const void *src,
+				       unsigned long len)
+{
+	memcpy(dst, src, len);
+}
 
 #define PG_non_WB				PG_arch_1
 PAGEFLAG(NonWB, non_WB)
-- 
1.6.0.2

