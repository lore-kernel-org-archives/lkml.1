Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbZFZXbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbZFZXbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 19:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757652AbZFZXaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 19:30:46 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2305 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757514AbZFZXal convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 19:30:41 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
cc: "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Fri, 26 Jun 2009 16:30:33 -0700
Subject: [PATCH v1 5/6][ARM]  new ARM SoC support: BCMRing
Thread-Topic: [PATCH v1 5/6][ARM]  new ARM SoC support: BCMRing
Thread-Index: Acn2thn21ZdODV5cQhytQsjoMQMt0A==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C7@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 665B85916007097476-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The fifth patch. It includes the nand driver and the nand header files.


>From b8b6c4ee0b7cee5263d881eadd5469e1bac29d42 Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 26 Jun 2009 15:47:50 -0700
Subject: [PATCH 5/6] add bcmring umi nand driver code and header file

---
 drivers/mtd/nand/nand_bcm_umi.c          |  895 ++++++++++++++++++++++++++++++
 drivers/mtd/nand/nand_calculate_ecc512.c |  269 +++++++++
 drivers/mtd/nand/nand_correct_data512.c  |  163 ++++++
 include/linux/mtd/nand_bcm_umi.h         |  236 ++++++++
 include/linux/mtd/nand_ecc512.h          |   26 +
 5 files changed, 1589 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/nand/nand_bcm_umi.c
 create mode 100644 drivers/mtd/nand/nand_calculate_ecc512.c
 create mode 100644 drivers/mtd/nand/nand_correct_data512.c
 create mode 100644 include/linux/mtd/nand_bcm_umi.h
 create mode 100644 include/linux/mtd/nand_ecc512.h

