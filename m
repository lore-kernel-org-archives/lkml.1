Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbYGXDpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbYGXDpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 23:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYGXDpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 23:45:11 -0400
Received: from ozlabs.org ([203.10.76.45]:46501 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbYGXDpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 23:45:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/1] cpumask: Change cpumask_of_cpu to use cpumask_of_cpu_map
Date: Thu, 24 Jul 2008 12:45:15 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Dave Jones <davej@codemonkey.org.uk>, Paul Jackson <pj@sgi.com>,
       Tony Luck <tony.luck@intel.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robert Richter <robert.richter@amd.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Sam Creasey <sammy@sammy.net>, Greg Banks <gnb@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@suse.de>, Johannes Weiner <hannes@saeurebad.de>
References: <20080723171841.815234000@polaris-admin.engr.sgi.com> <20080723171841.997896000@polaris-admin.engr.sgi.com>
In-Reply-To: <20080723171841.997896000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807241245.17239.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008 03:18:42 Mike Travis wrote:
>     Note that the declaration of cpumask_of_cpu_map[] is initialized
>     so that cpumask_of_cpu(0) is defined early.  This assumes that
>     cpu 0 is the boot cpu.

Hi Mike,

   Make this statically initialized please.  That almost guarantees there'll
be no problems.  It's a little tricky to do, but possible.  Patch below
tested on 32 bit x86 only.

> Based on linux-2.6.tip/master at the following commit:
>
>     commit a099a9b18ab434594bb01ed920e8c58574203fa9
>     Merge: 9b4ae4d... f3b51d7...
>     Author: Ingo Molnar <mingo@elte.hu>
>     Date:   Tue Jul 22 15:43:36 2008 +0200
>
>     Merge branch 'out-of-tree'

This is two-steps forward one step back.  Have Ingo drop the original
patches, and roll together into a single change.  That should be much
clearer.  I know it's a PITA.

Thanks,
Rusty.

Make cpumask_of_cpu_map generic

If an arch doesn't define cpumask_of_cpu_map, create a generic
statically-initialized one for them.  This allows removal of the buggy
cpumask_of_cpu() macro (&cpumask_of_cpu() gives address of
out-of-scope var).

An arch with NR_CPUS of 4096 probably wants to allocate this itself
based on the actual number of CPUs, since otherwise they're using 2MB
of rodata (1024 cpus means 128k).  That's what
CONFIG_HAVE_CPUMASK_OF_CPU_MAP is for (only x86/64 does so at the
moment).

