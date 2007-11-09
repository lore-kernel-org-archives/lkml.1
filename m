Return-Path: <linux-kernel-owner+w=401wt.eu-S1760283AbXKIVck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbXKIVck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757820AbXKIV3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:29:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757559AbXKIV3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:29:12 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7/24] consolidate msr.h
Date: Fri,  9 Nov 2007 16:42:48 -0200
Message-Id: <11946338263902-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11946338212915-git-send-email-gcosta@redhat.com>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com> <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com> <11946338212915-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch goes one step forward in consolidating the msr.h header.
It shares code between i386 and x86_64, instead of duplicating the
code for tsc reading, msr reading/writing, etc.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/ia32/syscall32.c        |    2 +-
 arch/x86/kernel/setup64.c        |    6 +-
 arch/x86/kernel/tsc_64.c         |   17 +++-
 arch/x86/kernel/vsyscall_64.c    |    4 +-
 arch/x86/vdso/vgetcpu.c          |    4 +-
 include/asm-x86/alternative_32.h |   17 +++-
 include/asm-x86/alternative_64.h |   27 ++++-
 include/asm-x86/msr.h            |  225 ++++++++++----------------------------
 include/asm-x86/tsc.h            |   33 +++++-
 9 files changed, 151 insertions(+), 184 deletions(-)

diff --git a/arch/x86/ia32/syscall32.c b/arch/x86/ia32/syscall32.c
index d751d96..a1247ed 100644
--- a/arch/x86/ia32/syscall32.c
+++ b/arch/x86/ia32/syscall32.c
@@ -82,5 +82,5 @@ void syscall32_cpu_init(void)
 	checking_wrmsrl(MSR_IA32_SYSENTER_ESP, 0ULL);
 	checking_wrmsrl(MSR_IA32_SYSENTER_EIP, (u64)ia32_sysenter_target);
 
-	wrmsrl(MSR_CSTAR, ia32_cstar_target);
+	wrmsrl(MSR_CSTAR, (u64)ia32_cstar_target);
 }
diff --git a/arch/x86/kernel/setup64.c b/arch/x86/kernel/setup64.c
index 3558ac7..50b7514 100644
--- a/arch/x86/kernel/setup64.c
+++ b/arch/x86/kernel/setup64.c
@@ -122,7 +122,7 @@ void pda_init(int cpu)
 	asm volatile("movl %0,%%fs ; movl %0,%%gs" :: "r" (0)); 
 	/* Memory clobbers used to order PDA accessed */
 	mb();
-	wrmsrl(MSR_GS_BASE, pda);
+	wrmsrl(MSR_GS_BASE, (u64)pda);
 	mb();
 
 	pda->cpunumber = cpu; 
@@ -161,8 +161,8 @@ void syscall_init(void)
 	 * but only a 32bit target. LSTAR sets the 64bit rip. 	 
 	 */ 
 	wrmsrl(MSR_STAR,  ((u64)__USER32_CS)<<48  | ((u64)__KERNEL_CS)<<32); 
-	wrmsrl(MSR_LSTAR, system_call); 
-	wrmsrl(MSR_CSTAR, ignore_sysret);
+	wrmsrl(MSR_LSTAR, (u64)system_call);
+	wrmsrl(MSR_CSTAR, (u64)ignore_sysret);
 
 #ifdef CONFIG_IA32_EMULATION   		
 	syscall32_cpu_init ();
diff --git a/arch/x86/kernel/tsc_64.c b/arch/x86/kernel/tsc_64.c
index 9c70af4..4502539 100644
--- a/arch/x86/kernel/tsc_64.c
+++ b/arch/x86/kernel/tsc_64.c
@@ -30,7 +30,7 @@ static unsigned long long cycles_2_ns(unsigned long long cyc)
 	return (cyc * cyc2ns_scale) >> NS_SCALE;
 }
 
-unsigned long long sched_clock(void)
+unsigned long long native_sched_clock(void)
 {
 	unsigned long a = 0;
 
@@ -44,6 +44,19 @@ unsigned long long sched_clock(void)
 	return cycles_2_ns(a);
 }
 
