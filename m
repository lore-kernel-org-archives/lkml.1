Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbXE1Ka1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbXE1Ka1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbXE1KaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:30:17 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:44313 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbXE1KaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HnYtMVAsAL+6eZDUU3L/z8F7laL+FjUFBdTmXLsCQjZLbzPxhCJbYttG1SbrJqoKNYUSAWdSu6BjFbSliZgi0eUGQvDzDA3exXMD49Xk5Lf4YX2VuG5dDBMdC0Okn5w14WaMjYg1uo63OKDays+4g37xhfOjLwEZGMJCZpP3c+k=
Message-ID: <465AAF2C.6070602@gmail.com>
Date: Mon, 28 May 2007 18:30:04 +0800
From: "Antonino A. Daplas" <adaplas@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: linux-fbdev-devel@lists.sourceforge.net
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 8/9] [RESEND] fbdev: Detect primary display device
References: <465952CD.2040409@gmail.com> <Pine.LNX.4.64.0705281037080.4790@anakin>
In-Reply-To: <Pine.LNX.4.64.0705281037080.4790@anakin>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add function helper, fb_is_primary_device().  Given struct fb_info, it will
return a nonzero value if the device is the primary display.

Currently, only the i386 is supported where the function checks for the
IORESOURCE_ROM_SHADOW flag.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
---
Geert Uytterhoeven wrote:
> On Sun, 27 May 2007, Antonino A. Daplas wrote:
>> Add function helper, fb_is_display_device().  Given struct fb_info, it will
>                              ^^^^^^^
> 			     primary
> 
>> return a nonzero value if the device is the primary display.
> 
>> +static inline int fb_is_primary_device(struct fb_screeninfo *info)
>                                                  ^^^^^^^^^^^^^

Yikes, thanks.  Andrew, here's an updated patch.

Tony

 arch/i386/Makefile         |    1 +
 arch/i386/video/Makefile   |    1 +
 arch/i386/video/fbdev.c    |   34 ++++++++++++++++++++++++++++++++++
 include/asm-alpha/fb.h     |    6 ++++++
 include/asm-arm/fb.h       |    6 ++++++
 include/asm-arm26/fb.h     |    6 ++++++
 include/asm-avr32/fb.h     |    6 ++++++
 include/asm-blackfin/fb.h  |    6 ++++++
 include/asm-cris/fb.h      |    6 ++++++
 include/asm-frv/fb.h       |    6 ++++++
 include/asm-h8300/fb.h     |    6 ++++++
 include/asm-i386/fb.h      |    3 +++
 include/asm-ia64/fb.h      |    6 ++++++
 include/asm-m32r/fb.h      |    6 ++++++
 include/asm-m68k/fb.h      |    6 ++++++
 include/asm-m68knommu/fb.h |    6 ++++++
 include/asm-mips/fb.h      |    6 ++++++
 include/asm-parisc/fb.h    |    6 ++++++
 include/asm-powerpc/fb.h   |    6 ++++++
 include/asm-s390/fb.h      |    6 ++++++
 include/asm-sh/fb.h        |    6 ++++++
 include/asm-sh64/fb.h      |    6 ++++++
 include/asm-sparc/fb.h     |    6 ++++++
 include/asm-sparc64/fb.h   |    6 ++++++
 include/asm-v850/fb.h      |    6 ++++++
 include/asm-x86_64/fb.h    |    7 ++++++-
 include/asm-xtensa/fb.h    |    6 ++++++
 27 files changed, 177 insertions(+), 1 deletions(-)

diff --git a/arch/i386/Makefile b/arch/i386/Makefile
index 3eb063e..01f0ff0 100644
--- a/arch/i386/Makefile
+++ b/arch/i386/Makefile
@@ -111,6 +111,7 @@ drivers-$(CONFIG_PCI)			+= arch/i386/pci
 # must be linked after kernel/
 drivers-$(CONFIG_OPROFILE)		+= arch/i386/oprofile/
 drivers-$(CONFIG_PM)			+= arch/i386/power/
