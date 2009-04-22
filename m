Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbZDVXtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbZDVXtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 19:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZDVXtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 19:49:12 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:46301 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbZDVXtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 19:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h1V0T9heQ2cXV7QB7fHumz21ZD8ETorwtwOtTsafRWbPgpte5UufnoQp2Jc9fF3HOs
         2xZUOWdTHxc7nh+VIRoJvRvlSK1lKS/Ro6ir+4u9ld+POsaZk2mQWoc7gKN5+qH5UDjw
         yjDHCOZHh2JsVFXwqN7bFL/FuRke7ciV74kjo=
MIME-Version: 1.0
In-Reply-To: <8763gxoz50.fsf_-_@basil.nowhere.org>
References: <49EEBD3C.3060009@garzik.org> <20090422070157.GA28438@elte.hu>
	 <8763gxoz50.fsf_-_@basil.nowhere.org>
Date: Wed, 22 Apr 2009 16:49:08 -0700
Message-ID: <3605561d0904221649n169dc579xb0694297154d97fa@mail.gmail.com>
Subject: Re: [PATCH] X86-32: Let gcc decide whether to inline memcpy was Re: 
	New x86 warning
From: Joe Damato <ice799@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 1:45 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Ingo Molnar <mingo@elte.hu> writes:
>
>> * Jeff Garzik <jeff@garzik.org> wrote:
>>
>>> On x86-32, this warning now appears for me in 2.6.30-rc3, and did
>>> not appear in 2.6.29.
>>>
>>> drivers/acpi/acpica/tbfadt.c: In function 'acpi_tb_create_local_fadt':
>>> /spare/repo/linux-2.6/arch/x86/include/asm/string_32.h:75: warning:
>>> array subscript is above array bounds
>>
>> Last i checked it was a GCC bounds check bogosity. All attempts to
>> work it around or annotate it sanely (without changing the assembly
>> code) failed. (new ideas welcome)
>>
>> The closest i came was the hacklet below to the assembly code. [with
>> an intentionally corrupted patch header to make it harder to apply
>> accidentally.]
>
> Modern gcc (and that is all that is supported now) should be able to
> generate this code on its own already.  So if you call __builtin_* it
> will  just work (that is what 64bit does) without that explicit code.
>
> Here's a patch that does that with some numbers. It gives about 3k
> smaller kernels on my configuration.
>
> IMHO it's long overdue to do this for 32bit too.
>
> It's a very attractive patch because it removes a lot of code:

I think this patch is great. Perhaps this would be a good time to also
clean out memset for x86_32? (If needed, I can start a new email
thread with this patch) I've built and booted this on my x86_32
hardware.

[danger: a newb's patch below]

Joe

--

Define memset to __builtin_memset and gcc should do the right thing.
Keep around the generic memset routine that gcc can use when it does
not inline. Removes a bunch of ugly code, too.

Signed-off-by: Joe Damato <ice799@gmail.com>
---
 arch/x86/include/asm/string_32.h |  117 +-------------------------------------
 arch/x86/lib/memcpy_32.c         |   12 ++++
 2 files changed, 15 insertions(+), 114 deletions(-)

diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
index 29fff54..aedee80 100644
--- a/arch/x86/include/asm/string_32.h
+++ b/arch/x86/include/asm/string_32.h
@@ -30,7 +30,6 @@ extern char *strchr(const char *s, int c);
 extern size_t strlen(const char *s);

 #define __HAVE_ARCH_MEMCPY
-
 extern void *__memcpy(void *to, const void *from, size_t n);

 #ifdef CONFIG_X86_USE_3DNOW
@@ -79,42 +78,8 @@ void *memmove(void *dest, const void *src, size_t n);
 #define __HAVE_ARCH_MEMCHR
 extern void *memchr(const void *cs, int c, size_t count);

-static inline void *__memset_generic(void *s, char c, size_t count)
-{
-	int d0, d1;
-	asm volatile("rep\n\t"
-		     "stosb"
-		     : "=&c" (d0), "=&D" (d1)
-		     : "a" (c), "1" (s), "0" (count)
-		     : "memory");
-	return s;
-}
-
-/* we might want to write optimized versions of these later */
-#define __constant_count_memset(s, c, count) __memset_generic((s),
(c), (count))
-
-/*
- * memset(x, 0, y) is a reasonably common thing to do, so we want to fill
- * things 32 bits at a time even when we don't know the size of the
- * area at compile-time..
- */
-static __always_inline
-void *__constant_c_memset(void *s, unsigned long c, size_t count)
-{
-	int d0, d1;
-	asm volatile("rep ; stosl\n\t"
-		     "testb $2,%b3\n\t"
-		     "je 1f\n\t"
-		     "stosw\n"
-		     "1:\ttestb $1,%b3\n\t"
-		     "je 2f\n\t"
-		     "stosb\n"
-		     "2:"
-		     : "=&c" (d0), "=&D" (d1)
-		     : "a" (c), "q" (count), "0" (count/4), "1" ((long)s)
-		     : "memory");
-	return s;
-}
+#define __HAVE_ARCH_MEMSET
+extern void *__memset(void *s, char c, size_t count);

 /* Added by Gertjan van Wingerde to make minix and sysv module work */
 #define __HAVE_ARCH_STRNLEN
