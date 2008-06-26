Return-Path: <linux-kernel-owner+w=401wt.eu-S1762475AbYFZTdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762475AbYFZTdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760790AbYFZT2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:28:48 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:30758 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777AbYFZT2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:28:47 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K334QX-04-UNA-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/34] AMD IOMMU: add functions to parse IOMMU memory mapping requirements for devices
Date: Thu, 26 Jun 2008 21:27:49 +0200
Message-ID: <1214508490-29683-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0715 (UTC) FILETIME=[C57F7130:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the functions to parse the information about IOMMU exclusion
ranges and required unity mappings for the devices handled by the IOMMU.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   87 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 3f4f7b8..555fcc9 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -556,3 +556,90 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 	return 0;
 }
 
+static void __init free_unity_maps(void)
+{
+	struct unity_map_entry *entry, *next;
+
+	list_for_each_entry_safe(entry, next, &amd_iommu_unity_map, list) {
+		list_del(&entry->list);
+		kfree(entry);
+	}
+}
+
+static int __init init_exclusion_range(struct ivmd_header *m)
+{
+	int i;
+
+	switch (m->type) {
+	case ACPI_IVMD_TYPE:
+		set_device_exclusion_range(m->devid, m);
+		break;
+	case ACPI_IVMD_TYPE_ALL:
+		for (i = 0; i < amd_iommu_last_bdf; ++i)
+			set_device_exclusion_range(i, m);
+		break;
+	case ACPI_IVMD_TYPE_RANGE:
+		for (i = m->devid; i <= m->aux; ++i)
+			set_device_exclusion_range(i, m);
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int __init init_unity_map_range(struct ivmd_header *m)
+{
+	struct unity_map_entry *e = 0;
+
+	e = kzalloc(sizeof(*e), GFP_KERNEL);
+	if (e == NULL)
+		return -ENOMEM;
+
+	switch (m->type) {
+	default:
+	case ACPI_IVMD_TYPE:
+		e->devid_start = e->devid_end = m->devid;
+		break;
+	case ACPI_IVMD_TYPE_ALL:
+		e->devid_start = 0;
+		e->devid_end = amd_iommu_last_bdf;
+		break;
+	case ACPI_IVMD_TYPE_RANGE:
+		e->devid_start = m->devid;
+		e->devid_end = m->aux;
+		break;
+	}
+	e->address_start = PAGE_ALIGN(m->range_start);
+	e->address_end = e->address_start + PAGE_ALIGN(m->range_length);
+	e->prot = m->flags >> 1;
+
+	list_add_tail(&e->list, &amd_iommu_unity_map);
+
+	return 0;
+}
+
+static int __init init_memory_definitions(struct acpi_table_header *table)
+{
+	u8 *p = (u8 *)table, *end = (u8 *)table;
+	struct ivmd_header *m;
+
+	INIT_LIST_HEAD(&amd_iommu_unity_map);
+
+	end += table->length;
+	p += IVRS_HEADER_LENGTH;
+
+	while (p < end) {
+		m = (struct ivmd_header *)p;
+		if (m->flags & IVMD_FLAG_EXCL_RANGE)
+			init_exclusion_range(m);
+		else if (m->flags & IVMD_FLAG_UNITY_MAP)
+			init_unity_map_range(m);
+
+		p += m->length;
+	}
+
+	return 0;
+}
+
-- 
1.5.3.7