+/* We need to define a real function for sched_clock, to override the
+   weak default version */
+#ifdef CONFIG_PARAVIRT
+unsigned long long sched_clock(void)
+{
+	return paravirt_sched_clock();
+}
+#else
+unsigned long long
+sched_clock(void) __attribute__((alias("native_sched_clock")));
+#endif
+
+
 static int tsc_unstable;
 
 inline int check_tsc_unstable(void)
@@ -256,7 +269,7 @@ static cycle_t read_tsc(void)
 
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
-	cycle_t ret = (cycle_t)get_cycles_sync();
+	cycle_t ret = (cycle_t)vget_cycles_sync();
 	return ret;
 }
 
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index ad4005c..1425d02 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -190,7 +190,7 @@ time_t __vsyscall(1) vtime(time_t *t)
 long __vsyscall(2)
 vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
 {
-	unsigned int dummy, p;
+	unsigned int p;
 	unsigned long j = 0;
 
 	/* Fast cache - only recompute value once per jiffies and avoid
@@ -205,7 +205,7 @@ vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
 		p = tcache->blob[1];
 	} else if (__vgetcpu_mode == VGETCPU_RDTSCP) {
 		/* Load per CPU data from RDTSCP */
-		rdtscp(dummy, dummy, p);
+		native_read_tscp(&p);
 	} else {
 		/* Load per CPU data from GDT */
 		asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
diff --git a/arch/x86/vdso/vgetcpu.c b/arch/x86/vdso/vgetcpu.c
index 91f6e85..61d0def 100644
--- a/arch/x86/vdso/vgetcpu.c
+++ b/arch/x86/vdso/vgetcpu.c
@@ -15,7 +15,7 @@
 
 long __vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
 {
-	unsigned int dummy, p;
+	unsigned int p;
 	unsigned long j = 0;
 
 	/* Fast cache - only recompute value once per jiffies and avoid
@@ -30,7 +30,7 @@ long __vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
 		p = tcache->blob[1];
 	} else if (*vdso_vgetcpu_mode == VGETCPU_RDTSCP) {
 		/* Load per CPU data from RDTSCP */
-		rdtscp(dummy, dummy, p);
+		native_read_tscp(&p);
 	} else {
 		/* Load per CPU data from GDT */
 		asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
diff --git a/include/asm-x86/alternative_32.h b/include/asm-x86/alternative_32.h
index bda6c81..1ed7708 100644
--- a/include/asm-x86/alternative_32.h
+++ b/include/asm-x86/alternative_32.h
@@ -101,7 +101,22 @@ static inline void alternatives_smp_switch(int smp) {}
  * use this macro(s) if you need more than one output parameter
  * in alternative_io
  */
-#define ASM_OUTPUT2(a, b) a, b
+#define ASM_OUTPUT2(a, b...) a, b
+
+#define fixup_section(code, fixup, output, input...)		\
+		asm volatile("2: " code "\n"                    \
+			     "1:\n\t"                           \
+			     ".section .fixup,\"ax\"\n\t"       \
+			     "3: "  fixup "\n\t"                \
+			     "jmp 1b\n\t"                       \
+			     ".previous\n\t"                    \
+			     ".section __ex_table,\"a\"\n"      \
+			     "   .align 4\n\t"                  \
+			     "   .long  2b,3b\n\t"              \
+			     ".previous"                        \
+			     : output                           \
+			     : input)
+
 
 /*
  * Alternative inline assembly for SMP.
diff --git a/include/asm-x86/alternative_64.h b/include/asm-x86/alternative_64.h
index ab161e8..f080b69 100644
--- a/include/asm-x86/alternative_64.h
+++ b/include/asm-x86/alternative_64.h
@@ -141,14 +141,29 @@ static inline void alternatives_smp_switch(int smp) {}
  * use this macro(s) if you need more than one output parameter
  * in alternative_io
  */
-#define ASM_OUTPUT2(a, b) a, b
-
-struct paravirt_patch;
+#define ASM_OUTPUT2(a, b...) a, b
+
+#define fixup_section(code, fixup, output, input...)   \
+		asm volatile("2: " code "\n"                    \
+			     "1:\n\t"                           \
+			     ".section .fixup,\"ax\"\n\t"       \
+			     "3: " fixup "\n\t"                 \
+			     " jmp 1b\n\t"                      \
+			     ".previous\n\t"                    \
+			     ".section __ex_table,\"a\"\n"      \
+			     "   .align 8\n\t"                  \
+			     "   .quad  2b,3b\n\t"              \
+			     ".previous"                        \
+			     : output                           \
+			     : input)
+
+struct paravirt_patch_site;
 #ifdef CONFIG_PARAVIRT
-void apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end);
+void apply_paravirt(struct paravirt_patch_site *start,
+		    struct paravirt_patch_site *end);
 #else
-static inline void
-apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end)
+static inline void apply_paravirt(struct paravirt_patch_site *start,
+				  struct paravirt_patch_site *end)
 {}
 #define __parainstructions NULL
 #define __parainstructions_end NULL
diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index 48f73c7..9171564 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -3,8 +3,6 @@
 
 #include <asm/msr-index.h>
 
-#ifdef __i386__
-
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
@@ -12,70 +10,66 @@
 
 static inline unsigned long long native_read_msr(unsigned int msr)
 {
-	unsigned long long val;
-
-	asm volatile("rdmsr" : "=A" (val) : "c" (msr));
-	return val;
+	unsigned long a, d;
+	asm volatile("rdmsr" : "=a" (a), "=d" (d) : "c" (msr));
+	return a | ((u64)d << 32);
 }
 
 static inline unsigned long long native_read_msr_safe(unsigned int msr,
 						      int *err)
 {
-	unsigned long long val;
-
-	asm volatile("2: rdmsr ; xorl %0,%0\n"
-		     "1:\n\t"
-		     ".section .fixup,\"ax\"\n\t"
-		     "3:  movl %3,%0 ; jmp 1b\n\t"
-		     ".previous\n\t"
-		     ".section __ex_table,\"a\"\n"
-		     "   .align 4\n\t"
-		     "   .long	2b,3b\n\t"
-		     ".previous"
-		     : "=r" (*err), "=A" (val)
-		     : "c" (msr), "i" (-EFAULT));
-
-	return val;
+	unsigned long a, d;
+	fixup_section("rdmsr; xor %0, %0", "mov %4, %0",
+	ASM_OUTPUT2("=r" (*err), "=a"((a)), "=d"((d))),
+		    "c"(msr), "i"(-EFAULT), "0"(0));
+	return a | ((u64)d << 32);
 }
 
-static inline void native_write_msr(unsigned int msr, unsigned long long val)
+static inline void native_write_msr(unsigned int msr, unsigned low,
+				    unsigned high)
 {
-	asm volatile("wrmsr" : : "c" (msr), "A"(val));
+	asm volatile("wrmsr" : : "c" (msr), "a"(low), "d" (high));
 }
 
 static inline int native_write_msr_safe(unsigned int msr,
-					unsigned long long val)
+					unsigned low, unsigned high)
 {
 	int err;
-	asm volatile("2: wrmsr ; xorl %0,%0\n"
-		     "1:\n\t"
-		     ".section .fixup,\"ax\"\n\t"
-		     "3:  movl %4,%0 ; jmp 1b\n\t"
-		     ".previous\n\t"
-		     ".section __ex_table,\"a\"\n"
-		     "   .align 4\n\t"
-		     "   .long	2b,3b\n\t"
-		     ".previous"
-		     : "=a" (err)
-		     : "c" (msr), "0" ((u32)val), "d" ((u32)(val>>32)),
-		       "i" (-EFAULT));
+	fixup_section("wrmsr; xor %0, %0", "mov %4, %0", "=a" (err),
+		      "c" (msr), "0" (low), "d" (high),
+		      "i" (-EFAULT));
 	return err;
 }
 
 static inline unsigned long long native_read_tsc(void)
 {
-	unsigned long long val;
-	asm volatile("rdtsc" : "=A" (val));
-	return val;
+	unsigned int low, high;
+	asm volatile("rdtsc" : "=a" (low), "=d" (high));
+	return low | ((u64)(high) << 32);
 }
 
