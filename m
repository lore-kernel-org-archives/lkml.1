Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZFIGbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZFIGbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZFIGbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:31:33 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:43862 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbZFIGbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:31:31 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jun 2009 02:31:30 EDT
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: [PATCH 05/27] score: create head files cache.h cacheflush.h checksum.h
 cputime.h current.h
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF45377EDE.71658F7D-ON482575D0.0023440F-482575D0.0023B614@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Tue, 9 Jun 2009 14:25:46 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/09 ?? 02:25:47,
	Serialize complete at 2009/06/09 ?? 02:25:47
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5e295ae34254dbb13418020df52a67934ec08f9a Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Tue, 9 Jun 2009 13:43:07 +0800



Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/cache.h      |    7 +
 arch/score/include/asm/cacheflush.h |   47 +++++++
 arch/score/include/asm/checksum.h   |  235 
+++++++++++++++++++++++++++++++++++
 arch/score/include/asm/cputime.h    |    6 +
 arch/score/include/asm/current.h    |   15 +++
 5 files changed, 310 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/cache.h
 create mode 100644 arch/score/include/asm/cacheflush.h
 create mode 100644 arch/score/include/asm/checksum.h
 create mode 100644 arch/score/include/asm/cputime.h
 create mode 100644 arch/score/include/asm/current.h

