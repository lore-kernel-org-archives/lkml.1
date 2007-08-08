Return-Path: <linux-kernel-owner+w=401wt.eu-S1765927AbXHHHRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765927AbXHHHRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760931AbXHHHI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:08:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760884AbXHHHIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:08:53 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 13/25] [PATCH] turn msr.h functions into native versions
Date: Wed,  8 Aug 2007 01:19:00 -0300
Message-Id: <11865468043920-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11865468003673-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <11865467741753-git-send-email-gcosta@redhat.com> <11865467773012-git-send-email-gcosta@redhat.com> <11865467812610-git-send-email-gcosta@redhat.com> <1186546785346-git-send-email-gcosta@redhat.com> <1186546789356-git-send-email-gcosta@redhat.com> <11865467931543-git-send-email-gcosta@redhat.com> <11865467973510-git-send-email-gcosta@redhat.com> <11865468003673-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch turns makes the basic operations in msr.h out of native
ones. Those operations are: rdmsr, wrmsr, rdtsc, rdtscp, rdpmc, and
cpuid. After they are turned into functions, some call sites need
casts, and so we provide them.

There is also a fixup needed in the functions located in the vsyscall
area, as they cannot call any of them anymore (otherwise, the call
would go through a kernel address, invalid in userspace mapping).

The solution is to call the now-provided native_ versions instead.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/ia32/syscall32.c  |    2 +-
 arch/x86_64/kernel/setup64.c  |    6 +-
 arch/x86_64/kernel/tsc.c      |   42 ++++++-
 arch/x86_64/kernel/vsyscall.c |    4 +-
 arch/x86_64/vdso/vgetcpu.c    |    4 +-
 include/asm-x86_64/msr.h      |  284 +++++++++++++++++++++++++---------------
 6 files changed, 226 insertions(+), 116 deletions(-)

diff --git a/arch/x86_64/ia32/syscall32.c b/arch/x86_64/ia32/syscall32.c
index 15013ba..dd1b4a3 100644
--- a/arch/x86_64/ia32/syscall32.c
+++ b/arch/x86_64/ia32/syscall32.c
@@ -79,5 +79,5 @@ void syscall32_cpu_init(void)
 	checking_wrmsrl(MSR_IA32_SYSENTER_ESP, 0ULL);
 	checking_wrmsrl(MSR_IA32_SYSENTER_EIP, (u64)ia32_sysenter_target);
 
-	wrmsrl(MSR_CSTAR, ia32_cstar_target);
+	wrmsrl(MSR_CSTAR, (u64)ia32_cstar_target);
 }
diff --git a/arch/x86_64/kernel/setup64.c b/arch/x86_64/kernel/setup64.c
index 1200aaa..395cf02 100644
--- a/arch/x86_64/kernel/setup64.c
+++ b/arch/x86_64/kernel/setup64.c
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
diff --git a/arch/x86_64/kernel/tsc.c b/arch/x86_64/kernel/tsc.c
index 2a59bde..0db0041 100644
--- a/arch/x86_64/kernel/tsc.c
+++ b/arch/x86_64/kernel/tsc.c
@@ -9,6 +9,46 @@
 
 #include <asm/timex.h>
 
+#ifdef CONFIG_PARAVIRT
+/*
+ * When paravirt is on, some functionalities are executed through function
+ * pointers in the paravirt_ops structure, for both the host and guest.
+ * These function pointers exist inside the kernel and can not
+ * be accessed by user space. To avoid this, we make a copy of the
+ * get_cycles_sync (called in kernel) but force the use of native_read_tsc.
+ * For the host, it will simply do the native rdtsc. The guest
+ * should set up it's own clock and vread
+ */
+static __always_inline long long vget_cycles_sync(void)
+{
+	unsigned long long ret;
+	unsigned eax, edx;
+
+	/*
+	 * Use RDTSCP if possible; it is guaranteed to be synchronous
+	 * and doesn't cause a VMEXIT on Hypervisors
+	 */
+	alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
+		       ASM_OUTPUT2("=a" (eax), "=d" (edx)),
+		       "a" (0U), "d" (0U) : "ecx", "memory");
+	ret = (((unsigned long long)edx) << 32) | ((unsigned long long)eax);
+	if (ret)
+		return ret;
+
+	/*
+	 * Don't do an additional sync on CPUs where we know
+	 * RDTSC is already synchronous:
+	 */
+	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
+			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
+	ret = native_read_tsc();
+
+	return ret;
+}
+#else
+# define vget_cycles_sync() get_cycles_sync()
+#endif
+
 static int notsc __initdata = 0;
 
 unsigned int cpu_khz;		/* TSC clocks / usec, not used here */
