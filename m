Return-Path: <linux-kernel-owner+w=401wt.eu-S1762819AbXGJDXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762819AbXGJDXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759997AbXGJDXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:23:40 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49737 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038AbXGJDXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:23:39 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 14/33] Top header file for new x86 setup code
Date: Mon,  9 Jul 2007 19:51:53 -0700
Message-Id: <11840374052662-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840373002601-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com>
 <11840363531039-git-send-email-hpa@zytor.com>
 <11840364593068-git-send-email-hpa@zytor.com>
 <1184036564610-git-send-email-hpa@zytor.com>
 <11840366692770-git-send-email-hpa@zytor.com>
 <11840367741994-git-send-email-hpa@zytor.com>
 <11840368791603-git-send-email-hpa@zytor.com>
 <11840369841576-git-send-email-hpa@zytor.com>
 <11840370903975-git-send-email-hpa@zytor.com>
 <11840371953778-git-send-email-hpa@zytor.com>
 <11840373002601-git-send-email-hpa@zytor.com>
Message-Id: <a862328acf06a9587458c615848099f96fbab1ce.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Top header file for the new x86 setup code.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/boot.h |  290 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 290 insertions(+), 0 deletions(-)
 create mode 100644 arch/i386/boot/boot.h

diff --git a/arch/i386/boot/boot.h b/arch/i386/boot/boot.h
new file mode 100644
index 0000000..7251ef6
--- /dev/null
+++ b/arch/i386/boot/boot.h
@@ -0,0 +1,290 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * arch/i386/boot/boot.h
+ *
+ * Header file for the real-mode kernel code
+ */
+
+#ifndef BOOT_BOOT_H
+#define BOOT_BOOT_H
+
+#ifndef __ASSEMBLY__
+
+#include <stdarg.h>
+#include <linux/types.h>
+#include <linux/edd.h>
+#include <asm/boot.h>
+#include <asm/bootparam.h>
+
+/* Useful macros */
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+
+extern struct setup_header hdr;
+extern struct boot_params boot_params;
+
+/* Basic port I/O */
+static inline void outb(u8 v, u16 port)
+{
+	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
+}
+static inline u8 inb(u16 port)
+{
+	u8 v;
+	asm volatile("inb %1,%0" : "=a" (v) : "dN" (port));
+	return v;
+}
+
+static inline void outw(u16 v, u16 port)
+{
+	asm volatile("outw %0,%1" : : "a" (v), "dN" (port));
+}
+static inline u16 inw(u16 port)
+{
+	u16 v;
+	asm volatile("inw %1,%0" : "=a" (v) : "dN" (port));
+	return v;
+}
+
+static inline void outl(u32 v, u16 port)
+{
+	asm volatile("outl %0,%1" : : "a" (v), "dn" (port));
+}
+static inline u32 inl(u32 port)
+{
+	u32 v;
+	asm volatile("inl %1,%0" : "=a" (v) : "dN" (port));
+	return v;
+}
+
+static inline void io_delay(void)
+{
+	const u16 DELAY_PORT = 0x80;
+	asm volatile("outb %%al,%0" : : "dN" (DELAY_PORT));
+}
+
+/* These functions are used to reference data in other segments. */
+
+static inline u16 ds(void)
+{
+	u16 seg;
+	asm("movw %%ds,%0" : "=rm" (seg));
+	return seg;
+}
+
+static inline void set_fs(u16 seg)
+{
+	asm volatile("movw %0,%%fs" : : "rm" (seg));
+}
+static inline u16 fs(void)
+{
+	u16 seg;
+	asm("movw %%fs,%0" : "=rm" (seg));
+	return seg;
+}
+
+static inline void set_gs(u16 seg)
+{
+	asm volatile("movw %0,%%gs" : : "rm" (seg));
+}
+static inline u16 gs(void)
+{
+	u16 seg;
+	asm("movw %%gs,%0" : "=rm" (seg));
+	return seg;
+}
+
+typedef unsigned int addr_t;
+
+static inline u8 rdfs8(addr_t addr)
+{
+	u8 v;
+	asm("movb %%fs:%1,%0" : "=r" (v) : "m" (*(u8 *)addr));
+	return v;
+}
+static inline u16 rdfs16(addr_t addr)
+{
+	u16 v;
+	asm("movw %%fs:%1,%0" : "=r" (v) : "m" (*(u16 *)addr));
+	return v;
+}
+static inline u32 rdfs32(addr_t addr)
+{
+	u32 v;
+	asm("movl %%fs:%1,%0" : "=r" (v) : "m" (*(u32 *)addr));
+	return v;
+}
+
+static inline void wrfs8(u8 v, addr_t addr)
+{
+	asm volatile("movb %1,%%fs:%0" : "+m" (*(u8 *)addr) : "r" (v));
+}
+static inline void wrfs16(u16 v, addr_t addr)
+{
+	asm volatile("movw %1,%%fs:%0" : "+m" (*(u16 *)addr) : "r" (v));
+}
+static inline void wrfs32(u32 v, addr_t addr)
+{
+	asm volatile("movl %1,%%fs:%0" : "+m" (*(u32 *)addr) : "r" (v));
+}
+
+static inline u8 rdgs8(addr_t addr)
+{
+	u8 v;
+	asm("movb %%gs:%1,%0" : "=r" (v) : "m" (*(u8 *)addr));
+	return v;
+}
+static inline u16 rdgs16(addr_t addr)
+{
+	u16 v;
+	asm("movw %%gs:%1,%0" : "=r" (v) : "m" (*(u16 *)addr));
+	return v;
+}
+static inline u32 rdgs32(addr_t addr)
+{
+	u32 v;
+	asm("movl %%gs:%1,%0" : "=r" (v) : "m" (*(u32 *)addr));
+	return v;
+}
+
+static inline void wrgs8(u8 v, addr_t addr)
+{
+	asm volatile("movb %1,%%gs:%0" : "+m" (*(u8 *)addr) : "r" (v));
+}
+static inline void wrgs16(u16 v, addr_t addr)
+{
+	asm volatile("movw %1,%%gs:%0" : "+m" (*(u16 *)addr) : "r" (v));
+}
+static inline void wrgs32(u32 v, addr_t addr)
+{
+	asm volatile("movl %1,%%gs:%0" : "+m" (*(u32 *)addr) : "r" (v));
+}
+
+/* Note: these only return true/false, not a signed return value! */
+static inline int memcmp(const void *s1, const void *s2, size_t len)
+{
+	u8 diff;
+	asm("repe; cmpsb; setnz %0"
+	    : "=qm" (diff), "+D" (s1), "+S" (s2), "+c" (len));
+	return diff;
+}
+
+static inline int memcmp_fs(const void *s1, addr_t s2, size_t len)
+{
+	u8 diff;
+	asm("fs; repe; cmpsb; setnz %0"
+	    : "=qm" (diff), "+D" (s1), "+S" (s2), "+c" (len));
+	return diff;
+}
+static inline int memcmp_gs(const void *s1, addr_t s2, size_t len)
+{
+	u8 diff;
+	asm("gs; repe; cmpsb; setnz %0"
+	    : "=qm" (diff), "+D" (s1), "+S" (s2), "+c" (len));
+	return diff;
+}
+
+/* Heap -- available for dynamic lists. */
+#define STACK_SIZE	512	/* Minimum number of bytes for stack */
+
+extern char _end[];
+extern char *HEAP;
+extern char *heap_end;
+#define RESET_HEAP() ((void *)( HEAP = _end ))
+static inline char *__get_heap(size_t s, size_t a, size_t n)
+{
+	char *tmp;
+
+	HEAP = (char *)(((size_t)HEAP+(a-1)) & ~(a-1));
+	tmp = HEAP;
+	HEAP += s*n;
+	return tmp;
+}
+#define GET_HEAP(type, n) \
+	((type *)__get_heap(sizeof(type),__alignof__(type),(n)))
+
+static inline int heap_free(void)
+{
+	return heap_end-HEAP;
+}
+
+/* copy.S */
+
+void copy_to_fs(addr_t dst, void *src, size_t len);
+void *copy_from_fs(void *dst, addr_t src, size_t len);
+void copy_to_gs(addr_t dst, void *src, size_t len);
+void *copy_from_gs(void *dst, addr_t src, size_t len);
+void *memcpy(void *dst, void *src, size_t len);
+void *memset(void *dst, int c, size_t len);
+
+#define memcpy(d,s,l) __builtin_memcpy(d,s,l)
+#define memset(d,c,l) __builtin_memset(d,c,l)
+
+/* a20.c */
+int enable_a20(void);
+
+/* apm.c */
+int query_apm_bios(void);
+
+/* cmdline.c */
+int cmdline_find_option(const char *option, char *buffer, int bufsize);
+
+/* cpu.c, cpucheck.c */
+int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr);
+int validate_cpu(void);
+
+/* edd.c */
+void query_edd(void);
+
+/* header.S */
+void __attribute__((noreturn)) die(void);
+
+/* mca.c */
+int query_mca(void);
+
+/* memory.c */
+int detect_memory(void);
+
+/* pm.c */
+void __attribute__((noreturn)) go_to_protected_mode(void);
+
+/* pmjump.S */
+void __attribute__((noreturn))
+	protected_mode_jump(u32 entrypoint, u32 bootparams);
+
+/* printf.c */
+unsigned int atou(const char *s);
+int sprintf(char *buf, const char *fmt, ...);
+int vsprintf(char *buf, const char *fmt, va_list args);
+int printf(const char *fmt, ...);
+
+/* string.c */
+int strcmp(const char *str1, const char *str2);
+
+/* tty.c */
+void puts(const char *);
+void putchar(int);
+int getchar(void);
+void kbd_flush(void);
+int getchar_timeout(void);
+
+/* video.c */
+void set_video(void);
+
+/* video-vesa.c */
+void vesa_store_edid(void);
+
+/* voyager.c */
+int query_voyager(void);
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* BOOT_BOOT_H */
-- 
1.5.2.2

