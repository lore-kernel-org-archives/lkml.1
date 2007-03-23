Return-Path: <linux-kernel-owner+w=401wt.eu-S2992443AbXCWPAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992443AbXCWPAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 11:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992439AbXCWPAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 11:00:43 -0400
Received: from www.osadl.org ([213.239.205.134]:41678 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992426AbXCWPAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 11:00:41 -0400
Subject: [PATCH] i386: add command line option "local_apic_timer_c2_ok"
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Thomas Renninger <trenn@suse.de>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <1174650969.10840.274.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070318184908.GU752@stusta.de>
	 <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org>
	 <46020385.50301@yahoo.com.au>
	 <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org>
	 <1174612132.16068.114.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org>
	 <20070323114223.GA23483@elte.hu>
	 <1174650969.10840.274.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 16:08:01 +0100
Message-Id: <1174662481.10840.292.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 12:56 +0100, Thomas Gleixner wrote:
> We should revert that patch and add a "trust_lapic_timer_in_c2"
> commandline option instead. So we are on the safe side.

Here is a patch which applies after reverting 
25496caec111481161e7f06bbfa12a533c43cc6f

It turned out that it is almost impossible to trust ACPI, BIOS & Co.
regarding the C states. This was the reason to switch the local apic
timer off in C2 state already. OTOH there are sane and well behaving
systems, which get punished by that decision.

Allow the user to confirm that the local apic timer is trustworthy in C2
state. This keeps the default behaviour on the safe side.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e39ab0c..09640a8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -780,6 +780,9 @@ and is between 256 and 4096 characters. It is defined in the file
 	lapic		[IA-32,APIC] Enable the local APIC even if BIOS
 			disabled it.
 
+	lapic_timer_c2_ok	[IA-32,APIC] trust the local apic timer in
+			C2 power state.
+
 	lasi=		[HW,SCSI] PARISC LASI driver for the 53c700 chip
 			Format: addr:<io>,irq:<irq>
 
diff --git a/arch/i386/kernel/apic.c b/arch/i386/kernel/apic.c
index 244c3fe..e884152 100644
--- a/arch/i386/kernel/apic.c
+++ b/arch/i386/kernel/apic.c
@@ -64,6 +64,9 @@ static int enable_local_apic __initdata = 0;
 static int local_apic_timer_verify_ok;
 /* Disable local APIC timer from the kernel commandline or via dmi quirk */
 static int local_apic_timer_disabled;
+/* Local APIC timer works in C2 */
+int local_apic_timer_c2_ok;
+EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
 
 /*
  * Debug level, exported for io_apic.c
@@ -1232,6 +1235,13 @@ static int __init parse_disable_lapic_timer(char *arg)
 }
 early_param("nolapic_timer", parse_disable_lapic_timer);
 
+static int __init parse_lapic_timer_c2_ok(char *arg)
+{
+	local_apic_timer_c2_ok = 1;
+	return 0;
+}
+early_param("lapic_timer_c2_ok", parse_lapic_timer_c2_ok);
+
 static int __init apic_set_verbosity(char *str)
 {
 	if (strcmp("debug", str) == 0)
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 6077300..cdf7894 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -268,6 +268,7 @@ static void acpi_timer_check_state(int state, struct acpi_processor *pr,
 				   struct acpi_processor_cx *cx)
 {
 	struct acpi_processor_power *pwr = &pr->power;
+	u8 type = local_apic_timer_c2_ok ? ACPI_STATE_C3 : ACPI_STATE_C2;
 
 	/*
 	 * Check, if one of the previous states already marked the lapic
@@ -276,7 +277,7 @@ static void acpi_timer_check_state(int state, struct acpi_processor *pr,
 	if (pwr->timer_broadcast_on_state < state)
 		return;
 
-	if (cx->type >= ACPI_STATE_C2)
+	if (cx->type >= type)
 		pr->power.timer_broadcast_on_state = state;
 }
 
diff --git a/include/asm-i386/apic.h b/include/asm-i386/apic.h
index cc6b165..a19810a 100644
--- a/include/asm-i386/apic.h
+++ b/include/asm-i386/apic.h
@@ -117,6 +117,7 @@ extern void enable_NMI_through_LVT0 (void * dummy);
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
 extern int timer_over_8254;
+extern int local_apic_timer_c2_ok;
 
 #else /* !CONFIG_X86_LOCAL_APIC */
 static inline void lapic_shutdown(void) { }


