Return-Path: <linux-kernel-owner+w=401wt.eu-S932438AbZFLDF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbZFLDF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbZFLDFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:05:19 -0400
Received: from sous-sol.org ([216.99.217.87]:43039 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbZFLDFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:05:18 -0400
Date: Thu, 11 Jun 2009 20:05:11 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] amd-iommu: initialization fixes
Message-ID: <20090612030511.GS20823@sequoia.sous-sol.org>
References: <20090612030341.GQ20823@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612030341.GQ20823@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the kernel in initialized w/out coming out of reset (e.g. kexec/kdump), the
prior kernel may leave the IOMMU running.  Here's some fixes just to
ensure all initialization is done in a sane manner.  

1) disable IOMMU when discovered, will get renabled after it's set up
2) disable event log handling while setting up the event log buffer.
   the spec says:
      Software Note: If EventLen or EventBase is changed while the
      EventLogRun=1, the IOMMU behavior is undefined.
3) ensure the head/tail event log buffer pointers are initialized to zero

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kernel/amd_iommu_init.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -252,6 +252,11 @@ static void __init iommu_enable(struct a
 	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
 }
 
+static void __init iommu_disable(struct amd_iommu *iommu)
+{
+	iommu_feature_disable(iommu, CONTROL_IOMMU_EN);
+}
+
 /* Function to enable IOMMU event logging and event interrupts */
 static void __init iommu_enable_event_logging(struct amd_iommu *iommu)
 {
@@ -259,6 +264,12 @@ static void __init iommu_enable_event_lo
 	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
 }
 
+static void __init iommu_disable_event_logging(struct amd_iommu *iommu)
+{
+	iommu_feature_disable(iommu, CONTROL_EVT_INT_EN);
+	iommu_feature_disable(iommu, CONTROL_EVT_LOG_EN);
+}
+
 /*
  * mapping and unmapping functions for the IOMMU MMIO space. Each AMD IOMMU in
  * the system has one.
@@ -453,12 +464,19 @@ static u8 * __init alloc_event_buffer(st
 	if (iommu->evt_buf == NULL)
 		return NULL;
 
+	/* disable event logging while setting it up */
+	iommu_disable_event_logging(iommu);
+
 	entry = (u64)virt_to_phys(iommu->evt_buf) | EVT_LEN_MASK;
 	memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
 		    &entry, sizeof(entry));
 
 	iommu->evt_buf_size = EVT_BUFFER_SIZE;
 
+	/* set head and tail to zero manually */
+	writel(0x00, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
+	writel(0x00, iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
+
 	return iommu->evt_buf;
 }
 
@@ -713,6 +731,9 @@ static int __init init_iommu_one(struct 
 	if (!iommu->mmio_base)
 		return -ENOMEM;
 
+	/* disable IOMMU in case it was left on */
+	iommu_disable(iommu);
+
 	iommu_set_device_table(iommu);
 	iommu->cmd_buf = alloc_command_buffer(iommu);
 	if (!iommu->cmd_buf)
