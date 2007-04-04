Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbXDEASO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbXDEASO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932078AbXDEAR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:17:57 -0400
Received: from 230.sub-75-208-113.myvzw.com ([75.208.113.230]:36878 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932129AbXDEAQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:16:47 -0400
Message-Id: <20070404191206.476822257@goop.org>
References: <20070404191151.009821039@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Apr 2007 12:12:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [patch 18/20] clean up tsc-based sched_clock
Content-Disposition: inline; filename=cleanup-tsc-sched-clock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Three cleanups:
 - change "instable" -> "unstable"
 - its better to use get_cpu_var for getting this cpu's variables
 - change cycles_2_ns to do the full computation rather than just the
   tsc->ns scaling.  Its a simpler interface, and it makes the function
   more generally useful.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/kernel/sched-clock.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

===================================================================
--- a/arch/i386/kernel/sched-clock.c
+++ b/arch/i386/kernel/sched-clock.c
@@ -39,17 +39,23 @@
 
 struct sc_data {
 	unsigned int cyc2ns_scale;
-	unsigned char instable;
+	unsigned char unstable;
 	unsigned long long last_tsc;
 	unsigned long long ns_base;
 };
 
 static DEFINE_PER_CPU(struct sc_data, sc_data);
 
-static inline unsigned long long cycles_2_ns(int cpu, unsigned long long cyc)
+static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 {
-	struct sc_data *sc = &per_cpu(sc_data, cpu);
-	return (cyc * sc->cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
+	const struct sc_data *sc = &__get_cpu_var(sc_data);
+	unsigned long long ns;
+
+	cyc -= sc->last_tsc;
+	ns = (cyc * sc->cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
+	ns += sc->ns_base;
+
+	return ns;
 }
 
 /*
@@ -62,18 +68,19 @@ static inline unsigned long long cycles_
  */
 unsigned long long sched_clock(void)
 {
-	int cpu = get_cpu();
-	struct sc_data *sc = &per_cpu(sc_data, cpu);
 	unsigned long long r;
+	const struct sc_data *sc = &get_cpu_var(sc_data);
 
-	if (sc->instable) {
+	if (sc->unstable) {
 		/* TBD find a cheaper fallback timer than this */
 		r = ktime_to_ns(ktime_get());
 	} else {
 		get_scheduled_cycles(r);
-		r = ((u64)sc->ns_base) + cycles_2_ns(cpu, r - sc->last_tsc);
+		r = cycles_2_ns(r);
 	}
-	put_cpu();
+
+	put_cpu_var(sc_data);
+
 	return r;
 }
 
@@ -81,7 +88,7 @@ static void resync_sc_freq(struct sc_dat
 static void resync_sc_freq(struct sc_data *sc, unsigned int newfreq)
 {
 	if (!cpu_has_tsc) {
-		sc->instable = 1;
+		sc->unstable = 1;
 		return;
 	}
 	/* RED-PEN protect with seqlock? I hope that's not needed
@@ -90,7 +97,7 @@ static void resync_sc_freq(struct sc_dat
 	sc->ns_base = ktime_to_ns(ktime_get());
 	get_scheduled_cycles(sc->last_tsc);
 	sc->cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR) / newfreq;
-	sc->instable = 0;
+	sc->unstable = 0;
 }
 
 static void call_r_s_f(void *arg)
@@ -119,9 +126,9 @@ static int sc_freq_event(struct notifier
 	switch (event) {
 	case CPUFREQ_RESUMECHANGE:  /* needed? */
 	case CPUFREQ_PRECHANGE:
-		/* Mark TSC as instable until cpu frequency change is done
+		/* Mark TSC as unstable until cpu frequency change is done
 		   because we don't know when exactly it will change */
-		sc->instable = 1;
+		sc->unstable = 1;
 		break;
 	case CPUFREQ_SUSPENDCHANGE:
 	case CPUFREQ_POSTCHANGE:
@@ -163,7 +170,7 @@ static __init int init_sched_clock(void)
 	int i;
 	struct cpufreq_freqs f = { .cpu = get_cpu(), .new = 0 };
 	for_each_possible_cpu (i)
-		per_cpu(sc_data, i).instable = 1;
+		per_cpu(sc_data, i).unstable = 1;
 	WARN_ON(num_online_cpus() > 1);
 	call_r_s_f(&f);
 	put_cpu();

-- 