@@ -165,7 +205,7 @@ static cycle_t read_tsc(void)
 
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
-	cycle_t ret = (cycle_t)get_cycles_sync();
+	cycle_t ret = (cycle_t)vget_cycles_sync();
 	return ret;
 }
 
diff --git a/arch/x86_64/kernel/vsyscall.c b/arch/x86_64/kernel/vsyscall.c
index 06c3494..22fc4c9 100644
--- a/arch/x86_64/kernel/vsyscall.c
+++ b/arch/x86_64/kernel/vsyscall.c
@@ -184,7 +184,7 @@ time_t __vsyscall(1) vtime(time_t *t)
 long __vsyscall(2)
 vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
 {
-	unsigned int dummy, p;
+	unsigned int p;
 	unsigned long j = 0;
 
 	/* Fast cache - only recompute value once per jiffies and avoid
@@ -199,7 +199,7 @@ vgetcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *tcache)
 		p = tcache->blob[1];
 	} else if (__vgetcpu_mode == VGETCPU_RDTSCP) {
 		/* Load per CPU data from RDTSCP */
-		rdtscp(dummy, dummy, p);
+		native_read_tscp(&p);
 	} else {
 		/* Load per CPU data from GDT */
 		asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
diff --git a/arch/x86_64/vdso/vgetcpu.c b/arch/x86_64/vdso/vgetcpu.c
index 91f6e85..61d0def 100644
--- a/arch/x86_64/vdso/vgetcpu.c
+++ b/arch/x86_64/vdso/vgetcpu.c
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
diff --git a/include/asm-x86_64/msr.h b/include/asm-x86_64/msr.h
index d5c55b8..6ec254e 100644
--- a/include/asm-x86_64/msr.h
+++ b/include/asm-x86_64/msr.h
@@ -10,110 +10,193 @@
  * Note: the rd* operations modify the parameters directly (without using
  * pointer indirection), this allows gcc to optimize better
  */
+static inline unsigned long native_read_msr(unsigned int msr)
+{
+	unsigned long a, d;
+	asm volatile("rdmsr" : "=a" (a), "=d" (d) : "c" (msr));
+	return a | (d << 32);
+}
 
-#define rdmsr(msr,val1,val2) \
-       __asm__ __volatile__("rdmsr" \
-			    : "=a" (val1), "=d" (val2) \
-			    : "c" (msr))
+static inline unsigned long native_read_msr_safe(unsigned int msr, int *err)
+{
+	unsigned long a, d;
+	asm volatile (  "1: rdmsr; xorl %0, %0\n"
+			"2:\n"
+			".section .fixup,\"ax\"\n"
+			"3:       movl %4,%0\n"
+			" jmp 2b\n"
+			".previous\n"
+			".section __ex_table,\"a\"\n"
+			" .align 8\n"
+			" .quad 1b,3b\n"
+			".previous":"=&bDS" (*err), "=a"((a)), "=d"((d))
+			:"c"(msr), "i"(-EIO), "0"(0));
+	return a | (d << 32);
+}
 
+static inline unsigned long native_write_msr(unsigned int msr,
+					     unsigned long val)
+{
+	asm volatile(	"wrmsr"
+			: /* no outputs */
+			: "c" (msr), "a" ((u32)val), "d" ((u32)(val>>32)));
+	return 0;
+}
 
-#define rdmsrl(msr,val) do { unsigned long a__,b__; \
-       __asm__ __volatile__("rdmsr" \
-			    : "=a" (a__), "=d" (b__) \
-			    : "c" (msr)); \
-       val = a__ | (b__<<32); \
-} while(0)
+/* wrmsr with exception handling */
+static inline long native_write_msr_safe(unsigned int msr, unsigned long val)
+{
+	unsigned long ret;
+	asm volatile("2: wrmsr ; xorq %0,%0\n"
+		     "1:\n\t"
+		     ".section .fixup,\"ax\"\n\t"
+		     "3:  movq %4,%0 ; jmp 1b\n\t"
+		     ".previous\n\t"
+		     ".section __ex_table,\"a\"\n"
+		     "   .align 8\n\t"
+		     "   .quad 	2b,3b\n\t"
+		     ".previous"
+		     : "=r" (ret)
+		     : "c" (msr), "a" ((u32)val), "d" ((u32)(val>>32)),
+		       "i" (-EFAULT));
+	return ret;
+}
 
