Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbXLDSvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbXLDSvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbXLDStA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:49:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbXLDSs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:48:58 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 10/10] integrate i386 and x86_64 code in msr.h
Date: Tue,  4 Dec 2007 14:04:00 -0200
Message-Id: <1196784291906-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1196784287349-git-send-email-gcosta@redhat.com>
References: 20071204140939.GA16328@elte.hu <11967842402729-git-send-email-gcosta@redhat.com> <11967842482873-git-send-email-gcosta@redhat.com> <11967842531735-git-send-email-gcosta@redhat.com> <11967842573035-git-send-email-gcosta@redhat.com> <11967842622658-git-send-email-gcosta@redhat.com> <119678426719-git-send-email-gcosta@redhat.com> <11967842711043-git-send-email-gcosta@redhat.com> <11967842762820-git-send-email-gcosta@redhat.com> <11967842821886-git-send-email-gcosta@redhat.com> <1196784287349-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches proceeds with the integration of msr.h, making
the code unified, instead of having a version for each architecture.
We stick with the native_* functions, and then paravirt comes for free.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/msr.h |  161 ++++++++++++++-----------------------------------
 1 files changed, 46 insertions(+), 115 deletions(-)

diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index f3a01ca..84116fa 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -5,6 +5,10 @@
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
+
+#include <asm/asm.h>
+#include <asm/errno.h>
+
 static inline unsigned long long native_read_tscp(int *aux)
 {
 	unsigned long low, high;
@@ -13,37 +17,36 @@ static inline unsigned long long native_read_tscp(int *aux)
 	return low | ((u64)high >> 32);
 }
 
-#define rdtscp(low, high, aux)						\
-       do {                                                            \
-		unsigned long long _val = native_read_tscp(&(aux));     \
-		(low) = (u32)_val;                                      \
-		(high) = (u32)(_val >> 32);                             \
-       } while (0)
-
-#define rdtscpll(val, aux) (val) = native_read_tscp(&(aux))
-#endif
+/*
+ * i386 calling convention returns 64-bit value in edx:eax, while
+ * x86_64 returns at rax. Also, the "A" constraint does not really
+ * mean rdx:rax in x86_64, so we need specialized behaviour for each
+ * architecture
+ */
+#ifdef CONFIG_X86_64
+#define DECLARE_ARGS(val, low, high)	unsigned low, high
+#define EAX_EDX_VAL(val, low, high)	(low | ((u64)(high) << 32))
+#define EAX_EDX_ARGS(val, low, high)	"a" (low), "d" (high)
+#define EAX_EDX_RET(val, low, high)	"=a" (low), "=d" (high)
+#else
+#define DECLARE_ARGS(val, low, high)	unsigned long long val
+#define EAX_EDX_VAL(val, low, high)	(val)
+#define EAX_EDX_ARGS(val, low, high)	"A" (val)
+#define EAX_EDX_RET(val, low, high)	"=A" (val)
 #endif
 
