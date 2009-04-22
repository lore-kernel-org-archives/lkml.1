Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbZDVIpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbZDVIpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 04:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZDVIpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 04:45:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59716 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZDVIpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 04:45:21 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH] X86-32: Let gcc decide whether to inline memcpy was Re: New x86 warning
From: Andi Kleen <andi@firstfloor.org>
References: <49EEBD3C.3060009@garzik.org> <20090422070157.GA28438@elte.hu>
Date: Wed, 22 Apr 2009 10:45:15 +0200
In-Reply-To: <20090422070157.GA28438@elte.hu> (Ingo Molnar's message of "Wed, 22 Apr 2009 09:01:57 +0200")
Message-ID: <8763gxoz50.fsf_-_@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Jeff Garzik <jeff@garzik.org> wrote:
>
>> On x86-32, this warning now appears for me in 2.6.30-rc3, and did 
>> not appear in 2.6.29.
>>
>> drivers/acpi/acpica/tbfadt.c: In function 'acpi_tb_create_local_fadt':
>> /spare/repo/linux-2.6/arch/x86/include/asm/string_32.h:75: warning:  
>> array subscript is above array bounds
>
> Last i checked it was a GCC bounds check bogosity. All attempts to 
> work it around or annotate it sanely (without changing the assembly 
> code) failed. (new ideas welcome)
>
> The closest i came was the hacklet below to the assembly code. [with 
> an intentionally corrupted patch header to make it harder to apply 
> accidentally.]

Modern gcc (and that is all that is supported now) should be able to
generate this code on its own already.  So if you call __builtin_* it
will  just work (that is what 64bit does) without that explicit code.

Here's a patch that does that with some numbers. It gives about 3k
smaller kernels on my configuration.

IMHO it's long overdue to do this for 32bit too.

It's a very attractive patch because it removes a lot of code:

 arch/x86/include/asm/string_32.h |  127 ++-------------------------------------
 arch/x86/lib/memcpy_32.c         |   16 ++++

-Andi

---

X86-32: Let gcc decide whether to inline memcpy 

Modern gccs have own heuristics to decide whether string functions should be inlined
or not. This used to be not the case with old gccs, but Linux doesn't support them
anymore. The 64bit kernel always did it this way. Just define memcpy to
__builtin_memcpy and gcc should do the right thing. Also supply
a out of line memcpy that gcc can fall back to when it decides
not to inline.

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
I left the 3d now case alone for now.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/string_32.h |  127 ++-------------------------------------
 arch/x86/lib/memcpy_32.c         |   16 ++++
 2 files changed, 23 insertions(+), 120 deletions(-)

Index: linux-2.6.30-rc2-ak/arch/x86/include/asm/string_32.h
===================================================================
--- linux-2.6.30-rc2-ak.orig/arch/x86/include/asm/string_32.h	2009-04-22 10:22:33.000000000 +0200
+++ linux-2.6.30-rc2-ak/arch/x86/include/asm/string_32.h	2009-04-22 10:23:12.000000000 +0200
@@ -29,121 +29,10 @@
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
@@ -155,7 +44,7 @@
 static inline void *__constant_memcpy3d(void *to, const void *from, size_t len)
 {
 	if (len < 512)
-		return __constant_memcpy(to, from, len);
+		return __memcpy(to, from, len);
 	return _mmx_memcpy(to, from, len);
 }
 
@@ -168,20 +57,18 @@
 
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
Index: linux-2.6.30-rc2-ak/arch/x86/lib/memcpy_32.c
===================================================================
--- linux-2.6.30-rc2-ak.orig/arch/x86/lib/memcpy_32.c	2009-04-22 10:22:33.000000000 +0200
+++ linux-2.6.30-rc2-ak/arch/x86/lib/memcpy_32.c	2009-04-22 10:23:56.000000000 +0200
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



-- 
ak@linux.intel.com -- Speaking for myself only.
