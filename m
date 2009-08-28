Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbZH1Kkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbZH1Kkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 06:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZH1Kkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 06:40:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56971 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbZH1Kka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 06:40:30 -0400
Date: Fri, 28 Aug 2009 12:40:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090828104014.GA6437@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, xen: Initialize cx to suppress warning

Jeremy Fitzhardinge (1):
      x86, xen: Suppress WP test on Xen

Yinghai Lu (1):
      x86: Fix vSMP boot crash


 arch/x86/kernel/apic/probe_64.c |   10 ++++++++++
 arch/x86/xen/enlighten.c        |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index bc3e880..fcec2f1 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -44,6 +44,11 @@ static struct apic *apic_probe[] __initdata = {
 	NULL,
 };
 
+static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
+{
+	return hard_smp_processor_id() >> index_msb;
+}
+
 /*
  * Check the APIC IDs in bios_cpu_apicid and choose the APIC mode.
  */
@@ -69,6 +74,11 @@ void __init default_setup_apic_routing(void)
 		printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 	}
 
+	if (is_vsmp_box()) {
+		/* need to update phys_pkg_id */
+		apic->phys_pkg_id = apicid_phys_pkg_id;
+	}
+
 	/*
 	 * Now that apic routing model is selected, configure the
 	 * fault handling for intr remapping.
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index e90540a..eb33aaa 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -215,6 +215,7 @@ static __init void xen_init_cpuid_mask(void)
 			  (1 << X86_FEATURE_ACPI));  /* disable ACPI */
 
 	ax = 1;
+	cx = 0;
 	xen_cpuid(&ax, &bx, &cx, &dx);
 
 	/* cpuid claims we support xsave; try enabling it to see what happens */
@@ -1059,6 +1060,7 @@ asmlinkage void __init xen_start_kernel(void)
 	/* set up basic CPUID stuff */
 	cpu_detect(&new_cpu_data);
 	new_cpu_data.hard_math = 1;
+	new_cpu_data.wp_works_ok = 1;
 	new_cpu_data.x86_capability[0] = cpuid_edx(1);
 #endif
 
