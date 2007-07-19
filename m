Return-Path: <linux-kernel-owner+w=401wt.eu-S1764467AbXGSKAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764467AbXGSKAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbXGSJy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:54:58 -0400
Received: from ns.suse.de ([195.135.220.2]:35340 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbXGSJy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:54:56 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [10/58] i386: Move all simple string operations out of line
Message-Id: <20070719095454.621C614E04@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:54:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The compiler generally generates reasonable inline code for the simple
cases and for the rest it's better for code size for them to be out of line.
Also there they can be potentially optimized more in the future.

In fact they probably should be in a .S file because they're all pure
assembly, but that's for another day.

Also some code style cleanup on them while I was on it (this seems
to be the last untouched really early Linux code) 

This saves ~12k text for a defconfig kernel with gcc 4.1.


Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/lib/Makefile    |    2 
 arch/i386/lib/string.c    |  233 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-i386/string.h |  243 ++--------------------------------------------
 3 files changed, 247 insertions(+), 231 deletions(-)

Index: linux/include/asm-i386/string.h
===================================================================
--- linux.orig/include/asm-i386/string.h
+++ linux/include/asm-i386/string.h
@@ -2,203 +2,35 @@
 #define _I386_STRING_H_
 
 #ifdef __KERNEL__
-/*
- * On a 486 or Pentium, we are better off not using the
- * byte string operations. But on a 386 or a PPro the
- * byte string ops are faster than doing it by hand
- * (MUCH faster on a Pentium).
- */
-
-/*
- * This string-include defines all string functions as inline
- * functions. Use gcc. It also assumes ds=es=data space, this should be
- * normal. Most of the string-functions are rather heavily hand-optimized,
- * see especially strsep,strstr,str[c]spn. They should work, but are not
- * very easy to understand. Everything is done entirely within the register
- * set, making the functions fast and clean. String instructions have been
- * used through-out, making for "slightly" unclear code :-)
- *
- *		NO Copyright (C) 1991, 1992 Linus Torvalds,
- *		consider these trivial functions to be PD.
- */
 
-/* AK: in fact I bet it would be better to move this stuff all out of line.
- */
+/* Let gcc decide wether to inline or use the out of line functions */
 
 #define __HAVE_ARCH_STRCPY
-static inline char * strcpy(char * dest,const char *src)
-{
-int d0, d1, d2;
-__asm__ __volatile__(
-	"1:\tlodsb\n\t"
-	"stosb\n\t"
-	"testb %%al,%%al\n\t"
-	"jne 1b"
-	: "=&S" (d0), "=&D" (d1), "=&a" (d2)
-	:"0" (src),"1" (dest) : "memory");
-return dest;
-}
+extern char *strcpy(char *dest, const char *src);
 
 #define __HAVE_ARCH_STRNCPY
-static inline char * strncpy(char * dest,const char *src,size_t count)
-{
-int d0, d1, d2, d3;
-__asm__ __volatile__(
-	"1:\tdecl %2\n\t"
-	"js 2f\n\t"
-	"lodsb\n\t"
-	"stosb\n\t"
-	"testb %%al,%%al\n\t"
-	"jne 1b\n\t"
-	"rep\n\t"
-	"stosb\n"
-	"2:"
-	: "=&S" (d0), "=&D" (d1), "=&c" (d2), "=&a" (d3)
-	:"0" (src),"1" (dest),"2" (count) : "memory");
-return dest;
-}
+extern char *strncpy(char *dest, const char *src, size_t count);
 
 #define __HAVE_ARCH_STRCAT
-static inline char * strcat(char * dest,const char * src)
-{
-int d0, d1, d2, d3;
-__asm__ __volatile__(
-	"repne\n\t"
-	"scasb\n\t"
-	"decl %1\n"
-	"1:\tlodsb\n\t"
-	"stosb\n\t"
-	"testb %%al,%%al\n\t"
-	"jne 1b"
-	: "=&S" (d0), "=&D" (d1), "=&a" (d2), "=&c" (d3)
-	: "0" (src), "1" (dest), "2" (0), "3" (0xffffffffu):"memory");
-return dest;
-}
+extern char *strcat(char *dest, const char *src);
 
 #define __HAVE_ARCH_STRNCAT
-static inline char * strncat(char * dest,const char * src,size_t count)
-{
-int d0, d1, d2, d3;
-__asm__ __volatile__(
-	"repne\n\t"
-	"scasb\n\t"
-	"decl %1\n\t"
-	"movl %8,%3\n"
-	"1:\tdecl %3\n\t"
-	"js 2f\n\t"
-	"lodsb\n\t"
-	"stosb\n\t"
-	"testb %%al,%%al\n\t"
-	"jne 1b\n"
-	"2:\txorl %2,%2\n\t"
-	"stosb"
-	: "=&S" (d0), "=&D" (d1), "=&a" (d2), "=&c" (d3)
-	: "0" (src),"1" (dest),"2" (0),"3" (0xffffffffu), "g" (count)
-	: "memory");
-return dest;
-}
+extern char *strncat(char *dest, const char *src, size_t count);
 
 #define __HAVE_ARCH_STRCMP
-static inline int strcmp(const char * cs,const char * ct)
-{
-int d0, d1;
-register int __res;
-__asm__ __volatile__(
-	"1:\tlodsb\n\t"
-	"scasb\n\t"
-	"jne 2f\n\t"
-	"testb %%al,%%al\n\t"
-	"jne 1b\n\t"
-	"xorl %%eax,%%eax\n\t"
-	"jmp 3f\n"
-	"2:\tsbbl %%eax,%%eax\n\t"
-	"orb $1,%%al\n"
-	"3:"
-	:"=a" (__res), "=&S" (d0), "=&D" (d1)
-	:"1" (cs),"2" (ct)
-	:"memory");
-return __res;
-}
+extern int strcmp(const char *cs, const char *ct);
 
 #define __HAVE_ARCH_STRNCMP
-static inline int strncmp(const char * cs,const char * ct,size_t count)
-{
-register int __res;
-int d0, d1, d2;
-__asm__ __volatile__(
-	"1:\tdecl %3\n\t"
-	"js 2f\n\t"
-	"lodsb\n\t"
-	"scasb\n\t"
-	"jne 3f\n\t"
-	"testb %%al,%%al\n\t"
-	"jne 1b\n"
-	"2:\txorl %%eax,%%eax\n\t"
-	"jmp 4f\n"
-	"3:\tsbbl %%eax,%%eax\n\t"
-	"orb $1,%%al\n"
-	"4:"
-	:"=a" (__res), "=&S" (d0), "=&D" (d1), "=&c" (d2)
-	:"1" (cs),"2" (ct),"3" (count)
-	:"memory");
-return __res;
-}
+extern int strncmp(const char *cs, const char *ct, size_t count);
 
 #define __HAVE_ARCH_STRCHR
-static inline char * strchr(const char * s, int c)
-{
-int d0;
-register char * __res;
-__asm__ __volatile__(
-	"movb %%al,%%ah\n"
-	"1:\tlodsb\n\t"
-	"cmpb %%ah,%%al\n\t"
-	"je 2f\n\t"
-	"testb %%al,%%al\n\t"
-	"jne 1b\n\t"
-	"movl $1,%1\n"
-	"2:\tmovl %1,%0\n\t"
-	"decl %0"
-	:"=a" (__res), "=&S" (d0)
-	:"1" (s),"0" (c)
-	:"memory");
-return __res;
-}
+extern char *strchr(const char *s, int c);
 
 #define __HAVE_ARCH_STRRCHR
-static inline char * strrchr(const char * s, int c)
-{
-int d0, d1;
-register char * __res;
-__asm__ __volatile__(
-	"movb %%al,%%ah\n"
-	"1:\tlodsb\n\t"
-	"cmpb %%ah,%%al\n\t"
-	"jne 2f\n\t"
-	"leal -1(%%esi),%0\n"
-	"2:\ttestb %%al,%%al\n\t"
-	"jne 1b"
-	:"=g" (__res), "=&S" (d0), "=&a" (d1)
-	:"0" (0),"1" (s),"2" (c)
-	:"memory");
-return __res;
-}
+extern char *strrchr(const char *s, int c);
 
 #define __HAVE_ARCH_STRLEN
-static inline size_t strlen(const char * s)
-{
-int d0;
-register int __res;
-__asm__ __volatile__(
-	"repne\n\t"
-	"scasb\n\t"
-	"notl %0\n\t"
-	"decl %0"
-	:"=c" (__res), "=&D" (d0)
-	:"1" (s),"a" (0), "0" (0xffffffffu)
-	:"memory");
-return __res;
-}
+extern size_t strlen(const char *s);
 
 static __always_inline void * __memcpy(void * to, const void * from, size_t n)
 {
@@ -207,9 +39,7 @@ __asm__ __volatile__(
 	"rep ; movsl\n\t"
 	"movl %4,%%ecx\n\t"
 	"andl $3,%%ecx\n\t"
-#if 1	/* want to pay 2 byte penalty for a chance to skip microcoded rep? */
 	"jz 1f\n\t"
-#endif
 	"rep ; movsb\n\t"
 	"1:"
 	: "=&c" (d0), "=&D" (d1), "=&S" (d2)
@@ -328,23 +158,7 @@ void *memmove(void * dest,const void * s
 #define memcmp __builtin_memcmp
 
 #define __HAVE_ARCH_MEMCHR
-static inline void * memchr(const void * cs,int c,size_t count)
-{
-int d0;
-register void * __res;
-if (!count)
-	return NULL;
-__asm__ __volatile__(
-	"repne\n\t"
-	"scasb\n\t"
-	"je 1f\n\t"
-	"movl $1,%0\n"
-	"1:\tdecl %0"
-	:"=D" (__res), "=&c" (d0)
-	:"a" (c),"0" (cs),"1" (count)
-	:"memory");
-return __res;
-}
+extern void *memchr(const void * cs,int c,size_t count);
 
 static inline void * __memset_generic(void * s, char c,size_t count)
 {
@@ -386,29 +200,10 @@ return (s);	
 
 /* Added by Gertjan van Wingerde to make minix and sysv module work */
 #define __HAVE_ARCH_STRNLEN
-static inline size_t strnlen(const char * s, size_t count)
-{
-int d0;
-register int __res;
-__asm__ __volatile__(
-	"movl %2,%0\n\t"
-	"jmp 2f\n"
-	"1:\tcmpb $0,(%0)\n\t"
-	"je 3f\n\t"
-	"incl %0\n"
-	"2:\tdecl %1\n\t"
-	"cmpl $-1,%1\n\t"
-	"jne 1b\n"
-	"3:\tsubl %2,%0"
-	:"=a" (__res), "=&d" (d0)
-	:"c" (s),"1" (count)
-	:"memory");
-return __res;
-}
+extern size_t strnlen(const char * s, size_t count);
 /* end of additional stuff */
 
 #define __HAVE_ARCH_STRSTR
-
 extern char *strstr(const char *cs, const char *ct);
 
 /*
@@ -474,19 +269,7 @@ __asm__  __volatile__( \
  * find the first occurrence of byte 'c', or 1 past the area if none
  */
 #define __HAVE_ARCH_MEMSCAN
-static inline void * memscan(void * addr, int c, size_t size)
-{
-	if (!size)
-		return addr;
-	__asm__("repnz; scasb\n\t"
-		"jnz 1f\n\t"
-		"dec %%edi\n"
-		"1:"
-		: "=D" (addr), "=c" (size)
-		: "0" (addr), "1" (size), "a" (c)
-		: "memory");
-	return addr;
-}
+extern void *memscan(void * addr, int c, size_t size);
 
 #endif /* __KERNEL__ */
 
Index: linux/arch/i386/lib/Makefile
===================================================================
--- linux.orig/arch/i386/lib/Makefile
+++ linux/arch/i386/lib/Makefile
@@ -4,7 +4,7 @@
 
 
 lib-y = checksum.o delay.o usercopy.o getuser.o putuser.o memcpy.o strstr.o \
-	bitops.o semaphore.o
+	bitops.o semaphore.o string.o
 
 lib-$(CONFIG_X86_USE_3DNOW) += mmx.o
 
Index: linux/arch/i386/lib/string.c
===================================================================
--- /dev/null
+++ linux/arch/i386/lib/string.c
@@ -0,0 +1,233 @@
+/*
+ * Most of the string-functions are rather heavily hand-optimized,
+ * see especially strsep,strstr,str[c]spn. They should work, but are not
+ * very easy to understand. Everything is done entirely within the register
+ * set, making the functions fast and clean. String instructions have been
+ * used through-out, making for "slightly" unclear code :-)
+ *
+ * AK: On P4 and K7 using non string instruction implementations might be faster
+ * for large memory blocks. But most of them are unlikely to be used on any
+ * of thse.
+ */
+
+#include <linux/string.h>
+#include <linux/module.h>
+
+char *strcpy(char * dest,const char *src)
+{
+	int d0, d1, d2;
+	asm( "1:\tlodsb\n\t"
+		"stosb\n\t"
+		"testb %%al,%%al\n\t"
+		"jne 1b"
+		: "=&S" (d0), "=&D" (d1), "=&a" (d2)
+		:"0" (src),"1" (dest) : "memory");
+	return dest;
+}
+EXPORT_SYMBOL(strcpy);
+
+char *strncpy(char * dest,const char *src,size_t count)
+{
+	int d0, d1, d2, d3;
+	asm( "1:\tdecl %2\n\t"
+		"js 2f\n\t"
+		"lodsb\n\t"
+		"stosb\n\t"
+		"testb %%al,%%al\n\t"
+		"jne 1b\n\t"
+		"rep\n\t"
+		"stosb\n"
+		"2:"
+		: "=&S" (d0), "=&D" (d1), "=&c" (d2), "=&a" (d3)
+		:"0" (src),"1" (dest),"2" (count) : "memory");
+	return dest;
+}
+EXPORT_SYMBOL(strncpy);
+
+char *strcat(char * dest,const char * src)
+{
+	int d0, d1, d2, d3;
+	asm( "repne\n\t"
+		"scasb\n\t"
+		"decl %1\n"
+		"1:\tlodsb\n\t"
+		"stosb\n\t"
+		"testb %%al,%%al\n\t"
+		"jne 1b"
+		: "=&S" (d0), "=&D" (d1), "=&a" (d2), "=&c" (d3)
+		: "0" (src), "1" (dest), "2" (0), "3" (0xffffffffu):"memory");
+	return dest;
+}
+EXPORT_SYMBOL(strcat);
+
+char *strncat(char * dest,const char * src,size_t count)
+{
+	int d0, d1, d2, d3;
+	asm( "repne\n\t"
+		"scasb\n\t"
+		"decl %1\n\t"
+		"movl %8,%3\n"
+		"1:\tdecl %3\n\t"
+		"js 2f\n\t"
+		"lodsb\n\t"
+		"stosb\n\t"
+		"testb %%al,%%al\n\t"
+		"jne 1b\n"
+		"2:\txorl %2,%2\n\t"
+		"stosb"
+		: "=&S" (d0), "=&D" (d1), "=&a" (d2), "=&c" (d3)
+		: "0" (src),"1" (dest),"2" (0),"3" (0xffffffffu), "g" (count)
+		: "memory");
+	return dest;
+}
+EXPORT_SYMBOL(strncat);
+
+int strcmp(const char * cs,const char * ct)
+{
+	int d0, d1;
+	int res;
+	asm( "1:\tlodsb\n\t"
+		"scasb\n\t"
+		"jne 2f\n\t"
+		"testb %%al,%%al\n\t"
+		"jne 1b\n\t"
+		"xorl %%eax,%%eax\n\t"
+		"jmp 3f\n"
+		"2:\tsbbl %%eax,%%eax\n\t"
+		"orb $1,%%al\n"
+		"3:"
+		:"=a" (res), "=&S" (d0), "=&D" (d1)
+		:"1" (cs),"2" (ct)
+		:"memory");
+	return res;
+}
+EXPORT_SYMBOL(strcmp);
+
+int strncmp(const char * cs,const char * ct,size_t count)
+{
+	int res;
+	int d0, d1, d2;
+	asm( "1:\tdecl %3\n\t"
+		"js 2f\n\t"
+		"lodsb\n\t"
+		"scasb\n\t"
+		"jne 3f\n\t"
+		"testb %%al,%%al\n\t"
+		"jne 1b\n"
+		"2:\txorl %%eax,%%eax\n\t"
+		"jmp 4f\n"
+		"3:\tsbbl %%eax,%%eax\n\t"
+		"orb $1,%%al\n"
+		"4:"
+		:"=a" (res), "=&S" (d0), "=&D" (d1), "=&c" (d2)
+		:"1" (cs),"2" (ct),"3" (count)
+		:"memory");
+	return res;
+}
+EXPORT_SYMBOL(strncmp);
+
+char *strchr(const char * s, int c)
+{
+	int d0;
+	char * res;
+	asm( "movb %%al,%%ah\n"
+		"1:\tlodsb\n\t"
+		"cmpb %%ah,%%al\n\t"
+		"je 2f\n\t"
+		"testb %%al,%%al\n\t"
+		"jne 1b\n\t"
+		"movl $1,%1\n"
+		"2:\tmovl %1,%0\n\t"
+		"decl %0"
+		:"=a" (res), "=&S" (d0)
+		:"1" (s),"0" (c)
+		:"memory");
+	return res;
+}
+EXPORT_SYMBOL(strchr);
+
+char *strrchr(const char * s, int c)
+{
+	int d0, d1;
+	char * res;
+	asm( "movb %%al,%%ah\n"
+		"1:\tlodsb\n\t"
+		"cmpb %%ah,%%al\n\t"
+		"jne 2f\n\t"
+		"leal -1(%%esi),%0\n"
+		"2:\ttestb %%al,%%al\n\t"
+		"jne 1b"
+		:"=g" (res), "=&S" (d0), "=&a" (d1)
+		:"0" (0),"1" (s),"2" (c)
+		:"memory");
+	return res;
+}
+EXPORT_SYMBOL(strrchr);
+
+size_t strlen(const char * s)
+{
+	int d0;
+	int res;
+	asm( "repne\n\t"
+		"scasb\n\t"
+		"notl %0\n\t"
+		"decl %0"
+		:"=c" (res), "=&D" (d0)
+		:"1" (s),"a" (0), "0" (0xffffffffu)
+		:"memory");
+	return res;
+}
+EXPORT_SYMBOL(strlen);
+
+void *memchr(const void *cs,int c,size_t count)
+{
+	int d0;
+	void *res;
+	if (!count)
+		return NULL;
+	asm( "repne\n\t"
+		"scasb\n\t"
+		"je 1f\n\t"
+		"movl $1,%0\n"
+		"1:\tdecl %0"
+		:"=D" (res), "=&c" (d0)
+		:"a" (c),"0" (cs),"1" (count)
+		:"memory");
+	return res;
+}
+EXPORT_SYMBOL(memchr);
+
+void *memscan(void * addr, int c, size_t size)
+{
+	if (!size)
+		return addr;
+	asm("repnz; scasb\n\t"
+	    "jnz 1f\n\t"
+	    "dec %%edi\n"
+	    "1:"
+	    : "=D" (addr), "=c" (size)
+	    : "0" (addr), "1" (size), "a" (c)
+	    : "memory");
+	return addr;
+}
+EXPORT_SYMBOL(memscan);
+
+size_t strnlen(const char *s, size_t count)
+{
+	int d0;
+	int res;
+	asm( "movl %2,%0\n\t"
+		"jmp 2f\n"
+		"1:\tcmpb $0,(%0)\n\t"
+		"je 3f\n\t"
+		"incl %0\n"
+		"2:\tdecl %1\n\t"
+		"cmpl $-1,%1\n\t"
+		"jne 1b\n"
+		"3:\tsubl %2,%0"
+		:"=a" (res), "=&d" (d0)
+		:"c" (s),"1" (count)
+		:"memory");
+	return res;
+}
+EXPORT_SYMBOL(strnlen);
