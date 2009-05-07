Return-Path: <linux-kernel-owner+w=401wt.eu-S1761009AbZEGNxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761009AbZEGNxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757771AbZEGNuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:50:24 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:54199 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859AbZEGNuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:50:05 -0400
X-BigFish: VPS-28(zz14c3M1135M1417L936eQ1370I936fJ655N19c2kzz1202hzzz32i66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KJA12X-01-QXL-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 02/21] amd64_edac: add driver header
Date: Thu, 7 May 2009 15:49:24 +0200
Message-ID: <1241704183-29223-3-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 07 May 2009 13:49:48.0672 (UTC) FILETIME=[B0103000:01C9CF1A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.h |  945 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 945 insertions(+), 0 deletions(-)
 create mode 100644 drivers/edac/amd64_edac.h

diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
new file mode 100644
index 0000000..5a6126c
--- /dev/null
+++ b/drivers/edac/amd64_edac.h
@@ -0,0 +1,945 @@
+/*
+ * AMD64 class Memory Controller kernel module
+ *
+ * Copyright (c) 2009 SoftwareBitMaker.
+ * Copyright (c) 2009 Advanced Micro Devices, Inc.
+ *
+ * This file may be distributed under the terms of the
+ * GNU General Public License.
+ *
+ *	Originally Written by Thayne Harbaugh
+ *
+ *      Changes by Douglas "norsk" Thompson  <dougthompson@xmission.com>:
+ *		- K8 CPU Revision D and greater support
+ *
+ *      Changes by Dave Peterson <dsp@llnl.gov> <dave_peterson@pobox.com>:
+ *		- Module largely rewritten, with new (and hopefully correct)
+ *		code for dealing with node and chip select interleaving,
+ *		various code cleanup, and bug fixes
+ *		- Added support for memory hoisting using DRAM hole address
+ *		register
+ *
+ *	Changes by Douglas "norsk" Thompson <dougthompson@xmission.com>:
+ *		-K8 Rev (1207) revision support added, required Revision
+ *		specific mini-driver code to support Rev F as well as
+ *		prior revisions
+ *
+ *	Changes by Douglas "norsk" Thompson <dougthompson@xmission.com>:
+ *		-Family 10h revision support added. New PCI Device IDs,
+ *		indicating new changes. Actual registers modified
+ *		were slight, less than the Rev E to Rev F transition
+ *		but changing the PCI Device ID was the proper thing to
+ *		do, as it provides for almost automactic family
+ *		detection. The mods to Rev F required more family
+ *		information detection.
+ *
+ *	Changes/Fixes by Borislav Petkov <borislav.petkov@amd.com>:
+ *		- misc fixes and code cleanups
+ *
+ * This module is based on the following documents
+ * (available from http://www.amd.com/):
+ *
+ *	Title:	BIOS and Kernel Developer's Guide for AMD Athlon 64 and AMD
+ *		Opteron Processors
+ *	AMD publication #: 26094
+ *`	Revision: 3.26
+ *
+ *	Title:	BIOS and Kernel Developer's Guide for AMD NPT Family 0Fh
+ *		Processors
+ *	AMD publication #: 32559
+ *	Revision: 3.00
+ *	Issue Date: May 2006
+ *
+ *	Title:	BIOS and Kernel Developer's Guide (BKDG) For AMD Family 10h
+ *		Processors
+ *	AMD publication #: 31116
+ *	Revision: 3.00
+ *	Issue Date: September 07, 2007
+ *
+ * Sections in the first 2 documents are no longer in sync with each other.
+ * The Family 10h BKDG was totally re-written from scratch with a new
+ * presentation model.
+ * Therefore, comments that refer to a Document section might be off.
+ */
+
+#include <linux/module.h>
+#include <linux/ctype.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/slab.h>
+#include <linux/mmzone.h>
+#include <linux/edac.h>
+#include "edac_core.h"
+
+#define amd64_printk(level, fmt, arg...) \
+	edac_printk(level, "amd64", fmt, ##arg)
+
+#define amd64_mc_printk(mci, level, fmt, arg...) \
+	edac_mc_chipset_printk(mci, level, "amd64", fmt, ##arg)
+
+/*
+ * Throughout the comments in this code, the following terms are used:
+ *
+ *	SysAddr, DramAddr, and InputAddr
+ *
+ *  These terms come directly from the amd64 documentation
+ * (AMD publication #26094).  They are defined as follows:
+ *
+ *     SysAddr:
+ *         This is a physical address generated by a CPU core or a device
+ *         doing DMA.  If generated by a CPU core, a SysAddr is the result of
+ *         a virtual to physical address translation by the CPU core's address
+ *         translation mechanism (MMU).
+ *
+ *     DramAddr:
+ *         A DramAddr is derived from a SysAddr by subtracting an offset that
+ *         depends on which node the SysAddr maps to and whether the SysAddr
+ *         is within a range affected by memory hoisting.  The DRAM Base
+ *         (section 3.4.4.1) and DRAM Limit (section 3.4.4.2) registers
+ *         determine which node a SysAddr maps to.
+ *
+ *         If the DRAM Hole Address Register (DHAR) is enabled and the SysAddr
+ *         is within the range of addresses specified by this register, then
+ *         a value x from the DHAR is subtracted from the SysAddr to produce a
+ *         DramAddr.  Here, x represents the base address for the node that
+ *         the SysAddr maps to plus an offset due to memory hoisting.  See
+ *         section 3.4.8 and the comments in amd64_get_dram_hole_info() and
+ *         sys_addr_to_dram_addr() below for more information.
+ *
+ *         If the SysAddr is not affected by the DHAR then a value y is
+ *         subtracted from the SysAddr to produce a DramAddr.  Here, y is the
+ *         base address for the node that the SysAddr maps to.  See section
+ *         3.4.4 and the comments in sys_addr_to_dram_addr() below for more
+ *         information.
+ *
+ *     InputAddr:
+ *         A DramAddr is translated to an InputAddr before being passed to the
+ *         memory controller for the node that the DramAddr is associated
+ *         with.  The memory controller then maps the InputAddr to a csrow.
+ *         If node interleaving is not in use, then the InputAddr has the same
+ *         value as the DramAddr.  Otherwise, the InputAddr is produced by
+ *         discarding the bits used for node interleaving from the DramAddr.
+ *         See section 3.4.4 for more information.
+ *
+ *         The memory controller for a given node uses its DRAM CS Base and
+ *         DRAM CS Mask registers to map an InputAddr to a csrow.  See
+ *         sections 3.5.4 and 3.5.5 for more information.
+ */
+
+/*
+ * Alter this version for the K8 module when modifications are made
+ */
+#define EDAC_AMD64_VERSION	" Ver: 3.2.0 " __DATE__
+#define EDAC_MOD_STR		"amd64_edac"
+
+/* Extended Model from CPUID, for CPU Revision numbers */
+#define OPTERON_CPU_LE_REV_C    0
+#define OPTERON_CPU_REV_D       1
+#define OPTERON_CPU_REV_E       2
+
+/* NPT processors have the following Extended Models */
+#define OPTERON_CPU_REV_F       4
+#define OPTERON_CPU_REV_FA	5
+
+/* Hardware limit on ChipSelect rows per MC and processors per system */
+#define CHIPSELECT_COUNT	8
+#define DRAM_REG_COUNT		8
+
+/*************************************************************/
+/* K8 register addresses - device 0 Function 1 - Address Map */
+/*************************************************************/
+#define K8_DRAM_BASE_LOW	0x40
+				/* Function 1: DRAM Base Register (8 x 32b
+				 * interlaced with K8_DRAM_LIMIT_LOW)
+				 *
+				 * 31:16 DRAM base address reg bits[39:24]
+				 * 15:11 reserved
+				 * 10:8  interleave enable
+				 *  7:2  reserved
+				 *  1    write enable
+				 *  0    read enable
+				 *
+				 */
+
+#define K8_DRAM_LIMIT_LOW	0x44
+				/* Function 1: DRAM Limit Register (8 x 32b
+				 * interlaced with K8_DRAM_BASE_LOW)
+				 *
+				 * 31:16 DRAM Limit addr 32:24
+				 * 15:11 reserved
+				 * 10:8  interleave select
+				 *  7:3  reserved
+				 *  2:0  destination node ID
+				 */
+
+#define K8_DHAR         0xf0
+				/* Function 1: DRAM Hole Address Register
+				 *
+				 * K8
+				 * 31:24 DramHoleBase
+				 * 23:16 reserved
+				 * 15:8  DramHoleOffset
+				 *  7:1  reserved
+				 *    0  DramHoleValid
+				 *
+				 * F10
+				 * 31:24 DramHoleBase
+				 * 23:16 reserved
+				 * 15:7  DramHoleOffset
+				 *  6:2  reserved
+				 *    1  DramMemHoistValid
+				 *    0  DramHoleValid
+				 */
+#define DHAR_VALID			BIT(0)
+#define F10_DRAM_MEM_HOIST_VALID	BIT(1)
+
+#define DHAR_BASE_MASK			0xff000000
+#define dhar_base(dhar)			(dhar & DHAR_BASE_MASK)
+
+#define K8_DHAR_OFFSET_MASK		0x0000ff00
+#define k8_dhar_offset(dhar)		((dhar & K8_DHAR_OFFSET_MASK) << 16)
+
+#define F10_DHAR_OFFSET_MASK		0x0000ff80
+					/* NOTE: Extra mask bit vs K8 */
+#define f10_dhar_offset(dhar)		((dhar & F10_DHAR_OFFSET_MASK) << 16)
+
+
+/* F10 High BASE/LIMIT registers */
+#define F10_DRAM_BASE_HIGH	0x140
+				/* Function 1: DRAM Base register HIGH
+				 *
+				 * 7:0  Drambase[47:40] DRAM base address reg
+				 *	bits[47:40]
+				 */
+
+#define F10_DRAM_LIMIT_HIGH	0x144
+				/* Function 1: DRAM Limit Register HIGH
+				 *
+				 * 7:0  DRAM limit address register bits[47:40]
+				 */
+
+/*****************************************************************/
+/* K8 register addresses - device 0 Function 2 - DRAM controller */
+/*************************************************************/
+#define K8_DCSB0		0x40
+#define F10_DCSB1		0x140
+				/* Function 2: DRAM Chip-Select Base (8 x 32b)
+				 *
+				 * For Rev E and prior
+				 * 31:21 Base addr high 35:25
+				 * 20:16 reserved
+				 * 15:9  Base addr low 19:13 (interlvd)
+				 *  8:1  reserved
+				 *  0    chip-select bank enable
+				 *
+				 * For Rev F (NPT) and later
+				 * 31:29 reserved
+				 * 28:19 Base address (36:27)
+				 * 18:14 reserved
+				 * 13:5  Base address (21:13)
+				 * 4:3   reserved
+				 * 2     TestFail
+				 * 1     Spare Rank
+				 * 0     CESenable
+				 *
+				 */
+#define K8_DCSB_CS_ENABLE	BIT(0)
+#define K8_DCSB_NPT_SPARE	BIT(1)
+#define K8_DCSB_NPT_TESTFAIL	BIT(2)
+
+/* REV E: selects bits 31-21 and 15-9 from DCSB
+ * and the shift amount to form address
+ */
+#define REV_E_DCSB_BASE_BITS	(0xFFE0FE00ULL)
+#define REV_E_DCS_SHIFT		4
+#define REV_E_DCSM_COUNT	8
+
+#define REV_F_F1Xh_DCSB_BASE_BITS    (0x1FF83FE0ULL)
+#define REV_F_F1Xh_DCS_SHIFT        8
+
+/* REV F and later : selects bits 28-19 and 13-5 from DCSB
+ * and the shift amount to form address
+ */
+#define REV_F_DCSB_BASE_BITS	(0x1FF83FE0ULL)
+#define REV_F_DCS_SHIFT		8
+#define REV_F_DCSM_COUNT        4
+#define F10_DCSM_COUNT		4
+#define F11_DCSM_COUNT		2
+
+/* DRAM CS Mask Registers */
+#define K8_DCSM0		0x60
+#define F10_DCSM1		0x160
+				/* Function 2: DRAM Chip-Select Mask (8 x 32b)
+				 *
+				 * 31:30 reserved
+				 * 29:21 addr mask high 33:25
+				 * 20:16 reserved
+				 * 15:9  addr mask low  19:13
+				 *  8:0  reserved
+				 */
+
+/* REV E: selects bits 29-21 and 15-9 from DCSM */
+#define REV_E_DCSM_MASK_BITS        0x3FE0FE00
+/*    represents unused bits [24-20] and [12-0] */
+#define REV_E_DCS_NOTUSED_BITS        0x01F01FFF
+
+/* REV F and later: selects bits 28-19 and 13-5 from DCSM */
+#define REV_F_F1Xh_DCSM_MASK_BITS    0x1FF83FE0
+/*    represents unused bits [26-22] and [12-0] */
+#define REV_F_F1Xh_DCS_NOTUSED_BITS    0x07C01FFF
+
+#define DBAM0			0x80
+#define DBAM1			0x180
+				/* Function 2: DRAM Base Addr Mapping (32b) */
+
+/* Extract the DIMM 'type' on the i'th DIMM from the DBAM reg value passed */
+#define DBAM_DIMM(i, reg)	((((reg) >> (4*i))) & 0xF)
+
+#define DBAM_MAX_VALUE	11
+
+
+#define F10_DCLR_0	0x90
+#define F10_DCLR_1	0x190
+				/* Function 2: DRAM configuration low reg (32b)
+				 *	One for each DCTx
+				 *
+				 * Rev E and earlier CPUS:
+				 *
+				 * 31:28 reserved
+				 * 27:25 Bypass Max: 000b=respect
+				 * 24    Dissable receivers - no sockets
+				 * 23:20 x4 DIMMS
+				 * 19    32byte chunks
+				 * 18    Unbuffered
+				 * 17    ECC enabled
+				 * 16    128/64 bit (dual/single chan)
+				 * 15:14 R/W Queue bypass count
+				 * 13    Self refresh
+				 * 12    exit self refresh
+				 * 11    mem clear status
+				 * 10    DRAM enable
+				 *  9    reserved
+				 *  8    DRAM init
+				 *  7:4  reserved
+				 *  3    dis DQS hysteresis
+				 *  2    QFC enabled
+				 *  1    DRAM drive strength
+				 *  0    Digital Locked Loop disable
+				 *
+				 * Rev F
+				 *
+				 * 31:20 reserved
+				 * 19    DIMM ECC Enable
+				 * 18:17 reserved
+				 * 16    Unbuffered DIMM
+				 * 15:12 x4 DIMMs
+				 * 11    Width128 bits
+				 * 10    burstLength32
+				 *  9    SelRefRateEn
+				 *  8    ParEn
+				 *  7    DramDrvWeak
+				 *  6    reserved
+				 * 5:4   DramTerm
+				 * 3:2   reserved
+				 *  1    ExitSelfRef
+				 *  0    InitDram
+				 *
+				 * Rev F10h
+				 *
+				 * 31:24 reserved
+				 * 23    FoceAutoPcg
+				 * 22:21 IdleCycLowLimit
+				 * 20    DynPageCloseEn
+				 * 19    DIMM ECC Enable
+				 * 18    PendRefPayback
+				 * 17    EnterSelRef
+				 * 16    Unbuffered DIMM
+				 * 15:12 x4 DIMMs
+				 * 11    Width128 bits
+				 * 10    burstLength32
+				 *  9    SelRefRateEn
+				 *  8    ParEn
+				 *  7    DramDrvWeak
+				 *  6    DisDqsBar
+				 * 5:4   DramTerm
+				 * 3:2   reserved
+				 *  1    ExitSelfRef
+				 *  0    InitDram
+				 */
+#define REVE_WIDTH_128	BIT(16)
+#define F10_WIDTH_128	BIT(11)
+
+
+#define F10_DCHR_0	0x94
+#define F10_DCHR_1	0x194
+				/* Function 2: DRAM Configuration High Reg */
+
+#define F10_DCHR_FOUR_RANK_DIMM	BIT(18)
+#define F10_DCHR_Ddr3Mode	BIT(8)
+#define F10_DCHR_MblMode	BIT(6)
+
+
+#define F10_DCTL_SEL_LOW	0x110
+				/* Function 2: DRAM Controller SELECT LOW */
+
+#define dct_sel_baseaddr(pvt)    \
+	((pvt->dram_ctl_select_low) & 0xFFFFF800)
+
+#define dct_sel_interleave_addr(pvt)    \
+	(((pvt->dram_ctl_select_low) >> 6) & 0x3)
+
+enum {
+	F10_DCTL_SEL_LOW_DctSelHiRngEn	= BIT(0),
+	F10_DCTL_SEL_LOW_DctSelIntLvEn	= BIT(2),
+	F10_DCTL_SEL_LOW_DctGangEn	= BIT(4),
+	F10_DCTL_SEL_LOW_DctDatIntLv	= BIT(5),
+	F10_DCTL_SEL_LOW_DramEnable	= BIT(8),
+	F10_DCTL_SEL_LOW_MemCleared	= BIT(10),
+};
+
+#define    dct_high_range_enabled(pvt)    \
+	(pvt->dram_ctl_select_low & F10_DCTL_SEL_LOW_DctSelHiRngEn)
+
+#define dct_interleave_enabled(pvt)    \
+	(pvt->dram_ctl_select_low & F10_DCTL_SEL_LOW_DctSelIntLvEn)
+
+#define dct_ganging_enabled(pvt)        \
+	(pvt->dram_ctl_select_low & F10_DCTL_SEL_LOW_DctGangEn)
+
+#define dct_data_interleave_enabled(pvt)    \
+	(pvt->dram_ctl_select_low & F10_DCTL_SEL_LOW_DctDatIntLv)
+
+#define dct_dram_enabled(pvt)    \
+	(pvt->dram_ctl_select_low & F10_DCTL_SEL_LOW_DramEnable)
+
+#define dct_memory_cleared(pvt)    \
+	(pvt->dram_ctl_select_low & F10_DCTL_SEL_LOW_MemCleared)
+
+
+#define F10_DCTL_SEL_HIGH	0x114
+				/* device 0 Function 2 - DRAM
+				 * Controller SELECT HIGH
+				 */
+
+/**************************************************************/
+/* K8 register addresses - device 0 Function 3 - Misc Control */
+/**************************************************************/
+#define K8_NBCTL	0x40
+				/* Function 3: MCA NB Control (32b)
+				 *
+				 *  1    MCA UE Reporting
+				 *  0    MCA CE Reporting
+				 */
+/* Correctable ECC error reporting enable */
+#define K8_NBCTL_CECCEn		BIT(0)
+
+/* UnCorrectable ECC error reporting enable */
+#define K8_NBCTL_UECCEn		BIT(1)
+
+#define K8_NBCFG	0x44
+				/* Function 3: MCA NB Config (32b)
+				 *
+				 * 23    Chip-kill x4 ECC enable
+				 * 22    ECC enable
+				 */
+#define		K8_NBCFG_CHIPKILL	BIT(23)
+#define		K8_NBCFG_ECC_ENABLE	BIT(22)
+
+#define K8_NBSL		0x48
+				/* Function 3: MCA NB Status Low (32b)
+				 *
+				 * 31:24 Syndrome 15:8 chip-kill x4
+				 * 23:20 reserved
+				 * 19:16 Extended err code (F0fh and earlier)
+				 * 20:16 Extended err code (F10h and later)
+				 * 15:0  Err code
+				 */
+
+
+#define	EXTRACT_HIGH_SYNDROME(x)	(((x) >> 24) & 0xff)
+#define EXTRACT_EXT_ERROR_CODE(x)	(((x) >> 16) & 0x1f)
+
+/* Start Family F10h: Normalized Extended Error Codes */
+#define F10_NBSL_EXT_ERR_RES		(0x0)
+#define F10_NBSL_EXT_ERR_CRC		(0x1)
+#define F10_NBSL_EXT_ERR_SYNC		(0x2)
+#define F10_NBSL_EXT_ERR_MST		(0x3)
+#define F10_NBSL_EXT_ERR_TGT		(0x4)
+#define F10_NBSL_EXT_ERR_GART		(0x5)
+#define F10_NBSL_EXT_ERR_RMW		(0x6)
+#define F10_NBSL_EXT_ERR_WDT		(0x7)
+#define F10_NBSL_EXT_ERR_ECC		(0x8)
+#define F10_NBSL_EXT_ERR_DEV		(0x9)
+#define F10_NBSL_EXT_ERR_LINK_DATA	(0xA)
+
+/* Next two are overloaded values */
+#define F10_NBSL_EXT_ERR_LINK_PROTO	(0xB)
+#define F10_NBSL_EXT_ERR_L3_PROTO	(0xB)
+
+#define F10_NBSL_EXT_ERR_NB_ARRAY	(0xC)
+#define F10_NBSL_EXT_ERR_DRAM_PARITY	(0xD)
+#define F10_NBSL_EXT_ERR_LINK_RETRY	(0xE)
+
+/* Next two are overloaded values */
+#define F10_NBSL_EXT_ERR_GART_WALK	(0xF)
+#define F10_NBSL_EXT_ERR_DEV_WALK	(0xF)
+
+/* 0x10 to 0x1B: Reserved */
+
+#define F10_NBSL_EXT_ERR_L3_DATA	(0x1C)
+#define F10_NBSL_EXT_ERR_L3_TAG		(0x1D)
+#define F10_NBSL_EXT_ERR_L3_LRU		(0x1E)
+/* End Family F10h: Extended Error Codes */
+
+/* Start K8: Normalized Extended Error Codes */
+#define K8_NBSL_EXT_ERR_ECC		(0x0)
+#define K8_NBSL_EXT_ERR_CRC		(0x1)
+#define K8_NBSL_EXT_ERR_SYNC		(0x2)
+#define K8_NBSL_EXT_ERR_MST		(0x3)
+#define K8_NBSL_EXT_ERR_TGT		(0x4)
+#define K8_NBSL_EXT_ERR_GART		(0x5)
+#define K8_NBSL_EXT_ERR_RMW		(0x6)
+#define K8_NBSL_EXT_ERR_WDT		(0x7)
+#define K8_NBSL_EXT_ERR_CHIPKILL_ECC	(0x8)
+#define K8_NBSL_EXT_ERR_DRAM_PARITY	(0xD)
+/* End K8: Extended Error Codes */
+
+
+/* Error Code */
+#define EXTRACT_ERROR_CODE(x)	((x) & 0xffff)
+#define		TEST_TLB_ERROR(x)	(((x) & 0xFFF0) == 0x0010)
+#define		TEST_MEM_ERROR(x)	(((x) & 0xFF00) == 0x0100)
+#define		TEST_BUS_ERROR(x)	(((x) & 0xF800) == 0x0800)
+#define 	EXTRACT_TT_CODE(x)	(((x) >> 2) & 0x3)
+#define 	EXTRACT_II_CODE(x)	(((x) >> 2) & 0x3)
+#define 	EXTRACT_LL_CODE(x)	(((x) >> 0) & 0x3)
+#define		EXTRACT_RRRR_CODE(x)	(((x) >> 4) & 0xf)
+#define 	EXTRACT_TO_CODE(x)	(((x) >> 8) & 0x1)
+#define		EXTRACT_PP_CODE(x)	(((x) >> 9) & 0x3)
+
+/* The following are for BUS type errors AFTER values have been
+ * normalized by shifting right
+ */
+#define K8_NBSL_PP_SRC		(0x0)
+#define K8_NBSL_PP_RES		(0x1)
+#define K8_NBSL_PP_OBS		(0x2)
+#define K8_NBSL_PP_GENERIC	(0x3)
+
+
+#define K8_NBSH		0x4C
+				/* Function 3: MCA NB Status High (32b)
+				 *
+				 * 31    Err valid
+				 * 30    Err overflow
+				 * 29    Uncorrected err
+				 * 28    Err enable
+				 * 27    Misc err reg valid
+				 * 26    Err addr valid
+				 * 25    proc context corrupt
+				 * 24:23 reserved
+				 * 22:15 Syndrome bits 7:0
+				 * 14    CE
+				 * 13    UE
+				 * 12:9  reserved
+				 *  8    err found by scrubber
+				 *  7    reserved
+				 *  6:4  Hyper-transport link number
+				 *    3:2  reserved= Rev F/Family 10h=Quad Core
+				 *  3    Err CPU 3	(F10)
+				 *  2    Err CPU 2	(F10)
+				 *  1    Err CPU 1	(Dual Core)
+				 *  0    Err CPU 0
+				 */
+
+#define K8_NBSH_VALID_BIT		BIT(31)
+#define K8_NBSH_OVERFLOW		BIT(30)
+#define K8_NBSH_UNCORRECTED_ERR		BIT(29)
+#define K8_NBSH_ERR_ENABLE		BIT(28)
+#define K8_NBSH_MISC_ERR_VALID		BIT(27)
+#define K8_NBSH_VALID_ERROR_ADDR	BIT(26)
+#define K8_NBSH_PCC			BIT(25)
+#define K8_NBSH_CECC			BIT(14)
+#define K8_NBSH_UECC			BIT(13)
+#define K8_NBSH_ERR_SCRUBER		BIT(8)
+#define K8_NBSH_CORE3			BIT(3)
+#define K8_NBSH_CORE2			BIT(2)
+#define K8_NBSH_CORE1			BIT(1)
+#define K8_NBSH_CORE0			BIT(0)
+
+#define EXTRACT_LDT_LINK(x) 		(((x) >> 4) & 0x7)
+#define EXTRACT_ERR_CPU_MAP(x)		((x) & 0xF)
+#define EXTRACT_LOW_SYNDROME(x)		(((x) >> 15) & 0xff)
+
+
+#define K8_NBEAL	0x50
+				/* Function 3: MCA NB err addr low (32b)
+				 *
+				 * 31:3  Err addr low 31:3
+				 *  2:0  reserved
+				 */
+
+#define K8_NBEAH	0x54
+				/* Function 3: MCA NB err addr high (32b)
+				 *
+				 * 31:8  reserved
+				 *  7:0  Err addr high 39:32
+				 */
+
+#define K8_SCRCTRL      0x58
+				/* Function 3: Memory scrub control register.
+				 *
+				 * 30:21 reserved
+				 * 20:16 dcache scrub
+				 * 15:13 reserved
+				 * 12:8  L2Scrub
+				 * 7:5   reserved
+				 * 4:0   dramscrub
+				 *
+				 */
+
+
+
+#define F10_NB_CFG_LOW	0x88
+				/* Function 3: NB Configuration reg low */
+#define 	F10_NB_CFG_LOW_ENABLE_EXT_CFG	BIT(14)
+
+#define F10_NB_CFG_HIGH	0x8C
+				/* Function 3: NB Configuration reg high */
+
+
+#define F10_ONLINE_SPARE	0xB0
+				/* Function 3: On-Line Spare Control Register */
+#define F10_ONLINE_SPARE_SWAPDONE0(x)	((x) & BIT(1))
+#define F10_ONLINE_SPARE_SWAPDONE1(x)	((x) & BIT(3))
+#define F10_ONLINE_SPARE_BADDRAM_CS0(x)	(((x) >> 4) & 0x00000007)
+#define F10_ONLINE_SPARE_BADDRAM_CS1(x)	(((x) >> 8) & 0x00000007)
+
+
+#define F10_NB_ARRAY_ADDR	0xB8
+				/* Function 3:
+				 *	Error injection NB Array Addr Reg
+				 *
+				 * For a 64-byte cacheline, we can select
+				 * one of 4 16-byte sections (0,1,2,3) of
+				 * that cacheline.
+				 * Bits 2:1 provide that selection.
+				 *
+				 * which 16-bit word of the section is
+				 * selected by bitmap 28:20 of F10_NB_ARRAY_DATA
+				 *
+				 * which bit of the the selected word
+				 * is then masked by bits 15:0 of the same reg
+				 *
+				 * Thus we have a tuple of:
+				 *	section,word,bit
+				 */
+
+				/* DRAM ECC Array Select */
+#define F10_NB_ARRAY_DRAM_ECC	0x80000000
+
+				/* Bits 2:1 are used to select 16-byte
+				 * section within a 64-byte cacheline
+				 */
+#define SET_NB_ARRAY_ADDRESS(section)	(((section) & 0x3) << 1)
+
+#define F10_NB_ARRAY_DATA	0xBC
+				/* Function 3:
+				 *	Error injection NB Array Data Reg
+				 *
+				 * 28:20	ErrInjEn selects 16-bit word
+				 *		(bit map: 0-8)
+				 * 17		EccWrReq
+				 * 16		EccRdReq
+				 * 15:0		EccVector, select bits
+				 */
+#define SET_NB_DRAM_INJECTION_WRITE(word, bits)  \
+				(BIT(((word) & 0xF) + 20) | \
+				BIT(17) |  \
+				((bits) & 0xF))
+#define SET_NB_DRAM_INJECTION_READ(word, bits)  \
+				(BIT(((word) & 0xF) + 20) | \
+				BIT(16) |  \
+				((bits) & 0xF))
+
+
+
+#define K8_NBCAP	0xE8
+				/* Function 3: MCA NB capabilities (32b)
+				 *
+				 * 31:9  reserved
+				 *  4    ChipKill S4ECD4ED capable
+				 *  3    SECDED capable
+				 */
+#define K8_NBCAP_CORES		(BIT(12)|BIT(13))
+#define K8_NBCAP_CHIPKILL	BIT(4)
+#define K8_NBCAP_SECDED		BIT(3)
+#define K8_NBCAP_8_NODE		BIT(2)
+#define K8_NBCAP_DUAL_NODE	BIT(1)
+#define K8_NBCAP_DCT_DUAL	BIT(0)
+
+				/* MSR's */
+
+				/*
+				 * K8_MSR_MCxCTL (64b)
+				 * (0x400,404,408,40C,410)
+				 * 63    Enable reporting source 63
+				 *  .
+				 *  .
+				 *  .
+				 *  2    Enable error source 2
+				 *  1    Enable error source 1
+				 *  0    Enable error source 0
+				 */
+
+				/*
+				 * K8_MSR_MCxSTAT (64b)
+				 * (0x401,405,409,40D,411)
+				 * 63    Error valid
+				 * 62    Status overflow
+				 * 61    UE
+				 * 60    Enabled error condition
+				 * 59    Misc register valid (not used)
+				 * 58    Err addr register valid
+				 * 57    Processor context corrupt
+				 * 56:32 Other information
+				 * 31:16 Model specific error code
+				 * 15:0  MCA err code
+				 */
+
+				/*
+				 * K8_MSR_MCxADDR (64b)
+				 * (0x402,406,40A,40E,412)
+				 * 63:48 reserved
+				 * 47:0  Address
+				 */
+
+				/*
+				 * K8_MSR_MCxMISC (64b)
+				 * (0x403,407,40B,40F,413)
+				 * Unused on Athlon64 and K8
+				 */
+
+/* MSR Regs */
+#define K8_MSR_MCGCTL	0x017b
+				/* Machine Chk Global report ctl (64b)
+				 *
+				 * 31:5  reserved
+				 *  4    North Bridge
+				 *  3    Load/Store
+				 *  2    Bus Unit
+				 *  1    Instruction Cache
+				 *  0    Data Cache
+				 */
+#define K8_MSR_MCGCTL_NBE	BIT(4)
+
+#define K8_MSR_MC4CTL	0x0410	/* North Bridge Check report ctl (64b) */
+#define K8_MSR_MC4STAT	0x0411	/* North Bridge status (64b) */
+#define K8_MSR_MC4ADDR	0x0412	/* North Bridge Address (64b) */
+
+/**
+ * popcnt - count the set bits in a bit vector.
+ * @vec - bit vector
+ *
+ * This instruction is supported only on F10h and later CPUs.
+ */
+#define popcnt(x)						\
+({								\
+	typeof(x) __ret;					\
+	__asm__("popcnt %1, %0" : "=r" (__ret) : "r" (x));	\
+	__ret;							\
+})
+
+/* AMD sets the first MC device at device ID 0x18. */
+static inline int get_mc_node_id_from_pdev(struct pci_dev *pdev)
+{
+	return PCI_SLOT(pdev->devfn) - 0x18;
+}
+
+enum amd64_chipset_families {
+	K8_CPUS = 0,
+	F10_CPUS,
+	F11_CPUS,
+};
+
+/*
+ * Structure to hold:
+ *	1) dynamicly read status and error address HW registers
+ *	2) sysfs entered values
+ *	3) MCE values
+ *
+ * Depends on entry into the modules
+ */
+struct amd64_error_info_regs {
+	u32 nbcfg;
+	u32 nbsh;
+	u32 nbsl;
+	u32 nbeah;
+	u32 nbeal;
+};
+
+/*
+ * Error injection control structure
+ */
+struct error_injection {
+	u32	section;
+	u32	word;
+	u32	bit_map;
+};
+
+struct amd64_pvt {
+	/* pci_device handles which we utilize */
+	struct pci_dev *addr_f1_ctl;
+	struct pci_dev *dram_f2_ctl;
+	struct pci_dev *misc_f3_ctl;
+
+	int mc_node_id;		/* MC index of this MC node */
+	int ext_model;		/* extended model value of this node */
+
+	struct low_ops	*ops;	/* pointer to per PCI Device ID func table */
+
+	int channel_count;	/* Count of 'channels' */
+
+	/* Raw registers */
+	u32 dclr0;		/* DRAM Configuration Low DCT0 reg */
+	u32 dclr1;		/* DRAM Configuration Low DCT1 reg */
+	u32 dchr0;		/* DRAM Configuration High DCT0 reg */
+	u32 dchr1;		/* DRAM Configuration High DCT1 reg */
+	u32 nbcap;		/* North Bridge Capabilities */
+	u32 nbcfg;		/* F10 North Bridge Configuration */
+	u32 ext_nbcfg;		/* Extended F10 North Bridge Configuration */
+	u32 dhar;		/* DRAM Hoist reg */
+	u32 dbam0;		/* DRAM Base Address Mapping reg for DCT0 */
+	u32 dbam1;		/* DRAM Base Address Mapping reg for DCT1 */
+
+	/* DRAM CS Base Address Registers
+	 *   F2x[1,0][5C:40]
+	 */
+	u32 dcsb0[CHIPSELECT_COUNT];    /* DRAM CS Base Registers */
+	u32 dcsb1[CHIPSELECT_COUNT];    /* DRAM CS Base Registers */
+
+	/* DRAM CS Mask Registers
+	 *   F2x[1,0][6C:60]
+	 */
+	u32 dcsm0[CHIPSELECT_COUNT];    /* DRAM CS Mask Registers */
+	u32 dcsm1[CHIPSELECT_COUNT];    /* DRAM CS Mask Registers */
+
+	/* Decoded parts of DRAM BASE and LIMIT Registers
+	 * F1x[78,70,68,60,58,50,48,40]
+	 */
+	u64 dram_base[DRAM_REG_COUNT];/* DRAM Base Reg */
+	u64 dram_limit[DRAM_REG_COUNT];/* DRAM Limit Reg */
+	u8 dram_IntlvSel[DRAM_REG_COUNT];
+	u8 dram_IntlvEn[DRAM_REG_COUNT];
+	u8 dram_DstNode[DRAM_REG_COUNT];
+	u8 dram_rw_en[DRAM_REG_COUNT];
+
+	/* The following fields are set at (load) run time, after Revision has
+	 * been determined, since the dct_base and dct_mask registers vary
+	 * by CPU Revsion
+	 */
+	u32 dcsb_base;		/* DCSB base bits */
+	u32 dcsm_mask;		/* DCSM mask bits */
+	u32 num_dcsm;		/* Number of DCSM registers */
+	u32 dcs_mask_notused;	/* DCSM notused mask bits */
+	u32 dcs_shift;		/* DCSB and DCSM shift value */
+
+	u64 top_mem;		/* top of memory below 4GB */
+	u64 top_mem2;		/* top of memory above 4GB */
+
+	/* F10 registers */
+	u32 dram_ctl_select_low;	/* DRAM Controller Select Low Reg */
+	u32 dram_ctl_select_high;	/* DRAM Controller Select High Reg */
+	u32 online_spare;               /* On-Line spare Reg */
+
+	/* sysfs storage area: Temp storage for when input
+	 * is received from sysfs
+	 */
+	struct amd64_error_info_regs ctl_error_info;
+
+	/* Place to store error injection parameters prior to issue */
+	struct error_injection injection;
+
+	/* Save old hw registers' values before we modified them */
+	u32 nbctl_mcgctl_saved;		/* When true, following 2 are valid */
+	u32 old_nbctl;
+	u32 *old_mcgctl;		/* per core on this node */
+
+	/* MC Type Index value: socket F vs Family 10h */
+	u32 mc_type_index;
+
+	/* misc settings */
+	struct flags {
+		unsigned long cf8_extcfg:1;
+	} flags;
+};
+
+struct scrubrate {
+       u32 scrubval;           /* bit pattern for scrub rate */
+       u32 bandwidth;          /* bandwidth consumed (bytes/sec) */
+};
+
+extern struct scrubrate scrubrates[23];
+extern u32 revf_quad_ddr2_shift[16];
+extern const char *tt_msgs[4];
+extern const char *ll_msgs[4];
+extern const char *rrrr_msgs[16];
+extern const char *to_msgs[2];
+extern const char *pp_msgs[4];
+extern const char *ii_msgs[4];
+extern const char *ext_msgs[32];
+extern const char *htlink_msgs[8];
+
+/*
+ * Each of the PCI Device IDs types have their own set of hardware
+ * accessor function and per device encoding/decoding logic.
+ */
+struct low_ops {
+	int (*probe_valid_hardware)(struct amd64_pvt *pvt);
+	int (*early_channel_count)(struct amd64_pvt *pvt);
+
+	u64 (*get_error_address)(struct mem_ctl_info *mci,
+			struct amd64_error_info_regs *info);
+	void (*read_dram_base_limit)(struct amd64_pvt *pvt, int dram);
+	void (*read_dram_ctl_register)(struct amd64_pvt *pvt);
+	void (*map_sysaddr_to_csrow)(struct mem_ctl_info *mci,
+					struct amd64_error_info_regs *info,
+					u64 SystemAddr);
+	int (*dbam_map_to_pages)(struct amd64_pvt *pvt, int dram_map);
+};
+
+/*
+ * amd64 family unique information
+ */
+struct amd64_family_type {
+	const char *ctl_name;
+	u16 addr_f1_ctl;
+	u16 misc_f3_ctl;
+	struct low_ops ops;
+};
+
+static struct amd64_family_type amd64_family_types[];
+
+static inline const char *get_amd_family_name(int index)
+{
+	return amd64_family_types[index].ctl_name;
+}
+
+static inline struct low_ops *get_amd_family_ops(int index)
+{
+	return &amd64_family_types[index].ops;
+}
+
+/*
+ * For future CPU versions, verify the following as new 'slow' rates appear and
+ * modify the necessary skip values for the supported CPU.
+ */
+#define K8_MIN_SCRUB_RATE_BITS	0x0
+#define F10_MIN_SCRUB_RATE_BITS	0x5
+#define F11_MIN_SCRUB_RATE_BITS	0x6
+
+int amd64_process_error_info(struct mem_ctl_info *mci,
+			     struct amd64_error_info_regs *info,
+			     int handle_errors);
+int amd64_get_dram_hole_info(struct mem_ctl_info *mci, u64 *hole_base,
+			     u64 *hole_offset, u64 *hole_size);
-- 
1.6.2.4


