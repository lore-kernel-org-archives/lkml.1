Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbYDHUtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbYDHUtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbYDHUs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:48:56 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:45421 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753363AbYDHUsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:48:55 -0400
Subject: Re: [PATCH] Fix paranoia about using BIOS quickboot mechanism.
From: Alok Kataria <akataria@vmware.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Daniel Arai <arai@vmware.com>,
       Zachary Amsden <zach@vmware.com>
In-Reply-To: <1207593513.5864.25.camel@promb-2n-dhcp158.eng.vmware.com>
References: <1207352954.6294.30.camel@promb-2n-dhcp158.eng.vmware.com>
	 <20080407082256.GA3524@elte.hu>
	 <1207593513.5864.25.camel@promb-2n-dhcp158.eng.vmware.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: VMware, Inc.
Date: Tue, 08 Apr 2008 13:48:06 -0700
Message-Id: <1207687686.5864.57.camel@promb-2n-dhcp158.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,


Here is the patch that fits on the mainline tree 2.6.25-rc8. The earlier patch that I sent was on X86-git tree. 

Tested for both 32bit and 64bit.

--
Fix paranoia about using BIOS quickboot mechanism.

Make sure that we clear the "shutdown status flag" in the CMOS register
after each CPU is brought up.  This fixes a problem where the "shutdown
status flag" may remain set when a CPU is brought up after booting.

Patch on top of linux-2.6.25-rc8.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Dan Arai <arai@vmware.com>

Index: linux-2.6.25-rc8/arch/x86/kernel/smpboot_32.c
===================================================================
--- linux-2.6.25-rc8.orig/arch/x86/kernel/smpboot_32.c	2008-04-08 11:36:37.000000000 -0700
+++ linux-2.6.25-rc8/arch/x86/kernel/smpboot_32.c	2008-04-08 12:04:00.000000000 -0700
@@ -869,6 +869,11 @@
 	/* mark "stuck" area as not stuck */
 	*((volatile unsigned long *)trampoline_base) = 0;
 
+	/*
+	 * Cleanup possible dangling ends...
+	 */
+	smpboot_restore_warm_reset_vector();
+
 	return boot_error;
 }
 
@@ -1070,11 +1075,6 @@
 	}
 
 	/*
-	 * Cleanup possible dangling ends...
-	 */
-	smpboot_restore_warm_reset_vector();
-
-	/*
 	 * Allow the user to impress friends.
 	 */
 	Dprintk("Before bogomips.\n");
Index: linux-2.6.25-rc8/arch/x86/kernel/smpboot_64.c
===================================================================
--- linux-2.6.25-rc8.orig/arch/x86/kernel/smpboot_64.c	2008-04-08 11:36:37.000000000 -0700
+++ linux-2.6.25-rc8/arch/x86/kernel/smpboot_64.c	2008-04-08 12:04:01.000000000 -0700
@@ -546,6 +546,23 @@
 }
 
 /*
+ * Cleanup possible dangling ends...
+ */
+static __cpuinit void smp_cleanup_boot(void)
+{
+	/*
+	 * Paranoid:  Set warm reset code and vector here back
+	 * to default values.
+	 */
+	CMOS_WRITE(0, 0xf);
+
+	/*
+	 * Reset trampoline flag
+	 */
+	*((volatile int *) phys_to_virt(0x467)) = 0;
+}
+
+/*
  * Boot one CPU.
  */
 static int __cpuinit do_boot_cpu(int cpu, int apicid)
@@ -699,6 +716,7 @@
 #endif
 		}
 	}
+	smp_cleanup_boot();
 	if (boot_error) {
 		cpu_clear(cpu, cpu_callout_map); /* was set here (do_boot_cpu()) */
 		clear_bit(cpu, (unsigned long *)&cpu_initialized); /* was set by cpu_init() */
@@ -716,23 +734,6 @@
 unsigned long cache_decay_ticks;
 
 /*
- * Cleanup possible dangling ends...
- */
-static __cpuinit void smp_cleanup_boot(void)
-{
-	/*
-	 * Paranoid:  Set warm reset code and vector here back
-	 * to default values.
-	 */
-	CMOS_WRITE(0, 0xf);
-
-	/*
-	 * Reset trampoline flag
-	 */
-	*((volatile int *) phys_to_virt(0x467)) = 0;
-}
-
-/*
  * Fall back to non SMP mode after errors.
  *
  * RED-PEN audit/test this more. I bet there is more state messed up here.
@@ -989,7 +990,6 @@
  */
 void __init smp_cpus_done(unsigned int max_cpus)
 {
-	smp_cleanup_boot();
 	setup_ioapic_dest();
 	check_nmi_watchdog();
 }