-#define wrmsr(msr,val1,val2) \
-     __asm__ __volatile__("wrmsr" \
-			  : /* no outputs */ \
-			  : "c" (msr), "a" (val1), "d" (val2))
+static inline unsigned long native_read_tsc(void)
+{
+	unsigned long low, high;
+	asm volatile("rdtsc" : "=a" (low), "=d" (high));
+	return low | (high << 32);
+}
 
-#define wrmsrl(msr,val) wrmsr(msr,(__u32)((__u64)(val)),((__u64)(val))>>32) 
+static inline unsigned long native_read_pmc(int counter)
+{
+	unsigned long low, high;
+	asm volatile ("rdpmc"
+		      : "=a" (low), "=d" (high)
+		      : "c" (counter));
 
-/* wrmsr with exception handling */
-#define wrmsr_safe(msr,a,b) ({ int ret__;			\
-	asm volatile("2: wrmsr ; xorl %0,%0\n"			\
-		     "1:\n\t"					\
-		     ".section .fixup,\"ax\"\n\t"		\
-		     "3:  movl %4,%0 ; jmp 1b\n\t"		\
-		     ".previous\n\t"				\
- 		     ".section __ex_table,\"a\"\n"		\
-		     "   .align 8\n\t"				\
-		     "   .quad 	2b,3b\n\t"			\
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
-                      "2:\n"					\
-                      ".section .fixup,\"ax\"\n"		\
-                      "3:       movl %4,%0\n"			\
-                      " jmp 2b\n"				\
-                      ".previous\n"				\
-                      ".section __ex_table,\"a\"\n"		\
-                      " .align 8\n"				\
-                      " .quad 1b,3b\n"				\
-                      ".previous":"=&bDS" (ret__), "=a"(*(a)), "=d"(*(b))\
-                      :"c"(msr), "i"(-EIO), "0"(0));		\
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
+	return low | (high << 32);
+}
+
+static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
+				unsigned int *ecx, unsigned int *edx)
+{
+	asm volatile ("cpuid"
+		      : "=a" (*eax),
+			"=b" (*ebx),
+			"=c" (*ecx),
+			"=d" (*edx)
+		      : "0" (*eax), "2" (*ecx));
+}
+
+static inline unsigned long native_read_tscp(int *aux)
+{
+	unsigned long low, high;
+	asm volatile (".byte 0x0f,0x01,0xf9"
+			: "=a" (low), "=d" (high), "=c" (*aux));
+	return low | (high >> 32);
+}
+
+#ifdef CONFIG_PARAVIRT
+#include <asm/paravirt.h>
+#else
+#define read_msr(msr)			native_read_msr(msr)
+#define read_msr_safe(msr, err)		native_read_msr_safe(msr, err)
+#define write_msr(msr, val) 		native_write_msr(msr, val)
+#define write_msr_safe(msr, val)	native_write_msr_safe(msr, val)
+#define read_tsc_reg()			native_read_tsc()
+#define read_tscp(aux)			native_read_tscp(aux)
+#define read_pmc(counter)		native_read_pmc(counter)
+#define __cpuid				native_cpuid
+#endif
+
+#define rdmsr(msr, low, high) 			\
+do {						\
+	unsigned long __val = read_msr(msr); 	\
+	low = (u32)__val;			\
+	high = (u32)(__val >> 32);		\
 } while (0)
 
-#define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
+#define rdmsrl(msr, val)		(val) = read_msr(msr)
+
+#define rdmsr_safe(msr, a, d)					\
+({								\
+	int __ret;						\
+	unsigned long __val = read_msr_safe(msr, &__ret);	\
+	(*a) = (u32)(__val);					\
+	(*d) = (u32)(__val >> 32);				\
+	__ret;							\
+})
+
+#define wrmsr(msr, val1, val2)				\
+do {							\
+	unsigned long __val;				\
+	__val = (unsigned long)val2 << 32;		\
+	__val |= val1;					\
+	write_msr(msr, __val);				\
+} while (0)
+
+#define wrmsrl(msr, val) write_msr(msr, val)
+
+#define wrmsr_safe(msr, a, d) \
+	write_msr_safe(msr, a | ( ((u64)d) << 32))
+
+#define checking_wrmsrl(msr, val) wrmsr_safe(msr, (u32)(val),(u32)((val)>>32))
+
+#define write_tsc(val1, val2) wrmsr(0x10, val1, val2)
 
 #define write_rdtscp_aux(val) wrmsr(0xc0000103, val, 0)
 
