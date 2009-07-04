Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbZGDBov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbZGDBov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758780AbZGDBo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:44:27 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1777 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758644AbZGDBoN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:44:13 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
       "Scott Branden" <sbranden@broadcom.com>,
       "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 18:44:08 -0700
Subject: [PATCH v2 8/18] new ARM SoC support: BCMRing
Thread-Topic: [PATCH v2 8/18] new ARM SoC support: BCMRing
Thread-Index: Acn8SOuwFNbvc+9BSMSXnV8Zkdm7KA==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25BA6C16@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 66506C624CG20367845-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 44f251fe10d28ca74bdd98daf2fbe25eb5444c1b Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 17:02:23 -0700
Subject: [PATCH 08/18] add mach-bcmring/dma.c

add dma support for bcmring
add dma register header file

Signed-off-by: Leo Chen <leochen@broadcom.com>
---
 arch/arm/mach-bcmring/dma.c                        | 2892 ++++++++++++++++++++
 arch/arm/mach-bcmring/include/csp/dmacHw.h         |  596 ++++
 .../mach-bcmring/include/mach/csp/dmacHw_priv.h    |  145 +
 .../arm/mach-bcmring/include/mach/csp/dmacHw_reg.h |  406 +++
 arch/arm/mach-bcmring/include/mach/dma.h           |  826 ++++++
 5 files changed, 4865 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-bcmring/dma.c
 create mode 100644 arch/arm/mach-bcmring/include/csp/dmacHw.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h
 create mode 100644 arch/arm/mach-bcmring/include/mach/dma.h

