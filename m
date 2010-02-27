Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968521Ab0B0PVE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 10:21:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35939 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966882Ab0B0PVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 10:21:00 -0500
Date: Sat, 27 Feb 2010 16:20:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/io changes for v2.6.34
Message-ID: <20100227152050.GA12552@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-io-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-io-for-linus

 Thanks,

	Ingo

------------------>
Brian Gerst (7):
      x86-32: Move XQUAD definitions to numaq.h
      x86-32: Remove _local variants of in/out from io_32.h
      x86-64: Reorganize io_64.h
      x86-64: Use BUILDIO in io_64.h
      x86: Clean up mem*io functions.
      x86: Simplify flush_write_buffers()
      x86: Merge io.h


 arch/x86/boot/compressed/misc.c |   13 +--
 arch/x86/include/asm/io.h       |  155 ++++++++++++++++++++++++++++++-
 arch/x86/include/asm/io_32.h    |  196 ---------------------------------------
 arch/x86/include/asm/io_64.h    |  181 ------------------------------------
 arch/x86/include/asm/numaq.h    |    4 +
 arch/x86/lib/Makefile           |    2 +-
 arch/x86/lib/io_64.c            |   25 -----
 arch/x86/pci/numaq_32.c         |    6 +-
 8 files changed, 162 insertions(+), 420 deletions(-)
 delete mode 100644 arch/x86/include/asm/io_32.h
 delete mode 100644 arch/x86/include/asm/io_64.h
 delete mode 100644 arch/x86/lib/io_64.c

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 3b22fe8..88042e8 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -19,11 +19,6 @@
 #define _ASM_X86_DESC_H 1
 #endif
 
-#ifdef CONFIG_X86_64
-#define _LINUX_STRING_H_ 1
-#define __LINUX_BITMAP_H 1
-#endif
-
 #include <linux/linkage.h>
 #include <linux/screen_info.h>
 #include <linux/elf.h>
@@ -131,8 +126,8 @@ static void error(char *m);
 static struct boot_params *real_mode;		/* Pointer to real-mode data */
 static int quiet;
 
-static void *memset(void *s, int c, unsigned n);
-void *memcpy(void *dest, const void *src, unsigned n);
+void *memset(void *s, int c, size_t n);
+void *memcpy(void *dest, const void *src, size_t n);
 
 static void __putstr(int, const char *);
 #define putstr(__x)  __putstr(0, __x)
@@ -223,7 +218,7 @@ static void __putstr(int error, const char *s)
 	outb(0xff & (pos >> 1), vidport+1);
 }
 
-static void *memset(void *s, int c, unsigned n)
+void *memset(void *s, int c, size_t n)
 {
 	int i;
 	char *ss = s;
@@ -233,7 +228,7 @@ static void *memset(void *s, int c, unsigned n)
 	return s;
 }
 
