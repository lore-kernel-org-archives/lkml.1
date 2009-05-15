Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbZEOTyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbZEOTyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbZEOTx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:53:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:40451 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbZEOTxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:53:55 -0400
Message-ID: <4A0DC832.5090200@kernel.org>
Date: Fri, 15 May 2009 12:53:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [PATCH] x86/acpi: don't call mp_config_acpi_gsi if update_mptable
 is not used
References: <4A0DC7DC.7000204@kernel.org>
In-Reply-To: <4A0DC7DC.7000204@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Len doesn't want mp code is called from acpi code.

[ Impact: less touch code flow for acpi code ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/mpspec.h |    1 +
 arch/x86/kernel/acpi/boot.c   |    4 +++-
 arch/x86/kernel/mpparse.c     |    2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -72,6 +72,7 @@ extern void mp_register_ioapic(int id, u
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 				   u32 gsi);
 extern void mp_config_acpi_legacy_irqs(void);
+extern int enable_update_mptable;
 struct device;
 extern int mp_register_gsi(struct device *dev, u32 gsi, int edge_level,
 				 int active_high_low);
Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -1226,7 +1226,9 @@ int mp_register_gsi(struct device *dev,
 		       ioapic_pin);
 		return gsi;
 	}
-	mp_config_acpi_gsi(dev, gsi, trigger, polarity);
+
+	if (enable_update_mptable)
+		mp_config_acpi_gsi(dev, gsi, trigger, polarity);
 
 	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
 			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -957,7 +957,7 @@ out:
 	return 0;
 }
 
-static int __initdata enable_update_mptable;
+int enable_update_mptable;
 
 static int __init update_mptable_setup(char *str)
 {