-static inline unsigned long long native_read_pmc(void)
+static inline unsigned long long native_read_pmc(int counter)
 {
-	unsigned long long val;
-	asm volatile("rdpmc" : "=A" (val));
-	return val;
+	unsigned long low, high;
+	asm volatile ("rdpmc"
+		      : "=a" (low), "=d" (high)
+		      : "c" (counter));
+
+	return low | ((u64)high << 32);
 }
 
+static inline unsigned long long native_read_tscp(int *aux)
+{
+	unsigned long low, high;
+	asm volatile (".byte 0x0f,0x01,0xf9"
+			: "=a" (low), "=d" (high), "=c" (*aux));
+	return low | ((u64)high >> 32);
+}
+
+#endif  /* ! __ASSEMBLY__ */
+#endif  /* __KERNEL__ */
+
+#ifndef __ASSEMBLY__
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
@@ -93,20 +87,26 @@ static inline unsigned long long native_read_pmc(void)
 		(val2) = (u32)(__val >> 32);				\
 	} while(0)
 
-static inline void wrmsr(u32 __msr, u32 __low, u32 __high)
+static inline void wrmsr(unsigned int msr, unsigned int low, unsigned int high)
 {
-	native_write_msr(__msr, ((u64)__high << 32) | __low);
+	native_write_msr(msr, low, high);
 }
 
 #define rdmsrl(msr,val)							\
 	((val) = native_read_msr(msr))
 
-#define wrmsrl(msr,val)	native_write_msr(msr, val)
+static inline void wrmsrl(unsigned int msr, unsigned long long val)
+{
+	unsigned long low, high;
+	low = (u32)val;
+	high = val >> 32;
+	native_write_msr(msr, low, high);
+}
 
 /* wrmsr with exception handling */
-static inline int wrmsr_safe(u32 __msr, u32 __low, u32 __high)
+static inline int wrmsr_safe(int msr, int low, int high)
 {
-	return native_write_msr_safe(__msr, ((u64)__high << 32) | __low);
+	return native_write_msr_safe(msr, low, high);
 }
 
 /* rdmsr with exception handling */
@@ -129,130 +129,28 @@ static inline int wrmsr_safe(u32 __msr, u32 __low, u32 __high)
 
 #define rdpmc(counter,low,high)					\
 	do {							\
-		u64 _l = native_read_pmc();			\
+		u64 _l = native_read_pmc(counter);		\
 		(low)  = (u32)_l;				\
 		(high) = (u32)(_l >> 32);			\
-	} while(0)
-#endif	/* !CONFIG_PARAVIRT */
-
-#ifdef CONFIG_SMP
-void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
-void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
-int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
-int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
-#else  /*  CONFIG_SMP  */
-static inline void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
-{
-	rdmsr(msr_no, *l, *h);
-}
-static inline void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
-{
-	wrmsr(msr_no, l, h);
-}
-static inline int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h)
-{
-	return rdmsr_safe(msr_no, l, h);
-}
-static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
-{
-	return wrmsr_safe(msr_no, l, h);
-}
-#endif  /*  CONFIG_SMP  */
-#endif  /* ! __ASSEMBLY__ */
-#endif  /* __KERNEL__ */
-
-#else   /* __i386__ */
-
-#ifndef __ASSEMBLY__
-#include <linux/errno.h>
-/*
- * Access to machine-specific registers (available on 586 and better only)
- * Note: the rd* operations modify the parameters directly (without using
- * pointer indirection), this allows gcc to optimize better
- */
+	} while (0)
 
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
-
-#define wrmsr(msr,val1,val2) \
-     __asm__ __volatile__("wrmsr" \
-			  : /* no outputs */ \
-			  : "c" (msr), "a" (val1), "d" (val2))
+#define rdtscp(low, high, aux) 						\
+	do {								\
+		unsigned long long _val = native_read_tscp(&(aux));	\
+		(low) = (u32)_val;					\
+		(high) = (u32)(_val >> 32);				\
+	} while (0)
 