+drivers-$(CONFIG_FB)                    += arch/i386/video/
 
 CFLAGS += $(mflags-y)
 AFLAGS += $(mflags-y)
diff --git a/arch/i386/video/Makefile b/arch/i386/video/Makefile
new file mode 100644
index 0000000..2c447c9
--- /dev/null
+++ b/arch/i386/video/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_FB)               += fbdev.o
diff --git a/arch/i386/video/fbdev.c b/arch/i386/video/fbdev.c
new file mode 100644
index 0000000..7fc712c
--- /dev/null
+++ b/arch/i386/video/fbdev.c
@@ -0,0 +1,34 @@
+/*
+ * arch/i386/video/fbdev.c - i386 Framebuffer
+ *
+ * Copyright (C) 2007 Antonino Daplas <adaplas@gmail.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ *
+ */
+#include <linux/fb.h>
+#include <linux/pci.h>
+
+int fb_is_primary_device(struct fb_info *info)
+{
+	struct device *device;
+	struct pci_dev *pci_dev = NULL;
+	struct resource *res = NULL;
+	int retval = 0;
+
+	device = info->device;
+
+	if (device)
+		pci_dev = to_pci_dev(device);
+
+	if (pci_dev)
+		res = &pci_dev->resource[PCI_ROM_RESOURCE];
+
+	if (res && res->flags & IORESOURCE_ROM_SHADOW)
+		retval = 1;
+
+	return retval;
+}
+EXPORT_SYMBOL(fb_is_primary_device);
diff --git a/include/asm-alpha/fb.h b/include/asm-alpha/fb.h
index ca714a4..6d3b5b6 100644
--- a/include/asm-alpha/fb.h
+++ b/include/asm-alpha/fb.h
@@ -1,7 +1,13 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/device.h>
 
 /* Caching is off in the I/O space quadrant by design.  */
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-arm/fb.h b/include/asm-arm/fb.h
index 4bf5b88..d92e99c 100644
--- a/include/asm-arm/fb.h
+++ b/include/asm-arm/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -10,4 +11,9 @@ static inline void fb_pgprotect(struct f
 	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-arm26/fb.h b/include/asm-arm26/fb.h
index 9f8c88d..c7df380 100644
--- a/include/asm-arm26/fb.h
+++ b/include/asm-arm26/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-avr32/fb.h b/include/asm-avr32/fb.h
index d22a4a8..41baf84 100644
--- a/include/asm-avr32/fb.h
+++ b/include/asm-avr32/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -12,4 +13,9 @@ static inline void fb_pgprotect(struct f
 				     | (_PAGE_BUFFER | _PAGE_DIRTY));
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-blackfin/fb.h b/include/asm-blackfin/fb.h
index 9f8c88d..c7df380 100644
--- a/include/asm-blackfin/fb.h
+++ b/include/asm-blackfin/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-cris/fb.h b/include/asm-cris/fb.h
index 9f8c88d..c7df380 100644
--- a/include/asm-cris/fb.h
+++ b/include/asm-cris/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-frv/fb.h b/include/asm-frv/fb.h
index 9f8c88d..c7df380 100644
--- a/include/asm-frv/fb.h
+++ b/include/asm-frv/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-h8300/fb.h b/include/asm-h8300/fb.h
index 9f8c88d..c7df380 100644
--- a/include/asm-h8300/fb.h
+++ b/include/asm-h8300/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-i386/fb.h b/include/asm-i386/fb.h
index d30073c..d1c6297 100644
--- a/include/asm-i386/fb.h
+++ b/include/asm-i386/fb.h
@@ -1,9 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
+extern int fb_is_primary_device(struct fb_info *info);
+
 static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
 				unsigned long off)
 {
diff --git a/include/asm-ia64/fb.h b/include/asm-ia64/fb.h
index c06b45b..33f2ba6 100644
--- a/include/asm-ia64/fb.h
+++ b/include/asm-ia64/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -13,4 +14,9 @@ static inline void fb_pgprotect(struct f
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-m32r/fb.h b/include/asm-m32r/fb.h
index 4bf5b88..d92e99c 100644
--- a/include/asm-m32r/fb.h
+++ b/include/asm-m32r/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -10,4 +11,9 @@ static inline void fb_pgprotect(struct f
 	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-m68k/fb.h b/include/asm-m68k/fb.h
index dc12b5a..6f0c25e 100644
--- a/include/asm-m68k/fb.h
+++ b/include/asm-m68k/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 #include <asm/setup.h>
@@ -24,4 +25,9 @@ static inline void fb_pgprotect(struct f
 }
 #endif /* CONFIG_SUN3 */
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-m68knommu/fb.h b/include/asm-m68knommu/fb.h
index 9f8c88d..f2752d4 100644
--- a/include/asm-m68knommu/fb.h
+++ b/include/asm-m68knommu/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-mips/fb.h b/include/asm-mips/fb.h
index ac23d96..cc740a9 100644
--- a/include/asm-mips/fb.h
+++ b/include/asm-mips/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -10,4 +11,9 @@ static inline void fb_pgprotect(struct f
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-parisc/fb.h b/include/asm-parisc/fb.h
index d5e47ed..4d503a0 100644
--- a/include/asm-parisc/fb.h
+++ b/include/asm-parisc/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -10,4 +11,9 @@ static inline void fb_pgprotect(struct f
 	pgprot_val(vma->vm_page_prot) |= _PAGE_NO_CACHE;
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-powerpc/fb.h b/include/asm-powerpc/fb.h
index e13d6eb..411af8d 100644
--- a/include/asm-powerpc/fb.h
+++ b/include/asm-powerpc/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -12,4 +13,9 @@ static inline void fb_pgprotect(struct f
 						 vma->vm_page_prot);
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-s390/fb.h b/include/asm-s390/fb.h
index 9f8c88d..c7df380 100644
--- a/include/asm-s390/fb.h
+++ b/include/asm-s390/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-sh/fb.h b/include/asm-sh/fb.h
index 4bf5b88..d92e99c 100644
--- a/include/asm-sh/fb.h
+++ b/include/asm-sh/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -10,4 +11,9 @@ static inline void fb_pgprotect(struct f
 	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-sh64/fb.h b/include/asm-sh64/fb.h
index 4bf5b88..d92e99c 100644
--- a/include/asm-sh64/fb.h
+++ b/include/asm-sh64/fb.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
 
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -10,4 +11,9 @@ static inline void fb_pgprotect(struct f
 	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-sparc/fb.h b/include/asm-sparc/fb.h
index 9f8c88d..c7df380 100644
--- a/include/asm-sparc/fb.h
+++ b/include/asm-sparc/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-sparc64/fb.h b/include/asm-sparc64/fb.h
index 8703c70..d6cd3a1 100644
--- a/include/asm-sparc64/fb.h
+++ b/include/asm-sparc64/fb.h
@@ -1,5 +1,6 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -9,4 +10,9 @@ static inline void fb_pgprotect(struct f
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-v850/fb.h b/include/asm-v850/fb.h
index 9f8c88d..c7df380 100644
--- a/include/asm-v850/fb.h
+++ b/include/asm-v850/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-x86_64/fb.h b/include/asm-x86_64/fb.h
index d30073c..60548e6 100644
--- a/include/asm-x86_64/fb.h
+++ b/include/asm-x86_64/fb.h
@@ -1,6 +1,6 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
-
+#include <linux/fb.h>
 #include <linux/fs.h>
 #include <asm/page.h>
 
@@ -11,4 +11,9 @@ static inline void fb_pgprotect(struct f
 		pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
 }
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
diff --git a/include/asm-xtensa/fb.h b/include/asm-xtensa/fb.h
index 9f8c88d..c7df380 100644
--- a/include/asm-xtensa/fb.h
+++ b/include/asm-xtensa/fb.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_FB_H_
 #define _ASM_FB_H_
+#include <linux/fb.h>
 
 #define fb_pgprotect(...) do {} while (0)
 
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
 #endif /* _ASM_FB_H_ */