In future as we support more CPUs, we'll need to resort to a
get_cpu_map()/put_cpu_map() allocation scheme.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 95e128369c3c include/linux/cpumask.h
--- a/include/linux/cpumask.h	Thu Jul 24 11:16:27 2008 +1000
+++ b/include/linux/cpumask.h	Thu Jul 24 12:33:45 2008 +1000
@@ -226,23 +226,8 @@ int __next_cpu(int n, const cpumask_t *s
 #define next_cpu(n, src)	({ (void)(src); 1; })
 #endif
 
-#ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
-extern cpumask_t *cpumask_of_cpu_map;
+extern const cpumask_t *cpumask_of_cpu_map;
 #define cpumask_of_cpu(cpu)    (cpumask_of_cpu_map[cpu])
-
-#else
-#define cpumask_of_cpu(cpu)						\
-(*({									\
-	typeof(_unused_cpumask_arg_) m;					\
-	if (sizeof(m) == sizeof(unsigned long)) {			\
-		m.bits[0] = 1UL<<(cpu);					\
-	} else {							\
-		cpus_clear(m);						\
-		cpu_set((cpu), m);					\
-	}								\
-	&m;								\
-}))
-#endif
 
 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
 
diff -r 95e128369c3c kernel/cpu.c
--- a/kernel/cpu.c	Thu Jul 24 11:16:27 2008 +1000
+++ b/kernel/cpu.c	Thu Jul 24 12:33:45 2008 +1000
@@ -428,3 +428,112 @@ out:
 #endif /* CONFIG_PM_SLEEP_SMP */
 
 #endif /* CONFIG_SMP */
+
+#ifndef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
+/* 64 bits of zeros, for initializers. */
+#if BITS_PER_LONG == 32
+#define Z64 0, 0
+#else
+#define Z64 0
+#endif
+
+/* Initializer macros. */
+#define CMI0(n) { .bits = { 1UL << (n) } }
+#define CMI(n, ...) { .bits = { __VA_ARGS__, 1UL << ((n) % BITS_PER_LONG) } }
+
+#define CMI8(n, ...)						\
+	CMI((n), __VA_ARGS__), CMI((n)+1, __VA_ARGS__),		\
+	CMI((n)+2, __VA_ARGS__), CMI((n)+3, __VA_ARGS__),	\
+	CMI((n)+4, __VA_ARGS__), CMI((n)+5, __VA_ARGS__),	\
+	CMI((n)+6, __VA_ARGS__), CMI((n)+7, __VA_ARGS__)
+
+#if BITS_PER_LONG == 32
+#define CMI64(n, ...)							\
+	CMI8((n), __VA_ARGS__), CMI8((n)+8, __VA_ARGS__),		\
+	CMI8((n)+16, __VA_ARGS__), CMI8((n)+24, __VA_ARGS__),		\
+	CMI8((n)+32, 0, __VA_ARGS__), CMI8((n)+40, 0, __VA_ARGS__),	\
+	CMI8((n)+48, 0, __VA_ARGS__), CMI8((n)+56, 0, __VA_ARGS__)
+#else
+#define CMI64(n, ...)							\
+	CMI8((n), __VA_ARGS__), CMI8((n)+8, __VA_ARGS__),		\
+	CMI8((n)+16, __VA_ARGS__), CMI8((n)+24, __VA_ARGS__),		\
+	CMI8((n)+32, __VA_ARGS__), CMI8((n)+40, __VA_ARGS__),	\
+	CMI8((n)+48, __VA_ARGS__), CMI8((n)+56, __VA_ARGS__)
+#endif
+
+#define CMI256(n, ...)							\
+	CMI64((n), __VA_ARGS__), CMI64((n)+64, Z64, __VA_ARGS__),	\
+	CMI64((n)+128, Z64, Z64, __VA_ARGS__),				\
+	CMI64((n)+192, Z64, Z64, Z64, __VA_ARGS__)
+#define Z256 Z64, Z64, Z64, Z64
+
+#define CMI1024(n, ...)					\
+	CMI256((n), __VA_ARGS__),			\
+	CMI256((n)+256, Z256, __VA_ARGS__),		\
+	CMI256((n)+512, Z256, Z256, __VA_ARGS__),	\
+	CMI256((n)+768, Z256, Z256, Z256, __VA_ARGS__)
+#define Z1024 Z256, Z256, Z256, Z256
+
+/* We want this statically initialized, just to be safe.  We try not
+ * to waste too much space, either. */
+static const cpumask_t cpumask_map[] = {
+	CMI0(0), CMI0(1), CMI0(2), CMI0(3),
+#if NR_CPUS > 4
+	CMI0(4), CMI0(5), CMI0(6), CMI0(7), 
+#endif
+#if NR_CPUS > 8
+	CMI0(8), CMI0(9), CMI0(10), CMI0(11), 
+	CMI0(12), CMI0(13), CMI0(14), CMI0(15), 
+#endif
+#if NR_CPUS > 16
+	CMI0(16), CMI0(17), CMI0(18), CMI0(19), 
+	CMI0(20), CMI0(21), CMI0(22), CMI0(23),
+	CMI0(24), CMI0(25), CMI0(26), CMI0(27),
+	CMI0(28), CMI0(29), CMI0(30), CMI0(31),
+#endif
+#if NR_CPUS > 32
+#if BITS_PER_LONG == 32
+	CMI(32, 0), CMI(33, 0), CMI(34, 0), CMI(35, 0), 
+	CMI(36, 0), CMI(37, 0), CMI(38, 0), CMI(39, 0),
+	CMI(40, 0), CMI(41, 0), CMI(42, 0), CMI(43, 0),
+	CMI(44, 0), CMI(45, 0), CMI(46, 0), CMI(47, 0),
+	CMI(48, 0), CMI(49, 0), CMI(50, 0), CMI(51, 0), 
+	CMI(52, 0), CMI(53, 0), CMI(54, 0), CMI(55, 0),
+	CMI(56, 0), CMI(57, 0), CMI(58, 0), CMI(59, 0),
+	CMI(60, 0), CMI(61, 0), CMI(62, 0), CMI(63, 0),
+#else
+	CMI0(32), CMI0(33), CMI0(34), CMI0(35), 
+	CMI0(36), CMI0(37), CMI0(38), CMI0(39),
+	CMI0(40), CMI0(41), CMI0(42), CMI0(43),
+	CMI0(44), CMI0(45), CMI0(46), CMI0(47),
+	CMI0(48), CMI0(49), CMI0(50), CMI0(51), 
+	CMI0(52), CMI0(53), CMI0(54), CMI0(55),
+	CMI0(56), CMI0(57), CMI0(58), CMI0(59),
+	CMI0(60), CMI0(61), CMI0(62), CMI0(63),
+#endif /* BITS_PER_LONG == 64 */
+#endif
+#if NR_CPUS > 64
+	CMI64(64, Z64),
+#endif
+#if NR_CPUS > 128
+	CMI64(128, Z64, Z64), CMI64(192, Z64, Z64, Z64),
+#endif
+#if NR_CPUS > 256
+	CMI256(256, Z256),
+#endif
+#if NR_CPUS > 512
+	CMI256(512, Z256, Z256), CMI256(768, Z256, Z256, Z256),
+#endif
+#if NR_CPUS > 1024
+	CMI1024(1024, Z1024),
+#endif
+#if NR_CPUS > 2048
+	CMI1024(2048, Z1024, Z1024), CMI1024(3072, Z1024, Z1024, Z1024), 
+#endif
+#if NR_CPUS > 4096
+#error NR_CPUS too big.  Fix initializers or set CONFIG_HAVE_CPUMASK_OF_CPU_MAP
+#endif
+};
+
+const cpumask_t *cpumask_of_cpu_map = cpumask_map;
+#endif /* !CONFIG_HAVE_CPUMASK_OF_CPU_MAP */
