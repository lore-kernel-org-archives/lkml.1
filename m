Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbYHCDIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbYHCDIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 23:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbYHCDBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 23:01:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:10980 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbYHCDBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 23:01:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=whA0kZ1WBS/hRgnHB1nPkgQi2/PpdnUpg+rtM56LGNB0/7jofU1Tx4Qp3TeqSKQdau
         CeWvHtwZtHXHrA5b3TmR5oXs73MZvkKXN4swXaq9cTCIVNmEnwKL1IRJL09kIo5wUp/6
         jkTiz1phVVnl2PxjGjhBHxczHFpMnHQR/RBcI=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 24/25] x86: get mp_irqs from madt
Date: Sat,  2 Aug 2008 19:59:24 -0700
Message-Id: <1217732365-16595-25-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217732365-16595-24-git-send-email-yhlu.kernel@gmail.com>
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-2-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-3-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-4-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-5-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-6-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-7-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-8-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-9-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-10-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-11-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-12-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-13-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-14-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-15-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-16-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-17-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-18-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-19-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-20-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-21-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-22-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-23-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-24-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/acpi/boot.c |   30 ++++++++++++++++++++++++++++--
 include/asm-x86/mpspec.h    |    1 +
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 27ef365..443cb30 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -962,6 +962,29 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 	nr_ioapics++;
 }
 
+int get_nr_irqs_via_madt(void)
+{
+	int idx;
+	int nr = 0;
+
+	for (idx = 0; idx < nr_ioapics; idx++) {
+		if (mp_ioapic_routing[idx].gsi_end > nr)
+			nr = mp_ioapic_routing[idx].gsi_end;
+	}
+
+	nr++;
+
+	/* double it for hotplug and msi and nmi */
+	nr <<= 1;
+
+	/* something wrong ? */
+	if (nr < 32)
+		nr = 32;
+
+	return nr;
+
+}
+
 static void assign_to_mp_irq(struct mp_config_intsrc *m,
 				    struct mp_config_intsrc *mp_irq)
 {
@@ -1259,9 +1282,12 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 		return count;
 	}
 
+
+	nr_irqs = get_nr_irqs_via_madt();
+
 	count =
 	    acpi_table_parse_madt(ACPI_MADT_TYPE_INTERRUPT_OVERRIDE, acpi_parse_int_src_ovr,
-				  NR_IRQ_VECTORS);
+				  nr_irqs);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX
 		       "Error parsing interrupt source overrides entry\n");
@@ -1281,7 +1307,7 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 
 	count =
 	    acpi_table_parse_madt(ACPI_MADT_TYPE_NMI_SOURCE, acpi_parse_nmi_src,
-				  NR_IRQ_VECTORS);
+				  nr_irqs);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX "Error parsing NMI SRC entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
diff --git a/include/asm-x86/mpspec.h b/include/asm-x86/mpspec.h
index 118da36..5daa0f4 100644
--- a/include/asm-x86/mpspec.h
+++ b/include/asm-x86/mpspec.h
@@ -59,6 +59,7 @@ extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 				   u32 gsi);
 extern void mp_config_acpi_legacy_irqs(void);
 extern int mp_register_gsi(u32 gsi, int edge_level, int active_high_low);
+extern int get_nr_irqs_via_madt(void);
 #ifdef CONFIG_X86_IO_APIC
 extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 				u32 gsi, int triggering, int polarity);
-- 
1.5.4.5

