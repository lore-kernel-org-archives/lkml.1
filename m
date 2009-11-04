Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZKDJFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZKDJFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 04:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZKDJFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 04:05:45 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:33321 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbZKDJFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 04:05:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WIMp94vCE6IFU05nsQ9AhHOU479yr8RXeWzCuE4MSXoOMH9zgPpnqQwyPbkamsUeYA
         hLIaFY5ji8RcDsCUN2V6i9t0nuCrQGHvexP/2ZHIHL8C4V6l6ZM8/dAA4GTjMo1QKwNZ
         cepxrno16P2lXvVw5XonmuLBAqzgR3nnzgzOg=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, huhb@lemote.com, yanh@lemote.com,
       Zhang Le <r0bertz@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
Subject: [PATCH -queue v0 3/6] [loongson] add basic cs5536 vsm support
Date: Wed,  4 Nov 2009 17:05:28 +0800
Message-Id: <6d5b947065d939155460c05d24d56e9fbb417680.1257325319.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1257325319.git.wuzhangjin@gmail.com>
References: <cover.1257325319.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provide the read/write interfaces for Virtual Support
Module(VSM, includes isa, ide, acc, ohci, ehci), fuloong2f and
yeeloong2f use cs5536 as their south bridge, need this lowlevel
interfaces to access the devices connectted to cs5536.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 .../mips/include/asm/mach-loongson/cs5536/cs5536.h |  305 ++++++++++++++++++
 .../include/asm/mach-loongson/cs5536/cs5536_pci.h  |  153 +++++++++
 .../include/asm/mach-loongson/cs5536/cs5536_vsm.h  |   31 ++
 arch/mips/loongson/Kconfig                         |    3 +
 arch/mips/loongson/common/Makefile                 |    6 +
 arch/mips/loongson/common/cs5536/Makefile          |    8 +
 arch/mips/loongson/common/cs5536/cs5536_acc.c      |  150 +++++++++
 arch/mips/loongson/common/cs5536/cs5536_ehci.c     |  160 ++++++++++
 arch/mips/loongson/common/cs5536/cs5536_ide.c      |  187 ++++++++++++
 arch/mips/loongson/common/cs5536/cs5536_isa.c      |  322 ++++++++++++++++++++
 arch/mips/loongson/common/cs5536/cs5536_ohci.c     |  155 ++++++++++
 arch/mips/loongson/common/cs5536/cs5536_pci.c      |   89 ++++++
 12 files changed, 1569 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-loongson/cs5536/cs5536.h
 create mode 100644 arch/mips/include/asm/mach-loongson/cs5536/cs5536_pci.h
 create mode 100644 arch/mips/include/asm/mach-loongson/cs5536/cs5536_vsm.h
 create mode 100644 arch/mips/loongson/common/cs5536/Makefile
 create mode 100644 arch/mips/loongson/common/cs5536/cs5536_acc.c
 create mode 100644 arch/mips/loongson/common/cs5536/cs5536_ehci.c
 create mode 100644 arch/mips/loongson/common/cs5536/cs5536_ide.c
 create mode 100644 arch/mips/loongson/common/cs5536/cs5536_isa.c
 create mode 100644 arch/mips/loongson/common/cs5536/cs5536_ohci.c
 create mode 100644 arch/mips/loongson/common/cs5536/cs5536_pci.c

