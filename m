Return-Path: <linux-kernel-owner+w=401wt.eu-S1762307AbXGLH1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762307AbXGLH1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 03:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbXGLH12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 03:27:28 -0400
Received: from hermes.xcon.it ([62.48.35.101]:37259 "EHLO hermes.xcon.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbXGLH10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 03:27:26 -0400
Subject: Re: Forward port of latest RT patch (2.6.21.5-rt20) to 2.6.22
	available
From: Alessio Igor Bogani <abogani@texware.it>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, jim.houston@ccur.com,
       joe.korty@ccur.com, dwalker@mvista.com, David Bahi <DBahi@novell.com>,
       Moiz Kohari <MKohari@novell.com>, Sven Dietrich <SDietrich@novell.com>,
       dsaxena@plexity.net, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <469544710200005A000275CC@mcclure.wal.novell.com>
References: <469544710200005A000275CC@mcclure.wal.novell.com>
Content-Type: multipart/mixed; boundary="=-iaal7ahNOjjeRTOnWzAI"
Date: Thu, 12 Jul 2007 09:27:19 +0200
Message-Id: <1184225239.5142.20.camel@godzilla.tecnorama.it>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iaal7ahNOjjeRTOnWzAI
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi All,

Sorry for my poor english.

On Wed, 2007-07-11 at 20:58 -0400, Gregory Haskins wrote:
[...]
> 	I just wanted to let you guys know that our team has a port of the
> 21.5-rt20 patch for the 2.6.22 kernel available.

Great! Thanks a lot for effort!

I'm doing the same thing and i don't have doubt your work is better than
mine. In any case i have a couple of suggestions for your patch (one is
a simple duplication definition and the other for build kernel with
CONFIG_SMP on i386).

Please keep me updated!

Hope these helps.

Ciao,
Alessio

--=-iaal7ahNOjjeRTOnWzAI
Content-Disposition: attachment; filename=duplicated-div64_64.c
Content-Type: text/x-patch; name=duplicated-div64_64.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -ruNp linux-2.6.22-rt1.orig/lib/div64.c linux-2.6.22-rt1.test/lib/div64.c
--- linux-2.6.22-rt1.orig/lib/div64.c	2007-07-12 08:57:33.000000000 +0200
+++ linux-2.6.22-rt1.test/lib/div64.c	2007-07-12 08:49:47.000000000 +0200
@@ -78,26 +78,4 @@ uint64_t div64_64(uint64_t dividend, uin
 }
 EXPORT_SYMBOL(div64_64);
 
-/* 64bit divisor, dividend and result. dynamic precision */
-uint64_t div64_64(uint64_t dividend, uint64_t divisor)
-{
-	uint32_t d = divisor;
-
-	if (divisor > 0xffffffffULL) {
-		unsigned int shift = fls(divisor >> 32);
-
-		d = divisor >> shift;
-		dividend >>= shift;
-	}
-
-	/* avoid 64 bit division if possible */
-	if (dividend >> 32)
-		do_div(dividend, d);
-	else
-		dividend = (uint32_t) dividend / d;
-
-	return dividend;
-}
-EXPORT_SYMBOL(div64_64);
-
 #endif /* BITS_PER_LONG == 32 */

--=-iaal7ahNOjjeRTOnWzAI
Content-Disposition: attachment; filename=patch-percpu-smp.diff
Content-Type: text/x-patch; name=patch-percpu-smp.diff; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -ruNp linux-2.6.22-rt1.orig/include/asm-generic/percpu.h linux-2.6.22-rt1.test/include/asm-generic/percpu.h
--- linux-2.6.22-rt1.orig/include/asm-generic/percpu.h	2007-07-12 09:13:08.000000000 +0200
+++ linux-2.6.22-rt1.test/include/asm-generic/percpu.h	2007-07-12 09:04:53.000000000 +0200
@@ -14,10 +14,6 @@ extern unsigned long __per_cpu_offset[NR
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
-#define DEFINE_PER_CPU_LOCKED(type, name) \
-    __attribute__((__section__(".data.percpu"))) __DEFINE_SPINLOCK(per_cpu_lock__##name##_locked); \
-    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name##_locked
-
 /* var is in discarded region: offset to particular copy we want */
 #define per_cpu(var, cpu) (*({				\
 	extern int simple_identifier_##var(void);	\
@@ -25,15 +21,6 @@ extern unsigned long __per_cpu_offset[NR
 #define __get_cpu_var(var) per_cpu(var, smp_processor_id())
 #define __raw_get_cpu_var(var) per_cpu(var, raw_smp_processor_id())
 
-#define per_cpu_lock(var, cpu) \
-	(*RELOC_HIDE(&per_cpu_lock__##var##_locked, __per_cpu_offset[cpu]))
-#define per_cpu_var_locked(var, cpu) \
-		(*RELOC_HIDE(&per_cpu__##var##_locked, __per_cpu_offset[cpu]))
-#define __get_cpu_lock(var, cpu) \
-		per_cpu_lock(var, cpu)
-#define __get_cpu_var_locked(var, cpu) \
-		per_cpu_var_locked(var, cpu)
-
 /* A macro to avoid #include hell... */
 #define percpu_modcopy(pcpudst, src, size)			\
 do {								\
@@ -60,13 +47,8 @@ do {								\
 #endif	/* SMP */
 
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
-#define DECLARE_PER_CPU_LOCKED(type, name) \
-    extern spinlock_t per_cpu_lock__##name##_locked; \
-    extern __typeof__(type) per_cpu__##name##_locked
 
 #define EXPORT_PER_CPU_SYMBOL(var) EXPORT_SYMBOL(per_cpu__##var)
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
-#define EXPORT_PER_CPU_LOCKED_SYMBOL(var) EXPORT_SYMBOL(per_cpu_lock__##var##_locked); EXPORT_SYMBOL(per_cpu__##var##_locked)
-#define EXPORT_PER_CPU_LOCKED_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu_lock__##var##_locked); EXPORT_SYMBOL_GPL(per_cpu__##var##_locked)
 
 #endif /* _ASM_GENERIC_PERCPU_H_ */
diff -ruNp linux-2.6.22-rt1.orig/include/asm-i386/percpu.h linux-2.6.22-rt1.test/include/asm-i386/percpu.h
--- linux-2.6.22-rt1.orig/include/asm-i386/percpu.h	2007-07-12 09:13:32.000000000 +0200
+++ linux-2.6.22-rt1.test/include/asm-i386/percpu.h	2007-07-12 09:05:12.000000000 +0200
@@ -54,6 +54,10 @@ extern unsigned long __per_cpu_offset[];
 #define DEFINE_PER_CPU(type, name) \
     __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name
 
+#define DEFINE_PER_CPU_LOCKED(type, name) \
+    __attribute__((__section__(".data.percpu"))) __DEFINE_SPINLOCK(per_cpu_lock__##name##_locked); \
+    __attribute__((__section__(".data.percpu"))) __typeof__(type) per_cpu__##name##_locked
+
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
@@ -69,6 +73,15 @@ DECLARE_PER_CPU(unsigned long, this_cpu_
 
 #define __get_cpu_var(var) __raw_get_cpu_var(var)
 
+#define per_cpu_lock(var, cpu) \
+	(*RELOC_HIDE(&per_cpu_lock__##var##_locked, __per_cpu_offset[cpu]))
+#define per_cpu_var_locked(var, cpu) \
+		(*RELOC_HIDE(&per_cpu__##var##_locked, __per_cpu_offset[cpu]))
+#define __get_cpu_lock(var, cpu) \
+		per_cpu_lock(var, cpu)
+#define __get_cpu_var_locked(var, cpu) \
+		per_cpu_var_locked(var, cpu)
+
 /* A macro to avoid #include hell... */
 #define percpu_modcopy(pcpudst, src, size)			\
 do {								\
@@ -144,6 +157,14 @@ extern void __bad_percpu_size(void);
 #define x86_add_percpu(var,val) percpu_to_op("add", per_cpu__##var, val)
 #define x86_sub_percpu(var,val) percpu_to_op("sub", per_cpu__##var, val)
 #define x86_or_percpu(var,val) percpu_to_op("or", per_cpu__##var, val)
+
+#define DECLARE_PER_CPU_LOCKED(type, name) \
+    extern spinlock_t per_cpu_lock__##name##_locked; \
+    extern __typeof__(type) per_cpu__##name##_locked
+
+#define EXPORT_PER_CPU_LOCKED_SYMBOL(var) EXPORT_SYMBOL(per_cpu_lock__##var##_locked); EXPORT_SYMBOL(per_cpu__##var##_locked)
+#define EXPORT_PER_CPU_LOCKED_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu_lock__##var##_locked); EXPORT_SYMBOL_GPL(per_cpu__##var##_locked)
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* __ARCH_I386_PERCPU__ */

--=-iaal7ahNOjjeRTOnWzAI--

