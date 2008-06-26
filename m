Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbYFZTby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbYFZTby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760595AbYFZT2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:28:39 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:24842 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760479AbYFZT2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:28:37 -0400
X-BigFish: VPS3(zz10d1Izz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K334QX-04-UN9-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/34] AMD IOMMU: clue initialization code together
Date: Thu, 26 Jun 2008 21:27:50 +0200
Message-ID: <1214508490-29683-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0752 (UTC) FILETIME=[C5851680:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch puts the AMD IOMMU ACPI table parsing and hardware initialization
functions together to the main intialization routine.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |  126 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 126 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 555fcc9..c792ddc 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -643,3 +643,129 @@ static int __init init_memory_definitions(struct acpi_table_header *table)
 	return 0;
 }
 
+int __init amd_iommu_init(void)
+{
+	int i, ret = 0;
+
+
+	if (amd_iommu_disable) {
+		printk(KERN_INFO "AMD IOMMU disabled by kernel command line\n");
+		return 0;
+	}
+
+	/*
+	 * First parse ACPI tables to find the largest Bus/Dev/Func
+	 * we need to handle. Upon this information the shared data
+	 * structures for the IOMMUs in the system will be allocated
+	 */
+	if (acpi_table_parse("IVRS", find_last_devid_acpi) != 0)
+		return -ENODEV;
+
+	dev_table_size     = TBL_SIZE(DEV_TABLE_ENTRY_SIZE);
+	alias_table_size   = TBL_SIZE(ALIAS_TABLE_ENTRY_SIZE);
+	rlookup_table_size = TBL_SIZE(RLOOKUP_TABLE_ENTRY_SIZE);
+
+	ret = -ENOMEM;
+
+	/* Device table - directly used by all IOMMUs */
+	amd_iommu_dev_table = (void *)__get_free_pages(GFP_KERNEL,
+				      get_order(dev_table_size));
+	if (amd_iommu_dev_table == NULL)
+		goto out;
+
+	/*
+	 * Alias table - map PCI Bus/Dev/Func to Bus/Dev/Func the
+	 * IOMMU see for that device
+	 */
+	amd_iommu_alias_table = (void *)__get_free_pages(GFP_KERNEL,
+			get_order(alias_table_size));
+	if (amd_iommu_alias_table == NULL)
+		goto free;
+
+	/* IOMMU rlookup table - find the IOMMU for a specific device */
+	amd_iommu_rlookup_table = (void *)__get_free_pages(GFP_KERNEL,
+			get_order(rlookup_table_size));
+	if (amd_iommu_rlookup_table == NULL)
+		goto free;
+
+	/*
+	 * Protection Domain table - maps devices to protection domains
+	 * This table has the same size as the rlookup_table
+	 */
+	amd_iommu_pd_table = (void *)__get_free_pages(GFP_KERNEL,
+				     get_order(rlookup_table_size));
+	if (amd_iommu_pd_table == NULL)
+		goto free;
+
+	amd_iommu_pd_alloc_bitmap = (void *)__get_free_pages(GFP_KERNEL,
+					    get_order(MAX_DOMAIN_ID/8));
+	if (amd_iommu_pd_alloc_bitmap == NULL)
+		goto free;
+
+	/*
+	 * memory is allocated now; initialize the device table with all zeroes
+	 * and let all alias entries point to itself
+	 */
+	memset(amd_iommu_dev_table, 0, dev_table_size);
+	for (i = 0; i < amd_iommu_last_bdf; ++i)
+		amd_iommu_alias_table[i] = i;
+
+	memset(amd_iommu_pd_table, 0, rlookup_table_size);
+	memset(amd_iommu_pd_alloc_bitmap, 0, MAX_DOMAIN_ID / 8);
+
+	/*
+	 * never allocate domain 0 because its used as the non-allocated and
+	 * error value placeholder
+	 */
+	amd_iommu_pd_alloc_bitmap[0] = 1;
+
+	/*
+	 * now the data structures are allocated and basically initialized
+	 * start the real acpi table scan
+	 */
+	ret = -ENODEV;
+	if (acpi_table_parse("IVRS", init_iommu_all) != 0)
+		goto free;
+
+	if (acpi_table_parse("IVRS", init_memory_definitions) != 0)
+		goto free;
+
+	printk(KERN_INFO "AMD IOMMU: aperture size is %d MB\n",
+			(1 << (amd_iommu_aperture_order-20)));
+
+	printk(KERN_INFO "AMD IOMMU: device isolation ");
+	if (amd_iommu_isolate)
+		printk("enabled\n");
+	else
+		printk("disabled\n");
+
+out:
+	return ret;
+
+free:
+	if (amd_iommu_pd_alloc_bitmap)
+		free_pages((unsigned long)amd_iommu_pd_alloc_bitmap, 1);
+
+	if (amd_iommu_pd_table)
+		free_pages((unsigned long)amd_iommu_pd_table,
+				get_order(rlookup_table_size));
+
+	if (amd_iommu_rlookup_table)
+		free_pages((unsigned long)amd_iommu_rlookup_table,
+				get_order(rlookup_table_size));
+
+	if (amd_iommu_alias_table)
+		free_pages((unsigned long)amd_iommu_alias_table,
+				get_order(alias_table_size));
+
+	if (amd_iommu_dev_table)
+		free_pages((unsigned long)amd_iommu_dev_table,
+				get_order(dev_table_size));
+
+	free_iommu_all();
+
+	free_unity_maps();
+
+	goto out;
+}
+
-- 
1.5.3.7


