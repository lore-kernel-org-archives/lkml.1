Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbZDVSCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbZDVSCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 14:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbZDVSBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 14:01:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:48510 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZDVSBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 14:01:50 -0400
Date: Wed, 22 Apr 2009 18:00:31 GMT
From: tip-bot for Andi Kleen <andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <8763gxoz50.fsf_-_@basil.nowhere.org>
References: <8763gxoz50.fsf_-_@basil.nowhere.org>
Subject: [tip:x86/asm] x86: use __builtin_memcpy() on 32 bits
Message-ID: <tip-1405ae250ec86802b32ca9f7aea977a5ab551b22@git.kernel.org>
Git-Commit-ID: 1405ae250ec86802b32ca9f7aea977a5ab551b22
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 22 Apr 2009 18:00:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1405ae250ec86802b32ca9f7aea977a5ab551b22
Gitweb:     http://git.kernel.org/tip/1405ae250ec86802b32ca9f7aea977a5ab551b22
Author:     Andi Kleen <andi@firstfloor.org>
AuthorDate: Wed, 22 Apr 2009 10:45:15 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 22 Apr 2009 10:55:20 -0700

x86: use __builtin_memcpy() on 32 bits

Modern gccs have own heuristics to decide whether string functions
should be inlined or not. This used to be not the case with old gccs,
but Linux doesn't support them anymore. The 64bit kernel always did it
this way. Just define memcpy to __builtin_memcpy and gcc should do the
right thing. Also supply a out of line memcpy that gcc can fall back
to when it decides not to inline.

First this fixes the

arch/x86/include/asm/string_32.h:75: warning: array subscript is above array bounds

warnings which have been creeping up recently by just
removing that code.

Then trusting gcc actually makes the kernel smaller by nearly 3K:

5503146  529444 1495040 7527630  72dcce vmlinux
5500373  529444 1495040 7524857  72d1f9 vmlinux-string

Also it removes some quite ugly code and will likely speed up
compilation by a tiny bit by having less inline code to process
for every file.

It did some quick boot tests and everything worked as expected.
I left the 3dnow case alone for now.

[ Impact: fixes warning, reduces code size ]

Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <8763gxoz50.fsf_-_@basil.nowhere.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/include/asm/string_32.h |  127 ++-----------------------------------
 arch/x86/lib/memcpy_32.c         |   16 +++++
 2 files changed, 23 insertions(+), 120 deletions(-)

diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
index 0e0e3ba..29fff54 100644
--- a/arch/x86/include/asm/string_32.h
+++ b/arch/x86/include/asm/string_32.h
@@ -29,121 +29,10 @@ extern char *strchr(const char *s, int c);
 #define __HAVE_ARCH_STRLEN
 extern size_t strlen(const char *s);
 
