Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbXH2VZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbXH2VZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 17:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756910AbXH2VZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 17:25:43 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:49353 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731AbXH2VZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 17:25:42 -0400
Date: Wed, 29 Aug 2007 14:24:51 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: B.Steinbrink@gmx.de, ak@suse.de, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: nmi_watchdog=2 regression in 2.6.21
Message-ID: <20070829212451.GC4810@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070827175431.GD784@frankl.hpl.hp.com> <1188237331.2435.255.camel@dhcp193.mvista.com> <20070827225555.GI784@frankl.hpl.hp.com> <1188256074.2435.272.camel@dhcp193.mvista.com> <20070828091217.GA1645@frankl.hpl.hp.com> <1188311684.2435.288.camel@dhcp193.mvista.com> <20070828170556.GI1645@frankl.hpl.hp.com> <1188325835.2435.317.camel@dhcp193.mvista.com> <20070828194636.GB2814@frankl.hpl.hp.com> <1188332024.2435.328.camel@dhcp193.mvista.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="rJwd6BRFiFCcLxzm"
Content-Disposition: inline
In-Reply-To: <1188332024.2435.328.camel@dhcp193.mvista.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Daniel,

On Tue, Aug 28, 2007 at 01:13:44PM -0700, Daniel Walker wrote:
> On Tue, 2007-08-28 at 12:46 -0700, Stephane Eranian wrote:
> 
> > I think I found the problem. As I suspected, it seems there is an assymetry
> > between the 1st end 2nd counter (just like what they have on P6 core). Yet
> > for architectural perfmon v1, this restriction is supposed to be lifted.
> > 
> > Unfortunately, a quick look at the errata document at
> > http://download.intel.com/design/mobile/SPECUPDT/30922212.pdf
> > 
> > for Core Duo shows bugs A49 as 'nofix':
> >   Core Duo processor has a bug which renders the enable bit (22) of
> >   PERFEVTSEL1 inoperative. The processor behaves like former P6 cores,
> >   the enable bit of PERFEVTSEL0 controls the activation of both counters
> 
> Your patch switched the nmi from PERFEVTSEL0 to PERFEVTSEL1  (right?)..
> So 0 works, 1 does not , for me anyway ..
> 
Yes that is what the patch was doing and it was for a specific reason. On
a Core 2 Duo (which uses the 2nd generation of the architectural PMU), some
useful features (such as PEBS) requiree the use of counter 0 so we cannot
give it away to NMI.

Now on Core Duo, there is no PEBS anyway, so it is okay to use counter 0
for NMI. The problem is that the detection code in perfctr-watchdog.c
treats a Core Duo and a Core 2 Duo the same way as they both have the
X86_FEATURE_ARCH_PERFMON bit set.

I have attached a patch with handle the case of the Core Duo. Unfortunately,
I do not own one so I cannot test it. I would appreciate if you could
try re-applying my counter 0 -> 1 patch + this new one to see if you
have the problem with the NMI getting stuck.

The patch below is probably still needed to handle the case where you get
stuck.

Thanks.

> > That explains why you get the 'NMI stuck' message when using PERFEVTSEL1.
> > I suspect when using PERFEVTSEL0, then NMI watchdog is not stuck. So it
> > is possible that in case NMI is stuck the code does not cleanly shutdown the
> > NMI interrupt and you get some spurious NMI interrupt later in the boot at
> > you are stuck because you are holding a lock. We need to look at the error
> > path of check_nmi_watchdog(). I glance through it and could not find the place
> > where the APIC vector is cleared.
> 
> As far as I can tell the check_nmi_watchdog() doesn't take locks, and it
> can't safely share a lock with the NMI .. 
> 
> The patch below fixes the hang (not the stuck NMI) .. Not totally sure
> why, but the cpus are stuck in a loop waiting for the endflag which
> never comes .. This also plays with the nmi hz which might do
> something.. /proc/interrupt doesn't show any nmi's either..
> 
> Daniel
> 
> Signed-off-by: Daniel Walker <dwalker@mvista.com>
> 
> Index: linux-2.6.22/arch/i386/kernel/nmi.c
> ===================================================================
> --- linux-2.6.22.orig/arch/i386/kernel/nmi.c	2007-08-15 00:51:12.000000000 +0000
> +++ linux-2.6.22/arch/i386/kernel/nmi.c	2007-08-28 20:15:04.000000000 +0000
> @@ -82,7 +82,7 @@ static __init void nmi_cpu_busy(void *da
>  static int __init check_nmi_watchdog(void)
>  {
>  	unsigned int *prev_nmi_count;
> -	int cpu;
> +	int cpu, ret = 0;
>  
>  	if ((nmi_watchdog == NMI_NONE) || (nmi_watchdog == NMI_DEFAULT))
>  		return 0;
> @@ -125,18 +125,18 @@ static int __init check_nmi_watchdog(voi
>  	if (!atomic_read(&nmi_active)) {
>  		kfree(prev_nmi_count);
>  		atomic_set(&nmi_active, -1);
> -		return -1;
> -	}
> +		printk("nmi malfunctioning.\n");
> +		ret = -1;
> +	} else 
> +		printk("OK.\n");
>  	endflag = 1;
> -	printk("OK.\n");
> -
>  	/* now that we know it works we can reduce NMI frequency to
>  	   something more reasonable; makes a difference in some configs */
>  	if (nmi_watchdog == NMI_LOCAL_APIC)
>  		nmi_hz = lapic_adjust_nmi_hz(1);
>  
>  	kfree(prev_nmi_count);
> -	return 0;
> +	return ret;
>  }
>  /* This needs to happen later in boot so counters are working */
>  late_initcall(check_nmi_watchdog);
> 

-- 

-Stephane

--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="coreduo.diff"

diff --git a/arch/i386/kernel/cpu/perfctr-watchdog.c b/arch/i386/kernel/cpu/perfctr-watchdog.c
index 9b5d6af..8af7998 100644
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c
+++ b/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -613,6 +613,17 @@ static struct wd_ops intel_arch_wd_ops = {
 	.evntsel = MSR_ARCH_PERFMON_EVENTSEL1,
 };
 
+/*
+ * Check for Intel Core Duo because it has a bug with PERFEVTSEL1
+ * (see Spefication Update bug AE49) and must use PERFEVTSEL0. We cannot
+ * use this counter on other processors supporting X86_FEATURE_ARCH_PERFMON
+ * because PEBS requires it.
+ */
+static inline int is_coreduo(void)
+{
+	return boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 14;
+}
+
 static void probe_nmi_watchdog(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
@@ -623,7 +634,8 @@ static void probe_nmi_watchdog(void)
 		wd_ops = &k7_wd_ops;
 		break;
 	case X86_VENDOR_INTEL:
-		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)) {
+		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON)
+		    && !is_coreduo()) {
 			wd_ops = &intel_arch_wd_ops;
 			break;
 		}

--rJwd6BRFiFCcLxzm--