-#define wrmsrl(msr,val) wrmsr(msr,(__u32)((__u64)(val)),((__u64)(val))>>32)
+#define rdtscpll(val, aux) (val) = native_read_tscp(&(aux))
 
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
+#endif	/* !CONFIG_PARAVIRT */
 
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
-#define rdtscp(low,high,aux) \
-     asm volatile (".byte 0x0f,0x01,0xf9" : "=a" (low), "=d" (high), "=c" (aux))
-
-#define rdtscll(val) do { \
-     unsigned int __a,__d; \
-     asm volatile("rdtsc" : "=a" (__a), "=d" (__d)); \
-     (val) = ((unsigned long)__a) | (((unsigned long)__d)<<32); \
-} while(0)
-
-#define rdtscpll(val, aux) do { \
-     unsigned long __a, __d; \
-     asm volatile (".byte 0x0f,0x01,0xf9" : "=a" (__a), "=d" (__d), "=c" (aux)); \
-     (val) = (__d << 32) | __a; \
-} while (0)
-
 #define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
 
 #define write_rdtscp_aux(val) wrmsr(0xc0000103, val, 0)
 
-#define rdpmc(counter,low,high) \
-     __asm__ __volatile__("rdpmc" \
-			  : "=a" (low), "=d" (high) \
-			  : "c" (counter))
-
 #ifdef CONFIG_SMP
 void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
@@ -275,9 +173,6 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 {
 	return wrmsr_safe(msr_no, l, h);
 }
-#endif  /* CONFIG_SMP */
-#endif  /* __ASSEMBLY__ */
-
-#endif  /* !__i386__ */
-
+#endif  /*  CONFIG_SMP  */
+#endif  /* ! __ASSEMBLY__ */
 #endif
diff --git a/include/asm-x86/tsc.h b/include/asm-x86/tsc.h
index d7b1c4e..651e6ac 100644
--- a/include/asm-x86/tsc.h
+++ b/include/asm-x86/tsc.h
@@ -33,7 +33,7 @@ static inline cycles_t get_cycles(void)
 }
 
 /* Like get_cycles, but make sure the CPU is synchronized. */
-static __always_inline cycles_t get_cycles_sync(void)
+static __always_inline cycles_t __get_cycles_sync(void)
 {
 	unsigned long long ret;
 	unsigned eax, edx;
@@ -55,11 +55,40 @@ static __always_inline cycles_t get_cycles_sync(void)
 	 */
 	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
 			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
-	rdtscll(ret);
 
+	return 0;
+}
+
+static __always_inline cycles_t get_cycles_sync(void)
+{
+	unsigned long long ret;
+	ret = __get_cycles_sync();
+	if (!ret)
+		rdtscll(ret);
 	return ret;
 }
 
+#ifdef CONFIG_PARAVIRT
+/*
+ * For paravirt guests, some functionalities are executed through function
+ * pointers in the various pvops structures.
+ * These function pointers exist inside the kernel and can not
+ * be accessed by user space. To avoid this, we make a copy of the
+ * get_cycles_sync (called in kernel) but force the use of native_read_tsc.
+ * Ideally, the guest should set up it's own clock and vread
+ */
+static __always_inline long long vget_cycles_sync(void)
+{
+	unsigned long long ret;
+	ret = __get_cycles_sync();
+	if (!ret)
+		ret = native_read_tsc();
+	return ret;
+}
+#else
+# define vget_cycles_sync() get_cycles_sync()
+#endif
+
 extern void tsc_init(void);
 extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
-- 
1.4.4.2