diff --git a/arch/mips/include/asm/mach-loongson/cs5536/cs5536.h b/arch/mips/include/asm/mach-loongson/cs5536/cs5536.h
new file mode 100644
index 0000000..021f77c
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson/cs5536/cs5536.h
@@ -0,0 +1,305 @@
+/*
+ * The header file of cs5536 sourth bridge.
+ *
+ * Copyright (C) 2007 Lemote, Inc.
+ * Author : jlliu <liujl@lemote.com>
+ */
+
+#ifndef	_CS5536_H
+#define	_CS5536_H
+
+#include <linux/types.h>
+
+extern void _rdmsr(u32 msr, u32 *hi, u32 *lo);
+extern void _wrmsr(u32 msr, u32 hi, u32 lo);
+
+/*
+ * MSR module base
+ */
+#define	CS5536_SB_MSR_BASE	(0x00000000)
+#define	CS5536_GLIU_MSR_BASE	(0x10000000)
+#define	CS5536_ILLEGAL_MSR_BASE	(0x20000000)
+#define	CS5536_USB_MSR_BASE	(0x40000000)
+#define	CS5536_IDE_MSR_BASE	(0x60000000)
+#define	CS5536_DIVIL_MSR_BASE	(0x80000000)
+#define	CS5536_ACC_MSR_BASE	(0xa0000000)
+#define	CS5536_UNUSED_MSR_BASE	(0xc0000000)
+#define	CS5536_GLCP_MSR_BASE	(0xe0000000)
+
+#define	SB_MSR_REG(offset)	(CS5536_SB_MSR_BASE	| (offset))
+#define	GLIU_MSR_REG(offset)	(CS5536_GLIU_MSR_BASE	| (offset))
+#define	ILLEGAL_MSR_REG(offset)	(CS5536_ILLEGAL_MSR_BASE | (offset))
+#define	USB_MSR_REG(offset)	(CS5536_USB_MSR_BASE	| (offset))
+#define	IDE_MSR_REG(offset)	(CS5536_IDE_MSR_BASE	| (offset))
+#define	DIVIL_MSR_REG(offset)	(CS5536_DIVIL_MSR_BASE	| (offset))
+#define	ACC_MSR_REG(offset)	(CS5536_ACC_MSR_BASE	| (offset))
+#define	UNUSED_MSR_REG(offset)	(CS5536_UNUSED_MSR_BASE	| (offset))
+#define	GLCP_MSR_REG(offset)	(CS5536_GLCP_MSR_BASE	| (offset))
+
+/*
+ * BAR SPACE OF VIRTUAL PCI :
+ * range for pci probe use, length is the actual size.
+ */
+/* IO space for all DIVIL modules */
+#define	CS5536_IRQ_RANGE	0xffffffe0 /* USERD FOR PCI PROBE */
+#define	CS5536_IRQ_LENGTH	0x20	/* THE REGS ACTUAL LENGTH */
+#define	CS5536_SMB_RANGE	0xfffffff8
+#define	CS5536_SMB_LENGTH	0x08
+#define	CS5536_GPIO_RANGE	0xffffff00
+#define	CS5536_GPIO_LENGTH	0x100
+#define	CS5536_MFGPT_RANGE	0xffffffc0
+#define	CS5536_MFGPT_LENGTH	0x40
+#define	CS5536_ACPI_RANGE	0xffffffe0
+#define	CS5536_ACPI_LENGTH	0x20
+#define	CS5536_PMS_RANGE	0xffffff80
+#define	CS5536_PMS_LENGTH	0x80
+/* IO space for IDE */
+#define	CS5536_IDE_RANGE	0xfffffff0
+#define	CS5536_IDE_LENGTH	0x10
+/* IO space for ACC */
+#define	CS5536_ACC_RANGE	0xffffff80
+#define	CS5536_ACC_LENGTH	0x80
+/* MEM space for ALL USB modules */
+#define	CS5536_OHCI_RANGE	0xfffff000
+#define	CS5536_OHCI_LENGTH	0x1000
+#define	CS5536_EHCI_RANGE	0xfffff000
+#define	CS5536_EHCI_LENGTH	0x1000
+
+/*
+ * PCI MSR ACCESS
+ */
+#define	PCI_MSR_CTRL		0xF0
+#define	PCI_MSR_ADDR		0xF4
+#define	PCI_MSR_DATA_LO		0xF8
+#define	PCI_MSR_DATA_HI		0xFC
+
+/**************** MSR *****************************/
+
+/*
+ * GLIU STANDARD MSR
+ */
+#define	GLIU_CAP		0x00
+#define	GLIU_CONFIG		0x01
+#define	GLIU_SMI		0x02
+#define	GLIU_ERROR		0x03
+#define	GLIU_PM			0x04
+#define	GLIU_DIAG		0x05
+
+/*
+ * GLIU SPEC. MSR
+ */
+#define	GLIU_P2D_BM0		0x20
+#define	GLIU_P2D_BM1		0x21
+#define	GLIU_P2D_BM2		0x22
+#define	GLIU_P2D_BMK0		0x23
+#define	GLIU_P2D_BMK1		0x24
+#define	GLIU_P2D_BM3		0x25
+#define	GLIU_P2D_BM4		0x26
+#define	GLIU_COH		0x80
+#define	GLIU_PAE		0x81
+#define	GLIU_ARB		0x82
+#define	GLIU_ASMI		0x83
+#define	GLIU_AERR		0x84
+#define	GLIU_DEBUG		0x85
+#define	GLIU_PHY_CAP		0x86
+#define	GLIU_NOUT_RESP		0x87
+#define	GLIU_NOUT_WDATA		0x88
+#define	GLIU_WHOAMI		0x8B
+#define	GLIU_SLV_DIS		0x8C
+#define	GLIU_IOD_BM0		0xE0
+#define	GLIU_IOD_BM1		0xE1
+#define	GLIU_IOD_BM2		0xE2
+#define	GLIU_IOD_BM3		0xE3
+#define	GLIU_IOD_BM4		0xE4
+#define	GLIU_IOD_BM5		0xE5
+#define	GLIU_IOD_BM6		0xE6
+#define	GLIU_IOD_BM7		0xE7
+#define	GLIU_IOD_BM8		0xE8
+#define	GLIU_IOD_BM9		0xE9
+#define	GLIU_IOD_SC0		0xEA
+#define	GLIU_IOD_SC1		0xEB
+#define	GLIU_IOD_SC2		0xEC
+#define	GLIU_IOD_SC3		0xED
+#define	GLIU_IOD_SC4		0xEE
+#define	GLIU_IOD_SC5		0xEF
+#define	GLIU_IOD_SC6		0xF0
+#define	GLIU_IOD_SC7		0xF1
+
+/*
+ * SB STANDARD
+ */
+#define	SB_CAP		0x00
+#define	SB_CONFIG	0x01
+#define	SB_SMI		0x02
+#define	SB_ERROR	0x03
+#define	SB_MAR_ERR_EN		0x00000001
+#define	SB_TAR_ERR_EN		0x00000002
+#define	SB_RSVD_BIT1		0x00000004
+#define	SB_EXCEP_ERR_EN		0x00000008
+#define	SB_SYSE_ERR_EN		0x00000010
+#define	SB_PARE_ERR_EN		0x00000020
+#define	SB_TAS_ERR_EN		0x00000040
+#define	SB_MAR_ERR_FLAG		0x00010000
+#define	SB_TAR_ERR_FLAG		0x00020000
+#define	SB_RSVD_BIT2		0x00040000
+#define	SB_EXCEP_ERR_FLAG	0x00080000
+#define	SB_SYSE_ERR_FLAG	0x00100000
+#define	SB_PARE_ERR_FLAG	0x00200000
+#define	SB_TAS_ERR_FLAG		0x00400000
+#define	SB_PM		0x04
+#define	SB_DIAG		0x05
+
+/*
+ * SB SPEC.
+ */
+#define	SB_CTRL		0x10
+#define	SB_R0		0x20
+#define	SB_R1		0x21
+#define	SB_R2		0x22
+#define	SB_R3		0x23
+#define	SB_R4		0x24
+#define	SB_R5		0x25
+#define	SB_R6		0x26
+#define	SB_R7		0x27
+#define	SB_R8		0x28
+#define	SB_R9		0x29
+#define	SB_R10		0x2A
+#define	SB_R11		0x2B
+#define	SB_R12		0x2C
+#define	SB_R13		0x2D
+#define	SB_R14		0x2E
+#define	SB_R15		0x2F
+
+/*
+ * GLCP STANDARD
+ */
+#define	GLCP_CAP		0x00
+#define	GLCP_CONFIG		0x01
+#define	GLCP_SMI		0x02
+#define	GLCP_ERROR		0x03
+#define	GLCP_PM			0x04
+#define	GLCP_DIAG		0x05
+
+/*
+ * GLCP SPEC.
+ */
+#define	GLCP_CLK_DIS_DELAY	0x08
+#define	GLCP_PM_CLK_DISABLE	0x09
+#define	GLCP_GLB_PM		0x0B
+#define	GLCP_DBG_OUT		0x0C
+#define	GLCP_RSVD1		0x0D
+#define	GLCP_SOFT_COM		0x0E
+#define	SOFT_BAR_SMB_FLAG	0x00000001
+#define	SOFT_BAR_GPIO_FLAG	0x00000002
+#define	SOFT_BAR_MFGPT_FLAG	0x00000004
+#define	SOFT_BAR_IRQ_FLAG	0x00000008
+#define	SOFT_BAR_PMS_FLAG	0x00000010
+#define	SOFT_BAR_ACPI_FLAG	0x00000020
+#define	SOFT_BAR_IDE_FLAG	0x00000400
+#define	SOFT_BAR_ACC_FLAG	0x00000800
+#define	SOFT_BAR_OHCI_FLAG	0x00001000
+#define	SOFT_BAR_EHCI_FLAG	0x00002000
+#define	GLCP_RSVD2		0x0F
+#define	GLCP_CLK_OFF		0x10
+#define	GLCP_CLK_ACTIVE		0x11
+#define	GLCP_CLK_DISABLE	0x12
+#define	GLCP_CLK4ACK		0x13
+#define	GLCP_SYS_RST		0x14
+#define	GLCP_RSVD3		0x15
+#define	GLCP_DBG_CLK_CTRL	0x16
+#define	GLCP_CHIP_REV_ID	0x17
+
+/* PIC */
+#define	PIC_YSEL_LOW		0x20
+#define	PIC_YSEL_LOW_USB_SHIFT		8
+#define	PIC_YSEL_LOW_ACC_SHIFT		16
+#define	PIC_YSEL_LOW_FLASH_SHIFT	24
+#define	PIC_YSEL_HIGH		0x21
+#define	PIC_ZSEL_LOW		0x22
+#define	PIC_ZSEL_HIGH		0x23
+#define	PIC_IRQM_PRIM		0x24
+#define	PIC_IRQM_LPC		0x25
+#define	PIC_XIRR_STS_LOW	0x26
+#define	PIC_XIRR_STS_HIGH	0x27
+#define	PCI_SHDW		0x34
+
+/*
+ * DIVIL STANDARD
+ */
+#define	DIVIL_CAP		0x00
+#define	DIVIL_CONFIG		0x01
+#define	DIVIL_SMI		0x02
+#define	DIVIL_ERROR		0x03
+#define	DIVIL_PM		0x04
+#define	DIVIL_DIAG		0x05
+
+/*
+ * DIVIL SPEC.
+ */
+#define	DIVIL_LBAR_IRQ		0x08
+#define	DIVIL_LBAR_KEL		0x09
+#define	DIVIL_LBAR_SMB		0x0B
+#define	DIVIL_LBAR_GPIO		0x0C
+#define	DIVIL_LBAR_MFGPT	0x0D
+#define	DIVIL_LBAR_ACPI		0x0E
+#define	DIVIL_LBAR_PMS		0x0F
+#define	DIVIL_LEG_IO		0x14
+#define	DIVIL_BALL_OPTS		0x15
+#define	DIVIL_SOFT_IRQ		0x16
+#define	DIVIL_SOFT_RESET	0x17
+
+/* MFGPT */
+#define MFGPT_IRQ	0x28
+
+/*
+ * IDE STANDARD
+ */
+#define	IDE_CAP		0x00
+#define	IDE_CONFIG	0x01
+#define	IDE_SMI		0x02
+#define	IDE_ERROR	0x03
+#define	IDE_PM		0x04
+#define	IDE_DIAG	0x05
+
+/*
+ * IDE SPEC.
+ */
+#define	IDE_IO_BAR	0x08
+#define	IDE_CFG		0x10
+#define	IDE_DTC		0x12
+#define	IDE_CAST	0x13
+#define	IDE_ETC		0x14
+#define	IDE_INTERNAL_PM	0x15
+
+/*
+ * ACC STANDARD
+ */
+#define	ACC_CAP		0x00
+#define	ACC_CONFIG	0x01
+#define	ACC_SMI		0x02
+#define	ACC_ERROR	0x03
+#define	ACC_PM		0x04
+#define	ACC_DIAG	0x05
+
+/*
+ * USB STANDARD
+ */
+#define	USB_CAP		0x00
+#define	USB_CONFIG	0x01
+#define	USB_SMI		0x02
+#define	USB_ERROR	0x03
+#define	USB_PM		0x04
+#define	USB_DIAG	0x05
+
+/*
+ * USB SPEC.
+ */
+#define	USB_OHCI	0x08
+#define	USB_EHCI	0x09
+
+/****************** NATIVE ***************************/
+/* GPIO : I/O SPACE; REG : 32BITS */
+#define	GPIOL_OUT_VAL		0x00
+#define	GPIOL_OUT_EN		0x04
+
+#endif				/* _CS5536_H */
diff --git a/arch/mips/include/asm/mach-loongson/cs5536/cs5536_pci.h b/arch/mips/include/asm/mach-loongson/cs5536/cs5536_pci.h
new file mode 100644
index 0000000..0dca9c8
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson/cs5536/cs5536_pci.h
@@ -0,0 +1,153 @@
+/*
+ * the definition file of cs5536 Virtual Support Module(VSM).
+ * pci configuration space can be accessed through the VSM, so
+ * there is no need of the MSR read/write now, except the spec.
+ * MSR registers which are not implemented yet.
+ *
+ * Copyright (C) 2007 Lemote Inc.
+ * Author : jlliu, liujl@lemote.com
+ */
+
+#ifndef	_CS5536_PCI_H
+#define	_CS5536_PCI_H
+
+#include <linux/types.h>
+#include <linux/pci_regs.h>
+
+extern void cs5536_pci_conf_write4(int function, int reg, u32 value);
+extern u32 cs5536_pci_conf_read4(int function, int reg);
+
+#define	CS5536_ACC_INTR		9
+#define	CS5536_IDE_INTR		14
+#define	CS5536_USB_INTR		11
+#define	CS5536_MFGPT_INTR	5
+#define	CS5536_UART1_INTR	4
+#define	CS5536_UART2_INTR	3
+
+/************** PCI BUS DEVICE FUNCTION ***************/
+
+/*
+ * PCI bus device function
+ */
+#define	PCI_BUS_CS5536		0
+#define	PCI_IDSEL_CS5536	14
+
+/********** STANDARD PCI-2.2 EXPANSION ****************/
+
+/*
+ * PCI configuration space
+ * we have to virtualize the PCI configure space head, so we should
+ * define the necessary IDs and some others.
+ */
+
+/* CONFIG of PCI VENDOR ID*/
+#define CFG_PCI_VENDOR_ID(mod_dev_id, sys_vendor_id) \
+	(((mod_dev_id) << 16) | (sys_vendor_id))
+
+/* VENDOR ID */
+#define	CS5536_VENDOR_ID	0x1022
+
+/* DEVICE ID */
+#define	CS5536_ISA_DEVICE_ID		0x2090
+#define	CS5536_IDE_DEVICE_ID		0x209a
+#define	CS5536_ACC_DEVICE_ID		0x2093
+#define	CS5536_OHCI_DEVICE_ID		0x2094
+#define	CS5536_EHCI_DEVICE_ID		0x2095
+
+/* CLASS CODE : CLASS SUB-CLASS INTERFACE */
+#define	CS5536_ISA_CLASS_CODE		0x060100
+#define CS5536_IDE_CLASS_CODE		0x010180
+#define	CS5536_ACC_CLASS_CODE		0x040100
+#define	CS5536_OHCI_CLASS_CODE		0x0C0310
+#define	CS5536_EHCI_CLASS_CODE		0x0C0320
+
+/* BHLC : BIST HEADER-TYPE LATENCY-TIMER CACHE-LINE-SIZE */
+
+#define CFG_PCI_CACHE_LINE_SIZE(header_type, latency_timer)	\
+	((PCI_NONE_BIST << 24) | ((header_type) << 16) \
+		| ((latency_timer) << 8) | PCI_NORMAL_CACHE_LINE_SIZE);
+
+#define	PCI_NONE_BIST			0x00	/* RO not implemented yet. */
+#define	PCI_BRIDGE_HEADER_TYPE		0x80	/* RO */
+#define	PCI_NORMAL_HEADER_TYPE		0x00
+#define	PCI_NORMAL_LATENCY_TIMER	0x00
+#define	PCI_NORMAL_CACHE_LINE_SIZE	0x08	/* RW */
+
+/* BAR */
+#define	PCI_BAR0_REG			0x10
+#define	PCI_BAR1_REG			0x14
+#define	PCI_BAR2_REG			0x18
+#define	PCI_BAR3_REG			0x1c
+#define	PCI_BAR4_REG			0x20
+#define	PCI_BAR5_REG			0x24
+#define	PCI_BAR_COUNT			6
+#define	PCI_BAR_RANGE_MASK		0xFFFFFFFF
+
+/* CARDBUS CIS POINTER */
+#define	PCI_CARDBUS_CIS_POINTER		0x00000000
+
+/* SUBSYSTEM VENDOR ID  */
+#define	CS5536_SUB_VENDOR_ID		CS5536_VENDOR_ID
+
+/* SUBSYSTEM ID */
+#define	CS5536_ISA_SUB_ID		CS5536_ISA_DEVICE_ID
+#define	CS5536_IDE_SUB_ID		CS5536_IDE_DEVICE_ID
+#define	CS5536_ACC_SUB_ID		CS5536_ACC_DEVICE_ID
+#define	CS5536_OHCI_SUB_ID		CS5536_OHCI_DEVICE_ID
+#define	CS5536_EHCI_SUB_ID		CS5536_EHCI_DEVICE_ID
+
+/* EXPANSION ROM BAR */
+#define	PCI_EXPANSION_ROM_BAR		0x00000000
+
+/* CAPABILITIES POINTER */
+#define	PCI_CAPLIST_POINTER		0x00000000
+#define PCI_CAPLIST_USB_POINTER		0x40
+/* INTERRUPT */
+
+#define CFG_PCI_INTERRUPT_LINE(pin, mod_intr) \
+	((PCI_MAX_LATENCY << 24) | (PCI_MIN_GRANT << 16) | \
+		((pin) << 8) | (mod_intr))
+
+#define	PCI_MAX_LATENCY			0x40
+#define	PCI_MIN_GRANT			0x00
+#define	PCI_DEFAULT_PIN			0x01
+
+/*********** EXPANSION PCI REG ************************/
+
+/*
+ * ISA EXPANSION
+ */
+#define	PCI_UART1_INT_REG 	0x50
+#define PCI_UART2_INT_REG	0x54
+#define	PCI_ISA_FIXUP_REG	0x58
+
+/*
+ * IDE EXPANSION
+ */
+#define	PCI_IDE_CFG_REG		0x40
+#define	CS5536_IDE_FLASH_SIGNATURE	0xDEADBEEF
+#define	PCI_IDE_DTC_REG		0x48
+#define	PCI_IDE_CAST_REG	0x4C
+#define	PCI_IDE_ETC_REG		0x50
+#define	PCI_IDE_PM_REG		0x54
+#define	PCI_IDE_INT_REG		0x60
+
+/*
+ * ACC EXPANSION
+ */
+#define	PCI_ACC_INT_REG		0x50
+
+/*
+ * OHCI EXPANSION : INTTERUPT IS IMPLEMENTED BY THE OHCI
+ */
+#define	PCI_OHCI_PM_REG		0x40
+#define	PCI_OHCI_INT_REG	0x50
+
+/*
+ * EHCI EXPANSION
+ */
+#define	PCI_EHCI_LEGSMIEN_REG	0x50
+#define	PCI_EHCI_LEGSMISTS_REG	0x54
+#define	PCI_EHCI_FLADJ_REG	0x60
+
+#endif				/* _CS5536_PCI_H_ */
diff --git a/arch/mips/include/asm/mach-loongson/cs5536/cs5536_vsm.h b/arch/mips/include/asm/mach-loongson/cs5536/cs5536_vsm.h
new file mode 100644
index 0000000..6305bea
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson/cs5536/cs5536_vsm.h
@@ -0,0 +1,31 @@
+/*
+ * the read/write interfaces for Virtual Support Module(VSM)
+ *
+ * Copyright (C) 2009 Lemote, Inc.
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ */
+
+#ifndef	_CS5536_VSM_H
+#define	_CS5536_VSM_H
+
+#include <linux/types.h>
+
+typedef void (*cs5536_pci_vsm_write)(int reg, u32 value);
+typedef u32 (*cs5536_pci_vsm_read)(int reg);
+
+#define DECLARE_CS5536_MODULE(name) \
+extern void pci_##name##_write_reg(int reg, u32 value); \
+extern u32 pci_##name##_read_reg(int reg);
+
+/* ide module */
+DECLARE_CS5536_MODULE(ide)
+/* acc module */
+DECLARE_CS5536_MODULE(acc)
+/* ohci module */
+DECLARE_CS5536_MODULE(ohci)
+/* isa module */
+DECLARE_CS5536_MODULE(isa)
+/* ehci module */
+DECLARE_CS5536_MODULE(ehci)
+
+#endif				/* _CS5536_VSM_H */
diff --git a/arch/mips/loongson/Kconfig b/arch/mips/loongson/Kconfig
index 818a028..b03d773 100644
--- a/arch/mips/loongson/Kconfig
+++ b/arch/mips/loongson/Kconfig
@@ -29,3 +29,6 @@ config LEMOTE_FULOONG2E
 
 	  Lemote Fuloong(2e) mini PC have a VIA686B south bridge.
 endchoice
