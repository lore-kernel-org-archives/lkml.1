Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbZKTHIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbZKTHIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 02:08:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755833AbZKTHG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 02:06:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:61356 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651AbZKTHGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 02:06:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,776,1249282800"; 
   d="scan'208";a="571400194"
Subject: [PATCH 2/8] ioat3: dca and raid operations are incompatible
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
Date: Fri, 20 Nov 2009 00:06:24 -0700
Message-ID: <20091120070624.13478.24768.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
References: <20091120070506.13478.77838.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RAID operations cause a system hang on platforms with DCA
(Direct-Cache-Access) enabled.  So turn off RAID capabilities in this
case.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/dca.c    |    2 +-
 drivers/dma/ioat/dma_v3.c |    6 ++++++
 drivers/dma/ioat/hw.h     |    2 ++
 3 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ioat/dca.c b/drivers/dma/ioat/dca.c
index 14f0a78..abd9038 100644
--- a/drivers/dma/ioat/dca.c
+++ b/drivers/dma/ioat/dca.c
@@ -103,7 +103,7 @@ static int dca_enabled_in_bios(struct pci_dev *pdev)
 	return res;
 }
 
-static int system_has_dca_enabled(struct pci_dev *pdev)
+int system_has_dca_enabled(struct pci_dev *pdev)
 {
 	if (boot_cpu_has(X86_FEATURE_DCA))
 		return dca_enabled_in_bios(pdev);
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 35d1e33..4f305f6 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1117,6 +1117,7 @@ static int __devinit ioat3_dma_self_test(struct ioatdma_device *device)
 int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 {
 	struct pci_dev *pdev = device->pdev;
+	int dca_en = system_has_dca_enabled(pdev);
 	struct dma_device *dma;
 	struct dma_chan *c;
 	struct ioat_chan_common *chan;
@@ -1137,6 +1138,11 @@ int __devinit ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	dma->device_prep_dma_interrupt = ioat3_prep_interrupt_lock;
 
 	cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
+
+	/* dca is incompatible with raid operations */
+	if (dca_en && (cap & (IOAT_CAP_XOR|IOAT_CAP_PQ)))
+		cap &= ~(IOAT_CAP_XOR|IOAT_CAP_PQ);
+
 	if (cap & IOAT_CAP_XOR) {
 		is_raid_device = true;
 		dma->max_xor = 8;
diff --git a/drivers/dma/ioat/hw.h b/drivers/dma/ioat/hw.h
index 99afb12..60e6754 100644
--- a/drivers/dma/ioat/hw.h
+++ b/drivers/dma/ioat/hw.h
@@ -39,6 +39,8 @@
 #define IOAT_VER_3_0            0x30    /* Version 3.0 */
 #define IOAT_VER_3_2            0x32    /* Version 3.2 */
 
+int system_has_dca_enabled(struct pci_dev *pdev);
+
 struct ioat_dma_descriptor {
 	uint32_t	size;
 	union {

