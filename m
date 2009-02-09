Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZBJUIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZBJUIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZBJUH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:07:28 -0500
Received: from gw.goop.org ([64.81.55.164]:50711 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991AbZBJUH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:07:27 -0500
Message-Id: <c3e137d1e882c4fab9adcce7ae2be9bf3eb64c4c.1234296039.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234296039.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234296039.git.jeremy.fitzhardinge@citrix.com>
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Mon, 9 Feb 2009 12:05:47 -0800
Subject: [PATCH] x86: add mp_find_ioapic_pin
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mp_find_ioapic_pin() to find an IO APIC's specific pin from a GSI,
and use this function within acpi/boot.  Make it non-static so other
code can use it too.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/mpspec.h |    1 +
 arch/x86/kernel/acpi/boot.c   |   16 +++++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index b59371a..5916c8d 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -78,6 +78,7 @@ extern int acpi_probe_gsi(void);
 extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 				u32 gsi, int triggering, int polarity);
 extern int mp_find_ioapic(int gsi);
+extern int mp_find_ioapic_pin(int ioapic, int gsi);
 #else
 static inline int
 mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 068b900..bba162c 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -887,6 +887,16 @@ int mp_find_ioapic(int gsi)
 	return -1;
 }
 
+int mp_find_ioapic_pin(int ioapic, int gsi)
+{
+	if (WARN_ON(ioapic == -1))
+		return -1;
+	if (WARN_ON(gsi > mp_ioapic_routing[ioapic].gsi_end))
+		return -1;
+
+	return gsi - mp_ioapic_routing[ioapic].gsi_base;
+}
+
 static u8 __init uniq_ioapic_id(u8 id)
 {
 #ifdef CONFIG_X86_32
@@ -1022,7 +1032,7 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	ioapic = mp_find_ioapic(gsi);
 	if (ioapic < 0)
 		return;
-	pin = gsi - mp_ioapic_routing[ioapic].gsi_base;
+	pin = mp_find_ioapic_pin(ioapic, gsi);
 
 	/*
 	 * TBD: This check is for faulty timer entries, where the override
@@ -1142,7 +1152,7 @@ int mp_register_gsi(u32 gsi, int triggering, int polarity)
 		return gsi;
 	}
 
-	ioapic_pin = gsi - mp_ioapic_routing[ioapic].gsi_base;
+	ioapic_pin = mp_find_ioapic_pin(ioapic, gsi);
 
 #ifdef CONFIG_X86_32
 	if (ioapic_renumber_irq)
@@ -1231,7 +1241,7 @@ int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
 	ioapic = mp_find_ioapic(gsi);
 	mp_irq.dstapic = mp_ioapic_routing[ioapic].apic_id;
-	mp_irq.dstirq = gsi - mp_ioapic_routing[ioapic].gsi_base;
+	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
 
 	save_mp_irq(&mp_irq);
 #endif
-- 
1.6.0.6


