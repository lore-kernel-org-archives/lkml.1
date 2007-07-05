Return-Path: <linux-kernel-owner+w=401wt.eu-S1763195AbXGEW1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763195AbXGEW1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761424AbXGEW1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:27:45 -0400
Received: from smtp-out.google.com ([216.239.45.13]:42030 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761651AbXGEW1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:27:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent;
	b=yu25oJAEkcI5e5Fq98FKoz+LbxA7mcm551snSq2v3rp+S3tC5T/TFZydCBTfJysoC
	oAdcuBenlBKzRkCxjmihQ==
Date: Thu, 5 Jul 2007 15:27:24 -0700
From: Aaron Durbin <adurbin@google.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@osdl.org, matthias.lenk@amd.com
Subject: [PATCH] i386/x86_64: Insert HPET firmware resource after PCI enumeration has completed
Message-ID: <20070705222724.GA12537@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Insert HPET resources after pci probing has been completed in order to avoid
resource conflicts with PCI resource reservation. With this change the
HPET firmware resources will be identified, but it should also not cause
issues when the HPET address falls on a BAR in a PCI device, and the PCI
enumeration cannot reserve the resources.

Signed-off-by: Aaron Durbin <adurbin@google.com>

---
 arch/i386/kernel/acpi/boot.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/i386/kernel/acpi/boot.c b/arch/i386/kernel/acpi/boot.c
index a574cd2..ca12b84 100644
--- a/arch/i386/kernel/acpi/boot.c
+++ b/arch/i386/kernel/acpi/boot.c
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
-- 
1.4.1

