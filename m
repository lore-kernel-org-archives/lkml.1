Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbYKMTk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbYKMTk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbYKMTeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:21 -0500
Received: from gw.goop.org ([64.81.55.164]:34408 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbYKMTeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:08 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 14 of 38] x86: add mp_find_ioapic_pin
X-Mercurial-Node: b386d2e473d5ed98c5dcc87388c6dd01c67ec8e3
Message-Id: <b386d2e473d5ed98c5dc.1226603412@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:12 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
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
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -64,6 +64,7 @@
 extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 				u32 gsi, int triggering, int polarity);
 extern int mp_find_ioapic(int gsi);
+extern int mp_find_ioapic_pin(int ioapic, int gsi);
 #else
 static inline int
 mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -880,6 +880,16 @@
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
@@ -992,7 +1002,7 @@
 	ioapic = mp_find_ioapic(gsi);
 	if (ioapic < 0)
 		return;
-	pin = gsi - mp_ioapic_routing[ioapic].gsi_base;
+	pin = mp_find_ioapic_pin(ioapic, gsi);
 
 	/*
 	 * TBD: This check is for faulty timer entries, where the override
@@ -1114,7 +1124,7 @@
 		return gsi;
 	}
 
-	ioapic_pin = gsi - mp_ioapic_routing[ioapic].gsi_base;
+	ioapic_pin = mp_find_ioapic_pin(ioapic, gsi);
 
 #ifdef CONFIG_X86_32
 	if (ioapic_renumber_irq)
@@ -1203,7 +1213,7 @@
 	mp_irq.mp_srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
 	ioapic = mp_find_ioapic(gsi);
 	mp_irq.mp_dstapic = mp_ioapic_routing[ioapic].apic_id;
-	mp_irq.mp_dstirq = gsi - mp_ioapic_routing[ioapic].gsi_base;
+	mp_irq.mp_dstirq = mp_find_ioapic_pin(ioapic, gsi);
 
 	save_mp_irq(&mp_irq);
 #endif


