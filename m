Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbXLDSyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbXLDSyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbXLDSxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:53:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483AbXLDSxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:53:32 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 6/10] introduce native_read_tscp
Date: Tue,  4 Dec 2007 14:03:56 -0200
Message-Id: <11967842711043-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <119678426719-git-send-email-gcosta@redhat.com>
References: 20071204140939.GA16328@elte.hu <11967842402729-git-send-email-gcosta@redhat.com> <11967842482873-git-send-email-gcosta@redhat.com> <11967842531735-git-send-email-gcosta@redhat.com> <11967842573035-git-send-email-gcosta@redhat.com> <11967842622658-git-send-email-gcosta@redhat.com> <119678426719-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Targetting paravirt, this patch introduces native_read_tscp, in
place of rdtscp() macro. When in a paravirt guest, this will
involve a function call, and thus, cannot be done in the vdso area.
These users then have to call the native version directly

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/vsyscall_64.c |    4 ++--
 arch/x86/vdso/vgetcpu.c       |    4 ++--
 include/asm-x86/msr.h         |   29 +++++++++++++++++++++--------
 3 files changed, 25 insertions(+), 12 deletions(-)

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
index 3b1ae1a..c8097f1 100644
--- a/arch/x86/vdso/vgetcpu.c
+++ b/arch/x86/vdso/vgetcpu.c
@@ -15,11 +15,11 @@
 
 long __vdso_getcpu(unsigned *cpu, unsigned *node, struct getcpu_cache *unused)
 {
-	unsigned int dummy, p;
+	unsigned int p;
 
 	if (*vdso_vgetcpu_mode == VGETCPU_RDTSCP) {
 		/* Load per CPU data from RDTSCP */
-		rdtscp(dummy, dummy, p);
+		native_read_tscp(&p);
 	} else {
 		/* Load per CPU data from GDT */
 		asm("lsl %1,%0" : "=r" (p) : "r" (__PER_CPU_SEG));
diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index 5fa30bd..0296358 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -3,6 +3,27 @@
 
 #include <asm/msr-index.h>
 
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+static inline unsigned long long native_read_tscp(int *aux)
+{
+	unsigned long low, high;
+	asm volatile (".byte 0x0f,0x01,0xf9"
+		      : "=a" (low), "=d" (high), "=c" (*aux));
+	return low | ((u64)high >> 32);
+}
+
+#define rdtscp(low, high, aux)						\
+       do {                                                            \
+		unsigned long long _val = native_read_tscp(&(aux));     \
+		(low) = (u32)_val;                                      \
+		(high) = (u32)(_val >> 32);                             \
+       } while (0)
+
+#define rdtscpll(val, aux) (val) = native_read_tscp(&(aux))
+#endif
+#endif
+
 #ifdef __i386__
 
 #ifdef __KERNEL__
@@ -206,8 +227,6 @@ static inline int wrmsr_safe(u32 __msr, u32 __low, u32 __high)
 #define rdtscl(low) \
      __asm__ __volatile__ ("rdtsc" : "=a" (low) : : "edx")
 
-#define rdtscp(low,high,aux) \
-     asm volatile (".byte 0x0f,0x01,0xf9" : "=a" (low), "=d" (high), "=c" (aux))
 
 #define rdtscll(val) do { \
      unsigned int __a,__d; \
@@ -215,12 +234,6 @@ static inline int wrmsr_safe(u32 __msr, u32 __low, u32 __high)
      (val) = ((unsigned long)__a) | (((unsigned long)__d)<<32); \
 } while(0)
 
-#define rdtscpll(val, aux) do { \
-     unsigned long __a, __d; \
-     asm volatile (".byte 0x0f,0x01,0xf9" : "=a" (__a), "=d" (__d), "=c" (aux)); \
-     (val) = (__d << 32) | __a; \
-} while (0)
-
 #define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
 
 #define write_rdtscp_aux(val) wrmsr(0xc0000103, val, 0)
-- 
1.4.4.2

