Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbXCDX2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbXCDX2k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 18:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbXCDX2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 18:28:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbXCDX2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 18:28:39 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Guillaume Chazarain" <guichaz@gmail.com>
Subject: Re: [1/3] Bugfix: Don't use the TSC in sched_clock if unstable
Date: Mon, 5 Mar 2007 00:28:24 +0100
User-Agent: KMail/1.9.5
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <3d8471ca0703031341l1768fe7rccf40712e452ea09@mail.gmail.com> <200703041825.39361.ak@suse.de> <3d8471ca0703041033v689b51dfuba0b09fc979d7698@mail.gmail.com>
In-Reply-To: <3d8471ca0703041033v689b51dfuba0b09fc979d7698@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703050028.25209.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 March 2007 19:33, Guillaume Chazarain wrote:
> 2007/3/4, Andi Kleen <ak@suse.de>:
> 
> > On what hardware?
> 
> Pentium M 798 MHz -> 2GHz

An older one (Banias) I assume? (please post /proc/cpuinfo) 

Assuming that:

> > And how many frequency transitions do you have per second?
> 
> 10 in a kernel compile exhibiting audio skips.
> 
> Anyway, the "Clocksource tsc unstable (delta = -263211549 ns)" line

That's because the new clocksource code doesn't correctly update
its state on cpufrequency scaling. That's another problem, but independent
of this. sched_clock doesn't rely on the clock source state for this,
but uses its own conversion functions.

> in the dmesg I attached to the previous mail confirms IMHO that my
> TSC is too unstable for scheduling purpose.

No it shouldn't be.  Must be a bug somewhere.

Your CPU doesn't have p state invariant TSC, but we should be able 
to generate nano seconds from TSC using the known frequency at any point 
of time using the frequency updated in arch/i386/kernel/tsc.c:time_cpufreq_notifier(). 

Can you run with this debug patch and send me the output? If it stops
logging before you see the problem increase MAX in the patch.

-Andi

Index: linux/arch/i386/kernel/tsc.c
===================================================================
--- linux.orig/arch/i386/kernel/tsc.c
+++ linux/arch/i386/kernel/tsc.c
@@ -85,9 +85,20 @@ static unsigned long cyc2ns_scale __read
 
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
 
+enum {
+	MAX = 500,
+}; 
+
+static int cnt;
+
 static inline void set_cyc2ns_scale(unsigned long cpu_khz)
 {
-	cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR)/cpu_khz;
+	long new = (1000000 << CYC2NS_SCALE_FACTOR)/cpu_khz;
+	if (cnt < MAX) {
+		printk("cyc2ns_scale %lx -> %lx\n", cyc2ns_scale, new); 
+		cnt++;
+	}
+	cyc2ns_scale = new;
 }
 
 static inline unsigned long long cycles_2_ns(unsigned long long cyc)
@@ -101,6 +112,8 @@ static inline unsigned long long cycles_
 unsigned long long sched_clock(void)
 {
 	unsigned long long this_offset;
+	static u64 last_offset;
+	static long last_conv;
 
 	if (unlikely(custom_sched_clock))
 		return (*custom_sched_clock)();
@@ -116,7 +129,17 @@ unsigned long long sched_clock(void)
 	rdtscll(this_offset);
 
 	/* return the value in ns */
-	return cycles_2_ns(this_offset);
+	this_offset = cycles_2_ns(this_offset);
+
+	if (cnt < MAX && this_offset <= last_offset) {
+		printk("sched_clock backward %llx(%lx)->%llx(%lx)\n",
+			last_offset, last_conv, this_offset, cyc2ns_scale);
+		cnt++;
+	} 
+	last_offset = this_offset;
+	last_conv = cyc2ns_scale;
+
+	return this_offset;
 }
 
 static unsigned long calculate_cpu_khz(void)

