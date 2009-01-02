Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbZABKoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbZABKoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbZABKlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:41:46 -0500
Received: from nelson.telenet-ops.be ([195.130.133.66]:36237 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668AbZABKlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:37 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: mac core - kill warn_unused_result warnings
Date: Fri,  2 Jan 2009 11:41:18 +0100
Message-Id: <1230892892-25751-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-5-git-send-email-geert@linux-m68k.org>
References: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-3-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-4-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-5-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: ignoring return value of 'request_irq', declared with attribute
warn_unused_result

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mac/baboon.c  |    3 ++-
 arch/m68k/mac/iop.c     |   10 ++++++----
 arch/m68k/mac/macints.c |    5 +++--
 arch/m68k/mac/oss.c     |   25 +++++++++++++++----------
 arch/m68k/mac/psc.c     |   12 ++++++++----
 arch/m68k/mac/via.c     |   33 ++++++++++++++++++++-------------
 6 files changed, 54 insertions(+), 34 deletions(-)

diff --git a/arch/m68k/mac/baboon.c b/arch/m68k/mac/baboon.c
index 245d16d..2a96beb 100644
--- a/arch/m68k/mac/baboon.c
+++ b/arch/m68k/mac/baboon.c
@@ -92,7 +92,8 @@ static irqreturn_t baboon_irq(int irq, void *dev_id)
 void __init baboon_register_interrupts(void)
 {
 	baboon_disabled = 0;
-	request_irq(IRQ_NUBUS_C, baboon_irq, 0, "baboon", (void *)baboon);
+	if (request_irq(IRQ_NUBUS_C, baboon_irq, 0, "baboon", (void *)baboon))
+		pr_err("Couldn't register baboon interrupt\n");
 }
 
 /*
diff --git a/arch/m68k/mac/iop.c b/arch/m68k/mac/iop.c
index 326fb99..1ad4e9d 100644
--- a/arch/m68k/mac/iop.c
+++ b/arch/m68k/mac/iop.c
@@ -305,14 +305,16 @@ void __init iop_register_interrupts(void)
 {
 	if (iop_ism_present) {
 		if (oss_present) {
-			request_irq(OSS_IRQLEV_IOPISM, iop_ism_irq,
+			if (request_irq(OSS_IRQLEV_IOPISM, iop_ism_irq,
 					IRQ_FLG_LOCK, "ISM IOP",
-					(void *) IOP_NUM_ISM);
+					(void *) IOP_NUM_ISM))
+				pr_err("Couldn't register ISM IOP interrupt\n");
 			oss_irq_enable(IRQ_MAC_ADB);
 		} else {
-			request_irq(IRQ_VIA2_0, iop_ism_irq,
+			if (request_irq(IRQ_VIA2_0, iop_ism_irq,
 					IRQ_FLG_LOCK|IRQ_FLG_FAST, "ISM IOP",
-					(void *) IOP_NUM_ISM);
+					(void *) IOP_NUM_ISM))
+				pr_err("Couldn't register ISM IOP interrupt\n");
 		}
 		if (!iop_alive(iop_base[IOP_NUM_ISM])) {
 			printk("IOP: oh my god, they killed the ISM IOP!\n");
diff --git a/arch/m68k/mac/macints.c b/arch/m68k/mac/macints.c
index 7d0cbf3..2371107 100644
--- a/arch/m68k/mac/macints.c
+++ b/arch/m68k/mac/macints.c
@@ -250,8 +250,9 @@ void __init mac_init_IRQ(void)
 	if (baboon_present)
 		baboon_register_interrupts();
 	iop_register_interrupts();
-	request_irq(IRQ_AUTO_7, mac_nmi_handler, 0, "NMI",
-			mac_nmi_handler);
+	if (request_irq(IRQ_AUTO_7, mac_nmi_handler, 0, "NMI",
+			mac_nmi_handler))
+		pr_err("Couldn't register NMI\n");
 #ifdef DEBUG_MACINTS
 	printk("mac_init_IRQ(): Done!\n");
 #endif
diff --git a/arch/m68k/mac/oss.c b/arch/m68k/mac/oss.c
index 8426501..f3d23d6 100644
--- a/arch/m68k/mac/oss.c
+++ b/arch/m68k/mac/oss.c
@@ -66,16 +66,21 @@ void __init oss_init(void)
 
 void __init oss_register_interrupts(void)
 {
-	request_irq(OSS_IRQLEV_SCSI, oss_irq, IRQ_FLG_LOCK,
-			"scsi", (void *) oss);
-	request_irq(OSS_IRQLEV_IOPSCC, mac_scc_dispatch, IRQ_FLG_LOCK,
-			"scc", mac_scc_dispatch);
-	request_irq(OSS_IRQLEV_NUBUS, oss_nubus_irq, IRQ_FLG_LOCK,
-			"nubus", (void *) oss);
-	request_irq(OSS_IRQLEV_SOUND, oss_irq, IRQ_FLG_LOCK,
-			"sound", (void *) oss);
-	request_irq(OSS_IRQLEV_VIA1, via1_irq, IRQ_FLG_LOCK,
-			"via1", (void *) via1);
+	if (request_irq(OSS_IRQLEV_SCSI, oss_irq, IRQ_FLG_LOCK,
+			"scsi", (void *) oss))
+		pr_err("Couldn't register %s interrupt\n", "scsi");
+	if (request_irq(OSS_IRQLEV_IOPSCC, mac_scc_dispatch, IRQ_FLG_LOCK,
+			"scc", mac_scc_dispatch))
+		pr_err("Couldn't register %s interrupt\n", "scc");
+	if (request_irq(OSS_IRQLEV_NUBUS, oss_nubus_irq, IRQ_FLG_LOCK,
+			"nubus", (void *) oss))
+		pr_err("Couldn't register %s interrupt\n", "nubus");
+	if (request_irq(OSS_IRQLEV_SOUND, oss_irq, IRQ_FLG_LOCK,
+			"sound", (void *) oss))
+		pr_err("Couldn't register %s interrupt\n", "sound");
+	if (request_irq(OSS_IRQLEV_VIA1, via1_irq, IRQ_FLG_LOCK,
+			"via1", (void *) via1))
+		pr_err("Couldn't register %s interrupt\n", "via1");
 }
 
 /*
diff --git a/arch/m68k/mac/psc.c b/arch/m68k/mac/psc.c
index f84a4dd..ba6ccab 100644
--- a/arch/m68k/mac/psc.c
+++ b/arch/m68k/mac/psc.c
@@ -117,10 +117,14 @@ void __init psc_init(void)
 
 void __init psc_register_interrupts(void)
 {
-	request_irq(IRQ_AUTO_3, psc_irq, 0, "psc3", (void *) 0x30);
-	request_irq(IRQ_AUTO_4, psc_irq, 0, "psc4", (void *) 0x40);
-	request_irq(IRQ_AUTO_5, psc_irq, 0, "psc5", (void *) 0x50);
-	request_irq(IRQ_AUTO_6, psc_irq, 0, "psc6", (void *) 0x60);
+	if (request_irq(IRQ_AUTO_3, psc_irq, 0, "psc3", (void *) 0x30))
+		pr_err("Couldn't register psc%d interrupt\n", 3);
+	if (request_irq(IRQ_AUTO_4, psc_irq, 0, "psc4", (void *) 0x40))
+		pr_err("Couldn't register psc%d interrupt\n", 4);
+	if (request_irq(IRQ_AUTO_5, psc_irq, 0, "psc5", (void *) 0x50))
+		pr_err("Couldn't register psc%d interrupt\n", 5);
+	if (request_irq(IRQ_AUTO_6, psc_irq, 0, "psc6", (void *) 0x60))
+		pr_err("Couldn't register psc%d interrupt\n", 6);
 }
 
 /*
diff --git a/arch/m68k/mac/via.c b/arch/m68k/mac/via.c
index 796c822..11bce3c 100644
--- a/arch/m68k/mac/via.c
+++ b/arch/m68k/mac/via.c
@@ -283,7 +283,8 @@ void __init via_init_clock(irq_handler_t func)
 	via1[vT1CL] = MAC_CLOCK_LOW;
 	via1[vT1CH] = MAC_CLOCK_HIGH;
 
-	request_irq(IRQ_MAC_TIMER_1, func, IRQ_FLG_LOCK, "timer", func);
+	if (request_irq(IRQ_MAC_TIMER_1, func, IRQ_FLG_LOCK, "timer", func))
+		pr_err("Couldn't register %s interrupt\n", "timer");
 }
 
 /*
@@ -293,25 +294,31 @@ void __init via_init_clock(irq_handler_t func)
 void __init via_register_interrupts(void)
 {
 	if (via_alt_mapping) {
-		request_irq(IRQ_AUTO_1, via1_irq,
+		if (request_irq(IRQ_AUTO_1, via1_irq,
 				IRQ_FLG_LOCK|IRQ_FLG_FAST, "software",
-				(void *) via1);
-		request_irq(IRQ_AUTO_6, via1_irq,
+				(void *) via1))
+			pr_err("Couldn't register %s interrupt\n", "software");
+		if (request_irq(IRQ_AUTO_6, via1_irq,
 				IRQ_FLG_LOCK|IRQ_FLG_FAST, "via1",
-				(void *) via1);
+				(void *) via1))
+			pr_err("Couldn't register %s interrupt\n", "via1");
 	} else {
-		request_irq(IRQ_AUTO_1, via1_irq,
+		if (request_irq(IRQ_AUTO_1, via1_irq,
 				IRQ_FLG_LOCK|IRQ_FLG_FAST, "via1",
-				(void *) via1);
+				(void *) via1))
+			pr_err("Couldn't register %s interrupt\n", "via1");
 	}
-	request_irq(IRQ_AUTO_2, via2_irq, IRQ_FLG_LOCK|IRQ_FLG_FAST,
-			"via2", (void *) via2);
+	if (request_irq(IRQ_AUTO_2, via2_irq, IRQ_FLG_LOCK|IRQ_FLG_FAST,
+			"via2", (void *) via2))
+		pr_err("Couldn't register %s interrupt\n", "via2");
 	if (!psc_present) {
-		request_irq(IRQ_AUTO_4, mac_scc_dispatch, IRQ_FLG_LOCK,
-				"scc", mac_scc_dispatch);
+		if (request_irq(IRQ_AUTO_4, mac_scc_dispatch, IRQ_FLG_LOCK,
+				"scc", mac_scc_dispatch))
+			pr_err("Couldn't register %s interrupt\n", "scc");
 	}
-	request_irq(IRQ_MAC_NUBUS, via_nubus_irq, IRQ_FLG_LOCK|IRQ_FLG_FAST,
-			"nubus", (void *) via2);
+	if (request_irq(IRQ_MAC_NUBUS, via_nubus_irq,
+			IRQ_FLG_LOCK|IRQ_FLG_FAST, "nubus", (void *) via2))
+		pr_err("Couldn't register %s interrupt\n", "nubus");
 }
 
 /*
-- 
1.5.6.5

