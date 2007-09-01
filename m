Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbXIATwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbXIATwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 15:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbXIATwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 15:52:09 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:59865 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbXIATwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 15:52:08 -0400
Date: Sat, 1 Sep 2007 12:51:42 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <ak@suse.de>
Cc: Daniel Walker <dwalker@mvista.com>,
       =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: nmi_watchdog=2 regression in 2.6.21
Message-ID: <20070901195142.GA9778@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070828194636.GB2814@frankl.hpl.hp.com> <20070901010053.GA29765@atjola.homenet> <1188610568.9476.7.camel@dhcp193.mvista.com> <200709011219.49256.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709011219.49256.ak@suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here is a patch to fix the NMI watchdog problem on CoreDuo processor.
I think we still need Daniel's patch to make the error path (when you
are stuck) do the right cleanup.


Changelog:
	- fix the NMI watchdog on Intel CoreDuo processor whereby the
	  kernel would get stuck during boot. The issue is related to
	  errata AE49, where the PERFEVTSEL1 counter does not have a
	  working enable bit. Thus it is not possible to use it for NMI.
	  The patch creates a dedicated wd_ops for CoreDuo which falls
	  back to using PERFEVTSEL0. The other Intel processors supporting
	  the architectural PMU will keep on using PERFEVTSEL1 as this
	  allows other subsystems, such as perfmon, to use PERFEVTSEL0 for
	  PEBS monitoring in particular.
	  Bug initially reported by Daniel Walker.

Signed-off-by: Stephane Eranian <eranian@hpl.hp.com>


diff --git a/arch/i386/kernel/cpu/perfctr-watchdog.c b/arch/i386/kernel/cpu/perfctr-watchdog.c
index 9b5d6af..f9066e1 100644
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ b/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -271,8 +271,8 @@ static int setup_k7_watchdog(unsigned nmi_hz)
 	unsigned int evntsel;
 	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 
-	perfctr_msr = MSR_K7_PERFCTR0;
-	evntsel_msr = MSR_K7_EVNTSEL0;
+	perfctr_msr = wd_ops->perfctr;
+	evntsel_msr = wd_ops->evntsel;
 
 	wrmsrl(perfctr_msr, 0UL);
 
@@ -351,8 +351,8 @@ static int setup_p6_watchdog(unsigned nmi_hz)
 	unsigned int evntsel;
 	struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 
-	perfctr_msr = MSR_P6_PERFCTR0;
-	evntsel_msr = MSR_P6_EVNTSEL0;
+	perfctr_msr = wd_ops->perfctr;
+	evntsel_msr = wd_ops->evntsel;
 
 	/* KVM doesn't implement this MSR */
 	if (wrmsr_safe(perfctr_msr, 0, 0) < 0)
@@ -577,8 +577,8 @@ static int setup_intel_arch_watchdog(unsigned nmi_hz)
 	    (ebx & ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT))
 		return 0;
 
-	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR1;
-	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL1;
+	perfctr_msr = wd_ops->perfctr;
+	evntsel_msr = wd_ops->evntsel;
 
 	wrmsrl(perfctr_msr, 0UL);
 
@@ -613,6 +613,16 @@ static struct wd_ops intel_arch_wd_ops = {
 	.evntsel = MSR_ARCH_PERFMON_EVENTSEL1,
 };
 
+static struct wd_ops coreduo_wd_ops = {
+	.reserve = single_msr_reserve,
+	.unreserve = single_msr_unreserve,
+	.setup = setup_intel_arch_watchdog,
+	.rearm = p6_rearm,
+	.stop = single_msr_stop_watchdog,
+	.perfctr = MSR_ARCH_PERFMON_PERFCTR0,
+	.evntsel = MSR_ARCH_PERFMON_EVENTSEL0,
+};
+
 static void probe_nmi_watchdog(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
@@ -623,6 +633,10 @@ static void probe_nmi_watchdog(void)
 		wd_ops = &k7_wd_ops;
 		break;
 	case X86_VENDOR_INTEL:
+		if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 14) {
+			wd_ops = &coreduo_wd_ops;
+			break;
+		}
 		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
 			wd_ops = &intel_arch_wd_ops;
 			break;
