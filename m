Return-Path: <linux-kernel-owner+w=401wt.eu-S1763004AbXEPVgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763004AbXEPVgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbXEPVf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:35:59 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:40607 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbXEPVf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=oFnMJ9ioybSRpYOFGrEUi36vOQ1mPcc1l4+kW1Hr9VGIxtFLUi52+I+/4Qq/f+KVeMUYBICDjiS5Ewi6KGTmp/q7r6iBWr9hQNPIk7pTP9YTapjs6Cz4FlCPNiAzSoRp59Pa4LL7NdmKIT8EtodaEb0CnkGRGArPAw6bvfV6q1c=
Message-ID: <464B78BC.4080900@gmail.com>
Date: Thu, 17 May 2007 05:33:48 +0800
From: "Antonino A. Daplas" <adaplas@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/10] [HEADS UP] fbdev: Move arch-specific bits to their
 respective subdirectories
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move arch-specific bits of fb_mmap() to their respective subdirectories

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
---
Hi all,

Please let me know if there are mistakes with this patch.

Thanks.

Tony

 drivers/video/fbmem.c      |   65 +++++---------------------------------------
 include/asm-alpha/fb.h     |    7 +++++
 include/asm-arm/fb.h       |   12 ++++++++
 include/asm-arm26/fb.h     |    7 +++++
 include/asm-avr32/fb.h     |   14 +++++++++
 include/asm-blackfin/fb.h  |    7 +++++
 include/asm-cris/fb.h      |    7 +++++
 include/asm-frv/fb.h       |    7 +++++
 include/asm-h8300/fb.h     |    7 +++++
 include/asm-i386/fb.h      |   13 +++++++++
 include/asm-ia64/fb.h      |   15 ++++++++++
 include/asm-m32r/fb.h      |   12 ++++++++
 include/asm-m68k/fb.h      |   28 +++++++++++++++++++
 include/asm-m68knommu/fb.h |    7 +++++
 include/asm-mips/fb.h      |   12 ++++++++
 include/asm-parisc/fb.h    |   12 ++++++++
 include/asm-powerpc/fb.h   |   14 +++++++++
 include/asm-ppc/fb.h       |   14 +++++++++
 include/asm-s390/fb.h      |    7 +++++
 include/asm-sh/fb.h        |   12 ++++++++
 include/asm-sh64/fb.h      |   12 ++++++++
 include/asm-sparc/fb.h     |    6 ++++
 include/asm-sparc64/fb.h   |   15 ++++++++++
 include/asm-v850/fb.h      |    7 +++++
 include/asm-x86_64/fb.h    |   13 +++++++++
 include/asm-xtensa/fb.h    |    7 +++++
 include/linux/fb.h         |   12 ++++++++
 27 files changed, 293 insertions(+), 58 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 38c2e25..68d60b7 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -33,17 +33,10 @@ #endif
 #include <linux/err.h>
 #include <linux/device.h>
 #include <linux/efi.h>
+#include <linux/fb.h>
 
-#if defined(__mc68000__) || defined(CONFIG_APUS)
-#include <asm/setup.h>
-#endif
-
-#include <asm/io.h>
-#include <asm/uaccess.h>
-#include <asm/page.h>
-#include <asm/pgtable.h>
+#include <asm/fb.h>
 
-#include <linux/fb.h>
 
     /*
      *  Frame buffer device initialization and setup routines
@@ -1155,17 +1148,15 @@ fb_compat_ioctl(struct file *file, unsig
 }
 #endif
 
-static int 
+static int
 fb_mmap(struct file *file, struct vm_area_struct * vma)
 {
 	int fbidx = iminor(file->f_path.dentry->d_inode);
 	struct fb_info *info = registered_fb[fbidx];
 	struct fb_ops *fb = info->fbops;
 	unsigned long off;
-#if !defined(__sparc__) || defined(__sparc_v9__)
 	unsigned long start;
 	u32 len;
-#endif
 
 	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT))
 		return -EINVAL;
@@ -1180,12 +1171,9 @@ #endif
 		return res;
 	}
 
-#if defined(__sparc__) && !defined(__sparc_v9__)
-	/* Should never get here, all fb drivers should have their own
-	   mmap routines */
-	return -EINVAL;
-#else
-	/* !sparc32... */
+	if (fb_mmap_required())
+		return -EINVAL;
+
 	lock_kernel();
 
 	/* frame buffer memory */
@@ -1209,50 +1197,11 @@ #else
 	vma->vm_pgoff = off >> PAGE_SHIFT;
 	/* This is an IO map - tell maydump to skip this VMA */
 	vma->vm_flags |= VM_IO | VM_RESERVED;
