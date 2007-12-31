Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbXLaSti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbXLaSti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 13:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbXLaSta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 13:49:30 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:35423 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbXLaSta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 13:49:30 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: asm-x86/msr.h for sanitized headers: clean it or punt it
Date: Mon, 31 Dec 2007 13:49:27 -0500
User-Agent: KMail/1.9.7
Cc: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, mingo@redhat.com,
       LKML <linux-kernel@vger.kernel.org>
References: <200712310045.24069.vapier@gentoo.org> <200712311310.32337.vapier@gentoo.org> <477931C8.4060208@zytor.com>
In-Reply-To: <477931C8.4060208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712311349.28081.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use __asm__ and __volatile__ in code that is exported to userspace.  Wrap
kernel functions with __KERNEL__ so they get scrubbed.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
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