-void *memcpy(void *dest, const void *src, unsigned n)
+void *memcpy(void *dest, const void *src, size_t n)
 {
 	int i;
 	const char *s = src;
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
index a299900..0000000
--- a/arch/x86/include/asm/io_32.h
+++ /dev/null
@@ -1,196 +0,0 @@
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
-#define XQUAD_PORTIO_BASE 0xfe400000
-#define XQUAD_PORTIO_QUAD 0x40000  /* 256k per quad. */
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
-memset_io(volatile void __iomem *addr, unsigned char val, int count)
-{
-	memset((void __force *)addr, val, count);
-}
-
-static inline void
-memcpy_fromio(void *dst, const volatile void __iomem *src, int count)
-{
-	__memcpy(dst, (const void __force *)src, count);
-}
-
-static inline void
-memcpy_toio(volatile void __iomem *dst, const void *src, int count)
-{
-	__memcpy((void __force *)dst, src, count);
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
-#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
-
-static inline void flush_write_buffers(void)
-{
-	asm volatile("lock; addl $0,0(%%esp)": : :"memory");
-}
-
-#else
-
-#define flush_write_buffers() do { } while (0)
-
-#endif
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
-#define __BUILDIO(bwl, bw, type)				\
-static inline void out##bwl(unsigned type value, int port)	\
-{								\
-	out##bwl##_local(value, port);				\
-}								\
-								\
-static inline unsigned type in##bwl(int port)			\
-{								\
-	return in##bwl##_local(port);				\
-}
-
-#define BUILDIO(bwl, bw, type)						\
-static inline void out##bwl##_local(unsigned type value, int port)	\
-{									\
-	asm volatile("out" #bwl " %" #bw "0, %w1"		\
-		     : : "a"(value), "Nd"(port));			\
-}									\
-									\
-static inline unsigned type in##bwl##_local(int port)			\
-{									\
-	unsigned type value;						\
-	asm volatile("in" #bwl " %w1, %" #bw "0"		\
-		     : "=a"(value) : "Nd"(port));			\
-	return value;							\
-}									\
-									\
-static inline void out##bwl##_local_p(unsigned type value, int port)	\
-{									\
-	out##bwl##_local(value, port);					\
-	slow_down_io();							\
-}									\
-									\
-static inline unsigned type in##bwl##_local_p(int port)			\
-{									\
-	unsigned type value = in##bwl##_local(port);			\
-	slow_down_io();							\
-	return value;							\
-}									\
-									\
-__BUILDIO(bwl, bw, type)						\
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
index 2440678..0000000
--- a/arch/x86/include/asm/io_64.h
+++ /dev/null
@@ -1,181 +0,0 @@
-#ifndef _ASM_X86_IO_64_H
-#define _ASM_X86_IO_64_H
-
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
-#endif
-
-/*
- * Talk about misusing macros..
- */
-#define __OUT1(s, x)							\
-static inline void out##s(unsigned x value, unsigned short port) {
-
-#define __OUT2(s, s1, s2)				\
-asm volatile ("out" #s " %" s1 "0,%" s2 "1"
-
-#ifndef REALLY_SLOW_IO
-#define REALLY_SLOW_IO
-#define UNSET_REALLY_SLOW_IO
-#endif
-
-#define __OUT(s, s1, x)							\
-	__OUT1(s, x) __OUT2(s, s1, "w") : : "a" (value), "Nd" (port));	\
-	}								\
-	__OUT1(s##_p, x) __OUT2(s, s1, "w") : : "a" (value), "Nd" (port)); \
-	slow_down_io();							\
-}
-
-#define __IN1(s)							\
-static inline RETURN_TYPE in##s(unsigned short port)			\
-{									\
-	RETURN_TYPE _v;
-
-#define __IN2(s, s1, s2)						\
-	asm volatile ("in" #s " %" s2 "1,%" s1 "0"
-
-#define __IN(s, s1, i...)						\
-	__IN1(s) __IN2(s, s1, "w") : "=a" (_v) : "Nd" (port), ##i);	\
-	return _v;							\
-	}								\
-	__IN1(s##_p) __IN2(s, s1, "w") : "=a" (_v) : "Nd" (port), ##i);	\
-	slow_down_io(); \
-	return _v; }
-
-#ifdef UNSET_REALLY_SLOW_IO
-#undef REALLY_SLOW_IO
-#endif
-
-#define __INS(s)							\
-static inline void ins##s(unsigned short port, void *addr,		\
-			  unsigned long count)				\
-{									\
-	asm volatile ("rep ; ins" #s					\
-		      : "=D" (addr), "=c" (count)			\
-		      : "d" (port), "0" (addr), "1" (count));		\
-}
-
-#define __OUTS(s)							\
-static inline void outs##s(unsigned short port, const void *addr,	\
-			   unsigned long count)				\
-{									\
-	asm volatile ("rep ; outs" #s					\
-		      : "=S" (addr), "=c" (count)			\
-		      : "d" (port), "0" (addr), "1" (count));		\
-}
-
-#define RETURN_TYPE unsigned char
-__IN(b, "")
-#undef RETURN_TYPE
-#define RETURN_TYPE unsigned short
-__IN(w, "")
-#undef RETURN_TYPE
-#define RETURN_TYPE unsigned int
-__IN(l, "")
-#undef RETURN_TYPE
-
-__OUT(b, "b", char)
-__OUT(w, "w", short)
-__OUT(l, , int)
-
-__INS(b)
-__INS(w)
-__INS(l)
-
-__OUTS(b)
-__OUTS(w)
-__OUTS(l)
-
-#if defined(__KERNEL__) && defined(__x86_64__)
-
-#include <linux/vmalloc.h>
-
-#include <asm-generic/iomap.h>
-
-void __memcpy_fromio(void *, unsigned long, unsigned);
-void __memcpy_toio(unsigned long, const void *, unsigned);
-
-static inline void memcpy_fromio(void *to, const volatile void __iomem *from,
-				 unsigned len)
-{
-	__memcpy_fromio(to, (unsigned long)from, len);
-}
-
-static inline void memcpy_toio(volatile void __iomem *to, const void *from,
-			       unsigned len)
-{
-	__memcpy_toio((unsigned long)to, from, len);
-}
-
-void memset_io(volatile void __iomem *a, int b, size_t c);
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
-#define flush_write_buffers()
-
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
-#endif /* __KERNEL__ */
-
-#endif /* _ASM_X86_IO_64_H */
diff --git a/arch/x86/include/asm/numaq.h b/arch/x86/include/asm/numaq.h
index 9f0a5f5..13370b9 100644
--- a/arch/x86/include/asm/numaq.h
+++ b/arch/x86/include/asm/numaq.h
@@ -33,6 +33,10 @@ extern int get_memcfg_numaq(void);
 
 extern void *xquad_portio;
 