diff --git a/drivers/mtd/nand/nand_bcm_umi.c b/drivers/mtd/nand/nand_bcm_umi.c
new file mode 100644
index 0000000..d0c222f
--- /dev/null
+++ b/drivers/mtd/nand/nand_bcm_umi.c
@@ -0,0 +1,895 @@
+/*
+ * Copyright (c) 2005 Broadcom Corporation
+ *
+ *    This driver was based on the sharpl NAND driver written by
+ *    Richard Purdie.  Their copyright is below.
+ *    As such, this driver falls under the GPL license also below.
+ *
+ *  Copyright (C) 2004 Richard Purdie
+ *
+ *  Based on Sharp's NAND driver sharp_sl.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/ioport.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
+#include <linux/mtd/nand_ecc.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/nand_ecc512.h>
+#include <linux/mtd/nand_bcm_umi.h>
+
+#include <asm/io.h>
+#include <asm/mach-types.h>
+
+#include <mach/reg_nand.h>
+#include <mach/reg_umi.h>
+#include <mach/memory_settings.h>
+
+#if NAND_ECC_BCH
+#define NAND_ECC_NUM_BYTES 13
+#else
+#define NAND_ECC_NUM_BYTES 3
+#endif
+
+#include <mach/dma.h>
+#include <linux/dma-mapping.h>
+#include <linux/completion.h>
+
+static char gBanner[] __initdata = KERN_INFO "BCM UMI MTD NAND Driver: 1.00\n";
+
+
+//  Register offsets
+//
+#define REG_NAND_CMD_OFFSET     ( 0 )
+#define REG_NAND_ADDR_OFFSET    ( 4 )
+#ifndef __ARMEB__
+#define REG_NAND_DATA8_OFFSET   ( 8 )
+#else
+#define REG_NAND_DATA8_OFFSET   ( 8 + 1 )
+#endif
+
+/****************************************************************************
+*
+*  nand_hw_eccoob
+*
+*   New oob placement block for use with hardware ecc generation.
+*
+***************************************************************************/
+#if NAND_ECC_BCH
+static struct nand_ecclayout nand_hw_eccoob_512 = {
+       .eccbytes       = 13,
+       .eccpos         = { 2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 },
+    // Reserve 5 for BI indicator
+       .oobfree        = {
+        { .offset = 0,      .length = 2 }}
+};
+
+// We treat the OOB for a 2K page as if it were 4 512 byte oobs, except the BI is at byte 0.
+
+static struct nand_ecclayout nand_hw_eccoob_2048 = {
+       .eccbytes       = 52,
+       .eccpos         = { 3,4,5,6,7,8,9,10,11,12,13,14,15,
+                      19,20,21,22,23,24,25,26,27,28,29,30,31,
+                      35,36,37,38,39,40,41,42,43,44,45,46,47,
+                      51,52,53,54,55,56,57,58,59,60,61,62,62 },
+    // Reserve 0 as BI indicator
+       .oobfree        = {
+        { .offset = 1,      .length = 2 },
+        { .offset = 16,     .length = 3 },
+        { .offset = 32,     .length = 3 },
+        { .offset = 48,     .length = 3 }}
+};
+
+// We treat the OOB for a 4K page as if it were 8 512 byte oobs, except the BI is at byte 0.
+
+static struct nand_ecclayout nand_hw_eccoob_4096 = {
+       .eccbytes       = 104,
+       .eccpos         = { 3,4,5,6,7,8,9,10,11,12,13,14,15,
+#if 0
+                      19,20,21,22,23,24,25,26,27,28,29,30,31,
+                      35,36,37,38,39,40,41,42,43,44,45,46,47,
+                      51,52,53,54,55,56,57,58,59,60,61,62,62,
+                      67,68,69,70,71,72,73,74,75,76,77,78,79,
+                      83,84,85,86,87,88,89,90,91,92,93,94,95,
+                      99,100,101,102,103,104,105,106,107,108,109,110,111,
+#endif
+                      115,116,117,118,119,120,121,122,123,124,125,126,127 },
+    // Reserve 0 as BI indicator
+       .oobfree        = {
+        { .offset = 1,      .length = 2 },
+        { .offset = 16,     .length = 3 },
+        { .offset = 32,     .length = 3 },
+        { .offset = 48,     .length = 3 },
+        { .offset = 64,     .length = 3 },
+        { .offset = 80,     .length = 3 },
+        { .offset = 96,     .length = 3 },
+        { .offset = 112,    .length = 3 }}
+};
+#else
+/* Hamming ECC */
+
+static struct nand_ecclayout nand_hw_eccoob_512 = {
+       .eccbytes       = 3,
+       .eccpos         = {6, 7, 8 },
+    // Reserve 0/1 and 10/11 as BI indicators for 16-bit flash
+    // Reserve 5 for 8-bit BI
+    // 6/7/8 are for ecc so this is all that's left
+       .oobfree        = {
+        { .offset = 2,      .length = 3},
+        { .offset = 9,      .length = 1},
+        { .offset = 12,     .length = 4 }}
+};
+
+// We treat the OOB for a 2K page as if it were 4 512 byte oobs, except that the ECC offset if 8 rather than 6.
+
+static struct nand_ecclayout nand_hw_eccoob_2048 = {
+       .eccbytes       = 12,
+       .eccpos         = {8, 9, 10, 24, 25, 26, 40, 41, 42, 56, 57, 58 },
+    // Reserve 0/1 as BI indicators for 8/16-bit flash
+    // 8/9/10 are for ecc so this is all that's left
+       .oobfree        = {
+        { .offset = 2,      .length = 6},
+        { .offset = 11,     .length = 13 },
+        { .offset = 27,     .length = 13 },
+        { .offset = 43,     .length = 13 },
+        { .offset = 59,     .length = 5 }}
+};
+
+// We treat the OOB for a 4K page as if it were 8 512 byte oobs, except that the ECC offset if 8 rather than 6.
+
+static struct nand_ecclayout nand_hw_eccoob_4096 = {
+       .eccbytes       = 24,
+       .eccpos         = {8, 9, 10, 24, 25, 26, 40, 41, 42, 56, 57, 58, 72, 73, 74, 88, 89, 90, 104, 105, 106, 120, 121, 122 },
+    // Reserve 0/1 as BI indicators for 8/16-bit flash
+    // 8/9/10 are for ecc so this is all that's left
+       .oobfree        = {
+        { .offset = 2,      .length = 6},
+        { .offset = 11,     .length = 13 },
+        { .offset = 27,     .length = 13 },
+        { .offset = 43,     .length = 13 },
+        { .offset = 59,     .length = 13 },
+        { .offset = 75,     .length = 13 },
+        { .offset = 91,     .length = 13 },
+        { .offset = 107,    .length = 13 }}
+        //{ .offset = 123,    .length = 5 }}    It turns out nand_ecclayout only has space for 8 entries
+};
+#endif
+
+/*
+ * MTD structure for BCM UMI
+ */
+static struct mtd_info *board_mtd = NULL;
+static void __iomem *bcm_umi_io_base;
+
+// Preallocate a buffer to avoid having to do this every dma operation.
+// This is the size of the preallocated coherent DMA buffer.
+#define DMA_MIN_BUFLEN          512
+#define DMA_MAX_BUFLEN          PAGE_SIZE
+#define USE_DIRECT_IO(len)      (((len) < DMA_MIN_BUFLEN ) || ((len) > DMA_MAX_BUFLEN ))
+#if defined( CONFIG_ARCH_BCMRING )
+/*
+ * TODO: The current NAND data space goes from 0x80001900 to 0x80001FFF,
+ * which is only 0x700 = 1792 bytes long. This is too small for 2K, 4K page
+ * size NAND flash. Need to break the DMA down to multiple 1Ks.
+ *
+ * Need to make sure REG_NAND_DATA_PADDR + DMA_MAX_LEN < 0x80002000
+ */
+#define DMA_MAX_LEN             1024
+#endif
+static void *virtPtr;
+static dma_addr_t physPtr;
+static struct completion nand_comp;
+
+/****************************************************************************
+*
+*   Handler called when the DMA finishes.
+*
+***************************************************************************/
+
+static void nand_dma_handler( DMA_Device_t dev, int reason, void *userData )
+{
+       complete(&nand_comp);
+}
+
+/****************************************************************************
+*
+*   Function to perform DMA initialization
+*
+***************************************************************************/
+
+static int nand_dma_init( void )
+{
+    int     rc;
+
+    if (( rc = dma_set_device_handler( DMA_DEVICE_NAND_MEM_TO_MEM, nand_dma_handler, NULL )) != 0 )
+    {
+        printk( KERN_ERR "dma_set_device_handler failed: %d\n", rc );
+        return rc;
+    }
+
+    virtPtr = dma_alloc_coherent( NULL, DMA_MAX_BUFLEN, &physPtr, GFP_KERNEL );
+    if ( virtPtr == NULL )
+    {
+        printk("NAND - Failed to allocate memory for DMA buffer\n");
+        return -ENOMEM;
+    }
+
+    return 0;
+}
+
+/****************************************************************************
+*
+*   Function to perform DMA termination
+*
+***************************************************************************/
+
+static void nand_dma_term( void )
+{
+   if ( virtPtr != NULL )
+   {
+       dma_free_coherent( NULL, DMA_MAX_BUFLEN, virtPtr, physPtr );
+   }
+
+}
+
+/****************************************************************************
+*
+*   Performs a read via DMA
+*
+***************************************************************************/
+
+static void nand_dma_read( void *buf, int len )
+{
+      int offset = 0;
+      int tmp_len = 0;
+      int len_left = len;
+      DMA_Handle_t  hndl;
+
+      if ( virtPtr == NULL )
+      {
+          panic( "nand_dma_read: virtPtr == NULL\n" );
+      }
+      if ( (void *)physPtr == NULL )
+      {
+          panic( "nand_dma_read: physPtr == NULL\n" );
+      }
+      if (( hndl = dma_request_channel( DMA_DEVICE_NAND_MEM_TO_MEM )) < 0 )
+      {
+          printk( KERN_ERR "nand_dma_read: unable to allocate dma channel: %d\n", (int)hndl );
+          panic( "\n" );
+      }
+
+      while ( len_left > 0 )
+      {
+          if ( len_left > DMA_MAX_LEN )
+          {
+              tmp_len = DMA_MAX_LEN;
+              len_left -= DMA_MAX_LEN;
+          }
+          else
+          {
+              tmp_len = len_left;
+              len_left = 0;
+          }
+
+          init_completion(&nand_comp);
+          dma_transfer_mem_to_mem( hndl, REG_NAND_DATA_PADDR, physPtr + offset, tmp_len );
+          wait_for_completion(&nand_comp);
+
+          offset += tmp_len;
+      }
+
+      dma_free_channel( hndl );
+
+      if ( buf != NULL )
+      {
+          memcpy(buf, virtPtr, len);
+      }
+}
+
+/****************************************************************************
+*
+*   Performs a write via DMA
+*
+***************************************************************************/
+
+static void nand_dma_write( const void *buf, int len )
+{
+      int offset = 0;
+      int tmp_len = 0;
+      int len_left = len;
+      DMA_Handle_t  hndl;
+
+      if ( buf == NULL )
+      {
+          panic( "nand_dma_write: buf == NULL\n" );
+      }
+      if ( virtPtr == NULL )
+      {
+          panic( "nand_dma_write: virtPtr == NULL\n" );
+      }
+      if ( (void *)physPtr == NULL )
+      {
+          panic( "nand_dma_write: physPtr == NULL\n" );
+      }
+      memcpy( virtPtr, buf, len );
+
+      if (( hndl = dma_request_channel( DMA_DEVICE_NAND_MEM_TO_MEM )) < 0 )
+      {
+          printk( KERN_ERR "nand_dma_write: unable to allocate dma channel: %d\n", (int)hndl );
+          panic( "\n" );
+      }
+
+      while ( len_left > 0 )
+      {
+          if ( len_left > DMA_MAX_LEN )
+          {
+              tmp_len = DMA_MAX_LEN;
+              len_left -= DMA_MAX_LEN;
+          }
+          else
+          {
+              tmp_len = len_left;
+              len_left = 0;
+          }
+
+          init_completion(&nand_comp);
+          dma_transfer_mem_to_mem( hndl, physPtr + offset, REG_NAND_DATA_PADDR, tmp_len );
+          wait_for_completion(&nand_comp);
+
+          offset += tmp_len;
+      }
+
+      dma_free_channel( hndl );
+}
+
+/****************************************************************************
+*
+*  nand_dev_raedy
+*
+*   Routine to check if nand is ready.
+*
+***************************************************************************/
+static int nand_dev_ready(struct mtd_info* mtd)
+{
+    return nand_bcm_umi_dev_ready();
+}
+
+/****************************************************************************
+*
+*  bcm_umi_nand_inithw
+*
+*   This routine does the necessary hardware (board-specific)
+*   initializations.  This includes setting up the timings, etc.
+*
+***************************************************************************/
+
+int bcm_umi_nand_inithw( void )
+{
+   // Configure nand timing parameters
+   // Configure nand timing parameters
+   REG_UMI_NAND_TCR &= ~0x7ffff;
+   REG_UMI_NAND_TCR |= HW_CFG_NAND_TCR;
+
+   REG_UMI_NAND_TCR  |= REG_UMI_NAND_TCR_CS_SWCTRL;        // enable software control of CS
+   REG_UMI_NAND_RCSR |= REG_UMI_NAND_RCSR_CS_ASSERTED;     // keep NAND chip select asserted
+
+   REG_UMI_NAND_TCR &= ~REG_UMI_NAND_TCR_WORD16;
+   REG_UMI_MMD_ICR |= REG_UMI_MMD_ICR_FLASH_WP;        //enable writes to flash
+
+   writel( NAND_CMD_RESET, bcm_umi_io_base + REG_NAND_CMD_OFFSET );
+   nand_bcm_umi_wait_till_ready();
+
+#if NAND_ECC_BCH
+   nand_bcm_umi_bch_config_ecc( NAND_ECC_NUM_BYTES );
+#endif
+
+       return 0;
+}
+
+/****************************************************************************
+*
+*  bcm_umi_nand_hwcontrol
+*
+*   Used to turn latch the proper register for access.
+*
+***************************************************************************/
+
+static void bcm_umi_nand_hwcontrol(struct mtd_info *mtd, int cmd, unsigned int ctrl)
+{
+   /* TODO: send command to hardware */
+   struct nand_chip *chip = mtd->priv;
+   if (ctrl & NAND_CTRL_CHANGE) {
+      if (ctrl & NAND_CLE) {
+         chip->IO_ADDR_W    = bcm_umi_io_base + REG_NAND_CMD_OFFSET;
+         goto CMD;
+      }
+      if (ctrl & NAND_ALE) {
+         chip->IO_ADDR_W    = bcm_umi_io_base + REG_NAND_ADDR_OFFSET;
+         goto CMD;
+      }
+      chip->IO_ADDR_W    = bcm_umi_io_base + REG_NAND_DATA8_OFFSET;
+   }
+
+CMD:
+   /* Send command to chip directly */
+   if (cmd != NAND_CMD_NONE)
+      writeb(cmd, chip->IO_ADDR_W);
+
+}
+
+/****************************************************************************
+*
+*  bcm_umi_nand_get_hw_ecc
+*
+*   Used to get the hardware ECC.
+*
+***************************************************************************/
+
+static int bcm_umi_nand_get_hw_ecc(struct mtd_info *mtd, const u_char *dat, u_char *ecc_code)
+{
+#if NAND_ECC_BCH
+   uint32_t eccVal;
+
+   if (REG_UMI_BCH_CTRL_STATUS & REG_UMI_BCH_CTRL_STATUS_PAUSE_ECC_DEC)
+   {
+      /* Don't calculate the ecc - it's a waste of time on reads */
+   }
+   else
+   {
+      /* wait for ECC to be valid */
+      nand_bcm_umi_bch_poll_write_ecc_calc();
+      /*
+      ** Get the hardware ecc from the 32-bit result registers.
+      ** Read after 512 byte accesses. Format B3B2B1B0
+      ** where B3 = ecc3, etc.
+      */
+      eccVal = REG_UMI_BCH_WR_ECC_3;
+      ecc_code[ 0 ] = eccVal & 0xff;            /* ECC12 */
+      eccVal = REG_UMI_BCH_WR_ECC_2;
+      ecc_code[ 1 ] = (eccVal >> 24) & 0xff;    /* ECC11 */
+      ecc_code[ 2 ] = (eccVal >> 16) & 0xff;    /* ECC10 */
+      ecc_code[ 3 ] = (eccVal >> 8) & 0xff;     /* ECC9 */
+      ecc_code[ 4 ] = eccVal & 0xff;            /* ECC8 */
+      eccVal = REG_UMI_BCH_WR_ECC_1;
+      ecc_code[ 5 ] = (eccVal >> 24) & 0xff;    /* ECC7 */
+      ecc_code[ 6 ] = (eccVal >> 16) & 0xff;    /* ECC6 */
+      ecc_code[ 7 ] = (eccVal >> 8) & 0xff;     /* ECC5 */
+      ecc_code[ 8 ] = eccVal & 0xff;            /* ECC4 */
+      eccVal = REG_UMI_BCH_WR_ECC_0;
+      ecc_code[ 9 ]  = (eccVal >> 24) & 0xff;   /* ECC3 */
+      ecc_code[ 10 ]  = (eccVal >> 16) & 0xff;  /* ECC2 */
+      ecc_code[ 11 ]  = (eccVal >> 8) & 0xff;   /* ECC1 */
+      ecc_code[ 12 ]  = eccVal & 0xff;          /* ECC0 */
+   }
+#else
+   unsigned long ecc = REG_UMI_NAND_ECC_DATA;
+   ecc_code[2] = (ecc >> 16) & 0xff;
+   ecc_code[1] = (ecc >>  8) & 0xff;
+   ecc_code[0] = (ecc >>  0) & 0xff;
+#endif
+   (void)mtd;
+   (void)dat;
+
+   return 0;
+}
+
+/****************************************************************************
+*
+*  bcm_umi_nand_enable_hwecc
+*
+*   Used to turn on hardware ECC.
+*
+***************************************************************************/
+
+static void bcm_umi_nand_enable_hwecc(struct mtd_info *mtd, int mode)
+{
+   (void)mtd;
+   (void)mode;
+#if NAND_ECC_BCH
+   if (mode == NAND_ECC_READ)
+      nand_bcm_umi_bch_enable_read_hwecc();
+   else if (mode == NAND_ECC_WRITE)
+      nand_bcm_umi_bch_enable_write_hwecc();
+#else
+   nand_bcm_umi_hamming_enable_hwecc();
+#endif
+}
+
+/**
+ * bcm_umi_nand_write_buf - write buffer to chip
+ * @mtd:       MTD device structure
+ * @buf:       data buffer
+ * @len:       number of bytes to write
+ *
+ * Default write function for 8bit buswith
+ */
+static void bcm_umi_nand_write_buf(struct mtd_info *mtd, const u_char *buf, int len)
+{
+//#if NAND_ECC_BCH
+//   nand_bcm_umi_bch_enable_write_hwecc();
+//#endif
+   if ( USE_DIRECT_IO( len ))
+   {
+      // Do it the old way if the buffer is small or too large. Probably quicker than starting and checking dma.
+      int i;
+      struct nand_chip *this = mtd->priv;
+
+      for (i=0; i<len; i++)
+      {
+         writeb(buf[i], this->IO_ADDR_W);
+      }
+   }
+   else
+   {
+      nand_dma_write( buf, len );
+   }
+}
+
+/**
+ * nand_read_buf - read chip data into buffer
+ * @mtd:       MTD device structure
+ * @buf:       buffer to store date
+ * @len:       number of bytes to read
+ *
+ * Default read function for 8bit buswith
+ */
+
+static void bcm_umi_nand_read_buf(struct mtd_info *mtd, u_char *buf, int len)
+{
+#if NAND_ECC_BCH
+   if (len == 16)
+   {
+      /* We are reading the OOB */
+      int i = 0;
+      if ( mtd->writesize == 512)  // writesize is the pagesize
+      {
+         /* skip CM */
+         buf[i++] = REG_NAND_DATA8;
+         buf[i++] = REG_NAND_DATA8;
+
+         /* read from 2 to 4 */
+         nand_bcm_umi_bch_resume_read_ecc_calc();
+
+         buf[i++] = REG_NAND_DATA8;
+         buf[i++] = REG_NAND_DATA8;
+         buf[i++] = REG_NAND_DATA8;
+         nand_bcm_umi_bch_pause_read_ecc_calc();
+
+         /* read BI */
+         buf[i++] = REG_NAND_DATA8;
+
+         /* read from 6 to nand_ecc_bch_total */
+         nand_bcm_umi_bch_resume_read_ecc_calc();
+
+         /* Deduct 3 from total since 3 ECC bytes have been read already */
+         for (; i < 16; i++)
+         {
+            buf[i] = REG_NAND_DATA8;
+         }
+      }
+      else
+      {
+         /* skip BI */
+         buf[i++] = REG_NAND_DATA8;
+
+         /* skip CM */
+         buf[i++] = REG_NAND_DATA8;
+         buf[i++] = REG_NAND_DATA8;
+
+         /* read ECC bytes */
+            nand_bcm_umi_bch_resume_read_ecc_calc();
+
+         for ( ; i < 16; i++)
+         {
+            buf[i] = REG_NAND_DATA8;
+         }
+      }
+   }
+   else
+#endif
+   {
+#if NAND_ECC_BCH
+      nand_bcm_umi_bch_enable_read_hwecc();
+#endif
+      if ( USE_DIRECT_IO( len ))
+      {
+         int i;
+         struct nand_chip *this = mtd->priv;
+
+         for (i=0; i<len; i++)
+         {
+            buf[i] = readb(this->IO_ADDR_R);
+         }
+      }
+      else
+      {
+         nand_dma_read( buf, len );
+      }
+#if NAND_ECC_BCH
+      nand_bcm_umi_bch_pause_read_ecc_calc();
+#endif
+   }
+}
+
+/**
+ * bcm_umi_nand_verify_buf - Verify chip data against buffer
+ * @mtd:       MTD device structure
+ * @buf:       buffer containing the data to compare
+ * @len:       number of bytes to compare
+ *
+ * Default verify function for 8bit buswith
+ */
+static int bcm_umi_nand_verify_buf(struct mtd_info *mtd, const u_char *buf, int len)
+{
+   if ( USE_DIRECT_IO( len ))
+   {
+      int i;
+      struct nand_chip *this = mtd->priv;
+      for (i=0; i<len; i++)
+      {
+         if (buf[i] != readb(this->IO_ADDR_R))
+         {
+            return -EFAULT;
+         }
+      }
+   }
+   else
+   {
+      nand_dma_read( NULL, len );
+      if ( memcmp( buf, virtPtr, len ) != 0 )
+      {
+         return -EFAULT;
+      }
+   }
+   return 0;
+}
+
+#if NAND_ECC_BCH
+static int nand_correct_bch(struct mtd_info *mtd, u_char *dat, u_char *read_ecc, u_char *calc_ecc)
+{
+   int result;
+
+   result = nand_bcm_umi_bch_correct_page( dat );
+
+   /* If the ECC is unprogrammed then we can't correct */
+   if (result != 0)
+   {
+      int i;
+
+      for (i = 0; i < NAND_ECC_NUM_BYTES; i++)
+      {
+         if (read_ecc[i] != 0xff)
+         {
+            return(result);
+         }
+      }
+      result = 0;
+   }
+   return result;
+}
+#endif
+
+#ifdef CONFIG_MTD_PARTITIONS
+const char *part_probes[] = { "cmdlinepart", NULL };
+#endif
+
+static int bcm_umi_nand_probe(struct platform_device *pdev)
+{
+   struct nand_chip *this;
+   int err = 0;
+
+   printk( gBanner );
+
+       /* Allocate memory for MTD device structure and private data */
+       board_mtd = kmalloc(sizeof(struct mtd_info) + sizeof(struct nand_chip), GFP_KERNEL);
+       if (!board_mtd) {
+               printk (KERN_WARNING "Unable to allocate NAND MTD device structure.\n");
+               return -ENOMEM;
+       }
+
+       /* map physical adress */
+#ifdef CONFIG_ARCH_BCMRING
+       bcm_umi_io_base = ioremap(MM_ADDR_IO_NAND, 0x1000);
+#else
+       bcm_umi_io_base = ioremap(0x08000000, 0x1000);
+#endif
+
+       if(!bcm_umi_io_base){
+               printk("ioremap to access BCM UMI NAND chip failed\n");
+               kfree(board_mtd);
+               return -EIO;
+       }
+
+       /* Get pointer to private data */
+       this = (struct nand_chip *) (&board_mtd[1]);
+
+       /* Initialize structures */
+       memset((char *) board_mtd, 0, sizeof(struct mtd_info));
+       memset((char *) this, 0, sizeof(struct nand_chip));
+
+       /* Link the private data with the MTD structure */
+       board_mtd->priv = this;
+
+   /* Initialize the NAND hardware.  */
+   if (bcm_umi_nand_inithw() < 0)
+   {
+      printk("BCM UMI NAND chip could not be initialized\n");
+      iounmap(bcm_umi_io_base);
+      kfree(board_mtd);
+      return -EIO;
+   }
+
+   /* Set address of NAND IO lines */
+   this->IO_ADDR_W    = bcm_umi_io_base + REG_NAND_DATA8_OFFSET;
+   this->IO_ADDR_R    = bcm_umi_io_base + REG_NAND_DATA8_OFFSET;
+
+   /* Set command delay time, see datasheet for correct value */
+   this->chip_delay   = 0;
+   /* Assign the device ready function, if available */
+   this->dev_ready = nand_dev_ready;
+   this->options = 0;
+
+   this->write_buf = bcm_umi_nand_write_buf;
+   this->read_buf = bcm_umi_nand_read_buf;
+   this->verify_buf = bcm_umi_nand_verify_buf;
+
+   this->cmd_ctrl = bcm_umi_nand_hwcontrol;
+#ifdef CONFIG_MTD_NAND_BCM_UMI_HWECC
+   this->ecc.mode = NAND_ECC_HW;
+   this->ecc.size = 512;
+   this->ecc.bytes = NAND_ECC_NUM_BYTES;
+
+#if NAND_ECC_BCH
+   this->ecc.correct = nand_correct_bch;
+#else
+   this->ecc.correct = nand_correct_data512;
+#endif
+
+   this->ecc.calculate = bcm_umi_nand_get_hw_ecc;
+   this->ecc.hwctl = bcm_umi_nand_enable_hwecc;
+#else
+   this->ecc.mode = NAND_ECC_SOFT;
+#endif
+
+   if (( err = nand_dma_init() ) != 0 )
+   {
+      return err;
+   }
+
+   /* Figure out the size of the device that we have. We need to do this to figure out which ECC
+    * layout we'll be using.                                                                       */
+
+   err = nand_scan_ident( board_mtd, 1 );
+   if (err)
+   {
+      printk( KERN_ERR "nand_scan failed: %d\n", err );
+      iounmap(bcm_umi_io_base);
+      kfree(board_mtd);
+      return err;
+   }
+
+   // Now that we know the nand size, we can setup the ECC layout
+
+#ifdef CONFIG_MTD_NAND_BCM_UMI_HWECC
+      switch ( board_mtd->writesize )  // writesize is the pagesize
+      {
+         case 4096:  this->ecc.layout = &nand_hw_eccoob_4096;    break;
+         case 2048:  this->ecc.layout = &nand_hw_eccoob_2048;    break;
+         case 512:   this->ecc.layout = &nand_hw_eccoob_512;     break;
+         default:
+         {
+            printk( KERN_ERR "NAND - Unrecognized pagesize: %d\n", board_mtd->writesize );
+            return -EINVAL;
+         }
+      }
+#endif
+
+   /* Now finish off the scan, now that ecc.layout has been initialized. */
+
+   err = nand_scan_tail( board_mtd );
+   if (err)
+   {
+      printk( KERN_ERR "nand_scan failed: %d\n", err );
+      iounmap(bcm_umi_io_base);
+      kfree(board_mtd);
+      return err;
+   }
+
+   /* Register the partitions */
+{
+   int nr_partitions;
+   struct mtd_partition* partition_info;
+
+   board_mtd->name = "bcm_umi-nand";
+   nr_partitions = parse_mtd_partitions(board_mtd, part_probes, &partition_info, 0);
+
+   if (nr_partitions <= 0)
+   {
+      printk("BCM UMI NAND: Too few partitions - %d\n", nr_partitions);
+      iounmap(bcm_umi_io_base);
+      kfree(board_mtd);
+      return -EIO;
+       }
+   add_mtd_partitions( board_mtd, partition_info, nr_partitions );
+}
+
+   /* Return happy */
+   return 0;
+}
+
+static int bcm_umi_nand_remove(struct platform_device *pdev)
+{
+   nand_dma_term();
+
+   /* Release resources, unregister device */
+   nand_release(board_mtd);
+
+   /* unmap physical adress */
+   iounmap(bcm_umi_io_base);
+
+   /* Free the MTD device structure */
+   kfree(board_mtd);
+
+   return 0;
+}
+
+#ifdef CONFIG_PM
+static int bcm_umi_nand_suspend(struct platform_device *pdev, pm_message_t state)
+{
+   printk(KERN_ERR "MTD NAND suspend is being called\n");
+   return 0;
+}
+
+static int bcm_umi_nand_resume(struct platform_device *pdev)
+{
+   printk(KERN_ERR "MTD NAND resume is being called\n");
+   return 0;
+}
+#else
+#define bcm_umi_nand_suspend   NULL
+#define bcm_umi_nand_resume    NULL
+#endif
+
+static struct platform_driver nand_driver = {
+   .driver = {
+      .name = "bcm-nand",
+      .owner = THIS_MODULE,
+   },
+   .probe = bcm_umi_nand_probe,
+   .remove = bcm_umi_nand_remove,
+   .suspend = bcm_umi_nand_suspend,
+   .resume = bcm_umi_nand_resume,
+};
+
+static int __init nand_init(void)
+{
+   return platform_driver_register(&nand_driver);
+}
+
+static void __exit nand_exit(void)
+{
+   platform_driver_unregister(&nand_driver);
+}
+
+module_init(nand_init);
+module_exit(nand_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Broadcom");
+MODULE_DESCRIPTION("BCM UMI MTD NAND driver");
diff --git a/drivers/mtd/nand/nand_calculate_ecc512.c b/drivers/mtd/nand/nand_calculate_ecc512.c
new file mode 100644
index 0000000..9beee0c
--- /dev/null
+++ b/drivers/mtd/nand/nand_calculate_ecc512.c
@@ -0,0 +1,269 @@
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
+
+
+//
+//---------------------------------------------------------------------------
+//
+// nand ecc calculation - only useful for mips cpu's that have no ECC
+// generation hardware.
+//---------------------------------------------------------------------------
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+//#include <linux/broadcom/knllog.h>
+
+/*****************************************************************************/
+/*                                                                           */
+/* NAME                                                                      */
+/*      nand_calculate_ecc512                                                         */
+/* DESCRIPTION                                                               */
+/*             This function generates 3 byte ECC for 512 byte data.                */
+/*      (Software ECC)                                                       */
+/* PARAMETERS                                                                */
+/*      pEcc            the location where ECC should be stored              */
+/*      datapage        given data                                           */
+/* RETURN VALUES                                                             */
+/*             none                                                                 */
+/*                                                                           */
+/*****************************************************************************/
+#define NAND_PG_SIZE 512
+
+
+// For efficiency reasons, process the data as 32-bit words, 4 bytes packed.
+// The words are grouped into blocks which helps us calculate parity regions.
+// The block size is set to 8 words so that we can calculate the larger
+// parity regions, which starts at P256, which needs 8 words. So for a
+// 512 byte page, we have to loop 16 times, 8 words per block to get 128 words,
+// or 512 bytes.
+#define NAND_PAGE_WORDS (NAND_PG_SIZE / 4)
+#define BYTES_PER_BLOCK        32
+#define WORDS_PER_BLOCK        (BYTES_PER_BLOCK / 4)
+#define BLOCKS (NAND_PAGE_WORDS / WORDS_PER_BLOCK)
+
+// Patterns which capture blocks of bytes
+// of different sizes, when layed out as
+// 32 bit words. This is more efficient
+// than calculating parity on a byte by
+// byte basis.
+#define P16_PATTERN            0xffff0000
+#define P16P_PATTERN   ~P16_PATTERN
+#define P8_PATTERN             0xff00ff00
+#define P8P_PATTERN            ~P8_PATTERN
+#define P4_PATTERN             0xf0f0f0f0
+#define P4P_PATTERN            ~P4_PATTERN
+#define P2_PATTERN             0xcccccccc
+#define P2P_PATTERN            ~P2_PATTERN
+#define P1_PATTERN             0xaaaaaaaa
+#define P1P_PATTERN            ~P1_PATTERN
+
+
+// These are bit positions within the largeBlockParity bitmap
+// for each corresponding pattern. D0 corresponds to the parity
+// of the first 32 byte block. D15 corresponds to the parity of
+// the last 32 byte block. Combinations of these bits can be
+// used to get the parity of each region.
+// 0  P256'
+// 1  P256   P512'
+// 2  P256'
+// 3  P256   P512   P1024'
+// 4  P256'
+// 5  P256   P512'
+// 6  P256'
+// 7  P256   P512'  P1024
+// ...
+#define P256_PATTERN           0xaaaa
+#define P512_PATTERN           0xcccc
+#define P1024_PATTERN   0xf0f0
+#define P2048_PATTERN   0xff00
+#define P256P_PATTERN          0x5555
+#define P512P_PATTERN          0x3333
+#define P1024P_PATTERN         0x0f0f
+#define P2048P_PATTERN         0x00ff
+
+
+// Positions in the final ECC word
+#define P4             0x00800000
+#define P4P            0x00400000
+#define P2             0x00200000
+#define P2P            0x00100000
+#define P1             0x00080000
+#define P1P            0x00040000
+#define P2048  0x00020000
+#define P2048P 0x00010000
+#define P1024  0x00008000
+#define P1024P 0x00004000
+#define P512   0x00002000
+#define P512P  0x00001000
+#define P256   0x00000800
+#define P256P  0x00000400
+#define P128   0x00000200
+#define P128P  0x00000100
+#define P64            0x00000080
+#define P64P   0x00000040
+#define P32            0x00000020
+#define P32P   0x00000010
+#define P16            0x00000008
+#define P16P   0x00000004
+#define P8             0x00000002
+#define P8P            0x00000001
+
+struct mtd_info;
+
+const u_char parity_nibble[16] =
+{
+       0,      // 0
+       1,  // 1
+       1,  // 2
+       0,  // 3
+       1,  // 4
+       0,  // 5
+       0,      // 6
+       1,      // 7
+       1,      // 8
+       0,      // 9
+       0,      // 0xa
+       1,      // 0xb
+       0,      // 0xc
+       1,      // 0xd
+       1,      // 0xe
+       0       // 0xf
+
+};
+
+typedef struct
+{
+    uint32_t largeBlockParities;   // bitmap of parities for blocks 0-15
+    uint32_t pBlock;               // parity of current block
+    uint32_t result;               // runnning ecc result
+    uint32_t p16ByteBlockOdd;      // 16 byte odd block parity
+    uint32_t p8ByteBlockOdd;       // 8 byte odd block parity
+    uint32_t p4ByteBlockOdd;       // 4 byte odd block parity
+    uint32_t p16ByteBlockEven;     // 16 byte even block parity
+    uint32_t p8ByteBlockEven;      // 8 byte even block parity
+    uint32_t p4ByteBlockEven;      // 4 byte even block parity
+    uint32_t pFinal;               // parity of 512 byte packet
+    uint32_t *wordp;               // ptr to aligned start of packet
+}
+ECCINFO;
+
+// Calculate the parity of a word (xor all bits in the word)
+// Returns parity 0 or 1.
+static inline int wordParity(uint32_t word)
+{
+       uint32_t val;
+       val = (word >> 16) ^ word;
+       val = (val >> 8) ^ val;
+       val = (val >> 4) ^ val;
+       return parity_nibble[val & 0xf];
+
+}
+// Calculate the parity of a word and return the bitmask
+// if nonzero parity or zero if zero parity.
+static inline uint32_t calcEccBit(uint32_t word, uint32_t bitmask)
+{
+       return wordParity(word) ? bitmask : 0;
+}
+
+
+// Main ecc calculation routine
+int nand_calculate_ecc512(struct mtd_info *mtd, const u_char *dat, u_char *ecc_code)
+{
+       int blockidx;   // 16 blocks of 8 longwords = 512 bytes
+    int wordidx;       // index within each block 0-7
+    uint32_t    alignedBuf[NAND_PG_SIZE/sizeof(uint32_t)];
+       ECCINFO ecc;
+
+       //KNLLOG("start\n");
+       memset(&ecc, 0, sizeof(ecc));
+
+    // Make sure the data is aligned.
+       ecc.wordp = (uint32_t *)dat;
+    if (((uint32_t)dat % 4) != 0)
+    {
+        memcpy((char *)alignedBuf, dat, NAND_PG_SIZE);
+        ecc.wordp = alignedBuf;      // 32-bit operations more efficient
+    }
+
+    // The data needs to be in little-endian order for the ECC calculations
+       // so we have to swap it for big-endian architectures.
+    for (blockidx = 0; blockidx < BLOCKS; blockidx++)
+       {
+               ecc.pBlock = 0; // Reset the parity each block
+               for (wordidx = 0; wordidx < WORDS_PER_BLOCK; wordidx++)
+               {
+                       uint32_t word = cpu_to_le32(*ecc.wordp++);
+                       ecc.pBlock ^= word;   // update the running word parity per block
+                       ecc.p16ByteBlockEven ^= !(wordidx & 4) ? word : 0;  // Every even block of 16 bytes
+                       ecc.p8ByteBlockEven  ^= !(wordidx & 2) ? word : 0;  // Every even block of 8 bytes
+                       ecc.p4ByteBlockEven  ^= !(wordidx & 1) ? word : 0;      // Every even block of 4 bytes
+                       ecc.p16ByteBlockOdd  ^=  (wordidx & 4) ? word : 0;      // Every odd block of 16 bytes
+                       ecc.p8ByteBlockOdd   ^=  (wordidx & 2) ? word : 0;  // Every odd block of 8 bytes
+                       ecc.p4ByteBlockOdd   ^=  (wordidx & 1) ? word : 0;      // Every odd block of 4 bytes
+               }
+               // pFinal is the total parity over all blocks and all data
+               ecc.pFinal ^= ecc.pBlock;
+
+               // If the word parity is set for this block, then update
+               // a bitmap that shows the parity over all 16 blocks.
+               if (wordParity(ecc.pBlock))
+               {
+                       ecc.largeBlockParities |= (1<<blockidx);
+               }
+       }
+       // Calculate the 256/512/1024/2048 bit region parities
+       ecc.result |= calcEccBit(ecc.largeBlockParities & P2048_PATTERN, P2048);
+       ecc.result |= calcEccBit(ecc.largeBlockParities & P1024_PATTERN, P1024);
+       ecc.result |= calcEccBit(ecc.largeBlockParities & P512_PATTERN,  P512);
+       ecc.result |= calcEccBit(ecc.largeBlockParities & P256_PATTERN,  P256);
+
+       ecc.result |= calcEccBit(ecc.largeBlockParities & P2048P_PATTERN, P2048P);
+       ecc.result |= calcEccBit(ecc.largeBlockParities & P1024P_PATTERN, P1024P);
+       ecc.result |= calcEccBit(ecc.largeBlockParities & P512P_PATTERN,  P512P);
+       ecc.result |= calcEccBit(ecc.largeBlockParities & P256P_PATTERN,  P256P);
+
+       // Using the 32/64/128 bit region parities
+       ecc.result |= calcEccBit(ecc.p16ByteBlockOdd, P128);
+       ecc.result |= calcEccBit(ecc.p8ByteBlockOdd,  P64);
+       ecc.result |= calcEccBit(ecc.p4ByteBlockOdd,  P32);
+
+       ecc.result |= calcEccBit(ecc.p16ByteBlockEven, P128P);
+       ecc.result |= calcEccBit(ecc.p8ByteBlockEven,  P64P);
+       ecc.result |= calcEccBit(ecc.p4ByteBlockEven,  P32P);
+
+       // Calculate the column parities
+       ecc.result |= calcEccBit(ecc.pFinal & P16_PATTERN, P16);
+       ecc.result |= calcEccBit(ecc.pFinal & P8_PATTERN,  P8);
+       ecc.result |= calcEccBit(ecc.pFinal & P4_PATTERN,  P4);
+       ecc.result |= calcEccBit(ecc.pFinal & P2_PATTERN,  P2);
+       ecc.result |= calcEccBit(ecc.pFinal & P1_PATTERN,  P1);
+
+       ecc.result |= calcEccBit(ecc.pFinal & P16P_PATTERN, P16P);
+       ecc.result |= calcEccBit(ecc.pFinal & P8P_PATTERN,  P8P);
+       ecc.result |= calcEccBit(ecc.pFinal & P4P_PATTERN,  P4P);
+       ecc.result |= calcEccBit(ecc.pFinal & P2P_PATTERN,  P2P);
+       ecc.result |= calcEccBit(ecc.pFinal & P1P_PATTERN,  P1P);
+
+       // Invert the result
+       ecc.result = ~ecc.result;
+
+       // Fill in the return codes
+    ecc_code[0] = ecc.result & 0xff;
+    ecc_code[1] = (ecc.result >> 8) & 0xff;
+    ecc_code[2] = (ecc.result >> 16) & 0xff;
+
+       //KNLLOG("done ecc=%x\n", ecc.result & 0xffffff);
+    return 0;
+}
diff --git a/drivers/mtd/nand/nand_correct_data512.c b/drivers/mtd/nand/nand_correct_data512.c
new file mode 100644
index 0000000..69d36d1
--- /dev/null
+++ b/drivers/mtd/nand/nand_correct_data512.c
@@ -0,0 +1,163 @@
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
+
+
+//
+//---------------------------------------------------------------------------
+//
+// nand error control correction routines
+//---------------------------------------------------------------------------
+#include <linux/types.h>
+#include <linux/mtd/nand_ecc512.h>
+
+typedef union{
+   unsigned long mylword;
+   unsigned short myword[2];
+   unsigned char  mybyte[4];   //MSB: byte[0]
+   struct{
+      unsigned int bit31:1;
+      unsigned int bit30:1;
+      unsigned int bit29:1;
+      unsigned int bit28:1;
+      unsigned int bit27:1;
+      unsigned int bit26:1;
+      unsigned int bit25:1;
+      unsigned int bit24:1;
+      unsigned int bit23:1;
+      unsigned int bit22:1;
+      unsigned int bit21:1;
+      unsigned int bit20:1;
+      unsigned int bit19:1;
+      unsigned int bit18:1;
+      unsigned int bit17:1;
+      unsigned int bit16:1;
+      unsigned int bit15:1;
+      unsigned int bit14:1;
+      unsigned int bit13:1;
+      unsigned int bit12:1;
+      unsigned int bit11:1;
+      unsigned int bit10:1;
+      unsigned int bit9:1;
+      unsigned int bit8:1;
+      unsigned int bit7:1;
+      unsigned int bit6:1;
+      unsigned int bit5:1;
+      unsigned int bit4:1;
+      unsigned int bit3:1;
+      unsigned int bit2:1;
+      unsigned int bit1:1;
+      unsigned int bit0:1;
+   } mybits;
+} UnionLW;
+
+typedef union{
+   unsigned char mybyte;
+   struct{
+      unsigned int bit7:1;
+      unsigned int bit6:1;
+      unsigned int bit5:1;
+      unsigned int bit4:1;
+      unsigned int bit3:1;
+      unsigned int bit2:1;
+      unsigned int bit1:1;
+      unsigned int bit0:1;
+   } mybits;
+} UnionB;
+
+/*****************************************************************************/
+/*                                                                           */
+/* NAME                                                                      */
+/*      nand_correct_data512                                                */
+/* DESCRIPTION                                                               */
+/*      This function compares two ECCs and indicates if there is an error.  */
+/* PARAMETERS                                                                */
+/*      read_ecc           one ECC to be compared                            */
+/*      calc_ecc           the other ECC to be compared                      */
+/*      dat                content of data page                              */
+/* RETURN VALUES                                                             */
+/*      Upon successful completion, compare_ecc returns 0.                   */
+/*      Otherwise, corresponding error code is returned.                     */
+/*                                                                           */
+/*****************************************************************************/
+int nand_correct_data512(struct mtd_info *mtd, u_char *dat, u_char *read_ecc, u_char *calc_ecc)
+{
+   unsigned short   i,j,row,col;
+   UnionLW   mylw;
+   unsigned short bitlen = 24;   // e.g. 512 byte pages
+
+    u_char   newval;
+
+   UnionLW orgecc;
+   UnionLW newecc;
+
+   orgecc.mylword = 0;
+   newecc.mylword = 0;
+
+   // Hardware register 00 ecc[2] ecc[1] ecc[0],   MSB..LSB
+   // OOB form  ecc[0] ecc[1] ecc[2]
+   // u_char form ecc[0] ecc[1] ecc[2]
+   orgecc.mybyte[1] = read_ecc[2];   // MSB
+   orgecc.mybyte[2] = read_ecc[1];
+   orgecc.mybyte[3] = read_ecc[0];   // LSB
+
+   newecc.mybyte[1] = calc_ecc[2];
+   newecc.mybyte[2] = calc_ecc[1];
+   newecc.mybyte[3] = calc_ecc[0];
+
+   mylw.mylword = orgecc.mylword ^ newecc.mylword;
+
+   // Quick check to avoid for loop below for normal no error case.
+   if (mylw.mylword == 0)
+   {
+      return 0;  // No error
+   }
+
+   j = 0;
+   for(i = 0; i < bitlen; i ++)
+   {
+      if( (mylw.mylword >> i) & 1 )
+      {
+         j++;
+      }
+   }
+   if( j == 1 )
+   {
+      return 2;  // ECC itself in error
+   }
+   if( j == (bitlen >> 1) )
+   {
+      row = mylw.mybits.bit1 +
+          (mylw.mybits.bit3  << 1) +
+          (mylw.mybits.bit5  << 2) +
+          (mylw.mybits.bit7  << 3) +
+          (mylw.mybits.bit9  << 4) +
+          (mylw.mybits.bit11 << 5) +
+          (mylw.mybits.bit13 << 6) +
+          (mylw.mybits.bit15 << 7) +
+          (mylw.mybits.bit17 << 8);
+
+      col = mylw.mybits.bit19 +
+          (mylw.mybits.bit21 << 1) +
+          (mylw.mybits.bit23 << 2);
+
+      newval = dat[row] ^ (1 << col);
+      /* printk("ECC: Replaced at offset 0x%x  old=0x%x new=0x%x\n", row, dat[row], newval); */
+      dat[row] = newval;
+
+      return 1;   // Corrected 1 error
+   }
+   return -1;   // 2 or more errors - uncorrectible
+}
+
diff --git a/include/linux/mtd/nand_bcm_umi.h b/include/linux/mtd/nand_bcm_umi.h
new file mode 100644
index 0000000..11366a0
--- /dev/null
+++ b/include/linux/mtd/nand_bcm_umi.h
@@ -0,0 +1,236 @@
+/*****************************************************************************
+* Copyright 2003 - 2009 Broadcom Corporation.  All rights reserved.
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
+#ifndef NAND_BCM_UMI_H
+#define NAND_BCM_UMI_H
+
+/* ---- Include Files ---------------------------------------------------- */
+#include <mach/reg_umi.h>
+#include <cfg_global.h>
+#ifdef BOOT0_BUILD
+#include <uart.h>
+#endif
+
+/* ---- Constants and Types ---------------------------------------------- */
+#if ( CFG_GLOBAL_CHIP_FAMILY == CFG_GLOBAL_CHIP_FAMILY_BCMRING )
+#define NAND_ECC_BCH (CFG_GLOBAL_CHIP_REV > 0xA0)
+#else
+#define NAND_ECC_BCH 0
+#endif
+
+/* ---- Variable Externs ------------------------------------------ */
+/* ---- Function Prototypes --------------------------------------- */
+
+static inline int nand_bcm_umi_dev_ready( void )
+{
+    return (REG_UMI_NAND_RCSR & REG_UMI_NAND_RCSR_RDY);
+}
+
+static inline void nand_bcm_umi_wait_till_ready( void )
+{
+    while ( nand_bcm_umi_dev_ready() == 0 )
+    {
+      ;
+   }
+}
+
+static inline void nand_bcm_umi_hamming_enable_hwecc(void)
+{
+   REG_UMI_NAND_ECC_CSR &= ~(REG_UMI_NAND_ECC_CSR_ECC_ENABLE | REG_UMI_NAND_ECC_CSR_256BYTE);   // disable and reset ECC, 512 byte page
+   REG_UMI_NAND_ECC_CSR |= REG_UMI_NAND_ECC_CSR_ECC_ENABLE;    // enable ECC
+}
+
+#if NAND_ECC_BCH
+static inline void nand_bcm_umi_bch_enable_read_hwecc( void )
+{
+   /* disable and reset ECC */
+   REG_UMI_BCH_CTRL_STATUS = REG_UMI_BCH_CTRL_STATUS_RD_ECC_VALID;
+   /* Turn on ECC */
+   REG_UMI_BCH_CTRL_STATUS = REG_UMI_BCH_CTRL_STATUS_ECC_RD_EN;
+}
+
+static inline void nand_bcm_umi_bch_enable_write_hwecc( void )
+{
+   /* disable and reset ECC */
+   REG_UMI_BCH_CTRL_STATUS = REG_UMI_BCH_CTRL_STATUS_WR_ECC_VALID;
+   /* Turn on ECC */
+   REG_UMI_BCH_CTRL_STATUS = REG_UMI_BCH_CTRL_STATUS_ECC_WR_EN;
+}
+
+static inline void nand_bcm_umi_bch_config_ecc( uint8_t numEccBytes )
+{
+    int nValue;
+    int tValue;
+    int kValue;
+    int numBits = numEccBytes * 8;
+    #define ECC_BITS_PER_CORRECTABLE_BIT 13
+    #define NAND_DATA_ACCESS_SIZE 512
+
+    /* Every correctible bit requires 13 ECC bits */
+    tValue = (int)(numBits / ECC_BITS_PER_CORRECTABLE_BIT);
+
+    /* Total data in number of bits for generating and computing BCH ECC */
+    nValue = (NAND_DATA_ACCESS_SIZE + numEccBytes) * 8;
+
+    /* K parameter is used internally.  K = N - (T * 13) */
+    kValue = nValue - (tValue * 13);
+
+    /* Write the settings */
+    REG_UMI_BCH_N = nValue;
+    REG_UMI_BCH_T = tValue;
+    REG_UMI_BCH_K = kValue;
+
+   /* disable and reset ECC */
+   REG_UMI_BCH_CTRL_STATUS = REG_UMI_BCH_CTRL_STATUS_WR_ECC_VALID | REG_UMI_BCH_CTRL_STATUS_RD_ECC_VALID;
+}
+
+static inline void nand_bcm_umi_bch_pause_read_ecc_calc( void )
+{
+   REG_UMI_BCH_CTRL_STATUS = REG_UMI_BCH_CTRL_STATUS_ECC_RD_EN | REG_UMI_BCH_CTRL_STATUS_PAUSE_ECC_DEC;
+}
+
+static inline void nand_bcm_umi_bch_resume_read_ecc_calc( void )
+{
+   REG_UMI_BCH_CTRL_STATUS = REG_UMI_BCH_CTRL_STATUS_ECC_RD_EN;
+}
+
+static inline uint32_t nand_bcm_umi_bch_poll_read_ecc_calc( void )
+{
+   uint32_t regVal;
+
+   do
+   {
+      /* wait for ECC to be valid */
+      regVal = REG_UMI_BCH_CTRL_STATUS;
+   }
+   while ( (regVal & REG_UMI_BCH_CTRL_STATUS_RD_ECC_VALID) == 0 );
+
+   return (regVal);
+}
+
+static inline void nand_bcm_umi_bch_poll_write_ecc_calc( void )
+{
+   /* wait for ECC to be valid */
+   while ( (REG_UMI_BCH_CTRL_STATUS & REG_UMI_BCH_CTRL_STATUS_WR_ECC_VALID) == 0 );
+}
+
+/****************************************************************************
+*  nand_bch_ecc_flip_bit - Routine to flip an errored bit
+*
+*  PURPOSE:
+*     This is a helper routine that flips the bit (0 -> 1 or 1 -> 0) of the
+*     errored bit specified
+*
+*  PARAMETERS:
+*     datap - Container that holds the 512 byte data
+*     errorLocation - Location of the bit that needs to be flipped
+*
+*  RETURNS:
+*     None
+****************************************************************************/
+static inline void nand_bcm_umi_bch_ecc_flip_bit( uint8_t  *datap, int errorLocation )
+{
+    int locWithinAByte = ( errorLocation & REG_UMI_BCH_ERR_LOC_BYTE ) >> 0;
+    int locWithinAWord = ( errorLocation & REG_UMI_BCH_ERR_LOC_WORD ) >> 3;
+    int locWithinAPage = ( errorLocation & REG_UMI_BCH_ERR_LOC_PAGE ) >> 5;
+
+    /* BCH uses big endian, need to change the location bits to little endian  */
+    locWithinAWord = 3 - locWithinAWord;
+
+    uint8_t errorByte = 0;
+    uint8_t byteMask = 1 << locWithinAByte;
+
+    errorByte = datap[ locWithinAPage*sizeof(uint32_t) + locWithinAWord ];
+
+#ifdef BOOT0_BUILD
+    puthexs("\nECC Correct Offset: ", locWithinAPage*sizeof(uint32_t) + locWithinAWord );
+    puthexs( " errorByte:", errorByte );
+    puthex8( " Bit: ", locWithinAByte );
+#endif
+
+    if (errorByte & byteMask)
+    {
+        /* bit needs to be cleared */
+        errorByte &= ~byteMask;
+    }
+    else
+    {
+        /* bit needs to be set */
+        errorByte |= byteMask;
+    }
+
+    /* write back the value with the fixed bit */
+    datap[ locWithinAPage*sizeof(uint32_t) + locWithinAWord ] = errorByte;
+}
+
+/****************************************************************************
+*  nand_correct_page_bch - Routine to correct bit errors when reading NAND
+*
+*  PURPOSE:
+*     This routine reads the BCH registers to determine if there are any bit
+*     errors during the read of the last 512 bytes of data + ECC bytes.  If
+*     errors exists, the routine fixes it.
+*
+*  PARAMETERS:
+*     datap - Container that holds the 512 byte data
+*
+*  RETURNS:
+*     0 or greater = Number of errors corrected (No errors are found or errors have been fixed)
+*    -1 = Error(s) cannot be fixed
+****************************************************************************/
+static inline int nand_bcm_umi_bch_correct_page( uint8_t *datap )
+{
+   int numErrors;
+   int errorLocation;
+   int idx;
+   uint32_t regValue;
+
+   /* wait for read ECC to be valid */
+   regValue = nand_bcm_umi_bch_poll_read_ecc_calc();
+
+   /* read the control status register to determine if there are error'ed bits */
+   /* see if errors are correctible */
+   if ( ( regValue & REG_UMI_BCH_CTRL_STATUS_UNCORR_ERR ) > 0 )
+   {
+      /* errors cannot be fixed, return -1 */
+      return -1;
+   }
+
+   if ( ( regValue & REG_UMI_BCH_CTRL_STATUS_CORR_ERR ) == 0 )
+   {
+      /* no errors */
+      return 0;
+   }
+
+   /*
+    * Fix errored bits by doing the following:
+    * 1. Read the number of errors in the control and status register
+    * 2. Read the error location registers that corresponds to the number
+    *    of errors reported
+    * 3. Invert the bit in the data
+    */
+   numErrors = ( regValue & REG_UMI_BCH_CTRL_STATUS_NB_CORR_ERROR ) >> 20;
+
+   for ( idx = 0; idx < numErrors; idx++ )
+   {
+      errorLocation = REG_UMI_BCH_ERR_LOC_ADDR(idx) & REG_UMI_BCH_ERR_LOC_MASK;
+
+      /* Flip bit */
+      nand_bcm_umi_bch_ecc_flip_bit( datap, errorLocation );
+   }
+   /* Errors corrected */
+   return numErrors;
+}
+#endif
+
+#endif /* NAND_BCM_UMI_H */
diff --git a/include/linux/mtd/nand_ecc512.h b/include/linux/mtd/nand_ecc512.h
new file mode 100644
index 0000000..1b6f86c
--- /dev/null
+++ b/include/linux/mtd/nand_ecc512.h
@@ -0,0 +1,26 @@
+/*
+ *  drivers/mtd/nand_ecc512.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This file is the header for the ECC algorithm.
+ */
+
+#ifndef __MTD_NAND_ECC512_H__
+#define __MTD_NAND_ECC512_H__
+
+struct mtd_info;
+
+/*
+ * Calculate 3 byte ECC code for 512 byte block
+ */
+int nand_calculate_ecc512(struct mtd_info *mtd, const u_char *dat, u_char *ecc_code);
+
+/*
+ * Detect and correct a 2 bit error for 512 byte block
+ */
+int nand_correct_data512(struct mtd_info *mtd, u_char *dat, u_char *read_ecc, u_char *calc_ecc);
+
+#endif /* __MTD_NAND_ECC512_H__ */
--
1.6.0.6



Leo Hao Chen
Software Engineer
Broadcom Canada Inc.


