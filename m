Return-Path: <linux-kernel-owner+w=401wt.eu-S965820AbXCPSOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965820AbXCPSOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965819AbXCPSOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:14:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:21519 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965818AbXCPSOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:14:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CQXBdRi1EEbsC6OWDtW9Mr6UGrR2PMWn2dBrOLWI37GxBi/YIIseMag/pMZYat5IvjcZ/orz5LGDBRkzQYAoX3U4JuHZSFPcRhTT+JH2tu3Tr2tptEgrCRgqc5B7F+5O8x2DI1MNpIOpmcTz30cz94Pe6UkSISFTsdG5+VdwkDQ=
Message-ID: <3d8471ca0703161114o7ad654car60c1a6b801401149@mail.gmail.com>
Date: Fri, 16 Mar 2007 19:14:30 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: [PATCH] Add an offset in the cyc2ns computation to fix sched_clock jumps
Cc: "john stultz" <johnstul@us.ibm.com>, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The scheduling problems I reported in the thread:
http://lkml.org/lkml/2007/3/3/128
are caused by the set_cyc2ns_scale() function called when the CPU speed changes.
Changing the scale causes a warp in the value returned by sched_clock().

The attached patch fixes the problem by adding an offset to the cyc2ns code to
smooth CPU frequency transitions. It also makes the cyc2ns parameters
per-CPU as cpufreq seems to support SMP but I don't have the hardware
to test. If you want
a version without the per-CPU or irqsave stuff, just ask.

Although it solved all my scheduler issues, it may not be fully satisfactory
as for example my TSC can run at a frequency as low as 350 MHz when the CPU is
idle and slowed down to the max at 798 MHz by ondemand. So in this case,
sched_clock() does not return nanoseconds as it thinks it does. Hopefully this
is a non-issue as the scheduler is not stressed when the CPU is idle.

For me, this is needed in 2.6.21 if I want to be able to listen to music while
compiling a kernel using the ondemand governor.

Thanks.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
---

diff -r fb83e6d92a4c arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c
+++ b/arch/i386/kernel/tsc.c
@@ -10,6 +10,7 @@
 #include <linux/jiffies.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
+#include <linux/percpu.h>

 #include <asm/delay.h>
 #include <asm/tsc.h>
@@ -79,20 +80,57 @@ static inline int check_tsc_unstable(voi
  *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
  *  (mathieu.desnoyers@polymtl.ca)
  *
+ *  ns += offset to avoid sched_clock jumps with cpufreq (guichaz@yahoo.fr)
+ *
  *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
  */
-static unsigned long cyc2ns_scale __read_mostly;
-
 #define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */

-static inline void set_cyc2ns_scale(unsigned long cpu_khz)
-{
-	cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR)/cpu_khz;
+struct cyc2ns_params {
+	unsigned long scale;
+	unsigned long long offset;
+};
+DEFINE_PER_CPU(struct cyc2ns_params, cyc2ns) __read_mostly;
+
+static inline unsigned long long __cycles_2_ns(struct cyc2ns_params *params,
+					       unsigned long long cyc)
+{
+	return ((cyc * params->scale) >> CYC2NS_SCALE_FACTOR) + params->offset;
 }

 static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 {
-	return (cyc * cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
+	struct cyc2ns_params *params;
+	unsigned long flags;
+	unsigned long long ns;
+
+	params = &get_cpu_var(cyc2ns);
+
+	local_irq_save(flags);
+	ns = __cycles_2_ns(params, cyc);
+	local_irq_restore(flags);
+
+	put_cpu_var(cyc2ns);
+	return ns;
+}
+
+static void set_cyc2ns_scale(unsigned long cpu_khz)
+{
+	struct cyc2ns_params *params;
+	unsigned long flags;
+	unsigned long long tsc_now, ns_now;
+
+	get_scheduled_cycles(tsc_now);
+	params = &get_cpu_var(cyc2ns);
+
+	local_irq_save(flags);
+	ns_now = __cycles_2_ns(params, tsc_now);
+
+	params->scale = (1000000 << CYC2NS_SCALE_FACTOR)/cpu_khz;
+	params->offset += ns_now - __cycles_2_ns(params, tsc_now);
+	local_irq_restore(flags);
+
+	put_cpu_var(cyc2ns);
 }

 /*


-- 
Guillaume