@@ -124,83 +89,7 @@ extern size_t strnlen(const char *s, size_t count);
 #define __HAVE_ARCH_STRSTR
 extern char *strstr(const char *cs, const char *ct);

-/*
- * This looks horribly ugly, but the compiler can optimize it totally,
- * as we by now know that both pattern and count is constant..
- */
-static __always_inline
-void *__constant_c_and_count_memset(void *s, unsigned long pattern,
-				    size_t count)
-{
-	switch (count) {
-	case 0:
-		return s;
-	case 1:
-		*(unsigned char *)s = pattern & 0xff;
-		return s;
-	case 2:
-		*(unsigned short *)s = pattern & 0xffff;
-		return s;
-	case 3:
-		*(unsigned short *)s = pattern & 0xffff;
-		*((unsigned char *)s + 2) = pattern & 0xff;
-		return s;
-	case 4:
-		*(unsigned long *)s = pattern;
-		return s;
-	}
-
-#define COMMON(x)							\
-	asm volatile("rep ; stosl"					\
-		     x							\
-		     : "=&c" (d0), "=&D" (d1)				\
-		     : "a" (eax), "0" (count/4), "1" ((long)s)	\
-		     : "memory")
-
-	{
-		int d0, d1;
-#if __GNUC__ == 4 && __GNUC_MINOR__ == 0
-		/* Workaround for broken gcc 4.0 */
-		register unsigned long eax asm("%eax") = pattern;
-#else
-		unsigned long eax = pattern;
-#endif
-
-		switch (count % 4) {
-		case 0:
-			COMMON("");
-			return s;
-		case 1:
-			COMMON("\n\tstosb");
-			return s;
-		case 2:
-			COMMON("\n\tstosw");
-			return s;
-		default:
-			COMMON("\n\tstosw\n\tstosb");
-			return s;
-		}
-	}
-
-#undef COMMON
-}
-
-#define __constant_c_x_memset(s, c, count)			\
-	(__builtin_constant_p(count)				\
-	 ? __constant_c_and_count_memset((s), (c), (count))	\
-	 : __constant_c_memset((s), (c), (count)))
-
-#define __memset(s, c, count)				\
-	(__builtin_constant_p(count)			\
-	 ? __constant_count_memset((s), (c), (count))	\
-	 : __memset_generic((s), (c), (count)))
-
-#define __HAVE_ARCH_MEMSET
-#define memset(s, c, count)						\
-	(__builtin_constant_p(c)					\
-	 ? __constant_c_x_memset((s), (0x01010101UL * (unsigned char)(c)), \
-				 (count))				\
-	 : __memset((s), (c), (count)))
+#define memset(s, c, count) __builtin_memset(s, c, count)

 /*
  * find the first occurrence of byte 'c', or 1 past the area if none
diff --git a/arch/x86/lib/memcpy_32.c b/arch/x86/lib/memcpy_32.c
index 16dc123..16b10d9 100644
--- a/arch/x86/lib/memcpy_32.c
+++ b/arch/x86/lib/memcpy_32.c
@@ -30,6 +30,18 @@ void *memcpy(void *to, const void *from, size_t n)
 }
 EXPORT_SYMBOL(memcpy);

+void *__memset(void *s, char c, size_t count)
+{
+	int d0, d1;
+	asm volatile("rep\n\t"
+		     "stosb"
+		     : "=&c" (d0), "=&D" (d1)
+		     : "a" (c), "1" (s), "0" (count)
+		     : "memory");
+	return s;
+}
+EXPORT_SYMBOL(__memset);
+
 void *memset(void *s, int c, size_t count)
 {
 	return __memset(s, c, count);
-- 
1.6.2
