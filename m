Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbZDNP4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbZDNP4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbZDNPv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:51:56 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46011 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755376AbZDNPvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:51:52 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 12/14] [VOYAGER] x86/Voyager: replace inline io area reads with readX accessors
Date: Tue, 14 Apr 2009 10:51:38 -0500
Message-Id: <1239724300-16371-13-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1239724300-16371-12-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-3-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-4-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-5-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-6-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-7-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-8-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-9-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-10-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-11-git-send-email-James.Bottomley@HansenPartnership.com>
 <1239724300-16371-12-git-send-email-James.Bottomley@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the memory manipulations done to reset QIC CPIs and to check
on booted processors rely on the read actually being issued.  With
newer versions of gcc this is no longer happening (presumably it sees
the read with no effect and optimises it away).  Replace the reads
with readX to assure volatile semantics for issuing the access.  This
fixes a bug where QIC based voyagers won't boot with certain versions
of gcc.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/mach-voyager/voyager_smp.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 84d1d7f..d7c2a6a 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -70,7 +70,7 @@ cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
 /* The internal functions */
 static void send_CPI(__u32 cpuset, __u8 cpi);
 static void ack_CPI(__u8 cpi);
-static int ack_QIC_CPI(__u8 cpi);
+static inline void ack_QIC_CPI(__u8 cpi);
 static void ack_special_QIC_CPI(__u8 cpi);
 static void ack_VIC_CPI(__u8 cpi);
 static void send_CPI_allbutself(__u8 cpi);
@@ -433,14 +433,9 @@ static void __init start_secondary(void *unused)
 
 	qic_setup();
 
-	if (is_cpu_quad() && !is_cpu_vic_boot()) {
+	if (is_cpu_quad() && !is_cpu_vic_boot())
 		/* clear the boot CPI */
-		__u8 dummy;
-
-		dummy =
-		    voyager_quad_cpi_addr[cpuid]->qic_cpi[VIC_CPU_BOOT_CPI].cpi;
-		printk("read dummy %d\n", dummy);
-	}
+		readw(&voyager_quad_cpi_addr[cpuid]->qic_cpi[VIC_CPU_BOOT_CPI].cpi);
 
 	/* lower the mask to receive CPIs */
 	vic_enable_cpi();
@@ -603,9 +598,7 @@ static void __init do_boot_cpu(__u8 cpu)
 		cpu_set(cpu, cpu_present_map);
 	} else {
 		printk("CPU%d FAILED TO BOOT: ", cpu);
-		if (*
-		    ((volatile unsigned char *)phys_to_virt(start_phys_address))
-		    == 0xA5)
+		if (readb(phys_to_virt(start_phys_address)) == 0xA5)
 			printk("Stuck.\n");
 		else
 			printk("Not responding.\n");
@@ -1306,18 +1299,15 @@ static void send_CPI(__u32 cpuset, __u8 cpi)
 
 /* Acknowledge receipt of CPI in the QIC, clear in QIC hardware and
  * set the cache line to shared by reading it.
- *
- * DON'T make this inline otherwise the cache line read will be
- * optimised away
  * */
-static int ack_QIC_CPI(__u8 cpi)
+static inline void ack_QIC_CPI(__u8 cpi)
 {
 	__u8 cpu = hard_smp_processor_id();
 
 	cpi &= 7;
 
 	outb(1 << cpi, QIC_INTERRUPT_CLEAR1);
-	return voyager_quad_cpi_addr[cpu]->qic_cpi[cpi].cpi;
+	readw(&voyager_quad_cpi_addr[cpu]->qic_cpi[cpi].cpi);
 }
 
 static void ack_special_QIC_CPI(__u8 cpi)
-- 
1.6.2.1

