Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbXIYUk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbXIYUk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbXIYUkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:40:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36319 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551AbXIYUkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:40:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: Disable local APIC timer use on AMD systems with C1E
Date: Tue, 25 Sep 2007 22:55:04 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@osdl.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>
References: <1190749021.17409.35.camel@chaos>
In-Reply-To: <1190749021.17409.35.camel@chaos>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_qWX+G+xP5PvOLcC"
Message-Id: <200709252255.06039.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_qWX+G+xP5PvOLcC
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday, 25 September 2007 21:37, Thomas Gleixner wrote:
> commit 3556ddfa9284a86a59a9b78fe5894430f6ab4eef titled
> 
>  [PATCH] x86-64: Disable local APIC timer use on AMD systems with C1E
> 
> solves a problem with AMD dual core laptops e.g. HP nx6325 (Turion 64
> X2) with C1E enabled:
> 
> When both cores go into idle at the same time, then the system switches
> into C1E state, which is basically the same as C3. This stops the local
> apic timer.
> 
> This was debugged right after the dyntick merge on i386 and despite the
> patch title it fixes only the 32 bit path.
> 
> x86_64 is still missing this fix. It seems that mainline is not really
> affected by this issue, as the PIT is running and keeps jiffies
> incrementing, but that's just waiting for trouble. 
> 
> -mm suffers from this problem due to the x86_64 high resolution timer
> patches.
> 
> This is a quick and dirty port of the i386 code to x86_64. 
> 
> I spent quite a time with Rafael to debug the -mm / hrt wreckage until
> someone pointed us to this. I really had forgotten that we debugged this
> half a year ago already. 
> 
> Sigh, is it just me or is there something yelling arch/x86 into my ear?
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

I have reworked the patch a bit so that it applies on top of 2.6.23-rc8-mm1
and compiles (my version is attached).

With this patch applied, the kernel boots correctly on the nx6325.

Greetings,
Rafael

--Boundary-00=_qWX+G+xP5PvOLcC
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="x86-64-disable-local-APIC-timer-use-on-AMD-systems-with-C1E.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="x86-64-disable-local-APIC-timer-use-on-AMD-systems-with-C1E.patch"


---
 arch/x86_64/kernel/apic.c  |    2 +-
 arch/x86_64/kernel/setup.c |   34 ++++++++++++++++++++++++++++++++++
 include/asm-x86_64/apic.h  |    1 +
 3 files changed, 36 insertions(+), 1 deletion(-)

Index: linux-2.6.23-rc8-mm1/arch/x86_64/kernel/setup.c
===================================================================
--- linux-2.6.23-rc8-mm1.orig/arch/x86_64/kernel/setup.c
+++ linux-2.6.23-rc8-mm1/arch/x86_64/kernel/setup.c
@@ -620,6 +620,37 @@ static void __cpuinit early_init_amd(str
 #endif
 }
 
+#define ENABLE_C1E_MASK		0x18000000
+#define CPUID_PROCESSOR_SIGNATURE	1
+#define CPUID_XFAM		0x0ff00000
+#define CPUID_XFAM_K8		0x00000000
+#define CPUID_XFAM_10H		0x00100000
+#define CPUID_XFAM_11H		0x00200000
+#define CPUID_XMOD		0x000f0000
+#define CPUID_XMOD_REV_F	0x00040000
+
+/* AMD systems with C1E don't have a working lAPIC timer. Check for that. */
+static __cpuinit int amd_apic_timer_broken(void)
+{
+	u32 lo, hi;
+	u32 eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
+	switch (eax & CPUID_XFAM) {
+	case CPUID_XFAM_K8:
+		if ((eax & CPUID_XMOD) < CPUID_XMOD_REV_F)
+			break;
+	case CPUID_XFAM_10H:
+	case CPUID_XFAM_11H:
+		rdmsr(MSR_K8_ENABLE_C1E, lo, hi);
+		if (lo & ENABLE_C1E_MASK)
+			return 1;
+		break;
+	default:
+		/* err on the side of caution */
+		return 1;
+	}
+	return 0;
+}
+
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 {
 	unsigned level, flags, dummy;
@@ -692,6 +723,9 @@ static void __cpuinit init_amd(struct cp
 	if (c->x86 == 0x10 && !force_mwait)
 		clear_bit(X86_FEATURE_MWAIT, &c->x86_capability);
 
+	if (amd_apic_timer_broken())
+		disable_apic_timer = 1;
+
 	if (c->x86 >= 0xf && c->x86 <= 0x11 &&
 	    !rdmsr_safe(MSR_VM_CR, &flags, &dummy) &&
 	    (flags & 0x18))
Index: linux-2.6.23-rc8-mm1/include/asm-x86_64/apic.h
===================================================================
--- linux-2.6.23-rc8-mm1.orig/include/asm-x86_64/apic.h
+++ linux-2.6.23-rc8-mm1/include/asm-x86_64/apic.h
@@ -19,6 +19,7 @@
 extern int apic_verbosity;
 extern int apic_runs_main_timer;
 extern int ioapic_force;
+extern int disable_apic_timer;
 
 /*
  * Define the default level of output to be very little
Index: linux-2.6.23-rc8-mm1/arch/x86_64/kernel/apic.c
===================================================================
--- linux-2.6.23-rc8-mm1.orig/arch/x86_64/kernel/apic.c
+++ linux-2.6.23-rc8-mm1/arch/x86_64/kernel/apic.c
@@ -41,8 +41,8 @@
 #include <asm/apic.h>
 
 int apic_verbosity;
+int disable_apic_timer __initdata;
 static int apic_calibrate_pmtmr __initdata;
-static int disable_apic_timer __initdata;
 
 /* Local APIC timer works in C2? */
 int local_apic_timer_c2_ok;

--Boundary-00=_qWX+G+xP5PvOLcC--
