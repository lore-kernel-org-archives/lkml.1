Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbYDENwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbYDENwl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 09:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYDENvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 09:51:05 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:37199 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbYDENvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 09:51:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=rkZPV1hEP4ekp2ajitf/CyBCrRoi/4lhbI3kDm79ZrMmdNJPvoe10AQON5c0I+r/im30pYKhK95vnvSEc/rLn59YBWyfw8Yr7/abbHFl2GWe6O/6kn+i+u4yKKJIcDmVswGEP1M9CMpOU7gcvnRfIZdEKXtVq9lTPxHB9nyFEqg=
References: <20080405133903.770639386@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 05 Apr 2008 22:39:12 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 9/9] x86: use bitmap library for pin_programmed
Content-Disposition: inline; filename=x86-mpparse-use-bitmap.patch
Message-ID: <47f783c4.1aad7e0a.12c1.24dc@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use bitmap library for pin_programmed rather than reinvent
bitmaps.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/mpparse_32.c |   15 ++++++---------
 arch/x86/kernel/mpparse_64.c |   16 +++++++---------
 2 files changed, 13 insertions(+), 18 deletions(-)

Index: 2.6-git/arch/x86/kernel/mpparse_64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/mpparse_64.c
+++ 2.6-git/arch/x86/kernel/mpparse_64.c
@@ -21,6 +21,7 @@
 #include <linux/mc146818rtc.h>
 #include <linux/acpi.h>
 #include <linux/module.h>
+#include <linux/bitmap.h>
 
 #include <asm/smp.h>
 #include <asm/mtrr.h>
@@ -643,7 +644,7 @@ static struct mp_ioapic_routing {
 	int			apic_id;
 	int			gsi_start;
 	int			gsi_end;
-	u32			pin_programmed[4];
+	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } mp_ioapic_routing[MAX_IO_APICS];
 
 static int mp_find_ioapic(int gsi)
@@ -802,9 +803,8 @@ void __init mp_config_acpi_legacy_irqs(v
 
 int mp_register_gsi(u32 gsi, int triggering, int polarity)
 {
-	int ioapic = -1;
-	int ioapic_pin = 0;
-	int idx, bit = 0;
+	int ioapic;
+	int ioapic_pin;
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
@@ -826,21 +826,19 @@ int mp_register_gsi(u32 gsi, int trigger
 	 * with redundant pin->gsi mappings (but unique PCI devices);
 	 * we only program the IOAPIC on the first.
 	 */
-	bit = ioapic_pin % 32;
-	idx = (ioapic_pin < 32) ? 0 : (ioapic_pin / 32);
-	if (idx > 3) {
+	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
 		printk(KERN_ERR "Invalid reference to IOAPIC pin "
 			"%d-%d\n", mp_ioapic_routing[ioapic].apic_id, 
 			ioapic_pin);
 		return gsi;
 	}
-	if ((1<<bit) & mp_ioapic_routing[ioapic].pin_programmed[idx]) {
+	if (test_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed)) {
 		Dprintk(KERN_DEBUG "Pin %d-%d already programmed\n",
 			mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
 		return gsi;
 	}
 
-	mp_ioapic_routing[ioapic].pin_programmed[idx] |= (1<<bit);
+	set_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed);
 
 	io_apic_set_pci_routing(ioapic, ioapic_pin, gsi,
 		triggering == ACPI_EDGE_SENSITIVE ? 0 : 1,
Index: 2.6-git/arch/x86/kernel/mpparse_32.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/mpparse_32.c
+++ 2.6-git/arch/x86/kernel/mpparse_32.c
@@ -859,7 +859,7 @@ static struct mp_ioapic_routing {
 	int			apic_id;
 	int			gsi_base;
 	int			gsi_end;
-	u32			pin_programmed[4];
+	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 } mp_ioapic_routing[MAX_IO_APICS];
 
 static int mp_find_ioapic (int gsi)
@@ -1031,9 +1031,8 @@ void __init mp_config_acpi_legacy_irqs (
 
 int mp_register_gsi(u32 gsi, int triggering, int polarity)
 {
-	int ioapic = -1;
-	int ioapic_pin = 0;
-	int idx, bit = 0;
+	int ioapic;
+	int ioapic_pin;
 	static int pci_irq = IRQ_COMPRESSION_START;
 	/*
 	 * Mapping between Global System Interrupts, which
@@ -1062,21 +1061,19 @@ int mp_register_gsi(u32 gsi, int trigger
 	 * with redundant pin->gsi mappings (but unique PCI devices);
 	 * we only program the IOAPIC on the first.
 	 */
-	bit = ioapic_pin % 32;
-	idx = (ioapic_pin < 32) ? 0 : (ioapic_pin / 32);
-	if (idx > 3) {
+	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
 		printk(KERN_ERR "Invalid reference to IOAPIC pin "
 			"%d-%d\n", mp_ioapic_routing[ioapic].apic_id, 
 			ioapic_pin);
 		return gsi;
 	}
-	if ((1<<bit) & mp_ioapic_routing[ioapic].pin_programmed[idx]) {
+	if (test_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed)) {
 		Dprintk(KERN_DEBUG "Pin %d-%d already programmed\n",
 			mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
 		return (gsi < IRQ_COMPRESSION_START ? gsi : gsi_to_irq[gsi]);
 	}
 
-	mp_ioapic_routing[ioapic].pin_programmed[idx] |= (1<<bit);
+	set_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed);
 
 	/*
 	 * For GSI >= 64, use IRQ compression

-- 