+
+config CS5536
+	bool
diff --git a/arch/mips/loongson/common/Makefile b/arch/mips/loongson/common/Makefile
index d21d116..d3138b8 100644
--- a/arch/mips/loongson/common/Makefile
+++ b/arch/mips/loongson/common/Makefile
@@ -10,3 +10,9 @@ obj-y += setup.o init.o cmdline.o env.o time.o reset.o irq.o \
 #
 obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
 obj-$(CONFIG_SERIAL_8250) += serial.o
+
+#
+# Enable CS5536 Virtual Support Module(VSM) to virtulize the PCI configure
+# space
+#
+obj-$(CONFIG_CS5536) += cs5536/
diff --git a/arch/mips/loongson/common/cs5536/Makefile b/arch/mips/loongson/common/cs5536/Makefile
new file mode 100644
index 0000000..31657ee
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for CS5536 support.
+#
+
+obj-$(CONFIG_CS5536) += cs5536_pci.o cs5536_ide.o cs5536_acc.o cs5536_ohci.o \
+			cs5536_isa.o cs5536_ehci.o
+
+EXTRA_CFLAGS += -Werror
diff --git a/arch/mips/loongson/common/cs5536/cs5536_acc.c b/arch/mips/loongson/common/cs5536/cs5536_acc.c
new file mode 100644
index 0000000..55b3d7a
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/cs5536_acc.c
@@ -0,0 +1,150 @@
+/*
+ * the ACC Virtual Support Module of AMD CS5536
+ *
+ * Copyright (C) 2007 Lemote, Inc.
+ * Author : jlliu, liujl@lemote.com
+ *
+ * Copyright (C) 2009 Lemote, Inc.
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <cs5536/cs5536.h>
+#include <cs5536/cs5536_pci.h>
+
+/*
+ * acc_write: acc write transfering
+ */
+
+void pci_acc_write_reg(int reg, u32 value)
+{
+	u32 hi = 0, lo = value;
+
+	switch (reg) {
+	case PCI_COMMAND:
+		_rdmsr(GLIU_MSR_REG(GLIU_PAE), &hi, &lo);
+		if (value & PCI_COMMAND_MASTER)
+			lo |= (0x03 << 8);
+		else
+			lo &= ~(0x03 << 8);
+		_wrmsr(GLIU_MSR_REG(GLIU_PAE), hi, lo);
+		break;
+	case PCI_STATUS:
+		if (value & PCI_STATUS_PARITY) {
+			_rdmsr(SB_MSR_REG(SB_ERROR), &hi, &lo);
+			if (lo & SB_PARE_ERR_FLAG) {
+				lo = (lo & 0x0000ffff) | SB_PARE_ERR_FLAG;
+				_wrmsr(SB_MSR_REG(SB_ERROR), hi, lo);
+			}
+		}
+		break;
+	case PCI_BAR0_REG:
+		if (value == PCI_BAR_RANGE_MASK) {
+			_rdmsr(GLCP_MSR_REG(GLCP_SOFT_COM), &hi, &lo);
+			lo |= SOFT_BAR_ACC_FLAG;
+			_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+		} else if (value & 0x01) {
+			value &= 0xfffffffc;
+			hi = 0xA0000000 | ((value & 0x000ff000) >> 12);
+			lo = 0x000fff80 | ((value & 0x00000fff) << 20);
+			_wrmsr(GLIU_MSR_REG(GLIU_IOD_BM1), hi, lo);
+		}
+		break;
+	case PCI_ACC_INT_REG:
+		_rdmsr(DIVIL_MSR_REG(PIC_YSEL_LOW), &hi, &lo);
+		/* disable all the usb interrupt in PIC */
+		lo &= ~(0xf << PIC_YSEL_LOW_ACC_SHIFT);
+		if (value)	/* enable all the acc interrupt in PIC */
+			lo |= (CS5536_ACC_INTR << PIC_YSEL_LOW_ACC_SHIFT);
+		_wrmsr(DIVIL_MSR_REG(PIC_YSEL_LOW), hi, lo);
+		break;
+	default:
+		break;
+	}
+
+	return;
+}
+
+/*
+ * acc_read: acc read transfering
+ */
+
+u32 pci_acc_read_reg(int reg)
+{
+	u32 hi, lo;
+	u32 conf_data = 0;
+
+	switch (reg) {
+	case PCI_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_ACC_DEVICE_ID, CS5536_VENDOR_ID);
+		break;
+	case PCI_COMMAND:
+		_rdmsr(GLIU_MSR_REG(GLIU_IOD_BM1), &hi, &lo);
+		if (((lo & 0xfff00000) || (hi & 0x000000ff))
+		    && ((hi & 0xf0000000) == 0xa0000000))
+			conf_data |= PCI_COMMAND_IO;
+		_rdmsr(GLIU_MSR_REG(GLIU_PAE), &hi, &lo);
+		if ((lo & 0x300) == 0x300)
+			conf_data |= PCI_COMMAND_MASTER;
+		break;
+	case PCI_STATUS:
+		conf_data |= PCI_STATUS_66MHZ;
+		conf_data |= PCI_STATUS_FAST_BACK;
+		_rdmsr(SB_MSR_REG(SB_ERROR), &hi, &lo);
+		if (lo & SB_PARE_ERR_FLAG)
+			conf_data |= PCI_STATUS_PARITY;
+		conf_data |= PCI_STATUS_DEVSEL_MEDIUM;
+		break;
+	case PCI_CLASS_REVISION:
+		_rdmsr(ACC_MSR_REG(ACC_CAP), &hi, &lo);
+		conf_data = lo & 0x000000ff;
+		conf_data |= (CS5536_ACC_CLASS_CODE << 8);
+		break;
+	case PCI_CACHE_LINE_SIZE:
+		conf_data =
+		    CFG_PCI_CACHE_LINE_SIZE(PCI_NORMAL_HEADER_TYPE,
+					    PCI_NORMAL_LATENCY_TIMER);
+		break;
+	case PCI_BAR0_REG:
+		_rdmsr(GLCP_MSR_REG(GLCP_SOFT_COM), &hi, &lo);
+		if (lo & SOFT_BAR_ACC_FLAG) {
+			conf_data = CS5536_ACC_RANGE |
+			    PCI_BASE_ADDRESS_SPACE_IO;
+			lo &= ~SOFT_BAR_ACC_FLAG;
+			_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+		} else {
+			_rdmsr(GLIU_MSR_REG(GLIU_IOD_BM1), &hi, &lo);
+			conf_data = (hi & 0x000000ff) << 12;
+			conf_data |= (lo & 0xfff00000) >> 20;
+			conf_data |= 0x01;
+			conf_data &= ~0x02;
+		}
+		break;
+	case PCI_CARDBUS_CIS:
+		conf_data = PCI_CARDBUS_CIS_POINTER;
+		break;
+	case PCI_SUBSYSTEM_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_ACC_SUB_ID, CS5536_SUB_VENDOR_ID);
+		break;
+	case PCI_ROM_ADDRESS:
+		conf_data = PCI_EXPANSION_ROM_BAR;
+		break;
+	case PCI_CAPABILITY_LIST:
+		conf_data = PCI_CAPLIST_USB_POINTER;
+		break;
+	case PCI_INTERRUPT_LINE:
+		conf_data =
+		    CFG_PCI_INTERRUPT_LINE(PCI_DEFAULT_PIN, CS5536_ACC_INTR);
+		break;
+	default:
+		break;
+	}
+
+	return conf_data;
+}
diff --git a/arch/mips/loongson/common/cs5536/cs5536_ehci.c b/arch/mips/loongson/common/cs5536/cs5536_ehci.c
new file mode 100644
index 0000000..d1d9aa9
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/cs5536_ehci.c
@@ -0,0 +1,160 @@
+/*
+ * the EHCI Virtual Support Module of AMD CS5536
+ *
+ * Copyright (C) 2007 Lemote, Inc.
+ * Author : jlliu, liujl@lemote.com
+ *
+ * Copyright (C) 2009 Lemote, Inc.
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <cs5536/cs5536.h>
+#include <cs5536/cs5536_pci.h>
+
+void pci_ehci_write_reg(int reg, u32 value)
+{
+	u32 hi = 0, lo = value;
+
+	switch (reg) {
+	case PCI_COMMAND:
+		_rdmsr(USB_MSR_REG(USB_EHCI), &hi, &lo);
+		if (value & PCI_COMMAND_MASTER)
+			hi |= PCI_COMMAND_MASTER;
+		else
+			hi &= ~PCI_COMMAND_MASTER;
+
+		if (value & PCI_COMMAND_MEMORY)
+			hi |= PCI_COMMAND_MEMORY;
+		else
+			hi &= ~PCI_COMMAND_MEMORY;
+		_wrmsr(USB_MSR_REG(USB_EHCI), hi, lo);
+		break;
+	case PCI_STATUS:
+		if (value & PCI_STATUS_PARITY) {
+			_rdmsr(SB_MSR_REG(SB_ERROR), &hi, &lo);
+			if (lo & SB_PARE_ERR_FLAG) {
+				lo = (lo & 0x0000ffff) | SB_PARE_ERR_FLAG;
+				_wrmsr(SB_MSR_REG(SB_ERROR), hi, lo);
+			}
+		}
+		break;
+	case PCI_BAR0_REG:
+		if (value == PCI_BAR_RANGE_MASK) {
+			_rdmsr(GLCP_MSR_REG(GLCP_SOFT_COM), &hi, &lo);
+			lo |= SOFT_BAR_EHCI_FLAG;
+			_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+		} else if ((value & 0x01) == 0x00) {
+			_wrmsr(USB_MSR_REG(USB_EHCI), hi, lo);
+
+			value &= 0xfffffff0;
+			hi = 0x40000000 | ((value & 0xff000000) >> 24);
+			lo = 0x000fffff | ((value & 0x00fff000) << 8);
+			_wrmsr(GLIU_MSR_REG(GLIU_P2D_BM4), hi, lo);
+		}
+		break;
+	case PCI_EHCI_LEGSMIEN_REG:
+		_rdmsr(USB_MSR_REG(USB_EHCI), &hi, &lo);
+		hi &= 0x003f0000;
+		hi |= (value & 0x3f) << 16;
+		_wrmsr(USB_MSR_REG(USB_EHCI), hi, lo);
+		break;
+	case PCI_EHCI_FLADJ_REG:
+		_rdmsr(USB_MSR_REG(USB_EHCI), &hi, &lo);
+		hi &= ~0x00003f00;
+		hi |= value & 0x00003f00;
+		_wrmsr(USB_MSR_REG(USB_EHCI), hi, lo);
+		break;
+	default:
+		break;
+	}
+
+	return;
+}
+
+u32 pci_ehci_read_reg(int reg)
+{
+	u32 conf_data = 0;
+	u32 hi, lo;
+
+	switch (reg) {
+	case PCI_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_EHCI_DEVICE_ID, CS5536_VENDOR_ID);
+		break;
+	case PCI_COMMAND:
+		_rdmsr(USB_MSR_REG(USB_EHCI), &hi, &lo);
+		if (hi & PCI_COMMAND_MASTER)
+			conf_data |= PCI_COMMAND_MASTER;
+		if (hi & PCI_COMMAND_MEMORY)
+			conf_data |= PCI_COMMAND_MEMORY;
+		break;
+	case PCI_STATUS:
+		conf_data |= PCI_STATUS_66MHZ;
+		conf_data |= PCI_STATUS_FAST_BACK;
+		_rdmsr(SB_MSR_REG(SB_ERROR), &hi, &lo);
+		if (lo & SB_PARE_ERR_FLAG)
+			conf_data |= PCI_STATUS_PARITY;
+		conf_data |= PCI_STATUS_DEVSEL_MEDIUM;
+		break;
+	case PCI_CLASS_REVISION:
+		_rdmsr(USB_MSR_REG(USB_CAP), &hi, &lo);
+		conf_data = lo & 0x000000ff;
+		conf_data |= (CS5536_EHCI_CLASS_CODE << 8);
+		break;
+	case PCI_CACHE_LINE_SIZE:
+		conf_data =
+		    CFG_PCI_CACHE_LINE_SIZE(PCI_NORMAL_HEADER_TYPE,
+					    PCI_NORMAL_LATENCY_TIMER);
+		break;
+	case PCI_BAR0_REG:
+		_rdmsr(GLCP_MSR_REG(GLCP_SOFT_COM), &hi, &lo);
+		if (lo & SOFT_BAR_EHCI_FLAG) {
+			conf_data = CS5536_EHCI_RANGE |
+			    PCI_BASE_ADDRESS_SPACE_MEMORY;
+			lo &= ~SOFT_BAR_EHCI_FLAG;
+			_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+		} else {
+			_rdmsr(USB_MSR_REG(USB_EHCI), &hi, &lo);
+			conf_data = lo & 0xfffff000;
+		}
+		break;
+	case PCI_CARDBUS_CIS:
+		conf_data = PCI_CARDBUS_CIS_POINTER;
+		break;
+	case PCI_SUBSYSTEM_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_EHCI_SUB_ID, CS5536_SUB_VENDOR_ID);
+		break;
+	case PCI_ROM_ADDRESS:
+		conf_data = PCI_EXPANSION_ROM_BAR;
+		break;
+	case PCI_CAPABILITY_LIST:
+		conf_data = PCI_CAPLIST_USB_POINTER;
+		break;
+	case PCI_INTERRUPT_LINE:
+		conf_data =
+		    CFG_PCI_INTERRUPT_LINE(PCI_DEFAULT_PIN, CS5536_USB_INTR);
+		break;
+	case PCI_EHCI_LEGSMIEN_REG:
+		_rdmsr(USB_MSR_REG(USB_EHCI), &hi, &lo);
+		conf_data = (hi & 0x003f0000) >> 16;
+		break;
+	case PCI_EHCI_LEGSMISTS_REG:
+		_rdmsr(USB_MSR_REG(USB_EHCI), &hi, &lo);
+		conf_data = (hi & 0x3f000000) >> 24;
+		break;
+	case PCI_EHCI_FLADJ_REG:
+		_rdmsr(USB_MSR_REG(USB_EHCI), &hi, &lo);
+		conf_data = hi & 0x00003f00;
+		break;
+	default:
+		break;
+	}
+
+	return conf_data;
+}
diff --git a/arch/mips/loongson/common/cs5536/cs5536_ide.c b/arch/mips/loongson/common/cs5536/cs5536_ide.c
new file mode 100644
index 0000000..afde81c
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/cs5536_ide.c
@@ -0,0 +1,187 @@
+/*
+ * the IDE Virtual Support Module of AMD CS5536
+ *
+ * Copyright (C) 2007 Lemote, Inc.
+ * Author : jlliu, liujl@lemote.com
+ *
+ * Copyright (C) 2009 Lemote, Inc.
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <cs5536/cs5536.h>
+#include <cs5536/cs5536_pci.h>
+
+/*
+ * ide_write : ide write transfering
+ */
+void pci_ide_write_reg(int reg, u32 value)
+{
+	u32 hi = 0, lo = value;
+
+	switch (reg) {
+	case PCI_COMMAND:
+		_rdmsr(GLIU_MSR_REG(GLIU_PAE), &hi, &lo);
+		if (value & PCI_COMMAND_MASTER)
+			lo |= (0x03 << 4);
+		else
+			lo &= ~(0x03 << 4);
+		_wrmsr(GLIU_MSR_REG(GLIU_PAE), hi, lo);
+		break;
+	case PCI_STATUS:
+		if (value & PCI_STATUS_PARITY) {
+			_rdmsr(SB_MSR_REG(SB_ERROR), &hi, &lo);
+			if (lo & SB_PARE_ERR_FLAG) {
+				lo = (lo & 0x0000ffff) | SB_PARE_ERR_FLAG;
+				_wrmsr(SB_MSR_REG(SB_ERROR), hi, lo);
+			}
+		}
+		break;
+	case PCI_CACHE_LINE_SIZE:
+		value &= 0x0000ff00;
+		_rdmsr(SB_MSR_REG(SB_CTRL), &hi, &lo);
+		hi &= 0xffffff00;
+		hi |= (value >> 8);
+		_wrmsr(SB_MSR_REG(SB_CTRL), hi, lo);
+		break;
+	case PCI_BAR4_REG:
+		if (value == PCI_BAR_RANGE_MASK) {
+			_rdmsr(GLCP_MSR_REG(GLCP_SOFT_COM), &hi, &lo);
+			lo |= SOFT_BAR_IDE_FLAG;
+			_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+		} else if (value & 0x01) {
+			lo = (value & 0xfffffff0) | 0x1;
+			_wrmsr(IDE_MSR_REG(IDE_IO_BAR), hi, lo);
+
+			value &= 0xfffffffc;
+			hi = 0x60000000 | ((value & 0x000ff000) >> 12);
+			lo = 0x000ffff0 | ((value & 0x00000fff) << 20);
+			_wrmsr(GLIU_MSR_REG(GLIU_IOD_BM2), hi, lo);
+		}
+		break;
+	case PCI_IDE_CFG_REG:
+		if (value == CS5536_IDE_FLASH_SIGNATURE) {
+			_rdmsr(DIVIL_MSR_REG(DIVIL_BALL_OPTS), &hi, &lo);
+			lo |= 0x01;
+			_wrmsr(DIVIL_MSR_REG(DIVIL_BALL_OPTS), hi, lo);
+		} else
+			_wrmsr(IDE_MSR_REG(IDE_CFG), hi, lo);
+		break;
+	case PCI_IDE_DTC_REG:
+		_wrmsr(IDE_MSR_REG(IDE_DTC), hi, lo);
+		break;
+	case PCI_IDE_CAST_REG:
+		_wrmsr(IDE_MSR_REG(IDE_CAST), hi, lo);
+		break;
+	case PCI_IDE_ETC_REG:
+		_wrmsr(IDE_MSR_REG(IDE_ETC), hi, lo);
+		break;
+	case PCI_IDE_PM_REG:
+		_wrmsr(IDE_MSR_REG(IDE_INTERNAL_PM), hi, lo);
+		break;
+	default:
+		break;
+	}
+
+	return;
+}
+
+/*
+ * ide_read : ide read tranfering.
+ */
+u32 pci_ide_read_reg(int reg)
+{
+	u32 conf_data = 0;
+	u32 hi, lo;
+
+	switch (reg) {
+	case PCI_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_IDE_DEVICE_ID, CS5536_VENDOR_ID);
+		break;
+	case PCI_COMMAND:
+		_rdmsr(IDE_MSR_REG(IDE_IO_BAR), &hi, &lo);
+		if (lo & 0xfffffff0)
+			conf_data |= PCI_COMMAND_IO;
+		_rdmsr(GLIU_MSR_REG(GLIU_PAE), &hi, &lo);
+		if ((lo & 0x30) == 0x30)
+			conf_data |= PCI_COMMAND_MASTER;
+		break;
+	case PCI_STATUS:
+		conf_data |= PCI_STATUS_66MHZ;
+		conf_data |= PCI_STATUS_FAST_BACK;
+		_rdmsr(SB_MSR_REG(SB_ERROR), &hi, &lo);
+		if (lo & SB_PARE_ERR_FLAG)
+			conf_data |= PCI_STATUS_PARITY;
+		conf_data |= PCI_STATUS_DEVSEL_MEDIUM;
+		break;
+	case PCI_CLASS_REVISION:
+		_rdmsr(IDE_MSR_REG(IDE_CAP), &hi, &lo);
+		conf_data = lo & 0x000000ff;
+		conf_data |= (CS5536_IDE_CLASS_CODE << 8);
+		break;
+	case PCI_CACHE_LINE_SIZE:
+		_rdmsr(SB_MSR_REG(SB_CTRL), &hi, &lo);
+		hi &= 0x000000f8;
+		conf_data = CFG_PCI_CACHE_LINE_SIZE(PCI_NORMAL_HEADER_TYPE, hi);
+		break;
+	case PCI_BAR4_REG:
+		_rdmsr(GLCP_MSR_REG(GLCP_SOFT_COM), &hi, &lo);
+		if (lo & SOFT_BAR_IDE_FLAG) {
+			conf_data = CS5536_IDE_RANGE |
+			    PCI_BASE_ADDRESS_SPACE_IO;
+			lo &= ~SOFT_BAR_IDE_FLAG;
+			_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+		} else {
+			_rdmsr(IDE_MSR_REG(IDE_IO_BAR), &hi, &lo);
+			conf_data = lo & 0xfffffff0;
+			conf_data |= 0x01;
+			conf_data &= ~0x02;
+		}
+		break;
+	case PCI_CARDBUS_CIS:
+		conf_data = PCI_CARDBUS_CIS_POINTER;
+		break;
+	case PCI_SUBSYSTEM_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_IDE_SUB_ID, CS5536_SUB_VENDOR_ID);
+		break;
+	case PCI_ROM_ADDRESS:
+		conf_data = PCI_EXPANSION_ROM_BAR;
+		break;
+	case PCI_CAPABILITY_LIST:
+		conf_data = PCI_CAPLIST_POINTER;
+		break;
+	case PCI_INTERRUPT_LINE:
+		conf_data =
+		    CFG_PCI_INTERRUPT_LINE(PCI_DEFAULT_PIN, CS5536_IDE_INTR);
+		break;
+	case PCI_IDE_CFG_REG:
+		_rdmsr(IDE_MSR_REG(IDE_CFG), &hi, &lo);
+		conf_data = lo;
+		break;
+	case PCI_IDE_DTC_REG:
+		_rdmsr(IDE_MSR_REG(IDE_DTC), &hi, &lo);
+		conf_data = lo;
+		break;
+	case PCI_IDE_CAST_REG:
+		_rdmsr(IDE_MSR_REG(IDE_CAST), &hi, &lo);
+		conf_data = lo;
+		break;
+	case PCI_IDE_ETC_REG:
+		_rdmsr(IDE_MSR_REG(IDE_ETC), &hi, &lo);
+		conf_data = lo;
+	case PCI_IDE_PM_REG:
+		_rdmsr(IDE_MSR_REG(IDE_INTERNAL_PM), &hi, &lo);
+		conf_data = lo;
+		break;
+	default:
+		break;
+	}
+
+	return conf_data;
+}
diff --git a/arch/mips/loongson/common/cs5536/cs5536_isa.c b/arch/mips/loongson/common/cs5536/cs5536_isa.c
new file mode 100644
index 0000000..c7e5f9e
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/cs5536_isa.c
@@ -0,0 +1,322 @@
+/*
+ * the ISA Virtual Support Module of AMD CS5536
+ *
+ * Copyright (C) 2007 Lemote, Inc.
+ * Author : jlliu, liujl@lemote.com
+ *
+ * Copyright (C) 2009 Lemote, Inc.
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <cs5536/cs5536.h>
+#include <cs5536/cs5536_pci.h>
+
+/* common variables for PCI_ISA_READ/WRITE_BAR */
+static const u32 divil_msr_reg[6] = {
+	DIVIL_MSR_REG(DIVIL_LBAR_SMB), DIVIL_MSR_REG(DIVIL_LBAR_GPIO),
+	DIVIL_MSR_REG(DIVIL_LBAR_MFGPT), DIVIL_MSR_REG(DIVIL_LBAR_IRQ),
+	DIVIL_MSR_REG(DIVIL_LBAR_PMS), DIVIL_MSR_REG(DIVIL_LBAR_ACPI),
+};
+
+static const u32 soft_bar_flag[6] = {
+	SOFT_BAR_SMB_FLAG, SOFT_BAR_GPIO_FLAG, SOFT_BAR_MFGPT_FLAG,
+	SOFT_BAR_IRQ_FLAG, SOFT_BAR_PMS_FLAG, SOFT_BAR_ACPI_FLAG,
+};
+
+static const u32 sb_msr_reg[6] = {
+	SB_MSR_REG(SB_R0), SB_MSR_REG(SB_R1), SB_MSR_REG(SB_R2),
+	SB_MSR_REG(SB_R3), SB_MSR_REG(SB_R4), SB_MSR_REG(SB_R5),
+};
+
+static const u32 bar_space_range[6] = {
+	CS5536_SMB_RANGE, CS5536_GPIO_RANGE, CS5536_MFGPT_RANGE,
+	CS5536_IRQ_RANGE, CS5536_PMS_RANGE, CS5536_ACPI_RANGE,
+};
+
+static const int bar_space_len[6] = {
+	CS5536_SMB_LENGTH, CS5536_GPIO_LENGTH, CS5536_MFGPT_LENGTH,
+	CS5536_IRQ_LENGTH, CS5536_PMS_LENGTH, CS5536_ACPI_LENGTH,
+};
+
+/*
+ * enable the divil module bar space.
+ *
+ * For all the DIVIL module LBAR, you should control the DIVIL LBAR reg
+ * and the RCONFx(0~5) reg to use the modules.
+ */
+static void divil_lbar_enable(void)
+{
+	u32 hi, lo;
+	int offset;
+
+	/*
+	 * The DIVIL IRQ is not used yet. and make the RCONF0 reserved.
+	 */
+
+	for (offset = DIVIL_LBAR_SMB; offset <= DIVIL_LBAR_PMS; offset++) {
+		_rdmsr(DIVIL_MSR_REG(offset), &hi, &lo);
+		hi |= 0x01;
+		_wrmsr(DIVIL_MSR_REG(DIVIL_LBAR_SMB), hi, lo);
+	}
+	return;
+}
+
+/*
+ * disable the divil module bar space.
+ */
+static void divil_lbar_disable(void)
+{
+	u32 hi, lo;
+	int offset;
+
+	for (offset = DIVIL_LBAR_SMB; offset <= DIVIL_LBAR_PMS; offset++) {
+		_rdmsr(DIVIL_MSR_REG(offset), &hi, &lo);
+		hi &= ~0x01;
+		_wrmsr(DIVIL_MSR_REG(DIVIL_LBAR_SMB), hi, lo);
+	}
+	return;
+}
+
+/*
+ * BAR write: write value to the n BAR
+ */
+
+void pci_isa_write_bar(int n, u32 value)
+{
+	u32 hi = 0, lo = value;
+
+	if (value == PCI_BAR_RANGE_MASK) {
+		_rdmsr(GLCP_MSR_REG(GLCP_SOFT_COM), &hi, &lo);
+		lo |= soft_bar_flag[n];
+		_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+	} else if (value & 0x01) {
+		/* NATIVE reg */
+		hi = 0x0000f001;
+		lo &= bar_space_range[n];
+		_wrmsr(divil_msr_reg[n], hi, lo);
+
+		/* RCONFx is 4bytes in units for I/O space */
+		hi = ((value & 0x000ffffc) << 12) |
+		    ((bar_space_len[n] - 4) << 12) | 0x01;
+		lo = ((value & 0x000ffffc) << 12) | 0x01;
+		_wrmsr(sb_msr_reg[n], hi, lo);
+	}
+
+	return;
+}
+
+/*
+ * BAR read: read the n BAR
+ */
+
+u32 pci_isa_read_bar(int n)
+{
+	u32 conf_data = 0;
+	u32 hi, lo;
+
+	_rdmsr(GLCP_MSR_REG(GLCP_SOFT_COM), &hi, &lo);
+	if (lo & soft_bar_flag[n]) {
+		conf_data = bar_space_range[n] | PCI_BASE_ADDRESS_SPACE_IO;
+		lo &= ~soft_bar_flag[n];
+		_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+	} else {
+		_rdmsr(divil_msr_reg[n], &hi, &lo);
+		conf_data = lo & bar_space_range[n];
+		conf_data |= 0x01;
+		conf_data &= ~0x02;
+	}
+	return conf_data;
+}
+
+/*
+ * isa_write : isa write transfering.
+ * we assume that the ISA is not the BUS MASTER!
+ */
+
+void pci_isa_write_reg(int reg, u32 value)
+{
+	u32 hi = 0, lo = value;
+	u32 temp;
+
+	switch (reg) {
+	case PCI_COMMAND:
+		if (value & PCI_COMMAND_IO)
+			divil_lbar_enable();
+		else
+			divil_lbar_disable();
+		break;
+	case PCI_STATUS:
+		_rdmsr(SB_MSR_REG(SB_ERROR), &hi, &lo);
+		temp = lo & 0x0000ffff;
+		if ((value & PCI_STATUS_SIG_TARGET_ABORT) &&
+		    (lo & SB_TAS_ERR_EN))
+			temp |= SB_TAS_ERR_FLAG;
+
+		if ((value & PCI_STATUS_REC_TARGET_ABORT) &&
+		    (lo & SB_TAR_ERR_EN))
+			temp |= SB_TAR_ERR_FLAG;
+
+		if ((value & PCI_STATUS_REC_MASTER_ABORT)
+		    && (lo & SB_MAR_ERR_EN))
+			temp |= SB_MAR_ERR_FLAG;
+
+		if ((value & PCI_STATUS_DETECTED_PARITY)
+		    && (lo & SB_PARE_ERR_EN))
+			temp |= SB_PARE_ERR_FLAG;
+
+		lo = temp;
+		_wrmsr(SB_MSR_REG(SB_ERROR), hi, lo);
+		break;
+	case PCI_CACHE_LINE_SIZE:
+		value &= 0x0000ff00;
+		_rdmsr(SB_MSR_REG(SB_CTRL), &hi, &lo);
+		hi &= 0xffffff00;
+		hi |= (value >> 8);
+		_wrmsr(SB_MSR_REG(SB_CTRL), hi, lo);
+		break;
+	case PCI_BAR0_REG:
+		pci_isa_write_bar(0, value);
+		break;
+	case PCI_BAR1_REG:
+		pci_isa_write_bar(1, value);
+		break;
+	case PCI_BAR2_REG:
+		pci_isa_write_bar(2, value);
+		break;
+	case PCI_BAR3_REG:
+		pci_isa_write_bar(3, value);
+		break;
+	case PCI_BAR4_REG:
+		pci_isa_write_bar(4, value);
+		break;
+	case PCI_BAR5_REG:
+		pci_isa_write_bar(5, value);
+		break;
+	case PCI_UART1_INT_REG:
+		_rdmsr(DIVIL_MSR_REG(PIC_YSEL_HIGH), &hi, &lo);
+		/* disable uart1 interrupt in PIC */
+		lo &= ~(0xf << 24);
+		if (value)	/* enable uart1 interrupt in PIC */
+			lo |= (CS5536_UART1_INTR << 24);
+		_wrmsr(DIVIL_MSR_REG(PIC_YSEL_HIGH), hi, lo);
+		break;
+	case PCI_UART2_INT_REG:
+		_rdmsr(DIVIL_MSR_REG(PIC_YSEL_HIGH), &hi, &lo);
+		/* disable uart2 interrupt in PIC */
+		lo &= ~(0xf << 28);
+		if (value)	/* enable uart2 interrupt in PIC */
+			lo |= (CS5536_UART2_INTR << 28);
+		_wrmsr(DIVIL_MSR_REG(PIC_YSEL_HIGH), hi, lo);
+		break;
+	case PCI_ISA_FIXUP_REG:
+		if (value) {
+			/* enable the TARGET ABORT/MASTER ABORT etc. */
+			_rdmsr(SB_MSR_REG(SB_ERROR), &hi, &lo);
+			lo |= 0x00000063;
+			_wrmsr(SB_MSR_REG(SB_ERROR), hi, lo);
+		}
+
+	default:
+		/* ALL OTHER PCI CONFIG SPACE HEADER IS NOT IMPLEMENTED. */
+		break;
+	}
+
+	return;
+}
+
+/*
+ * isa_read : isa read transfering.
+ * we assume that the ISA is not the BUS MASTER.
+ */
+
+u32 pci_isa_read_reg(int reg)
+{
+	u32 conf_data = 0;
+	u32 hi, lo;
+
+	switch (reg) {
+	case PCI_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_ISA_DEVICE_ID, CS5536_VENDOR_ID);
+		break;
+	case PCI_COMMAND:
+		/* we just check the first LBAR for the IO enable bit, */
+		/* maybe we should changed later. */
+		_rdmsr(DIVIL_MSR_REG(DIVIL_LBAR_SMB), &hi, &lo);
+		if (hi & 0x01)
+			conf_data |= PCI_COMMAND_IO;
+		break;
+	case PCI_STATUS:
+		conf_data |= PCI_STATUS_66MHZ;
+		conf_data |= PCI_STATUS_DEVSEL_MEDIUM;
+		conf_data |= PCI_STATUS_FAST_BACK;
+
+		_rdmsr(SB_MSR_REG(SB_ERROR), &hi, &lo);
+		if (lo & SB_TAS_ERR_FLAG)
+			conf_data |= PCI_STATUS_SIG_TARGET_ABORT;
+		if (lo & SB_TAR_ERR_FLAG)
+			conf_data |= PCI_STATUS_REC_TARGET_ABORT;
+		if (lo & SB_MAR_ERR_FLAG)
+			conf_data |= PCI_STATUS_REC_MASTER_ABORT;
+		if (lo & SB_PARE_ERR_FLAG)
+			conf_data |= PCI_STATUS_DETECTED_PARITY;
+		break;
+	case PCI_CLASS_REVISION:
+		_rdmsr(GLCP_MSR_REG(GLCP_CHIP_REV_ID), &hi, &lo);
+		conf_data = lo & 0x000000ff;
+		conf_data |= (CS5536_ISA_CLASS_CODE << 8);
+		break;
+	case PCI_CACHE_LINE_SIZE:
+		_rdmsr(SB_MSR_REG(SB_CTRL), &hi, &lo);
+		hi &= 0x000000f8;
+		conf_data = CFG_PCI_CACHE_LINE_SIZE(PCI_BRIDGE_HEADER_TYPE, hi);
+		break;
+		/*
+		 * we only use the LBAR of DIVIL, no RCONF used.
+		 * all of them are IO space.
+		 */
+	case PCI_BAR0_REG:
+		return pci_isa_read_bar(0);
+		break;
+	case PCI_BAR1_REG:
+		return pci_isa_read_bar(1);
+		break;
+	case PCI_BAR2_REG:
+		return pci_isa_read_bar(2);
+		break;
+	case PCI_BAR3_REG:
+		break;
+	case PCI_BAR4_REG:
+		return pci_isa_read_bar(4);
+		break;
+	case PCI_BAR5_REG:
+		return pci_isa_read_bar(5);
+		break;
+	case PCI_CARDBUS_CIS:
+		conf_data = PCI_CARDBUS_CIS_POINTER;
+		break;
+	case PCI_SUBSYSTEM_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_ISA_SUB_ID, CS5536_SUB_VENDOR_ID);
+		break;
+	case PCI_ROM_ADDRESS:
+		conf_data = PCI_EXPANSION_ROM_BAR;
+		break;
+	case PCI_CAPABILITY_LIST:
+		conf_data = PCI_CAPLIST_POINTER;
+		break;
+	case PCI_INTERRUPT_LINE:
+		/* no interrupt used here */
+		conf_data = CFG_PCI_INTERRUPT_LINE(0x00, 0x00);
+		break;
+	default:
+		break;
+	}
+
+	return conf_data;
+}
diff --git a/arch/mips/loongson/common/cs5536/cs5536_ohci.c b/arch/mips/loongson/common/cs5536/cs5536_ohci.c
new file mode 100644
index 0000000..6d824fc
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/cs5536_ohci.c
@@ -0,0 +1,155 @@
+/*
+ * the OHCI Virtual Support Module of AMD CS5536
+ *
+ * Copyright (C) 2007 Lemote, Inc.
+ * Author : jlliu, liujl@lemote.com
+ *
+ * Copyright (C) 2009 Lemote, Inc.
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <cs5536/cs5536.h>
+#include <cs5536/cs5536_pci.h>
+
+/*
+ * ohci_write : ohci write transfering.
+ */
+void pci_ohci_write_reg(int reg, u32 value)
+{
+	u32 hi = 0, lo = value;
+
+	switch (reg) {
+	case PCI_COMMAND:
+		_rdmsr(USB_MSR_REG(USB_OHCI), &hi, &lo);
+		if (value & PCI_COMMAND_MASTER)
+			hi |= PCI_COMMAND_MASTER;
+		else
+			hi &= ~PCI_COMMAND_MASTER;
+
+		if (value & PCI_COMMAND_MEMORY)
+			hi |= PCI_COMMAND_MEMORY;
+		else
+			hi &= ~PCI_COMMAND_MEMORY;
+		_wrmsr(USB_MSR_REG(USB_OHCI), hi, lo);
+		break;
+	case PCI_STATUS:
+		if (value & PCI_STATUS_PARITY) {
+			_rdmsr(SB_MSR_REG(SB_ERROR), &hi, &lo);
+			if (lo & SB_PARE_ERR_FLAG) {
+				lo = (lo & 0x0000ffff) | SB_PARE_ERR_FLAG;
+				_wrmsr(SB_MSR_REG(SB_ERROR), hi, lo);
+			}
+		}
+		break;
+	case PCI_BAR0_REG:
+		if (value == PCI_BAR_RANGE_MASK) {
+			_rdmsr(GLCP_MSR_REG(GLCP_SOFT_COM), &hi, &lo);
+			lo |= SOFT_BAR_OHCI_FLAG;
+			_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+		} else if ((value & 0x01) == 0x00) {
+			_wrmsr(USB_MSR_REG(USB_OHCI), hi, lo);
+
+			value &= 0xfffffff0;
+			hi = 0x40000000 | ((value & 0xff000000) >> 24);
+			lo = 0x000fffff | ((value & 0x00fff000) << 8);
+			_wrmsr(GLIU_MSR_REG(GLIU_P2D_BM3), hi, lo);
+		}
+		break;
+	case PCI_OHCI_INT_REG:
+		_rdmsr(DIVIL_MSR_REG(PIC_YSEL_LOW), &hi, &lo);
+		lo &= ~(0xf << PIC_YSEL_LOW_USB_SHIFT);
+		if (value)	/* enable all the usb interrupt in PIC */
+			lo |= (CS5536_USB_INTR << PIC_YSEL_LOW_USB_SHIFT);
+		_wrmsr(DIVIL_MSR_REG(PIC_YSEL_LOW), hi, lo);
+		break;
+	default:
+		break;
+	}
+
+	return;
+}
+
+/*
+ * ohci_read : ohci read transfering.
+ */
+u32 pci_ohci_read_reg(int reg)
+{
+	u32 conf_data = 0;
+	u32 hi, lo;
+
+	switch (reg) {
+	case PCI_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_OHCI_DEVICE_ID, CS5536_VENDOR_ID);
+		break;
+	case PCI_COMMAND:
+		_rdmsr(USB_MSR_REG(USB_OHCI), &hi, &lo);
+		if (hi & PCI_COMMAND_MASTER)
+			conf_data |= PCI_COMMAND_MASTER;
+		if (hi & PCI_COMMAND_MEMORY)
+			conf_data |= PCI_COMMAND_MEMORY;
+		break;
+	case PCI_STATUS:
+		conf_data |= PCI_STATUS_66MHZ;
+		conf_data |= PCI_STATUS_FAST_BACK;
+		_rdmsr(SB_MSR_REG(SB_ERROR), &hi, &lo);
+		if (lo & SB_PARE_ERR_FLAG)
+			conf_data |= PCI_STATUS_PARITY;
+		conf_data |= PCI_STATUS_DEVSEL_MEDIUM;
+		break;
+	case PCI_CLASS_REVISION:
+		_rdmsr(USB_MSR_REG(USB_CAP), &hi, &lo);
+		conf_data = lo & 0x000000ff;
+		conf_data |= (CS5536_OHCI_CLASS_CODE << 8);
+		break;
+	case PCI_CACHE_LINE_SIZE:
+		conf_data =
+		    CFG_PCI_CACHE_LINE_SIZE(PCI_NORMAL_HEADER_TYPE,
+					    PCI_NORMAL_LATENCY_TIMER);
+		break;
+	case PCI_BAR0_REG:
+		_rdmsr(GLCP_MSR_REG(GLCP_SOFT_COM), &hi, &lo);
+		if (lo & SOFT_BAR_OHCI_FLAG) {
+			conf_data = CS5536_OHCI_RANGE |
+			    PCI_BASE_ADDRESS_SPACE_MEMORY;
+			lo &= ~SOFT_BAR_OHCI_FLAG;
+			_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+		} else {
+			_rdmsr(USB_MSR_REG(USB_OHCI), &hi, &lo);
+			conf_data = lo & 0xffffff00;
+			conf_data &= ~0x0000000f;	/* 32bit mem */
+		}
+		break;
+	case PCI_CARDBUS_CIS:
+		conf_data = PCI_CARDBUS_CIS_POINTER;
+		break;
+	case PCI_SUBSYSTEM_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_OHCI_SUB_ID, CS5536_SUB_VENDOR_ID);
+		break;
+	case PCI_ROM_ADDRESS:
+		conf_data = PCI_EXPANSION_ROM_BAR;
+		break;
+	case PCI_CAPABILITY_LIST:
+		conf_data = PCI_CAPLIST_USB_POINTER;
+		break;
+	case PCI_INTERRUPT_LINE:
+		conf_data =
+		    CFG_PCI_INTERRUPT_LINE(PCI_DEFAULT_PIN, CS5536_USB_INTR);
+		break;
+	case PCI_OHCI_INT_REG:
+		_rdmsr(DIVIL_MSR_REG(PIC_YSEL_LOW), &hi, &lo);
+		if ((lo & 0x00000f00) == CS5536_USB_INTR)
+			conf_data = 1;
+		break;
+	default:
+		break;
+	}
+
+	return conf_data;
+}
diff --git a/arch/mips/loongson/common/cs5536/cs5536_pci.c b/arch/mips/loongson/common/cs5536/cs5536_pci.c
new file mode 100644
index 0000000..a7a3d25
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/cs5536_pci.c
@@ -0,0 +1,89 @@
+/*
+ * read/write operation to the PCI config space of CS5536
+ *
+ * Copyright (C) 2007 Lemote, Inc.
+ * Author : jlliu, liujl@lemote.com
+ *
+ * Copyright (C) 2009 Lemote, Inc.
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ *	the Virtual Support Module(VSM) for virtulizing the PCI
+ *	configure space are defined in cs5536_modulename.c respectively,
+ *
+ *	after this virtulizing, user can access the PCI configure space
+ *	directly as a normal multi-function PCI device which follows
+ *	the PCI-2.2 spec.
+ */
+
+#include <linux/types.h>
+#include <cs5536/cs5536_vsm.h>
+
+enum {
+	CS5536_FUNC_START = -1,
+	CS5536_ISA_FUNC,
+	reserved_func,
+	CS5536_IDE_FUNC,
+	CS5536_ACC_FUNC,
+	CS5536_OHCI_FUNC,
+	CS5536_EHCI_FUNC,
+	CS5536_FUNC_END,
+};
+
+static const cs5536_pci_vsm_write vsm_conf_write[] = {
+	[CS5536_ISA_FUNC]	pci_isa_write_reg,
+	[reserved_func]		NULL,
+	[CS5536_IDE_FUNC]	pci_ide_write_reg,
+	[CS5536_ACC_FUNC]	pci_acc_write_reg,
+	[CS5536_OHCI_FUNC]	pci_ohci_write_reg,
+	[CS5536_EHCI_FUNC]	pci_ehci_write_reg,
+};
+
+static const cs5536_pci_vsm_read vsm_conf_read[] = {
+	[CS5536_ISA_FUNC]	pci_isa_read_reg,
+	[reserved_func]		NULL,
+	[CS5536_IDE_FUNC]	pci_ide_read_reg,
+	[CS5536_ACC_FUNC]	pci_acc_read_reg,
+	[CS5536_OHCI_FUNC]	pci_ohci_read_reg,
+	[CS5536_EHCI_FUNC]	pci_ehci_read_reg,
+};
+
+/*
+ * write to PCI config space and transfer it to MSR write.
+ */
+void cs5536_pci_conf_write4(int function, int reg, u32 value)
+{
+	if ((function <= CS5536_FUNC_START) || (function >= CS5536_FUNC_END))
+		return;
+	if ((reg < 0) || (reg > 0x100) || ((reg & 0x03) != 0))
+		return;
+
+	if (vsm_conf_write[function] != NULL)
+		vsm_conf_write[function](reg, value);
+
+	return;
+}
+
+/*
+ * read PCI config space and transfer it to MSR access.
+ */
+u32 cs5536_pci_conf_read4(int function, int reg)
+{
+	u32 data = 0;
+
+	if ((function <= CS5536_FUNC_START) || (function >= CS5536_FUNC_END))
+		return 0;
+	if ((reg < 0) || ((reg & 0x03) != 0))
+		return 0;
+	if (reg > 0x100)
+		return 0xffffffff;
+
+	if (vsm_conf_read[function] != NULL)
+		data = vsm_conf_read[function](reg);
+
+	return data;
+}
-- 
1.6.2.1

