Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbZBIJFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbZBIJFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZBIJFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:05:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:59951 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbZBIJFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:05:01 -0500
Message-ID: <498FF175.9010204@kernel.org>
Date: Mon, 09 Feb 2009 01:03:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: find nr_irqs_gsi with mp_ioapic_routing v3
References: <498CCEDB.8050708@kernel.org> <20090209081350.GC24420@elte.hu>
In-Reply-To: <20090209081350.GC24420@elte.hu>
Content-Type: text/plain; charset=us-ascii
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

v2: Ingo pointed out inline acpi_probe_gsi() should be with !CONFIG_ACPI

v3: against current upstream for 2.6.29, because it is 2.6.29 material

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/mpspec.h |    6 ++++++
 arch/x86/kernel/acpi/boot.c   |   23 +++++++++++++++++++++++
 arch/x86/kernel/io_apic.c     |   20 +++++++++++++++-----
 3 files changed, 44 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -60,6 +60,7 @@ extern void mp_override_legacy_irq(u8 bu
 				   u32 gsi);
 extern void mp_config_acpi_legacy_irqs(void);
 extern int mp_register_gsi(u32 gsi, int edge_level, int active_high_low);
+extern int acpi_probe_gsi(void);
 #ifdef CONFIG_X86_IO_APIC
 extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 				u32 gsi, int triggering, int polarity);
@@ -71,6 +72,11 @@ mp_config_acpi_gsi(unsigned char number,
 	return 0;
 }
 #endif
+#else /* !CONFIG_ACPI */
+static inline int acpi_probe_gsi(void)
+{
+	return 0;
+}
 #endif /* CONFIG_ACPI */
 
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -3841,14 +3841,24 @@ int __init io_apic_get_redir_entries (in
 
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
 
 /* --------------------------------------------------------------------------
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -973,6 +973,29 @@ void __init mp_register_ioapic(int id, u
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
 static void assign_to_mp_irq(struct mp_config_intsrc *m,
 				    struct mp_config_intsrc *mp_irq)
 {
