Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbZJ2Que@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbZJ2Que (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbZJ2Que
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:50:34 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:1294 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbZJ2Quc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:50:32 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KSAC40-04-FK3-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 1/4] x86/amd-iommu: Workaround for erratum 63
Date: Thu, 29 Oct 2009 17:50:09 +0100
Message-ID: <1256835012-31410-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1256835012-31410-1-git-send-email-joerg.roedel@amd.com>
References: <1256835012-31410-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 29 Oct 2009 16:50:17.0668 (UTC) FILETIME=[E4F01840:01CA58B7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an erratum for IOMMU hardware which documents
undefined behavior when forwarding SMI requests from
peripherals and the DTE of that peripheral has a sysmgt
value of 01b. This problem caused weird IO_PAGE_FAULTS in my
case.
This patch implements the suggested workaround for that
erratum into the AMD IOMMU driver.  The erratum is
documented with number 63.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu.h |    1 +
 arch/x86/kernel/amd_iommu.c      |    2 ++
 arch/x86/kernel/amd_iommu_init.c |   22 ++++++++++++++++++++++
 3 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index bdf96f1..9dbd403 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -30,6 +30,7 @@ extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
 extern void amd_iommu_flush_all_domains(void);
 extern void amd_iommu_flush_all_devices(void);
 extern void amd_iommu_shutdown(void);
+extern void amd_iommu_apply_erratum_63(u16 devid);
 #else
 static inline int amd_iommu_init(void) { return -ENODEV; }
 static inline void amd_iommu_detect(void) { }
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 6c99f50..f95dfe5 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1114,6 +1114,8 @@ static void __detach_device(struct protection_domain *domain, u16 devid)
 	amd_iommu_dev_table[devid].data[1] = 0;
 	amd_iommu_dev_table[devid].data[2] = 0;
 
+	amd_iommu_apply_erratum_63(devid);
+
 	/* decrease reference counter */
 	domain->dev_cnt -= 1;
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index c1b17e9..498c8c7 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -509,6 +509,26 @@ static void set_dev_entry_bit(u16 devid, u8 bit)
 	amd_iommu_dev_table[devid].data[i] |= (1 << _bit);
 }
 
+static int get_dev_entry_bit(u16 devid, u8 bit)
+{
+	int i = (bit >> 5) & 0x07;
+	int _bit = bit & 0x1f;
+
+	return (amd_iommu_dev_table[devid].data[i] & (1 << _bit)) >> _bit;
+}
+
+
+void amd_iommu_apply_erratum_63(u16 devid)
+{
+	int sysmgt;
+
+	sysmgt = get_dev_entry_bit(devid, DEV_ENTRY_SYSMGT1) |
+		 (get_dev_entry_bit(devid, DEV_ENTRY_SYSMGT2) << 1);
+
+	if (sysmgt == 0x01)
+		set_dev_entry_bit(devid, DEV_ENTRY_IW);
+}
+
 /* Writes the specific IOMMU for a device into the rlookup table */
 static void __init set_iommu_for_device(struct amd_iommu *iommu, u16 devid)
 {
@@ -537,6 +557,8 @@ static void __init set_dev_entry_from_acpi(struct amd_iommu *iommu,
 	if (flags & ACPI_DEVFLAG_LINT1)
 		set_dev_entry_bit(devid, DEV_ENTRY_LINT1_PASS);
 
+	amd_iommu_apply_erratum_63(devid);
+
 	set_iommu_for_device(iommu, devid);
 }
 
-- 
1.6.5


