Return-Path: <linux-kernel-owner+w=401wt.eu-S1763465AbYCSUGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763465AbYCSUGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757147AbYCSTib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbYCSTiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:25 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 03/79] [PATCH] use apic_*_around instead of apic_write in x86_64
Date: Wed, 19 Mar 2008 14:24:58 -0300
Message-Id: <12059475892790-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059475853453-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces apic_read() for apic_read_around()
and apic_write for apic_write_around() in smpboot_64.c
We do it to have a common usage between x86_64 and i386.
In the former, it will always simply expand to apic_write

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_64.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index 4f6d976..57ebe6c 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -281,8 +281,8 @@ static void inquire_remote_apic(int apicid)
 			printk(KERN_CONT
 			       "a previous APIC delivery may have failed\n");
 
-		apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(apicid));
-		apic_write(APIC_ICR, APIC_DM_REMRD | regs[i]);
+		apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(apicid));
+		apic_write_around(APIC_ICR, APIC_DM_REMRD | regs[i]);
 
 		timeout = 0;
 		do {
@@ -315,12 +315,12 @@ static int __cpuinit wakeup_secondary_via_INIT(int phys_apicid, unsigned int sta
 	/*
 	 * Turn INIT on target chip
 	 */
-	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
+	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
 
 	/*
 	 * Send IPI
 	 */
-	apic_write(APIC_ICR, APIC_INT_LEVELTRIG | APIC_INT_ASSERT
+	apic_write_around(APIC_ICR, APIC_INT_LEVELTRIG | APIC_INT_ASSERT
 				| APIC_DM_INIT);
 
 	Dprintk("Waiting for send to finish...\n");
@@ -331,10 +331,10 @@ static int __cpuinit wakeup_secondary_via_INIT(int phys_apicid, unsigned int sta
 	Dprintk("Deasserting INIT.\n");
 
 	/* Target chip */
-	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
+	apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
 
 	/* Send IPI */
-	apic_write(APIC_ICR, APIC_INT_LEVELTRIG | APIC_DM_INIT);
+	apic_write_around(APIC_ICR, APIC_INT_LEVELTRIG | APIC_DM_INIT);
 
 	Dprintk("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
@@ -353,6 +353,7 @@ static int __cpuinit wakeup_secondary_via_INIT(int phys_apicid, unsigned int sta
 
 	for (j = 1; j <= num_starts; j++) {
 		Dprintk("Sending STARTUP #%d.\n",j);
+		apic_read_around(APIC_SPIV);
 		apic_write(APIC_ESR, 0);
 		apic_read(APIC_ESR);
 		Dprintk("After apic_write.\n");
@@ -362,11 +363,11 @@ static int __cpuinit wakeup_secondary_via_INIT(int phys_apicid, unsigned int sta
 		 */
 
 		/* Target chip */
-		apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
+		apic_write_around(APIC_ICR2, SET_APIC_DEST_FIELD(phys_apicid));
 
 		/* Boot on the stack */
 		/* Kick the second */
-		apic_write(APIC_ICR, APIC_DM_STARTUP | (start_rip >> 12));
+		apic_write_around(APIC_ICR, APIC_DM_STARTUP | (start_rip>>12));
 
 		/*
 		 * Give the other CPU some time to accept the IPI.
@@ -386,6 +387,7 @@ static int __cpuinit wakeup_secondary_via_INIT(int phys_apicid, unsigned int sta
 		 * Due to the Pentium erratum 3AP.
 		 */
 		if (maxlvt > 3) {
+			apic_read_around(APIC_SPIV);
 			apic_write(APIC_ESR, 0);
 		}
 		accept_status = (apic_read(APIC_ESR) & 0xEF);
-- 
1.5.0.6

