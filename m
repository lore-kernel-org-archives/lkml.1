Return-Path: <linux-kernel-owner+w=401wt.eu-S1762206AbYDSPH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762206AbYDSPH0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762379AbYDSPGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:06:47 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:11425 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762367AbYDSPGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:06:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=HcY+1ejMdryd61nOFkArd1Ooke+XUYOiLe5gDZd+hIDc7tKRlUxf5QBIHhsiCSEvHKpiZrX5auAMih1XRpLPdMCFn3lT02BqPQCD6bo1AG06fj0xeZ55j7EGfNFjjmznnftbghhZvN5Hs2C7sI9d6blKXXT3JQwtYTpJPaaCPw4=
References: <20080419145510.150338641@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 19 Apr 2008 23:55:13 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 03/10] x86: use bitmap library for pin_programmed
Content-Disposition: inline; filename=x86-mpparse-use-bitmap.patch
Message-ID: <480a0a81.15528c0a.59b6.3d5b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use bitmap library for pin_programmed rather than reinvent
bitmaps.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/mpparse.c |   14 +++++---------
 include/asm-x86/io_apic.h |    6 ++++--
 2 files changed, 9 insertions(+), 11 deletions(-)

Index: 2.6-git/arch/x86/kernel/mpparse.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/mpparse.c
+++ 2.6-git/arch/x86/kernel/mpparse.c
@@ -799,7 +799,6 @@ void __init find_smp_config(void)
 #ifdef	CONFIG_X86_IO_APIC
 
 #define MP_ISA_BUS		0
-#define MP_MAX_IOAPIC_PIN	127
 
 extern struct mp_ioapic_routing mp_ioapic_routing[MAX_IO_APICS];
 
@@ -982,9 +981,8 @@ void __init mp_config_acpi_legacy_irqs(v
 
 int mp_register_gsi(u32 gsi, int triggering, int polarity)
 {
-	int ioapic = -1;
-	int ioapic_pin = 0;
-	int idx, bit = 0;
+	int ioapic;
+	int ioapic_pin;
 #ifdef CONFIG_X86_32
 #define MAX_GSI_NUM	4096
 #define IRQ_COMPRESSION_START	64
@@ -1024,15 +1022,13 @@ int mp_register_gsi(u32 gsi, int trigger
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
-	if ((1 << bit) & mp_ioapic_routing[ioapic].pin_programmed[idx]) {
+	if (test_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed)) {
 		Dprintk(KERN_DEBUG "Pin %d-%d already programmed\n",
 			mp_ioapic_routing[ioapic].apic_id, ioapic_pin);
 #ifdef CONFIG_X86_32
@@ -1042,7 +1038,7 @@ int mp_register_gsi(u32 gsi, int trigger
 #endif
 	}
 
-	mp_ioapic_routing[ioapic].pin_programmed[idx] |= (1 << bit);
+	set_bit(ioapic_pin, mp_ioapic_routing[ioapic].pin_programmed);
 #ifdef CONFIG_X86_32
 	/*
 	 * For GSI >= 64, use IRQ compression
Index: 2.6-git/include/asm-x86/io_apic.h
===================================================================
--- 2.6-git.orig/include/asm-x86/io_apic.h
+++ 2.6-git/include/asm-x86/io_apic.h
@@ -1,7 +1,7 @@
 #ifndef __ASM_IO_APIC_H
 #define __ASM_IO_APIC_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 
@@ -110,11 +110,13 @@ extern int nr_ioapic_registers[MAX_IO_AP
  * MP-BIOS irq configuration table structures:
  */
 
+#define MP_MAX_IOAPIC_PIN 127
+
 struct mp_ioapic_routing {
 	int apic_id;
 	int gsi_base;
 	int gsi_end;
-	u32 pin_programmed[4];
+	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
 };
 
 /* I/O APIC entries */

-- 
