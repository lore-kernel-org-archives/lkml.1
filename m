Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbZA3UHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbZA3UHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 15:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZA3UHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 15:07:20 -0500
Received: from relay1.sgi.com ([192.48.179.29]:39770 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754054AbZA3UHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 15:07:19 -0500
Message-ID: <49835DF5.6000301@sgi.com>
Date: Fri, 30 Jan 2009 12:07:17 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [Fwd: [PATCH] voyager: fix up for moving the generic smp call func
 to	pointers]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo - this is the second patch.

-------- Original Message --------
Subject: [PATCH] voyager: fix up for moving the generic smp call func to	pointers
Date: Fri, 30 Jan 2009 18:35:24 +0000
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mike Travis <travis@sgi.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>

commit e7986739a76cde5079da08809d8bbc6878387ae0
Author: Mike Travis <travis@sgi.com>
Date:   Tue Dec 16 17:33:52 2008 -0800

    x86 smp: modify send_IPI_mask interface to accept cpumask_t pointers

Changed all the IPI ops to take pointers, but didn't update voyager,
which is now broken.  Make the changes in voyager as well.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/mach-voyager/voyager_smp.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index b1b1bd3..7ffcdee 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -81,7 +81,7 @@ static void enable_local_vic_irq(unsigned int irq);
 static void disable_local_vic_irq(unsigned int irq);
 static void before_handle_vic_irq(unsigned int irq);
 static void after_handle_vic_irq(unsigned int irq);
-static void set_vic_irq_affinity(unsigned int irq, cpumask_t mask);
+static void set_vic_irq_affinity(unsigned int irq, const struct cpumask *mask);
 static void ack_vic_irq(unsigned int irq);
 static void vic_enable_cpi(void);
 static void do_boot_cpu(__u8 cpuid);
@@ -1597,16 +1597,16 @@ static void after_handle_vic_irq(unsigned int irq)
  * change the mask and then do an interrupt enable CPI to re-enable on
  * the selected processors */
 
-void set_vic_irq_affinity(unsigned int irq, cpumask_t mask)
+void set_vic_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	/* Only extended processors handle interrupts */
 	unsigned long real_mask;
 	unsigned long irq_mask = 1 << irq;
 	int cpu;
 
-	real_mask = cpus_addr(mask)[0] & voyager_extended_vic_processors;
+	real_mask = cpus_addr(*mask)[0] & voyager_extended_vic_processors;
 
-	if (cpus_addr(mask)[0] == 0)
+	if (cpus_addr(*mask)[0] == 0)
 		/* can't have no CPUs to accept the interrupt -- extremely
 		 * bad things will happen */
 		return;
@@ -1782,9 +1782,9 @@ void __init smp_setup_processor_id(void)
 	x86_write_percpu(cpu_number, hard_smp_processor_id());
 }
 
-static void voyager_send_call_func(cpumask_t callmask)
+static void voyager_send_call_func(const struct cpumask *callmask)
 {
-	__u32 mask = cpus_addr(callmask)[0] & ~(1 << smp_processor_id());
+	__u32 mask = cpus_addr(*callmask)[0] & ~(1 << smp_processor_id());
 	send_CPI(mask, VIC_CALL_FUNCTION_CPI);
 }
 
-- 
1.5.6.6


