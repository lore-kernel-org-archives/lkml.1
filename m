Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbZLOEHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbZLOEHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758543AbZLOEHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:07:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753499AbZLOEG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:06:59 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       Dor Laor <dlaor@redhat.com>
Subject: [PATCH RFC: kvm tsc virtualization 03/20] TSC offset framework
Date: Mon, 14 Dec 2009 18:08:30 -1000
Message-Id: <1260850127-9766-4-git-send-email-zamsden@redhat.com>
In-Reply-To: <1260850127-9766-3-git-send-email-zamsden@redhat.com>
References: <1260850127-9766-1-git-send-email-zamsden@redhat.com>
 <1260850127-9766-2-git-send-email-zamsden@redhat.com>
 <1260850127-9766-3-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the framework for a preliminary way to cope with CPUs which have
different TSC offsets from each other.  The TSC delta is measured
(in cross-cache-directions for highest accuracy) and stored.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/x86.c |  202 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 202 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index faa467d..95e43b9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -730,6 +730,196 @@ static void kvm_set_time_scale(uint32_t tsc_khz, struct pvclock_vcpu_time_info *
 }
 
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
+static DEFINE_PER_CPU(unsigned long, cpu_tsc_multiplier);
+static DEFINE_PER_CPU(int, cpu_tsc_shift);
+static DEFINE_PER_CPU(s64, cpu_tsc_offset);
+static DEFINE_PER_CPU(u64, cpu_tsc_measure_base);
+static int tsc_base_cpu = -1;
+static unsigned long ref_tsc_khz;
+
+static inline unsigned long div_precise(unsigned long hi, unsigned long lo,
+	unsigned long divisor, unsigned long *rptr)
+{
+	unsigned long quotient, remainder;
+	__asm__ ( "div %4"
+		: "=a" (quotient), "=d" (remainder)
+		: "0" (lo), "1" (hi), "rm" (divisor));
+	*rptr = remainder;
+	return quotient;
+}
+
+/*
+ * compute the best multipler and shift pair m,s, such that for n,
+ *   n * a / b  = (n * m) >> s
+ */
+static void compute_best_multiplier(unsigned long a, unsigned long b,
+	unsigned long *m, int *s)
+{
+	int shift, bit;
+	unsigned long lo, hi, remainder, mult;
+
+	/*
+	 * By pre-shifting and using maximum machine width, we get the most
+	 * bits of precision.
+	 */
+	shift = BITS_PER_LONG + fls(b) - fls(a) - 1;
+	if (shift > BITS_PER_LONG)
+		shift = BITS_PER_LONG;
+	if (shift < 0)
+		shift = 0;
+	lo = a << shift;
+	hi = a >> (BITS_PER_LONG - shift);
+	mult = div_precise(hi, lo, b, &remainder);
+
+	/* See if it can be further simplified */
+	bit = __ffs(mult);
+	if (bit > shift)
+		bit = shift;
+	mult >>= bit;
+	shift -= bit;
+	*m = mult;
+	*s = shift;
+}
+
+static inline unsigned long mult_precise(unsigned long val, unsigned long mult,
+	int shift)
+{
+	unsigned long top, bot;
+
+	__asm__ ( "mul %3; shrd %1, %0" :
+		 "=&a" (bot), "=&d" (top) :
+		 "0" (mult), "rm" (val), "c" (shift));
+	return bot;
+}
+
+static inline u64 compute_ref_tsc(int cpu)
+{
+	u64 tsc = native_read_tsc() - per_cpu(cpu_tsc_measure_base, cpu);
+	tsc = mult_precise(tsc, per_cpu(cpu_tsc_multiplier, cpu),
+				per_cpu(cpu_tsc_shift, cpu));
+	return tsc + per_cpu(cpu_tsc_offset, cpu);
+}
+
+#define SYNC_TRIES 64
+
+/*
+ * sync_tsc_helper is a dual-entry coroutine meant to be run by only
+ * two CPUs at a time, one of which is a measuring CPU.  Both CPUs
+ * synchronize entry and exit as well as the central recording loop
+ * using only memory barriers and atomic variables to avoid lock latency.
+ *
+ * To discount cache latency effects, this routine will be called
+ * twice, one with the measure / recording CPUs reversed.  In addition,
+ * the first 4 and last 2 results will be discarded to allow branch
+ * predicition to become established (and to discount effects from
+ * a potentially early predicted loop exit).
+ *
+ * Because of this, we must be extra careful to guard the entrance
+ * and exit against the CPU switch.  I chose to use atomic instructions
+ * only at the end of the measure loop and use the same routine for
+ * both CPUs, with symmetric comparisons, and a statically placed
+ * recording array, hopefully maximizing the branch predicition and
+ * cache locality.  The results appear quite good; on known to be
+ * synchronized CPUs, I typically get < 10 TSC delta measured, with
+ * maximum observed error on the order of 100 cycles.
+ *
+ * This doesn't account for NUMA cache effects, and could potentially
+ * be improved there by moving the delta[] array to the stack of the
+ * measuring CPU.  In fact, this modification might be worth trying
+ * for non-NUMA systems as well, but this appears to be fine for now.
+ */
+static void sync_tsc_helper(int measure_cpu, u64 *delta, atomic_t *ready)
+{
+	int tries;
+	static u64 tsc_other;
+	int junk = 0;
+	u64 tsc;
+	int cpu = raw_smp_processor_id();
+
+	if (cpu == measure_cpu) {
+		atomic_set(ready, 0);
+		while (!atomic_read(ready))
+			/* wait */;
+	} else {
+		while (atomic_read(ready))
+			/* wait */;
+		atomic_set(ready, 1);
+	}
+	for (tries = 0; tries < SYNC_TRIES; tries++) {
+		mb();
+		if (cpu == measure_cpu) {
+			atomic_set(ready, 0);
+		} else {
+			while (atomic_read(ready))
+				/* wait */;
+		}
+		native_cpuid(&junk, &junk, &junk, &junk);
+		tsc = compute_ref_tsc(cpu);
+		rdtsc_barrier();
+		if (cpu == measure_cpu) {
+			while (!atomic_read(ready))
+				/* wait */;
+			rmb();
+			delta[tries] = tsc - tsc_other;
+		} else {
+			tsc_other = tsc;
+			wmb();
+			atomic_set(ready, 1);
+		}
+	}
+	if (cpu == measure_cpu)
+		atomic_dec(ready);
+	else
+		atomic_inc(ready);
+	while (atomic_read(ready) != 1)
+		/* wait */;
+	mb();
+}
+
+static void kvm_sync_tsc(void *cpup)
+{
+	int new_cpu = *(int *)cpup;
+	unsigned long flags;
+	static s64 delta[SYNC_TRIES*2];
+	static atomic_t ready = ATOMIC_INIT(1);
+
+	BUG_ON(tsc_base_cpu == -1);
+	pr_debug("%s: IN, cpu = %d, freq = %ldkHz, tsc_base_cpu = %d\n", __func__, raw_smp_processor_id(), per_cpu(cpu_tsc_khz, raw_smp_processor_id()) , tsc_base_cpu);
+	local_irq_save(flags);
+	if (raw_smp_processor_id() == new_cpu) {
+		per_cpu(cpu_tsc_measure_base, new_cpu) = native_read_tsc();
+		per_cpu(cpu_tsc_offset, new_cpu) = 0;
+		compute_best_multiplier(ref_tsc_khz,
+			per_cpu(cpu_tsc_khz, new_cpu),
+			&per_cpu(cpu_tsc_multiplier, new_cpu),
+			&per_cpu(cpu_tsc_shift, new_cpu));
+	}
+	sync_tsc_helper(tsc_base_cpu, delta, &ready);
+	sync_tsc_helper(new_cpu, &delta[SYNC_TRIES], &ready);
+	if (raw_smp_processor_id() == new_cpu) {
+		int i;
+		s64 accumulator = 0;
+
+		/*
+		 * accumulate [SYNC_TRIES+4,-2) of tsc{base} - tsc{new}
+		 * subtract   [SYNC_TRIES+4,-2) of tsc{new} - tsc{base}
+		 *
+		 * this allows instruction cycle and cache differences to
+		 * cancel each other out and drops warm up/cool down variation
+		 *
+		 * Note the arithmatic must be signed because of the divide
+		 */
+
+		for (i = 4; i < SYNC_TRIES - 2; i++)
+			accumulator += delta[i];
+		for (i = 4; i < SYNC_TRIES - 2; i++)
+			accumulator -= delta[i+SYNC_TRIES];
+		accumulator = accumulator / (SYNC_TRIES*2-12);
+		per_cpu(cpu_tsc_offset, new_cpu) = accumulator;
+		pr_debug("%s: OUT, cpu = %d, cpu_tsc_offset = %lld, cpu_tsc_multiplier=%ld, cpu_tsc_shift=%d\n", __func__, raw_smp_processor_id(), per_cpu(cpu_tsc_offset, new_cpu), per_cpu(cpu_tsc_multiplier, new_cpu), per_cpu(cpu_tsc_shift, new_cpu));
+	}
+	local_irq_restore(flags);
+}
 
 static void kvm_write_guest_time(struct kvm_vcpu *v)
 {
@@ -3352,6 +3542,18 @@ static void kvm_timer_init(void)
 		for_each_possible_cpu(cpu)
 			per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
 	}
+	tsc_base_cpu = get_cpu();
+	ref_tsc_khz = per_cpu(cpu_tsc_khz, tsc_base_cpu);
+	per_cpu(cpu_tsc_multiplier, tsc_base_cpu) = 1;
+	per_cpu(cpu_tsc_shift, tsc_base_cpu) = 0;
+	per_cpu(cpu_tsc_offset, tsc_base_cpu) = 0;
+	for_each_online_cpu(cpu)
+		if (cpu != tsc_base_cpu) {
+			smp_call_function_single(cpu, kvm_sync_tsc,
+						 (void *)&cpu, 0);
+			kvm_sync_tsc((void *)&cpu);
+		}
+	put_cpu();
 }
 
 int kvm_arch_init(void *opaque)
-- 
1.6.5.2

