Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbZBGAAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbZBGAAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 19:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZBGAAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 19:00:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:45869 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbZBGAAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 19:00:04 -0500
Message-ID: <498CCEDB.8050708@kernel.org>
Date: Fri, 06 Feb 2009 15:59:23 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: find nr_irqs_gsi with mp_ioapic_routing
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: find right nr_irqs_gsi on some systems.

one system has gap between gsi.
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfeafd000] gsi_base[48])
[    0.000000] IOAPIC[1]: apic_id 5, version 0, address 0xfeafd000, GSI 48-54
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfeafc000] gsi_base[56])
[    0.000000] IOAPIC[2]: apic_id 6, version 0, address 0xfeafc000, GSI 56-62
...
[    0.000000] nr_irqs_gsi: 38

so nr_irqs_gsi is not right. some irq for MSI will overwrite with io_apic.

need to get that with acpi_probe_gsi when acpi io_apic is used

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/mpspec.h |    5 +++++
 arch/x86/kernel/acpi/boot.c   |   23 +++++++++++++++++++++++
 arch/x86/kernel/io_apic.c     |   20 +++++++++++++++-----
 3 files changed, 43 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -73,6 +73,7 @@ extern void mp_override_legacy_irq(u8 bu
 				   u32 gsi);
 extern void mp_config_acpi_legacy_irqs(void);
 extern int mp_register_gsi(u32 gsi, int edge_level, int active_high_low);
+extern int acpi_probe_gsi(void);
 #ifdef CONFIG_X86_IO_APIC
 extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 				u32 gsi, int triggering, int polarity);
@@ -83,6 +84,10 @@ mp_config_acpi_gsi(unsigned char number,
 {
 	return 0;
 }
+static inline int acpi_probe_gsi(void)
+{
+	return 0;
+}
 #endif
 #endif /* CONFIG_ACPI */
 
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -944,6 +944,29 @@ void __init mp_register_ioapic(int id, u
 	nr_ioapics++;
 }
 
+int __init acpi_probe_gsi(void)
+{
+	int idx;
+	int gsi;
+	int max_gsi = 0;
+
+	if (acpi_disabled)
+		return 0;
+
+	if (!acpi_ioapic)
+		return 0;
+
+	max_gsi = 0;
+	for (idx = 0; idx < nr_ioapics; idx++) {
+		gsi = mp_ioapic_routing[idx].gsi_end;
+
+		if (gsi > max_gsi)
+			max_gsi = gsi;
+	}
+
+	return max_gsi + 1;
+}
+
 static void assign_to_mp_irq(struct mpc_intsrc *m,
 				    struct mpc_intsrc *mp_irq)
 {
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -3810,14 +3810,24 @@ int __init io_apic_get_redir_entries (in
 
 void __init probe_nr_irqs_gsi(void)
 {
-	int idx;
 	int nr = 0;
 
-	for (idx = 0; idx < nr_ioapics; idx++)
-		nr += io_apic_get_redir_entries(idx) + 1;
-
-	if (nr > nr_irqs_gsi)
+	nr = acpi_probe_gsi();
+	if (nr > nr_irqs_gsi) {
 		nr_irqs_gsi = nr;
+	} else {
+		/* for acpi=off or acpi is not compiled in */
+		int idx;
+
+		nr = 0;
+		for (idx = 0; idx < nr_ioapics; idx++)
+			nr += io_apic_get_redir_entries(idx) + 1;
+
+		if (nr > nr_irqs_gsi)
+			nr_irqs_gsi = nr;
+	}
+
+	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
 }
 
 #ifdef CONFIG_SPARSE_IRQ