-#define rdpmc(counter,low,high) \
-     __asm__ __volatile__("rdpmc" \
-			  : "=a" (low), "=d" (high) \
-			  : "c" (counter))
+#define rdtsc(low, high)			\
+do {						\
+	unsigned long __val  = read_tsc_reg();	\
+	low = (u32)__val;			\
+	high = (u32)(__val >> 32);		\
+} while (0)
+
+#define rdtscl(low) 	(low) = (u32)read_tsc_reg()
+
+#define rdtscll(val)	(val) = read_tsc_reg()
+
+#define rdtscp(low, high, aux)				\
+do {							\
+	int __aux;					\
+	unsigned long __val = read_tscp(&__aux);	\
+	(low) = (u32)__val;				\
+	(high) = (u32)(__val >> 32);			\
+	(aux) = __aux;					\
+} while (0)
+
+#define rdtscpll(val, aux)				\
+do {							\
+	unsigned long __aux; 				\
+	val = read_tscp(&__aux);			\
+	(aux) = __aux;					\
+} while (0)
+
+#define rdpmc(counter, low, high)			\
+do {							\
+	unsigned long __val = read_pmc(counter);	\
+	(low) = (u32)(__val);				\
+	(high) = (u32)(__val >> 32);			\
+} while (0)
 
 static inline void cpuid(int op, unsigned int *eax, unsigned int *ebx,
 			 unsigned int *ecx, unsigned int *edx)
 {
-	__asm__("cpuid"
-		: "=a" (*eax),
-		  "=b" (*ebx),
-		  "=c" (*ecx),
-		  "=d" (*edx)
-		: "0" (op));
+	*eax = op;
+	*ecx = 0;
+	__cpuid(eax, ebx, ecx, edx);
 }
 
 /* Some CPUID calls want 'count' to be placed in ecx */
 static inline void cpuid_count(int op, int count, int *eax, int *ebx, int *ecx,
 	       	int *edx)
 {
-	__asm__("cpuid"
-		: "=a" (*eax),
-		  "=b" (*ebx),
-		  "=c" (*ecx),
-		  "=d" (*edx)
-		: "0" (op), "c" (count));
+	*eax = op;
+	*ecx = count;
+	__cpuid(eax, ebx, ecx, edx);
 }
 
 /*
@@ -121,42 +204,29 @@ static inline void cpuid_count(int op, int count, int *eax, int *ebx, int *ecx,
  */
 static inline unsigned int cpuid_eax(unsigned int op)
 {
-	unsigned int eax;
-
-	__asm__("cpuid"
-		: "=a" (eax)
-		: "0" (op)
-		: "bx", "cx", "dx");
+	unsigned int eax, ebx, ecx, edx;
+	cpuid(op, &eax, &ebx, &ecx, &edx);
 	return eax;
 }
+
 static inline unsigned int cpuid_ebx(unsigned int op)
 {
-	unsigned int eax, ebx;
-
-	__asm__("cpuid"
-		: "=a" (eax), "=b" (ebx)
-		: "0" (op)
-		: "cx", "dx" );
+	unsigned int eax, ebx, ecx, edx;
+	cpuid(op, &eax, &ebx, &ecx, &edx);
 	return ebx;
 }
+
 static inline unsigned int cpuid_ecx(unsigned int op)
 {
-	unsigned int eax, ecx;
-
-	__asm__("cpuid"
-		: "=a" (eax), "=c" (ecx)
-		: "0" (op)
-		: "bx", "dx" );
+	unsigned int eax, ebx, ecx, edx;
+	cpuid(op, &eax, &ebx, &ecx, &edx);
 	return ecx;
 }
+
 static inline unsigned int cpuid_edx(unsigned int op)
 {
-	unsigned int eax, edx;
-
-	__asm__("cpuid"
-		: "=a" (eax), "=d" (edx)
-		: "0" (op)
-		: "bx", "cx");
+	unsigned int eax, ebx, ecx, edx;
+	cpuid(op, &eax, &ebx, &ecx, &edx);
 	return edx;
 }
 
-- 
1.4.4.2

