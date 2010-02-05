Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab0BEOhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:37:37 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:49631 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933166Ab0BEOhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:37:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AZCtoyH/aeNKEOX2794kdnc0j1qzvYpFOmABwq8T2e8pu+4tbnxJs2aHp5vJX7uZ42
         ICV1ujj2SDUUjbOkP+wHCcKFF8BycJvrz11/JVCj7yHNDacNCD3C1xrOxh5UfWjZRbcw
         Y895pE3eU/9h7BdF7onrA5v/TNO8qEdBzznmE=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] x86: Merge io.h
Date: Fri,  5 Feb 2010 09:37:09 -0500
Message-Id: <1265380629-3212-8-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265380629-3212-1-git-send-email-brgerst@gmail.com>
References: <1265380629-3212-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

io_32.h and io_64.h are now identical.  Merge them into io.h.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/io.h    |  155 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/include/asm/io_32.h |  161 ------------------------------------------
 arch/x86/include/asm/io_64.h |  161 ------------------------------------------
 3 files changed, 152 insertions(+), 325 deletions(-)
 delete mode 100644 arch/x86/include/asm/io_32.h
 delete mode 100644 arch/x86/include/asm/io_64.h

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 7373932..a1dcfa3 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -1,8 +1,42 @@
 #ifndef _ASM_X86_IO_H
 #define _ASM_X86_IO_H
 
+/*
+ * This file contains the definitions for the x86 IO instructions
+ * inb/inw/inl/outb/outw/outl and the "string versions" of the same
+ * (insb/insw/insl/outsb/outsw/outsl). You can also use "pausing"
+ * versions of the single-IO instructions (inb_p/inw_p/..).
+ *
+ * This file is not meant to be obfuscating: it's just complicated
+ * to (a) handle it all in a way that makes gcc able to optimize it
+ * as well as possible and (b) trying to avoid writing the same thing
+ * over and over again with slight variations and possibly making a
+ * mistake somewhere.
+ */
+
+/*
+ * Thanks to James van Artsdalen for a better timing-fix than
+ * the two short jumps: using outb's to a nonexistent port seems
+ * to guarantee better timings even on fast machines.
+ *
+ * On the other hand, I'd like to be sure of a non-existent port:
+ * I feel a bit unsafe about using 0x80 (should be safe, though)
+ *
+ *		Linus
+ */
+
+ /*
+  *  Bit simplified and optimized by Jan Hubicka
+  *  Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999.
+  *
+  *  isa_memset_io, isa_memcpy_fromio, isa_memcpy_toio added,
+  *  isa_read[wl] and isa_write[wl] fixed
+  *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
+  */
+
 #define ARCH_HAS_IOREMAP_WC
 
+#include <linux/string.h>
 #include <linux/compiler.h>
 #include <asm-generic/int-ll64.h>
 #include <asm/page.h>
@@ -173,11 +207,126 @@ static inline void __iomem *ioremap(resource_size_t offset, unsigned long size)
 extern void iounmap(volatile void __iomem *addr);
 
 
-#ifdef CONFIG_X86_32
-# include "io_32.h"
+#ifdef __KERNEL__
+
+#include <asm-generic/iomap.h>
+
+#include <linux/vmalloc.h>
+
+/*
+ * Convert a virtual cached pointer to an uncached pointer
+ */
+#define xlate_dev_kmem_ptr(p)	p
+
+static inline void
+memset_io(volatile void __iomem *addr, unsigned char val, size_t count)
+{
+	memset((void __force *)addr, val, count);
+}
+
+static inline void
+memcpy_fromio(void *dst, const volatile void __iomem *src, size_t count)
+{
+	memcpy(dst, (const void __force *)src, count);
+}
+
+static inline void
+memcpy_toio(volatile void __iomem *dst, const void *src, size_t count)
+{
+	memcpy((void __force *)dst, src, count);
+}
+
+/*
+ * ISA space is 'always mapped' on a typical x86 system, no need to
+ * explicitly ioremap() it. The fact that the ISA IO space is mapped
+ * to PAGE_OFFSET is pure coincidence - it does not mean ISA values
+ * are physical addresses. The following constant pointer can be
+ * used as the IO-area pointer (it can be iounmapped as well, so the
+ * analogy with PCI is quite large):
+ */
+#define __ISA_IO_base ((char __iomem *)(PAGE_OFFSET))
+
+/*
+ *	Cache management
+ *
+ *	This needed for two cases
+ *	1. Out of order aware processors
+ *	2. Accidentally out of order processors (PPro errata #51)
+ */
+
+static inline void flush_write_buffers(void)
+{
+#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
+	asm volatile("lock; addl $0,0(%%esp)": : :"memory");
+#endif
+}
+
+#endif /* __KERNEL__ */
+
+extern void native_io_delay(void);
+
+extern int io_delay_type;
+extern void io_delay_init(void);
+
+#if defined(CONFIG_PARAVIRT)
+#include <asm/paravirt.h>
 #else
