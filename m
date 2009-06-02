Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbZFBANT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbZFBANT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 20:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbZFBANJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 20:13:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:46443 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbZFBANH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 20:13:07 -0400
Date: Tue, 2 Jun 2009 00:12:30 GMT
From: tip-bot for Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yhlu.kernel@gmail.com, nagananda.chumbalkar@hp.com, tglx@linutronix.de,
       ak@suse.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yhlu.kernel@gmail.com, nagananda.chumbalkar@hp.com, tglx@linutronix.de,
       ak@suse.de, mingo@elte.hu
In-Reply-To: <20090416014230.4885.94926.sendpatchset@localhost.localdomain>
References: <20090416014230.4885.94926.sendpatchset@localhost.localdomain>
Subject: [tip:irq/numa] x86: Print real IOAPIC version for x86-64
Message-ID: <tip-58f892e022e88438183c48661dcdc6a2997dab99@git.kernel.org>
Git-Commit-ID: 58f892e022e88438183c48661dcdc6a2997dab99
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 00:12:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58f892e022e88438183c48661dcdc6a2997dab99
Gitweb:     http://git.kernel.org/tip/58f892e022e88438183c48661dcdc6a2997dab99
Author:     Naga Chumbalkar <nagananda.chumbalkar@hp.com>
AuthorDate: Tue, 26 May 2009 21:48:07 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 02:03:18 +0200

x86: Print real IOAPIC version for x86-64

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

Author: Andi Kleen <ak@suse.de>
Date:   Tue Sep 26 10:52:37 2006 +0200

    [PATCH] Remove APIC version/cpu capability mpparse checking/printing

    ACPI went to great trouble to get the APIC version and CPU capabilities
    of different CPUs before passing them to the mpparser. But all
    that data was used was to print it out.  Actually it even faked some data
    based on the boot cpu, not on the actual CPU being booted.

    Remove all this code because it's not needed.

    Cc: len.brown@intel.com

At the time, the IOAPIC version number was deliberately not printed
in the x86_64 code path. However, after the x86 and x86_64 files were
merged, the net result is that the IOAPIC version is printed incorrectly
in the x86_64 code path.

The patch below provides a fix. I have tested it with acpi, and with
acpi=off, and did not see any problems.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>
LKML-Reference: <20090416014230.4885.94926.sendpatchset@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
*************************


---
 arch/x86/kernel/acpi/boot.c    |    5 +----
 arch/x86/kernel/apic/io_apic.c |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 844e5e2..6310861 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -985,11 +985,8 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
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
index ac7f3b6..f712f8f 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4012,6 +4012,7 @@ int __init io_apic_get_unique_id(int ioapic, int apic_id)
 
 	return apic_id;
 }
+#endif
 
 int __init io_apic_get_version(int ioapic)
 {
@@ -4024,7 +4025,6 @@ int __init io_apic_get_version(int ioapic)
 
 	return reg_01.bits.version;
 }
-#endif
 
 int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 {
