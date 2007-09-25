Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbXIYThW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbXIYThW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 15:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbXIYThL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 15:37:11 -0400
Received: from www.osadl.org ([213.239.205.134]:45787 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752604AbXIYThJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 15:37:09 -0400
Subject: [PATCH] x86-64: Disable local APIC timer use on AMD systems with
	C1E
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Andi Kleen <ak@suse.de>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 21:37:01 +0200
Message-Id: <1190749021.17409.35.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 3556ddfa9284a86a59a9b78fe5894430f6ab4eef titled

 [PATCH] x86-64: Disable local APIC timer use on AMD systems with C1E

solves a problem with AMD dual core laptops e.g. HP nx6325 (Turion 64
X2) with C1E enabled:

When both cores go into idle at the same time, then the system switches
into C1E state, which is basically the same as C3. This stops the local
apic timer.

This was debugged right after the dyntick merge on i386 and despite the
patch title it fixes only the 32 bit path.

x86_64 is still missing this fix. It seems that mainline is not really
affected by this issue, as the PIT is running and keeps jiffies
incrementing, but that's just waiting for trouble. 

-mm suffers from this problem due to the x86_64 high resolution timer
patches.

This is a quick and dirty port of the i386 code to x86_64. 

I spent quite a time with Rafael to debug the -mm / hrt wreckage until
someone pointed us to this. I really had forgotten that we debugged this
half a year ago already. 

Sigh, is it just me or is there something yelling arch/x86 into my ear?

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
index af838f6..32054bf 100644
--- a/arch/x86_64/kernel/setup.c
+++ b/arch/x86_64/kernel/setup.c
@@ -546,6 +546,37 @@ static void __init amd_detect_cmp(struct cpuinfo_x86 *c)
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
 	unsigned level;
@@ -617,6 +648,9 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	/* Family 10 doesn't support C states in MWAIT so don't use it */
 	if (c->x86 == 0x10 && !force_mwait)
 		clear_bit(X86_FEATURE_MWAIT, &c->x86_capability);
+
+	if (amd_apic_timer_broken())
+		disable_apic_timer = 1;
 }
 
 static void __cpuinit detect_ht(struct cpuinfo_x86 *c)
diff --git a/include/asm-x86_64/apic.h b/include/asm-x86_64/apic.h
index 85125ef..e458020 100644
--- a/include/asm-x86_64/apic.h
+++ b/include/asm-x86_64/apic.h
@@ -20,6 +20,7 @@ extern int apic_verbosity;
 extern int apic_runs_main_timer;
 extern int ioapic_force;
 extern int apic_mapped;
+extern int disable_apic_timer;
 
 /*
  * Define the default level of output to be very little


