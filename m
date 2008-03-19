Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbYCSUVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbYCSUVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbYCSTjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215AbYCSTi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:59 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 53/79] [PATCH] wrap esr setting up in i386 in lapic_setup_esr
Date: Wed, 19 Mar 2008 14:25:48 -0300
Message-Id: <12059478142946-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059478102473-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

it is a little bit more complicated than x86_64 due to erratas and
other stuff, but its existance will ease integration

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/apic_32.c |   73 ++++++++++++++++++++++++--------------------
 1 files changed, 40 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index c32cc0f..80c81c7 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -897,12 +897,50 @@ void __init init_bsp_APIC(void)
 	apic_write_around(APIC_LVT1, value);
 }
 
+void __cpuinit lapic_setup_esr(void)
+{
+	unsigned long oldvalue, value, maxlvt;
+	if (lapic_is_integrated() && !esr_disable) {
+		/* !82489DX */
+		maxlvt = lapic_get_maxlvt();
+		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP. */
+			apic_write(APIC_ESR, 0);
+		oldvalue = apic_read(APIC_ESR);
+
+		/* enables sending errors */
+		value = ERROR_APIC_VECTOR;
+		apic_write_around(APIC_LVTERR, value);
+		/*
+		 * spec says clear errors after enabling vector.
+		 */
+		if (maxlvt > 3)
+			apic_write(APIC_ESR, 0);
+		value = apic_read(APIC_ESR);
+		if (value != oldvalue)
+			apic_printk(APIC_VERBOSE, "ESR value before enabling "
+				"vector: 0x%08lx  after: 0x%08lx\n",
+				oldvalue, value);
+	} else {
+		if (esr_disable)
+			/*
+			 * Something untraceable is creating bad interrupts on
+			 * secondary quads ... for the moment, just leave the
+			 * ESR disabled - we can't do anything useful with the
+			 * errors anyway - mbligh
+			 */
+			printk(KERN_INFO "Leaving ESR disabled.\n");
+		else
+			printk(KERN_INFO "No ESR for 82489DX.\n");
+	}
+}
+
+
 /**
  * setup_local_APIC - setup the local APIC
  */
 void __cpuinit setup_local_APIC(void)
 {
-	unsigned long oldvalue, value, maxlvt, integrated;
+	unsigned long value, integrated;
 	int i, j;
 
 	/* Pound the ESR really hard over the head with a big hammer - mbligh */
@@ -1027,38 +1065,7 @@ void __cpuinit setup_local_APIC(void)
 		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write_around(APIC_LVT1, value);
 
-	if (integrated && !esr_disable) {
-		/* !82489DX */
-		maxlvt = lapic_get_maxlvt();
-		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP. */
-			apic_write(APIC_ESR, 0);
-		oldvalue = apic_read(APIC_ESR);
-
-		/* enables sending errors */
-		value = ERROR_APIC_VECTOR;
-		apic_write_around(APIC_LVTERR, value);
-		/*
-		 * spec says clear errors after enabling vector.
-		 */
-		if (maxlvt > 3)
-			apic_write(APIC_ESR, 0);
-		value = apic_read(APIC_ESR);
-		if (value != oldvalue)
-			apic_printk(APIC_VERBOSE, "ESR value before enabling "
-				"vector: 0x%08lx  after: 0x%08lx\n",
-				oldvalue, value);
-	} else {
-		if (esr_disable)
-			/*
-			 * Something untraceable is creating bad interrupts on
-			 * secondary quads ... for the moment, just leave the
-			 * ESR disabled - we can't do anything useful with the
-			 * errors anyway - mbligh
-			 */
-			printk(KERN_INFO "Leaving ESR disabled.\n");
-		else
-			printk(KERN_INFO "No ESR for 82489DX.\n");
-	}
+	lapic_setup_esr();
 
 	/* Disable the local apic timer */
 	value = apic_read(APIC_LVTT);
-- 
1.5.0.6