-# include "io_64.h"
+
+static inline void slow_down_io(void)
+{
+	native_io_delay();
+#ifdef REALLY_SLOW_IO
+	native_io_delay();
+	native_io_delay();
+	native_io_delay();
 #endif
+}
+
+#endif
+
+#define BUILDIO(bwl, bw, type)						\
+static inline void out##bwl(unsigned type value, int port)		\
+{									\
+	asm volatile("out" #bwl " %" #bw "0, %w1"			\
+		     : : "a"(value), "Nd"(port));			\
+}									\
+									\
+static inline unsigned type in##bwl(int port)				\
+{									\
+	unsigned type value;						\
+	asm volatile("in" #bwl " %w1, %" #bw "0"			\
+		     : "=a"(value) : "Nd"(port));			\
+	return value;							\
+}									\
+									\
+static inline void out##bwl##_p(unsigned type value, int port)		\
+{									\
+	out##bwl(value, port);						\
+	slow_down_io();							\
+}									\
+									\
+static inline unsigned type in##bwl##_p(int port)			\
+{									\
+	unsigned type value = in##bwl(port);				\
+	slow_down_io();							\
+	return value;							\
+}									\
+									\
+static inline void outs##bwl(int port, const void *addr, unsigned long count) \
+{									\
+	asm volatile("rep; outs" #bwl					\
+		     : "+S"(addr), "+c"(count) : "d"(port));		\
+}									\
+									\
+static inline void ins##bwl(int port, void *addr, unsigned long count)	\
+{									\
+	asm volatile("rep; ins" #bwl					\
+		     : "+D"(addr), "+c"(count) : "d"(port));		\
+}
+
+BUILDIO(b, b, char)
+BUILDIO(w, w, short)
+BUILDIO(l, , int)
 
 extern void *xlate_dev_mem_ptr(unsigned long phys);
 extern void unxlate_dev_mem_ptr(unsigned long phys, void *addr);
