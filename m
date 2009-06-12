Return-Path: <linux-kernel-owner+w=401wt.eu-S932473AbZFLDE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbZFLDE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbZFLDEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:04:22 -0400
Received: from sous-sol.org ([216.99.217.87]:43035 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756222AbZFLDEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:04:22 -0400
Date: Thu, 11 Jun 2009 20:04:14 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] amd-iommu: fix issues with kdump
Message-ID: <20090612030414.GR20823@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612030341.GQ20823@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kexec'ing to a new kernel (for example, when crashing and launching a
kdump session), the AMD IOMMU may have cached translations.  The kexec'd
kernel, during initialization, will invalidate the IOMMU device table
entries, but not the domain translations.  These stale entries can cause
a device's DMA to fail, makes it rough to write a dump to disk when the
disk controller can't DMA ;-)  Just invalidating the iommu pages should
be enough, however the old kernel left the IOMMU enabled and running.
In particular, the command buffer doesn't seem to work properly after
it's been updated while active.  Unlike the event log buffer which is
documented to have undefined behaviour when updated while enabled,
the documentation doesn't specify for the command buffer.  However,
disabling the command buffer before updating the IOMMU w/ new command
buffer and re-enabling is sufficient to ensure future commands are picked
up an processed properly, especially those critical invalidations.

Issue found here https://bugzilla.redhat.com/show_bug.cgi?id=504751, but
this also fixes current (2.6.30) Linux kernel.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kernel/amd_iommu.c      |   16 ++++++++++++++++
 arch/x86/kernel/amd_iommu_init.c |    3 +++
 2 files changed, 19 insertions(+)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -425,6 +425,16 @@ static void iommu_flush_tlb(struct amd_i
 	iommu_queue_inv_iommu_pages(iommu, address, domid, 0, 1);
 }
 
+/* Flush the whole IO/TLB for a given protection domain - including PDE */
+static void iommu_flush_tlb_pde(struct amd_iommu *iommu, u16 domid)
+{
+	u64 address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
+
+	INC_STATS_COUNTER(domain_flush_single);
+
+	iommu_queue_inv_iommu_pages(iommu, address, domid, 1, 1);
+}
+
 /*
  * This function is used to flush the IO/TLB for a given protection domain
  * on every IOMMU in the system
@@ -934,7 +944,13 @@ static void attach_device(struct amd_iom
 	amd_iommu_pd_table[devid] = domain;
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 
+	/*
+	 * We might boot into a crash-kernel here. The crashed kernel
+	 * left the caches in the IOMMU dirty. So we have to flush
+	 * here to evict all dirty stuff.
+	 */
 	iommu_queue_inv_dev_entry(iommu, devid);
+	iommu_flush_tlb_pde(iommu, domain->id);
 }
 
 /*
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -420,6 +420,9 @@ static u8 * __init alloc_command_buffer(
 
 	iommu->cmd_buf_size = CMD_BUFFER_SIZE;
 
+	/* disable command buffer processing while setting it up */
+	iommu_feature_disable(iommu, CONTROL_CMDBUF_EN);
+
 	entry = (u64)virt_to_phys(cmd_buf);
 	entry |= MMIO_CMD_SIZE_512;
 	memcpy_toio(iommu->mmio_base + MMIO_CMD_BUF_OFFSET,
