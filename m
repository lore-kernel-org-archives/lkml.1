Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbYAARY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbYAARY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 12:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbYAARYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 12:24:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57887 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbYAARYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 12:24:48 -0500
Date: Tue, 1 Jan 2008 18:21:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080101172111.GA9714@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

two fixes for v2.6.24, for exported headers bugs. (no effect on the 
kernel side)

	Ingo

------------------>
Mike Frysinger (2):
      x86: fix asm-x86/byteorder.h for userspace export
      x86: fix asm-x86/msr.h for user-space export

 byteorder.h |    4 +--
 msr.h       |   74 +++++++++++++++++++++++++++++++-----------------------------
 2 files changed, 41 insertions(+), 37 deletions(-)

diff --git a/include/asm-x86/byteorder.h b/include/asm-x86/byteorder.h
index 1f2d6d5..fe2f2e5 100644
--- a/include/asm-x86/byteorder.h
+++ b/include/asm-x86/byteorder.h
@@ -30,13 +30,13 @@ static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 val)
 	} v;
 	v.u = val;
 #ifdef CONFIG_X86_BSWAP
-	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
+	__asm__("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
 #else
 	v.s.a = ___arch__swab32(v.s.a);
 	v.s.b = ___arch__swab32(v.s.b);
-	asm("xchgl %0,%1" : "=r" (v.s.a), "=r" (v.s.b) : "0" (v.s.a), "1" (v.s.b));
+	__asm__("xchgl %0,%1" : "=r" (v.s.a), "=r" (v.s.b) : "0" (v.s.a), "1" (v.s.b));
 #endif
 	return v.u;
 }
diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index ba4b314..664a2fa 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -191,38 +191,6 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 
 #define wrmsrl(msr,val) wrmsr(msr,(__u32)((__u64)(val)),((__u64)(val))>>32)
 
-/* wrmsr with exception handling */
-#define wrmsr_safe(msr,a,b) ({ int ret__;			\
-	asm volatile("2: wrmsr ; xorl %0,%0\n"			\
-		     "1:\n\t"					\
-		     ".section .fixup,\"ax\"\n\t"		\
-		     "3:  movl %4,%0 ; jmp 1b\n\t"		\
-		     ".previous\n\t"				\
-		     ".section __ex_table,\"a\"\n"		\
-		     "   .align 8\n\t"				\
-		     "   .quad	2b,3b\n\t"			\
-		     ".previous"				\
-		     : "=a" (ret__)				\
-		     : "c" (msr), "0" (a), "d" (b), "i" (-EFAULT)); \
-	ret__; })
-
-#define checking_wrmsrl(msr,val) wrmsr_safe(msr,(u32)(val),(u32)((val)>>32))
-
-#define rdmsr_safe(msr,a,b) \
-	({ int ret__;						\
-	  asm volatile ("1:       rdmsr\n"			\
-			"2:\n"					\
-			".section .fixup,\"ax\"\n"		\
-			"3:       movl %4,%0\n"			\
-			" jmp 2b\n"				\
-			".previous\n"				\
-			".section __ex_table,\"a\"\n"		\
-			" .align 8\n"				\
-			" .quad 1b,3b\n"				\
-			".previous":"=&bDS" (ret__), "=a"(*(a)), "=d"(*(b)) \
-			:"c"(msr), "i"(-EIO), "0"(0));			\
-	  ret__; })
-
 #define rdtsc(low,high) \
      __asm__ __volatile__("rdtsc" : "=a" (low), "=d" (high))
 
@@ -230,17 +198,17 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
      __asm__ __volatile__ ("rdtsc" : "=a" (low) : : "edx")
 
 #define rdtscp(low,high,aux) \
-     asm volatile (".byte 0x0f,0x01,0xf9" : "=a" (low), "=d" (high), "=c" (aux))
+     __asm__ __volatile__ (".byte 0x0f,0x01,0xf9" : "=a" (low), "=d" (high), "=c" (aux))
 
 #define rdtscll(val) do { \
      unsigned int __a,__d; \
-     asm volatile("rdtsc" : "=a" (__a), "=d" (__d)); \
+     __asm__ __volatile__("rdtsc" : "=a" (__a), "=d" (__d)); \
      (val) = ((unsigned long)__a) | (((unsigned long)__d)<<32); \
 } while(0)
 
 #define rdtscpll(val, aux) do { \
      unsigned long __a, __d; \
-     asm volatile (".byte 0x0f,0x01,0xf9" : "=a" (__a), "=d" (__d), "=c" (aux)); \
+     __asm__ __volatile__ (".byte 0x0f,0x01,0xf9" : "=a" (__a), "=d" (__d), "=c" (aux)); \
      (val) = (__d << 32) | __a; \
 } while (0)
 
@@ -253,6 +221,7 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 			  : "=a" (low), "=d" (high) \
 			  : "c" (counter))
 
+
 static inline void cpuid(int op, unsigned int *eax, unsigned int *ebx,
 			 unsigned int *ecx, unsigned int *edx)
 {
@@ -320,6 +289,40 @@ static inline unsigned int cpuid_edx(unsigned int op)
 	return edx;
 }
 
+#ifdef __KERNEL__
+
+/* wrmsr with exception handling */
+#define wrmsr_safe(msr,a,b) ({ int ret__;			\
+	asm volatile("2: wrmsr ; xorl %0,%0\n"			\
+		     "1:\n\t"					\
+		     ".section .fixup,\"ax\"\n\t"		\
+		     "3:  movl %4,%0 ; jmp 1b\n\t"		\
+		     ".previous\n\t"				\
+		     ".section __ex_table,\"a\"\n"		\
+		     "   .align 8\n\t"				\
+		     "   .quad	2b,3b\n\t"			\
+		     ".previous"				\
+		     : "=a" (ret__)				\
+		     : "c" (msr), "0" (a), "d" (b), "i" (-EFAULT)); \
+	ret__; })
+
+#define checking_wrmsrl(msr,val) wrmsr_safe(msr,(u32)(val),(u32)((val)>>32))
+
+#define rdmsr_safe(msr,a,b) \
+	({ int ret__;						\
+	  asm volatile ("1:       rdmsr\n"			\
+			"2:\n"					\
+			".section .fixup,\"ax\"\n"		\
+			"3:       movl %4,%0\n"			\
+			" jmp 2b\n"				\
+			".previous\n"				\
+			".section __ex_table,\"a\"\n"		\
+			" .align 8\n"				\
+			" .quad 1b,3b\n"				\
+			".previous":"=&bDS" (ret__), "=a"(*(a)), "=d"(*(b)) \
+			:"c"(msr), "i"(-EIO), "0"(0));			\
+	  ret__; })
+
 #ifdef CONFIG_SMP
 void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
@@ -343,6 +346,7 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 	return wrmsr_safe(msr_no, l, h);
 }
 #endif  /* CONFIG_SMP */
+#endif  /* __KERNEL__ */
 #endif  /* __ASSEMBLY__ */
 
 #endif  /* !__i386__ */
