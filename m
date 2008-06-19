Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbYFSA24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbYFSA24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbYFSA2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:28:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:48029 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452AbYFSA2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:28:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=VpWHUef6tbI2wAtWSzUoxbyrssTnT8WpxANOuceNGcqtsr9WQYHurTIjObrVw1VqUx
         764Hj97TH3a/+43ZdVmepsI8ucTIffVylaLKS+VK6eZG1jWVc7pbSn4+4mQiF3qK9t4D
         bWqWpx03GcBmFiExmk418M9FMSzsajPaFLJTY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>, Len Brown <lenb@kernel.org>
Subject: [PATCH] x86: update mptable fix with no ioapic v2
Date: Wed, 18 Jun 2008 17:29:31 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200806011317.38622.yhlu.kernel@gmail.com> <200806181432.57204.yhlu.kernel@gmail.com>
In-Reply-To: <200806181432.57204.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806181729.31464.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


if the system doesn't have ioapic, we don't need to store entries for mptable
update

also let mp_config_acpi_gsi not call func in mpparse
so later could decouple mpparse with acpi more easily

Reported-by: Daniel Exner <dex@dragonslave.de>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/acpi/boot.c |   87 ++++++++++++++++++++++++++++----------------
 arch/x86/kernel/mpparse.c   |   19 ++++-----
 include/asm-x86/mpspec.h    |    2 -
 3 files changed, 65 insertions(+), 43 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -958,10 +958,37 @@ void __init mp_register_ioapic(int id, u
 	nr_ioapics++;
 }
 
+static void assign_to_mp_irq(struct mp_config_intsrc *m,
+				    struct mp_config_intsrc *mp_irq)
+{
+	memcpy(mp_irq, m, sizeof(struct mp_config_intsrc));
+}
+
+static int mp_irq_cmp(struct mp_config_intsrc *mp_irq,
+				struct mp_config_intsrc *m)
+{
+	return memcmp(mp_irq, m, sizeof(struct mp_config_intsrc));
+}
+
+static void save_mp_irq(struct mp_config_intsrc *m)
+{
+	int i;
+
+	for (i = 0; i < mp_irq_entries; i++) {
+		if (!mp_irq_cmp(&mp_irqs[i], m))
+			return;
+	}
+
+	assign_to_mp_irq(m, &mp_irqs[mp_irq_entries]);
+	if (++mp_irq_entries == MAX_IRQ_SOURCES)
+		panic("Max # of irq sources exceeded!!\n");
+}
+
 void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 {
 	int ioapic;
 	int pin;
+	struct mp_config_intsrc mp_irq;
 
 	/*
 	 * Convert 'gsi' to 'ioapic.pin'.
@@ -979,18 +1006,15 @@ void __init mp_override_legacy_irq(u8 bu
 	if ((bus_irq == 0) && (trigger == 3))
 		trigger = 1;
 
-	mp_irqs[mp_irq_entries].mp_type = MP_INTSRC;
-	mp_irqs[mp_irq_entries].mp_irqtype = mp_INT;
-	mp_irqs[mp_irq_entries].mp_irqflag = (trigger << 2) | polarity;
-	mp_irqs[mp_irq_entries].mp_srcbus = MP_ISA_BUS;
-	mp_irqs[mp_irq_entries].mp_srcbusirq = bus_irq;	/* IRQ */
-	mp_irqs[mp_irq_entries].mp_dstapic =
-			mp_ioapics[ioapic].mp_apicid;	/* APIC ID */
-	mp_irqs[mp_irq_entries].mp_dstirq = pin;	/* INTIN# */
-
-	if (++mp_irq_entries == MAX_IRQ_SOURCES)
-		panic("Max # of irq sources exceeded!!\n");
+	mp_irq.mp_type = MP_INTSRC;
+	mp_irq.mp_irqtype = mp_INT;
+	mp_irq.mp_irqflag = (trigger << 2) | polarity;
+	mp_irq.mp_srcbus = MP_ISA_BUS;
+	mp_irq.mp_srcbusirq = bus_irq;	/* IRQ */
+	mp_irq.mp_dstapic = mp_ioapics[ioapic].mp_apicid; /* APIC ID */
+	mp_irq.mp_dstirq = pin;	/* INTIN# */
 
+	save_mp_irq(&mp_irq);
 }
 
 void __init mp_config_acpi_legacy_irqs(void)
@@ -998,6 +1022,7 @@ void __init mp_config_acpi_legacy_irqs(v
 	int i;
 	int ioapic;
 	unsigned int dstapic;
+	struct mp_config_intsrc mp_irq;
 
 #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
 	/*
@@ -1050,16 +1075,15 @@ void __init mp_config_acpi_legacy_irqs(v
 			continue;	/* IRQ already used */
 		}
 
-		mp_irqs[mp_irq_entries].mp_type = MP_INTSRC;
-		mp_irqs[mp_irq_entries].mp_irqflag = 0;	/* Conforming */
-		mp_irqs[mp_irq_entries].mp_srcbus = MP_ISA_BUS;
-		mp_irqs[mp_irq_entries].mp_dstapic = dstapic;
-		mp_irqs[mp_irq_entries].mp_irqtype = mp_INT;
-		mp_irqs[mp_irq_entries].mp_srcbusirq = i; /* Identity mapped */
-		mp_irqs[mp_irq_entries].mp_dstirq = i;
+		mp_irq.mp_type = MP_INTSRC;
+		mp_irq.mp_irqflag = 0;	/* Conforming */
+		mp_irq.mp_srcbus = MP_ISA_BUS;
+		mp_irq.mp_dstapic = dstapic;
+		mp_irq.mp_irqtype = mp_INT;
+		mp_irq.mp_srcbusirq = i; /* Identity mapped */
+		mp_irq.mp_dstirq = i;
 