-static __always_inline void *__memcpy(void *to, const void *from, size_t n)
-{
-	int d0, d1, d2;
-	asm volatile("rep ; movsl\n\t"
-		     "movl %4,%%ecx\n\t"
-		     "andl $3,%%ecx\n\t"
-		     "jz 1f\n\t"
-		     "rep ; movsb\n\t"
-		     "1:"
-		     : "=&c" (d0), "=&D" (d1), "=&S" (d2)
-		     : "0" (n / 4), "g" (n), "1" ((long)to), "2" ((long)from)
-		     : "memory");
-	return to;
-}
-
-/*
- * This looks ugly, but the compiler can optimize it totally,
- * as the count is constant.
- */
-static __always_inline void *__constant_memcpy(void *to, const void *from,
-					       size_t n)
-{
-	long esi, edi;
-	if (!n)
-		return to;
-
-	switch (n) {
-	case 1:
-		*(char *)to = *(char *)from;
-		return to;
-	case 2:
-		*(short *)to = *(short *)from;
-		return to;
-	case 4:
-		*(int *)to = *(int *)from;
-		return to;
-
-	case 3:
-		*(short *)to = *(short *)from;
-		*((char *)to + 2) = *((char *)from + 2);
-		return to;
-	case 5:
-		*(int *)to = *(int *)from;
-		*((char *)to + 4) = *((char *)from + 4);
-		return to;
-	case 6:
-		*(int *)to = *(int *)from;
-		*((short *)to + 2) = *((short *)from + 2);
-		return to;
-	case 8:
-		*(int *)to = *(int *)from;
-		*((int *)to + 1) = *((int *)from + 1);
-		return to;
-	}
-
-	esi = (long)from;
-	edi = (long)to;
-	if (n >= 5 * 4) {
-		/* large block: use rep prefix */
-		int ecx;
-		asm volatile("rep ; movsl"
-			     : "=&c" (ecx), "=&D" (edi), "=&S" (esi)
-			     : "0" (n / 4), "1" (edi), "2" (esi)
-			     : "memory"
-		);
-	} else {
-		/* small block: don't clobber ecx + smaller code */
-		if (n >= 4 * 4)
-			asm volatile("movsl"
-				     : "=&D"(edi), "=&S"(esi)
-				     : "0"(edi), "1"(esi)
-				     : "memory");
-		if (n >= 3 * 4)
-			asm volatile("movsl"
-				     : "=&D"(edi), "=&S"(esi)
-				     : "0"(edi), "1"(esi)
-				     : "memory");
-		if (n >= 2 * 4)
-			asm volatile("movsl"
-				     : "=&D"(edi), "=&S"(esi)
-				     : "0"(edi), "1"(esi)
-				     : "memory");
-		if (n >= 1 * 4)
-			asm volatile("movsl"
-				     : "=&D"(edi), "=&S"(esi)
-				     : "0"(edi), "1"(esi)
-				     : "memory");
-	}
-	switch (n % 4) {
-		/* tail */
-	case 0:
-		return to;
-	case 1:
-		asm volatile("movsb"
-			     : "=&D"(edi), "=&S"(esi)
-			     : "0"(edi), "1"(esi)
-			     : "memory");
-		return to;
-	case 2:
-		asm volatile("movsw"
-			     : "=&D"(edi), "=&S"(esi)
-			     : "0"(edi), "1"(esi)
-			     : "memory");
-		return to;
-	default:
-		asm volatile("movsw\n\tmovsb"
-			     : "=&D"(edi), "=&S"(esi)
-			     : "0"(edi), "1"(esi)
-			     : "memory");
-		return to;
-	}
-}
-
 #define __HAVE_ARCH_MEMCPY
 
+extern void *__memcpy(void *to, const void *from, size_t n);
+
 #ifdef CONFIG_X86_USE_3DNOW
 
 #include <asm/mmx.h>
@@ -155,7 +44,7 @@ static __always_inline void *__constant_memcpy(void *to, const void *from,
 static inline void *__constant_memcpy3d(void *to, const void *from, size_t len)
 {
 	if (len < 512)
-		return __constant_memcpy(to, from, len);
+		return __memcpy(to, from, len);
 	return _mmx_memcpy(to, from, len);
 }
 
@@ -168,20 +57,18 @@ static inline void *__memcpy3d(void *to, const void *from, size_t len)
 
 #define memcpy(t, f, n)				\
 	(__builtin_constant_p((n))		\
-	 ? __constant_memcpy3d((t), (f), (n))	\
+	 ? __builtin_memcpy((t), (f), (n))	\
 	 : __memcpy3d((t), (f), (n)))
 
 #else
 
 /*
  *	No 3D Now!
+ *
+ * Let gcc figure it out.
  */
 
-#define memcpy(t, f, n)				\
-	(__builtin_constant_p((n))		\
-	 ? __constant_memcpy((t), (f), (n))	\
-	 : __memcpy((t), (f), (n)))
-
+#define memcpy(t, f, n) __builtin_memcpy(t,f,n)
 #endif
 
 #define __HAVE_ARCH_MEMMOVE
diff --git a/arch/x86/lib/memcpy_32.c b/arch/x86/lib/memcpy_32.c
index 5415a9d..16dc123 100644
--- a/arch/x86/lib/memcpy_32.c
+++ b/arch/x86/lib/memcpy_32.c
@@ -4,6 +4,22 @@
 #undef memcpy
 #undef memset
 
+void *__memcpy(void *to, const void *from, size_t n)
+{
+	int d0, d1, d2;
+	asm volatile("rep ; movsl\n\t"
+		     "movl %4,%%ecx\n\t"
+		     "andl $3,%%ecx\n\t"
+		     "jz 1f\n\t"
+		     "rep ; movsb\n\t"
+		     "1:"
+		     : "=&c" (d0), "=&D" (d1), "=&S" (d2)
+		     : "0" (n / 4), "g" (n), "1" ((long)to), "2" ((long)from)
+		     : "memory");
+	return to;
+}
+EXPORT_SYMBOL(__memcpy);
+
 void *memcpy(void *to, const void *from, size_t n)
 {
 #ifdef CONFIG_X86_USE_3DNOW
