Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbYHXJHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbYHXJHn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 05:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbYHXJDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 05:03:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:44068 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbYHXJDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 05:03:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iC17HVjEtW2Z1aWM/DDVRNjpmp/U4FoFp0DnWfttsMujMVcy0m3cL2tJJLYSNQwT2q
         xngtaZZXj3KFI0FIfPPT5EBa03WTiRxpqt2gjRKax0/0hpWmXI8wr3MK52BXd/OcQmce
         V/mTLK3ist/JP8sFqRiJrPUvd94hpQCmQ6tT0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Yinghai Lu <yhlu.kernel@mgail.com>
Subject: [PATCH 13/18] x86: copy detect_init_APIC to the other
Date: Sun, 24 Aug 2008 02:01:51 -0700
Message-Id: <1219568516-681-14-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
References: <1219568516-681-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@mgail.com>
---
 arch/x86/kernel/apic_32.c |   20 +++++++++++
 arch/x86/kernel/apic_64.c |   82 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 101 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 0d9c000..87566a3 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1214,6 +1214,25 @@ void __cpuinit end_local_APIC_setup(void)
 	apic_pm_activate();
 }
 
+#ifdef CONFIG_X86_64
+/*
+ * Detect and enable local APICs on non-SMP boards.
+ * Original code written by Keir Fraser.
+ * On AMD64 we trust the BIOS - if it says no APIC it is likely
+ * not correctly set up (usually the APIC timer won't work etc.)
+ */
+static int __init detect_init_APIC(void)
+{
+	if (!cpu_has_apic) {
+		printk(KERN_INFO "No local APIC present\n");
+		return -1;
+	}
+
+	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
+	boot_cpu_physical_apicid = 0;
+	return 0;
+}
+#else
 /*
  * Detect and initialize APIC
  */
@@ -1292,6 +1311,7 @@ no_apic:
 	printk(KERN_INFO "No local APIC present or hardware disabled\n");
 	return -1;
 }
+#endif
 
 #ifdef CONFIG_X86_64
 void __init early_init_lapic_mapping(void)
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 16a30c2..b7268f5 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -684,7 +684,6 @@ int setup_profiling_timer(unsigned int multiplier)
 	return -EINVAL;
 }
 
-
 /*
  * Local APIC start and shutdown
  */
@@ -1264,6 +1263,7 @@ end:
 }
 #endif /* HAVE_X2APIC */
 
+#ifdef CONFIG_X86_64
 /*
  * Detect and enable local APICs on non-SMP boards.
  * Original code written by Keir Fraser.
@@ -1281,6 +1281,86 @@ static int __init detect_init_APIC(void)
 	boot_cpu_physical_apicid = 0;
 	return 0;
 }
+#else
+/*
+ * Detect and initialize APIC
+ */
+static int __init detect_init_APIC(void)
+{
+	u32 h, l, features;
+
+	/* Disabled by kernel option? */
+	if (disable_apic)
+		return -1;
+
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+		if ((boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model > 1) ||
+		    (boot_cpu_data.x86 == 15))
+			break;
+		goto no_apic;
+	case X86_VENDOR_INTEL:
+		if (boot_cpu_data.x86 == 6 || boot_cpu_data.x86 == 15 ||
+		    (boot_cpu_data.x86 == 5 && cpu_has_apic))
+			break;
+		goto no_apic;
+	default:
+		goto no_apic;
+	}
+
+	if (!cpu_has_apic) {
+		/*
+		 * Over-ride BIOS and try to enable the local APIC only if
+		 * "lapic" specified.
+		 */
+		if (!force_enable_local_apic) {
+			printk(KERN_INFO "Local APIC disabled by BIOS -- "
+			       "you can enable it with \"lapic\"\n");
+			return -1;
+		}
+		/*
+		 * Some BIOSes disable the local APIC in the APIC_BASE
+		 * MSR. This can only be done in software for Intel P6 or later
+		 * and AMD K7 (Model > 1) or later.
+		 */
+		rdmsr(MSR_IA32_APICBASE, l, h);
+		if (!(l & MSR_IA32_APICBASE_ENABLE)) {
+			printk(KERN_INFO
+			       "Local APIC disabled by BIOS -- reenabling.\n");
+			l &= ~MSR_IA32_APICBASE_BASE;
+			l |= MSR_IA32_APICBASE_ENABLE | APIC_DEFAULT_PHYS_BASE;
+			wrmsr(MSR_IA32_APICBASE, l, h);
+			enabled_via_apicbase = 1;
+		}
+	}
+	/*
+	 * The APIC feature bit should now be enabled
+	 * in `cpuid'
+	 */
+	features = cpuid_edx(1);
+	if (!(features & (1 << X86_FEATURE_APIC))) {
+		printk(KERN_WARNING "Could not enable APIC!\n");
+		return -1;
+	}
+	set_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
+	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
+
+	/* The BIOS may have set up the APIC at some other address */
+	rdmsr(MSR_IA32_APICBASE, l, h);
+	if (l & MSR_IA32_APICBASE_ENABLE)
+		mp_lapic_addr = l & MSR_IA32_APICBASE_BASE;
+
+	printk(KERN_INFO "Found and enabled local APIC!\n");
+
+	apic_pm_activate();
+
+	return 0;
+
+no_apic:
+	printk(KERN_INFO "No local APIC present or hardware disabled\n");
+	return -1;
+}
+#endif
 
 #ifdef CONFIG_X86_64
 void __init early_init_lapic_mapping(void)
-- 
1.5.4.5