+#define XQUAD_PORTIO_BASE 0xfe400000
+#define XQUAD_PORTIO_QUAD 0x40000  /* 256k per quad. */
+#define XQUAD_PORT_ADDR(port, quad) (xquad_portio + (XQUAD_PORTIO_QUAD*quad) + port)
+
 /*
  * SYS_CFG_DATA_PRIV_ADDR, struct eachquadmem, and struct sys_cfg_data are the
  */
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index cffd754..fff1427 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -34,7 +34,7 @@ ifneq ($(CONFIG_X86_CMPXCHG64),y)
 endif
         lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
 else
-        obj-y += io_64.o iomap_copy_64.o
+        obj-y += iomap_copy_64.o
         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
         lib-y += memmove_64.o memset_64.o
diff --git a/arch/x86/lib/io_64.c b/arch/x86/lib/io_64.c
deleted file mode 100644
index 3f1eb59..0000000
--- a/arch/x86/lib/io_64.c
+++ /dev/null
@@ -1,25 +0,0 @@
-#include <linux/string.h>
-#include <linux/module.h>
-#include <asm/io.h>
-
-void __memcpy_toio(unsigned long dst, const void *src, unsigned len)
-{
-	__inline_memcpy((void *)dst, src, len);
-}
-EXPORT_SYMBOL(__memcpy_toio);
-
-void __memcpy_fromio(void *dst, unsigned long src, unsigned len)
-{
-	__inline_memcpy(dst, (const void *)src, len);
-}
-EXPORT_SYMBOL(__memcpy_fromio);
-
-void memset_io(volatile void __iomem *a, int b, size_t c)
-{
-	/*
-	 * TODO: memset can mangle the IO patterns quite a bit.
-	 * perhaps it would be better to use a dumb one:
-	 */
-	memset((void *)a, b, c);
-}
-EXPORT_SYMBOL(memset_io);
diff --git a/arch/x86/pci/numaq_32.c b/arch/x86/pci/numaq_32.c
index 8eb295e..8884a1c 100644
--- a/arch/x86/pci/numaq_32.c
+++ b/arch/x86/pci/numaq_32.c
@@ -8,9 +8,7 @@
 #include <asm/apic.h>
 #include <asm/mpspec.h>
 #include <asm/pci_x86.h>
-
-#define XQUAD_PORTIO_BASE 0xfe400000
-#define XQUAD_PORTIO_QUAD 0x40000  /* 256k per quad. */
+#include <asm/numaq.h>
 
 #define BUS2QUAD(global) (mp_bus_id_to_node[global])
 
@@ -18,8 +16,6 @@
 
 #define QUADLOCAL2BUS(quad,local) (quad_local_to_mp_bus_id[quad][local])
 
-#define XQUAD_PORT_ADDR(port, quad) (xquad_portio + (XQUAD_PORTIO_QUAD*quad) + port)
-
 #define PCI_CONF1_MQ_ADDRESS(bus, devfn, reg) \
 	(0x80000000 | (BUS2LOCAL(bus) << 16) | (devfn << 8) | (reg & ~3))
 