-#if defined(__mc68000__)
-#if defined(CONFIG_SUN3)
-	pgprot_val(vma->vm_page_prot) |= SUN3_PAGE_NOCACHE;
-#elif defined(CONFIG_MMU)
-	if (CPU_IS_020_OR_030)
-		pgprot_val(vma->vm_page_prot) |= _PAGE_NOCACHE030;
-	if (CPU_IS_040_OR_060) {
-		pgprot_val(vma->vm_page_prot) &= _CACHEMASK040;
-		/* Use no-cache mode, serialized */
-		pgprot_val(vma->vm_page_prot) |= _PAGE_NOCACHE_S;
-	}
-#endif
-#elif defined(__powerpc__)
-	vma->vm_page_prot = phys_mem_access_prot(file, off >> PAGE_SHIFT,
-						 vma->vm_end - vma->vm_start,
-						 vma->vm_page_prot);
-#elif defined(__alpha__)
-	/* Caching is off in the I/O space quadrant by design.  */
-#elif defined(__i386__) || defined(__x86_64__)
-	if (boot_cpu_data.x86 > 3)
-		pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
-#elif defined(__mips__) || defined(__sparc_v9__)
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-#elif defined(__hppa__)
-	pgprot_val(vma->vm_page_prot) |= _PAGE_NO_CACHE;
-#elif defined(__arm__) || defined(__sh__) || defined(__m32r__)
-	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-#elif defined(__avr32__)
-	vma->vm_page_prot = __pgprot((pgprot_val(vma->vm_page_prot)
-				      & ~_PAGE_CACHABLE)
-				     | (_PAGE_BUFFER | _PAGE_DIRTY));
-#elif defined(__ia64__)
-	if (efi_range_is_wc(vma->vm_start, vma->vm_end - vma->vm_start))
-		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-	else
-		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-#else
-#warning What do we have to do here??
-#endif
+	fb_pgprotect(file, vma);
 	if (io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
 			     vma->vm_end - vma->vm_start, vma->vm_page_prot))
 		return -EAGAIN;
 	return 0;
-#endif /* !sparc32 */
 }
 
 static int
