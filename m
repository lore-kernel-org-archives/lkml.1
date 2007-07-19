Return-Path: <linux-kernel-owner+w=401wt.eu-S965036AbXGSOEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965036AbXGSOEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762622AbXGSNtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:49:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764923AbXGSNtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:49:04 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: adurbin@google.com, johnstul@us.ibm.com, tglx@linutronix.de, ak@suse.de,
       lenb@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [32/48] i386: insert HPET firmware resource after PCI enumeration has completed
Message-Id: <20070719134902.94CA814E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:49:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Aaron Durbin <adurbin@google.com>

Insert HPET resources after pci probing has been completed in order to
avoid resource conflicts with PCI resource reservation.  With this change
the HPET firmware resources will be identified, but it should also not
cause issues when the HPET address falls on a BAR in a PCI device, and the
PCI enumeration cannot reserve the resources.

Signed-off-by: Aaron Durbin <adurbin@google.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/boot.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

Index: linux/arch/i386/kernel/acpi/boot.c
===================================================================
--- linux.orig/arch/i386/kernel/acpi/boot.c
+++ linux/arch/i386/kernel/acpi/boot.c
@@ -618,6 +618,8 @@ static int __init acpi_parse_sbf(struct 
 #ifdef CONFIG_HPET_TIMER
 #include <asm/hpet.h>
 
+static struct __initdata resource *hpet_res;
+
 static int __init acpi_parse_hpet(struct acpi_table_header *table)
 {
 	struct acpi_table_hpet *hpet_tbl;
@@ -638,8 +640,42 @@ static int __init acpi_parse_hpet(struct
 	printk(KERN_INFO PREFIX "HPET id: %#x base: %#lx\n",
 	       hpet_tbl->id, hpet_address);
 
+	/*
+	 * Allocate and initialize the HPET firmware resource for adding into
+	 * the resource tree during the lateinit timeframe.
+	 */
+#define HPET_RESOURCE_NAME_SIZE 9
+	hpet_res = alloc_bootmem(sizeof(*hpet_res) + HPET_RESOURCE_NAME_SIZE);
+
+	if (!hpet_res)
+		return 0;
+
+	memset(hpet_res, 0, sizeof(*hpet_res));
+	hpet_res->name = (void *)&hpet_res[1];
+	hpet_res->flags = IORESOURCE_MEM;
+	snprintf((char *)hpet_res->name, HPET_RESOURCE_NAME_SIZE, "HPET %u",
+		 hpet_tbl->sequence);
+
+	hpet_res->start = hpet_address;
+	hpet_res->end = hpet_address + (1 * 1024) - 1;
+
 	return 0;
 }
+
+/*
+ * hpet_insert_resource inserts the HPET resources used into the resource
+ * tree.
+ */
+static __init int hpet_insert_resource(void)
+{
+	if (!hpet_res)
+		return 1;
+
+	return insert_resource(&iomem_resource, hpet_res);
+}
+
+late_initcall(hpet_insert_resource);
+
 #else
 #define	acpi_parse_hpet	NULL
 #endif
