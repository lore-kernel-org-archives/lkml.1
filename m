Return-Path: <linux-kernel-owner+w=401wt.eu-S1765964AbYETOcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765964AbYETOcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763678AbYETOcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:32:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760905AbYETOcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:32:09 -0400
Date: Tue, 20 May 2008 09:23:06 -0400
From: Dave Jones <davej@redhat.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com
Subject: Re: [X86] Add a boot parameter to force-enable PAT
Message-ID: <20080520132306.GB4843@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Yinghai Lu <yhlu.kernel@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	hpa@zytor.com
References: <200805200409.m4K49Ybn024338@gelk.kernelslacker.org> <86802c440805192253s34b3acb2r63c657db86676792@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440805192253s34b3acb2r63c657db86676792@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 10:53:58PM -0700, Yinghai Lu wrote:
 
 > you don't need to set that bit again...
 > 
 > prevoious !test_cpu_cap(..) already get out.
 

* Add an enablepat boot parameter, useful for testing CPUs not yet
  added to the whitelist.
* Don't try to enable PAT if it was never enabled in the first place.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 72c07a0..e179c22 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -236,6 +236,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			try_unsupported: try to drive unsupported chipsets
 				(may crash computer or cause data corruption)
 
+	enablepat	[i386,x86-64]
+			Force the CPU's PAT feature to be used even if it
+			isn't in the kernels whitelist.
+
 	enable_timer_pin_1 [i386,x86-64]
 			Enable PIN 1 of APIC timer
 			Can be useful to work around chipset bugs

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index c2e1ce3..e22e809 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -50,9 +50,27 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	}
 }
 
+static int forcepat;
+
+static int __init x86_forcepat_setup(char *s)
+{
+	forcepat = 1;
+	return 1;
+}
+__setup("enablepat", x86_forcepat_setup);
+
+
 #ifdef CONFIG_X86_PAT
 void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 {
+	if (!test_cpu_cap(c, X86_FEATURE_PAT))
+		return;
+
+	if (forcepat == 1) {
+		printk(KERN_INFO "Force enabling PAT\n");
+		return;
+	}
+
 	switch (c->x86_vendor) {
 	case X86_VENDOR_AMD:
 		if (c->x86 >= 0xf && c->x86 <= 0x11)

-- 
http://www.codemonkey.org.uk