diff --git a/arch/x86/include/asm/io_32.h b/arch/x86/include/asm/io_32.h
deleted file mode 100644
index e8177f3..0000000
--- a/arch/x86/include/asm/io_32.h
+++ /dev/null
@@ -1,161 +0,0 @@
-#ifndef _ASM_X86_IO_32_H
-#define _ASM_X86_IO_32_H
-
-#include <linux/string.h>
-#include <linux/compiler.h>
-
-/*
- * This file contains the definitions for the x86 IO instructions
- * inb/inw/inl/outb/outw/outl and the "string versions" of the same
- * (insb/insw/insl/outsb/outsw/outsl). You can also use "pausing"
- * versions of the single-IO instructions (inb_p/inw_p/..).
- *
- * This file is not meant to be obfuscating: it's just complicated
- * to (a) handle it all in a way that makes gcc able to optimize it
- * as well as possible and (b) trying to avoid writing the same thing
- * over and over again with slight variations and possibly making a
- * mistake somewhere.
- */
-
-/*
- * Thanks to James van Artsdalen for a better timing-fix than
- * the two short jumps: using outb's to a nonexistent port seems
- * to guarantee better timings even on fast machines.
- *
- * On the other hand, I'd like to be sure of a non-existent port:
- * I feel a bit unsafe about using 0x80 (should be safe, though)
- *
- *		Linus
- */
-
- /*
-  *  Bit simplified and optimized by Jan Hubicka
-  *  Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999.
-  *
-  *  isa_memset_io, isa_memcpy_fromio, isa_memcpy_toio added,
-  *  isa_read[wl] and isa_write[wl] fixed
-  *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
-  */
-
-#ifdef __KERNEL__
-
-#include <asm-generic/iomap.h>
-
-#include <linux/vmalloc.h>
-
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
-static inline void
-memset_io(volatile void __iomem *addr, unsigned char val, size_t count)
-{
-	memset((void __force *)addr, val, count);
-}
-
-static inline void
-memcpy_fromio(void *dst, const volatile void __iomem *src, size_t count)
-{
-	memcpy(dst, (const void __force *)src, count);
-}
-
-static inline void
-memcpy_toio(volatile void __iomem *dst, const void *src, size_t count)
-{
-	memcpy((void __force *)dst, src, count);
-}
-
-/*
- * ISA space is 'always mapped' on a typical x86 system, no need to
- * explicitly ioremap() it. The fact that the ISA IO space is mapped
- * to PAGE_OFFSET is pure coincidence - it does not mean ISA values
- * are physical addresses. The following constant pointer can be
- * used as the IO-area pointer (it can be iounmapped as well, so the
- * analogy with PCI is quite large):
- */
-#define __ISA_IO_base ((char __iomem *)(PAGE_OFFSET))
-
-/*
- *	Cache management
- *
- *	This needed for two cases
- *	1. Out of order aware processors
- *	2. Accidentally out of order processors (PPro errata #51)
- */
-
-static inline void flush_write_buffers(void)
-{
-#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
-	asm volatile("lock; addl $0,0(%%esp)": : :"memory");
-#endif
-}
-
-#endif /* __KERNEL__ */
-
-extern void native_io_delay(void);
-
-extern int io_delay_type;
-extern void io_delay_init(void);
-
-#if defined(CONFIG_PARAVIRT)
-#include <asm/paravirt.h>
-#else
-
-static inline void slow_down_io(void)
-{
-	native_io_delay();
-#ifdef REALLY_SLOW_IO
-	native_io_delay();
-	native_io_delay();
-	native_io_delay();
-#endif
-}
-
-#endif
-
-#define BUILDIO(bwl, bw, type)						\
-static inline void out##bwl(unsigned type value, int port)		\
-{									\
-	asm volatile("out" #bwl " %" #bw "0, %w1"			\
-		     : : "a"(value), "Nd"(port));			\
-}									\
-									\
-static inline unsigned type in##bwl(int port)				\
-{									\
-	unsigned type value;						\
-	asm volatile("in" #bwl " %w1, %" #bw "0"			\
-		     : "=a"(value) : "Nd"(port));			\
-	return value;							\
-}									\
-									\
-static inline void out##bwl##_p(unsigned type value, int port)		\
-{									\
-	out##bwl(value, port);						\
-	slow_down_io();							\
-}									\
-									\
-static inline unsigned type in##bwl##_p(int port)			\
-{									\
-	unsigned type value = in##bwl(port);				\
-	slow_down_io();							\
-	return value;							\
-}									\
-									\
-static inline void outs##bwl(int port, const void *addr, unsigned long count) \
-{									\
-	asm volatile("rep; outs" #bwl					\
-		     : "+S"(addr), "+c"(count) : "d"(port));		\
-}									\
-									\
-static inline void ins##bwl(int port, void *addr, unsigned long count)	\
-{									\
-	asm volatile("rep; ins" #bwl					\
-		     : "+D"(addr), "+c"(count) : "d"(port));		\
-}
-
-BUILDIO(b, b, char)
-BUILDIO(w, w, short)
-BUILDIO(l, , int)
-
-#endif /* _ASM_X86_IO_32_H */
diff --git a/arch/x86/include/asm/io_64.h b/arch/x86/include/asm/io_64.h
deleted file mode 100644
index 6964a1c..0000000
--- a/arch/x86/include/asm/io_64.h
+++ /dev/null
@@ -1,161 +0,0 @@
-#ifndef _ASM_X86_IO_64_H
-#define _ASM_X86_IO_64_H
-
-#include <linux/string.h>
-#include <linux/compiler.h>
-
-/*
- * This file contains the definitions for the x86 IO instructions
- * inb/inw/inl/outb/outw/outl and the "string versions" of the same
- * (insb/insw/insl/outsb/outsw/outsl). You can also use "pausing"
- * versions of the single-IO instructions (inb_p/inw_p/..).
- *
- * This file is not meant to be obfuscating: it's just complicated
- * to (a) handle it all in a way that makes gcc able to optimize it
- * as well as possible and (b) trying to avoid writing the same thing
- * over and over again with slight variations and possibly making a
- * mistake somewhere.
- */
-
-/*
- * Thanks to James van Artsdalen for a better timing-fix than
- * the two short jumps: using outb's to a nonexistent port seems
- * to guarantee better timings even on fast machines.
- *
- * On the other hand, I'd like to be sure of a non-existent port:
- * I feel a bit unsafe about using 0x80 (should be safe, though)
- *
- *		Linus
- */
-
- /*
-  *  Bit simplified and optimized by Jan Hubicka
-  *  Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999.
-  *
-  *  isa_memset_io, isa_memcpy_fromio, isa_memcpy_toio added,
-  *  isa_read[wl] and isa_write[wl] fixed
-  *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
-  */
-
-#ifdef __KERNEL__
-
-#include <asm-generic/iomap.h>
-
-#include <linux/vmalloc.h>
-
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
-static inline void
-memset_io(volatile void __iomem *addr, unsigned char val, size_t count)
-{
-	memset((void __force *)addr, val, count);
-}
-
-static inline void
-memcpy_fromio(void *dst, const volatile void __iomem *src, size_t count)
-{
-	memcpy(dst, (const void __force *)src, count);
-}
-
-static inline void
-memcpy_toio(volatile void __iomem *dst, const void *src, size_t count)
-{
-	memcpy((void __force *)dst, src, count);
-}
-
-/*
- * ISA space is 'always mapped' on a typical x86 system, no need to
- * explicitly ioremap() it. The fact that the ISA IO space is mapped
- * to PAGE_OFFSET is pure coincidence - it does not mean ISA values
- * are physical addresses. The following constant pointer can be
- * used as the IO-area pointer (it can be iounmapped as well, so the
- * analogy with PCI is quite large):
- */
-#define __ISA_IO_base ((char __iomem *)(PAGE_OFFSET))
-
-/*
- *	Cache management
- *
- *	This needed for two cases
- *	1. Out of order aware processors
- *	2. Accidentally out of order processors (PPro errata #51)
- */
-
-static inline void flush_write_buffers(void)
-{
-#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
-	asm volatile("lock; addl $0,0(%%esp)": : :"memory");
-#endif
-}
-
-#endif /* __KERNEL__ */
-
-extern void native_io_delay(void);
-
-extern int io_delay_type;
-extern void io_delay_init(void);
-
-#if defined(CONFIG_PARAVIRT)
-#include <asm/paravirt.h>
-#else
-
-static inline void slow_down_io(void)
-{
-	native_io_delay();
-#ifdef REALLY_SLOW_IO
-	native_io_delay();
-	native_io_delay();
-	native_io_delay();
-#endif
-}
-
-#endif
-
-#define BUILDIO(bwl, bw, type)						\
-static inline void out##bwl(unsigned type value, int port)		\
-{									\
-	asm volatile("out" #bwl " %" #bw "0, %w1"			\
-		     : : "a"(value), "Nd"(port));			\
-}									\
-									\
-static inline unsigned type in##bwl(int port)				\
-{									\
-	unsigned type value;						\
-	asm volatile("in" #bwl " %w1, %" #bw "0"			\
-		     : "=a"(value) : "Nd"(port));			\
-	return value;							\
-}									\
-									\
-static inline void out##bwl##_p(unsigned type value, int port)		\
-{									\
-	out##bwl(value, port);						\
-	slow_down_io();							\
-}									\
-									\
-static inline unsigned type in##bwl##_p(int port)			\
-{									\
-	unsigned type value = in##bwl(port);				\
-	slow_down_io();							\
-	return value;							\
-}									\
-									\
-static inline void outs##bwl(int port, const void *addr, unsigned long count) \
-{									\
-	asm volatile("rep; outs" #bwl					\
-		     : "+S"(addr), "+c"(count) : "d"(port));		\
-}									\
-									\
-static inline void ins##bwl(int port, void *addr, unsigned long count)	\
-{									\
-	asm volatile("rep; ins" #bwl					\
-		     : "+D"(addr), "+c"(count) : "d"(port));		\
-}
-
-BUILDIO(b, b, char)
-BUILDIO(w, w, short)
-BUILDIO(l, , int)
-
-#endif /* _ASM_X86_IO_64_H */
-- 
1.6.6

