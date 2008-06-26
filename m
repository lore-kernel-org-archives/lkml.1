Return-Path: <linux-kernel-owner+w=401wt.eu-S932245AbYFZTik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbYFZTik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760364AbYFZT3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:17 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:27710 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760590AbYFZT3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:12 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K334RT-04-UOE-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/34] AMD IOMMU: add device table initialization functions
Date: Thu, 26 Jun 2008 21:27:46 +0200
Message-ID: <1214508490-29683-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0627 (UTC) FILETIME=[C57203B0:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds functions necessary to initialize the device table from the
ACPI definitions.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   45 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index c2be3ad..4c37abb 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -308,3 +308,48 @@ static void __init free_command_buffer(struct amd_iommu *iommu)
 				get_order(CMD_BUFFER_SIZE));
 }
 
+static void set_dev_entry_bit(u16 devid, u8 bit)
+{
+	int i = (bit >> 5) & 0x07;
+	int _bit = bit & 0x1f;
+
+	amd_iommu_dev_table[devid].data[i] |= (1 << _bit);
+}
+
+static void __init set_dev_entry_from_acpi(u16 devid, u32 flags, u32 ext_flags)
+{
+	if (flags & ACPI_DEVFLAG_INITPASS)
+		set_dev_entry_bit(devid, DEV_ENTRY_INIT_PASS);
+	if (flags & ACPI_DEVFLAG_EXTINT)
+		set_dev_entry_bit(devid, DEV_ENTRY_EINT_PASS);
+	if (flags & ACPI_DEVFLAG_NMI)
+		set_dev_entry_bit(devid, DEV_ENTRY_NMI_PASS);
+	if (flags & ACPI_DEVFLAG_SYSMGT1)
+		set_dev_entry_bit(devid, DEV_ENTRY_SYSMGT1);
+	if (flags & ACPI_DEVFLAG_SYSMGT2)
+		set_dev_entry_bit(devid, DEV_ENTRY_SYSMGT2);
+	if (flags & ACPI_DEVFLAG_LINT0)
+		set_dev_entry_bit(devid, DEV_ENTRY_LINT0_PASS);
+	if (flags & ACPI_DEVFLAG_LINT1)
+		set_dev_entry_bit(devid, DEV_ENTRY_LINT1_PASS);
+}
+
+static void __init set_iommu_for_device(struct amd_iommu *iommu, u16 devid)
+{
+	amd_iommu_rlookup_table[devid] = iommu;
+}
+
+static void __init set_device_exclusion_range(u16 devid, struct ivmd_header *m)
+{
+	struct amd_iommu *iommu = amd_iommu_rlookup_table[devid];
+
+	if (!(m->flags & IVMD_FLAG_EXCL_RANGE))
+		return;
+
+	if (iommu) {
+		set_dev_entry_bit(m->devid, DEV_ENTRY_EX);
+		iommu->exclusion_start = m->range_start;
+		iommu->exclusion_length = m->range_length;
+	}
+}
+
-- 
1.5.3.7


