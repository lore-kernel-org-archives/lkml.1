Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbYJVL37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbYJVL37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYJVL3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:29:51 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:20145 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbYJVL3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:29:50 -0400
X-BigFish: VPS-5(z34a4jz14c3M3b49Kzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K95196-02-HLL-01
Date: Wed, 22 Oct 2008 13:28:58 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: call dmi-quirks for HP Laptops after early-quirks are
	executed
Message-ID: <20081022112858.GE13400@alberich.amd.com>
References: <20081016105706.GC29183@alberich.amd.com> <20081022100253.GB29744@elte.hu> <20081022100924.GC13400@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081022100924.GC13400@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 22 Oct 2008 11:29:32.0906 (UTC) FILETIME=[747F74A0:01C93439]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problems with bogus IRQ0 override of those laptops should be fixed
with commits

x86: SB600: skip IRQ0 override if it is not routed to INT2 of IOAPIC
x86: SB450: skip IRQ0 override if it is not routed to INT2 of IOAPIC

that introduce early-quirks based on chipset configuration.

For further information, see
http://bugzilla.kernel.org/show_bug.cgi?id=11516

Instead of removing the related dmi-quirks completely we'd like to
keep them for (at least) one kernel version -- to double-check whether
the early-quirks really took effect. But the dmi-quirks need to be
called after early-quirks are executed. With this patch calling
sequence for dmi-quirks is changed as follows:

 acpi_boot_table_init()   (dmi-quirks)
 ...
 early_quirks()           (detect bogus IRQ0 override)
 ...
 acpi_boot_init()         (late dmi-quirks and setup IO APIC)

Note: Plan is to remove the "late dmi-quirks" with next kernel version.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

---
 arch/x86/kernel/acpi/boot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 0d1c26a..3e822bc 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1598,6 +1598,11 @@ static struct dmi_system_id __initdata acpi_dmi_table[] = {
 		     DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 360"),
 		     },
 	 },
+	{}
+};
+
+/* second table for DMI checks that should run after early-quirks */
+static struct dmi_system_id __initdata acpi_dmi_table_late[] = {
 	/*
 	 * HP laptops which use a DSDT reporting as HP/SB400/10000,
 	 * which includes some code which overrides all temperature
@@ -1726,6 +1731,9 @@ int __init early_acpi_boot_init(void)
 
 int __init acpi_boot_init(void)
 {
+        /* those are executed after early-quirks are executed */
+	dmi_check_system(acpi_dmi_table_late);
+
 	/*
 	 * If acpi_disabled, bail out
 	 * One exception: acpi=ht continues far enough to enumerate LAPICs
-- 
1.6.0.2