diff --git a/arch/score/include/asm/cache.h 
b/arch/score/include/asm/cache.h
new file mode 100644
index 0000000..ae3d59f
--- /dev/null
+++ b/arch/score/include/asm/cache.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_SCORE_CACHE_H
+#define _ASM_SCORE_CACHE_H
+
+#define L1_CACHE_SHIFT         4
+#define L1_CACHE_BYTES         (1 << L1_CACHE_SHIFT)
+
+#endif /* _ASM_SCORE_CACHE_H */
diff --git a/arch/score/include/asm/cacheflush.h 
b/arch/score/include/asm/cacheflush.h
new file mode 100644
index 0000000..1c74628
--- /dev/null
+++ b/arch/score/include/asm/cacheflush.h
@@ -0,0 +1,47 @@
+#ifndef _ASM_SCORE_CACHEFLUSH_H
+#define _ASM_SCORE_CACHEFLUSH_H
+
+/* Keep includes the same across arches. */
+#include <linux/mm.h>
+
+extern void (*flush_cache_all)(void);
+extern void (*flush_cache_mm)(struct mm_struct *mm);
+extern void (*flush_cache_range)(struct vm_area_struct *vma,
+                               unsigned long start, unsigned long end);
+extern void (*flush_cache_page)(struct vm_area_struct *vma,
+                               unsigned long page, unsigned long pfn);
+extern void (*flush_cache_sigtramp)(unsigned long addr);
+extern void (*flush_icache_all)(void);
+extern void (*flush_icache_range)(unsigned long start, unsigned long 
end);
+extern void (*flush_data_cache_page)(unsigned long addr);
+
+extern void s7_flush_cache_all(void);
+
+#define flush_cache_dup_mm(mm)                 do {} while (0)
+#define flush_dcache_page(page)                        do {} while (0)
+#define flush_dcache_mmap_lock(mapping)                do {} while (0)
+#define flush_dcache_mmap_unlock(mapping)      do {} while (0)
+#define flush_cache_vmap(start, end)           do {} while (0)
+#define flush_cache_vunmap(start, end)         do {} while (0)
+
+static inline void flush_icache_page(struct vm_area_struct *vma,
+       struct page *page)
+{
+       if (vma->vm_flags & VM_EXEC) {
+               void *v = page_address(page);
+               flush_icache_range((unsigned long) v,
+                               (unsigned long) v + PAGE_SIZE);
+       }
+}
+
+#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
+       memcpy(dst, src, len)
+
+#define copy_to_user_page(vma, page, vaddr, dst, src, len)     \
+       do {                                                    \
+               memcpy(dst, src, len);                          \
+               if ((vma->vm_flags & VM_EXEC))                  \
+                       flush_cache_page(vma, vaddr, page_to_pfn(page));\
+       } while (0)
+
+#endif /* _ASM_SCORE_CACHEFLUSH_H */
diff --git a/arch/score/include/asm/checksum.h 
b/arch/score/include/asm/checksum.h
new file mode 100644
index 0000000..f909ac3
--- /dev/null
+++ b/arch/score/include/asm/checksum.h
@@ -0,0 +1,235 @@
+#ifndef _ASM_SCORE_CHECKSUM_H
+#define _ASM_SCORE_CHECKSUM_H
+
+#include <linux/in6.h>
+#include <asm/uaccess.h>
+
+/*
+ * computes the checksum of a memory block at buff, length len,
+ * and adds in "sum" (32-bit)
+ *
+ * returns a 32-bit number suitable for feeding into itself
+ * or csum_tcpudp_magic
+ *
+ * this function must be called with even lengths, except
+ * for the last fragment, which may be odd
+ *
+ * it's best to have buff aligned on a 32-bit boundary
+ */
+unsigned int csum_partial(const void *buff, int len, __wsum sum);
+unsigned int csum_partial_copy_from_user(const char *src, char *dst, int 
len,
+                                       unsigned int sum, int *csum_err);
+unsigned int csum_partial_copy(const char *src, char *dst,
+                                       int len, unsigned int sum);
+
+/*
+ * this is a new version of the above that records errors it finds in 
*errp,
+ * but continues and zeros the rest of the buffer.
+ */
+
+/*
+ * Copy and checksum to user
+ */
+#define HAVE_CSUM_COPY_USER
+static inline
+__wsum csum_and_copy_to_user(const void *src, void __user *dst, int len,
+                       __wsum sum, int *err_ptr)
+{
+       sum = csum_partial(src, len, sum);
+       if (copy_to_user(dst, src, len)) {
+               *err_ptr = -EFAULT;
+               return (__force __wsum) -1; /* invalid checksum */
+       }
+       return sum;
+}
+
+
+#define csum_partial_copy_nocheck csum_partial_copy
+/*
+ *     Fold a partial checksum without adding pseudo headers
+ */
+
+static inline __sum16 csum_fold(__wsum sum)
+{
+       /* the while loop is unnecessary really, it's always enough with 
two
+          iterations */
+       __asm__ __volatile__(
+               ".set volatile\n\t"
+               ".set\tr1\n\t"
+               "slli\tr1,%0, 16\n\t"
+               "add\t%0,%0, r1\n\t"
+               "cmp.c\tr1, %0\n\t"
+               "srli\t%0, %0, 16\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:ldi\tr30, 0xffff\n\t"
+               "xor\t%0, %0, r30\n\t"
+               "slli\t%0, %0, 16\n\t"
+               "srli\t%0, %0, 16\n\t"
+               ".set\tnor1\n\t"
+               ".set optimize\n\t"
+               : "=r" (sum)
+               : "0" (sum));
+       return sum;
+}
+
+/*
+ *     This is a version of ip_compute_csum() optimized for IP headers,
+ *     which always checksum on 4 octet boundaries.
+ *
+ *     By Jorge Cwik <jorge@laser.satlink.net>, adapted for linux by
+ *     Arnt Gulbrandsen.
+ */
+static inline __sum16 ip_fast_csum(const void *iph, unsigned int ihl)
+{
+       unsigned int sum;
+       unsigned long dummy;
+
+       __asm__ __volatile__(
+               ".set volatile\n\t"
+               ".set\tnor1\n\t"
+               "lw\t%0, [%1]\n\t"
+               "subri\t%2, %2, 4\n\t"
+               "slli\t%2, %2, 2\n\t"
+               "lw\t%3, [%1, 4]\n\t"
+               "add\t%2, %2, %1\n\t"
+               "add\t%0, %0, %3\n\t"
+               "cmp.c\t%3, %0\n\t"
+               "lw\t%3, [%1, 8]\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:\n\t"
+               "add\t%0, %0, %3\n\t"
+               "cmp.c\t%3, %0\n\t"
+               "lw\t%3, [%1, 12]\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:add\t%0, %0, %3\n\t"
+               "cmp.c\t%3, %0\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n"
+
+               "1:\tlw\t%3, [%1, 16]\n\t"
+               "addi\t%1, 4\n\t"
+               "add\t%0, %0, %3\n\t"
+               "cmp.c\t%3, %0\n\t"
+               "bleu\t2f\n\t"
+               "addi\t%0, 0x1\n"
+               "2:cmp.c\t%2, %1\n\t"
+               "bne\t1b\n\t"
+
+               ".set\tr1\n\t"
+               ".set optimize\n\t"
+               : "=&r" (sum), "=&r" (iph), "=&r" (ihl), "=&r" (dummy)
+               : "1" (iph), "2" (ihl));
+
+       return csum_fold(sum);
+}
+
+static inline __wsum
+csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
+               unsigned short proto, __wsum sum)
+{
+       unsigned long tmp = (ntohs(len) << 16) + proto * 256;
+       __asm__ __volatile__(
+               ".set volatile\n\t"
+               "add\t%0, %0, %2\n\t"
+               "cmp.c\t%2, %0\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:\n\t"
+               "add\t%0, %0, %3\n\t"
+               "cmp.c\t%3, %0\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:\n\t"
+               "add\t%0, %0, %4\n\t"
+               "cmp.c\t%4, %0\n\t"
+               "bleu\t1f\n\t"
+               "addi\t%0, 0x1\n\t"
+               "1:\n\t"
+               ".set optimize\n\t"
+               : "=r" (sum)
+               : "0" (daddr), "r"(saddr),
+               "r" (tmp),
+               "r" (sum));
+       return sum;
+}
+
+/*
+ * computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented
+ */
+static inline __sum16
+csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
+               unsigned short proto, __wsum sum)
+{
+       return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, 
sum));
+}
+
+/*
+ * this routine is used for miscellaneous IP-like checksums, mainly
+ * in icmp.c
+ */
+
+static inline unsigned short ip_compute_csum(const void *buff, int len)
+{
+       return csum_fold(csum_partial(buff, len, 0));
+}
+
+#define _HAVE_ARCH_IPV6_CSUM
+static inline __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
+                               const struct in6_addr *daddr,
+                               __u32 len, unsigned short proto,
+                               __wsum sum)
+{
+       __asm__ __volatile__(
+               ".set\tnoreorder\t\t\t# csum_ipv6_magic\n\t"
+               ".set\tnoat\n\t"
+               "addu\t%0, %5\t\t\t# proto (long in network byte 
order)\n\t"
+               "sltu\t$1, %0, %5\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %6\t\t\t# csum\n\t"
+               "sltu\t$1, %0, %6\n\t"
+               "lw\t%1, 0(%2)\t\t\t# four words source address\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 4(%2)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 8(%2)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 12(%2)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 0(%3)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 4(%3)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 8(%3)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "lw\t%1, 12(%3)\n\t"
+               "addu\t%0, $1\n\t"
+               "addu\t%0, %1\n\t"
+               "sltu\t$1, %0, %1\n\t"
+               "addu\t%0, $1\t\t\t# Add final carry\n\t"
+               ".set\tnoat\n\t"
+               ".set\tnoreorder"
+               : "=r" (sum), "=r" (proto)
+               : "r" (saddr), "r" (daddr),
+                 "0" (htonl(len)), "1" (htonl(proto)), "r" (sum));
+
+       return csum_fold(sum);
+}
+#endif /* _ASM_SCORE_CHECKSUM_H */
diff --git a/arch/score/include/asm/cputime.h 
b/arch/score/include/asm/cputime.h
new file mode 100644
index 0000000..1fced99
--- /dev/null
+++ b/arch/score/include/asm/cputime.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_CPUTIME_H
+#define _ASM_SCORE_CPUTIME_H
+
+#include <asm-generic/cputime.h>
+
+#endif /* _ASM_SCORE_CPUTIME_H */
diff --git a/arch/score/include/asm/current.h 
b/arch/score/include/asm/current.h
new file mode 100644
index 0000000..91de710
--- /dev/null
+++ b/arch/score/include/asm/current.h
@@ -0,0 +1,15 @@
+#ifndef _ASM_SCORE_CURRENT_H
+#define _ASM_SCORE_CURRENT_H
+
+#include <linux/thread_info.h>
+
+struct task_struct;
+
+static inline struct task_struct *get_current(void)
+{
+       return current_thread_info()->task;
+}
+
+#define current        get_current()
+
+#endif /* _ASM_SCORE_CURRENT_H */
-- 
1.6.2

