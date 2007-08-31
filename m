Return-Path: <linux-kernel-owner+w=401wt.eu-S965573AbXHaQWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965573AbXHaQWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 12:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932864AbXHaQWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 12:22:12 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:64248 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536AbXHaQWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 12:22:10 -0400
Date: Fri, 31 Aug 2007 09:21:46 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: B.Steinbrink@gmx.de, ak@suse.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: nmi_watchdog=2 regression in 2.6.21
Message-ID: <20070831162146.GD7161@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070828091217.GA1645@frankl.hpl.hp.com> <1188311684.2435.288.camel@dhcp193.mvista.com> <20070828170556.GI1645@frankl.hpl.hp.com> <1188325835.2435.317.camel@dhcp193.mvista.com> <20070828194636.GB2814@frankl.hpl.hp.com> <1188332024.2435.328.camel@dhcp193.mvista.com> <20070829212451.GC4810@frankl.hpl.hp.com> <1188436919.26038.27.camel@dhcp193.mvista.com> <20070830210555.GA6635@frankl.hpl.hp.com> <1188571401.26038.41.camel@dhcp193.mvista.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <1188571401.26038.41.camel@dhcp193.mvista.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Daniel,

On Fri, Aug 31, 2007 at 07:43:20AM -0700, Daniel Walker wrote:
> On Thu, 2007-08-30 at 14:05 -0700, Stephane Eranian wrote:
> > Daniel,
> 
> > Yes, I realized I missed a small detail in the switch statement.
> > Could you try the new version?
> 
> This patch still has the stuck NMI .. Essentially the same thing that
> happened without the patch..
> 
Ok, looks like deaulting to P6 does not quite work.

Here is a new version. This time I used a different approach.
I am must admit I am a bit puzzled by the duplication of information
between the wd_ops and the nmi_watchdog_ctlblk structure. My understanding
is that thelater is used as a cache for the info that needs to be per-cpu.

The wd_ops provides the MSR to use for the counter, yet all the setup_*()
routines hardcode the MSR. Not sure why?

In this patch, the setup_*() routine now extract the MSR from the wd_ops
to copy them into the nmi_watchdog_ctlblk. This is not done for P4 because
of the special and ugly case of HT. 

With this approach, we can now create a custom wd_ops for CoreDuo that is
a clone of the intel_arch_wd_ops, except for the MSR.

Could you try this one instead?

Thanks.

-- 

-Stephane

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="coreduo3.diff"

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

--7AUc2qLy4jB3hD7Z--
