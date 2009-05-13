Return-Path: <linux-kernel-owner+w=401wt.eu-S1761081AbZEMXln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbZEMXln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 19:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbZEMXlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 19:41:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60370 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502AbZEMXlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 19:41:32 -0400
Message-ID: <4A0B5A34.1080301@zytor.com>
Date: Wed, 13 May 2009 16:39:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Hitoshi Mitake <h.mitake@gmail.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
       rpjday@crashcourse.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Remove readq()/writeq() on 32-bit
References: <49EE37AF.4020507@zytor.com>	 <20090421.173123.191021055.davem@davemloft.net>	 <adak55438gp.fsf_-_@cisco.com>	 <20090428.221228.217954247.davem@davemloft.net>	 <20090429115654.GC11586@elte.hu> <49F843BC.7020902@garzik.org>	 <adahc071ie4.fsf@cisco.com> <49F8B1A1.4010208@garzik.org> <a6b9f31a0905122232s2d23b4e3h6e447c3fa5c29ee6@mail.gmail.com> <4A0B2B54.5090803@zytor.com> <4A0B4C1C.9000706@garzik.org>
In-Reply-To: <4A0B4C1C.9000706@garzik.org>
Content-Type: multipart/mixed;
 boundary="------------020401050908010300040302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020401050908010300040302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jeff Garzik wrote:
> 
> Judging from this thread and past, I think people will continue to 
> complain and get confused, even with the above.
> 

Do you really think so?  Seems unfortunate, since an API rename would be
way more invasive.  This is the entirety of the header patch
(compile-tested using 32-bit allyesconfig).

	-hpa


--------------020401050908010300040302
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index df9e885..0be277b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -19,8 +19,6 @@ config X86_64
 config X86
 	def_bool y
 	select HAVE_AOUT if X86_32
-	select HAVE_READQ
-	select HAVE_WRITEQ
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 7373932..199c7b9 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -51,27 +51,6 @@ build_mmio_write(__writel, "l", unsigned int, "r", )
 build_mmio_read(readq, "q", unsigned long, "=r", :"memory")
 build_mmio_write(writeq, "q", unsigned long, "r", :"memory")
 
-#else
-
-static inline __u64 readq(const volatile void __iomem *addr)
-{
-	const volatile u32 __iomem *p = addr;
-	u32 low, high;
-
-	low = readl(p);
-	high = readl(p + 1);
-
-	return low + ((u64)high << 32);
-}
-
-static inline void writeq(__u64 val, volatile void __iomem *addr)
-{
-	writel(val, addr);
-	writel(val >> 32, addr+4);
-}
-
-#endif
-
 #define readq_relaxed(a)	readq(a)
 
 #define __raw_readq(a)		readq(a)
@@ -81,6 +60,8 @@ static inline void writeq(__u64 val, volatile void __iomem *addr)
 #define readq			readq
 #define writeq			writeq
 
+#endif
+
 /**
  *	virt_to_phys	-	map virtual addresses to physical
  *	@address: address to remap
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 2506592..43f14f5 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -33,6 +33,7 @@
 #include "i915_reg.h"
 #include "intel_bios.h"
 #include <linux/io-mapping.h>
+#include <linux/io64_lh.h>	/* Simulate 64-bit I/O on 32 bits */
 
 /* General customization:
  */
@@ -705,13 +706,7 @@ extern void intel_modeset_cleanup(struct drm_device *dev);
 #define I915_WRITE16(reg, val)	writel(val, dev_priv->regs + (reg))
 #define I915_READ8(reg)		readb(dev_priv->regs + (reg))
 #define I915_WRITE8(reg, val)	writeb(val, dev_priv->regs + (reg))
-#ifdef writeq
 #define I915_WRITE64(reg, val)	writeq(val, dev_priv->regs + (reg))
-#else
-#define I915_WRITE64(reg, val)	(writel(val, dev_priv->regs + (reg)), \
-				 writel(upper_32_bits(val), dev_priv->regs + \
-					(reg) + 4))
-#endif
 #define POSTING_READ(reg)	(void)I915_READ(reg)
 
 #define I915_VERBOSE 0
diff --git a/include/drm/drm_os_linux.h b/include/drm/drm_os_linux.h
index 26641e9..3925946 100644
--- a/include/drm/drm_os_linux.h
+++ b/include/drm/drm_os_linux.h
@@ -5,19 +5,7 @@
 
 #include <linux/interrupt.h>	/* For task queue support */
 #include <linux/delay.h>
-
-#ifndef readq
-static inline u64 readq(void __iomem *reg)
-{
-	return ((u64) readl(reg)) | (((u64) readl(reg + 4UL)) << 32);
-}
-
-static inline void writeq(u64 val, void __iomem *reg)
-{
-	writel(val & 0xffffffff, reg);
-	writel(val >> 32, reg + 0x4UL);
-}
-#endif
+#include <linux/io64_lh.h>	/* Simulate 64-bit I/O on 32 bits */
 
 /** Current process ID */
 #define DRM_CURRENTPID			task_pid_nr(current)
diff --git a/include/linux/io64_lh.h b/include/linux/io64_lh.h
new file mode 100644
index 0000000..361931b
--- /dev/null
+++ b/include/linux/io64_lh.h
@@ -0,0 +1,74 @@
+/* ----------------------------------------------------------------------- *
+ *
+ *  Copyright (C) 2009 Intel Corporation. All rights reserved.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License version
+ *  2 as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA.
+ *
+ *  H. Peter Anvin <hpa@linux.intel.com>
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * io64_lh.h
+ *
+ * One possible implementation of readq()/writeq() on 32-bit platforms.
+ * Emulate 64-bit I/O using nonatomic low-high 32-bit references.
+ */
+
+#ifndef _LINUX_IO64_LH_H
+#define _LINUX_IO64_LH_H
+
+#include <linux/io.h>
+#include <linux/types.h>
+
+#ifndef readq
+static inline __u64 readq(const volatile void __iomem *addr)
+{
+	const volatile u32 __iomem *p = addr;
+	u32 l, h;
+
+	l = readl(p);
+	h = readl(p + 1);
+
+	return l + ((u64)h << 32);
+}
+#define readq		readq
+
+static inline __u64 readq_relaxed(const volatile void __iomem *addr)
+{
+	const volatile u32 __iomem *p = addr;
+	u32 l, h;
+
+	l = readl_relaxed(p);
+	h = readl_relaxed(p + 1);
+
+	return l + ((u64)h << 32);
+}
+#define readq_relaxed	readq_relaxed
+
+#endif /* readq */
+
+#ifndef writeq
+
+static inline void writeq(__u64 val, volatile void __iomem *addr)
+{
+	writel(val, addr);
+	writel(val >> 32, addr+4);
+}
+#define writeq		writeq
+
+#endif /* writeq */
+
+#endif /* _LINUX_IO64_LH_H */

--------------020401050908010300040302--