diff --git a/include/asm-alpha/fb.h b/include/asm-alpha/fb.h
new file mode 100644
index 0000000..ca714a4
--- /dev/null
+++ b/include/asm-alpha/fb.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+/* Caching is off in the I/O space quadrant by design.  */
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-arm/fb.h b/include/asm-arm/fb.h
new file mode 100644
index 0000000..067b599
--- /dev/null
+++ b/include/asm-arm/fb.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
+{
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+}
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-arm26/fb.h b/include/asm-arm26/fb.h
new file mode 100644
index 0000000..dc9d1be
--- /dev/null
+++ b/include/asm-arm26/fb.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#warning What do we have to do here??
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-avr32/fb.h b/include/asm-avr32/fb.h
new file mode 100644
index 0000000..710255a
--- /dev/null
+++ b/include/asm-avr32/fb.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
+{
+	vma->vm_page_prot = __pgprot((pgprot_val(vma->vm_page_prot)
+				      & ~_PAGE_CACHABLE)
+				     | (_PAGE_BUFFER | _PAGE_DIRTY));
+}
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-blackfin/fb.h b/include/asm-blackfin/fb.h
new file mode 100644
index 0000000..dc9d1be
--- /dev/null
+++ b/include/asm-blackfin/fb.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#warning What do we have to do here??
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-cris/fb.h b/include/asm-cris/fb.h
new file mode 100644
index 0000000..dc9d1be
--- /dev/null
+++ b/include/asm-cris/fb.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#warning What do we have to do here??
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-frv/fb.h b/include/asm-frv/fb.h
new file mode 100644
index 0000000..dc9d1be
--- /dev/null
+++ b/include/asm-frv/fb.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#warning What do we have to do here??
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-h8300/fb.h b/include/asm-h8300/fb.h
new file mode 100644
index 0000000..dc9d1be
--- /dev/null
+++ b/include/asm-h8300/fb.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#warning What do we have to do here??
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-i386/fb.h b/include/asm-i386/fb.h
new file mode 100644
index 0000000..ff83013
--- /dev/null
+++ b/include/asm-i386/fb.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
+{
+	if (boot_cpu_data.x86 > 3)
+		pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
+}
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-ia64/fb.h b/include/asm-ia64/fb.h
new file mode 100644
index 0000000..31b9743
--- /dev/null
+++ b/include/asm-ia64/fb.h
@@ -0,0 +1,15 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
+{
+	if (efi_range_is_wc(vma->vm_start, vma->vm_end - vma->vm_start))
+		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+	else
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+}
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-m32r/fb.h b/include/asm-m32r/fb.h
new file mode 100644
index 0000000..067b599
--- /dev/null
+++ b/include/asm-m32r/fb.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
+{
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+}
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-m68k/fb.h b/include/asm-m68k/fb.h
new file mode 100644
index 0000000..7d4a28f
--- /dev/null
+++ b/include/asm-m68k/fb.h
@@ -0,0 +1,28 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+#include <asm/setup.h>
+
+#ifdef CONFIG_SUN3
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
+{
+	pgprot_val(vma->vm_page_prot) |= SUN3_PAGE_NOCACHE;
+}
+#elif defined(CONFIG_MMU)
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
+	if (CPU_IS_020_OR_030)
+		pgprot_val(vma->vm_page_prot) |= _PAGE_NOCACHE030;
+	if (CPU_IS_040_OR_060) {
+		pgprot_val(vma->vm_page_prot) &= _CACHEMASK040;
+		/* Use no-cache mode, serialized */
+		pgprot_val(vma->vm_page_prot) |= _PAGE_NOCACHE_S;
+	}
+}
+#else
+#warning What do we have to do here??
+#define fb_pgprotect(...) do {} while (0)
+#endif /* CONFIG_SUN3 */
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-m68knommu/fb.h b/include/asm-m68knommu/fb.h
new file mode 100644
index 0000000..dc9d1be
--- /dev/null
+++ b/include/asm-m68knommu/fb.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#warning What do we have to do here??
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-mips/fb.h b/include/asm-mips/fb.h
new file mode 100644
index 0000000..dab64a8
--- /dev/null
+++ b/include/asm-mips/fb.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
+{
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+}
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-parisc/fb.h b/include/asm-parisc/fb.h
new file mode 100644
index 0000000..a9c2f67
--- /dev/null
+++ b/include/asm-parisc/fb.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
+{
+	pgprot_val(vma->vm_page_prot) |= _PAGE_NO_CACHE;
+}
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-powerpc/fb.h b/include/asm-powerpc/fb.h
new file mode 100644
index 0000000..32eb8b7
--- /dev/null
+++ b/include/asm-powerpc/fb.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
+{
+	vma->vm_page_prot = phys_mem_access_prot(file, off >> PAGE_SHIFT,
+						 vma->vm_end - vma->vm_start,
+						 vma->vm_page_prot);
+}
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-ppc/fb.h b/include/asm-ppc/fb.h
new file mode 100644
index 0000000..32eb8b7
--- /dev/null
+++ b/include/asm-ppc/fb.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
+{
+	vma->vm_page_prot = phys_mem_access_prot(file, off >> PAGE_SHIFT,
+						 vma->vm_end - vma->vm_start,
+						 vma->vm_page_prot);
+}
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-s390/fb.h b/include/asm-s390/fb.h
new file mode 100644
index 0000000..dc9d1be
--- /dev/null
+++ b/include/asm-s390/fb.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#warning What do we have to do here??
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-sh/fb.h b/include/asm-sh/fb.h
new file mode 100644
index 0000000..067b599
--- /dev/null
+++ b/include/asm-sh/fb.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
+{
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+}
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-sh64/fb.h b/include/asm-sh64/fb.h
new file mode 100644
index 0000000..067b599
--- /dev/null
+++ b/include/asm-sh64/fb.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
+{
+	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
+}
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-sparc/fb.h b/include/asm-sparc/fb.h
new file mode 100644
index 0000000..9f8c88d
--- /dev/null
+++ b/include/asm-sparc/fb.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-sparc64/fb.h b/include/asm-sparc64/fb.h
new file mode 100644
index 0000000..01b50b2
--- /dev/null
+++ b/include/asm-sparc64/fb.h
@@ -0,0 +1,15 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#if defined(__sparc_v9__)
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
+{
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+}
+#else
+#define fb_pgprotect(...) do {} while (0)
+#endif /* defined(__sparc_v9__) */
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-v850/fb.h b/include/asm-v850/fb.h
new file mode 100644
index 0000000..dc9d1be
--- /dev/null
+++ b/include/asm-v850/fb.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#warning What do we have to do here??
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-x86_64/fb.h b/include/asm-x86_64/fb.h
new file mode 100644
index 0000000..ff83013
--- /dev/null
+++ b/include/asm-x86_64/fb.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#include <linux/fs.h>
+#include <asm/page.h>
+
+static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma)
+{
+	if (boot_cpu_data.x86 > 3)
+		pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
+}
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/asm-xtensa/fb.h b/include/asm-xtensa/fb.h
new file mode 100644
index 0000000..dc9d1be
--- /dev/null
+++ b/include/asm-xtensa/fb.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+
+#warning What do we have to do here??
+#define fb_pgprotect(...) do {} while (0)
+
+#endif /* _ASM_FB_H_ */
diff --git a/include/linux/fb.h b/include/linux/fb.h
index c654d0e..0e929c3 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -1064,6 +1064,18 @@ extern int fb_find_mode(struct fb_var_sc
 			const struct fb_videomode *default_mode,
 			unsigned int default_bpp);
 
+#if defined(__sparc__) && !defined(__sparc_v9__)
+static inline int fb_mmap_required(void)
+{
+	return 1;
+}
+#else
+static inline int fb_mmap_required(void)
+{
+	return 0;
+}
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_FB_H */


