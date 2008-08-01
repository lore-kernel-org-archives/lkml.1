Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbYHAJmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbYHAJmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757701AbYHAJix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:38:53 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:14084 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbYHAJiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q6Gu8qkRB4m/BPlY+zJ/tBYCnelIGBL6ZDxtG+QpLV6fU9NGX6e7MSjP+wBKYKmqTG
         3xPfVEhrAQaq/ImgThT25wswligJKKOzL1N0/nyRdM57HJVa7sHhyOObYUqhmoEppcBk
         4q2RKoTe6J2vflk5hfr/z6Y640adJwgX3aZA4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 14/16] x86: get mp_irqs from madt
Date: Fri,  1 Aug 2008 02:37:42 -0700
Message-Id: <1217583464-28494-15-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217583464-28494-14-git-send-email-yhlu.kernel@gmail.com>
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-2-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-3-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-4-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-5-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-6-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-7-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-8-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-9-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-10-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-11-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-12-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-13-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-14-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/acpi/boot.c |   30 ++++++++++++++++++++++++++++--
 include/asm-x86/mpspec.h    |    1 +
 2 files changed, 29 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -962,6 +962,29 @@ void __init mp_register_ioapic(int id, u
 	nr_ioapics++;
 }
 
+int get_nr_irqs_via_madt(void)
+{
+	int idx;
+	int nr = 0;
+
+	for (idx = 0; idx < nr_ioapics; idx ++) {
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
@@ -1259,9 +1282,12 @@ static int __init acpi_parse_madt_ioapic
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
@@ -1281,7 +1307,7 @@ static int __init acpi_parse_madt_ioapic
 
 	count =
 	    acpi_table_parse_madt(ACPI_MADT_TYPE_NMI_SOURCE, acpi_parse_nmi_src,
-				  NR_IRQ_VECTORS);
+				  nr_irqs);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX "Error parsing NMI SRC entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
Index: linux-2.6/include/asm-x86/mpspec.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mpspec.h
+++ linux-2.6/include/asm-x86/mpspec.h
@@ -59,6 +59,7 @@ extern void mp_override_legacy_irq(u8 bu
 				   u32 gsi);
 extern void mp_config_acpi_legacy_irqs(void);
 extern int mp_register_gsi(u32 gsi, int edge_level, int active_high_low);
+extern int get_nr_irqs_via_madt(void);
 #ifdef CONFIG_X86_IO_APIC
 extern int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 				u32 gsi, int triggering, int polarity);
