Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab0BWLvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 06:51:39 -0500
Received: from cantor.suse.de ([195.135.220.2]:45233 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab0BWLvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 06:51:37 -0500
From: Thomas Renninger <trenn@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kerstin Jonsson <kerstin.jonsson@ericsson.com>, jbohac@novell.com,
       "Yinghai Lu" <yinghai@kernel.org>, akpm@linux-foundation.org,
       mingo@elte.hu, Thomas Renninger <trenn@suse.de>
Subject: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec
Date: Tue, 23 Feb 2010 12:51:25 +0100
Message-Id: <1266925885-17616-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kerstin Jonsson <kerstin.jonsson@ericsson.com>

When the SMP kernel decides to crash_kexec() the local APICs may have
pending interrupts in their vector tables.
The setup routine for the local APIC has a deficient mechanism for
clearing these interrupts, it only handles interrupts that has already
been dispatched to the local core for servicing (the ISR register)
safely, it doesn't consider lower prioritized queued interrupts stored
in the IRR register.

If you have more than one pending interrupt within the same 32 bit word
in the LAPIC vector table registers you may find yourself entering the
IO APIC setup with pending interrupts left in the LAPIC. This is a
situation for wich the IO APIC setup is not prepared. Depending of
what/which interrupt vector/vectors are stuck in the APIC tables your
system may show various degrees of malfunctioning.
That was the reason why the check_timer() failed in our system, the
timer interrupts was blocked by pending interrupts from the old kernel
when routed trough the IO APIC.

Additional comment from Jiri Bohac:
==============
If this should go into stable release,
I'd add some kind of limit on the number of iterations, just to be safe from
hard to debug lock-ups:

+if (loops++  > MAX_LOOPS) {
+        printk("LAPIC pending clean-up")
+        break;
+}
 while (queued);

with MAX_LOOPS something like 1E9 this would leave plenty of time for the
pending IRQs to be cleared and would and still cause at most a second of delay
if the loop were to lock-up for whatever reason.
==============

>From trenn@suse.de:
Merged Jiri suggestion into the patch.
Also made the max_loops depend on cpu_khz. Not sure how long an apic_read
takes, as it is on the CPU it may only be one cycle and we now wait 1 sec
in WARN_ON(..) case?

CC: jbohac@novell.com
CC: "Yinghai Lu" <yinghai@kernel.org>
CC: akpm@linux-foundation.org
CC: mingo@elte.hu
CC: "Kerstin Jonsson" <kerstin.jonsson@ericsson.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 arch/x86/kernel/apic/apic.c |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3987e44..912dd59 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -51,6 +51,7 @@
 #include <asm/smp.h>
 #include <asm/mce.h>
 #include <asm/kvm_para.h>
+#include <asm/tsc.h>
 
 unsigned int num_processors;
 
@@ -1151,8 +1152,8 @@ static void __cpuinit lapic_setup_esr(void)
  */
 void __cpuinit setup_local_APIC(void)
 {
-	unsigned int value;
-	int i, j;
+	unsigned int value, queued;
+	int i, j, acked = 0, max_loops = cpu_khz * 1000;
 
 	if (disable_apic) {
 		arch_disable_smp_support();
@@ -1204,13 +1205,28 @@ void __cpuinit setup_local_APIC(void)
 	 * the interrupt. Hence a vector might get locked. It was noticed
 	 * for timer irq (vector 0x31). Issue an extra EOI to clear ISR.
 	 */
-	for (i = APIC_ISR_NR - 1; i >= 0; i--) {
-		value = apic_read(APIC_ISR + i*0x10);
-		for (j = 31; j >= 0; j--) {
-			if (value & (1<<j))
-				ack_APIC_irq();
-		}
-	}
+        do {
+            queued = 0;
+            for (i = APIC_ISR_NR - 1; i >= 0; i--)
+                queued |= apic_read(APIC_IRR + i*0x10);
+
+            for (i = APIC_ISR_NR - 1; i >= 0; i--) {
+                value = apic_read(APIC_ISR + i*0x10);
+                for (j = 31; j >= 0; j--) {
+                    if (value & (1<<j)) {
+                        ack_APIC_irq();
+                        acked++;
+                    }
+                }
+            }
+            if (acked > 256) {
+                printk(KERN_ERR "LAPIC pending interrupts after %d EOI\n",
+		       acked);
+                break;
+            }
+	    max_loops--;
+        } while (queued && max_loops > 0);
+	WARN_ON(!max_loops);
 
 	/*
 	 * Now that we are all set up, enable the APIC
-- 
1.6.3

