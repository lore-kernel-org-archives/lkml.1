Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbYFPBTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbYFPBTW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 21:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbYFPBTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 21:19:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:54013 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYFPBTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 21:19:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=DFxMyDgd7aQoE1NcgxHjV2YiCOaWjCSRAUvdakoPuYky0soZeuXPS3zhFMhR+wI2Ae
         mwJB4YZJxthrCpNZbJRWbDQoFI5kMxLLGiYQtP/tAa0+O961xEmvLnFtGw4Vr06bfn2p
         7PmvJu43QUCfoWT2CtENDDRFU+iq/HHpuU3Kw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: using dstapic in mp_config_acpi_legacy_irqs
Date: Sun, 15 Jun 2008 18:19:46 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806151819.47236.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so don't get that same value multiple times.

also make mp_config_acpi_legacy_irqs more readable by moving some assignment
together.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d2a4768..04dbb35 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -960,8 +960,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
 void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 {
-	int ioapic = -1;
-	int pin = -1;
+	int ioapic;
+	int pin;
 
 	/*
 	 * Convert 'gsi' to 'ioapic.pin'.
@@ -995,8 +995,9 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 
 void __init mp_config_acpi_legacy_irqs(void)
 {
-	int i = 0;
-	int ioapic = -1;
+	int i;
+	int ioapic;
+	unsigned int dstapic;
 
 #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
 	/*
@@ -1021,6 +1022,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 	ioapic = mp_find_ioapic(0);
 	if (ioapic < 0)
 		return;
+	dstapic = mp_ioapics[ioapic].mp_apicid;
 
 	/*
 	 * Use the default configuration for the IRQs 0-15.  Unless
@@ -1029,11 +1031,6 @@ void __init mp_config_acpi_legacy_irqs(void)
 	for (i = 0; i < 16; i++) {
 		int idx;
 
-		mp_irqs[mp_irq_entries].mp_type = MP_INTSRC;
-		mp_irqs[mp_irq_entries].mp_irqflag = 0;	/* Conforming */
-		mp_irqs[mp_irq_entries].mp_srcbus = MP_ISA_BUS;
-		mp_irqs[mp_irq_entries].mp_dstapic = mp_ioapics[ioapic].mp_apicid;
-
 		for (idx = 0; idx < mp_irq_entries; idx++) {
 			struct mp_config_intsrc *irq = mp_irqs + idx;
 
@@ -1043,9 +1040,8 @@ void __init mp_config_acpi_legacy_irqs(void)
 				break;
 
 			/* Do we already have a mapping for this IOAPIC pin */
-			if ((irq->mp_dstapic ==
-				mp_irqs[mp_irq_entries].mp_dstapic) &&
-			    (irq->mp_dstirq == i))
+			if (irq->mp_dstapic == dstapic &&
+			    irq->mp_dstirq == i)
 				break;
 		}
 
@@ -1054,8 +1050,12 @@ void __init mp_config_acpi_legacy_irqs(void)
 			continue;	/* IRQ already used */
 		}
 
+		mp_irqs[mp_irq_entries].mp_type = MP_INTSRC;
+		mp_irqs[mp_irq_entries].mp_irqflag = 0;	/* Conforming */
+		mp_irqs[mp_irq_entries].mp_srcbus = MP_ISA_BUS;
+		mp_irqs[mp_irq_entries].mp_dstapic = dstapic;
 		mp_irqs[mp_irq_entries].mp_irqtype = mp_INT;
-		mp_irqs[mp_irq_entries].mp_srcbusirq = i;	/* Identity mapped */
+		mp_irqs[mp_irq_entries].mp_srcbusirq = i; /* Identity mapped */
 		mp_irqs[mp_irq_entries].mp_dstirq = i;
 
 		if (++mp_irq_entries == MAX_IRQ_SOURCES)
