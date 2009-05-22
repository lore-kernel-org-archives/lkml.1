Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbZEVMO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbZEVMO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbZEVMNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:13:20 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:11973 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332AbZEVMNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:13:17 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j)
X-FB-SS: 5,
X-WSS-ID: 0KK1OLI-04-9W1-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/7] amd-iommu: print ivmd information to dmesg when requested
Date: Fri, 22 May 2009 14:12:46 +0200
Message-ID: <1242994369-28697-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994369-28697-1-git-send-email-joerg.roedel@amd.com>
References: <1242994369-28697-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:12:49.0886 (UTC) FILETIME=[9FFE27E0:01C9DAD6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: be able to show in dmesg whats in the acpi ivmd fields ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index fe3e645..b90a78c 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -983,6 +983,7 @@ static int __init init_exclusion_range(struct ivmd_header *m)
 static int __init init_unity_map_range(struct ivmd_header *m)
 {
 	struct unity_map_entry *e = 0;
+	char *s;
 
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
 	if (e == NULL)
@@ -991,13 +992,16 @@ static int __init init_unity_map_range(struct ivmd_header *m)
 	switch (m->type) {
 	default:
 	case ACPI_IVMD_TYPE:
+		s = "IVMD_TYPEi\t\t\t";
 		e->devid_start = e->devid_end = m->devid;
 		break;
 	case ACPI_IVMD_TYPE_ALL:
+		s = "IVMD_TYPE_ALL\t\t";
 		e->devid_start = 0;
 		e->devid_end = amd_iommu_last_bdf;
 		break;
 	case ACPI_IVMD_TYPE_RANGE:
+		s = "IVMD_TYPE_RANGE\t\t";
 		e->devid_start = m->devid;
 		e->devid_end = m->aux;
 		break;
@@ -1006,6 +1010,13 @@ static int __init init_unity_map_range(struct ivmd_header *m)
 	e->address_end = e->address_start + PAGE_ALIGN(m->range_length);
 	e->prot = m->flags >> 1;
 
+	DUMP_printk("%s devid_start: %02x:%02x.%x devid_end: %02x:%02x.%x"
+		    " range_start: %016llx range_end: %016llx flags: %x\n", s,
+		    PCI_BUS(e->devid_start), PCI_SLOT(e->devid_start),
+		    PCI_FUNC(e->devid_start), PCI_BUS(e->devid_end),
+		    PCI_SLOT(e->devid_end), PCI_FUNC(e->devid_end),
+		    e->address_start, e->address_end, m->flags);
+
 	list_add_tail(&e->list, &amd_iommu_unity_map);
 
 	return 0;
-- 
1.6.3.1