-		if (++mp_irq_entries == MAX_IRQ_SOURCES)
-			panic("Max # of irq sources exceeded!!\n");
+		save_mp_irq(&mp_irq);
 	}
 }
 
@@ -1167,25 +1191,26 @@ int mp_register_gsi(u32 gsi, int trigger
 int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 			u32 gsi, int triggering, int polarity)
 {
-	struct mpc_config_intsrc intsrc;
+#ifdef CONFIG_X86_MPPARSE
+	struct mp_config_intsrc mp_irq;
 	int ioapic;
 
-	if (!enable_update_mptable)
+	if (!acpi_ioapic)
 		return 0;
 
 	/* print the entry should happen on mptable identically */
-	intsrc.mpc_type = MP_INTSRC;
-	intsrc.mpc_irqtype = mp_INT;
-	intsrc.mpc_irqflag = (triggering == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
+	mp_irq.mp_type = MP_INTSRC;
+	mp_irq.mp_irqtype = mp_INT;
+	mp_irq.mp_irqflag = (triggering == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
 				(polarity == ACPI_ACTIVE_HIGH ? 1 : 3);
-	intsrc.mpc_srcbus = number;
-	intsrc.mpc_srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
+	mp_irq.mp_srcbus = number;
+	mp_irq.mp_srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
 	ioapic = mp_find_ioapic(gsi);
-	intsrc.mpc_dstapic = mp_ioapic_routing[ioapic].apic_id;
-	intsrc.mpc_dstirq = gsi - mp_ioapic_routing[ioapic].gsi_base;
-
-	MP_intsrc_info(&intsrc);
+	mp_irq.mp_dstapic = mp_ioapic_routing[ioapic].apic_id;
+	mp_irq.mp_dstirq = gsi - mp_ioapic_routing[ioapic].gsi_base;
 
+	save_mp_irq(&mp_irq);
+#endif
 	return 0;
 }
 
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -34,8 +34,6 @@
 #include <mach_mpparse.h>
 #endif
 
-int enable_update_mptable;
-
 /*
  * Checksum an MP configuration block.
  */
@@ -246,7 +244,7 @@ static void __init print_mp_irq_info(str
 		mp_irq->mp_srcbusirq, mp_irq->mp_dstapic, mp_irq->mp_dstirq);
 }
 
-static void assign_to_mp_irq(struct mpc_config_intsrc *m,
+static void __init assign_to_mp_irq(struct mpc_config_intsrc *m,
 				    struct mp_config_intsrc *mp_irq)
 {
 	mp_irq->mp_dstapic = m->mpc_dstapic;
@@ -270,7 +268,7 @@ static void __init assign_to_mpc_intsrc(
 	m->mpc_dstirq = mp_irq->mp_dstirq;
 }
 
-static int mp_irq_mpc_intsrc_cmp(struct mp_config_intsrc *mp_irq,
+static int __init mp_irq_mpc_intsrc_cmp(struct mp_config_intsrc *mp_irq,
 					struct mpc_config_intsrc *m)
 {
 	if (mp_irq->mp_dstapic != m->mpc_dstapic)
@@ -291,17 +289,16 @@ static int mp_irq_mpc_intsrc_cmp(struct 
 	return 0;
 }
 
-void MP_intsrc_info(struct mpc_config_intsrc *m)
+static void __init MP_intsrc_info(struct mpc_config_intsrc *m)
 {
 	int i;
 
 	print_MP_intsrc_info(m);
 
-	if (enable_update_mptable)
-		for (i = 0; i < mp_irq_entries; i++) {
-			if (!mp_irq_mpc_intsrc_cmp(&mp_irqs[i], m))
-				return;
-		}
+	for (i = 0; i < mp_irq_entries; i++) {
+		if (!mp_irq_mpc_intsrc_cmp(&mp_irqs[i], m))
+			return;
+	}
 
 	assign_to_mp_irq(m, &mp_irqs[mp_irq_entries]);
 	if (++mp_irq_entries == MAX_IRQ_SOURCES)
@@ -1113,6 +1110,8 @@ out:
 	return 0;
 }
 
+static int __initdata enable_update_mptable;
+
 static int __init update_mptable_setup(char *str)
 {
 	enable_update_mptable = 1;
Index: linux-2.6/include/asm-x86/mpspec.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mpspec.h
+++ linux-2.6/include/asm-x86/mpspec.h
@@ -59,9 +59,7 @@ extern void mp_override_legacy_irq(u8 bu
 				   u32 gsi);
 extern void mp_config_acpi_legacy_irqs(void);
 extern int mp_register_gsi(u32 gsi, int edge_level, int active_high_low);
-extern void MP_intsrc_info(struct mpc_config_intsrc *m);
 #ifdef CONFIG_X86_IO_APIC
-extern int enable_update_mptable;
 extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 				u32 gsi, int triggering, int polarity);
 #else
