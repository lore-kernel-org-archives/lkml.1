Return-Path: <linux-kernel-owner+w=401wt.eu-S1751495AbXE2XkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbXE2XkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 19:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXE2XkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 19:40:05 -0400
Received: from are.twiddle.net ([64.81.246.98]:40665 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbXE2XkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 19:40:04 -0400
X-Greylist: delayed 2261 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 19:40:04 EDT
Date: Tue, 29 May 2007 16:01:35 -0700
From: Richard Henderson <rth@twiddle.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-kernel@vger.kernel.org
Subject: [alpha] cleanup in bitops.h
Message-ID: <20070529230135.GA16535@twiddle.net>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove 2 functions private to the alpha implemetation, 
in favor of similar functions in <linux/log2.h>.

Provide a more efficient version of the fls64 function
for pre-ev67 alphas.


r~



diff -ruNp /home/rth/work/linux/linux-2.6.22-rc2/arch/alpha/kernel/pci_iommu.c linux-2.6.22-rc2/arch/alpha/kernel/pci_iommu.c
--- /home/rth/work/linux/linux-2.6.22-rc2/arch/alpha/kernel/pci_iommu.c	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22-rc2/arch/alpha/kernel/pci_iommu.c	2007-05-25 15:42:32.000000000 -0700
@@ -7,6 +7,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/bootmem.h>
+#include <linux/log2.h>
 
 #include <asm/io.h>
 #include <asm/hwrpb.h>
@@ -53,7 +54,7 @@ size_for_memory(unsigned long max)
 {
 	unsigned long mem = max_low_pfn << PAGE_SHIFT;
 	if (mem < max)
-		max = 1UL << ceil_log2(mem);
+		max = roundup_pow_of_two(mem);
 	return max;
 }
 
diff -ruNp /home/rth/work/linux/linux-2.6.22-rc2/arch/alpha/kernel/setup.c linux-2.6.22-rc2/arch/alpha/kernel/setup.c
--- /home/rth/work/linux/linux-2.6.22-rc2/arch/alpha/kernel/setup.c	2007-05-28 15:23:20.000000000 -0700
+++ linux-2.6.22-rc2/arch/alpha/kernel/setup.c	2007-05-25 15:41:20.000000000 -0700
@@ -43,6 +43,7 @@
 #include <linux/notifier.h>
 #include <asm/setup.h>
 #include <asm/io.h>
+#include <linux/log2.h>
 
 extern struct atomic_notifier_head panic_notifier_list;
 static int alpha_panic_event(struct notifier_block *, unsigned long, void *);
@@ -1303,7 +1304,7 @@ external_cache_probe(int minsize, int wi
 	long size = minsize, maxsize = MAX_BCACHE_SIZE * 2;
 
 	if (maxsize > (max_low_pfn + 1) << PAGE_SHIFT)
-		maxsize = 1 << (floor_log2(max_low_pfn + 1) + PAGE_SHIFT);
+		maxsize = 1 << (ilog2(max_low_pfn + 1) + PAGE_SHIFT);
 
 	/* Get the first block cached. */
 	read_mem_block(__va(0), stride, size);
diff -ruNp /home/rth/work/linux/linux-2.6.22-rc2/arch/alpha/lib/Makefile linux-2.6.22-rc2/arch/alpha/lib/Makefile
--- /home/rth/work/linux/linux-2.6.22-rc2/arch/alpha/lib/Makefile	2007-05-28 15:23:20.000000000 -0700
+++ linux-2.6.22-rc2/arch/alpha/lib/Makefile	2007-05-25 15:43:08.000000000 -0700
@@ -37,7 +37,8 @@ lib-y =	__divqu.o __remqu.o __divlu.o __
 	$(ev6-y)clear_page.o \
 	$(ev6-y)copy_page.o \
 	fpreg.o \
-	callback_srm.o srm_puts.o srm_printk.o
+	callback_srm.o srm_puts.o srm_printk.o \
+	fls.o
 
 lib-$(CONFIG_SMP) += dec_and_lock.o
 
diff -ruNp /home/rth/work/linux/linux-2.6.22-rc2/arch/alpha/lib/fls.c linux-2.6.22-rc2/arch/alpha/lib/fls.c
--- /home/rth/work/linux/linux-2.6.22-rc2/arch/alpha/lib/fls.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.22-rc2/arch/alpha/lib/fls.c	2007-05-28 16:06:46.000000000 -0700
@@ -0,0 +1,38 @@
+/* 
+ * arch/alpha/lib/fls.c
+ */
+
+#include <linux/module.h>
+#include <asm/bitops.h>
+
+/* This is fls(x)-1, except zero is held to zero.  This allows most
+   efficent input into extbl, plus it allows easy handling of fls(0)=0.  */
+
+const unsigned char __flsm1_tab[256] = 
+{
+  0,
+  0,
+  1, 1,
+  2, 2, 2, 2,
+  3, 3, 3, 3, 3, 3, 3, 3,
+  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
+
+  5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
+  5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
+
+  6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
+  6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
+  6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
+  6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
+
+  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
+};
+
+EXPORT_SYMBOL(__flsm1_tab);
diff -ruNp /home/rth/work/linux/linux-2.6.22-rc2/include/asm-alpha/bitops.h linux-2.6.22-rc2/include/asm-alpha/bitops.h
--- /home/rth/work/linux/linux-2.6.22-rc2/include/asm-alpha/bitops.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22-rc2/include/asm-alpha/bitops.h	2007-05-28 16:05:18.000000000 -0700
@@ -313,32 +313,29 @@ static inline int ffs(int word)
  * fls: find last bit set.
  */
 #if defined(CONFIG_ALPHA_EV6) && defined(CONFIG_ALPHA_EV67)
-static inline int fls(int word)
+static inline int fls64(unsigned long word)
 {
-	return 64 - __kernel_ctlz(word & 0xffffffff);
+	return 64 - __kernel_ctlz(word);
 }
 #else
-#include <asm-generic/bitops/fls.h>
-#endif
-#include <asm-generic/bitops/fls64.h>
+extern const unsigned char __flsm1_tab[256];
 
-/* Compute powers of two for the given integer.  */
-static inline long floor_log2(unsigned long word)
+static inline int fls64(unsigned long x)
 {
-#if defined(CONFIG_ALPHA_EV6) && defined(CONFIG_ALPHA_EV67)
-	return 63 - __kernel_ctlz(word);
-#else
-	long bit;
-	for (bit = -1; word ; bit++)
-		word >>= 1;
-	return bit;
-#endif
+	unsigned long t, a, r;
+
+	t = __kernel_cmpbge (x, 0x0101010101010101);
+	a = __flsm1_tab[t];
+	t = __kernel_extbl (x, a);
+	r = a*8 + __flsm1_tab[t] + (x != 0);
+
+	return r;
 }
+#endif
 
-static inline long ceil_log2(unsigned long word)
+static inline int fls(int x)
 {
-	long bit = floor_log2(word);
-	return bit + (word > (1UL << bit));
+	return fls64((unsigned int) x);
 }
 
 /*
@@ -353,9 +350,20 @@ static inline unsigned long hweight64(un
 	return __kernel_ctpop(w);
 }
 
-#define hweight32(x)	(unsigned int) hweight64((x) & 0xfffffffful)
-#define hweight16(x)	(unsigned int) hweight64((x) & 0xfffful)
-#define hweight8(x)	(unsigned int) hweight64((x) & 0xfful)
+static inline unsigned int hweight32(unsigned int w)
+{
+	return hweight64(w);
+}
+
+static inline unsigned int hweight16(unsigned int w)
+{
+	return hweight64(w & 0xffff);
+}
+
+static inline unsigned int hweight8(unsigned int w)
+{
+	return hweight64(w & 0xff);
+}
 #else
 #include <asm-generic/bitops/hweight.h>
 #endif
