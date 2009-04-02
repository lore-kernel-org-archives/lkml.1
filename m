Return-Path: <linux-kernel-owner+w=401wt.eu-S935188AbZDBGKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935188AbZDBGKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761277AbZDBGJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:09:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:41535 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbZDBGJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:09:48 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: norsk5@yahoo.com
Cc: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: [v0 PATCH 1/5] EDAC: Add CPC925 driver header file
Date: Thu,  2 Apr 2009 14:07:16 +0800
Message-Id: <1238652440-9224-2-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1238652440-9224-1-git-send-email-qingtao.cao@windriver.com>
References: <1238652440-9224-1-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 02 Apr 2009 06:09:41.0368 (UTC) FILETIME=[9C5EA780:01C9B359]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce IBM CPC925 EDAC driver header file, which adds register and bits
definitions for the IBM CPC925 Bridge and Memory Controller.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 drivers/edac/cpc925_edac.h |  283 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 283 insertions(+)
 create mode 100644 drivers/edac/cpc925_edac.h

--- /dev/null
+++ b/drivers/edac/cpc925_edac.h
@@ -0,0 +1,283 @@
+/*
+ * cpc925_edac.h
+ * 	EDAC definitions for IBM CPC925 Bridge and Memory Controller.
+ * 	All information taken from "CPC925 Bridge and Memory Controller
+ * 	User Manual, SA14-2761-02".
+ *
+ * Copyright (c) 2008 Wind River Systems, Inc.
+ *
+ * Authors:	Cao Qingtao <qingtao.cao@windriver.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#ifndef _CPC925_EDAC_H_
+#define _CPC925_EDAC_H_
+
+#define CPC925_EDAC_REVISION	" Ver: 1.0.0 " __DATE__
+#define CPC925_EDAC_MOD_STR	"cpc925_edac"
+
+#define cpc925_printk(level, fmt, arg...) \
+	edac_printk(level, "CPC925", fmt, ##arg)
+
+#define cpc925_mc_printk(mci, level, fmt, arg...) \
+	edac_mc_chipset_printk(mci, level, "CPC925", fmt, ##arg)
+
+/*
+ * CPC925 registers are of 32 bits with bit0 defined at the
+ * most significant bit and bit31 at that of least significant.
+ */
+#define CPC925_BITS_PER_REG	32
+#define CPC925_BIT(nr)		(1UL << (CPC925_BITS_PER_REG - 1 - nr))
+
+/*
+ * EDAC device names for the error detections of
+ * CPU Interface and Hypertransport Link.
+ */
+#define CPC925_CPU_ERR_DEV	"cpu"
+#define CPC925_HT_LINK_DEV	"htlink"
+
+/* Suppose DDR Refresh cycle is 15.6 microsecond */
+#define CPC925_REF_FREQ		0xFA69
+#define CPC925_SCRUB_BLOCK_SIZE 64	/* bytes */
+#define CPC925_NR_CSROWS	8
+
+/*
+ * CPU and Memory Controller Registers
+ */
+/************************************************************
+ *	Processor Interface Exception Mask Register (APIMASK)
+ ************************************************************/
+#define REG_APIMASK_OFFSET	0x30070
+enum apimask_bits {
+	APIMASK_DART	= CPC925_BIT(0), /* DART Exception */
+	APIMASK_ADI0	= CPC925_BIT(1), /* Handshake Error on PI0_ADI */
+	APIMASK_ADI1	= CPC925_BIT(2), /* Handshake Error on PI1_ADI */
+	APIMASK_STAT	= CPC925_BIT(3), /* Status Exception */
+	APIMASK_DERR	= CPC925_BIT(4), /* Data Error Exception */
+	APIMASK_ADRS0	= CPC925_BIT(5), /* Addressing Exception on PI0 */
+	APIMASK_ADRS1	= CPC925_BIT(6), /* Addressing Exception on PI1 */
+					 /* BIT(7) Reserved */
+	APIMASK_ECC_UE_H = CPC925_BIT(8), /* UECC upper */
+	APIMASK_ECC_CE_H = CPC925_BIT(9), /* CECC upper */
+	APIMASK_ECC_UE_L = CPC925_BIT(10), /* UECC lower */
+	APIMASK_ECC_CE_L = CPC925_BIT(11), /* CECC lower */
+
+	CPU_MASK_ENABLE = (APIMASK_DART | APIMASK_ADI0 | APIMASK_ADI1 |
+			   APIMASK_STAT | APIMASK_DERR | APIMASK_ADRS0 |
+			   APIMASK_ADRS1),
+	ECC_MASK_ENABLE = (APIMASK_ECC_UE_H | APIMASK_ECC_CE_H |
+			   APIMASK_ECC_UE_L | APIMASK_ECC_CE_L),
+};
+
+/************************************************************
+ *	Processor Interface Exception Register (APIEXCP)
+ ************************************************************/
+#define REG_APIEXCP_OFFSET	0x30060
+enum apiexcp_bits {
+	APIEXCP_DART	= CPC925_BIT(0), /* DART Exception */
+	APIEXCP_ADI0	= CPC925_BIT(1), /* Handshake Error on PI0_ADI */
+	APIEXCP_ADI1	= CPC925_BIT(2), /* Handshake Error on PI1_ADI */
+	APIEXCP_STAT	= CPC925_BIT(3), /* Status Exception */
+	APIEXCP_DERR	= CPC925_BIT(4), /* Data Error Exception */
+	APIEXCP_ADRS0	= CPC925_BIT(5), /* Addressing Exception on PI0 */
+	APIEXCP_ADRS1	= CPC925_BIT(6), /* Addressing Exception on PI1 */
+					 /* BIT(7) Reserved */
+	APIEXCP_ECC_UE_H = CPC925_BIT(8), /* UECC upper */
+	APIEXCP_ECC_CE_H = CPC925_BIT(9), /* CECC upper */
+	APIEXCP_ECC_UE_L = CPC925_BIT(10), /* UECC lower */
+	APIEXCP_ECC_CE_L = CPC925_BIT(11), /* CECC lower */
+
+	CPU_EXCP_DETECTED = (APIEXCP_DART | APIEXCP_ADI0 | APIEXCP_ADI1 |
+			     APIEXCP_STAT | APIEXCP_DERR | APIEXCP_ADRS0 |
+			     APIEXCP_ADRS1),
+	UECC_EXCP_DETECTED = (APIEXCP_ECC_UE_H | APIEXCP_ECC_UE_L),
+	CECC_EXCP_DETECTED = (APIEXCP_ECC_CE_H | APIEXCP_ECC_CE_L),
+	ECC_EXCP_DETECTED = (UECC_EXCP_DETECTED | CECC_EXCP_DETECTED),
+};
+
+/************************************************************
+ *	Memory Bus Configuration Register (MBCR)
+************************************************************/
+#define REG_MBCR_OFFSET		0x2190
+#define MBCR_64BITCFG_SHIFT	23
+#define MBCR_64BITCFG_MASK	(1UL << MBCR_64BITCFG_SHIFT)
+#define MBCR_64BITBUS_SHIFT	22
+#define MBCR_64BITBUS_MASK	(1UL << MBCR_64BITBUS_SHIFT)
+
+/************************************************************
+ *	Memory Bank Mode Register (MBMR)
+************************************************************/
+#define REG_MBMR_OFFSET		0x21C0
+#define MBMR_MODE_MAX_VALUE	0xF
+#define MBMR_MODE_SHIFT		25
+#define MBMR_MODE_MASK		(MBMR_MODE_MAX_VALUE << MBMR_MODE_SHIFT)
+#define MBMR_BBA_SHIFT		24
+#define MBMR_BBA_MASK		(1UL << MBMR_BBA_SHIFT)
+
+/************************************************************
+ *	Memory Bank Boundary Address Register (MBBAR)
+ ************************************************************/
+#define REG_MBBAR_OFFSET	0x21D0
+#define MBBAR_BBA_MAX_VALUE	0xFF
+#define MBBAR_BBA_SHIFT		24
+#define MBBAR_BBA_MASK		(MBBAR_BBA_MAX_VALUE << MBBAR_BBA_SHIFT)
+
+/************************************************************
+ *	Memory Scrub Control Register (MSCR)
+ ************************************************************/
+#define REG_MSCR_OFFSET		0x2400
+#define MSCR_SCRUB_MOD_MASK	0xC0000000 /* scrub_mod - bit0:1*/
+#define MSCR_BACKGR_SCRUB	0x40000000 /* 01 */
+#define MSCR_SI_SHIFT		16 	/* si - bit8:15*/
+#define MSCR_SI_MAX_VALUE	0xFF
+#define MSCR_SI_MASK		(MSCR_SI_MAX_VALUE << MSCR_SI_SHIFT)
+
+/************************************************************
+ *	Memory Scrub Range Start Register (MSRSR)
+ ************************************************************/
+#define REG_MSRSR_OFFSET	0x2410
+
+/************************************************************
+ *	Memory Scrub Range End Register (MSRER)
+ ************************************************************/
+#define REG_MSRER_OFFSET	0x2420
+
+/************************************************************
+ *	Memory Scrub Pattern Register (MSPR)
+ ************************************************************/
+#define REG_MSPR_OFFSET		0x2430
+
+/************************************************************
+ *	Memory Check Control Register (MCCR)
+ ************************************************************/
+#define REG_MCCR_OFFSET		0x2440
+enum mccr_bits {
+	MCCR_ECC_EN	= CPC925_BIT(0), /* ECC high and low check */
+};
+
+/************************************************************
+ *	Memory Check Range End Register (MCRER)
+ ************************************************************/
+#define REG_MCRER_OFFSET	0x2450
+
+/************************************************************
+ *	Memory Error Address Register (MEAR)
+ ************************************************************/
+#define REG_MEAR_OFFSET		0x2460
+#define MEAR_BCNT_MAX_VALUE	0x3
+#define MEAR_BCNT_SHIFT		30
+#define MEAR_BCNT_MASK		(MEAR_BCNT_MAX_VALUE << MEAR_BCNT_SHIFT)
+#define MEAR_RANK_MAX_VALUE	0x7
+#define MEAR_RANK_SHIFT		27
+#define MEAR_RANK_MASK		(MEAR_RANK_MAX_VALUE << MEAR_RANK_SHIFT)
+#define MEAR_COL_MAX_VALUE	0x7FF
+#define MEAR_COL_SHIFT		16
+#define MEAR_COL_MASK		(MEAR_COL_MAX_VALUE << MEAR_COL_SHIFT)
+#define MEAR_BANK_MAX_VALUE	0x3
+#define MEAR_BANK_SHIFT		14
+#define MEAR_BANK_MASK		(MEAR_BANK_MAX_VALUE << MEAR_BANK_SHIFT)
+#define MEAR_ROW_MASK		0x00003FFF
+
+/************************************************************
+ *	Memory Error Syndrome Register (MESR)
+ ************************************************************/
+#define REG_MESR_OFFSET		0x2470
+#define MESR_ECC_SYN_H_MASK	0xFF00
+#define MESR_ECC_SYN_L_MASK	0x00FF
+
+/************************************************************
+ *	Memory Mode Control Register (MMCR)
+ ************************************************************/
+#define REG_MMCR_OFFSET		0x2500
+enum mmcr_bits {
+	MMCR_REG_DIMM_MODE = CPC925_BIT(3),
+};
+
+/*
+ * HyperTransport Link Registers
+ */
+/************************************************************
+ *  Error Handling/Enumeration Scratch Pad Register (ERRCTRL)
+ ************************************************************/
+#define REG_ERRCTRL_OFFSET	0x70140
+enum errctrl_bits {			 /* nonfatal interrupts for */
+	ERRCTRL_SERR_NF	= CPC925_BIT(0), /* system error */
+	ERRCTRL_CRC_NF	= CPC925_BIT(1), /* CRC error */
+	ERRCTRL_RSP_NF	= CPC925_BIT(2), /* Response error */
+	ERRCTRL_EOC_NF	= CPC925_BIT(3), /* End-Of-Chain error */
+	ERRCTRL_OVF_NF	= CPC925_BIT(4), /* Overflow error */
+	ERRCTRL_PROT_NF	= CPC925_BIT(5), /* Protocol error */
+
+	ERRCTRL_RSP_ERR	= CPC925_BIT(6), /* Response error received */
+	ERRCTRL_CHN_FAL = CPC925_BIT(7), /* Sync flooding detected */
+
+	HT_ERRCTRL_ENABLE = (ERRCTRL_SERR_NF | ERRCTRL_CRC_NF |
+			     ERRCTRL_RSP_NF | ERRCTRL_EOC_NF |
+			     ERRCTRL_OVF_NF | ERRCTRL_PROT_NF),
+	HT_ERRCTRL_DETECTED = (ERRCTRL_RSP_ERR | ERRCTRL_CHN_FAL),
+};
+
+/************************************************************
+ *  Link Configuration and Link Control Register (LINKCTRL)
+ ************************************************************/
+#define REG_LINKCTRL_OFFSET	0x70110
+enum linkctrl_bits {
+	LINKCTRL_CRC_ERR	= (CPC925_BIT(22) | CPC925_BIT(23)),
+	LINKCTRL_LINK_FAIL	= CPC925_BIT(27),
+
+	HT_LINKCTRL_DETECTED	= (LINKCTRL_CRC_ERR | LINKCTRL_LINK_FAIL),
+};
+
+/************************************************************
+ *  Link FreqCap/Error/Freq/Revision ID Register (LINKERR)
+ ************************************************************/
+#define REG_LINKERR_OFFSET	0x70120
+enum linkerr_bits {
+	LINKERR_EOC_ERR		= CPC925_BIT(17), /* End-Of-Chain error */
+	LINKERR_OVF_ERR		= CPC925_BIT(18), /* Receive Buffer Overflow */
+	LINKERR_PROT_ERR	= CPC925_BIT(19), /* Protocol error */
+
+	HT_LINKERR_DETECTED	= (LINKERR_EOC_ERR | LINKERR_OVF_ERR |
+				   LINKERR_PROT_ERR),
+};
+
+/************************************************************
+ *	Bridge Control Register (BRGCTRL)
+ ************************************************************/
+#define REG_BRGCTRL_OFFSET	0x70300
+enum brgctrl_bits {
+	BRGCTRL_DETSERR = CPC925_BIT(0), /* SERR on Secondary Bus */
+	BRGCTRL_SECBUSRESET = CPC925_BIT(9), /* Secondary Bus Reset */
+};
+
+struct cpc925_mc_pdata {
+	void __iomem *vbase;
+	unsigned long total_mem;
+	const char *name;
+	int edac_idx;
+};
+
+struct cpc925_dev_info {
+	void __iomem *vbase;
+	struct platform_device *pdev;
+	char *ctl_name;
+	int edac_idx;
+	struct edac_device_ctl_info *edac_dev;
+	void (*init)(struct cpc925_dev_info *dev_info);
+	void (*exit)(struct cpc925_dev_info *dev_info);
+	void (*check)(struct edac_device_ctl_info *edac_dev);
+};
+
+#endif