diff --git a/arch/arm/mach-bcmring/dma.c b/arch/arm/mach-bcmring/dma.c
new file mode 100644
index 0000000..c584e51
--- /dev/null
+++ b/arch/arm/mach-bcmring/dma.c
@@ -0,0 +1,2892 @@
+/*****************************************************************************
+* Copyright 2004 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+/****************************************************************************/
+/**
+*   @file   dma.c
+*
+*   @brief  Implements the DMA interface.
+*/
+/****************************************************************************/
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/irqreturn.h>
+#include <linux/proc_fs.h>
+
+#include <mach/timer.h>
+
+#include <linux/mm.h>
+#include <linux/pfn.h>
+#include <asm/atomic.h>
+#include <mach/dma.h>
+
+/* I don't quite understand why dc4 fails when this is set to 1 and DMA is enabled */
+/* especially since dc4 doesn't use kmalloc'd memory. */
+
+#define ALLOW_MAP_OF_KMALLOC_MEMORY 0
+
+/* ---- Public Variables ------------------------------------------------- */
+
+/* ---- Private Constants and Types -------------------------------------- */
+
+#define MAKE_HANDLE(controllerIdx, channelIdx)    (((controllerIdx) << 4) | (channelIdx))
+
+#define CONTROLLER_FROM_HANDLE(handle)    (((handle) >> 4) & 0x0f)
+#define CHANNEL_FROM_HANDLE(handle)       ((handle) & 0x0f)
+
+#define DMA_MAP_DEBUG   0
+
+#if DMA_MAP_DEBUG
+#   define  DMA_MAP_PRINT(fmt, args...)   printk("%s: " fmt, __func__,  ## args)
+#else
+#   define  DMA_MAP_PRINT(fmt, args...)
+#endif
+
+/* ---- Private Variables ------------------------------------------------ */
+
+static DMA_Global_t gDMA;
+static struct proc_dir_entry *gDmaDir;
+
+static atomic_t gDmaStatMemTypeKmalloc = ATOMIC_INIT(0);
+static atomic_t gDmaStatMemTypeVmalloc = ATOMIC_INIT(0);
+static atomic_t gDmaStatMemTypeUser = ATOMIC_INIT(0);
+static atomic_t gDmaStatMemTypeCoherent = ATOMIC_INIT(0);
+
+DMA_DeviceAttribute_t DMA_gDeviceAttribute[DMA_NUM_DEVICE_ENTRIES] = {
+       [DMA_DEVICE_MEM_TO_MEM] =       /* MEM 2 MEM */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0 | DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "mem-to-mem",
+        .config = {
+                   .srcUpdate = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+                   .dstUpdate = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+                   .transferType = dmacHw_TRANSFER_TYPE_MEM_TO_MEM,
+                   .transferMode = dmacHw_TRANSFER_MODE_PERREQUEST,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_1,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_1,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_64,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_64,
+
+                   },
+        },
+       [DMA_DEVICE_VPM_MEM_TO_MEM] =   /* VPM */
+       {
+        .flags = DMA_DEVICE_FLAG_IS_DEDICATED | DMA_DEVICE_FLAG_NO_ISR,
+        .name = "vpm",
+        .dedicatedController = 0,
+        .dedicatedChannel = 0,
+        /* reserve DMA0:0 for VPM */
+        },
+       [DMA_DEVICE_NAND_MEM_TO_MEM] =  /* NAND */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0 | DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "nand",
+        .config = {
+                   .srcPeripheralPort = 0,
+                   .dstPeripheralPort = 0,
+                   .srcStatusRegisterAddress = 0x00000000,
+                   .dstStatusRegisterAddress = 0x00000000,
+                   .transferType = dmacHw_TRANSFER_TYPE_MEM_TO_MEM,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_1,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_1,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_32,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_32,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_4,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_4,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_6,
+                   },
+        },
+       [DMA_DEVICE_PIF_MEM_TO_DEV] =   /* PIF TX */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0 | DMA_DEVICE_FLAG_ON_DMA1
+        | DMA_DEVICE_FLAG_ALLOW_LARGE_FIFO
+        | DMA_DEVICE_FLAG_ALLOC_DMA1_FIRST | DMA_DEVICE_FLAG_PORT_PER_DMAC,
+        .name = "pif_tx",
+        .dmacPort = {14, 5},
+        .config = {
+                   .srcPeripheralPort = 0,     /* SRC: memory */
+                   /* dstPeripheralPort          = 5 or 14 */
+                   .srcStatusRegisterAddress = 0x00000000,
+                   .dstStatusRegisterAddress = 0x00000000,
+                   .srcUpdate = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+                   .dstUpdate = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+                   .transferType = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_1,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_2,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_64,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_32,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_8,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_8,
+                   .maxDataPerBlock = 16256,
+                   },
+        },
+       [DMA_DEVICE_PIF_DEV_TO_MEM] =   /* PIF RX */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0 | DMA_DEVICE_FLAG_ON_DMA1
+        | DMA_DEVICE_FLAG_ALLOW_LARGE_FIFO
+        /* DMA_DEVICE_FLAG_ALLOC_DMA1_FIRST */
+        | DMA_DEVICE_FLAG_PORT_PER_DMAC,
+        .name = "pif_rx",
+        .dmacPort = {14, 5},
+        .config = {
+                   /* srcPeripheralPort          = 5 or 14 */
+                   .dstPeripheralPort = 0,     /* DST: memory */
+                   .srcStatusRegisterAddress = 0x00000000,
+                   .dstStatusRegisterAddress = 0x00000000,
+                   .srcUpdate = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+                   .dstUpdate = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+                   .transferType = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_2,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_1,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_32,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_64,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_8,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_8,
+                   .maxDataPerBlock = 16256,
+                   },
+        },
+       [DMA_DEVICE_I2S0_DEV_TO_MEM] =  /* I2S RX */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0,
+        .name = "i2s0_rx",
+        .config = {
+                   .srcPeripheralPort = 0,     /* SRC: I2S0 */
+                   .dstPeripheralPort = 0,     /* DST: memory */
+                   .srcStatusRegisterAddress = 0,
+                   .dstStatusRegisterAddress = 0,
+                   .transferType = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_1,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_1,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_16,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_64,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_4,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_0,
+                   .blockTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .transferMode = dmacHw_TRANSFER_MODE_CONTINUOUS,
+                   },
+        },
+       [DMA_DEVICE_I2S0_MEM_TO_DEV] =  /* I2S TX */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0,
+        .name = "i2s0_tx",
+        .config = {
+                   .srcPeripheralPort = 0,     /* SRC: memory */
+                   .dstPeripheralPort = 1,     /* DST: I2S0 */
+                   .srcStatusRegisterAddress = 0,
+                   .dstStatusRegisterAddress = 0,
+                   .transferType = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_1,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_1,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_64,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_16,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_0,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_4,
+                   .blockTransferInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .transferMode = dmacHw_TRANSFER_MODE_PERREQUEST,
+                   },
+        },
+       [DMA_DEVICE_I2S1_DEV_TO_MEM] =  /* I2S1 RX */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "i2s1_rx",
+        .config = {
+                   .srcPeripheralPort = 2,     /* SRC: I2S1 */
+                   .dstPeripheralPort = 0,     /* DST: memory */
+                   .srcStatusRegisterAddress = 0,
+                   .dstStatusRegisterAddress = 0,
+                   .transferType = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_1,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_1,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_16,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_64,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_4,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_0,
+                   .blockTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .transferMode = dmacHw_TRANSFER_MODE_CONTINUOUS,
+                   },
+        },
+       [DMA_DEVICE_I2S1_MEM_TO_DEV] =  /* I2S1 TX */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "i2s1_tx",
+        .config = {
+                   .srcPeripheralPort = 0,     /* SRC: memory */
+                   .dstPeripheralPort = 3,     /* DST: I2S1 */
+                   .srcStatusRegisterAddress = 0,
+                   .dstStatusRegisterAddress = 0,
+                   .transferType = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_1,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_1,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_64,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_16,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_0,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_4,
+                   .blockTransferInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .transferMode = dmacHw_TRANSFER_MODE_PERREQUEST,
+                   },
+        },
+       [DMA_DEVICE_ESW_MEM_TO_DEV] =   /* ESW TX */
+       {
+        .name = "esw_tx",
+        .flags = DMA_DEVICE_FLAG_IS_DEDICATED,
+        .dedicatedController = 1,
+        .dedicatedChannel = 3,
+        .config = {
+                   .srcPeripheralPort = 0,     /* SRC: memory */
+                   .dstPeripheralPort = 1,     /* DST: ESW (MTP) */
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   /* DMAx_AHB_SSTATARy */
+                   .srcStatusRegisterAddress = 0x00000000,
+                   /* DMAx_AHB_DSTATARy */
+                   .dstStatusRegisterAddress = 0x30490010,
+                   /* DMAx_AHB_CFGy */
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   /* DMAx_AHB_CTLy */
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_2,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_1,
+                   .transferType = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_0,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_8,
+                   .srcUpdate = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+                   .dstUpdate = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_64,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_64,
+                   },
+        },
+       [DMA_DEVICE_ESW_DEV_TO_MEM] =   /* ESW RX */
+       {
+        .name = "esw_rx",
+        .flags = DMA_DEVICE_FLAG_IS_DEDICATED,
+        .dedicatedController = 1,
+        .dedicatedChannel = 2,
+        .config = {
+                   .srcPeripheralPort = 0,     /* SRC: ESW (PTM) */
+                   .dstPeripheralPort = 0,     /* DST: memory */
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   /* DMAx_AHB_SSTATARy */
+                   .srcStatusRegisterAddress = 0x30480010,
+                   /* DMAx_AHB_DSTATARy */
+                   .dstStatusRegisterAddress = 0x00000000,
+                   /* DMAx_AHB_CFGy */
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   /* DMAx_AHB_CTLy */
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_2,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_1,
+                   .transferType = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_8,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_0,
+                   .srcUpdate = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+                   .dstUpdate = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_64,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_64,
+                   },
+        },
+       [DMA_DEVICE_APM_CODEC_A_DEV_TO_MEM] =   /* APM Codec A Ingress */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0,
+        .name = "apm_a_rx",
+        .config = {
+                   .srcPeripheralPort = 2,     /* SRC: Codec A Ingress FIFO */
+                   .dstPeripheralPort = 0,     /* DST: memory */
+                   .srcStatusRegisterAddress = 0x00000000,
+                   .dstStatusRegisterAddress = 0x00000000,
+                   .srcUpdate = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+                   .dstUpdate = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+                   .transferType = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_2,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_1,
+                   .blockTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_32,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_64,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_4,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_4,
+                   .transferMode = dmacHw_TRANSFER_MODE_CONTINUOUS,
+                   },
+        },
+       [DMA_DEVICE_APM_CODEC_A_MEM_TO_DEV] =   /* APM Codec A Egress */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0,
+        .name = "apm_a_tx",
+        .config = {
+                   .srcPeripheralPort = 0,     /* SRC: memory */
+                   .dstPeripheralPort = 3,     /* DST: Codec A Egress FIFO */
+                   .srcStatusRegisterAddress = 0x00000000,
+                   .dstStatusRegisterAddress = 0x00000000,
+                   .srcUpdate = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+                   .dstUpdate = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+                   .transferType = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_1,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_2,
+                   .blockTransferInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_64,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_32,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_4,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_4,
+                   .transferMode = dmacHw_TRANSFER_MODE_PERREQUEST,
+                   },
+        },
+       [DMA_DEVICE_APM_CODEC_B_DEV_TO_MEM] =   /* APM Codec B Ingress */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0,
+        .name = "apm_b_rx",
+        .config = {
+                   .srcPeripheralPort = 4,     /* SRC: Codec B Ingress FIFO */
+                   .dstPeripheralPort = 0,     /* DST: memory */
+                   .srcStatusRegisterAddress = 0x00000000,
+                   .dstStatusRegisterAddress = 0x00000000,
+                   .srcUpdate = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+                   .dstUpdate = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+                   .transferType = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_2,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_1,
+                   .blockTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_32,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_64,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_4,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_4,
+                   .transferMode = dmacHw_TRANSFER_MODE_CONTINUOUS,
+                   },
+        },
+       [DMA_DEVICE_APM_CODEC_B_MEM_TO_DEV] =   /* APM Codec B Egress */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0,
+        .name = "apm_b_tx",
+        .config = {
+                   .srcPeripheralPort = 0,     /* SRC: memory */
+                   .dstPeripheralPort = 5,     /* DST: Codec B Egress FIFO */
+                   .srcStatusRegisterAddress = 0x00000000,
+                   .dstStatusRegisterAddress = 0x00000000,
+                   .srcUpdate = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+                   .dstUpdate = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+                   .transferType = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_1,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_2,
+                   .blockTransferInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_64,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_32,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_4,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_4,
+                   .transferMode = dmacHw_TRANSFER_MODE_PERREQUEST,
+                   },
+        },
+       [DMA_DEVICE_APM_CODEC_C_DEV_TO_MEM] =   /* APM Codec C Ingress */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "apm_c_rx",
+        .config = {
+                   .srcPeripheralPort = 4,     /* SRC: Codec C Ingress FIFO */
+                   .dstPeripheralPort = 0,     /* DST: memory */
+                   .srcStatusRegisterAddress = 0x00000000,
+                   .dstStatusRegisterAddress = 0x00000000,
+                   .srcUpdate = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+                   .dstUpdate = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+                   .transferType = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_2,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_1,
+                   .blockTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_32,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_64,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_4,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_4,
+                   .transferMode = dmacHw_TRANSFER_MODE_CONTINUOUS,
+                   },
+        },
+       [DMA_DEVICE_APM_PCM0_DEV_TO_MEM] =      /* PCM0 RX */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0,
+        .name = "pcm0_rx",
+        .config = {
+                   .srcPeripheralPort = 12,    /* SRC: PCM0 */
+                   .dstPeripheralPort = 0,     /* DST: memory */
+                   .srcStatusRegisterAddress = 0,
+                   .dstStatusRegisterAddress = 0,
+                   .transferType = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_2,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_1,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_32,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_64,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_8,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_4,
+                   .blockTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .transferMode = dmacHw_TRANSFER_MODE_CONTINUOUS,
+                   },
+        },
+       [DMA_DEVICE_APM_PCM0_MEM_TO_DEV] =      /* PCM0 TX */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0,
+        .name = "pcm0_tx",
+        .config = {
+                   .srcPeripheralPort = 0,     /* SRC: memory */
+                   .dstPeripheralPort = 13,    /* DST: PCM0 */
+                   .srcStatusRegisterAddress = 0,
+                   .dstStatusRegisterAddress = 0,
+                   .transferType = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_1,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_2,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_64,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_32,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_4,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_8,
+                   .blockTransferInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .transferMode = dmacHw_TRANSFER_MODE_PERREQUEST,
+                   },
+        },
+       [DMA_DEVICE_APM_PCM1_DEV_TO_MEM] =      /* PCM1 RX */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "pcm1_rx",
+        .config = {
+                   .srcPeripheralPort = 14,    /* SRC: PCM1 */
+                   .dstPeripheralPort = 0,     /* DST: memory */
+                   .srcStatusRegisterAddress = 0,
+                   .dstStatusRegisterAddress = 0,
+                   .transferType = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_2,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_1,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_32,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_64,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_8,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_4,
+                   .blockTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .transferMode = dmacHw_TRANSFER_MODE_CONTINUOUS,
+                   },
+        },
+       [DMA_DEVICE_APM_PCM1_MEM_TO_DEV] =      /* PCM1 TX */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "pcm1_tx",
+        .config = {
+                   .srcPeripheralPort = 0,     /* SRC: memory */
+                   .dstPeripheralPort = 15,    /* DST: PCM1 */
+                   .srcStatusRegisterAddress = 0,
+                   .dstStatusRegisterAddress = 0,
+                   .transferType = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_1,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_2,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_64,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_32,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_4,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_8,
+                   .blockTransferInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .transferMode = dmacHw_TRANSFER_MODE_PERREQUEST,
+                   },
+        },
+       [DMA_DEVICE_SPUM_DEV_TO_MEM] =  /* SPUM RX */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0 | DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "spum_rx",
+        .config = {
+                   .srcPeripheralPort = 6,     /* SRC: Codec A Ingress FIFO */
+                   .dstPeripheralPort = 0,     /* DST: memory */
+                   .srcStatusRegisterAddress = 0x00000000,
+                   .dstStatusRegisterAddress = 0x00000000,
+                   .srcUpdate = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+                   .dstUpdate = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+                   .transferType = dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_2,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_1,
+                   .blockTransferInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_32,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_32,
+                   /* Busrt size **MUST** be 16 for SPUM to work */
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_16,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_16,
+                   .transferMode = dmacHw_TRANSFER_MODE_PERREQUEST,
+                   /* on the RX side, SPU needs to be the flow controller */
+                   .flowControler = dmacHw_FLOW_CONTROL_PERIPHERAL,
+                   },
+        },
+       [DMA_DEVICE_SPUM_MEM_TO_DEV] =  /* SPUM TX */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0 | DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "spum_tx",
+        .config = {
+                   .srcPeripheralPort = 0,     /* SRC: memory */
+                   .dstPeripheralPort = 7,     /* DST: SPUM */
+                   .srcStatusRegisterAddress = 0x00000000,
+                   .dstStatusRegisterAddress = 0x00000000,
+                   .srcUpdate = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+                   .dstUpdate = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+                   .transferType = dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_1,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_2,
+                   .blockTransferInterrupt = dmacHw_INTERRUPT_DISABLE,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_32,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_32,
+                   /* Busrt size **MUST** be 16 for SPUM to work */
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_16,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_16,
+                   .transferMode = dmacHw_TRANSFER_MODE_PERREQUEST,
+                   },
+        },
+       [DMA_DEVICE_MEM_TO_VRAM] =      /* MEM 2 VRAM */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0 | DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "mem-to-vram",
+        .config = {
+                   .srcPeripheralPort = 0,     /* SRC: memory */
+                   .srcStatusRegisterAddress = 0x00000000,
+                   .dstStatusRegisterAddress = 0x00000000,
+                   .srcUpdate = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+                   .dstUpdate = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+                   .transferType = dmacHw_TRANSFER_TYPE_MEM_TO_MEM,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_1,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_2,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_64,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_64,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_8,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_8,
+                   },
+        },
+       [DMA_DEVICE_VRAM_TO_MEM] =      /* VRAM 2 MEM */
+       {
+        .flags = DMA_DEVICE_FLAG_ON_DMA0 | DMA_DEVICE_FLAG_ON_DMA1,
+        .name = "vram-to-mem",
+        .config = {
+                   .dstPeripheralPort = 0,     /* DST: memory */
+                   .srcStatusRegisterAddress = 0x00000000,
+                   .dstStatusRegisterAddress = 0x00000000,
+                   .srcUpdate = dmacHw_SRC_ADDRESS_UPDATE_MODE_INC,
+                   .dstUpdate = dmacHw_DST_ADDRESS_UPDATE_MODE_INC,
+                   .transferType = dmacHw_TRANSFER_TYPE_MEM_TO_MEM,
+                   .srcMasterInterface = dmacHw_SRC_MASTER_INTERFACE_2,
+                   .dstMasterInterface = dmacHw_DST_MASTER_INTERFACE_1,
+                   .completeTransferInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .errorInterrupt = dmacHw_INTERRUPT_ENABLE,
+                   .channelPriority = dmacHw_CHANNEL_PRIORITY_7,
+                   .srcMaxTransactionWidth = dmacHw_SRC_TRANSACTION_WIDTH_64,
+                   .dstMaxTransactionWidth = dmacHw_DST_TRANSACTION_WIDTH_64,
+                   .srcMaxBurstWidth = dmacHw_SRC_BURST_WIDTH_8,
+                   .dstMaxBurstWidth = dmacHw_DST_BURST_WIDTH_8,
+                   },
+        },
+};
+
+EXPORT_SYMBOL(DMA_gDeviceAttribute);   /* primarily for dma-test.c */
+
+/* ---- Private Function Prototypes -------------------------------------- */
+
+/* ---- Functions  ------------------------------------------------------- */
+
+/****************************************************************************/
+/**
+*   Displays information for /proc/dma/mem-type
+*/
+/****************************************************************************/
+
+static int dma_proc_read_mem_type(char *buf, char **start, off_t offset,
+                                 int count, int *eof, void *data)
+{
+       int len = 0;
+
+       len += sprintf(buf + len, "dma_map_mem statistics\n");
+       len +=
+           sprintf(buf + len, "coherent: %d\n",
+                   atomic_read(&gDmaStatMemTypeCoherent));
+       len +=
+           sprintf(buf + len, "kmalloc:  %d\n",
+                   atomic_read(&gDmaStatMemTypeKmalloc));
+       len +=
+           sprintf(buf + len, "vmalloc:  %d\n",
+                   atomic_read(&gDmaStatMemTypeVmalloc));
+       len +=
+           sprintf(buf + len, "user:     %d\n",
+                   atomic_read(&gDmaStatMemTypeUser));
+
+       return len;
+}
+
+/****************************************************************************/
+/**
+*   Displays information for /proc/dma/channels
+*/
+/****************************************************************************/
+
+static int dma_proc_read_channels(char *buf, char **start, off_t offset,
+                                 int count, int *eof, void *data)
+{
+       int controllerIdx;
+       int channelIdx;
+       int limit = count - 200;
+       int len = 0;
+       DMA_Channel_t *channel;
+
+       if (down_interruptible(&gDMA.lock) < 0) {
+               return -ERESTARTSYS;
+       }
+
+       for (controllerIdx = 0; controllerIdx < DMA_NUM_CONTROLLERS;
+            controllerIdx++) {
+               for (channelIdx = 0; channelIdx < DMA_NUM_CHANNELS;
+                    channelIdx++) {
+                       if (len >= limit) {
+                               break;
+                       }
+
+                       channel =
+                           &gDMA.controller[controllerIdx].channel[channelIdx];
+
+                       len +=
+                           sprintf(buf + len, "%d:%d ", controllerIdx,
+                                   channelIdx);
+
+                       if ((channel->flags & DMA_CHANNEL_FLAG_IS_DEDICATED) !=
+                           0) {
+                               len +=
+                                   sprintf(buf + len, "Dedicated for %s ",
+                                           DMA_gDeviceAttribute[channel->
+                                                                devType].name);
+                       } else {
+                               len += sprintf(buf + len, "Shared ");
+                       }
+
+                       if ((channel->flags & DMA_CHANNEL_FLAG_NO_ISR) != 0) {
+                               len += sprintf(buf + len, "No ISR ");
+                       }
+
+                       if ((channel->flags & DMA_CHANNEL_FLAG_LARGE_FIFO) != 0) {
+                               len += sprintf(buf + len, "Fifo: 128 ");
+                       } else {
+                               len += sprintf(buf + len, "Fifo: 64  ");
+                       }
+
+                       if ((channel->flags & DMA_CHANNEL_FLAG_IN_USE) != 0) {
+                               len +=
+                                   sprintf(buf + len, "InUse by %s",
+                                           DMA_gDeviceAttribute[channel->
+                                                                devType].name);
+#if (DMA_DEBUG_TRACK_RESERVATION)
+                               len +=
+                                   sprintf(buf + len, " (%s:%d)",
+                                           channel->fileName,
+                                           channel->lineNum);
+#endif
+                       } else {
+                               len += sprintf(buf + len, "Avail ");
+                       }
+
+                       if (channel->lastDevType != DMA_DEVICE_NONE) {
+                               len +=
+                                   sprintf(buf + len, "Last use: %s ",
+                                           DMA_gDeviceAttribute[channel->
+                                                                lastDevType].
+                                           name);
+                       }
+
+                       len += sprintf(buf + len, "\n");
+               }
+       }
+       up(&gDMA.lock);
+       *eof = 1;
+
+       return len;
+}
+
+/****************************************************************************/
+/**
+*   Displays information for /proc/dma/devices
+*/
+/****************************************************************************/
+
+static int dma_proc_read_devices(char *buf, char **start, off_t offset,
+                                int count, int *eof, void *data)
+{
+       int limit = count - 200;
+       int len = 0;
+       int devIdx;
+
+       if (down_interruptible(&gDMA.lock) < 0) {
+               return -ERESTARTSYS;
+       }
+
+       for (devIdx = 0; devIdx < DMA_NUM_DEVICE_ENTRIES; devIdx++) {
+               DMA_DeviceAttribute_t *devAttr = &DMA_gDeviceAttribute[devIdx];
+
+               if (devAttr->name == NULL) {
+                       continue;
+               }
+
+               if (len >= limit) {
+                       break;
+               }
+
+               len += sprintf(buf + len, "%-12s ", devAttr->name);
+
+               if ((devAttr->flags & DMA_DEVICE_FLAG_IS_DEDICATED) != 0) {
+                       len +=
+                           sprintf(buf + len, "Dedicated %d:%d ",
+                                   devAttr->dedicatedController,
+                                   devAttr->dedicatedChannel);
+               } else {
+                       len += sprintf(buf + len, "Shared DMA:");
+                       if ((devAttr->flags & DMA_DEVICE_FLAG_ON_DMA0) != 0) {
+                               len += sprintf(buf + len, "0");
+                       }
+                       if ((devAttr->flags & DMA_DEVICE_FLAG_ON_DMA1) != 0) {
+                               len += sprintf(buf + len, "1");
+                       }
+                       len += sprintf(buf + len, " ");
+               }
+               if ((devAttr->flags & DMA_DEVICE_FLAG_NO_ISR) != 0) {
+                       len += sprintf(buf + len, "NoISR ");
+               }
+               if ((devAttr->flags & DMA_DEVICE_FLAG_ALLOW_LARGE_FIFO) != 0) {
+                       len += sprintf(buf + len, "Allow-128 ");
+               }
+
+               len +=
+                   sprintf(buf + len,
+                           "Xfer #: %Lu Ticks: %Lu Bytes: %Lu DescLen: %u\n",
+                           devAttr->numTransfers, devAttr->transferTicks,
+                           devAttr->transferBytes,
+                           devAttr->ring.bytesAllocated);
+
+       }
+
+       up(&gDMA.lock);
+       *eof = 1;
+
+       return len;
+}
+
+/****************************************************************************/
+/**
+*   Determines if a DMA_Device_t is "valid".
+*
+*   @return
+*       TRUE        - dma device is valid
+*       FALSE       - dma device isn't valid
+*/
+/****************************************************************************/
+
+static inline int IsDeviceValid(DMA_Device_t device)
+{
+       return (device >= 0) && (device < DMA_NUM_DEVICE_ENTRIES);
+}
+
+/****************************************************************************/
+/**
+*   Translates a DMA handle into a pointer to a channel.
+*
+*   @return
+*       non-NULL    - pointer to DMA_Channel_t
+*       NULL        - DMA Handle was invalid
+*/
+/****************************************************************************/
+
+static inline DMA_Channel_t *HandleToChannel(DMA_Handle_t handle)
+{
+       int controllerIdx;
+       int channelIdx;
+
+       controllerIdx = CONTROLLER_FROM_HANDLE(handle);
+       channelIdx = CHANNEL_FROM_HANDLE(handle);
+
+       if ((controllerIdx > DMA_NUM_CONTROLLERS)
+           || (channelIdx > DMA_NUM_CHANNELS)) {
+               return NULL;
+       }
+       return &gDMA.controller[controllerIdx].channel[channelIdx];
+}
+
+/****************************************************************************/
+/**
+*   Interrupt handler which is called to process DMA interrupts.
+*/
+/****************************************************************************/
+
+static irqreturn_t dma_interrupt_handler(int irq, void *dev_id)
+{
+       DMA_Channel_t *channel;
+       DMA_DeviceAttribute_t *devAttr;
+       int irqStatus;
+
+       channel = (DMA_Channel_t *) dev_id;
+
+       /* Figure out why we were called, and knock down the interrupt */
+
+       irqStatus = dmacHw_getInterruptStatus(channel->dmacHwHandle);
+       dmacHw_clearInterrupt(channel->dmacHwHandle);
+
+       if ((channel->devType < 0)
+           || (channel->devType > DMA_NUM_DEVICE_ENTRIES)) {
+               printk(KERN_ERR "dma_interrupt_handler: Invalid devType: %d\n",
+                      channel->devType);
+               return IRQ_NONE;
+       }
+       devAttr = &DMA_gDeviceAttribute[channel->devType];
+
+       /* Update stats */
+
+       if ((irqStatus & dmacHw_INTERRUPT_STATUS_TRANS) != 0) {
+               devAttr->transferTicks +=
+                   (timer_get_tick_count() - devAttr->transferStartTime);
+       }
+
+       if ((irqStatus & dmacHw_INTERRUPT_STATUS_ERROR) != 0) {
+               printk(KERN_ERR
+                      "dma_interrupt_handler: devType :%d DMA error (%s)\n",
+                      channel->devType, devAttr->name);
+       } else {
+               devAttr->numTransfers++;
+               devAttr->transferBytes += devAttr->numBytes;
+       }
+
+       /* Call any installed handler */
+
+       if (devAttr->devHandler != NULL) {
+               devAttr->devHandler(channel->devType, irqStatus,
+                                   devAttr->userData);
+       }
+
+       return IRQ_HANDLED;
+}
+
+/****************************************************************************/
+/**
+*   Allocates memory to hold a descriptor ring. The descriptor ring then
+*   needs to be populated by making one or more calls to
+*   dna_add_descriptors.
+*
+*   The returned descriptor ring will be automatically initialized.
+*
+*   @return
+*       0           Descriptor ring was allocated successfully
+*       -EINVAL     Invalid parameters passed in
+*       -ENOMEM     Unable to allocate memory for the desired number of descriptors.
+*/
+/****************************************************************************/
+
+int dma_alloc_descriptor_ring(DMA_DescriptorRing_t *ring,      /* Descriptor ring to populate */
+                             int numDescriptors        /* Number of descriptors that need to be allocated. */
+    ) {
+       size_t bytesToAlloc = dmacHw_descriptorLen(numDescriptors);
+
+       if ((ring == NULL) || (numDescriptors <= 0)) {
+               return -EINVAL;
+       }
+
+       ring->physAddr = 0;
+       ring->descriptorsAllocated = 0;
+       ring->bytesAllocated = 0;
+
+       ring->virtAddr = dma_alloc_writecombine(NULL,
+                                                    bytesToAlloc,
+                                                    &ring->physAddr,
+                                                    GFP_KERNEL);
+       if (ring->virtAddr == NULL) {
+               return -ENOMEM;
+       }
+
+       ring->bytesAllocated = bytesToAlloc;
+       ring->descriptorsAllocated = numDescriptors;
+
+       return dma_init_descriptor_ring(ring, numDescriptors);
+}
+
+EXPORT_SYMBOL(dma_alloc_descriptor_ring);
+
+/****************************************************************************/
+/**
+*   Releases the memory which was previously allocated for a descriptor ring.
+*/
+/****************************************************************************/
+
+void dma_free_descriptor_ring(DMA_DescriptorRing_t *ring       /* Descriptor to release */
+    ) {
+       if (ring->virtAddr != NULL) {
+               dma_free_writecombine(NULL,
+                                     ring->bytesAllocated,
+                                     ring->virtAddr, ring->physAddr);
+       }
+
+       ring->bytesAllocated = 0;
+       ring->descriptorsAllocated = 0;
+       ring->virtAddr = NULL;
+       ring->physAddr = 0;
+}
+
+EXPORT_SYMBOL(dma_free_descriptor_ring);
+
+/****************************************************************************/
+/**
+*   Initializes a descriptor ring, so that descriptors can be added to it.
+*   Once a descriptor ring has been allocated, it may be reinitialized for
+*   use with additional/different regions of memory.
+*
+*   Note that if 7 descriptors are allocated, it's perfectly acceptable to
+*   initialize the ring with a smaller number of descriptors. The amount
+*   of memory allocated for the descriptor ring will not be reduced, and
+*   the descriptor ring may be reinitialized later
+*
+*   @return
+*       0           Descriptor ring was initialized successfully
+*       -ENOMEM     The descriptor which was passed in has insufficient space
+*                   to hold the desired number of descriptors.
+*/
+/****************************************************************************/
+
+int dma_init_descriptor_ring(DMA_DescriptorRing_t *ring,       /* Descriptor ring to initialize */
+                            int numDescriptors /* Number of descriptors to initialize. */
+    ) {
+       if (ring->virtAddr == NULL) {
+               return -EINVAL;
+       }
+       if (dmacHw_initDescriptor(ring->virtAddr,
+                                 ring->physAddr,
+                                 ring->bytesAllocated, numDescriptors) < 0) {
+               printk(KERN_ERR
+                      "dma_init_descriptor_ring: dmacHw_initDescriptor failed\n");
+               return -ENOMEM;
+       }
+
+       return 0;
+}
+
+EXPORT_SYMBOL(dma_init_descriptor_ring);
+
+/****************************************************************************/
+/**
+*   Determines the number of descriptors which would be required for a
+*   transfer of the indicated memory region.
+*
+*   This function also needs to know which DMA device this transfer will
+*   be destined for, so that the appropriate DMA configuration can be retrieved.
+*   DMA parameters such as transfer width, and whether this is a memory-to-memory
+*   or memory-to-peripheral, etc can all affect the actual number of descriptors
+*   required.
+*
+*   @return
+*       > 0     Returns the number of descriptors required for the indicated transfer
+*       -ENODEV - Device handed in is invalid.
+*       -EINVAL Invalid parameters
+*       -ENOMEM Memory exhausted
+*/
+/****************************************************************************/
+
+int dma_calculate_descriptor_count(DMA_Device_t device,        /* DMA Device that this will be associated with */
+                                  dma_addr_t srcData,  /* Place to get data to write to device */
+                                  dma_addr_t dstData,  /* Pointer to device data address */
+                                  size_t numBytes      /* Number of bytes to transfer to the device */
+    ) {
+       int numDescriptors;
+       DMA_DeviceAttribute_t *devAttr;
+
+       if (!IsDeviceValid(device)) {
+               return -ENODEV;
+       }
+       devAttr = &DMA_gDeviceAttribute[device];
+
+       numDescriptors = dmacHw_calculateDescriptorCount(&devAttr->config,
+                                                             (void *)srcData,
+                                                             (void *)dstData,
+                                                             numBytes);
+       if (numDescriptors < 0) {
+               printk(KERN_ERR
+                      "dma_calculate_descriptor_count: dmacHw_calculateDescriptorCount failed\n");
+               return -EINVAL;
+       }
+
+       return numDescriptors;
+}
+
+EXPORT_SYMBOL(dma_calculate_descriptor_count);
+
+/****************************************************************************/
+/**
+*   Adds a region of memory to the descriptor ring. Note that it may take
+*   multiple descriptors for each region of memory. It is the callers
+*   responsibility to allocate a sufficiently large descriptor ring.
+*
+*   @return
+*       0       Descriptors were added successfully
+*       -ENODEV Device handed in is invalid.
+*       -EINVAL Invalid parameters
+*       -ENOMEM Memory exhausted
+*/
+/****************************************************************************/
+
+int dma_add_descriptors(DMA_DescriptorRing_t *ring,    /* Descriptor ring to add descriptors to */
+                       DMA_Device_t device,    /* DMA Device that descriptors are for */
+                       dma_addr_t srcData,     /* Place to get data (memory or device) */
+                       dma_addr_t dstData,     /* Place to put data (memory or device) */
+                       size_t numBytes /* Number of bytes to transfer to the device */
+    ) {
+       int rc;
+       DMA_DeviceAttribute_t *devAttr;
+
+       if (!IsDeviceValid(device)) {
+               return -ENODEV;
+       }
+       devAttr = &DMA_gDeviceAttribute[device];
+
+       rc = dmacHw_setDataDescriptor(&devAttr->config,
+                                     ring->virtAddr,
+                                     (void *)srcData,
+                                     (void *)dstData, numBytes);
+       if (rc < 0) {
+               printk(KERN_ERR
+                      "dma_add_descriptors: dmacHw_setDataDescriptor failed with code: %d\n",
+                      rc);
+               return -ENOMEM;
+       }
+
+       return 0;
+}
+
+EXPORT_SYMBOL(dma_add_descriptors);
+
+/****************************************************************************/
+/**
+*   Sets the descriptor ring associated with a device.
+*
+*   Once set, the descriptor ring will be associated with the device, even
+*   across channel request/free calls. Passing in a NULL descriptor ring
+*   will release any descriptor ring currently associated with the device.
+*
+*   Note: If you call dma_transfer, or one of the other dma_alloc_ functions
+*         the descriptor ring may be released and reallocated.
+*
+*   Note: This function will release the descriptor memory for any current
+*         descriptor ring associated with this device.
+*
+*   @return
+*       0       Descriptors were added successfully
+*       -ENODEV Device handed in is invalid.
+*/
+/****************************************************************************/
+
+int dma_set_device_descriptor_ring(DMA_Device_t device,        /* Device to update the descriptor ring for. */
+                                  DMA_DescriptorRing_t *ring   /* Descriptor ring to add descriptors to */
+    ) {
+       DMA_DeviceAttribute_t *devAttr;
+
+       if (!IsDeviceValid(device)) {
+               return -ENODEV;
+       }
+       devAttr = &DMA_gDeviceAttribute[device];
+
+       /* Free the previously allocated descriptor ring */
+
+       dma_free_descriptor_ring(&devAttr->ring);
+
+       if (ring != NULL) {
+               /* Copy in the new one */
+
+               devAttr->ring = *ring;
+       }
+
+       /* Set things up so that if dma_transfer is called then this descriptor */
+       /* ring will get freed. */
+
+       devAttr->prevSrcData = 0;
+       devAttr->prevDstData = 0;
+       devAttr->prevNumBytes = 0;
+
+       return 0;
+}
+
+EXPORT_SYMBOL(dma_set_device_descriptor_ring);
+
+/****************************************************************************/
+/**
+*   Retrieves the descriptor ring associated with a device.
+*
+*   @return
+*       0       Descriptors were added successfully
+*       -ENODEV Device handed in is invalid.
+*/
+/****************************************************************************/
+
+int dma_get_device_descriptor_ring(DMA_Device_t device,        /* Device to retrieve the descriptor ring for. */
+                                  DMA_DescriptorRing_t *ring   /* Place to store retrieved ring */
+    ) {
+       DMA_DeviceAttribute_t *devAttr;
+
+       memset(ring, 0, sizeof(*ring));
+
+       if (!IsDeviceValid(device)) {
+               return -ENODEV;
+       }
+       devAttr = &DMA_gDeviceAttribute[device];
+
+       *ring = devAttr->ring;
+
+       return 0;
+}
+
+EXPORT_SYMBOL(dma_get_device_descriptor_ring);
+
+/****************************************************************************/
+/**
+*   Configures a DMA channel.
+*
+*   @return
+*       >= 0    - Initialization was successfull.
+*
+*       -EBUSY  - Device is currently being used.
+*       -ENODEV - Device handed in is invalid.
+*/
+/****************************************************************************/
+
+static int ConfigChannel(DMA_Handle_t handle)
+{
+       DMA_Channel_t *channel;
+       DMA_DeviceAttribute_t *devAttr;
+       int controllerIdx;
+
+       channel = HandleToChannel(handle);
+       if (channel == NULL) {
+               return -ENODEV;
+       }
+       devAttr = &DMA_gDeviceAttribute[channel->devType];
+       controllerIdx = CONTROLLER_FROM_HANDLE(handle);
+
+       if ((devAttr->flags & DMA_DEVICE_FLAG_PORT_PER_DMAC) != 0) {
+               if (devAttr->config.transferType ==
+                   dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL) {
+                       devAttr->config.dstPeripheralPort =
+                           devAttr->dmacPort[controllerIdx];
+               } else if (devAttr->config.transferType ==
+                          dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM) {
+                       devAttr->config.srcPeripheralPort =
+                           devAttr->dmacPort[controllerIdx];
+               }
+       }
+
+       if (dmacHw_configChannel(channel->dmacHwHandle, &devAttr->config) != 0) {
+               printk(KERN_ERR "ConfigChannel: dmacHw_configChannel failed\n");
+               return -EIO;
+       }
+
+       return 0;
+}
+
+/****************************************************************************/
+/**
+*   Intializes all of the data structures associated with the DMA.
+*   @return
+*       >= 0    - Initialization was successfull.
+*
+*       -EBUSY  - Device is currently being used.
+*       -ENODEV - Device handed in is invalid.
+*/
+/****************************************************************************/
+
+int dma_init(void)
+{
+       int rc = 0;
+       int controllerIdx;
+       int channelIdx;
+       DMA_Device_t devIdx;
+       DMA_Channel_t *channel;
+       DMA_Handle_t dedicatedHandle;
+
+       memset(&gDMA, 0, sizeof(gDMA));
+
+       init_MUTEX_LOCKED(&gDMA.lock);
+       init_waitqueue_head(&gDMA.freeChannelQ);
+
+       /* Initialize the Hardware */
+
+       dmacHw_initDma();
+
+       /* Start off by marking all of the DMA channels as shared. */
+
+       for (controllerIdx = 0; controllerIdx < DMA_NUM_CONTROLLERS;
+            controllerIdx++) {
+               for (channelIdx = 0; channelIdx < DMA_NUM_CHANNELS;
+                    channelIdx++) {
+                       channel =
+                           &gDMA.controller[controllerIdx].channel[channelIdx];
+
+                       channel->flags = 0;
+                       channel->devType = DMA_DEVICE_NONE;
+                       channel->lastDevType = DMA_DEVICE_NONE;
+
+#if (DMA_DEBUG_TRACK_RESERVATION)
+                       channel->fileName = "";
+                       channel->lineNum = 0;
+#endif
+
+                       channel->dmacHwHandle =
+                           dmacHw_getChannelHandle(dmacHw_MAKE_CHANNEL_ID
+                                                   (controllerIdx,
+                                                    channelIdx));
+                       dmacHw_initChannel(channel->dmacHwHandle);
+               }
+       }
+
+       /* Record any special attributes that channels may have */
+
+       gDMA.controller[0].channel[0].flags |= DMA_CHANNEL_FLAG_LARGE_FIFO;
+       gDMA.controller[0].channel[1].flags |= DMA_CHANNEL_FLAG_LARGE_FIFO;
+       gDMA.controller[1].channel[0].flags |= DMA_CHANNEL_FLAG_LARGE_FIFO;
+       gDMA.controller[1].channel[1].flags |= DMA_CHANNEL_FLAG_LARGE_FIFO;
+
+       /* Now walk through and record the dedicated channels. */
+
+       for (devIdx = 0; devIdx < DMA_NUM_DEVICE_ENTRIES; devIdx++) {
+               DMA_DeviceAttribute_t *devAttr = &DMA_gDeviceAttribute[devIdx];
+
+               if (((devAttr->flags & DMA_DEVICE_FLAG_NO_ISR) != 0)
+                   && ((devAttr->flags & DMA_DEVICE_FLAG_IS_DEDICATED) == 0)) {
+                       printk(KERN_ERR
+                              "DMA Device: %s Can only request NO_ISR for dedicated devices\n",
+                              devAttr->name);
+                       rc = -EINVAL;
+                       goto out;
+               }
+
+               if ((devAttr->flags & DMA_DEVICE_FLAG_IS_DEDICATED) != 0) {
+                       /* This is a dedicated device. Mark the channel as being reserved. */
+
+                       if (devAttr->dedicatedController >= DMA_NUM_CONTROLLERS) {
+                               printk(KERN_ERR
+                                      "DMA Device: %s DMA Controller %d is out of range\n",
+                                      devAttr->name,
+                                      devAttr->dedicatedController);
+                               rc = -EINVAL;
+                               goto out;
+                       }
+
+                       if (devAttr->dedicatedChannel >= DMA_NUM_CHANNELS) {
+                               printk(KERN_ERR
+                                      "DMA Device: %s DMA Channel %d is out of range\n",
+                                      devAttr->name,
+                                      devAttr->dedicatedChannel);
+                               rc = -EINVAL;
+                               goto out;
+                       }
+
+                       dedicatedHandle =
+                           MAKE_HANDLE(devAttr->dedicatedController,
+                                       devAttr->dedicatedChannel);
+                       channel = HandleToChannel(dedicatedHandle);
+
+                       if ((channel->flags & DMA_CHANNEL_FLAG_IS_DEDICATED) !=
+                           0) {
+                               printk
+                                   ("DMA Device: %s attempting to use same DMA Controller:Channel (%d:%d) as %s\n",
+                                    devAttr->name,
+                                    devAttr->dedicatedController,
+                                    devAttr->dedicatedChannel,
+                                    DMA_gDeviceAttribute[channel->devType].
+                                    name);
+                               rc = -EBUSY;
+                               goto out;
+                       }
+
+                       channel->flags |= DMA_CHANNEL_FLAG_IS_DEDICATED;
+                       channel->devType = devIdx;
+
+                       if (devAttr->flags & DMA_DEVICE_FLAG_NO_ISR) {
+                               channel->flags |= DMA_CHANNEL_FLAG_NO_ISR;
+                       }
+
+                       /* For dedicated channels, we can go ahead and configure the DMA channel now */
+                       /* as well. */
+
+                       ConfigChannel(dedicatedHandle);
+               }
+       }
+
+       /* Go through and register the interrupt handlers */
+
+       for (controllerIdx = 0; controllerIdx < DMA_NUM_CONTROLLERS;
+            controllerIdx++) {
+               for (channelIdx = 0; channelIdx < DMA_NUM_CHANNELS;
+                    channelIdx++) {
+                       channel =
+                           &gDMA.controller[controllerIdx].channel[channelIdx];
+
+                       if ((channel->flags & DMA_CHANNEL_FLAG_NO_ISR) == 0) {
+                               snprintf(channel->name, sizeof(channel->name),
+                                        "dma %d:%d %s", controllerIdx,
+                                        channelIdx,
+                                        channel->devType ==
+                                        DMA_DEVICE_NONE ? "" :
+                                        DMA_gDeviceAttribute[channel->devType].
+                                        name);
+
+                               rc =
+                                    request_irq(IRQ_DMA0C0 +
+                                                (controllerIdx *
+                                                 DMA_NUM_CHANNELS) +
+                                                channelIdx,
+                                                dma_interrupt_handler,
+                                                IRQF_DISABLED, channel->name,
+                                                channel);
+                               if (rc != 0) {
+                                       printk(KERN_ERR
+                                              "request_irq for IRQ_DMA%dC%d failed\n",
+                                              controllerIdx, channelIdx);
+                               }
+                       }
+               }
+       }
+
+       /* Create /proc/dma/channels and /proc/dma/devices */
+
+       gDmaDir = create_proc_entry("dma", S_IFDIR | S_IRUGO | S_IXUGO, NULL);
+
+       if (gDmaDir == NULL) {
+               printk(KERN_ERR "Unable to create /proc/dma\n");
+       } else {
+               create_proc_read_entry("channels", 0, gDmaDir,
+                                      dma_proc_read_channels, NULL);
+               create_proc_read_entry("devices", 0, gDmaDir,
+                                      dma_proc_read_devices, NULL);
+               create_proc_read_entry("mem-type", 0, gDmaDir,
+                                      dma_proc_read_mem_type, NULL);
+       }
+
+out:
+
+       up(&gDMA.lock);
+
+       return rc;
+}
+
+/****************************************************************************/
+/**
+*   Reserves a channel for use with @a dev. If the device is setup to use
+*   a shared channel, then this function will block until a free channel
+*   becomes available.
+*
+*   @return
+*       >= 0    - A valid DMA Handle.
+*       -EBUSY  - Device is currently being used.
+*       -ENODEV - Device handed in is invalid.
+*/
+/****************************************************************************/
+
+#if (DMA_DEBUG_TRACK_RESERVATION)
+DMA_Handle_t dma_request_channel_dbg
+    (DMA_Device_t dev, const char *fileName, int lineNum)
+#else
+DMA_Handle_t dma_request_channel(DMA_Device_t dev)
+#endif
+{
+       DMA_Handle_t handle;
+       DMA_DeviceAttribute_t *devAttr;
+       DMA_Channel_t *channel;
+       int controllerIdx;
+       int controllerIdx2;
+       int channelIdx;
+
+       if (down_interruptible(&gDMA.lock) < 0) {
+               return -ERESTARTSYS;
+       }
+
+       if ((dev < 0) || (dev >= DMA_NUM_DEVICE_ENTRIES)) {
+               handle = -ENODEV;
+               goto out;
+       }
+       devAttr = &DMA_gDeviceAttribute[dev];
+
+#if (DMA_DEBUG_TRACK_RESERVATION)
+       {
+               char *s;
+
+               s = strrchr(fileName, '/');
+               if (s != NULL) {
+                       fileName = s + 1;
+               }
+       }
+#endif
+       if ((devAttr->flags & DMA_DEVICE_FLAG_IN_USE) != 0) {
+               /* This device has already been requested and not been freed */
+
+               printk(KERN_ERR "%s: device %s is already requested\n",
+                      __func__, devAttr->name);
+               handle = -EBUSY;
+               goto out;
+       }
+
+       if ((devAttr->flags & DMA_DEVICE_FLAG_IS_DEDICATED) != 0) {
+               /* This device has a dedicated channel. */
+
+               channel =
+                   &gDMA.controller[devAttr->dedicatedController].
+                   channel[devAttr->dedicatedChannel];
+               if ((channel->flags & DMA_CHANNEL_FLAG_IN_USE) != 0) {
+                       handle = -EBUSY;
+                       goto out;
+               }
+
+               channel->flags |= DMA_CHANNEL_FLAG_IN_USE;
+               devAttr->flags |= DMA_DEVICE_FLAG_IN_USE;
+
+#if (DMA_DEBUG_TRACK_RESERVATION)
+               channel->fileName = fileName;
+               channel->lineNum = lineNum;
+#endif
+               handle =
+                   MAKE_HANDLE(devAttr->dedicatedController,
+                               devAttr->dedicatedChannel);
+               goto out;
+       }
+
+       /* This device needs to use one of the shared channels. */
+
+       handle = DMA_INVALID_HANDLE;
+       while (handle == DMA_INVALID_HANDLE) {
+               /* Scan through the shared channels and see if one is available */
+
+               for (controllerIdx2 = 0; controllerIdx2 < DMA_NUM_CONTROLLERS;
+                    controllerIdx2++) {
+                       /* Check to see if we should try on controller 1 first. */
+
+                       controllerIdx = controllerIdx2;
+                       if ((devAttr->
+                            flags & DMA_DEVICE_FLAG_ALLOC_DMA1_FIRST) != 0) {
+                               controllerIdx = 1 - controllerIdx;
+                       }
+
+                       /* See if the device is available on the controller being tested */
+
+                       if ((devAttr->
+                            flags & (DMA_DEVICE_FLAG_ON_DMA0 << controllerIdx))
+                           != 0) {
+                               for (channelIdx = 0;
+                                    channelIdx < DMA_NUM_CHANNELS;
+                                    channelIdx++) {
+                                       channel =
+                                           &gDMA.controller[controllerIdx].
+                                           channel[channelIdx];
+
+                                       if (((channel->
+                                             flags &
+                                             DMA_CHANNEL_FLAG_IS_DEDICATED) ==
+                                            0)
+                                           &&
+                                           ((channel->
+                                             flags & DMA_CHANNEL_FLAG_IN_USE)
+                                            == 0)) {
+                                               if (((channel->
+                                                     flags &
+                                                     DMA_CHANNEL_FLAG_LARGE_FIFO)
+                                                    != 0)
+                                                   &&
+                                                   ((devAttr->
+                                                     flags &
+                                                     DMA_DEVICE_FLAG_ALLOW_LARGE_FIFO)
+                                                    == 0)) {
+                                                       /* This channel is a large fifo - don't tie it up */
+                                                       /* with devices that we don't want using it. */
+
+                                                       continue;
+                                               }
+
+                                               channel->flags |=
+                                                   DMA_CHANNEL_FLAG_IN_USE;
+                                               channel->devType = dev;
+                                               devAttr->flags |=
+                                                   DMA_DEVICE_FLAG_IN_USE;
+
+#if (DMA_DEBUG_TRACK_RESERVATION)
+                                               channel->fileName = fileName;
+                                               channel->lineNum = lineNum;
+#endif
+                                               handle =
+                                                   MAKE_HANDLE(controllerIdx,
+                                                               channelIdx);
+
+                                               /* Now that we've reserved the channel - we can go ahead and configure it */
+
+                                               if (ConfigChannel(handle) != 0) {
+                                                       handle = -EIO;
+                                                       printk(KERN_ERR
+                                                              "dma_request_channel: ConfigChannel failed\n");
+                                               }
+                                               goto out;
+                                       }
+                               }
+                       }
+               }
+
+               /* No channels are currently available. Let's wait for one to free up. */
+
+               {
+                       DEFINE_WAIT(wait);
+
+                       prepare_to_wait(&gDMA.freeChannelQ, &wait,
+                                       TASK_INTERRUPTIBLE);
+                       up(&gDMA.lock);
+                       schedule();
+                       finish_wait(&gDMA.freeChannelQ, &wait);
+
+                       if (signal_pending(current)) {
+                               /* We don't currently hold gDMA.lock, so we return directly */
+
+                               return -ERESTARTSYS;
+                       }
+               }
+
+               if (down_interruptible(&gDMA.lock)) {
+                       return -ERESTARTSYS;
+               }
+       }
+
+out:
+       up(&gDMA.lock);
+
+       return handle;
+}
+
+/* Create both _dbg and non _dbg functions for modules. */
+
+#if (DMA_DEBUG_TRACK_RESERVATION)
+#undef dma_request_channel
+DMA_Handle_t dma_request_channel(DMA_Device_t dev)
+{
+       return dma_request_channel_dbg(dev, __FILE__, __LINE__);
+}
+
+EXPORT_SYMBOL(dma_request_channel_dbg);
+#endif
+EXPORT_SYMBOL(dma_request_channel);
+
+/****************************************************************************/
+/**
+*   Frees a previously allocated DMA Handle.
+*/
+/****************************************************************************/
+
+int dma_free_channel(DMA_Handle_t handle       /* DMA handle. */
+    ) {
+       int rc = 0;
+       DMA_Channel_t *channel;
+       DMA_DeviceAttribute_t *devAttr;
+
+       if (down_interruptible(&gDMA.lock) < 0) {
+               return -ERESTARTSYS;
+       }
+
+       channel = HandleToChannel(handle);
+       if (channel == NULL) {
+               rc = -EINVAL;
+               goto out;
+       }
+
+       devAttr = &DMA_gDeviceAttribute[channel->devType];
+
+       if ((channel->flags & DMA_CHANNEL_FLAG_IS_DEDICATED) == 0) {
+               channel->lastDevType = channel->devType;
+               channel->devType = DMA_DEVICE_NONE;
+       }
+       channel->flags &= ~DMA_CHANNEL_FLAG_IN_USE;
+       devAttr->flags &= ~DMA_DEVICE_FLAG_IN_USE;
+
+out:
+       up(&gDMA.lock);
+
+       wake_up_interruptible(&gDMA.freeChannelQ);
+
+       return rc;
+}
+
+EXPORT_SYMBOL(dma_free_channel);
+
+/****************************************************************************/
+/**
+*   Determines if a given device has been configured as using a shared
+*   channel.
+*
+*   @return
+*       0           Device uses a dedicated channel
+*       > zero      Device uses a shared channel
+*       < zero      Error code
+*/
+/****************************************************************************/
+
+int dma_device_is_channel_shared(DMA_Device_t device   /* Device to check. */
+    ) {
+       DMA_DeviceAttribute_t *devAttr;
+
+       if (!IsDeviceValid(device)) {
+               return -ENODEV;
+       }
+       devAttr = &DMA_gDeviceAttribute[device];
+
+       return ((devAttr->flags & DMA_DEVICE_FLAG_IS_DEDICATED) == 0);
+}
+
+EXPORT_SYMBOL(dma_device_is_channel_shared);
+
+/****************************************************************************/
+/**
+*   Allocates buffers for the descriptors. This is normally done automatically
+*   but needs to be done explicitly when initiating a dma from interrupt
+*   context.
+*
+*   @return
+*       0       Descriptors were allocated successfully
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _MEM_TO_DEV and not _DEV_TO_MEM)
+*       -ENOMEM Memory exhausted
+*/
+/****************************************************************************/
+
+int dma_alloc_descriptors(DMA_Handle_t handle, /* DMA Handle */
+                         dmacHw_TRANSFER_TYPE_e transferType,  /* Type of transfer being performed */
+                         dma_addr_t srcData,   /* Place to get data to write to device */
+                         dma_addr_t dstData,   /* Pointer to device data address */
+                         size_t numBytes       /* Number of bytes to transfer to the device */
+    ) {
+       DMA_Channel_t *channel;
+       DMA_DeviceAttribute_t *devAttr;
+       int numDescriptors;
+       size_t ringBytesRequired;
+       int rc = 0;
+
+       channel = HandleToChannel(handle);
+       if (channel == NULL) {
+               return -ENODEV;
+       }
+
+       devAttr = &DMA_gDeviceAttribute[channel->devType];
+
+       if (devAttr->config.transferType != transferType) {
+               return -EINVAL;
+       }
+
+       /* Figure out how many descriptors we need. */
+
+       /* printk("srcData: 0x%08x dstData: 0x%08x, numBytes: %d\n", */
+       /*        srcData, dstData, numBytes); */
+
+       numDescriptors = dmacHw_calculateDescriptorCount(&devAttr->config,
+                                                             (void *)srcData,
+                                                             (void *)dstData,
+                                                             numBytes);
+       if (numDescriptors < 0) {
+               printk(KERN_ERR "%s: dmacHw_calculateDescriptorCount failed\n",
+                      __func__);
+               return -EINVAL;
+       }
+
+       /* Check to see if we can reuse the existing descriptor ring, or if we need to allocate */
+       /* a new one. */
+
+       ringBytesRequired = dmacHw_descriptorLen(numDescriptors);
+
+       /* printk("ringBytesRequired: %d\n", ringBytesRequired); */
+
+       if (ringBytesRequired > devAttr->ring.bytesAllocated) {
+               /* Make sure that this code path is never taken from interrupt context. */
+               /* It's OK for an interrupt to initiate a DMA transfer, but the descriptor */
+               /* allocation needs to have already been done. */
+
+               might_sleep();
+
+               /* Free the old descriptor ring and allocate a new one. */
+
+               dma_free_descriptor_ring(&devAttr->ring);
+
+               /* And allocate a new one. */
+
+               rc =
+                    dma_alloc_descriptor_ring(&devAttr->ring,
+                                              numDescriptors);
+               if (rc < 0) {
+                       printk(KERN_ERR
+                              "%s: dma_alloc_descriptor_ring(%d) failed\n",
+                              __func__, numDescriptors);
+                       return rc;
+               }
+               /* Setup the descriptor for this transfer */
+
+               if (dmacHw_initDescriptor(devAttr->ring.virtAddr,
+                                         devAttr->ring.physAddr,
+                                         devAttr->ring.bytesAllocated,
+                                         numDescriptors) < 0) {
+                       printk(KERN_ERR "%s: dmacHw_initDescriptor failed\n",
+                              __func__);
+                       return -EINVAL;
+               }
+       } else {
+               /* We've already got enough ring buffer allocated. All we need to do is reset */
+               /* any control information, just in case the previous DMA was stopped. */
+
+               dmacHw_resetDescriptorControl(devAttr->ring.virtAddr);
+       }
+
+       /* dma_alloc/free both set the prevSrc/DstData to 0. If they happen to be the same */
+       /* as last time, then we don't need to call setDataDescriptor again. */
+
+       if (dmacHw_setDataDescriptor(&devAttr->config,
+                                    devAttr->ring.virtAddr,
+                                    (void *)srcData,
+                                    (void *)dstData, numBytes) < 0) {
+               printk(KERN_ERR "%s: dmacHw_setDataDescriptor failed\n",
+                      __func__);
+               return -EINVAL;
+       }
+
+       /* Remember the critical information for this transfer so that we can eliminate */
+       /* another call to dma_alloc_descriptors if the caller reuses the same buffers */
+
+       devAttr->prevSrcData = srcData;
+       devAttr->prevDstData = dstData;
+       devAttr->prevNumBytes = numBytes;
+
+       return 0;
+}
+
+EXPORT_SYMBOL(dma_alloc_descriptors);
+
+/****************************************************************************/
+/**
+*   Allocates and sets up descriptors for a double buffered circular buffer.
+*
+*   This is primarily intended to be used for things like the ingress samples
+*   from a microphone.
+*
+*   @return
+*       > 0     Number of descriptors actually allocated.
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _MEM_TO_DEV and not _DEV_TO_MEM)
+*       -ENOMEM Memory exhausted
+*/
+/****************************************************************************/
+
+int dma_alloc_double_dst_descriptors(DMA_Handle_t handle,      /* DMA Handle */
+                                    dma_addr_t srcData,        /* Physical address of source data */
+                                    dma_addr_t dstData1,       /* Physical address of first destination buffer */
+                                    dma_addr_t dstData2,       /* Physical address of second destination buffer */
+                                    size_t numBytes    /* Number of bytes in each destination buffer */
+    ) {
+       DMA_Channel_t *channel;
+       DMA_DeviceAttribute_t *devAttr;
+       int numDst1Descriptors;
+       int numDst2Descriptors;
+       int numDescriptors;
+       size_t ringBytesRequired;
+       int rc = 0;
+
+       channel = HandleToChannel(handle);
+       if (channel == NULL) {
+               return -ENODEV;
+       }
+
+       devAttr = &DMA_gDeviceAttribute[channel->devType];
+
+       /* Figure out how many descriptors we need. */
+
+       /* printk("srcData: 0x%08x dstData: 0x%08x, numBytes: %d\n", */
+       /*        srcData, dstData, numBytes); */
+
+       numDst1Descriptors =
+            dmacHw_calculateDescriptorCount(&devAttr->config, (void *)srcData,
+                                            (void *)dstData1, numBytes);
+       if (numDst1Descriptors < 0) {
+               return -EINVAL;
+       }
+       numDst2Descriptors =
+            dmacHw_calculateDescriptorCount(&devAttr->config, (void *)srcData,
+                                            (void *)dstData2, numBytes);
+       if (numDst2Descriptors < 0) {
+               return -EINVAL;
+       }
+       numDescriptors = numDst1Descriptors + numDst2Descriptors;
+       /* printk("numDescriptors: %d\n", numDescriptors); */
+
+       /* Check to see if we can reuse the existing descriptor ring, or if we need to allocate */
+       /* a new one. */
+
+       ringBytesRequired = dmacHw_descriptorLen(numDescriptors);
+
+       /* printk("ringBytesRequired: %d\n", ringBytesRequired); */
+
+       if (ringBytesRequired > devAttr->ring.bytesAllocated) {
+               /* Make sure that this code path is never taken from interrupt context. */
+               /* It's OK for an interrupt to initiate a DMA transfer, but the descriptor */
+               /* allocation needs to have already been done. */
+
+               might_sleep();
+
+               /* Free the old descriptor ring and allocate a new one. */
+
+               dma_free_descriptor_ring(&devAttr->ring);
+
+               /* And allocate a new one. */
+
+               rc =
+                    dma_alloc_descriptor_ring(&devAttr->ring,
+                                              numDescriptors);
+               if (rc < 0) {
+                       printk(KERN_ERR
+                              "%s: dma_alloc_descriptor_ring(%d) failed\n",
+                              __func__, ringBytesRequired);
+                       return rc;
+               }
+       }
+
+       /* Setup the descriptor for this transfer. Since this function is used with */
+       /* CONTINUOUS DMA operations, we need to reinitialize every time, otherwise */
+       /* setDataDescriptor will keep trying to append onto the end. */
+
+       if (dmacHw_initDescriptor(devAttr->ring.virtAddr,
+                                 devAttr->ring.physAddr,
+                                 devAttr->ring.bytesAllocated,
+                                 numDescriptors) < 0) {
+               printk(KERN_ERR "%s: dmacHw_initDescriptor failed\n", __func__);
+               return -EINVAL;
+       }
+
+       /* dma_alloc/free both set the prevSrc/DstData to 0. If they happen to be the same */
+       /* as last time, then we don't need to call setDataDescriptor again. */
+
+       if (dmacHw_setDataDescriptor(&devAttr->config,
+                                    devAttr->ring.virtAddr,
+                                    (void *)srcData,
+                                    (void *)dstData1, numBytes) < 0) {
+               printk(KERN_ERR "%s: dmacHw_setDataDescriptor 1 failed\n",
+                      __func__);
+               return -EINVAL;
+       }
+       if (dmacHw_setDataDescriptor(&devAttr->config,
+                                    devAttr->ring.virtAddr,
+                                    (void *)srcData,
+                                    (void *)dstData2, numBytes) < 0) {
+               printk(KERN_ERR "%s: dmacHw_setDataDescriptor 2 failed\n",
+                      __func__);
+               return -EINVAL;
+       }
+
+       /* You should use dma_start_transfer rather than dma_transfer_xxx so we don't */
+       /* try to make the 'prev' variables right. */
+
+       devAttr->prevSrcData = 0;
+       devAttr->prevDstData = 0;
+       devAttr->prevNumBytes = 0;
+
+       return numDescriptors;
+}
+
+EXPORT_SYMBOL(dma_alloc_double_dst_descriptors);
+
+/****************************************************************************/
+/**
+*   Initiates a transfer when the descriptors have already been setup.
+*
+*   This is a special case, and normally, the dma_transfer_xxx functions should
+*   be used.
+*
+*   @return
+*       0       Transfer was started successfully
+*       -ENODEV Invalid handle
+*/
+/****************************************************************************/
+
+int dma_start_transfer(DMA_Handle_t handle)
+{
+       DMA_Channel_t *channel;
+       DMA_DeviceAttribute_t *devAttr;
+
+       channel = HandleToChannel(handle);
+       if (channel == NULL) {
+               return -ENODEV;
+       }
+       devAttr = &DMA_gDeviceAttribute[channel->devType];
+
+       dmacHw_initiateTransfer(channel->dmacHwHandle, &devAttr->config,
+                               devAttr->ring.virtAddr);
+
+       /* Since we got this far, everything went successfully */
+
+       return 0;
+}
+
+EXPORT_SYMBOL(dma_start_transfer);
+
+/****************************************************************************/
+/**
+*   Stops a previously started DMA transfer.
+*
+*   @return
+*       0       Transfer was stopped successfully
+*       -ENODEV Invalid handle
+*/
+/****************************************************************************/
+
+int dma_stop_transfer(DMA_Handle_t handle)
+{
+       DMA_Channel_t *channel;
+
+       channel = HandleToChannel(handle);
+       if (channel == NULL) {
+               return -ENODEV;
+       }
+
+       dmacHw_stopTransfer(channel->dmacHwHandle);
+
+       return 0;
+}
+
+EXPORT_SYMBOL(dma_stop_transfer);
+
+/****************************************************************************/
+/**
+*   Waits for a DMA to complete by polling. This function is only intended
+*   to be used for testing. Interrupts should be used for most DMA operations.
+*/
+/****************************************************************************/
+
+int dma_wait_transfer_done(DMA_Handle_t handle)
+{
+       DMA_Channel_t *channel;
+       dmacHw_TRANSFER_STATUS_e status;
+
+       channel = HandleToChannel(handle);
+       if (channel == NULL) {
+               return -ENODEV;
+       }
+
+       while ((status =
+               dmacHw_transferCompleted(channel->dmacHwHandle)) ==
+              dmacHw_TRANSFER_STATUS_BUSY) {
+               ;
+       }
+
+       if (status == dmacHw_TRANSFER_STATUS_ERROR) {
+               printk(KERN_ERR "%s: DMA transfer failed\n", __func__);
+               return -EIO;
+       }
+       return 0;
+}
+
+EXPORT_SYMBOL(dma_wait_transfer_done);
+
+/****************************************************************************/
+/**
+*   Initiates a DMA, allocating the descriptors as required.
+*
+*   @return
+*       0       Transfer was started successfully
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _DEV_TO_MEM and not _MEM_TO_DEV)
+*/
+/****************************************************************************/
+
+int dma_transfer(DMA_Handle_t handle,  /* DMA Handle */
+                dmacHw_TRANSFER_TYPE_e transferType,   /* Type of transfer being performed */
+                dma_addr_t srcData,    /* Place to get data to write to device */
+                dma_addr_t dstData,    /* Pointer to device data address */
+                size_t numBytes        /* Number of bytes to transfer to the device */
+    ) {
+       DMA_Channel_t *channel;
+       DMA_DeviceAttribute_t *devAttr;
+       int rc = 0;
+
+       channel = HandleToChannel(handle);
+       if (channel == NULL) {
+               return -ENODEV;
+       }
+
+       devAttr = &DMA_gDeviceAttribute[channel->devType];
+
+       if (devAttr->config.transferType != transferType) {
+               return -EINVAL;
+       }
+
+       /* We keep track of the information about the previous request for this */
+       /* device, and if the attributes match, then we can use the descriptors we setup */
+       /* the last time, and not have to reinitialize everything. */
+
+       {
+               rc =
+                    dma_alloc_descriptors(handle, transferType, srcData,
+                                          dstData, numBytes);
+               if (rc != 0) {
+                       return rc;
+               }
+       }
+
+       /* And kick off the transfer */
+
+       devAttr->numBytes = numBytes;
+       devAttr->transferStartTime = timer_get_tick_count();
+
+       dmacHw_initiateTransfer(channel->dmacHwHandle, &devAttr->config,
+                               devAttr->ring.virtAddr);
+
+       /* Since we got this far, everything went successfully */
+
+       return 0;
+}
+
+EXPORT_SYMBOL(dma_transfer);
+
+/****************************************************************************/
+/**
+*   Set the callback function which will be called when a transfer completes.
+*   If a NULL callback function is set, then no callback will occur.
+*
+*   @note   @a devHandler will be called from IRQ context.
+*
+*   @return
+*       0       - Success
+*       -ENODEV - Device handed in is invalid.
+*/
+/****************************************************************************/
+
+int dma_set_device_handler(DMA_Device_t dev,   /* Device to set the callback for. */
+                          DMA_DeviceHandler_t devHandler,      /* Function to call when the DMA completes */
+                          void *userData       /* Pointer which will be passed to devHandler. */
+    ) {
+       DMA_DeviceAttribute_t *devAttr;
+       unsigned long flags;
+
+       if (!IsDeviceValid(dev)) {
+               return -ENODEV;
+       }
+       devAttr = &DMA_gDeviceAttribute[dev];
+
+       local_irq_save(flags);
+
+       devAttr->userData = userData;
+       devAttr->devHandler = devHandler;
+
+       local_irq_restore(flags);
+
+       return 0;
+}
+
+EXPORT_SYMBOL(dma_set_device_handler);
+
+/****************************************************************************/
+/**
+*   Initializes a memory mapping structure
+*/
+/****************************************************************************/
+
+int dma_init_mem_map(DMA_MemMap_t *memMap)
+{
+       memset(memMap, 0, sizeof(*memMap));
+
+       init_MUTEX(&memMap->lock);
+
+       return 0;
+}
+
+EXPORT_SYMBOL(dma_init_mem_map);
+
+/****************************************************************************/
+/**
+*   Releases any memory currently being held by a memory mapping structure.
+*/
+/****************************************************************************/
+
+int dma_term_mem_map(DMA_MemMap_t *memMap)
+{
+       down(&memMap->lock);    /* Just being paranoid */
+
+       /* Free up any allocated memory */
+
+       up(&memMap->lock);
+       memset(memMap, 0, sizeof(*memMap));
+
+       return 0;
+}
+
+EXPORT_SYMBOL(dma_term_mem_map);
+
+/****************************************************************************/
+/**
+*   Looks at a memory address and categorizes it.
+*
+*   @return One of the values from the DMA_MemType_t enumeration.
+*/
+/****************************************************************************/
+
+DMA_MemType_t dma_mem_type(void *addr)
+{
+       unsigned long addrVal = (unsigned long)addr;
+
+       if (addrVal >= VMALLOC_END) {
+               /* NOTE: DMA virtual memory space starts at 0xFFxxxxxx */
+
+               /* dma_alloc_xxx pages are physically and virtually contiguous */
+
+               return DMA_MEM_TYPE_DMA;
+       }
+
+       /* Technically, we could add one more classification. Addresses between VMALLOC_END */
+       /* and the beginning of the DMA virtual address could be considered to be I/O space. */
+       /* Right now, nobody cares about this particular classification, so we ignore it. */
+
+       if (is_vmalloc_addr(addr)) {
+               /* Address comes from the vmalloc'd region. Pages are virtually */
+               /* contiguous but NOT physically contiguous */
+
+               return DMA_MEM_TYPE_VMALLOC;
+       }
+
+       if (addrVal >= PAGE_OFFSET) {
+               /* PAGE_OFFSET is typically 0xC0000000 */
+
+               /* kmalloc'd pages are physically contiguous */
+
+               return DMA_MEM_TYPE_KMALLOC;
+       }
+
+       return DMA_MEM_TYPE_USER;
+}
+
+EXPORT_SYMBOL(dma_mem_type);
+
+/****************************************************************************/
+/**
+*   Looks at a memory address and determines if we support DMA'ing to/from
+*   that type of memory.
+*
+*   @return boolean -
+*               return value != 0 means dma supported
+*               return value == 0 means dma not supported
+*/
+/****************************************************************************/
+
+int dma_mem_supports_dma(void *addr)
+{
+       DMA_MemType_t memType = dma_mem_type(addr);
+
+       return (memType == DMA_MEM_TYPE_DMA)
+#if ALLOW_MAP_OF_KMALLOC_MEMORY
+           || (memType == DMA_MEM_TYPE_KMALLOC)
+#endif
+           || (memType == DMA_MEM_TYPE_USER);
+}
+
+EXPORT_SYMBOL(dma_mem_supports_dma);
+
+/****************************************************************************/
+/**
+*   Maps in a memory region such that it can be used for performing a DMA.
+*
+*   @return
+*/
+/****************************************************************************/
+
+int dma_map_start(DMA_MemMap_t *memMap,        /* Stores state information about the map */
+                 enum dma_data_direction dir   /* Direction that the mapping will be going */
+    ) {
+       int rc;
+
+       down(&memMap->lock);
+
+       DMA_MAP_PRINT("memMap: %p\n", memMap);
+
+       if (memMap->inUse) {
+               printk(KERN_ERR "%s: memory map %p is already being used\n",
+                      __func__, memMap);
+               rc = -EBUSY;
+               goto out;
+       }
+
+       memMap->inUse = 1;
+       memMap->dir = dir;
+       memMap->numRegionsUsed = 0;
+
+       rc = 0;
+
+out:
+
+       DMA_MAP_PRINT("returning %d", rc);
+
+       up(&memMap->lock);
+
+       return rc;
+}
+
+EXPORT_SYMBOL(dma_map_start);
+
+/****************************************************************************/
+/**
+*   Adds a segment of memory to a memory map. Each segment is both
+*   physically and virtually contiguous.
+*
+*   @return     0 on success, error code otherwise.
+*/
+/****************************************************************************/
+
+static int dma_map_add_segment(DMA_MemMap_t *memMap,   /* Stores state information about the map */
+                              DMA_Region_t *region,    /* Region that the segment belongs to */
+                              void *virtAddr,  /* Virtual address of the segment being added */
+                              dma_addr_t physAddr,     /* Physical address of the segment being added */
+                              size_t numBytes  /* Number of bytes of the segment being added */
+    ) {
+       DMA_Segment_t *segment;
+
+       DMA_MAP_PRINT("memMap:%p va:%p pa:0x%x #:%d\n", memMap, virtAddr,
+                     physAddr, numBytes);
+
+       /* Sanity check */
+
+       if (((unsigned long)virtAddr < (unsigned long)region->virtAddr)
+           || (((unsigned long)virtAddr + numBytes)) >
+           ((unsigned long)region->virtAddr + region->numBytes)) {
+               printk(KERN_ERR
+                      "%s: virtAddr %p is outside region @ %p len: %d\n",
+                      __func__, virtAddr, region->virtAddr, region->numBytes);
+               return -EINVAL;
+       }
+
+       if (region->numSegmentsUsed > 0) {
+               /* Check to see if this segment is physically contiguous with the previous one */
+
+               segment = &region->segment[region->numSegmentsUsed - 1];
+
+               if ((segment->physAddr + segment->numBytes) == physAddr) {
+                       /* It is - just add on to the end */
+
+                       DMA_MAP_PRINT("appending %d bytes to last segment\n",
+                                     numBytes);
+
+                       segment->numBytes += numBytes;
+
+                       return 0;
+               }
+       }
+
+       /* Reallocate to hold more segments, if required. */
+
+       if (region->numSegmentsUsed >= region->numSegmentsAllocated) {
+               DMA_Segment_t *newSegment;
+               size_t oldSize =
+                   region->numSegmentsAllocated * sizeof(*newSegment);
+               int newAlloc = region->numSegmentsAllocated + 4;
+               size_t newSize = newAlloc * sizeof(*newSegment);
+
+               newSegment = kmalloc(newSize, GFP_KERNEL);
+               if (newSegment == NULL) {
+                       return -ENOMEM;
+               }
+               memcpy(newSegment, region->segment, oldSize);
+               memset(&((uint8_t *) newSegment)[oldSize], 0,
+                      newSize - oldSize);
+               kfree(region->segment);
+
+               region->numSegmentsAllocated = newAlloc;
+               region->segment = newSegment;
+       }
+
+       segment = &region->segment[region->numSegmentsUsed];
+       region->numSegmentsUsed++;
+
+       segment->virtAddr = virtAddr;
+       segment->physAddr = physAddr;
+       segment->numBytes = numBytes;
+
+       DMA_MAP_PRINT("returning success\n");
+
+       return 0;
+}
+
+/****************************************************************************/
+/**
+*   Adds a region of memory to a memory map. Each region is virtually
+*   contiguous, but not necessarily physically contiguous.
+*
+*   @return     0 on success, error code otherwise.
+*/
+/****************************************************************************/
+
+int dma_map_add_region(DMA_MemMap_t *memMap,   /* Stores state information about the map */
+                      void *mem,       /* Virtual address that we want to get a map of */
+                      size_t numBytes  /* Number of bytes being mapped */
+    ) {
+       unsigned long addr = (unsigned long)mem;
+       unsigned int offset;
+       int rc = 0;
+       DMA_Region_t *region;
+       dma_addr_t physAddr;
+
+       down(&memMap->lock);
+
+       DMA_MAP_PRINT("memMap:%p va:%p #:%d\n", memMap, mem, numBytes);
+
+       if (!memMap->inUse) {
+               printk(KERN_ERR "%s: Make sure you call dma_map_start first\n",
+                      __func__);
+               rc = -EINVAL;
+               goto out;
+       }
+
+       /* Reallocate to hold more regions. */
+
+       if (memMap->numRegionsUsed >= memMap->numRegionsAllocated) {
+               DMA_Region_t *newRegion;
+               size_t oldSize =
+                   memMap->numRegionsAllocated * sizeof(*newRegion);
+               int newAlloc = memMap->numRegionsAllocated + 4;
+               size_t newSize = newAlloc * sizeof(*newRegion);
+
+               newRegion = kmalloc(newSize, GFP_KERNEL);
+               if (newRegion == NULL) {
+                       rc = -ENOMEM;
+                       goto out;
+               }
+               memcpy(newRegion, memMap->region, oldSize);
+               memset(&((uint8_t *) newRegion)[oldSize], 0, newSize - oldSize);
+
+               kfree(memMap->region);
+
+               memMap->numRegionsAllocated = newAlloc;
+               memMap->region = newRegion;
+       }
+
+       region = &memMap->region[memMap->numRegionsUsed];
+       memMap->numRegionsUsed++;
+
+       offset = addr & ~PAGE_MASK;
+
+       region->memType = dma_mem_type(mem);
+       region->virtAddr = mem;
+       region->numBytes = numBytes;
+       region->numSegmentsUsed = 0;
+       region->numLockedPages = 0;
+       region->lockedPages = NULL;
+
+       switch (region->memType) {
+       case DMA_MEM_TYPE_VMALLOC:
+               {
+                       atomic_inc(&gDmaStatMemTypeVmalloc);
+
+                       /* printk(KERN_ERR "%s: vmalloc'd pages are not supported\n", __func__); */
+
+                       /* vmalloc'd pages are not physically contiguous */
+
+                       rc = -EINVAL;
+                       break;
+               }
+
+       case DMA_MEM_TYPE_KMALLOC:
+               {
+                       atomic_inc(&gDmaStatMemTypeKmalloc);
+
+                       /* kmalloc'd pages are physically contiguous, so they'll have exactly */
+                       /* one segment */
+
+#if ALLOW_MAP_OF_KMALLOC_MEMORY
+                       physAddr =
+                           dma_map_single(NULL, mem, numBytes, memMap->dir);
+                       rc = dma_map_add_segment(memMap, region, mem, physAddr,
+                                                numBytes);
+#else
+                       rc = -EINVAL;
+#endif
+                       break;
+               }
+
+       case DMA_MEM_TYPE_DMA:
+               {
+                       /* dma_alloc_xxx pages are physically contiguous */
+
+                       atomic_inc(&gDmaStatMemTypeCoherent);
+
+                       physAddr = (vmalloc_to_pfn(mem) << PAGE_SHIFT) + offset;
+
+                       dma_sync_single_for_cpu(NULL, physAddr, numBytes,
+                                               memMap->dir);
+                       rc = dma_map_add_segment(memMap, region, mem, physAddr,
+                                                numBytes);
+                       break;
+               }
+
+       case DMA_MEM_TYPE_USER:
+               {
+                       size_t firstPageOffset;
+                       size_t firstPageSize;
+                       struct page **pages;
+                       struct task_struct *userTask;
+
+                       atomic_inc(&gDmaStatMemTypeUser);
+
+#if 1
+                       /* If the pages are user pages, then the dma_mem_map_set_user_task function */
+                       /* must have been previously called. */
+
+                       if (memMap->userTask == NULL) {
+                               printk(KERN_ERR
+                                      "%s: must call dma_mem_map_set_user_task when using user-mode memory\n",
+                                      __func__);
+                               return -EINVAL;
+                       }
+
+                       /* User pages need to be locked. */
+
+                       firstPageOffset =
+                           (unsigned long)region->virtAddr & (PAGE_SIZE - 1);
+                       firstPageSize = PAGE_SIZE - firstPageOffset;
+
+                       region->numLockedPages = (firstPageOffset
+                                                 + region->numBytes +
+                                                 PAGE_SIZE - 1) / PAGE_SIZE;
+                       pages =
+                           kmalloc(region->numLockedPages *
+                                   sizeof(struct page *), GFP_KERNEL);
+
+                       if (pages == NULL) {
+                               region->numLockedPages = 0;
+                               return -ENOMEM;
+                       }
+
+                       userTask = memMap->userTask;
+
+                       down_read(&userTask->mm->mmap_sem);
+                       rc = get_user_pages(userTask,   /* task */
+                                           userTask->mm,       /* mm */
+                                           (unsigned long)region->virtAddr,    /* start */
+                                           region->numLockedPages,     /* len */
+                                           memMap->dir == DMA_FROM_DEVICE,     /* write */
+                                           0,  /* force */
+                                           pages,      /* pages (array of pointers to page) */
+                                           NULL);      /* vmas */
+                       up_read(&userTask->mm->mmap_sem);
+
+                       if (rc != region->numLockedPages) {
+                               kfree(pages);
+                               region->numLockedPages = 0;
+
+                               if (rc >= 0) {
+                                       rc = -EINVAL;
+                               }
+                       } else {
+                               uint8_t *virtAddr = region->virtAddr;
+                               size_t bytesRemaining;
+                               int pageIdx;
+
+                               rc = 0; /* Since get_user_pages returns +ve number */
+
+                               region->lockedPages = pages;
+
+                               /* We've locked the user pages. Now we need to walk them and figure */
+                               /* out the physical addresses. */
+
+                               /* The first page may be partial */
+
+                               dma_map_add_segment(memMap,
+                                                   region,
+                                                   virtAddr,
+                                                   PFN_PHYS(page_to_pfn
+                                                            (pages[0])) +
+                                                   firstPageOffset,
+                                                   firstPageSize);
+
+                               virtAddr += firstPageSize;
+                               bytesRemaining =
+                                   region->numBytes - firstPageSize;
+
+                               for (pageIdx = 1;
+                                    pageIdx < region->numLockedPages;
+                                    pageIdx++) {
+                                       size_t bytesThisPage =
+                                           (bytesRemaining >
+                                            PAGE_SIZE ? PAGE_SIZE :
+                                            bytesRemaining);
+
+                                       DMA_MAP_PRINT
+                                           ("pageIdx:%d pages[pageIdx]=%p pfn=%u phys=%u\n",
+                                            pageIdx, pages[pageIdx],
+                                            page_to_pfn(pages[pageIdx]),
+                                            PFN_PHYS(page_to_pfn
+                                                     (pages[pageIdx])));
+
+                                       dma_map_add_segment(memMap,
+                                                           region,
+                                                           virtAddr,
+                                                           PFN_PHYS(page_to_pfn
+                                                                    (pages
+                                                                     [pageIdx])),
+                                                           bytesThisPage);
+
+                                       virtAddr += bytesThisPage;
+                                       bytesRemaining -= bytesThisPage;
+                               }
+                       }
+#else
+                       printk(KERN_ERR
+                              "%s: User mode pages are not yet supported\n",
+                              __func__);
+
+                       /* user pages are not physically contiguous */
+
+                       rc = -EINVAL;
+#endif
+                       break;
+               }
+
+       default:
+               {
+                       printk(KERN_ERR "%s: Unsupported memory type: %d\n",
+                              __func__, region->memType);
+
+                       rc = -EINVAL;
+                       break;
+               }
+       }
+
+       if (rc != 0) {
+               memMap->numRegionsUsed--;
+       }
+
+out:
+
+       DMA_MAP_PRINT("returning %d\n", rc);
+
+       up(&memMap->lock);
+
+       return rc;
+}
+
+EXPORT_SYMBOL(dma_map_add_segment);
+
+/****************************************************************************/
+/**
+*   Maps in a memory region such that it can be used for performing a DMA.
+*
+*   @return     0 on success, error code otherwise.
+*/
+/****************************************************************************/
+
+int dma_map_mem(DMA_MemMap_t *memMap,  /* Stores state information about the map */
+               void *mem,      /* Virtual address that we want to get a map of */
+               size_t numBytes,        /* Number of bytes being mapped */
+               enum dma_data_direction dir     /* Direction that the mapping will be going */
+    ) {
+       int rc;
+
+       rc = dma_map_start(memMap, dir);
+       if (rc == 0) {
+               rc = dma_map_add_region(memMap, mem, numBytes);
+               if (rc < 0) {
+                       /* Since the add fails, this function will fail, and the caller won't */
+                       /* call unmap, so we need to do it here. */
+
+                       dma_unmap(memMap, 0);
+               }
+       }
+
+       return rc;
+}
+
+EXPORT_SYMBOL(dma_map_mem);
+
+/****************************************************************************/
+/**
+*   Setup a descriptor ring for a given memory map.
+*
+*   It is assumed that the descriptor ring has already been initialized, and
+*   this routine will only reallocate a new descriptor ring if the existing
+*   one is too small.
+*
+*   @return     0 on success, error code otherwise.
+*/
+/****************************************************************************/
+
+int dma_map_create_descriptor_ring(DMA_Device_t dev,   /* DMA device (where the ring is stored) */
+                                  DMA_MemMap_t *memMap,        /* Memory map that will be used */
+                                  dma_addr_t devPhysAddr       /* Physical address of device */
+    ) {
+       int rc;
+       int numDescriptors;
+       DMA_DeviceAttribute_t *devAttr;
+       DMA_Region_t *region;
+       DMA_Segment_t *segment;
+       dma_addr_t srcPhysAddr;
+       dma_addr_t dstPhysAddr;
+       int regionIdx;
+       int segmentIdx;
+
+       devAttr = &DMA_gDeviceAttribute[dev];
+
+       down(&memMap->lock);
+
+       /* Figure out how many descriptors we need */
+
+       numDescriptors = 0;
+       for (regionIdx = 0; regionIdx < memMap->numRegionsUsed; regionIdx++) {
+               region = &memMap->region[regionIdx];
+
+               for (segmentIdx = 0; segmentIdx < region->numSegmentsUsed;
+                    segmentIdx++) {
+                       segment = &region->segment[segmentIdx];
+
+                       if (memMap->dir == DMA_TO_DEVICE) {
+                               srcPhysAddr = segment->physAddr;
+                               dstPhysAddr = devPhysAddr;
+                       } else {
+                               srcPhysAddr = devPhysAddr;
+                               dstPhysAddr = segment->physAddr;
+                       }
+
+                       rc =
+                            dma_calculate_descriptor_count(dev, srcPhysAddr,
+                                                           dstPhysAddr,
+                                                           segment->
+                                                           numBytes);
+                       if (rc < 0) {
+                               printk(KERN_ERR
+                                      "%s: dma_calculate_descriptor_count failed: %d\n",
+                                      __func__, rc);
+                               goto out;
+                       }
+                       numDescriptors += rc;
+               }
+       }
+
+       /* Adjust the size of the ring, if it isn't big enough */
+
+       if (numDescriptors > devAttr->ring.descriptorsAllocated) {
+               dma_free_descriptor_ring(&devAttr->ring);
+               rc =
+                    dma_alloc_descriptor_ring(&devAttr->ring,
+                                              numDescriptors);
+               if (rc < 0) {
+                       printk(KERN_ERR
+                              "%s: dma_alloc_descriptor_ring failed: %d\n",
+                              __func__, rc);
+                       goto out;
+               }
+       } else {
+               rc =
+                    dma_init_descriptor_ring(&devAttr->ring,
+                                             numDescriptors);
+               if (rc < 0) {
+                       printk(KERN_ERR
+                              "%s: dma_init_descriptor_ring failed: %d\n",
+                              __func__, rc);
+                       goto out;
+               }
+       }
+
+       /* Populate the descriptors */
+
+       for (regionIdx = 0; regionIdx < memMap->numRegionsUsed; regionIdx++) {
+               region = &memMap->region[regionIdx];
+
+               for (segmentIdx = 0; segmentIdx < region->numSegmentsUsed;
+                    segmentIdx++) {
+                       segment = &region->segment[segmentIdx];
+
+                       if (memMap->dir == DMA_TO_DEVICE) {
+                               srcPhysAddr = segment->physAddr;
+                               dstPhysAddr = devPhysAddr;
+                       } else {
+                               srcPhysAddr = devPhysAddr;
+                               dstPhysAddr = segment->physAddr;
+                       }
+
+                       rc =
+                            dma_add_descriptors(&devAttr->ring, dev,
+                                                srcPhysAddr, dstPhysAddr,
+                                                segment->numBytes);
+                       if (rc < 0) {
+                               printk(KERN_ERR
+                                      "%s: dma_add_descriptors failed: %d\n",
+                                      __func__, rc);
+                               goto out;
+                       }
+               }
+       }
+
+       rc = 0;
+
+out:
+
+       up(&memMap->lock);
+       return rc;
+}
+
+EXPORT_SYMBOL(dma_map_create_descriptor_ring);
+
+/****************************************************************************/
+/**
+*   Maps in a memory region such that it can be used for performing a DMA.
+*
+*   @return
+*/
+/****************************************************************************/
+
+int dma_unmap(DMA_MemMap_t *memMap,    /* Stores state information about the map */
+             int dirtied       /* non-zero if any of the pages were modified */
+    ) {
+       int regionIdx;
+       int segmentIdx;
+       DMA_Region_t *region;
+       DMA_Segment_t *segment;
+
+       for (regionIdx = 0; regionIdx < memMap->numRegionsUsed; regionIdx++) {
+               region = &memMap->region[regionIdx];
+
+               for (segmentIdx = 0; segmentIdx < region->numSegmentsUsed;
+                    segmentIdx++) {
+                       segment = &region->segment[segmentIdx];
+
+                       switch (region->memType) {
+                       case DMA_MEM_TYPE_VMALLOC:
+                               {
+                                       printk(KERN_ERR
+                                              "%s: vmalloc'd pages are not yet supported\n",
+                                              __func__);
+                                       return -EINVAL;
+                               }
+
+                       case DMA_MEM_TYPE_KMALLOC:
+                               {
+#if ALLOW_MAP_OF_KMALLOC_MEMORY
+                                       dma_unmap_single(NULL,
+                                                        segment->physAddr,
+                                                        segment->numBytes,
+                                                        memMap->dir);
+#endif
+                                       break;
+                               }
+
+                       case DMA_MEM_TYPE_DMA:
+                               {
+                                       dma_sync_single_for_cpu(NULL,
+                                                               segment->
+                                                               physAddr,
+                                                               segment->
+                                                               numBytes,
+                                                               memMap->dir);
+                                       break;
+                               }
+
+                       case DMA_MEM_TYPE_USER:
+                               {
+                                       /* Nothing to do here. */
+
+                                       break;
+                               }
+
+                       default:
+                               {
+                                       printk(KERN_ERR
+                                              "%s: Unsupported memory type: %d\n",
+                                              __func__, region->memType);
+                                       return -EINVAL;
+                               }
+                       }
+
+                       segment->virtAddr = NULL;
+                       segment->physAddr = 0;
+                       segment->numBytes = 0;
+               }
+
+               if (region->numLockedPages > 0) {
+                       int pageIdx;
+
+                       /* Some user pages were locked. We need to go and unlock them now. */
+
+                       for (pageIdx = 0; pageIdx < region->numLockedPages;
+                            pageIdx++) {
+                               struct page *page =
+                                   region->lockedPages[pageIdx];
+
+                               if (memMap->dir == DMA_FROM_DEVICE) {
+                                       SetPageDirty(page);
+                               }
+                               page_cache_release(page);
+                       }
+                       kfree(region->lockedPages);
+                       region->numLockedPages = 0;
+                       region->lockedPages = NULL;
+               }
+
+               region->memType = DMA_MEM_TYPE_NONE;
+               region->virtAddr = NULL;
+               region->numBytes = 0;
+               region->numSegmentsUsed = 0;
+       }
+       memMap->userTask = NULL;
+       memMap->numRegionsUsed = 0;
+       memMap->inUse = 0;
+
+       up(&memMap->lock);
+
+       return 0;
+}
+
+EXPORT_SYMBOL(dma_unmap);
diff --git a/arch/arm/mach-bcmring/include/csp/dmacHw.h b/arch/arm/mach-bcmring/include/csp/dmacHw.h
new file mode 100644
index 0000000..5d51013
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/csp/dmacHw.h
@@ -0,0 +1,596 @@
+/*****************************************************************************
+* Copyright 2004 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+/****************************************************************************/
+/**
+*  @file    dmacHw.h
+*
+*  @brief   API definitions for low level DMA controller driver
+*
+*/
+/****************************************************************************/
+#ifndef _DMACHW_H
+#define _DMACHW_H
+
+#include <stddef.h>
+
+#include <csp/stdint.h>
+#include <mach/csp/dmacHw_reg.h>
+
+/* Define DMA Channel ID using DMA controller number (m) and channel number (c).
+
+   System specific channel ID should be defined as follows
+
+   For example:
+
+   #include <dmacHw.h>
+   ...
+   #define systemHw_LCD_CHANNEL_ID                dmacHw_MAKE_CHANNEL_ID(0,5)
+   #define systemHw_SWITCH_RX_CHANNEL_ID          dmacHw_MAKE_CHANNEL_ID(0,0)
+   #define systemHw_SWITCH_TX_CHANNEL_ID          dmacHw_MAKE_CHANNEL_ID(0,1)
+   #define systemHw_APM_RX_CHANNEL_ID             dmacHw_MAKE_CHANNEL_ID(0,3)
+   #define systemHw_APM_TX_CHANNEL_ID             dmacHw_MAKE_CHANNEL_ID(0,4)
+   ...
+   #define systemHw_SHARED1_CHANNEL_ID            dmacHw_MAKE_CHANNEL_ID(1,4)
+   #define systemHw_SHARED2_CHANNEL_ID            dmacHw_MAKE_CHANNEL_ID(1,5)
+   #define systemHw_SHARED3_CHANNEL_ID            dmacHw_MAKE_CHANNEL_ID(0,6)
+   ...
+*/
+#define dmacHw_MAKE_CHANNEL_ID(m, c)         (m << 8 | c)
+
+typedef enum {
+       dmacHw_CHANNEL_PRIORITY_0 = dmacHw_REG_CFG_LO_CH_PRIORITY_0,    /* Channel priority 0. Lowest priority DMA channel */
+       dmacHw_CHANNEL_PRIORITY_1 = dmacHw_REG_CFG_LO_CH_PRIORITY_1,    /* Channel priority 1 */
+       dmacHw_CHANNEL_PRIORITY_2 = dmacHw_REG_CFG_LO_CH_PRIORITY_2,    /* Channel priority 2 */
+       dmacHw_CHANNEL_PRIORITY_3 = dmacHw_REG_CFG_LO_CH_PRIORITY_3,    /* Channel priority 3 */
+       dmacHw_CHANNEL_PRIORITY_4 = dmacHw_REG_CFG_LO_CH_PRIORITY_4,    /* Channel priority 4 */
+       dmacHw_CHANNEL_PRIORITY_5 = dmacHw_REG_CFG_LO_CH_PRIORITY_5,    /* Channel priority 5 */
+       dmacHw_CHANNEL_PRIORITY_6 = dmacHw_REG_CFG_LO_CH_PRIORITY_6,    /* Channel priority 6 */
+       dmacHw_CHANNEL_PRIORITY_7 = dmacHw_REG_CFG_LO_CH_PRIORITY_7     /* Channel priority 7. Highest priority DMA channel */
+} dmacHw_CHANNEL_PRIORITY_e;
+
+/* Source destination master interface */
+typedef enum {
+       dmacHw_SRC_MASTER_INTERFACE_1 = dmacHw_REG_CTL_SMS_1,   /* Source DMA master interface 1 */
+       dmacHw_SRC_MASTER_INTERFACE_2 = dmacHw_REG_CTL_SMS_2,   /* Source DMA master interface 2 */
+       dmacHw_DST_MASTER_INTERFACE_1 = dmacHw_REG_CTL_DMS_1,   /* Destination DMA master interface 1 */
+       dmacHw_DST_MASTER_INTERFACE_2 = dmacHw_REG_CTL_DMS_2    /* Destination DMA master interface 2 */
+} dmacHw_MASTER_INTERFACE_e;
+
+typedef enum {
+       dmacHw_SRC_TRANSACTION_WIDTH_8 = dmacHw_REG_CTL_SRC_TR_WIDTH_8, /* Source 8 bit  (1 byte) per transaction */
+       dmacHw_SRC_TRANSACTION_WIDTH_16 = dmacHw_REG_CTL_SRC_TR_WIDTH_16,       /* Source 16 bit (2 byte) per transaction */
+       dmacHw_SRC_TRANSACTION_WIDTH_32 = dmacHw_REG_CTL_SRC_TR_WIDTH_32,       /* Source 32 bit (4 byte) per transaction */
+       dmacHw_SRC_TRANSACTION_WIDTH_64 = dmacHw_REG_CTL_SRC_TR_WIDTH_64,       /* Source 64 bit (8 byte) per transaction */
+       dmacHw_DST_TRANSACTION_WIDTH_8 = dmacHw_REG_CTL_DST_TR_WIDTH_8, /* Destination 8 bit  (1 byte) per transaction */
+       dmacHw_DST_TRANSACTION_WIDTH_16 = dmacHw_REG_CTL_DST_TR_WIDTH_16,       /* Destination 16 bit (2 byte) per transaction */
+       dmacHw_DST_TRANSACTION_WIDTH_32 = dmacHw_REG_CTL_DST_TR_WIDTH_32,       /* Destination 32 bit (4 byte) per transaction */
+       dmacHw_DST_TRANSACTION_WIDTH_64 = dmacHw_REG_CTL_DST_TR_WIDTH_64        /* Destination 64 bit (8 byte) per transaction */
+} dmacHw_TRANSACTION_WIDTH_e;
+
+typedef enum {
+       dmacHw_SRC_BURST_WIDTH_0 = dmacHw_REG_CTL_SRC_MSIZE_0,  /* Source No burst */
+       dmacHw_SRC_BURST_WIDTH_4 = dmacHw_REG_CTL_SRC_MSIZE_4,  /* Source 4  X dmacHw_TRANSACTION_WIDTH_xxx bytes per burst */
+       dmacHw_SRC_BURST_WIDTH_8 = dmacHw_REG_CTL_SRC_MSIZE_8,  /* Source 8  X dmacHw_TRANSACTION_WIDTH_xxx bytes per burst */
+       dmacHw_SRC_BURST_WIDTH_16 = dmacHw_REG_CTL_SRC_MSIZE_16,        /* Source 16 X dmacHw_TRANSACTION_WIDTH_xxx bytes per burst */
+       dmacHw_DST_BURST_WIDTH_0 = dmacHw_REG_CTL_DST_MSIZE_0,  /* Destination No burst */
+       dmacHw_DST_BURST_WIDTH_4 = dmacHw_REG_CTL_DST_MSIZE_4,  /* Destination 4  X dmacHw_TRANSACTION_WIDTH_xxx bytes per burst */
+       dmacHw_DST_BURST_WIDTH_8 = dmacHw_REG_CTL_DST_MSIZE_8,  /* Destination 8  X dmacHw_TRANSACTION_WIDTH_xxx bytes per burst */
+       dmacHw_DST_BURST_WIDTH_16 = dmacHw_REG_CTL_DST_MSIZE_16 /* Destination 16 X dmacHw_TRANSACTION_WIDTH_xxx bytes per burst */
+} dmacHw_BURST_WIDTH_e;
+
+typedef enum {
+       dmacHw_TRANSFER_TYPE_MEM_TO_MEM = dmacHw_REG_CTL_TTFC_MM_DMAC,  /* Memory to memory transfer */
+       dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM = dmacHw_REG_CTL_TTFC_PM_DMAC,   /* Peripheral to memory transfer */
+       dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL = dmacHw_REG_CTL_TTFC_MP_DMAC,   /* Memory to peripheral transfer */
+       dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_PERIPHERAL = dmacHw_REG_CTL_TTFC_PP_DMAC     /* Peripheral to peripheral transfer */
+} dmacHw_TRANSFER_TYPE_e;
+
+typedef enum {
+       dmacHw_TRANSFER_MODE_PERREQUEST,        /* Block transfer per DMA request */
+       dmacHw_TRANSFER_MODE_CONTINUOUS,        /* Continuous transfer of streaming data */
+       dmacHw_TRANSFER_MODE_PERIODIC   /* Periodic transfer of streaming data */
+} dmacHw_TRANSFER_MODE_e;
+
+typedef enum {
+       dmacHw_SRC_ADDRESS_UPDATE_MODE_INC = dmacHw_REG_CTL_SINC_INC,   /* Increment source address after every transaction */
+       dmacHw_SRC_ADDRESS_UPDATE_MODE_DEC = dmacHw_REG_CTL_SINC_DEC,   /* Decrement source address after every transaction */
+       dmacHw_DST_ADDRESS_UPDATE_MODE_INC = dmacHw_REG_CTL_DINC_INC,   /* Increment destination address after every transaction */
+       dmacHw_DST_ADDRESS_UPDATE_MODE_DEC = dmacHw_REG_CTL_DINC_DEC,   /* Decrement destination address after every transaction */
+       dmacHw_SRC_ADDRESS_UPDATE_MODE_NC = dmacHw_REG_CTL_SINC_NC,     /* No change in source address after every transaction */
+       dmacHw_DST_ADDRESS_UPDATE_MODE_NC = dmacHw_REG_CTL_DINC_NC      /* No change in destination address after every transaction */
+} dmacHw_ADDRESS_UPDATE_MODE_e;
+
+typedef enum {
+       dmacHw_FLOW_CONTROL_DMA,        /* DMA working as flow controller (default) */
+       dmacHw_FLOW_CONTROL_PERIPHERAL  /* Peripheral working as flow controller */
+} dmacHw_FLOW_CONTROL_e;
+
+typedef enum {
+       dmacHw_TRANSFER_STATUS_BUSY,    /* DMA Transfer ongoing */
+       dmacHw_TRANSFER_STATUS_DONE,    /* DMA Transfer completed */
+       dmacHw_TRANSFER_STATUS_ERROR    /* DMA Transfer error */
+} dmacHw_TRANSFER_STATUS_e;
+
+typedef enum {
+       dmacHw_INTERRUPT_DISABLE,       /* Interrupt disable  */
+       dmacHw_INTERRUPT_ENABLE /* Interrupt enable */
+} dmacHw_INTERRUPT_e;
+
+typedef enum {
+       dmacHw_INTERRUPT_STATUS_NONE = 0x0,     /* No DMA interrupt */
+       dmacHw_INTERRUPT_STATUS_TRANS = 0x1,    /* End of DMA transfer interrupt */
+       dmacHw_INTERRUPT_STATUS_BLOCK = 0x2,    /* End of block transfer interrupt */
+       dmacHw_INTERRUPT_STATUS_ERROR = 0x4     /* Error interrupt */
+} dmacHw_INTERRUPT_STATUS_e;
+
+typedef enum {
+       dmacHw_CONTROLLER_ATTRIB_CHANNEL_NUM,   /* Number of DMA channel */
+       dmacHw_CONTROLLER_ATTRIB_CHANNEL_MAX_BLOCK_SIZE,        /* Maximum channel burst size */
+       dmacHw_CONTROLLER_ATTRIB_MASTER_INTF_NUM,       /* Number of DMA master interface */
+       dmacHw_CONTROLLER_ATTRIB_CHANNEL_BUS_WIDTH,     /* Channel Data bus width */
+       dmacHw_CONTROLLER_ATTRIB_CHANNEL_FIFO_SIZE      /* Channel FIFO size */
+} dmacHw_CONTROLLER_ATTRIB_e;
+
+typedef unsigned long dmacHw_HANDLE_t; /* DMA channel handle */
+typedef uint32_t dmacHw_ID_t;  /* DMA channel Id.  Must be created using
+                                  "dmacHw_MAKE_CHANNEL_ID" macro
+                                */
+/* DMA channel configuration parameters */
+typedef struct {
+       uint32_t srcPeripheralPort;     /* Source peripheral port */
+       uint32_t dstPeripheralPort;     /* Destination peripheral port */
+       uint32_t srcStatusRegisterAddress;      /* Source status register address */
+       uint32_t dstStatusRegisterAddress;      /* Destination status register address of type  */
+
+       uint32_t srcGatherWidth;        /* Number of bytes gathered before successive gather opearation */
+       uint32_t srcGatherJump; /* Number of bytes jumpped before successive gather opearation */
+       uint32_t dstScatterWidth;       /* Number of bytes sacattered before successive scatter opearation */
+       uint32_t dstScatterJump;        /* Number of bytes jumpped  before successive scatter opearation */
+       uint32_t maxDataPerBlock;       /* Maximum number of bytes to be transferred per block/descrptor.
+                                          0 = Maximum possible.
+                                        */
+
+       dmacHw_ADDRESS_UPDATE_MODE_e srcUpdate; /* Source address update mode */
+       dmacHw_ADDRESS_UPDATE_MODE_e dstUpdate; /* Destination address update mode */
+       dmacHw_TRANSFER_TYPE_e transferType;    /* DMA transfer type  */
+       dmacHw_TRANSFER_MODE_e transferMode;    /* DMA transfer mode */
+       dmacHw_MASTER_INTERFACE_e srcMasterInterface;   /* DMA source interface  */
+       dmacHw_MASTER_INTERFACE_e dstMasterInterface;   /* DMA destination interface */
+       dmacHw_TRANSACTION_WIDTH_e srcMaxTransactionWidth;      /* Source transaction width   */
+       dmacHw_TRANSACTION_WIDTH_e dstMaxTransactionWidth;      /* Destination transaction width */
+       dmacHw_BURST_WIDTH_e srcMaxBurstWidth;  /* Source burst width */
+       dmacHw_BURST_WIDTH_e dstMaxBurstWidth;  /* Destination burst width */
+       dmacHw_INTERRUPT_e blockTransferInterrupt;      /* Block trsnafer interrupt */
+       dmacHw_INTERRUPT_e completeTransferInterrupt;   /* Complete DMA trsnafer interrupt */
+       dmacHw_INTERRUPT_e errorInterrupt;      /* Error interrupt */
+       dmacHw_CHANNEL_PRIORITY_e channelPriority;      /* Channel priority */
+       dmacHw_FLOW_CONTROL_e flowControler;    /* Data flow controller */
+} dmacHw_CONFIG_t;
+
+/****************************************************************************/
+/**
+*  @brief   Initializes DMA
+*
+*  This function initializes DMA CSP driver
+*
+*  @note
+*     Must be called before using any DMA channel
+*/
+/****************************************************************************/
+void dmacHw_initDma(void);
+
+/****************************************************************************/
+/**
+*  @brief   Exit function for  DMA
+*
+*  This function isolates DMA from the system
+*
+*/
+/****************************************************************************/
+void dmacHw_exitDma(void);
+
+/****************************************************************************/
+/**
+*  @brief   Gets a handle to a DMA channel
+*
+*  This function returns a handle, representing a control block of a particular DMA channel
+*
+*  @return  -1       - On Failure
+*            handle  - On Success, representing a channel control block
+*
+*  @note
+*     None  Channel ID must be created using "dmacHw_MAKE_CHANNEL_ID" macro
+*/
+/****************************************************************************/
+dmacHw_HANDLE_t dmacHw_getChannelHandle(dmacHw_ID_t channelId  /* [ IN ] DMA Channel Id */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Initializes a DMA channel for use
+*
+*  This function initializes and resets a DMA channel for use
+*
+*  @return  -1     - On Failure
+*            0     - On Success
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+int dmacHw_initChannel(dmacHw_HANDLE_t handle  /*  [ IN ] DMA Channel handle  */
+    );
+
+/****************************************************************************/
+/**
+*  @brief  Estimates number of descriptor needed to perform certain DMA transfer
+*
+*
+*  @return  On failure : -1
+*           On success : Number of descriptor count
+*
+*
+*/
+/****************************************************************************/
+int dmacHw_calculateDescriptorCount(dmacHw_CONFIG_t *pConfig,  /*   [ IN ] Configuration settings */
+                                   void *pSrcAddr,     /*   [ IN ] Source (Peripheral/Memory) address */
+                                   void *pDstAddr,     /*   [ IN ] Destination (Peripheral/Memory) address */
+                                   size_t dataLen      /*   [ IN ] Data length in bytes */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Initializes descriptor ring
+*
+*  This function will initializes the descriptor ring of a DMA channel
+*
+*
+*  @return   -1 - On failure
+*             0 - On success
+*  @note
+*     - "len" parameter should be obtained from "dmacHw_descriptorLen"
+*     - Descriptor buffer MUST be 32 bit aligned and uncached as it
+*       is accessed by ARM and DMA
+*/
+/****************************************************************************/
+int dmacHw_initDescriptor(void *pDescriptorVirt,       /*  [ IN ] Virtual address of uncahced buffer allocated to form descriptor ring */
+                         uint32_t descriptorPhyAddr,   /*  [ IN ] Physical address of pDescriptorVirt (descriptor buffer) */
+                         uint32_t len, /*  [ IN ] Size of the pBuf */
+                         uint32_t num  /*  [ IN ] Number of descriptor in the ring */
+    );
+
+/****************************************************************************/
+/**
+*  @brief  Finds amount of memory required to form a descriptor ring
+*
+*
+*  @return   Number of bytes required to form a descriptor ring
+*
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+uint32_t dmacHw_descriptorLen(uint32_t descCnt /*  [ IN ] Number of descriptor in the ring */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Configure DMA channel
+*
+*  @return  0  : On success
+*           -1 : On failure
+*/
+/****************************************************************************/
+int dmacHw_configChannel(dmacHw_HANDLE_t handle,       /*  [ IN ] DMA Channel handle  */
+                        dmacHw_CONFIG_t *pConfig       /*   [ IN ] Configuration settings */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Set descriptors for known data length
+*
+*  When DMA has to work as a flow controller, this function prepares the
+*  descriptor chain to transfer data
+*
+*  from:
+*          - Memory to memory
+*          - Peripheral to memory
+*          - Memory to Peripheral
+*          - Peripheral to Peripheral
+*
+*  @return   -1 - On failure
+*             0 - On success
+*
+*/
+/****************************************************************************/
+int dmacHw_setDataDescriptor(dmacHw_CONFIG_t *pConfig, /*  [ IN ] Configuration settings */
+                            void *pDescriptor, /*  [ IN ] Descriptor buffer  */
+                            void *pSrcAddr,    /*  [ IN ] Source (Peripheral/Memory) address */
+                            void *pDstAddr,    /*  [ IN ] Destination (Peripheral/Memory) address */
+                            size_t dataLen     /*  [ IN ] Length in bytes   */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Indicates whether DMA transfer is in progress or completed
+*
+*  @return   DMA transfer status
+*          dmacHw_TRANSFER_STATUS_BUSY:         DMA Transfer ongoing
+*          dmacHw_TRANSFER_STATUS_DONE:         DMA Transfer completed
+*          dmacHw_TRANSFER_STATUS_ERROR:        DMA Transfer error
+*
+*/
+/****************************************************************************/
+dmacHw_TRANSFER_STATUS_e dmacHw_transferCompleted(dmacHw_HANDLE_t handle       /*   [ IN ] DMA Channel handle  */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Set descriptor carrying control information
+*
+*  This function will be used to send specific control information to the device
+*  using the DMA channel
+*
+*
+*  @return  -1 - On failure
+*            0 - On success
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+int dmacHw_setControlDescriptor(dmacHw_CONFIG_t *pConfig,      /*  [ IN ] Configuration settings */
+                               void *pDescriptor,      /*  [ IN ] Descriptor buffer  */
+                               uint32_t ctlAddress,    /*  [ IN ] Address of the device control register  */
+                               uint32_t control        /*  [ IN ] Device control information */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Read data DMA transferred to memory
+*
+*  This function will read data that has been DMAed to memory while transfering from:
+*          - Memory to memory
+*          - Peripheral to memory
+*
+*  @return  0 - No more data is available to read
+*           1 - More data might be available to read
+*
+*/
+/****************************************************************************/
+int dmacHw_readTransferredData(dmacHw_HANDLE_t handle, /*  [ IN ] DMA Channel handle    */
+                              dmacHw_CONFIG_t *pConfig,        /*  [ IN ]  Configuration settings */
+                              void *pDescriptor,       /*  [ IN ] Descriptor buffer  */
+                              void **ppBbuf,   /*  [ OUT ] Data received */
+                              size_t *pLlen    /*  [ OUT ] Length of the data received */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Prepares descriptor ring, when source peripheral working as a flow controller
+*
+*  This function will form the descriptor ring by allocating buffers, when source peripheral
+*  has to work as a flow controller to transfer data from:
+*           - Peripheral to memory.
+*
+*  @return  -1 - On failure
+*            0 - On success
+*
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+int dmacHw_setVariableDataDescriptor(dmacHw_HANDLE_t handle,   /*  [ IN ] DMA Channel handle   */
+                                    dmacHw_CONFIG_t *pConfig,  /*  [ IN ] Configuration settings */
+                                    void *pDescriptor, /*  [ IN ] Descriptor buffer  */
+                                    uint32_t srcAddr,  /*  [ IN ] Source peripheral address */
+                                    void *(*fpAlloc) (int len),        /*  [ IN ] Function pointer  that provides destination memory */
+                                    int len,   /*  [ IN ] Number of bytes "fpAlloc" will allocate for destination */
+                                    int num    /*  [ IN ] Number of descriptor to set */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Program channel register to initiate transfer
+*
+*  @return  void
+*
+*
+*  @note
+*     - Descriptor buffer MUST ALWAYS be flushed before calling this function
+*     - This function should also be called from ISR to program the channel with
+*       pending descriptors
+*/
+/****************************************************************************/
+void dmacHw_initiateTransfer(dmacHw_HANDLE_t handle,   /*   [ IN ] DMA Channel handle */
+                            dmacHw_CONFIG_t *pConfig,  /*   [ IN ] Configuration settings */
+                            void *pDescriptor  /*   [ IN ] Descriptor buffer  */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Resets descriptor control information
+*
+*  @return  void
+*/
+/****************************************************************************/
+void dmacHw_resetDescriptorControl(void *pDescriptor   /*   [ IN ] Descriptor buffer  */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Program channel register to stop transfer
+*
+*  Ensures the channel is not doing any transfer after calling this function
+*
+*  @return  void
+*
+*/
+/****************************************************************************/
+void dmacHw_stopTransfer(dmacHw_HANDLE_t handle        /*   [ IN ] DMA Channel handle */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Check the existance of pending descriptor
+*
+*  This function confirmes if there is any pending descriptor in the chain
+*  to program the channel
+*
+*  @return  1 : Channel need to be programmed with pending descriptor
+*           0 : No more pending descriptor to programe the channel
+*
+*  @note
+*     - This function should be called from ISR in case there are pending
+*       descriptor to program the channel.
+*
+*     Example:
+*
+*     dmac_isr ()
+*     {
+*         ...
+*         if (dmacHw_descriptorPending (handle))
+*         {
+*            dmacHw_initiateTransfer (handle);
+*         }
+*     }
+*
+*/
+/****************************************************************************/
+uint32_t dmacHw_descriptorPending(dmacHw_HANDLE_t handle,      /*   [ IN ] DMA Channel handle */
+                                 void *pDescriptor     /*   [ IN ] Descriptor buffer */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Deallocates source or destination memory, allocated
+*
+*  This function can be called to deallocate data memory that was DMAed successfully
+*
+*  @return  -1  - On failure
+*            0  - On success
+*
+*  @note
+*     This function will be called ONLY, when source OR destination address is pointing
+*     to dynamic memory
+*/
+/****************************************************************************/
+int dmacHw_freeMem(dmacHw_CONFIG_t *pConfig,   /*  [ IN ] Configuration settings */
+                  void *pDescriptor,   /*  [ IN ] Descriptor buffer  */
+                  void (*fpFree) (void *)      /*  [ IN ] Function pointer to free data memory */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Clears the interrupt
+*
+*  This function clears the DMA channel specific interrupt
+*
+*  @return   N/A
+*
+*  @note
+*     Must be called under the context of ISR
+*/
+/****************************************************************************/
+void dmacHw_clearInterrupt(dmacHw_HANDLE_t handle      /*  [ IN ] DMA Channel handle  */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Returns the cause of channel specific DMA interrupt
+*
+*  This function returns the cause of interrupt
+*
+*  @return  Interrupt status, each bit representing a specific type of interrupt
+*           of type dmacHw_INTERRUPT_STATUS_e
+*  @note
+*           This function should be called under the context of ISR
+*/
+/****************************************************************************/
+dmacHw_INTERRUPT_STATUS_e dmacHw_getInterruptStatus(dmacHw_HANDLE_t handle     /*  [ IN ] DMA Channel handle  */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Indentifies a DMA channel causing interrupt
+*
+*  This functions returns a channel causing interrupt of type dmacHw_INTERRUPT_STATUS_e
+*
+*  @return  NULL   : No channel causing DMA interrupt
+*           ! NULL : Handle to a channel causing DMA interrupt
+*  @note
+*     dmacHw_clearInterrupt() must be called with a valid handle after calling this function
+*/
+/****************************************************************************/
+dmacHw_HANDLE_t dmacHw_getInterruptSource(void);
+
+/****************************************************************************/
+/**
+*  @brief   Sets channel specific user data
+*
+*  This function associates user data to a specif DMA channel
+*
+*/
+/****************************************************************************/
+void dmacHw_setChannelUserData(dmacHw_HANDLE_t handle, /*  [ IN ] DMA Channel handle  */
+                              void *userData   /*  [ IN ] User data  */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Gets channel specific user data
+*
+*  This function returns user data specific to a DMA channel
+*
+*  @return   user data
+*/
+/****************************************************************************/
+void *dmacHw_getChannelUserData(dmacHw_HANDLE_t handle /*  [ IN ] DMA Channel handle  */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Displays channel specific registers and other control parameters
+*
+*
+*  @return  void
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+void dmacHw_printDebugInfo(dmacHw_HANDLE_t handle,     /*  [ IN ] DMA Channel handle  */
+                          void *pDescriptor,   /*  [ IN ] Descriptor buffer  */
+                          int (*fpPrint) (const char *, ...)   /*  [ IN ] Print callback function */
+    );
+
+/****************************************************************************/
+/**
+*  @brief   Provides DMA controller attributes
+*
+*
+*  @return  DMA controller attributes
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+uint32_t dmacHw_getDmaControllerAttribute(dmacHw_HANDLE_t handle,      /*  [ IN ]  DMA Channel handle  */
+                                         dmacHw_CONTROLLER_ATTRIB_e attr       /*  [ IN ]  DMA Controler attribute of type  dmacHw_CONTROLLER_ATTRIB_e */
+    );
+
+#endif /* _DMACHW_H */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
new file mode 100644
index 0000000..375066a
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
@@ -0,0 +1,145 @@
+/*****************************************************************************
+* Copyright 2004 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+/****************************************************************************/
+/**
+*  @file    dmacHw_priv.h
+*
+*  @brief   Private Definitions for low level DMA driver
+*
+*/
+/****************************************************************************/
+
+#ifndef _DMACHW_PRIV_H
+#define _DMACHW_PRIV_H
+
+#include <csp/stdint.h>
+
+/* Data type for DMA Link List Item */
+typedef struct {
+       uint32_t sar;           /* Source Adress Register.
+                                  Address must be aligned to CTLx.SRC_TR_WIDTH.             */
+       uint32_t dar;           /* Destination Address Register.
+                                  Address must be aligned to CTLx.DST_TR_WIDTH.             */
+       uint32_t llpPhy;        /* LLP contains the physical address of the next descriptor for block chaining using linked lists.
+                                  Address MUST be aligned to a 32-bit boundary.             */
+       dmacHw_REG64_t ctl;     /* Control Register. 64 bits */
+       uint32_t sstat;         /* Source Status Register */
+       uint32_t dstat;         /* Destination Status Register */
+       uint32_t devCtl;        /* Device specific control information */
+       uint32_t llp;           /* LLP contains the virtual address of the next descriptor for block chaining using linked lists. */
+} dmacHw_DESC_t;
+
+/*
+ *  Descriptor ring pointers
+ */
+typedef struct {
+       int num;                /* Number of link items */
+       dmacHw_DESC_t *pHead;   /* Head of descriptor ring (for writing) */
+       dmacHw_DESC_t *pTail;   /* Tail of descriptor ring (for reading) */
+       dmacHw_DESC_t *pProg;   /* Descriptor to program the channel (for programming the channel register) */
+       dmacHw_DESC_t *pEnd;    /* End of current descriptor chain */
+       dmacHw_DESC_t *pFree;   /* Descriptor to free memory (freeing dynamic memory) */
+       uint32_t virt2PhyOffset;        /* Virtual to physical address offset for the descriptor ring */
+} dmacHw_DESC_RING_t;
+
+/*
+ *  DMA channel control block
+ */
+typedef struct {
+       uint32_t module;        /* DMA controller module (0-1) */
+       uint32_t channel;       /* DMA channel (0-7) */
+       volatile uint32_t varDataStarted;       /* Flag indicating variable data channel is enabled */
+       volatile uint32_t descUpdated;  /* Flag to indicate descriptor update is complete */
+       void *userData;         /* Channel specifc user data */
+} dmacHw_CBLK_t;
+
+#define dmacHw_ASSERT(a)                  if (!(a)) while (1)
+#define dmacHw_MAX_CHANNEL_COUNT          16
+#define dmacHw_FREE_USER_MEMORY           0xFFFFFFFF
+#define dmacHw_DESC_FREE                  dmacHw_REG_CTL_DONE
+#define dmacHw_DESC_INIT                  ((dmacHw_DESC_t *) 0xFFFFFFFF)
+#define dmacHw_MAX_BLOCKSIZE              4064
+#define dmacHw_GET_DESC_RING(addr)        (dmacHw_DESC_RING_t *)(addr)
+#define dmacHw_ADDRESS_MASK(byte)         ((byte) - 1)
+#define dmacHw_NEXT_DESC(rp, dp)           ((rp)->dp = (dmacHw_DESC_t *)(rp)->dp->llp)
+#define dmacHw_HANDLE_TO_CBLK(handle)     ((dmacHw_CBLK_t *) (handle))
+#define dmacHw_CBLK_TO_HANDLE(cblkp)      ((dmacHw_HANDLE_t) (cblkp))
+#define dmacHw_DST_IS_MEMORY(tt)          (((tt) ==  dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM) || ((tt) == dmacHw_TRANSFER_TYPE_MEM_TO_MEM)) ? 1 : 0
+
+/****************************************************************************/
+/**
+*  @brief   Get next available transaction width
+*
+*
+*  @return  On sucess  : Next avail able transaction width
+*           On failure : dmacHw_TRANSACTION_WIDTH_8
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+static inline dmacHw_TRANSACTION_WIDTH_e dmacHw_GetNextTrWidth(dmacHw_TRANSACTION_WIDTH_e tw   /*   [ IN ] Current transaction width */
+    ) {
+       if (tw & dmacHw_REG_CTL_SRC_TR_WIDTH_MASK) {
+               return ((tw >> dmacHw_REG_CTL_SRC_TR_WIDTH_SHIFT) -
+                        1) << dmacHw_REG_CTL_SRC_TR_WIDTH_SHIFT;
+       } else if (tw & dmacHw_REG_CTL_DST_TR_WIDTH_MASK) {
+               return ((tw >> dmacHw_REG_CTL_DST_TR_WIDTH_SHIFT) -
+                        1) << dmacHw_REG_CTL_DST_TR_WIDTH_SHIFT;
+       }
+
+       /* Default return  */
+       return dmacHw_SRC_TRANSACTION_WIDTH_8;
+}
+
+/****************************************************************************/
+/**
+*  @brief   Get number of bytes per transaction
+*
+*  @return  Number of bytes per transaction
+*
+*
+*  @note
+*     None
+*/
+/****************************************************************************/
+static inline int dmacHw_GetTrWidthInBytes(dmacHw_TRANSACTION_WIDTH_e tw       /*   [ IN ]  Transaction width */
+    ) {
+       int width = 1;
+       switch (tw) {
+       case dmacHw_SRC_TRANSACTION_WIDTH_8:
+               width = 1;
+               break;
+       case dmacHw_SRC_TRANSACTION_WIDTH_16:
+       case dmacHw_DST_TRANSACTION_WIDTH_16:
+               width = 2;
+               break;
+       case dmacHw_SRC_TRANSACTION_WIDTH_32:
+       case dmacHw_DST_TRANSACTION_WIDTH_32:
+               width = 4;
+               break;
+       case dmacHw_SRC_TRANSACTION_WIDTH_64:
+       case dmacHw_DST_TRANSACTION_WIDTH_64:
+               width = 8;
+               break;
+       default:
+               dmacHw_ASSERT(0);
+       }
+
+       /* Default transaction width */
+       return width;
+}
+
+#endif /* _DMACHW_PRIV_H */
diff --git a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h
new file mode 100644
index 0000000..891cea8
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h
@@ -0,0 +1,406 @@
+/*****************************************************************************
+* Copyright 2004 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+/****************************************************************************/
+/**
+*  @file    dmacHw_reg.h
+*
+*  @brief   Definitions for low level DMA registers
+*
+*/
+/****************************************************************************/
+
+#ifndef _DMACHW_REG_H
+#define _DMACHW_REG_H
+
+#include <csp/stdint.h>
+#include <mach/csp/mm_io.h>
+
+/* Data type for 64 bit little endian register */
+typedef struct {
+       volatile uint32_t lo;   /* Lower 32 bit in little endian mode */
+       volatile uint32_t hi;   /* Upper 32 bit in little endian mode */
+} dmacHw_REG64_t;
+
+/* Data type representing DMA channel registers */
+typedef struct {
+       dmacHw_REG64_t ChannelSar;      /*  Source Adress Register. 64 bits (upper 32 bits are reserved)
+                                          Address must be aligned to CTLx.SRC_TR_WIDTH.
+                                        */
+       dmacHw_REG64_t ChannelDar;      /*  Destination Address Register.64 bits (upper 32 bits are reserved)
+                                          Address must be aligned to CTLx.DST_TR_WIDTH.
+                                        */
+       dmacHw_REG64_t ChannelLlp;      /*  Link List Pointer.64 bits (upper 32 bits are reserved)
+                                          LLP contains the pointer to the next LLI for block chaining using linked lists.
+                                          If LLPis set to 0x0, then transfers using linked lists are not enabled.
+                                          Address MUST be aligned to a 32-bit boundary.
+                                        */
+       dmacHw_REG64_t ChannelCtl;      /* Control Register. 64 bits */
+       dmacHw_REG64_t ChannelSstat;    /* Source Status Register */
+       dmacHw_REG64_t ChannelDstat;    /* Destination Status Register */
+       dmacHw_REG64_t ChannelSstatAddr;        /* Source Status Address Register */
+       dmacHw_REG64_t ChannelDstatAddr;        /* Destination Status Address Register */
+       dmacHw_REG64_t ChannelConfig;   /* Channel Configuration Register */
+       dmacHw_REG64_t SrcGather;       /* Source gather register */
+       dmacHw_REG64_t DstScatter;      /* Destination scatter register */
+} dmacHw_CH_REG_t;
+
+/* Data type for RAW interrupt status registers */
+typedef struct {
+       dmacHw_REG64_t RawTfr;  /* Raw Status for IntTfr Interrupt */
+       dmacHw_REG64_t RawBlock;        /* Raw Status for IntBlock Interrupt */
+       dmacHw_REG64_t RawSrcTran;      /* Raw Status for IntSrcTran Interrupt */
+       dmacHw_REG64_t RawDstTran;      /* Raw Status for IntDstTran Interrupt */
+       dmacHw_REG64_t RawErr;  /* Raw Status for IntErr Interrupt */
+} dmacHw_INT_RAW_t;
+
+/* Data type for interrupt status registers */
+typedef struct {
+       dmacHw_REG64_t StatusTfr;       /* Status for IntTfr Interrupt */
+       dmacHw_REG64_t StatusBlock;     /* Status for IntBlock Interrupt */
+       dmacHw_REG64_t StatusSrcTran;   /* Status for IntSrcTran Interrupt */
+       dmacHw_REG64_t StatusDstTran;   /* Status for IntDstTran Interrupt */
+       dmacHw_REG64_t StatusErr;       /* Status for IntErr Interrupt */
+} dmacHw_INT_STATUS_t;
+
+/* Data type for interrupt mask registers*/
+typedef struct {
+       dmacHw_REG64_t MaskTfr; /* Mask for IntTfr Interrupt */
+       dmacHw_REG64_t MaskBlock;       /* Mask for IntBlock Interrupt */
+       dmacHw_REG64_t MaskSrcTran;     /* Mask for IntSrcTran Interrupt */
+       dmacHw_REG64_t MaskDstTran;     /* Mask for IntDstTran Interrupt */
+       dmacHw_REG64_t MaskErr; /* Mask for IntErr Interrupt */
+} dmacHw_INT_MASK_t;
+
+/* Data type for interrupt clear registers */
+typedef struct {
+       dmacHw_REG64_t ClearTfr;        /* Clear for IntTfr Interrupt */
+       dmacHw_REG64_t ClearBlock;      /* Clear for IntBlock Interrupt */
+       dmacHw_REG64_t ClearSrcTran;    /* Clear for IntSrcTran Interrupt */
+       dmacHw_REG64_t ClearDstTran;    /* Clear for IntDstTran Interrupt */
+       dmacHw_REG64_t ClearErr;        /* Clear for IntErr Interrupt */
+       dmacHw_REG64_t StatusInt;       /* Status for each interrupt type */
+} dmacHw_INT_CLEAR_t;
+
+/* Data type for software handshaking registers */
+typedef struct {
+       dmacHw_REG64_t ReqSrcReg;       /* Source Software Transaction Request Register */
+       dmacHw_REG64_t ReqDstReg;       /* Destination Software Transaction Request Register */
+       dmacHw_REG64_t SglReqSrcReg;    /* Single Source Transaction Request Register */
+       dmacHw_REG64_t SglReqDstReg;    /* Single Destination Transaction Request Register */
+       dmacHw_REG64_t LstSrcReg;       /* Last Source Transaction Request Register */
+       dmacHw_REG64_t LstDstReg;       /* Last Destination Transaction Request Register */
+} dmacHw_SW_HANDSHAKE_t;
+
+/* Data type for misc. registers */
+typedef struct {
+       dmacHw_REG64_t DmaCfgReg;       /* DMA Configuration Register */
+       dmacHw_REG64_t ChEnReg; /* DMA Channel Enable Register */
+       dmacHw_REG64_t DmaIdReg;        /* DMA ID Register */
+       dmacHw_REG64_t DmaTestReg;      /* DMA Test Register */
+       dmacHw_REG64_t Reserved0;       /* Reserved */
+       dmacHw_REG64_t Reserved1;       /* Reserved */
+       dmacHw_REG64_t CompParm6;       /* Component Parameter 6 */
+       dmacHw_REG64_t CompParm5;       /* Component Parameter 5 */
+       dmacHw_REG64_t CompParm4;       /* Component Parameter 4 */
+       dmacHw_REG64_t CompParm3;       /* Component Parameter 3 */
+       dmacHw_REG64_t CompParm2;       /* Component Parameter 2 */
+       dmacHw_REG64_t CompParm1;       /* Component Parameter 1 */
+       dmacHw_REG64_t CompId;  /* Compoent ID */
+} dmacHw_MISC_t;
+
+/* Base registers */
+#define dmacHw_0_MODULE_BASE_ADDR        (char *) MM_IO_BASE_DMA0      /* DMAC 0 module's base address */
+#define dmacHw_1_MODULE_BASE_ADDR        (char *) MM_IO_BASE_DMA1      /* DMAC 1 module's base address */
+
+extern uint32_t dmaChannelCount_0;
+extern uint32_t dmaChannelCount_1;
+
+/* Define channel specific registers */
+#define dmacHw_CHAN_BASE(module, chan)          ((dmacHw_CH_REG_t *) ((char *)((module) ? dmacHw_1_MODULE_BASE_ADDR : dmacHw_0_MODULE_BASE_ADDR) + ((chan) * sizeof(dmacHw_CH_REG_t))))
+
+/* Raw interrupt status registers */
+#define dmacHw_REG_INT_RAW_BASE(module)         ((char *)dmacHw_CHAN_BASE((module), ((module) ? dmaChannelCount_1 : dmaChannelCount_0)))
+#define dmacHw_REG_INT_RAW_TRAN(module)         (((dmacHw_INT_RAW_t *) dmacHw_REG_INT_RAW_BASE((module)))->RawTfr.lo)
+#define dmacHw_REG_INT_RAW_BLOCK(module)        (((dmacHw_INT_RAW_t *) dmacHw_REG_INT_RAW_BASE((module)))->RawBlock.lo)
+#define dmacHw_REG_INT_RAW_STRAN(module)        (((dmacHw_INT_RAW_t *) dmacHw_REG_INT_RAW_BASE((module)))->RawSrcTran.lo)
+#define dmacHw_REG_INT_RAW_DTRAN(module)        (((dmacHw_INT_RAW_t *) dmacHw_REG_INT_RAW_BASE((module)))->RawDstTran.lo)
+#define dmacHw_REG_INT_RAW_ERROR(module)        (((dmacHw_INT_RAW_t *) dmacHw_REG_INT_RAW_BASE((module)))->RawErr.lo)
+
+/* Interrupt status registers */
+#define dmacHw_REG_INT_STAT_BASE(module)        ((char *)(dmacHw_REG_INT_RAW_BASE((module)) + sizeof(dmacHw_INT_RAW_t)))
+#define dmacHw_REG_INT_STAT_TRAN(module)        (((dmacHw_INT_STATUS_t *) dmacHw_REG_INT_STAT_BASE((module)))->StatusTfr.lo)
+#define dmacHw_REG_INT_STAT_BLOCK(module)       (((dmacHw_INT_STATUS_t *) dmacHw_REG_INT_STAT_BASE((module)))->StatusBlock.lo)
+#define dmacHw_REG_INT_STAT_STRAN(module)       (((dmacHw_INT_STATUS_t *) dmacHw_REG_INT_STAT_BASE((module)))->StatusSrcTran.lo)
+#define dmacHw_REG_INT_STAT_DTRAN(module)       (((dmacHw_INT_STATUS_t *) dmacHw_REG_INT_STAT_BASE((module)))->StatusDstTran.lo)
+#define dmacHw_REG_INT_STAT_ERROR(module)       (((dmacHw_INT_STATUS_t *) dmacHw_REG_INT_STAT_BASE((module)))->StatusErr.lo)
+
+/* Interrupt status registers */
+#define dmacHw_REG_INT_MASK_BASE(module)        ((char *)(dmacHw_REG_INT_STAT_BASE((module)) + sizeof(dmacHw_INT_STATUS_t)))
+#define dmacHw_REG_INT_MASK_TRAN(module)        (((dmacHw_INT_MASK_t *) dmacHw_REG_INT_MASK_BASE((module)))->MaskTfr.lo)
+#define dmacHw_REG_INT_MASK_BLOCK(module)       (((dmacHw_INT_MASK_t *) dmacHw_REG_INT_MASK_BASE((module)))->MaskBlock.lo)
+#define dmacHw_REG_INT_MASK_STRAN(module)       (((dmacHw_INT_MASK_t *) dmacHw_REG_INT_MASK_BASE((module)))->MaskSrcTran.lo)
+#define dmacHw_REG_INT_MASK_DTRAN(module)       (((dmacHw_INT_MASK_t *) dmacHw_REG_INT_MASK_BASE((module)))->MaskDstTran.lo)
+#define dmacHw_REG_INT_MASK_ERROR(module)       (((dmacHw_INT_MASK_t *) dmacHw_REG_INT_MASK_BASE((module)))->MaskErr.lo)
+
+/* Interrupt clear registers */
+#define dmacHw_REG_INT_CLEAR_BASE(module)       ((char *)(dmacHw_REG_INT_MASK_BASE((module)) + sizeof(dmacHw_INT_MASK_t)))
+#define dmacHw_REG_INT_CLEAR_TRAN(module)       (((dmacHw_INT_CLEAR_t *) dmacHw_REG_INT_CLEAR_BASE((module)))->ClearTfr.lo)
+#define dmacHw_REG_INT_CLEAR_BLOCK(module)      (((dmacHw_INT_CLEAR_t *) dmacHw_REG_INT_CLEAR_BASE((module)))->ClearBlock.lo)
+#define dmacHw_REG_INT_CLEAR_STRAN(module)      (((dmacHw_INT_CLEAR_t *) dmacHw_REG_INT_CLEAR_BASE((module)))->ClearSrcTran.lo)
+#define dmacHw_REG_INT_CLEAR_DTRAN(module)      (((dmacHw_INT_CLEAR_t *) dmacHw_REG_INT_CLEAR_BASE((module)))->ClearDstTran.lo)
+#define dmacHw_REG_INT_CLEAR_ERROR(module)      (((dmacHw_INT_CLEAR_t *) dmacHw_REG_INT_CLEAR_BASE((module)))->ClearErr.lo)
+#define dmacHw_REG_INT_STATUS(module)           (((dmacHw_INT_CLEAR_t *) dmacHw_REG_INT_CLEAR_BASE((module)))->StatusInt.lo)
+
+/* Software handshaking registers */
+#define dmacHw_REG_SW_HS_BASE(module)           ((char *)(dmacHw_REG_INT_CLEAR_BASE((module)) + sizeof(dmacHw_INT_CLEAR_t)))
+#define dmacHw_REG_SW_HS_SRC_REQ(module)        (((dmacHw_SW_HANDSHAKE_t *) dmacHw_REG_SW_HS_BASE((module)))->ReqSrcReg.lo)
+#define dmacHw_REG_SW_HS_DST_REQ(module)        (((dmacHw_SW_HANDSHAKE_t *) dmacHw_REG_SW_HS_BASE((module)))->ReqDstReg.lo)
+#define dmacHw_REG_SW_HS_SRC_SGL_REQ(module)    (((dmacHw_SW_HANDSHAKE_t *) dmacHw_REG_SW_HS_BASE((module)))->SglReqSrcReg.lo)
+#define dmacHw_REG_SW_HS_DST_SGL_REQ(module)    (((dmacHw_SW_HANDSHAKE_t *) dmacHw_REG_SW_HS_BASE((module)))->SglReqDstReg.lo)
+#define dmacHw_REG_SW_HS_SRC_LST_REQ(module)    (((dmacHw_SW_HANDSHAKE_t *) dmacHw_REG_SW_HS_BASE((module)))->LstSrcReg.lo)
+#define dmacHw_REG_SW_HS_DST_LST_REQ(module)    (((dmacHw_SW_HANDSHAKE_t *) dmacHw_REG_SW_HS_BASE((module)))->LstDstReg.lo)
+
+/* Miscellaneous registers */
+#define dmacHw_REG_MISC_BASE(module)            ((char *)(dmacHw_REG_SW_HS_BASE((module)) + sizeof(dmacHw_SW_HANDSHAKE_t)))
+#define dmacHw_REG_MISC_CFG(module)             (((dmacHw_MISC_t *) dmacHw_REG_MISC_BASE((module)))->DmaCfgReg.lo)
+#define dmacHw_REG_MISC_CH_ENABLE(module)       (((dmacHw_MISC_t *) dmacHw_REG_MISC_BASE((module)))->ChEnReg.lo)
+#define dmacHw_REG_MISC_ID(module)              (((dmacHw_MISC_t *) dmacHw_REG_MISC_BASE((module)))->DmaIdReg.lo)
+#define dmacHw_REG_MISC_TEST(module)            (((dmacHw_MISC_t *) dmacHw_REG_MISC_BASE((module)))->DmaTestReg.lo)
+#define dmacHw_REG_MISC_COMP_PARAM1_LO(module)  (((dmacHw_MISC_t *) dmacHw_REG_MISC_BASE((module)))->CompParm1.lo)
+#define dmacHw_REG_MISC_COMP_PARAM1_HI(module)  (((dmacHw_MISC_t *) dmacHw_REG_MISC_BASE((module)))->CompParm1.hi)
+#define dmacHw_REG_MISC_COMP_PARAM2_LO(module)  (((dmacHw_MISC_t *) dmacHw_REG_MISC_BASE((module)))->CompParm2.lo)
+#define dmacHw_REG_MISC_COMP_PARAM2_HI(module)  (((dmacHw_MISC_t *) dmacHw_REG_MISC_BASE((module)))->CompParm2.hi)
+#define dmacHw_REG_MISC_COMP_PARAM3_LO(module)  (((dmacHw_MISC_t *) dmacHw_REG_MISC_BASE((module)))->CompParm3.lo)
+#define dmacHw_REG_MISC_COMP_PARAM3_HI(module)  (((dmacHw_MISC_t *) dmacHw_REG_MISC_BASE((module)))->CompParm3.hi)
+#define dmacHw_REG_MISC_COMP_PARAM4_LO(module)  (((dmacHw_MISC_t *) dmacHw_REG_MISC_BASE((module)))->CompParm4.lo)
+#define dmacHw_REG_MISC_COMP_PARAM4_HI(module)  (((dmacHw_MISC_t *) dmacHw_REG_MISC_BASE((module)))->CompParm4.hi)
+#define dmacHw_REG_MISC_COMP_PARAM5_LO(module)  (((dmacHw_MISC_t *) dmacHw_REG_MISC_BASE((module)))->CompParm5.lo)
+#define dmacHw_REG_MISC_COMP_PARAM5_HI(module)  (((dmacHw_MISC_t *) dmacHw_REG_MISC_BASE((module)))->CompParm5.hi)
+#define dmacHw_REG_MISC_COMP_PARAM6_LO(module)  (((dmacHw_MISC_t *) dmacHw_REG_MISC_BASE((module)))->CompParm6.lo)
+#define dmacHw_REG_MISC_COMP_PARAM6_HI(module)  (((dmacHw_MISC_t *) dmacHw_REG_MISC_BASE((module)))->CompParm6.hi)
+
+/* Channel control registers */
+#define dmacHw_REG_SAR(module, chan)            (dmacHw_CHAN_BASE((module), (chan))->ChannelSar.lo)
+#define dmacHw_REG_DAR(module, chan)            (dmacHw_CHAN_BASE((module), (chan))->ChannelDar.lo)
+#define dmacHw_REG_LLP(module, chan)            (dmacHw_CHAN_BASE((module), (chan))->ChannelLlp.lo)
+
+#define dmacHw_REG_CTL_LO(module, chan)         (dmacHw_CHAN_BASE((module), (chan))->ChannelCtl.lo)
+#define dmacHw_REG_CTL_HI(module, chan)         (dmacHw_CHAN_BASE((module), (chan))->ChannelCtl.hi)
+
+#define dmacHw_REG_SSTAT(module, chan)          (dmacHw_CHAN_BASE((module), (chan))->ChannelSstat.lo)
+#define dmacHw_REG_DSTAT(module, chan)          (dmacHw_CHAN_BASE((module), (chan))->ChannelDstat.lo)
+#define dmacHw_REG_SSTATAR(module, chan)        (dmacHw_CHAN_BASE((module), (chan))->ChannelSstatAddr.lo)
+#define dmacHw_REG_DSTATAR(module, chan)        (dmacHw_CHAN_BASE((module), (chan))->ChannelDstatAddr.lo)
+
+#define dmacHw_REG_CFG_LO(module, chan)         (dmacHw_CHAN_BASE((module), (chan))->ChannelConfig.lo)
+#define dmacHw_REG_CFG_HI(module, chan)         (dmacHw_CHAN_BASE((module), (chan))->ChannelConfig.hi)
+
+#define dmacHw_REG_SGR_LO(module, chan)         (dmacHw_CHAN_BASE((module), (chan))->SrcGather.lo)
+#define dmacHw_REG_SGR_HI(module, chan)         (dmacHw_CHAN_BASE((module), (chan))->SrcGather.hi)
+
+#define dmacHw_REG_DSR_LO(module, chan)         (dmacHw_CHAN_BASE((module), (chan))->DstScatter.lo)
+#define dmacHw_REG_DSR_HI(module, chan)         (dmacHw_CHAN_BASE((module), (chan))->DstScatter.hi)
+
+#define INT_STATUS_MASK(channel)                (0x00000001 << (channel))
+#define CHANNEL_BUSY(mod, channel)              (dmacHw_REG_MISC_CH_ENABLE((mod)) & (0x00000001 << (channel)))
+
+/* Bit mask for REG_DMACx_CTL_LO */
+
+#define dmacHw_REG_CTL_INT_EN                       0x00000001 /* Channel interrupt enable */
+
+#define dmacHw_REG_CTL_DST_TR_WIDTH_MASK            0x0000000E /* Destination transaction width mask */
+#define dmacHw_REG_CTL_DST_TR_WIDTH_SHIFT           1
+#define dmacHw_REG_CTL_DST_TR_WIDTH_8               0x00000000 /* Destination transaction width 8 bit */
+#define dmacHw_REG_CTL_DST_TR_WIDTH_16              0x00000002 /* Destination transaction width 16 bit */
+#define dmacHw_REG_CTL_DST_TR_WIDTH_32              0x00000004 /* Destination transaction width 32 bit */
+#define dmacHw_REG_CTL_DST_TR_WIDTH_64              0x00000006 /* Destination transaction width 64 bit */
+
+#define dmacHw_REG_CTL_SRC_TR_WIDTH_MASK            0x00000070 /* Source transaction width mask */
+#define dmacHw_REG_CTL_SRC_TR_WIDTH_SHIFT           4
+#define dmacHw_REG_CTL_SRC_TR_WIDTH_8               0x00000000 /* Source transaction width 8 bit */
+#define dmacHw_REG_CTL_SRC_TR_WIDTH_16              0x00000010 /* Source transaction width 16 bit */
+#define dmacHw_REG_CTL_SRC_TR_WIDTH_32              0x00000020 /* Source transaction width 32 bit */
+#define dmacHw_REG_CTL_SRC_TR_WIDTH_64              0x00000030 /* Source transaction width 64 bit */
+
+#define dmacHw_REG_CTL_DS_ENABLE                    0x00040000 /* Destination scatter enable */
+#define dmacHw_REG_CTL_SG_ENABLE                    0x00020000 /* Source gather enable */
+
+#define dmacHw_REG_CTL_DINC_MASK                    0x00000180 /* Destination address inc/dec mask */
+#define dmacHw_REG_CTL_DINC_INC                     0x00000000 /* Destination address increment */
+#define dmacHw_REG_CTL_DINC_DEC                     0x00000080 /* Destination address decrement */
+#define dmacHw_REG_CTL_DINC_NC                      0x00000100 /* Destination address no change */
+
+#define dmacHw_REG_CTL_SINC_MASK                    0x00000600 /* Source address inc/dec mask */
+#define dmacHw_REG_CTL_SINC_INC                     0x00000000 /* Source address increment */
+#define dmacHw_REG_CTL_SINC_DEC                     0x00000200 /* Source address decrement */
+#define dmacHw_REG_CTL_SINC_NC                      0x00000400 /* Source address no change */
+
+#define dmacHw_REG_CTL_DST_MSIZE_MASK               0x00003800 /* Destination burst transaction length */
+#define dmacHw_REG_CTL_DST_MSIZE_0                  0x00000000 /* No Destination burst */
+#define dmacHw_REG_CTL_DST_MSIZE_4                  0x00000800 /* Destination burst transaction length 4 */
+#define dmacHw_REG_CTL_DST_MSIZE_8                  0x00001000 /* Destination burst transaction length 8 */
+#define dmacHw_REG_CTL_DST_MSIZE_16                 0x00001800 /* Destination burst transaction length 16 */
+
+#define dmacHw_REG_CTL_SRC_MSIZE_MASK               0x0001C000 /* Source burst transaction length */
+#define dmacHw_REG_CTL_SRC_MSIZE_0                  0x00000000 /* No Source burst */
+#define dmacHw_REG_CTL_SRC_MSIZE_4                  0x00004000 /* Source burst transaction length 4 */
+#define dmacHw_REG_CTL_SRC_MSIZE_8                  0x00008000 /* Source burst transaction length 8 */
+#define dmacHw_REG_CTL_SRC_MSIZE_16                 0x0000C000 /* Source burst transaction length 16 */
+
+#define dmacHw_REG_CTL_TTFC_MASK                    0x00700000 /* Transfer type and flow controller */
+#define dmacHw_REG_CTL_TTFC_MM_DMAC                 0x00000000 /* Memory to Memory with DMAC as flow controller */
+#define dmacHw_REG_CTL_TTFC_MP_DMAC                 0x00100000 /* Memory to Peripheral with DMAC as flow controller */
+#define dmacHw_REG_CTL_TTFC_PM_DMAC                 0x00200000 /* Peripheral to Memory with DMAC as flow controller */
+#define dmacHw_REG_CTL_TTFC_PP_DMAC                 0x00300000 /* Peripheral to Peripheral with DMAC as flow controller */
+#define dmacHw_REG_CTL_TTFC_PM_PERI                 0x00400000 /* Peripheral to Memory with Peripheral as flow controller */
+#define dmacHw_REG_CTL_TTFC_PP_SPERI                0x00500000 /* Peripheral to Peripheral with Source Peripheral as flow controller */
+#define dmacHw_REG_CTL_TTFC_MP_PERI                 0x00600000 /* Memory to Peripheral with Peripheral as flow controller */
+#define dmacHw_REG_CTL_TTFC_PP_DPERI                0x00700000 /* Peripheral to Peripheral with Destination Peripheral as flow controller */
+
+#define dmacHw_REG_CTL_DMS_MASK                     0x01800000 /* Destination AHB master interface */
+#define dmacHw_REG_CTL_DMS_1                        0x00000000 /* Destination AHB master interface 1 */
+#define dmacHw_REG_CTL_DMS_2                        0x00800000 /* Destination AHB master interface 2 */
+
+#define dmacHw_REG_CTL_SMS_MASK                     0x06000000 /* Source AHB master interface */
+#define dmacHw_REG_CTL_SMS_1                        0x00000000 /* Source AHB master interface 1 */
+#define dmacHw_REG_CTL_SMS_2                        0x02000000 /* Source AHB master interface 2 */
+
+#define dmacHw_REG_CTL_LLP_DST_EN                   0x08000000 /* Block chaining enable for destination side */
+#define dmacHw_REG_CTL_LLP_SRC_EN                   0x10000000 /* Block chaining enable for source side */
+
+/* Bit mask for REG_DMACx_CTL_HI */
+#define dmacHw_REG_CTL_BLOCK_TS_MASK                0x00000FFF /* Block transfer size */
+#define dmacHw_REG_CTL_DONE                         0x00001000 /* Block trasnfer done */
+
+/* Bit mask for REG_DMACx_CFG_LO */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_SHIFT                  5 /* Channel priority shift */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_MASK          0x000000E0 /* Channel priority mask */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_0             0x00000000 /* Channel priority 0 */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_1             0x00000020 /* Channel priority 1 */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_2             0x00000040 /* Channel priority 2 */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_3             0x00000060 /* Channel priority 3 */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_4             0x00000080 /* Channel priority 4 */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_5             0x000000A0 /* Channel priority 5 */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_6             0x000000C0 /* Channel priority 6 */
+#define dmacHw_REG_CFG_LO_CH_PRIORITY_7             0x000000E0 /* Channel priority 7 */
+
+#define dmacHw_REG_CFG_LO_CH_SUSPEND                0x00000100 /* Channel suspend */
+#define dmacHw_REG_CFG_LO_CH_FIFO_EMPTY             0x00000200 /* Channel FIFO empty */
+#define dmacHw_REG_CFG_LO_DST_CH_SW_HS              0x00000400 /* Destination channel SW handshaking */
+#define dmacHw_REG_CFG_LO_SRC_CH_SW_HS              0x00000800 /* Source channel SW handshaking */
+
+#define dmacHw_REG_CFG_LO_CH_LOCK_MASK              0x00003000 /* Channel locking mask */
+#define dmacHw_REG_CFG_LO_CH_LOCK_DMA               0x00000000 /* Channel lock over the entire DMA transfer operation */
+#define dmacHw_REG_CFG_LO_CH_LOCK_BLOCK             0x00001000 /* Channel lock over the block transfer operation */
+#define dmacHw_REG_CFG_LO_CH_LOCK_TRANS             0x00002000 /* Channel lock over the transaction */
+#define dmacHw_REG_CFG_LO_CH_LOCK_ENABLE            0x00010000 /* Channel lock enable */
+
+#define dmacHw_REG_CFG_LO_BUS_LOCK_MASK             0x0000C000 /* Bus locking mask */
+#define dmacHw_REG_CFG_LO_BUS_LOCK_DMA              0x00000000 /* Bus lock over the entire DMA transfer operation */
+#define dmacHw_REG_CFG_LO_BUS_LOCK_BLOCK            0x00004000 /* Bus lock over the block transfer operation */
+#define dmacHw_REG_CFG_LO_BUS_LOCK_TRANS            0x00008000 /* Bus lock over the transaction */
+#define dmacHw_REG_CFG_LO_BUS_LOCK_ENABLE           0x00020000 /* Bus lock enable */
+
+#define dmacHw_REG_CFG_LO_DST_HS_POLARITY_LOW       0x00040000 /* Destination channel handshaking signal polarity low */
+#define dmacHw_REG_CFG_LO_SRC_HS_POLARITY_LOW       0x00080000 /* Source channel handshaking signal polarity low */
+
+#define dmacHw_REG_CFG_LO_MAX_AMBA_BURST_LEN_MASK   0x3FF00000 /* Maximum AMBA burst length */
+
+#define dmacHw_REG_CFG_LO_AUTO_RELOAD_SRC           0x40000000 /* Source address auto reload */
+#define dmacHw_REG_CFG_LO_AUTO_RELOAD_DST           0x80000000 /* Destination address auto reload */
+
+/* Bit mask for REG_DMACx_CFG_HI */
+#define dmacHw_REG_CFG_HI_FC_DST_READY              0x00000001 /* Source transaction request is serviced when destination is ready */
+#define dmacHw_REG_CFG_HI_FIFO_ENOUGH               0x00000002 /* Initiate burst transaction when enough data in available in FIFO */
+
+#define dmacHw_REG_CFG_HI_AHB_HPROT_MASK            0x0000001C /* AHB protection mask */
+#define dmacHw_REG_CFG_HI_AHB_HPROT_1               0x00000004 /* AHB protection 1 */
+#define dmacHw_REG_CFG_HI_AHB_HPROT_2               0x00000008 /* AHB protection 2 */
+#define dmacHw_REG_CFG_HI_AHB_HPROT_3               0x00000010 /* AHB protection 3 */
+
+#define dmacHw_REG_CFG_HI_UPDATE_DST_STAT           0x00000020 /* Destination status update enable */
+#define dmacHw_REG_CFG_HI_UPDATE_SRC_STAT           0x00000040 /* Source status update enable */
+
+#define dmacHw_REG_CFG_HI_SRC_PERI_INTF_MASK        0x00000780 /* Source peripheral hardware interface mask */
+#define dmacHw_REG_CFG_HI_DST_PERI_INTF_MASK        0x00007800 /* Destination peripheral hardware interface mask */
+
+/* DMA Configuration Parameters */
+#define dmacHw_REG_COMP_PARAM_NUM_CHANNELS          0x00000700 /* Number of channels */
+#define dmacHw_REG_COMP_PARAM_NUM_INTERFACE         0x00001800 /* Number of master interface */
+#define dmacHw_REG_COMP_PARAM_MAX_BLK_SIZE          0x0000000f /* Maximum brust size */
+#define dmacHw_REG_COMP_PARAM_DATA_WIDTH            0x00006000 /* Data transfer width */
+
+/* Define GET/SET macros to program the registers */
+#define dmacHw_SET_SAR(module, channel, addr)          (dmacHw_REG_SAR((module), (channel)) = (uint32_t) (addr))
+#define dmacHw_SET_DAR(module, channel, addr)          (dmacHw_REG_DAR((module), (channel)) = (uint32_t) (addr))
+#define dmacHw_SET_LLP(module, channel, ptr)           (dmacHw_REG_LLP((module), (channel)) = (uint32_t) (ptr))
+
+#define dmacHw_GET_SSTAT(module, channel)              (dmacHw_REG_SSTAT((module), (channel)))
+#define dmacHw_GET_DSTAT(module, channel)              (dmacHw_REG_DSTAT((module), (channel)))
+
+#define dmacHw_SET_SSTATAR(module, channel, addr)      (dmacHw_REG_SSTATAR((module), (channel)) = (uint32_t) (addr))
+#define dmacHw_SET_DSTATAR(module, channel, addr)      (dmacHw_REG_DSTATAR((module), (channel)) = (uint32_t) (addr))
+
+#define dmacHw_SET_CONTROL_LO(module, channel, ctl)    (dmacHw_REG_CTL_LO((module), (channel)) |= (ctl))
+#define dmacHw_RESET_CONTROL_LO(module, channel)       (dmacHw_REG_CTL_LO((module), (channel)) = 0)
+#define dmacHw_GET_CONTROL_LO(module, channel)         (dmacHw_REG_CTL_LO((module), (channel)))
+
+#define dmacHw_SET_CONTROL_HI(module, channel, ctl)    (dmacHw_REG_CTL_HI((module), (channel)) |= (ctl))
+#define dmacHw_RESET_CONTROL_HI(module, channel)       (dmacHw_REG_CTL_HI((module), (channel)) = 0)
+#define dmacHw_GET_CONTROL_HI(module, channel)         (dmacHw_REG_CTL_HI((module), (channel)))
+
+#define dmacHw_GET_BLOCK_SIZE(module, channel)         (dmacHw_REG_CTL_HI((module), (channel)) & dmacHw_REG_CTL_BLOCK_TS_MASK)
+#define dmacHw_DMA_COMPLETE(module, channel)           (dmacHw_REG_CTL_HI((module), (channel)) & dmacHw_REG_CTL_DONE)
+
+#define dmacHw_SET_CONFIG_LO(module, channel, cfg)     (dmacHw_REG_CFG_LO((module), (channel)) |= (cfg))
+#define dmacHw_RESET_CONFIG_LO(module, channel)        (dmacHw_REG_CFG_LO((module), (channel)) = 0)
+#define dmacHw_GET_CONFIG_LO(module, channel)          (dmacHw_REG_CFG_LO((module), (channel)))
+#define dmacHw_SET_AMBA_BUSRT_LEN(module, channel, len)    (dmacHw_REG_CFG_LO((module), (channel)) = (dmacHw_REG_CFG_LO((module), (channel)) & ~(dmacHw_REG_CFG_LO_MAX_AMBA_BURST_LEN_MASK)) | (((len) << 20) & dmacHw_REG_CFG_LO_MAX_AMBA_BURST_LEN_MASK))
+#define dmacHw_SET_CHANNEL_PRIORITY(module, channel, prio) (dmacHw_REG_CFG_LO((module), (channel)) = (dmacHw_REG_CFG_LO((module), (channel)) & ~(dmacHw_REG_CFG_LO_CH_PRIORITY_MASK)) | (prio))
+#define dmacHw_SET_AHB_HPROT(module, channel, protect)  (dmacHw_REG_CFG_HI(module, channel) = (dmacHw_REG_CFG_HI((module), (channel)) & ~(dmacHw_REG_CFG_HI_AHB_HPROT_MASK)) | (protect))
+
+#define dmacHw_SET_CONFIG_HI(module, channel, cfg)      (dmacHw_REG_CFG_HI((module), (channel)) |= (cfg))
+#define dmacHw_RESET_CONFIG_HI(module, channel)         (dmacHw_REG_CFG_HI((module), (channel)) = 0)
+#define dmacHw_GET_CONFIG_HI(module, channel)           (dmacHw_REG_CFG_HI((module), (channel)))
+#define dmacHw_SET_SRC_PERI_INTF(module, channel, intf) (dmacHw_REG_CFG_HI((module), (channel)) = (dmacHw_REG_CFG_HI((module), (channel)) & ~(dmacHw_REG_CFG_HI_SRC_PERI_INTF_MASK)) | (((intf) << 7) & dmacHw_REG_CFG_HI_SRC_PERI_INTF_MASK))
+#define dmacHw_SRC_PERI_INTF(intf)                      (((intf) << 7) & dmacHw_REG_CFG_HI_SRC_PERI_INTF_MASK)
+#define dmacHw_SET_DST_PERI_INTF(module, channel, intf) (dmacHw_REG_CFG_HI((module), (channel)) = (dmacHw_REG_CFG_HI((module), (channel)) & ~(dmacHw_REG_CFG_HI_DST_PERI_INTF_MASK)) | (((intf) << 11) & dmacHw_REG_CFG_HI_DST_PERI_INTF_MASK))
+#define dmacHw_DST_PERI_INTF(intf)                      (((intf) << 11) & dmacHw_REG_CFG_HI_DST_PERI_INTF_MASK)
+
+#define dmacHw_DMA_START(module, channel)              (dmacHw_REG_MISC_CH_ENABLE((module)) = (0x00000001 << ((channel) + 8)) | (0x00000001 << (channel)))
+#define dmacHw_DMA_STOP(module, channel)               (dmacHw_REG_MISC_CH_ENABLE((module)) = (0x00000001 << ((channel) + 8)))
+#define dmacHw_DMA_ENABLE(module)                      (dmacHw_REG_MISC_CFG((module)) = 1)
+#define dmacHw_DMA_DISABLE(module)                     (dmacHw_REG_MISC_CFG((module)) = 0)
+
+#define dmacHw_TRAN_INT_ENABLE(module, channel)        (dmacHw_REG_INT_MASK_TRAN((module)) = (0x00000001 << ((channel) + 8)) | (0x00000001 << (channel)))
+#define dmacHw_BLOCK_INT_ENABLE(module, channel)       (dmacHw_REG_INT_MASK_BLOCK((module)) = (0x00000001 << ((channel) + 8)) | (0x00000001 << (channel)))
+#define dmacHw_ERROR_INT_ENABLE(module, channel)       (dmacHw_REG_INT_MASK_ERROR((module)) = (0x00000001 << ((channel) + 8)) | (0x00000001 << (channel)))
+
+#define dmacHw_TRAN_INT_DISABLE(module, channel)       (dmacHw_REG_INT_MASK_TRAN((module)) = (0x00000001 << ((channel) + 8)))
+#define dmacHw_BLOCK_INT_DISABLE(module, channel)      (dmacHw_REG_INT_MASK_BLOCK((module)) = (0x00000001 << ((channel) + 8)))
+#define dmacHw_ERROR_INT_DISABLE(module, channel)      (dmacHw_REG_INT_MASK_ERROR((module)) = (0x00000001 << ((channel) + 8)))
+#define dmacHw_STRAN_INT_DISABLE(module, channel)      (dmacHw_REG_INT_MASK_STRAN((module)) = (0x00000001 << ((channel) + 8)))
+#define dmacHw_DTRAN_INT_DISABLE(module, channel)      (dmacHw_REG_INT_MASK_DTRAN((module)) = (0x00000001 << ((channel) + 8)))
+
+#define dmacHw_TRAN_INT_CLEAR(module, channel)         (dmacHw_REG_INT_CLEAR_TRAN((module)) = (0x00000001 << (channel)))
+#define dmacHw_BLOCK_INT_CLEAR(module, channel)        (dmacHw_REG_INT_CLEAR_BLOCK((module)) = (0x00000001 << (channel)))
+#define dmacHw_ERROR_INT_CLEAR(module, channel)        (dmacHw_REG_INT_CLEAR_ERROR((module)) = (0x00000001 << (channel)))
+
+#define dmacHw_GET_NUM_CHANNEL(module)                 (((dmacHw_REG_MISC_COMP_PARAM1_HI((module)) & dmacHw_REG_COMP_PARAM_NUM_CHANNELS) >> 8) + 1)
+#define dmacHw_GET_NUM_INTERFACE(module)               (((dmacHw_REG_MISC_COMP_PARAM1_HI((module)) & dmacHw_REG_COMP_PARAM_NUM_INTERFACE) >> 11) + 1)
+#define dmacHw_GET_MAX_BLOCK_SIZE(module, channel)     ((dmacHw_REG_MISC_COMP_PARAM1_LO((module)) >> (4 * (channel))) & dmacHw_REG_COMP_PARAM_MAX_BLK_SIZE)
+#define dmacHw_GET_CHANNEL_DATA_WIDTH(module, channel) ((dmacHw_REG_MISC_COMP_PARAM1_HI((module)) & dmacHw_REG_COMP_PARAM_DATA_WIDTH) >> 13)
+
+#endif /* _DMACHW_REG_H */
diff --git a/arch/arm/mach-bcmring/include/mach/dma.h b/arch/arm/mach-bcmring/include/mach/dma.h
new file mode 100644
index 0000000..847980c
--- /dev/null
+++ b/arch/arm/mach-bcmring/include/mach/dma.h
@@ -0,0 +1,826 @@
+/*****************************************************************************
+* Copyright 2004 - 2008 Broadcom Corporation.  All rights reserved.
+*
+* Unless you and Broadcom execute a separate written software license
+* agreement governing use of this software, this software is licensed to you
+* under the terms of the GNU General Public License version 2, available at
+* http://www.broadcom.com/licenses/GPLv2.php (the "GPL").
+*
+* Notwithstanding the above, under no circumstances may you combine this
+* software in any way with any other Broadcom software provided under a
+* license other than the GPL, without Broadcom's express prior written
+* consent.
+*****************************************************************************/
+
+/****************************************************************************/
+/**
+*   @file   dma.h
+*
+*   @brief  API definitions for the linux DMA interface.
+*/
+/****************************************************************************/
+
+#if !defined(ASM_ARM_ARCH_BCMRING_DMA_H)
+#define ASM_ARM_ARCH_BCMRING_DMA_H
+
+/* ---- Include Files ---------------------------------------------------- */
+
+#include <linux/kernel.h>
+#include <linux/wait.h>
+#include <linux/semaphore.h>
+#include <csp/dmacHw.h>
+#include <mach/timer.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/pagemap.h>
+
+/* ---- Constants and Types ---------------------------------------------- */
+
+/* If DMA_DEBUG_TRACK_RESERVATION is set to a non-zero value, then the filename */
+/* and line number of the reservation request will be recorded in the channel table */
+
+#define DMA_DEBUG_TRACK_RESERVATION   1
+
+#define DMA_NUM_CONTROLLERS     2
+#define DMA_NUM_CHANNELS        8      /* per controller */
+
+typedef enum {
+       DMA_DEVICE_MEM_TO_MEM,  /* For memory to memory transfers */
+       DMA_DEVICE_I2S0_DEV_TO_MEM,
+       DMA_DEVICE_I2S0_MEM_TO_DEV,
+       DMA_DEVICE_I2S1_DEV_TO_MEM,
+       DMA_DEVICE_I2S1_MEM_TO_DEV,
+       DMA_DEVICE_APM_CODEC_A_DEV_TO_MEM,
+       DMA_DEVICE_APM_CODEC_A_MEM_TO_DEV,
+       DMA_DEVICE_APM_CODEC_B_DEV_TO_MEM,
+       DMA_DEVICE_APM_CODEC_B_MEM_TO_DEV,
+       DMA_DEVICE_APM_CODEC_C_DEV_TO_MEM,      /* Additional mic input for beam-forming */
+       DMA_DEVICE_APM_PCM0_DEV_TO_MEM,
+       DMA_DEVICE_APM_PCM0_MEM_TO_DEV,
+       DMA_DEVICE_APM_PCM1_DEV_TO_MEM,
+       DMA_DEVICE_APM_PCM1_MEM_TO_DEV,
+       DMA_DEVICE_SPUM_DEV_TO_MEM,
+       DMA_DEVICE_SPUM_MEM_TO_DEV,
+       DMA_DEVICE_SPIH_DEV_TO_MEM,
+       DMA_DEVICE_SPIH_MEM_TO_DEV,
+       DMA_DEVICE_UART_A_DEV_TO_MEM,
+       DMA_DEVICE_UART_A_MEM_TO_DEV,
+       DMA_DEVICE_UART_B_DEV_TO_MEM,
+       DMA_DEVICE_UART_B_MEM_TO_DEV,
+       DMA_DEVICE_PIF_MEM_TO_DEV,
+       DMA_DEVICE_PIF_DEV_TO_MEM,
+       DMA_DEVICE_ESW_DEV_TO_MEM,
+       DMA_DEVICE_ESW_MEM_TO_DEV,
+       DMA_DEVICE_VPM_MEM_TO_MEM,
+       DMA_DEVICE_CLCD_MEM_TO_MEM,
+       DMA_DEVICE_NAND_MEM_TO_MEM,
+       DMA_DEVICE_MEM_TO_VRAM,
+       DMA_DEVICE_VRAM_TO_MEM,
+
+       /* Add new entries before this line. */
+
+       DMA_NUM_DEVICE_ENTRIES,
+       DMA_DEVICE_NONE = 0xff, /* Special value to indicate that no device is currently assigned. */
+
+} DMA_Device_t;
+
+/****************************************************************************
+*
+*   The DMA_Handle_t is the primary object used by callers of the API.
+*
+*****************************************************************************/
+
+#define DMA_INVALID_HANDLE  ((DMA_Handle_t) -1)
+
+typedef int DMA_Handle_t;
+
+/****************************************************************************
+*
+*   The DMA_DescriptorRing_t contains a ring of descriptors which is used
+*   to point to regions of memory.
+*
+*****************************************************************************/
+
+typedef struct {
+       void *virtAddr;         /* Virtual Address of the descriptor ring */
+       dma_addr_t physAddr;    /* Physical address of the descriptor ring */
+       int descriptorsAllocated;       /* Number of descriptors allocated in the descriptor ring */
+       size_t bytesAllocated;  /* Number of bytes allocated in the descriptor ring */
+
+} DMA_DescriptorRing_t;
+
+/****************************************************************************
+*
+*   The DMA_MemType_t and DMA_MemMap_t are helper structures used to setup
+*   DMA chains from a variety of memory sources.
+*
+*****************************************************************************/
+
+#define DMA_MEM_MAP_MIN_SIZE    4096   /* Pages less than this size are better */
+                                       /* off not being DMA'd. */
+
+typedef enum {
+       DMA_MEM_TYPE_NONE,      /* Not a valid setting */
+       DMA_MEM_TYPE_VMALLOC,   /* Memory came from vmalloc call */
+       DMA_MEM_TYPE_KMALLOC,   /* Memory came from kmalloc call */
+       DMA_MEM_TYPE_DMA,       /* Memory came from dma_alloc_xxx call */
+       DMA_MEM_TYPE_USER,      /* Memory came from user space. */
+
+} DMA_MemType_t;
+
+/* A segment represents a physically and virtually contiguous chunk of memory. */
+/* i.e. each segment can be DMA'd */
+/* A user of the DMA code will add memory regions. Each region may need to be */
+/* represented by one or more segments. */
+
+typedef struct {
+       void *virtAddr;         /* Virtual address used for this segment */
+       dma_addr_t physAddr;    /* Physical address this segment maps to */
+       size_t numBytes;        /* Size of the segment, in bytes */
+
+} DMA_Segment_t;
+
+/* A region represents a virtually contiguous chunk of memory, which may be */
+/* made up of multiple segments. */
+
+typedef struct {
+       DMA_MemType_t memType;
+       void *virtAddr;
+       size_t numBytes;
+
+       /* Each region (virtually contiguous) consists of one or more segments. Each */
+       /* segment is virtually and physically contiguous. */
+
+       int numSegmentsUsed;
+       int numSegmentsAllocated;
+       DMA_Segment_t *segment;
+
+       /* When a region corresponds to user memory, we need to lock all of the pages */
+       /* down before we can figure out the physical addresses. The lockedPage array contains */
+       /* the pages that were locked, and which subsequently need to be unlocked once the */
+       /* memory is unmapped. */
+
+       unsigned numLockedPages;
+       struct page **lockedPages;
+
+} DMA_Region_t;
+
+typedef struct {
+       int inUse;              /* Is this mapping currently being used? */
+       struct semaphore lock;  /* Acquired when using this structure */
+       enum dma_data_direction dir;    /* Direction this transfer is intended for */
+
+       /* In the event that we're mapping user memory, we need to know which task */
+       /* the memory is for, so that we can obtain the correct mm locks. */
+
+       struct task_struct *userTask;
+
+       int numRegionsUsed;
+       int numRegionsAllocated;
+       DMA_Region_t *region;
+
+} DMA_MemMap_t;
+
+/****************************************************************************
+*
+*   The DMA_DeviceAttribute_t contains information which describes a
+*   particular DMA device (or peripheral).
+*
+*   It is anticipated that the arrary of DMA_DeviceAttribute_t's will be
+*   statically initialized.
+*
+*****************************************************************************/
+
+/* The device handler is called whenever a DMA operation completes. The reaon */
+/* for it to be called will be a bitmask with one or more of the following bits */
+/* set. */
+
+#define DMA_HANDLER_REASON_BLOCK_COMPLETE       dmacHw_INTERRUPT_STATUS_BLOCK
+#define DMA_HANDLER_REASON_TRANSFER_COMPLETE    dmacHw_INTERRUPT_STATUS_TRANS
+#define DMA_HANDLER_REASON_ERROR                dmacHw_INTERRUPT_STATUS_ERROR
+
+typedef void (*DMA_DeviceHandler_t) (DMA_Device_t dev, int reason,
+                                    void *userData);
+
+#define DMA_DEVICE_FLAG_ON_DMA0             0x00000001
+#define DMA_DEVICE_FLAG_ON_DMA1             0x00000002
+#define DMA_DEVICE_FLAG_PORT_PER_DMAC       0x00000004 /* If set, it means that the port used on DMAC0 is different from the port used on DMAC1 */
+#define DMA_DEVICE_FLAG_ALLOC_DMA1_FIRST    0x00000008 /* If set, allocate from DMA1 before allocating from DMA0 */
+#define DMA_DEVICE_FLAG_IS_DEDICATED        0x00000100
+#define DMA_DEVICE_FLAG_NO_ISR              0x00000200
+#define DMA_DEVICE_FLAG_ALLOW_LARGE_FIFO    0x00000400
+#define DMA_DEVICE_FLAG_IN_USE              0x00000800 /* If set, device is in use on a channel */
+
+/* Note: Some DMA devices can be used from multiple DMA Controllers. The bitmask is used to */
+/*       determine which DMA controllers a given device can be used from, and the interface */
+/*       array determeines the actual interface number to use for a given controller. */
+
+typedef struct {
+       uint32_t flags;         /* Bitmask of DMA_DEVICE_FLAG_xxx constants */
+       uint8_t dedicatedController;    /* Controller number to use if DMA_DEVICE_FLAG_IS_DEDICATED is set. */
+       uint8_t dedicatedChannel;       /* Channel number to use if DMA_DEVICE_FLAG_IS_DEDICATED is set. */
+       const char *name;       /* Will show up in the /proc entry */
+
+       uint32_t dmacPort[DMA_NUM_CONTROLLERS]; /* Specifies the port number when DMA_DEVICE_FLAG_PORT_PER_DMAC flag is set */
+
+       dmacHw_CONFIG_t config; /* Configuration to use when DMA'ing using this device */
+
+       void *userData;         /* Passed to the devHandler */
+       DMA_DeviceHandler_t devHandler; /* Called when DMA operations finish. */
+
+       timer_tick_count_t transferStartTime;   /* Time the current transfer was started */
+
+       /* The following statistical information will be collected and presented in a proc entry. */
+       /* Note: With a contiuous bandwidth of 1 Gb/sec, it would take 584 years to overflow */
+       /*       a 64 bit counter. */
+
+       uint64_t numTransfers;  /* Number of DMA transfers performed */
+       uint64_t transferTicks; /* Total time spent doing DMA transfers (measured in timer_tick_count_t's) */
+       uint64_t transferBytes; /* Total bytes transferred */
+       uint32_t timesBlocked;  /* Number of times a channel was unavailable */
+       uint32_t numBytes;      /* Last transfer size */
+
+       /* It's not possible to free memory which is allocated for the descriptors from within */
+       /* the ISR. So make the presumption that a given device will tend to use the */
+       /* same sized buffers over and over again, and we keep them around. */
+
+       DMA_DescriptorRing_t ring;      /* Ring of descriptors allocated for this device */
+
+       /* We stash away some of the information from the previous transfer. If back-to-back */
+       /* transfers are performed from the same buffer, then we don't have to keep re-initializing */
+       /* the descriptor buffers. */
+
+       uint32_t prevNumBytes;
+       dma_addr_t prevSrcData;
+       dma_addr_t prevDstData;
+
+} DMA_DeviceAttribute_t;
+
+/****************************************************************************
+*
+*   DMA_Channel_t, DMA_Controller_t, and DMA_State_t are really internal
+*   data structures and don't belong in this header file, but are included
+*   merely for discussion.
+*
+*   By the time this is implemented, these structures will be moved out into
+*   the appropriate C source file instead.
+*
+*****************************************************************************/
+
+/****************************************************************************
+*
+*   The DMA_Channel_t contains state information about each DMA channel. Some
+*   of the channels are dedicated. Non-dedicated channels are shared
+*   amongst the other devices.
+*
+*****************************************************************************/
+
+#define DMA_CHANNEL_FLAG_IN_USE         0x00000001
+#define DMA_CHANNEL_FLAG_IS_DEDICATED   0x00000002
+#define DMA_CHANNEL_FLAG_NO_ISR         0x00000004
+#define DMA_CHANNEL_FLAG_LARGE_FIFO     0x00000008
+
+typedef struct {
+       uint32_t flags;         /* bitmask of DMA_CHANNEL_FLAG_xxx constants */
+       DMA_Device_t devType;   /* Device this channel is currently reserved for */
+       DMA_Device_t lastDevType;       /* Device type that used this previously */
+       char name[20];          /* Name passed onto request_irq */
+
+#if (DMA_DEBUG_TRACK_RESERVATION)
+       const char *fileName;   /* Place where channel reservation took place */
+       int lineNum;            /* Place where channel reservation took place */
+#endif
+       dmacHw_HANDLE_t dmacHwHandle;   /* low level channel handle. */
+
+} DMA_Channel_t;
+
+/****************************************************************************
+*
+*   The DMA_Controller_t contains state information about each DMA controller.
+*
+*   The freeChannelQ is stored in the controller data structure rather than
+*   the channel data structure since several of the devices are accessible
+*   from multiple controllers, and there is no way to know which controller
+*   will become available first.
+*
+*****************************************************************************/
+
+typedef struct {
+       DMA_Channel_t channel[DMA_NUM_CHANNELS];
+
+} DMA_Controller_t;
+
+/****************************************************************************
+*
+*   The DMA_Global_t contains all of the global state information used by
+*   the DMA code.
+*
+*   Callers which need to allocate a shared channel will be queued up
+*   on the freeChannelQ until a channel becomes available.
+*
+*****************************************************************************/
+
+typedef struct {
+       struct semaphore lock;  /* acquired when manipulating table entries */
+       wait_queue_head_t freeChannelQ;
+
+       DMA_Controller_t controller[DMA_NUM_CONTROLLERS];
+
+} DMA_Global_t;
+
+/* ---- Variable Externs ------------------------------------------------- */
+
+extern DMA_DeviceAttribute_t DMA_gDeviceAttribute[DMA_NUM_DEVICE_ENTRIES];
+
+/* ---- Function Prototypes ---------------------------------------------- */
+
+#if defined(__KERNEL__)
+
+/****************************************************************************/
+/**
+*   Initializes the DMA module.
+*
+*   @return
+*       0       - Success
+*       < 0     - Error
+*/
+/****************************************************************************/
+
+int dma_init(void);
+
+#if (DMA_DEBUG_TRACK_RESERVATION)
+DMA_Handle_t dma_request_channel_dbg(DMA_Device_t dev, const char *fileName,
+                                    int lineNum);
+#define dma_request_channel(dev)  dma_request_channel_dbg(dev, __FILE__, __LINE__)
+#else
+
+/****************************************************************************/
+/**
+*   Reserves a channel for use with @a dev. If the device is setup to use
+*   a shared channel, then this function will block until a free channel
+*   becomes available.
+*
+*   @return
+*       >= 0    - A valid DMA Handle.
+*       -EBUSY  - Device is currently being used.
+*       -ENODEV - Device handed in is invalid.
+*/
+/****************************************************************************/
+
+DMA_Handle_t dma_request_channel(DMA_Device_t dev      /* Device to use with the allocated channel. */
+    );
+#endif
+
+/****************************************************************************/
+/**
+*   Frees a previously allocated DMA Handle.
+*
+*   @return
+*        0      - DMA Handle was released successfully.
+*       -EINVAL - Invalid DMA handle
+*/
+/****************************************************************************/
+
+int dma_free_channel(DMA_Handle_t channel      /* DMA handle. */
+    );
+
+/****************************************************************************/
+/**
+*   Determines if a given device has been configured as using a shared
+*   channel.
+*
+*   @return boolean
+*       0           Device uses a dedicated channel
+*       non-zero    Device uses a shared channel
+*/
+/****************************************************************************/
+
+int dma_device_is_channel_shared(DMA_Device_t dev      /* Device to check. */
+    );
+
+/****************************************************************************/
+/**
+*   Allocates memory to hold a descriptor ring. The descriptor ring then
+*   needs to be populated by making one or more calls to
+*   dna_add_descriptors.
+*
+*   The returned descriptor ring will be automatically initialized.
+*
+*   @return
+*       0           Descriptor ring was allocated successfully
+*       -ENOMEM     Unable to allocate memory for the desired number of descriptors.
+*/
+/****************************************************************************/
+
+int dma_alloc_descriptor_ring(DMA_DescriptorRing_t *ring,      /* Descriptor ring to populate */
+                             int numDescriptors        /* Number of descriptors that need to be allocated. */
+    );
+
+/****************************************************************************/
+/**
+*   Releases the memory which was previously allocated for a descriptor ring.
+*/
+/****************************************************************************/
+
+void dma_free_descriptor_ring(DMA_DescriptorRing_t *ring       /* Descriptor to release */
+    );
+
+/****************************************************************************/
+/**
+*   Initializes a descriptor ring, so that descriptors can be added to it.
+*   Once a descriptor ring has been allocated, it may be reinitialized for
+*   use with additional/different regions of memory.
+*
+*   Note that if 7 descriptors are allocated, it's perfectly acceptable to
+*   initialize the ring with a smaller number of descriptors. The amount
+*   of memory allocated for the descriptor ring will not be reduced, and
+*   the descriptor ring may be reinitialized later
+*
+*   @return
+*       0           Descriptor ring was initialized successfully
+*       -ENOMEM     The descriptor which was passed in has insufficient space
+*                   to hold the desired number of descriptors.
+*/
+/****************************************************************************/
+
+int dma_init_descriptor_ring(DMA_DescriptorRing_t *ring,       /* Descriptor ring to initialize */
+                            int numDescriptors /* Number of descriptors to initialize. */
+    );
+
+/****************************************************************************/
+/**
+*   Determines the number of descriptors which would be required for a
+*   transfer of the indicated memory region.
+*
+*   This function also needs to know which DMA device this transfer will
+*   be destined for, so that the appropriate DMA configuration can be retrieved.
+*   DMA parameters such as transfer width, and whether this is a memory-to-memory
+*   or memory-to-peripheral, etc can all affect the actual number of descriptors
+*   required.
+*
+*   @return
+*       > 0     Returns the number of descriptors required for the indicated transfer
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _MEM_TO_DEV and not _DEV_TO_MEM)
+*       -ENOMEM Memory exhausted
+*/
+/****************************************************************************/
+
+int dma_calculate_descriptor_count(DMA_Device_t device,        /* DMA Device that this will be associated with */
+                                  dma_addr_t srcData,  /* Place to get data to write to device */
+                                  dma_addr_t dstData,  /* Pointer to device data address */
+                                  size_t numBytes      /* Number of bytes to transfer to the device */
+    );
+
+/****************************************************************************/
+/**
+*   Adds a region of memory to the descriptor ring. Note that it may take
+*   multiple descriptors for each region of memory. It is the callers
+*   responsibility to allocate a sufficiently large descriptor ring.
+*
+*   @return
+*       0       Descriptors were added successfully
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _MEM_TO_DEV and not _DEV_TO_MEM)
+*       -ENOMEM Memory exhausted
+*/
+/****************************************************************************/
+
+int dma_add_descriptors(DMA_DescriptorRing_t *ring,    /* Descriptor ring to add descriptors to */
+                       DMA_Device_t device,    /* DMA Device that descriptors are for */
+                       dma_addr_t srcData,     /* Place to get data (memory or device) */
+                       dma_addr_t dstData,     /* Place to put data (memory or device) */
+                       size_t numBytes /* Number of bytes to transfer to the device */
+    );
+
+/****************************************************************************/
+/**
+*   Sets the descriptor ring associated with a device.
+*
+*   Once set, the descriptor ring will be associated with the device, even
+*   across channel request/free calls. Passing in a NULL descriptor ring
+*   will release any descriptor ring currently associated with the device.
+*
+*   Note: If you call dma_transfer, or one of the other dma_alloc_ functions
+*         the descriptor ring may be released and reallocated.
+*
+*   Note: This function will release the descriptor memory for any current
+*         descriptor ring associated with this device.
+*/
+/****************************************************************************/
+
+int dma_set_device_descriptor_ring(DMA_Device_t device,        /* Device to update the descriptor ring for. */
+                                  DMA_DescriptorRing_t *ring   /* Descriptor ring to add descriptors to */
+    );
+
+/****************************************************************************/
+/**
+*   Retrieves the descriptor ring associated with a device.
+*/
+/****************************************************************************/
+
+int dma_get_device_descriptor_ring(DMA_Device_t device,        /* Device to retrieve the descriptor ring for. */
+                                  DMA_DescriptorRing_t *ring   /* Place to store retrieved ring */
+    );
+
+/****************************************************************************/
+/**
+*   Allocates buffers for the descriptors. This is normally done automatically
+*   but needs to be done explicitly when initiating a dma from interrupt
+*   context.
+*
+*   @return
+*       0       Descriptors were allocated successfully
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _MEM_TO_DEV and not _DEV_TO_MEM)
+*       -ENOMEM Memory exhausted
+*/
+/****************************************************************************/
+
+int dma_alloc_descriptors(DMA_Handle_t handle, /* DMA Handle */
+                         dmacHw_TRANSFER_TYPE_e transferType,  /* Type of transfer being performed */
+                         dma_addr_t srcData,   /* Place to get data to write to device */
+                         dma_addr_t dstData,   /* Pointer to device data address */
+                         size_t numBytes       /* Number of bytes to transfer to the device */
+    );
+
+/****************************************************************************/
+/**
+*   Allocates and sets up descriptors for a double buffered circular buffer.
+*
+*   This is primarily intended to be used for things like the ingress samples
+*   from a microphone.
+*
+*   @return
+*       > 0     Number of descriptors actually allocated.
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _MEM_TO_DEV and not _DEV_TO_MEM)
+*       -ENOMEM Memory exhausted
+*/
+/****************************************************************************/
+
+int dma_alloc_double_dst_descriptors(DMA_Handle_t handle,      /* DMA Handle */
+                                    dma_addr_t srcData,        /* Physical address of source data */
+                                    dma_addr_t dstData1,       /* Physical address of first destination buffer */
+                                    dma_addr_t dstData2,       /* Physical address of second destination buffer */
+                                    size_t numBytes    /* Number of bytes in each destination buffer */
+    );
+
+/****************************************************************************/
+/**
+*   Initializes a DMA_MemMap_t data structure
+*/
+/****************************************************************************/
+
+int dma_init_mem_map(DMA_MemMap_t *memMap      /* Stores state information about the map */
+    );
+
+/****************************************************************************/
+/**
+*   Releases any memory currently being held by a memory mapping structure.
+*/
+/****************************************************************************/
+
+int dma_term_mem_map(DMA_MemMap_t *memMap      /* Stores state information about the map */
+    );
+
+/****************************************************************************/
+/**
+*   Looks at a memory address and categorizes it.
+*
+*   @return One of the values from the DMA_MemType_t enumeration.
+*/
+/****************************************************************************/
+
+DMA_MemType_t dma_mem_type(void *addr);
+
+/****************************************************************************/
+/**
+*   Sets the process (aka userTask) associated with a mem map. This is
+*   required if user-mode segments will be added to the mapping.
+*/
+/****************************************************************************/
+
+static inline void dma_mem_map_set_user_task(DMA_MemMap_t *memMap,
+                                            struct task_struct *task)
+{
+       memMap->userTask = task;
+}
+
+/****************************************************************************/
+/**
+*   Looks at a memory address and determines if we support DMA'ing to/from
+*   that type of memory.
+*
+*   @return boolean -
+*               return value != 0 means dma supported
+*               return value == 0 means dma not supported
+*/
+/****************************************************************************/
+
+int dma_mem_supports_dma(void *addr);
+
+/****************************************************************************/
+/**
+*   Initializes a memory map for use. Since this function acquires a
+*   sempaphore within the memory map, it is VERY important that dma_unmap
+*   be called when you're finished using the map.
+*/
+/****************************************************************************/
+
+int dma_map_start(DMA_MemMap_t *memMap,        /* Stores state information about the map */
+                 enum dma_data_direction dir   /* Direction that the mapping will be going */
+    );
+
+/****************************************************************************/
+/**
+*   Adds a segment of memory to a memory map.
+*
+*   @return     0 on success, error code otherwise.
+*/
+/****************************************************************************/
+
+int dma_map_add_region(DMA_MemMap_t *memMap,   /* Stores state information about the map */
+                      void *mem,       /* Virtual address that we want to get a map of */
+                      size_t numBytes  /* Number of bytes being mapped */
+    );
+
+/****************************************************************************/
+/**
+*   Creates a descriptor ring from a memory mapping.
+*
+*   @return 0 on sucess, error code otherwise.
+*/
+/****************************************************************************/
+
+int dma_map_create_descriptor_ring(DMA_Device_t dev,   /* DMA device (where the ring is stored) */
+                                  DMA_MemMap_t *memMap,        /* Memory map that will be used */
+                                  dma_addr_t devPhysAddr       /* Physical address of device */
+    );
+
+/****************************************************************************/
+/**
+*   Maps in a memory region such that it can be used for performing a DMA.
+*
+*   @return
+*/
+/****************************************************************************/
+
+int dma_map_mem(DMA_MemMap_t *memMap,  /* Stores state information about the map */
+               void *addr,     /* Virtual address that we want to get a map of */
+               size_t count,   /* Number of bytes being mapped */
+               enum dma_data_direction dir     /* Direction that the mapping will be going */
+    );
+
+/****************************************************************************/
+/**
+*   Maps in a memory region such that it can be used for performing a DMA.
+*
+*   @return
+*/
+/****************************************************************************/
+
+int dma_unmap(DMA_MemMap_t *memMap,    /* Stores state information about the map */
+             int dirtied       /* non-zero if any of the pages were modified */
+    );
+
+/****************************************************************************/
+/**
+*   Initiates a transfer when the descriptors have already been setup.
+*
+*   This is a special case, and normally, the dma_transfer_xxx functions should
+*   be used.
+*
+*   @return
+*       0       Transfer was started successfully
+*       -ENODEV Invalid handle
+*/
+/****************************************************************************/
+
+int dma_start_transfer(DMA_Handle_t handle);
+
+/****************************************************************************/
+/**
+*   Stops a previously started DMA transfer.
+*
+*   @return
+*       0       Transfer was stopped successfully
+*       -ENODEV Invalid handle
+*/
+/****************************************************************************/
+
+int dma_stop_transfer(DMA_Handle_t handle);
+
+/****************************************************************************/
+/**
+*   Waits for a DMA to complete by polling. This function is only intended
+*   to be used for testing. Interrupts should be used for most DMA operations.
+*/
+/****************************************************************************/
+
+int dma_wait_transfer_done(DMA_Handle_t handle);
+
+/****************************************************************************/
+/**
+*   Initiates a DMA transfer
+*
+*   @return
+*       0       Transfer was started successfully
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _MEM_TO_DEV and not _DEV_TO_MEM)
+*/
+/****************************************************************************/
+
+int dma_transfer(DMA_Handle_t handle,  /* DMA Handle */
+                dmacHw_TRANSFER_TYPE_e transferType,   /* Type of transfer being performed */
+                dma_addr_t srcData,    /* Place to get data to write to device */
+                dma_addr_t dstData,    /* Pointer to device data address */
+                size_t numBytes        /* Number of bytes to transfer to the device */
+    );
+
+/****************************************************************************/
+/**
+*   Initiates a transfer from memory to a device.
+*
+*   @return
+*       0       Transfer was started successfully
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _DEV_TO_MEM and not _MEM_TO_DEV)
+*/
+/****************************************************************************/
+
+static inline int dma_transfer_to_device(DMA_Handle_t handle,  /* DMA Handle */
+                                        dma_addr_t srcData,    /* Place to get data to write to device (physical address) */
+                                        dma_addr_t dstData,    /* Pointer to device data address (physical address) */
+                                        size_t numBytes        /* Number of bytes to transfer to the device */
+    ) {
+       return dma_transfer(handle,
+                           dmacHw_TRANSFER_TYPE_MEM_TO_PERIPHERAL,
+                           srcData, dstData, numBytes);
+}
+
+/****************************************************************************/
+/**
+*   Initiates a transfer from a device to memory.
+*
+*   @return
+*       0       Transfer was started successfully
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device is _MEM_TO_DEV and not _DEV_TO_MEM)
+*/
+/****************************************************************************/
+
+static inline int dma_transfer_from_device(DMA_Handle_t handle,        /* DMA Handle */
+                                          dma_addr_t srcData,  /* Pointer to the device data address (physical address) */
+                                          dma_addr_t dstData,  /* Place to store data retrieved from the device (physical address) */
+                                          size_t numBytes      /* Number of bytes to retrieve from the device */
+    ) {
+       return dma_transfer(handle,
+                           dmacHw_TRANSFER_TYPE_PERIPHERAL_TO_MEM,
+                           srcData, dstData, numBytes);
+}
+
+/****************************************************************************/
+/**
+*   Initiates a memory to memory transfer.
+*
+*   @return
+*       0       Transfer was started successfully
+*       -EINVAL Invalid device type for this kind of transfer
+*               (i.e. the device wasn't DMA_DEVICE_MEM_TO_MEM)
+*/
+/****************************************************************************/
+
+static inline int dma_transfer_mem_to_mem(DMA_Handle_t handle, /* DMA Handle */
+                                         dma_addr_t srcData,   /* Place to transfer data from (physical address) */
+                                         dma_addr_t dstData,   /* Place to transfer data to (physical address) */
+                                         size_t numBytes       /* Number of bytes to transfer */
+    ) {
+       return dma_transfer(handle,
+                           dmacHw_TRANSFER_TYPE_MEM_TO_MEM,
+                           srcData, dstData, numBytes);
+}
+
+/****************************************************************************/
+/**
+*   Set the callback function which will be called when a transfer completes.
+*   If a NULL callback function is set, then no callback will occur.
+*
+*   @note   @a devHandler will be called from IRQ context.
+*
+*   @return
+*       0       - Success
+*       -ENODEV - Device handed in is invalid.
+*/
+/****************************************************************************/
+
+int dma_set_device_handler(DMA_Device_t dev,   /* Device to set the callback for. */
+                          DMA_DeviceHandler_t devHandler,      /* Function to call when the DMA completes */
+                          void *userData       /* Pointer which will be passed to devHandler. */
+    );
+
+#endif
+
+#endif /* ASM_ARM_ARCH_BCMRING_DMA_H */
--
1.6.0.6


Leo Hao Chen
Software Engineer
Broadcom Canada Inc.


