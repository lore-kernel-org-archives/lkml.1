Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbXLaSKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbXLaSKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 13:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbXLaSKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 13:10:34 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:55057 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbXLaSKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 13:10:33 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: asm-x86/msr.h for sanitized headers: clean it or punt it
Date: Mon, 31 Dec 2007 13:10:31 -0500
User-Agent: KMail/1.9.7
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       LKML <linux-kernel@vger.kernel.org>
References: <200712310045.24069.vapier@gentoo.org> <200712311033.34489.vapier@gentoo.org> <20071231163635.GA15298@one.firstfloor.org>
In-Reply-To: <20071231163635.GA15298@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712311310.32337.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 December 2007, Andi Kleen wrote:
> > can you enumerate which functions need to actually go to userspace then ?
> >  the
>
> rdtscl/rdtscll/rdpmc primarily

i'll just mark out the useless C funcs then

> > __KERNEL__ markings are a crapshoot at the moment.  you must also be
> > jumping through hoops in order to use the header in the first place since
> > the vanilla one wont compile out of the box.
>
> At least the 64bit one or older 32bit one works without hoops. Agreed that
> the paravirt changes destroyed it on newer 32bit though. That's an
> unfortunate regression.

i dont see how when the exported code has prototypes with "u32" types in them.
but at any rate ...
---
Use __asm__ and __volatile__ in code that is exported to userspace.  Wrap
kernel functions with __KERNEL__ so they get scrubbed.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index ba4b314..ffb9319 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -193,7 +193,7 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 
 /* wrmsr with exception handling */
 #define wrmsr_safe(msr,a,b) ({ int ret__;			\
-	asm volatile("2: wrmsr ; xorl %0,%0\n"			\
+	__asm__ __volatile__("2: wrmsr ; xorl %0,%0\n"			\
 		     "1:\n\t"					\
 		     ".section .fixup,\"ax\"\n\t"		\
 		     "3:  movl %4,%0 ; jmp 1b\n\t"		\
@@ -210,7 +210,7 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 
 #define rdmsr_safe(msr,a,b) \
 	({ int ret__;						\
-	  asm volatile ("1:       rdmsr\n"			\
+	  __asm__ __volatile__ ("1:       rdmsr\n"			\
 			"2:\n"					\
 			".section .fixup,\"ax\"\n"		\
 			"3:       movl %4,%0\n"			\
@@ -230,17 +230,17 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
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
 
@@ -320,6 +320,7 @@ static inline unsigned int cpuid_edx(unsigned int op)
 	return edx;
 }
 
+#ifdef __KERNEL__
 #ifdef CONFIG_SMP
 void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
@@ -343,6 +344,7 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 	return wrmsr_safe(msr_no, l, h);
 }
 #endif  /* CONFIG_SMP */
+#endif  /* __KERNEL__ */
 #endif  /* __ASSEMBLY__ */
 
 #endif  /* !__i386__ */