-#ifdef __i386__
-
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
-
-#include <asm/asm.h>
-#include <asm/errno.h>
-
 static inline unsigned long long native_read_msr(unsigned int msr)
 {
-	unsigned long long val;
+	DECLARE_ARGS(val, low, high);
 
-	asm volatile("rdmsr" : "=A" (val) : "c" (msr));
-	return val;
+	asm volatile("rdmsr" : EAX_EDX_RET(val, low, high) : "c" (msr));
+	return EAX_EDX_VAL(val, low, high);
 }
 
 static inline unsigned long long native_read_msr_safe(unsigned int msr,
 						      int *err)
 {
-	unsigned long long val;
+	DECLARE_ARGS(val, low, high);
 
 	asm volatile("2: rdmsr ; xor %0,%0\n"
 		     "1:\n\t"
@@ -54,10 +57,9 @@ static inline unsigned long long native_read_msr_safe(unsigned int msr,
 		     _ASM_ALIGN "\n\t"
 		     _ASM_PTR " 2b,3b\n\t"
 		     ".previous"
-		     : "=r" (*err), "=A" (val)
+		     : "=r" (*err), EAX_EDX_RET(val, low, high)
 		     : "c" (msr), "i" (-EFAULT));
-
-	return val;
+	return EAX_EDX_VAL(val, low, high);
 }
 
 static inline void native_write_msr(unsigned int msr,
@@ -87,16 +89,18 @@ static inline int native_write_msr_safe(unsigned int msr,
 
 static inline unsigned long long native_read_tsc(void)
 {
-	unsigned long long val;
-	asm volatile("rdtsc" : "=A" (val));
-	return val;
+	DECLARE_ARGS(val, low, high);
+
+	asm volatile("rdtsc" : EAX_EDX_RET(val, low, high));
+	return EAX_EDX_VAL(val, low, high);
 }
 
 static inline unsigned long long native_read_pmc(int counter)
 {
-	unsigned long long val;
-	asm volatile("rdpmc" : "=A" (val) : "c" (counter));
-	return val;
+	DECLARE_ARGS(val, low, high);
+
+	asm volatile("rdpmc" : EAX_EDX_RET(val, low, high) : "c" (counter));
+	return EAX_EDX_VAL(val, low, high);
 }
 
 #ifdef CONFIG_PARAVIRT
@@ -124,7 +128,8 @@ static inline void wrmsr(unsigned msr, unsigned low, unsigned high)
 #define rdmsrl(msr,val)							\
 	((val) = native_read_msr(msr))
 
-#define wrmsrl(msr, val) native_write_msr(msr, (u32)val, (u32)(val >> 32))
+#define wrmsrl(msr, val)						\
+	native_write_msr(msr, (u32)((u64)(val)), (u32)((u64)(val) >> 32))
 
 /* wrmsr with exception handling */
 static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
@@ -156,101 +161,25 @@ static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
 		(low)  = (u32)_l;				\
 		(high) = (u32)(_l >> 32);			\
 	} while(0)
-#endif	/* !CONFIG_PARAVIRT */
-
-#endif  /* ! __ASSEMBLY__ */
-#endif  /* __KERNEL__ */
 
-#else   /* __i386__ */
-
-#ifndef __ASSEMBLY__
-#include <linux/errno.h>
-/*
- * Access to machine-specific registers (available on 586 and better only)
- * Note: the rd* operations modify the parameters directly (without using
- * pointer indirection), this allows gcc to optimize better
- */
-
-#define rdmsr(msr,val1,val2) \
-       __asm__ __volatile__("rdmsr" \
-			    : "=a" (val1), "=d" (val2) \
-			    : "c" (msr))
-
-
-#define rdmsrl(msr,val) do { unsigned long a__,b__; \
-       __asm__ __volatile__("rdmsr" \
-			    : "=a" (a__), "=d" (b__) \
-			    : "c" (msr)); \
-       val = a__ | (b__<<32); \
-} while(0)
+#define rdtscp(low, high, aux)						\
+       do {                                                            \
+		unsigned long long _val = native_read_tscp(&(aux));     \
+		(low) = (u32)_val;                                      \
+		(high) = (u32)(_val >> 32);                             \
+       } while (0)
 
-#define wrmsr(msr,val1,val2) \
-     __asm__ __volatile__("wrmsr" \
-			  : /* no outputs */ \
-			  : "c" (msr), "a" (val1), "d" (val2))
+#define rdtscpll(val, aux) (val) = native_read_tscp(&(aux))
 
-#define wrmsrl(msr,val) wrmsr(msr,(__u32)((__u64)(val)),((__u64)(val))>>32)
+#endif	/* !CONFIG_PARAVIRT */
 
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
 
 #define checking_wrmsrl(msr,val) wrmsr_safe(msr,(u32)(val),(u32)((val)>>32))
 
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
-#define rdtsc(low,high) \
-     __asm__ __volatile__("rdtsc" : "=a" (low), "=d" (high))
-
-#define rdtscl(low) \
-     __asm__ __volatile__ ("rdtsc" : "=a" (low) : : "edx")
-
-
-#define rdtscll(val) do { \
-     unsigned int __a,__d; \
-     asm volatile("rdtsc" : "=a" (__a), "=d" (__d)); \
-     (val) = ((unsigned long)__a) | (((unsigned long)__d)<<32); \
-} while(0)
-
 #define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
 
 #define write_rdtscp_aux(val) wrmsr(0xc0000103, val, 0)
 
-#define rdpmc(counter,low,high) \
-     __asm__ __volatile__("rdpmc" \
-			  : "=a" (low), "=d" (high) \
-			  : "c" (counter))
-
-#endif  /* __ASSEMBLY__ */
-
-#endif  /* !__i386__ */
-
-#ifndef __ASSEMBLY__
-
 #ifdef CONFIG_SMP
 void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
@@ -275,5 +204,7 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 }
 #endif  /* CONFIG_SMP */
 #endif /* __ASSEMBLY__ */
+#endif /* __KERNEL__ */
+
 
 #endif
-- 
1.4.4.2

