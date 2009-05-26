Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbZEZVsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbZEZVsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZEZVsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:48:07 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:48814 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZEZVsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:48:06 -0400
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: x86@kernel.org
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com
Message-Id: <20090416014230.4885.94926.sendpatchset@localhost.localdomain>
Subject: [PATCH] x86: print real IOAPIC version for x86-64
Date: Tue, 26 May 2009 21:48:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the fact that the IOAPIC version number in the x86_64 code path always
gets assigned to 0, instead of the correct value.

Before the patch: (from "dmesg" output):
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23     <---

After the patch:
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23    <---

History:
io_apic_get_version() was compiled out of the x86_64 code path in the commit
f2c2cca3acef8b253a36381d9b469ad4fb08563a:

*************************
Author: Andi Kleen <ak@suse.de>
Date:   Tue Sep 26 10:52:37 2006 +0200

    [PATCH] Remove APIC version/cpu capability mpparse checking/printing

    ACPI went to great trouble to get the APIC version and CPU capabilities
    of different CPUs before passing them to the mpparser. But all
    that data was used was to print it out.  Actually it even faked some data
    based on the boot cpu, not on the actual CPU being booted.

    Remove all this code because it's not needed.

    Cc: len.brown@intel.com

    Signed-off-by: Andi Kleen <ak@suse.de>
*************************

At the time, the IOAPIC version number was deliberately not printed in the
x86_64 code path. However, after the x86 and x86_64 files were merged, the net
result is that the IOAPIC version is printed incorrectly in the x86_64 code
path.

The patch below provides a fix. I have tested it with acpi, and with acpi=off,
and did not see any problems.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com> 
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/acpi/boot.c    |    5 +----
 arch/x86/kernel/apic/io_apic.c |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 723989d..ad88b1b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -986,11 +986,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
 	mp_ioapics[idx].apicid = uniq_ioapic_id(id);
-#ifdef CONFIG_X86_32
 	mp_ioapics[idx].apicver = io_apic_get_version(idx);
-#else
-	mp_ioapics[idx].apicver = 0;
-#endif
+
 	/*
 	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 30da617..c2bc2eb 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3980,6 +3980,7 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 
 	return apic_id;
 }
+#endif
 
 int __init io_apic_get_version(int ioapic)
 {
@@ -3992,7 +3993,6 @@ int __init io_apic_get_version(int ioapic)
 
 	return reg_01.bits.version;
 }
-#endif
 
 int io_apic_set_pci_routing (int ioapic, int pin, int irq, int triggering, int polarity)
 {
-- 
1.6.2.2

