Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab0BQLne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 06:43:34 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:54844 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756386Ab0BQLnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 06:43:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=GoT/ZST3gwL1HKB0xdTbra6f6DxZY6QkSlvWoA3C8eXyxdDjxUVoy5M2y5zSGjaXML
         ODirP2vtPfrQQcj6Rygw3kXAYllGIcdcSJn6JfA+LCQHtNGPALyywI9iQCcr4hx1KDHY
         40zTGUS3BLdsZU38oVtUNBxe7oE+8olYuUyxc=
From: Luca Barbieri <luca@luca-barbieri.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
Date: Wed, 17 Feb 2010 12:42:41 +0100
Message-Id: <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses SSE movlps to perform 64-bit atomic reads and writes.

According to Intel manuals, all aligned 64-bit reads and writes are
atomically, which should include movlps.

To do this, we need to disable preempt, clts if TS was set, and
restore TS.

If we don't need to change TS, using SSE is much faster.

Otherwise, it should be essentially even, with the fastest method
depending on the specific architecture.

Another important point is that with SSE atomic64_read can keep the
cacheline in shared state.

If we could keep TS off and reenable it when returning to userspace,
this would be even faster, but this is left for a later patch.

We use SSE because we can just save the low part %xmm0, whereas using
the FPU or MMX requires at least saving the environment, and seems
impossible to do fast.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 arch/x86/include/asm/atomic_32.h |   10 ++++-
 arch/x86/lib/atomic64_32.c       |   67 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index 1ab431c..d03e471 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -268,6 +268,9 @@ typedef struct {
 
 #define ATOMIC64_INIT(val)	{ (val) }
 
+long long sse_atomic64_read_cx8call(long long, const atomic64_t *v);
+void sse_atomic64_set_cx8call(long long, unsigned high);
+
 long long cx8_atomic64_read_cx8call(long long, const atomic64_t *v);
 long long cx8_atomic64_set_cx8call(long long, const atomic64_t *v);
 long long cx8_atomic64_xchg_cx8call(long long, unsigned high);
@@ -281,8 +284,10 @@ int cx8_atomic64_add_unless(atomic64_t *v, long long a, long long u);
 
 #ifdef CONFIG_X86_CMPXCHG64
 #define ATOMIC64_ALTERNATIVE(f) "call cx8_atomic64_" #f
+#define ATOMIC64_ALTERNATIVE_XMM(f) ALTERNATIVE("call cx8_atomic64_" #f, "call sse_atomic64_" #g, X86_FEATURE_XMM)
 #else
 #define ATOMIC64_ALTERNATIVE(f) ALTERNATIVE("call generic_atomic64_" #f, "call cx8_atomic64_" #f, X86_FEATURE_CX8)
+#define ATOMIC64_ALTERNATIVE_XMM(f) ALTERNATIVE3("call generic_atomic64_" #f, "call cx8_atomic64_" #f, X86_FEATURE_CX8, "call sse_atomic64_" #f, X86_FEATURE_XMM)
 #endif
 
 /**
@@ -349,7 +354,7 @@ static inline void atomic64_set(atomic64_t *v, long long i)
 {
 	unsigned high = (unsigned)(i >> 32);
 	unsigned low = (unsigned)i;
-	asm volatile(ATOMIC64_ALTERNATIVE(set_cx8call)
+	asm volatile(ATOMIC64_ALTERNATIVE_XMM(set_cx8call)
 			: "+b" (low), "+c" (high)
 			: "S" (v)
 			: "eax", "edx", "memory"
@@ -365,7 +370,7 @@ static inline void atomic64_set(atomic64_t *v, long long i)
 static inline long long atomic64_read(atomic64_t *v)
 {
 	long long r;
-	asm volatile(ATOMIC64_ALTERNATIVE(read_cx8call)
+	asm volatile(ATOMIC64_ALTERNATIVE_XMM(read_cx8call)
 				: "=A" (r), "+c" (v)
 				: : "memory"
 				);
@@ -470,6 +475,7 @@ static inline int atomic64_inc_not_zero(atomic64_t *v)
 #define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
 
 #undef ATOMIC64_ALTERNATIVE
+#undef ATOMIC64_ALTERNATIVE_XMM
 
 #include <asm-generic/atomic-long.h>
 #endif /* _ASM_X86_ATOMIC_32_H */
diff --git a/arch/x86/lib/atomic64_32.c b/arch/x86/lib/atomic64_32.c
index b7edbb3..9ff8589 100644
--- a/arch/x86/lib/atomic64_32.c
+++ b/arch/x86/lib/atomic64_32.c
@@ -61,6 +61,47 @@ EXPORT_SYMBOL(generic_atomic64_read_cx8call);
 
 #endif /* CONFIG_X86_CMPXCHG64 */
 
+struct sse_atomic64_percpu {
+	long long xmm0_low;
+	long low;
+	long high;
+};
+
+/* we actually only need 8-byte alignment, but using cacheline alignment is the only simple way to this */
+/* we use a per-CPU variable because we need to disable preemption anyway and this is faster than
+ * aligning the stack pointer to 8 bytes
+ */
+DEFINE_PER_CPU_ALIGNED(struct sse_atomic64_percpu, sse_atomic64_percpu);
+
+/* using the fpu/mmx looks infeasible due to the need to save the FPU environment, which is very slow
+ * SSE2 is slightly slower on Core 2 and less compatible, so avoid it for now
+ */
+long long sse_atomic64_read_cx8call(long long dummy, const atomic64_t *v)
+{
+	long long res;
+	unsigned long cr0 = 0;
+	struct thread_info *me = current_thread_info();
+	preempt_disable();
+	if (!(me->status & TS_USEDFPU)) {
+		cr0 = read_cr0();
+		if (cr0 & X86_CR0_TS)
+			clts();
+	}
+	asm volatile(
+			"movlps %%xmm0, " __percpu_arg(0) "\n\t"
+			"movlps %3, %%xmm0\n\t"
+			"movlps %%xmm0, " __percpu_arg(1) "\n\t"
+			"movlps " __percpu_arg(0) ", %%xmm0\n\t"
+			    : "+m" (per_cpu__sse_atomic64_percpu.xmm0_low), "=m" (per_cpu__sse_atomic64_percpu.low), "=m" (per_cpu__sse_atomic64_percpu.high)
+			    : "m" (v->counter));
+	if (cr0 & X86_CR0_TS)
+		write_cr0(cr0);
+	res = (long long)(unsigned)percpu_read(sse_atomic64_percpu.low) | ((long long)(unsigned)percpu_read(sse_atomic64_percpu.high) << 32);
+	preempt_enable();
+	return res;
+}
+EXPORT_SYMBOL(sse_atomic64_read_cx8call);
+
 register unsigned low asm("ebx");
 register atomic64_t *v asm("esi");
 
@@ -121,3 +162,29 @@ int generic_atomic64_inc_not_zero_cx8call(void)
 EXPORT_SYMBOL(generic_atomic64_inc_not_zero_cx8call);
 
 #endif /* CONFIG_X86_CMPXCHG64 */
+
+/* put this here because we need access to the global register variables */
+void sse_atomic64_set_cx8call(long long dummy, unsigned high)
+{
+	struct thread_info *me = current_thread_info();
+	unsigned long cr0 = 0;
+	preempt_disable();
+	percpu_write(sse_atomic64_percpu.low, low);
+	percpu_write(sse_atomic64_percpu.high, high);
+	if (!(me->status & TS_USEDFPU)) {
+		cr0 = read_cr0();
+		if (cr0 & X86_CR0_TS)
+			clts();
+	}
+	asm volatile(
+			"movlps %%xmm0, " __percpu_arg(0) "\n\t"
+			"movlps " __percpu_arg(2) ", %%xmm0\n\t"
+			"movlps %%xmm0, %1\n\t"
+			"movlps " __percpu_arg(0) ", %%xmm0\n\t"
+			    : "+m" (per_cpu__sse_atomic64_percpu.xmm0_low), "=m" (v->counter)
+			    : "m" (per_cpu__sse_atomic64_percpu.low), "m" (per_cpu__sse_atomic64_percpu.high));
+	if (cr0 & X86_CR0_TS)
+		write_cr0(cr0);
+	preempt_enable();
+}
+EXPORT_SYMBOL(sse_atomic64_set_cx8call);
-- 
1.6.6.1.476.g01ddb

