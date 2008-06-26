Return-Path: <linux-kernel-owner+w=401wt.eu-S1763258AbYFZTm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763258AbYFZTm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761568AbYFZT3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:43 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:34412 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761522AbYFZT3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:41 -0400
X-BigFish: VPS9(ze98mzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K334QX-04-UN5-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 05/34] AMD IOMMU: add functions to find last possible PCI device for IOMMU
Date: Thu, 26 Jun 2008 21:27:41 +0200
Message-ID: <1214508490-29683-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0527 (UTC) FILETIME=[C562C170:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds functions to find the last PCI bus/device/function the IOMMU
driver has to handle. This information is used later to allocate the memory for
the data structures.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   79 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 0ad8cf9..ee0b2da 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -116,3 +116,82 @@ unsigned long *amd_iommu_pd_alloc_bitmap;
 static u32 dev_table_size;
 static u32 alias_table_size;
 static u32 rlookup_table_size;
+
+static int __init find_last_devid_on_pci(int bus, int dev, int fn, int cap_ptr)
+{
+	u32 cap;
+
+	cap = read_pci_config(bus, dev, fn, cap_ptr+MMIO_RANGE_OFFSET);
+	UPDATE_LAST_BDF(DEVID(MMIO_GET_BUS(cap), MMIO_GET_LD(cap)));
+
+	return 0;
+}
+
+static int __init find_last_devid_from_ivhd(struct ivhd_header *h)
+{
+	u8 *p = (void *)h, *end = (void *)h;
+	struct ivhd_entry *dev;
+
+	p += sizeof(*h);
+	end += h->length;
+
+	find_last_devid_on_pci(PCI_BUS(h->devid),
+			PCI_SLOT(h->devid),
+			PCI_FUNC(h->devid),
+			h->cap_ptr);
+
+	while (p < end) {
+		dev = (struct ivhd_entry *)p;
+		switch (dev->type) {
+		case IVHD_DEV_SELECT:
+		case IVHD_DEV_RANGE_END:
+		case IVHD_DEV_ALIAS:
+		case IVHD_DEV_EXT_SELECT:
+			UPDATE_LAST_BDF(dev->devid);
+			break;
+		default:
+			break;
+		}
+		p += 0x04 << (*p >> 6);
+	}
+
+	WARN_ON(p != end);
+
+	return 0;
+}
+
+static int __init find_last_devid_acpi(struct acpi_table_header *table)
+{
+	int i;
+	u8 checksum = 0, *p = (u8 *)table, *end = (u8 *)table;
+	struct ivhd_header *h;
+
+	/*
+	 * Validate checksum here so we don't need to do it when
+	 * we actually parse the table
+	 */
+	for (i = 0; i < table->length; ++i)
+		checksum += p[i];
+	if (checksum != 0)
+		/* ACPI table corrupt */
+		return -ENODEV;
+
+	p += IVRS_HEADER_LENGTH;
+
+	end += table->length;
+	while (p < end) {
+		h = (struct ivhd_header *)p;
+		switch (h->type) {
+		case ACPI_IVHD_TYPE:
+			find_last_devid_from_ivhd(h);
+			break;
+		default:
+			break;
+		}
+		p += h->length;
+	}
+	WARN_ON(p != end);
+
+	return 0;
+}
+
-- 
1.5.3.7


