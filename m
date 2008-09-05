Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYIEQLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYIEQLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbYIEQLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:11:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:50126 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbYIEQLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:11:32 -0400
Subject: [GIT *] Fixes for 2.6.27
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Khem Raj <raj.khem@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 17:11:28 +0100
Message-Id: <1220631088.2985.353.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the following three fixes from
	git://git.infradead.org/~dwmw2/dwmw2-2.6.27.git

There's a minor fix to the tmio_nand driver, and two fixes to exported
header files -- one of which involves reverting a late change to the ARM
byteorder headers, which slipped in post 2.6.27-rc4 but should have
waited until the next merge window (and wants more thought, anyway).

David Woodhouse (1):
      Revert "[ARM] use the new byteorder headers"

Dmitry Baryshkov (1):
      [MTD] [NAND] tmio_nand: fix base address programming

Khem Raj (1):
      Fix conditional export of kvh.h and a.out.h to userspace.


 arch/arm/include/asm/byteorder.h |   25 ++++++++++++++-----------
 drivers/mtd/nand/tmio_nand.c     |    8 ++++----
 include/asm-generic/Kbuild.asm   |    6 ++++--
 include/linux/Kbuild             |    6 ++++--
 4 files changed, 26 insertions(+), 19 deletions(-)

Full patch follows:

diff --git a/arch/arm/include/asm/byteorder.h b/arch/arm/include/asm/byteorder.h
index d04a7a2..4fbfb22 100644
--- a/arch/arm/include/asm/byteorder.h
+++ b/arch/arm/include/asm/byteorder.h
@@ -18,15 +18,7 @@
 #include <linux/compiler.h>
 #include <asm/types.h>
 
-#ifdef __ARMEB__
-# define __BIG_ENDIAN
-#else
-# define __LITTLE_ENDIAN
-#endif
-
-#define __SWAB_64_THRU_32__
-
-static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
+static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
 {
 	__u32 t;
 
@@ -48,8 +40,19 @@ static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 
 	return x;
 }
-#define __arch_swab32 __arch_swab32
 
-#include <linux/byteorder.h>
+#define __arch__swab32(x) ___arch__swab32(x)
+
+#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#  define __BYTEORDER_HAS_U64__
+#  define __SWAB_64_THRU_32__
+#endif
+
+#ifdef __ARMEB__
+#include <linux/byteorder/big_endian.h>
+#else
+#include <linux/byteorder/little_endian.h>
+#endif
 
 #endif
+
diff --git a/drivers/mtd/nand/tmio_nand.c b/drivers/mtd/nand/tmio_nand.c
index cbab654..edb1e32 100644
--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -109,7 +109,7 @@ struct tmio_nand {
 
 	void __iomem *ccr;
 	void __iomem *fcr;
-	unsigned long fcr_phys;
+	unsigned long fcr_base;
 
 	unsigned int irq;
 
@@ -316,8 +316,8 @@ static int tmio_hw_init(struct platform_device *dev, struct tmio_nand *tmio)
 	tmio_iowrite8(0x81, tmio->ccr + CCR_ICC);
 
 	/* (10h)BaseAddress    0x1000 spba.spba2 */
-	tmio_iowrite16(tmio->fcr_phys, tmio->ccr + CCR_BASE);
-	tmio_iowrite16(tmio->fcr_phys >> 16, tmio->ccr + CCR_BASE + 16);
+	tmio_iowrite16(tmio->fcr_base, tmio->ccr + CCR_BASE);
+	tmio_iowrite16(tmio->fcr_base >> 16, tmio->ccr + CCR_BASE + 2);
 
 	/* (04h)Command Register I/O spcmd */
 	tmio_iowrite8(0x02, tmio->ccr + CCR_COMMAND);
@@ -395,7 +395,7 @@ static int tmio_probe(struct platform_device *dev)
 		goto err_iomap_ccr;
 	}
 
-	tmio->fcr_phys = (unsigned long)fcr->start;
+	tmio->fcr_base = fcr->start & 0xfffff;
 	tmio->fcr = ioremap(fcr->start, fcr->end - fcr->start + 1);
 	if (!tmio->fcr) {
 		retval = -EIO;
diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index 1170dc6..1870d5e 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -1,8 +1,10 @@
-ifneq ($(wildcard $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
+ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
+      		  $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
 header-y  += kvm.h
 endif
 
-ifneq ($(wildcard $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
+ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
+      		  $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
 unifdef-y += a.out.h
 endif
 unifdef-y += auxvec.h
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 5939125..b68ec09 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -167,7 +167,8 @@ unifdef-y += acct.h
 unifdef-y += adb.h
 unifdef-y += adfs_fs.h
 unifdef-y += agpgart.h
-ifneq ($(wildcard $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
+ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/a.out.h \
+      		  $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
 unifdef-y += a.out.h
 endif
 unifdef-y += apm_bios.h
@@ -258,7 +259,8 @@ unifdef-y += kd.h
 unifdef-y += kernelcapi.h
 unifdef-y += kernel.h
 unifdef-y += keyboard.h
-ifneq ($(wildcard $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
+ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/include/asm/kvm.h \
+      		  $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
 unifdef-y += kvm.h
 endif
 unifdef-y += llc.h


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



