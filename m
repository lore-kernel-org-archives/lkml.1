Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZETWGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZETWGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbZETWGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:06:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:33888 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbZETWGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:06:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ObGzRi3mADttVCSCp6qJFSdpcqS/x06RpmlC5nBuiLOEHEQSMG3WzOkp4EyETIXTrq
         B1hBKbOjPtU12Jpzf27enYJZQiJ+dSoxxqvcWZdGq7AyAfmBwoRk6kJeKl3EaBBelgHB
         CyCM36xHr+TijViCdUJF7JoxdipIU27eaMIqU=
From: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Wu Zhangjin <wuzhangjin@gmail.com>,
       Yan hua <yanh@lemote.com>, Philippe Vachon <philippe@cowpig.ca>,
       Zhang Le <r0bertz@gentoo.org>, Zhang Fuxin <zhangfx@lemote.com>,
       Arnaud Patard <apatard@mandriva.com>, loongson-dev@googlegroups.com,
       gnewsense-dev@nongnu.org, Nicholas Mc Guire <hofrat@hofr.at>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>
Subject: [loongson-PATCH-v1 13/27] add basic fuloong(2f) support
Date: Thu, 21 May 2009 06:06:20 +0800
Message-Id: <1cb69445cfff01ccc805487692bf63d98fd045fa.1242855716.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1242855716.git.wuzhangjin@gmail.com>
References: <cover.1242855716.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

fuloong(2e) has an VIA686B south bridge, but fuloong(2f) has an AMD
CS5536 south bridge. so, we need to add basic cs5536 south bridge
support here.

there are several modules provided by cs5536, currently, only these
modules are used in fuloong(2f) mini PC: ide, acc(audio), ohci, isa, and
ehci. and these modules are general modules, which means should be
compiled in kernel by default, besides, there are several selective
modules: flash(nor and nand), otg, udc. the otg and udc modules are used
in the NAS machine made by Lemote(the source code support will be added
later, only a few differ from fuloong2f mini PC).

since the PCI operations are similiar between fuloong(2e) and
fuloong(2f),yeeloong(2f) and even similiar to gdium, herein, I just
rename ops-fuloong2e.c to ops-loongsgon2.c to share most of the source
code.

PS: the originl cs5536 support for fuloong2f is from the to-mips branch
of git://dev.lemote.com/linux_loongson.git, tons of source code have
been cleaned up. the most important change is using the linux-internal
pci_regs.h(include/linux/pci_regs.h) instead of the original pcireg.h
and dividing the huge cs5536_vsm.c to several small files, one file one
cs5536 module. at the same time, tons of souce code are tuned to be
understandable and some trashy souce code are removed away which will
archieve a higher performance. and also, the header files, cs5536.h and
cs5536_pci.h are cleaned up a lot.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Makefile                                 |    1 +
 .../mips/include/asm/mach-loongson/cs5536/cs5536.h |  382 +++++++++++++++++
 .../include/asm/mach-loongson/cs5536/cs5536_pci.h  |  174 ++++++++
 .../include/asm/mach-loongson/cs5536/cs5536_vsm.h  |   59 +++
 arch/mips/include/asm/mach-loongson/loongson.h     |    2 +-
 arch/mips/include/asm/mach-loongson/machine.h      |   30 ++
 arch/mips/loongson/Kconfig                         |   44 ++
 arch/mips/loongson/Makefile                        |    6 +
 arch/mips/loongson/common/Makefile                 |    6 +
 arch/mips/loongson/common/bonito-irq.c             |    5 +
 arch/mips/loongson/common/cs5536/Makefile          |   20 +
 arch/mips/loongson/common/cs5536/cs5536_acc.c      |  155 +++++++
 arch/mips/loongson/common/cs5536/cs5536_ehci.c     |  165 +++++++
 arch/mips/loongson/common/cs5536/cs5536_flash.c    |  450 ++++++++++++++++++++
 arch/mips/loongson/common/cs5536/cs5536_ide.c      |  193 +++++++++
 arch/mips/loongson/common/cs5536/cs5536_isa.c      |  376 ++++++++++++++++
 arch/mips/loongson/common/cs5536/cs5536_ohci.c     |  167 ++++++++
 arch/mips/loongson/common/cs5536/cs5536_otg.c      |  137 ++++++
 arch/mips/loongson/common/cs5536/cs5536_pci.c      |  126 ++++++
 arch/mips/loongson/common/cs5536/cs5536_udc.c      |  142 ++++++
 arch/mips/loongson/fuloong-2f/Makefile             |    5 +
 arch/mips/loongson/fuloong-2f/irq.c                |   53 +++
 arch/mips/loongson/fuloong-2f/reset.c              |   65 +++
 arch/mips/pci/Makefile                             |    3 +-
 arch/mips/pci/fixup-fuloong2f.c                    |  171 ++++++++
 arch/mips/pci/ops-fuloong2e.c                      |  160 -------
 arch/mips/pci/ops-loongson2.c                      |  213 +++++++++
 27 files changed, 3148 insertions(+), 162 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-loongson/cs5536/cs5536.h
 create mode 100644 arch/mips/include/asm/mach-loongson/cs5536/cs5536_pci.h
 create mode 100644 arch/mips/include/asm/mach-loongson/cs5536/cs5536_vsm.h
 create mode 100644 arch/mips/loongson/common/cs5536/Makefile
 create mode 100644 arch/mips/loongson/common/cs5536/cs5536_acc.c
 create mode 100644 arch/mips/loongson/common/cs5536/cs5536_ehci.c
 create mode 100644 arch/mips/loongson/common/cs5536/cs5536_flash.c
 create mode 100644 arch/mips/loongson/common/cs5536/cs5536_ide.c
 create mode 100644 arch/mips/loongson/common/cs5536/cs5536_isa.c
 create mode 100644 arch/mips/loongson/common/cs5536/cs5536_ohci.c
 create mode 100644 arch/mips/loongson/common/cs5536/cs5536_otg.c
 create mode 100644 arch/mips/loongson/common/cs5536/cs5536_pci.c
 create mode 100644 arch/mips/loongson/common/cs5536/cs5536_udc.c
 create mode 100644 arch/mips/loongson/fuloong-2f/Makefile
 create mode 100644 arch/mips/loongson/fuloong-2f/irq.c
 create mode 100644 arch/mips/loongson/fuloong-2f/reset.c
 create mode 100644 arch/mips/pci/fixup-fuloong2f.c
 delete mode 100644 arch/mips/pci/ops-fuloong2e.c
 create mode 100644 arch/mips/pci/ops-loongson2.c

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 6cbfc22..abf16c1 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -310,6 +310,7 @@ core-$(CONFIG_LOONGSON_SYSTEMS) +=arch/mips/loongson/
 cflags-$(CONFIG_LOONGSON_SYSTEMS) += -I$(srctree)/arch/mips/include/asm/mach-loongson \
 					-mno-branch-likely
 load-$(CONFIG_LEMOTE_FULOONG2E) +=0xffffffff80100000
+load-$(CONFIG_LEMOTE_FULOONG2F) +=0xffffffff80200000
 
 #
 # MIPS Malta board
diff --git a/arch/mips/include/asm/mach-loongson/cs5536/cs5536.h b/arch/mips/include/asm/mach-loongson/cs5536/cs5536.h
new file mode 100644
index 0000000..a9bbe1d
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson/cs5536/cs5536.h
@@ -0,0 +1,382 @@
+/*
+ * The header file of cs5536 sourth bridge.
+ *
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
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
+/* MEM space for 4KB nand flash; IO space for 16B nor flash. */
+#ifdef	CS5536_NOR_FLASH
+#define	CS5536_FLSH_LENGTH	0x10
+#define	CS5536_FLSH_RANGE	0xfffffff0
+#else
+#define	CS5536_FLSH_RANGE	0xfffff000
+#define	CS5536_FLSH_LENGTH	0x1000
+#endif
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
+#define	CS5536_UDC_RANGE	0xffffe000
+#define	CS5536_UDC_LENGTH	0x2000
+#define	CS5536_OTG_RANGE	0xfffff000
+#define	CS5536_OTG_LENGTH	0x1000
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
+#define	SOFT_BAR_FLSH0_FLAG	0x00000040
+#define	SOFT_BAR_FLSH1_FLAG	0x00000080
+#define	SOFT_BAR_FLSH2_FLAG	0x00000100
+#define	SOFT_BAR_FLSH3_FLAG	0x00000200
+#define	SOFT_BAR_IDE_FLAG	0x00000400
+#define	SOFT_BAR_ACC_FLAG	0x00000800
+#define	SOFT_BAR_OHCI_FLAG	0x00001000
+#define	SOFT_BAR_EHCI_FLAG	0x00002000
+#define	SOFT_BAR_UDC_FLAG	0x00004000
+#define	SOFT_BAR_OTG_FLAG	0x00008000
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
+#define	DIVIL_LBAR_FLSH0	0x10
+#define	DIVIL_LBAR_FLSH1	0x11
+#define	DIVIL_LBAR_FLSH2	0x12
+#define	DIVIL_LBAR_FLSH3	0x13
+#define	DIVIL_LEG_IO		0x14
+#define	DIVIL_BALL_OPTS		0x15
+#define	DIVIL_SOFT_IRQ		0x16
+#define	DIVIL_SOFT_RESET	0x17
+/* NOR FLASH */
+#define	NORF_CTRL		0x18
+#define	NORF_T01		0x19
+#define	NORF_T23		0x1A
+/* NAND FLASH */
+#define	NANDF_DATA		0x1B
+#define	NANDF_CTRL		0x1C
+#define	NANDF_RSVD		0x1D
+/* KEL Keyboard Emulation Logic */
+#define	KEL_CTRL		0x1F
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
+/* MFGPT */
+#define	MFGPT_IRQ		0x28
+#define	MFGPT_NR		0x29
+#define	MFGPT_RSVD		0x2A
+#define	MFGPT_SETUP		0x2B
+/* FLOPPY */
+#define	FLPY_3F2_SHDW		0x30
+#define	FLPY_3F7_SHDW		0x31
+#define	FLPY_372_SHDW		0x32
+#define	FLPY_377_SHDW		0x33
+/* PIT */
+#define	PIT_SHDW		0x36
+#define	PIT_CNTRL		0x37
+/* UART */
+#define	UART1_MOD		0x38
+#define	UART1_DONG		0x39
+#define	UART1_CONF		0x3A
+#define	UART1_RSVD		0x3B
+#define	UART2_MOD		0x3C
+#define	UART2_DONG		0x3D
+#define	UART2_CONF		0x3E
+#define	UART2_RSVD		0x3F
+/* DMA */
+#define	DIVIL_AC_DMA		0x1E
+#define	DMA_MAP			0x40
+#define	DMA_SHDW_CH0		0x41
+#define	DMA_SHDW_CH1		0x42
+#define	DMA_SHDW_CH2		0x43
+#define	DMA_SHDW_CH3		0x44
+#define	DMA_SHDW_CH4		0x45
+#define	DMA_SHDW_CH5		0x46
+#define	DMA_SHDW_CH6		0x47
+#define	DMA_SHDW_CH7		0x48
+#define	DMA_MSK_SHDW		0x49
+/* LPC */
+#define	LPC_EADDR		0x4C
+#define	LPC_ESTAT		0x4D
+#define	LPC_SIRQ		0x4E
+#define	LPC_RSVD		0x4F
+/* PMC */
+#define	PMC_LTMR		0x50
+#define	PMC_RSVD		0x51
+/* RTC */
+#define	RTC_RAM_LOCK		0x54
+#define	RTC_DOMA_OFFSET		0x55
+#define	RTC_MONA_OFFSET		0x56
+#define	RTC_CEN_OFFSET		0x57
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
+#define	USB_UDC		0x0A
+#define	USB_OTG		0x0B
+
+/****************** NATIVE ***************************/
+/* GPIO : I/O SPACE; REG : 32BITS */
+#define	GPIOL_OUT_VAL		0x00
+#define	GPIOL_OUT_EN		0x04
+
+#endif				/* _CS5536_H */
diff --git a/arch/mips/include/asm/mach-loongson/cs5536/cs5536_pci.h b/arch/mips/include/asm/mach-loongson/cs5536/cs5536_pci.h
new file mode 100644
index 0000000..34d37ed
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson/cs5536/cs5536_pci.h
@@ -0,0 +1,174 @@
+/*
+ * the definition file of cs5536 Virtual Support Module(VSM).
+ * pci configuration space can be accessed through the VSM, so
+ * there is no need of the MSR read/write now, except the spec.
+ * MSR registers which are not implemented yet.
+ *
+ * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
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
+#define	CS5536_FLASH_INTR	6
+#define	CS5536_ACC_INTR		9
+#define	CS5536_IDE_INTR		14
+#define	CS5536_USB_INTR		11
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
+#define	CS5536_FLASH_DEVICE_ID		0x2091
+#define	CS5536_IDE_DEVICE_ID		0x209a
+#define	CS5536_ACC_DEVICE_ID		0x2093
+#define	CS5536_OHCI_DEVICE_ID		0x2094
+#define	CS5536_EHCI_DEVICE_ID		0x2095
+#define	CS5536_UDC_DEVICE_ID		0x2096
+#define	CS5536_OTG_DEVICE_ID		0x2097
+
+/* CLASS CODE : CLASS SUB-CLASS INTERFACE */
+#define	CS5536_ISA_CLASS_CODE		0x060100
+#define	CS5536_FLASH_CLASS_CODE		0x050100
+#define CS5536_IDE_CLASS_CODE		0x010180
+#define	CS5536_ACC_CLASS_CODE		0x040100
+#define	CS5536_OHCI_CLASS_CODE		0x0C0310
+#define	CS5536_EHCI_CLASS_CODE		0x0C0320
+#define	CS5536_UDC_CLASS_CODE		0x0C03FE
+#define	CS5536_OTG_CLASS_CODE		0x0C0380
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
+#define	CS5536_FLASH_SUB_ID		CS5536_FLASH_DEVICE_ID
+#define	CS5536_IDE_SUB_ID		CS5536_IDE_DEVICE_ID
+#define	CS5536_ACC_SUB_ID		CS5536_ACC_DEVICE_ID
+#define	CS5536_OHCI_SUB_ID		CS5536_OHCI_DEVICE_ID
+#define	CS5536_EHCI_SUB_ID		CS5536_EHCI_DEVICE_ID
+#define	CS5536_UDC_SUB_ID		CS5536_UDC_DEVICE_ID
+#define	CS5536_OTG_SUB_ID		CS5536_OTG_DEVICE_ID
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
+ * FLASH EXPANSION
+ */
+#define	PCI_FLASH_INT_REG		0x50
+#define	PCI_NOR_FLASH_CTRL_REG		0x40
+#define	PCI_NOR_FLASH_T01_REG		0x44
+#define	PCI_NOR_FLASH_T23_REG		0x48
+#define	PCI_NAND_FLASH_TDATA_REG	0x60
+#define	PCI_NAND_FLASH_TCTRL_REG	0x64
+#define	PCI_NAND_FLASH_RSVD_REG		0x68
+#define	PCI_FLASH_SELECT_REG		0x70
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
index 0000000..41e7136
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson/cs5536/cs5536_vsm.h
@@ -0,0 +1,59 @@
+/*
+ * the Virtual Support Module(VSM) read/write interfaces
+ *
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ */
+
+#ifndef	_CS5536_VSM_H
+#define	_CS5536_VSM_H
+
+#include <linux/types.h>
+
+#define DECLARE_CS5536_MODULE(name) \
+extern void pci_##name##_write_reg(int reg, u32 value); \
+extern u32 pci_##name##_read_reg(int reg);
+
+#define DEFINE_CS5536_MODULE(name) \
+void pci_##name##_write_reg(int reg, u32 value)\
+{						\
+	return;					\
+}						\
+u32 pci_##name##_read_reg(int reg)		\
+{						\
+	return 0xffffffff;			\
+}						\
+
+/* core modules of cs5536 */
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
+/* selective modules of cs5536 */
+/* flash(nor or nand flash) module */
+#ifdef CONFIG_CS5536_FLASH
+    DECLARE_CS5536_MODULE(flash)
+#else
+    DEFINE_CS5536_MODULE(flash)
+#endif
+/* otg module */
+#ifdef CONFIG_CS5536_OTG
+    DECLARE_CS5536_MODULE(otg)
+#else
+    DEFINE_CS5536_MODULE(otg)
+#endif
+/* udc module */
+#ifdef CONFIG_CS5536_UDC
+    DECLARE_CS5536_MODULE(udc)
+#else
+    DEFINE_CS5536_MODULE(udc)
+#endif
+#endif				/* _CS5536_VSM_H */
diff --git a/arch/mips/include/asm/mach-loongson/loongson.h b/arch/mips/include/asm/mach-loongson/loongson.h
index 8ddfbd3..aaa2948 100644
--- a/arch/mips/include/asm/mach-loongson/loongson.h
+++ b/arch/mips/include/asm/mach-loongson/loongson.h
@@ -287,7 +287,7 @@ extern unsigned long _loongson_addrwincfg_base;
 	s##_WIN##w##_BASE = (src); \
 	s##_WIN##w##_MMAP = (src) | ADDRWIN_MAP_DST_##d; \
 	s##_WIN##w##_MASK = ~(size-1); \
-} while (0);
+} while (0)
 
 #define LOONGSON_ADDRWIN_CPUTOPCI(win, src, dst, size) \
 	LOONGSON_ADDRWIN_CFG(CPU, PCI, win, src, dst, size)
diff --git a/arch/mips/include/asm/mach-loongson/machine.h b/arch/mips/include/asm/mach-loongson/machine.h
index 5f2cd3a..bb3dd37 100644
--- a/arch/mips/include/asm/mach-loongson/machine.h
+++ b/arch/mips/include/asm/mach-loongson/machine.h
@@ -13,6 +13,8 @@
 #ifndef __MACHINE_H
 #define __MACHINE_H
 
+#ifdef CONFIG_LEMOTE_FULOONG2E
+
 #define MACH_NAME			"lemote-fuloong(2e)"
 
 #define LOONGSON_UART_BASE		0x1fd003f8
@@ -23,5 +25,33 @@
 #define LOONGSON_TIMER_IRQ        	(MIPS_CPU_IRQ_BASE + 7)
 #define LOONGSON_DMATIMEOUT_IRQ		(LOONGSON_IRQ_BASE + 10)
 
+#else /* CONFIG_LEMOTE_FULOONG2F */
+
+#define MACH_NAME			"lemote-fuloong(2f)"
+
+#define LOONGSON_UART_BASE		0x1fd002f8
+
+#define LOONGSON_TIMER_IRQ	(MIPS_CPU_IRQ_BASE + 7)	/* cpu timer */
+#define LOONGSON_PERFCNT_IRQ	(MIPS_CPU_IRQ_BASE + 6) /* cpu perf counter */
+#define LOONGSON_NORTH_BRIDGE_IRQ	(MIPS_CPU_IRQ_BASE + 6)	/* bonito */
+#define LOONGSON_UART_IRQ	(MIPS_CPU_IRQ_BASE + 3)	/* cpu serial port */
+#define LOONGSON_SOUTH_BRIDGE_IRQ	(MIPS_CPU_IRQ_BASE + 2)	/* i8259 */
+
+#define LOONGSON_INT_BIT_GPIO1		(1 << 1)
+#define LOONGSON_INT_BIT_GPIO2		(1 << 2)
+#define LOONGSON_INT_BIT_GPIO3		(1 << 3)
+#define LOONGSON_INT_BIT_PCI_INTA	(1 << 4)
+#define LOONGSON_INT_BIT_PCI_INTB	(1 << 5)
+#define LOONGSON_INT_BIT_PCI_INTC	(1 << 6)
+#define LOONGSON_INT_BIT_PCI_INTD	(1 << 7)
+#define LOONGSON_INT_BIT_PCI_PERR	(1 << 8)
+#define LOONGSON_INT_BIT_PCI_SERR	(1 << 9)
+#define LOONGSON_INT_BIT_DDR		(1 << 10)
+#define LOONGSON_INT_BIT_INT0		(1 << 11)
+#define LOONGSON_INT_BIT_INT1		(1 << 12)
+#define LOONGSON_INT_BIT_INT2		(1 << 13)
+#define LOONGSON_INT_BIT_INT3		(1 << 14)
+
+#endif
 
 #endif				/* ! __MACHINE_H */
diff --git a/arch/mips/loongson/Kconfig b/arch/mips/loongson/Kconfig
index 5874bf6..2bfda6e 100644
--- a/arch/mips/loongson/Kconfig
+++ b/arch/mips/loongson/Kconfig
@@ -28,4 +28,48 @@ config LEMOTE_FULOONG2E
 	  Lemote Fulong mini-PC board based on the Chinese Loongson-2E CPU and
 	  an FPGA northbridge
 
+config LEMOTE_FULOONG2F
+	bool "Lemote Fuloong(2f) mini-PC"
+	select ARCH_SPARSEMEM_ENABLE
+	select CEVT_R4K
+	select CSRC_R4K
+	select SYS_HAS_CPU_LOONGSON2F
+	select DMA_NONCOHERENT
+	select BOOT_ELF32
+	select BOARD_SCACHE
+	select HW_HAS_PCI
+	select I8259
+	select ISA
+	select IRQ_CPU
+	select SYS_SUPPORTS_32BIT_KERNEL
+	select SYS_SUPPORTS_64BIT_KERNEL
+	select SYS_SUPPORTS_LITTLE_ENDIAN
+	select SYS_SUPPORTS_HIGHMEM
+	select SYS_HAS_EARLY_PRINTK
+	select GENERIC_HARDIRQS_NO__DO_IRQ
+	select GENERIC_ISA_DMA_SUPPORT_BROKEN
+	select CPU_HAS_WB
+	select CS5536
+	help
+	  Lemote Fulong mini-PC board based on the Chinese Loongson-2F CPU
+
 endchoice
+
+config CS5536
+	bool
+
+config CS5536_FLASH
+	bool
+	depends on CS5536
+
+config CS5536_NOR_FLASH
+	bool
+	depends on CS5536_FLASH
+
+config CS5536_OTG
+	bool
+	depends on CS5536
+
+config CS5536_UDC
+	bool
+	depends on CS5536
diff --git a/arch/mips/loongson/Makefile b/arch/mips/loongson/Makefile
index cc9f1c8..e9b8a81 100644
--- a/arch/mips/loongson/Makefile
+++ b/arch/mips/loongson/Makefile
@@ -9,3 +9,9 @@ obj-$(CONFIG_LOONGSON_SYSTEMS) += common/
 #
 
 obj-$(CONFIG_LEMOTE_FULOONG2E)	+= fuloong-2e/
+
+#
+# Lemote Fuloong mini-PC (Loongson 2F-based)
+#
+
+obj-$(CONFIG_LEMOTE_FULOONG2F)	+= fuloong-2f/
diff --git a/arch/mips/loongson/common/Makefile b/arch/mips/loongson/common/Makefile
index 79b2736..71a4ea7 100644
--- a/arch/mips/loongson/common/Makefile
+++ b/arch/mips/loongson/common/Makefile
@@ -17,4 +17,10 @@ obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
 #
 obj-$(CONFIG_RTC_DRV_CMOS) += rtc.o
 
+#
+# Enable CS5536 Virtual Support Module(VSM) for virtulize the PCI configure
+# space
+#
+obj-$(CONFIG_CS5536) += cs5536/
+
 EXTRA_CFLAGS += -Werror
diff --git a/arch/mips/loongson/common/bonito-irq.c b/arch/mips/loongson/common/bonito-irq.c
index 1f43447..940c1f0 100644
--- a/arch/mips/loongson/common/bonito-irq.c
+++ b/arch/mips/loongson/common/bonito-irq.c
@@ -53,10 +53,13 @@ static struct irq_chip bonito_irq_type = {
 	.unmask	= bonito_irq_enable,
 };
 
+/* there is no need to handle dma timeout in loongson-2f based machines */
+#ifdef CONFIG_CPU_LOONGSON2E
 static struct irqaction dma_timeout_irqaction = {
 	.handler	= no_action,
 	.name		= "dma_timeout",
 };
+#endif
 
 void bonito_irq_init(void)
 {
@@ -65,5 +68,7 @@ void bonito_irq_init(void)
 	for (i = LOONGSON_IRQ_BASE; i < LOONGSON_IRQ_BASE + 32; i++)
 		set_irq_chip_and_handler(i, &bonito_irq_type, handle_level_irq);
 
+#ifdef CONFIG_CPU_LOONGSON2E
 	setup_irq(LOONGSON_DMATIMEOUT_IRQ, &dma_timeout_irqaction);
+#endif
 }
diff --git a/arch/mips/loongson/common/cs5536/Makefile b/arch/mips/loongson/common/cs5536/Makefile
new file mode 100644
index 0000000..09bc177
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/Makefile
@@ -0,0 +1,20 @@
+#
+# Makefile for CS5536 support.
+#
+
+#
+# core modules
+#
+obj-$(CONFIG_CS5536) += cs5536_pci.o cs5536_ide.o cs5536_acc.o cs5536_ohci.o \
+			cs5536_isa.o cs5536_ehci.o
+#
+# selective modules
+#
+# add a CS5536_[MODULE] to your board in arch/mips/loongson/Kconfig
+#
+obj-$(CONFIG_CS5536_FLASH) += cs5536_flash.o
+obj-$(CONFIG_CS5536_NOR_FLASH) += cs5536_flash.o
+obj-$(CONFIG_CS5536_OTG) += cs5536_otg.o
+obj-$(CONFIG_CS5536_UDC) += cs5536_udc.o
+
+EXTRA_CFLAGS += -Werror
diff --git a/arch/mips/loongson/common/cs5536/cs5536_acc.c b/arch/mips/loongson/common/cs5536/cs5536_acc.c
new file mode 100644
index 0000000..487f4a6
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/cs5536_acc.c
@@ -0,0 +1,155 @@
+/*
+ * the ACC Virtual Support Module of AMD CS5536
+ *
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author : jlliu, liujl@lemote.com
+ *
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
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
+	case PCI_BAR1_REG:
+	case PCI_BAR2_REG:
+	case PCI_BAR3_REG:
+	case PCI_BAR4_REG:
+	case PCI_BAR5_REG:
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
+		conf_data = CFG_PCI_INTERRUPT_LINE(PCI_DEFAULT_PIN, CS5536_ACC_INTR);
+		break;
+	default:
+		break;
+	}
+
+	return conf_data;
+}
diff --git a/arch/mips/loongson/common/cs5536/cs5536_ehci.c b/arch/mips/loongson/common/cs5536/cs5536_ehci.c
new file mode 100644
index 0000000..9c262fd
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/cs5536_ehci.c
@@ -0,0 +1,165 @@
+/*
+ * the EHCI Virtual Support Module of AMD CS5536
+ *
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author : jlliu, liujl@lemote.com
+ *
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
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
+	case PCI_BAR1_REG:
+	case PCI_BAR2_REG:
+	case PCI_BAR3_REG:
+	case PCI_BAR4_REG:
+	case PCI_BAR5_REG:
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
+		conf_data = CFG_PCI_INTERRUPT_LINE(PCI_DEFAULT_PIN, CS5536_USB_INTR);
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
diff --git a/arch/mips/loongson/common/cs5536/cs5536_flash.c b/arch/mips/loongson/common/cs5536/cs5536_flash.c
new file mode 100644
index 0000000..88226c8
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/cs5536_flash.c
@@ -0,0 +1,450 @@
+/*
+ * the FLASH Virtual Support Module of AMD CS5536
+ *
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author : jlliu, liujl@lemote.com
+ *
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
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
+ * enable the region of flashs(NOR or NAND)
+ *
+ * the same as the DIVIL other modules above, two groups of regs should be
+ * modified here to control the region. DIVIL flash LBAR and the
+ * RCONFx(6~9 reserved).
+ */
+static void flash_lbar_enable(void)
+{
+	u32 hi, lo;
+	int offset;
+
+	for (offset = DIVIL_LBAR_FLSH0; offset <= DIVIL_LBAR_FLSH3; offset++) {
+		_rdmsr(DIVIL_MSR_REG(offset), &hi, &lo);
+		hi |= 0x1;
+		_wrmsr(DIVIL_MSR_REG(offset), hi, lo);
+	}
+
+	for (offset = SB_R6; offset <= SB_R9; offset++) {
+		_rdmsr(SB_MSR_REG(offset), &hi, &lo);
+		lo |= 0x1;
+		_wrmsr(SB_MSR_REG(offset), hi, lo);
+	}
+
+	return;
+}
+
+/*
+ * disable the region of flashs(NOR or NAND)
+ */
+static void flash_lbar_disable(void)
+{
+	u32 hi, lo;
+	int offset;
+
+	for (offset = DIVIL_LBAR_FLSH0; offset <= DIVIL_LBAR_FLSH3; offset++) {
+		_rdmsr(DIVIL_MSR_REG(offset), &hi, &lo);
+		hi &= ~0x01;
+		_wrmsr(DIVIL_MSR_REG(offset), hi, lo);
+	}
+	for (offset = SB_R6; offset <= SB_R9; offset++) {
+		_rdmsr(SB_MSR_REG(offset), &hi, &lo);
+		lo &= ~0x01;
+		_wrmsr(SB_MSR_REG(offset), hi, lo);
+	}
+
+	return;
+}
+
+#ifndef	CONFIG_CS5536_NOR_FLASH	/* for nand flash */
+
+void pci_flash_write_bar(int n, u32 value)
+{
+	u32 hi = 0, lo = value;
+
+	if (value == PCI_BAR_RANGE_MASK) {
+		/* make the flag for reading the bar length. */
+		_rdmsr(GLCP_MSR_REG(GLCP_SOFT_COM), &hi, &lo);
+		lo |= (SOFT_BAR_FLSH0_FLAG << n);
+		_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+	} else if ((value & 0x01) == 0x00) {
+		/* mem space nand flash native reg base addr */
+		hi = 0xfffff007;
+		lo &= CS5536_FLSH_RANGE;
+		_wrmsr(DIVIL_MSR_REG(DIVIL_LBAR_FLSH0 + n), hi, lo);
+
+		/* RCONFx is 4KB in units for mem space. */
+		hi = ((value & 0xfffff000) << 12) |
+		    ((CS5536_FLSH_LENGTH & 0xfffff000) - (1 << 12)) | 0x00;
+		lo = ((value & 0xfffff000) << 12) | 0x01;
+		_wrmsr(SB_MSR_REG(SB_R6 + n), hi, lo);
+	}
+	return;
+}
+
+void pci_flash_write_reg(int reg, u32 value)
+{
+	u32 hi = 0, lo = value;
+
+	switch (reg) {
+	case PCI_COMMAND:
+		if (value & PCI_COMMAND_MEMORY)
+			flash_lbar_enable();
+		else
+			flash_lbar_disable();
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
+		pci_flash_write_bar(0, value);
+		break;
+	case PCI_BAR1_REG:
+		pci_flash_write_bar(1, value);
+		break;
+	case PCI_BAR2_REG:
+		pci_flash_write_bar(2, value);
+		break;
+	case PCI_BAR3_REG:
+		pci_flash_write_bar(3, value);
+		break;
+	case PCI_FLASH_INT_REG:
+		_rdmsr(DIVIL_MSR_REG(PIC_YSEL_LOW), &hi, &lo);
+		/* disable all the flash interrupt in PIC */
+		lo &= ~(0xf << PIC_YSEL_LOW_FLASH_SHIFT);
+		if (value)	/* enable all the flash interrupt in PIC */
+			lo |= (CS5536_FLASH_INTR << PIC_YSEL_LOW_FLASH_SHIFT);
+		_wrmsr(DIVIL_MSR_REG(PIC_YSEL_LOW), hi, lo);
+		break;
+	case PCI_NAND_FLASH_TDATA_REG:
+		_wrmsr(DIVIL_MSR_REG(NANDF_DATA), hi, lo);
+		break;
+	case PCI_NAND_FLASH_TCTRL_REG:
+		lo &= 0x00000fff;
+		_wrmsr(DIVIL_MSR_REG(NANDF_CTRL), hi, lo);
+		break;
+	case PCI_NAND_FLASH_RSVD_REG:
+		_wrmsr(DIVIL_MSR_REG(NANDF_RSVD), hi, lo);
+		break;
+	case PCI_FLASH_SELECT_REG:
+		if (value == CS5536_IDE_FLASH_SIGNATURE) {
+			_rdmsr(DIVIL_MSR_REG(DIVIL_BALL_OPTS), &hi, &lo);
+			lo &= ~0x01;
+			_wrmsr(DIVIL_MSR_REG(DIVIL_BALL_OPTS), hi, lo);
+		}
+		break;
+	default:
+		break;
+	}
+
+	return;
+}
+
+u32 pci_flash_read_bar(int n)
+{
+	u32 hi, lo;
+	u32 conf_data = 0;
+
+	_rdmsr(GLCP_MSR_REG(GLCP_SOFT_COM), &hi, &lo);
+	if (lo & (SOFT_BAR_FLSH0_FLAG << n)) {
+		conf_data = CS5536_FLSH_RANGE | PCI_BASE_ADDRESS_SPACE_MEMORY;
+		lo &= ~(SOFT_BAR_FLSH0_FLAG << n);
+		_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+	} else {
+		_rdmsr(DIVIL_MSR_REG(DIVIL_LBAR_FLSH0 + n), &hi, &lo);
+		conf_data = lo;
+		conf_data &= ~0x0f;
+	}
+
+	return conf_data;
+}
+
+u32 pci_flash_read_reg(int reg)
+{
+	u32 conf_data = 0;
+	u32 hi, lo;
+
+	switch (reg) {
+	case PCI_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_FLASH_DEVICE_ID, CS5536_VENDOR_ID);
+		break;
+	case PCI_COMMAND:
+		/* we just read one lbar for returning. */
+		_rdmsr(DIVIL_MSR_REG(DIVIL_LBAR_FLSH0), &hi, &lo);
+		if (hi & 0x1)
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
+		_rdmsr(DIVIL_MSR_REG(DIVIL_CAP), &hi, &lo);
+		conf_data = lo & 0x000000ff;
+		conf_data |= (CS5536_FLASH_CLASS_CODE << 8);
+		break;
+	case PCI_CACHE_LINE_SIZE:
+		conf_data =
+		    CFG_PCI_CACHE_LINE_SIZE(PCI_NORMAL_HEADER_TYPE,
+					    PCI_NORMAL_LATENCY_TIMER);
+		break;
+	case PCI_BAR0_REG:
+		return pci_flash_read_bar(0);
+		break;
+	case PCI_BAR1_REG:
+		return pci_flash_read_bar(1);
+		break;
+	case PCI_BAR2_REG:
+		return pci_flash_read_bar(2);
+		break;
+	case PCI_BAR3_REG:
+		return pci_flash_read_bar(3);
+		break;
+	case PCI_CARDBUS_CIS:
+		conf_data = PCI_CARDBUS_CIS_POINTER;
+		break;
+	case PCI_SUBSYSTEM_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_FLASH_SUB_ID,
+				      CS5536_SUB_VENDOR_ID);
+		break;
+	case PCI_ROM_ADDRESS:
+		conf_data = PCI_EXPANSION_ROM_BAR;
+		break;
+	case PCI_CAPABILITY_LIST:
+		conf_data = PCI_CAPLIST_POINTER;
+		break;
+	case PCI_INTERRUPT_LINE:
+		conf_data = CFG_PCI_INTERRUPT_LINE(PCI_DEFAULT_PIN, CS5536_FLASH_INTR);
+		break;
+	case PCI_NAND_FLASH_TDATA_REG:
+		_rdmsr(DIVIL_MSR_REG(NANDF_DATA), &hi, &lo);
+		conf_data = lo;
+		break;
+	case PCI_NAND_FLASH_TCTRL_REG:
+		_rdmsr(DIVIL_MSR_REG(NANDF_CTRL), &hi, &lo);
+		conf_data = lo & 0x00000fff;
+		break;
+	case PCI_NAND_FLASH_RSVD_REG:
+		_rdmsr(DIVIL_MSR_REG(NANDF_RSVD), &hi, &lo);
+		conf_data = lo;
+		break;
+	case PCI_FLASH_SELECT_REG:
+		_rdmsr(DIVIL_MSR_REG(DIVIL_BALL_OPTS), &hi, &lo);
+		conf_data = lo & 0x01;
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+#else				/* CONFIG_CS5536_NOR_FLASH */
+
+void pci_flash_write_bar(int n, u32 value)
+{
+	u32 hi = 0, lo = value;
+
+	if (value == PCI_BAR_RANGE_MASK) {
+		_rdmsr(GLCP_MSR_REG(GLCP_SOFT_COM), &hi, &lo);
+		lo |= (SOFT_BAR_FLSH0_FLAG << n);
+		_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+	} else if (value & 0x01) {
+		/* IO space of 16bytes nor flash */
+		hi = 0x0000fff1;
+		lo &= CS5536_FLSH_RANGE;
+		_wrmsr(DIVIL_MSR_REG(DIVIL_LBAR_FLSH0 + n), hi, lo);
+
+		/* RCONFx used for 16bytes reserved. */
+		hi = ((value & 0x000ffffc) << 12) | ((CS5536_FLSH_LENGTH - 4)
+						     << 12) | 0x01;
+		lo = ((value & 0x000ffffc) << 12) | 0x01;
+		_wrmsr(SB_MSR_REG(SB_R6 + n), hi, lo);
+	}
+	return;
+}
+
+void pci_flash_write_reg(int reg, u32 value)
+{
+	u32 hi = 0, lo = value;
+
+	switch (reg) {
+	case PCI_COMMAND:
+		if (value & PCI_COMMAND_IO)
+			flash_lbar_enable();
+		else
+			flash_lbar_disable();
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
+		pci_flash_write_bar(0, value);
+		break;
+	case PCI_BAR1_REG:
+		pci_flash_write_bar(1, value);
+		break;
+	case PCI_BAR2_REG:
+		pci_flash_write_bar(2, value);
+		break;
+	case PCI_BAR3_REG:
+		pci_flash_write_bar(3, value);
+		break;
+	case PCI_FLASH_INT_REG:
+		_rdmsr(DIVIL_MSR_REG(PIC_YSEL_LOW), &hi, &lo);
+		/* disable all the flash interrupt in PIC */
+		lo &= ~(0xf << PIC_YSEL_LOW_FLASH_SHIFT);
+		if (value)	/* enable all the flash interrupt in PIC */
+			lo |= (CS5536_FLASH_INTR << PIC_YSEL_LOW_FLASH_SHIFT);
+		_wrmsr(DIVIL_MSR_REG(PIC_YSEL_LOW), hi, lo);
+		break;
+	case PCI_NOR_FLASH_CTRL_REG:
+		lo &= 0x000000ff;
+		_wrmsr(DIVIL_MSR_REG(NORF_CTRL), hi, lo);
+		break;
+	case PCI_NOR_FLASH_T01_REG:
+		_wrmsr(DIVIL_MSR_REG(NORF_T01), hi, lo);
+		break;
+	case PCI_NOR_FLASH_T23_REG:
+		_wrmsr(DIVIL_MSR_REG(NORF_T23), hi, lo);
+		break;
+	case PCI_FLASH_SELECT_REG:
+		if (value == CS5536_IDE_FLASH_SIGNATURE) {
+			_rdmsr(DIVIL_MSR_REG(DIVIL_BALL_OPTS), &hi, &lo);
+			lo &= ~0x01;
+			_wrmsr(DIVIL_MSR_REG(DIVIL_BALL_OPTS), hi, lo);
+		}
+		break;
+	default:
+		break;
+	}
+	return;
+}
+
+u32 pci_flash_read_bar(int n)
+{
+	u32 hi, lo;
+	u32 conf_data = 0;
+
+	_rdmsr(GLCP_MSR_REG(GLCP_SOFT_COM), &hi, &lo);
+	if (lo & (SOFT_BAR_FLSH0_FLAG << n)) {
+		conf_data = CS5536_FLSH_RANGE | PCI_BASE_ADDRESS_SPACE_IO;
+		lo &= ~(SOFT_BAR_FLSH0_FLAG << n);
+		_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+	} else {
+		_rdmsr(DIVIL_MSR_REG(DIVIL_LBAR_FLSH0 + n), &hi, &lo);
+		conf_data = lo & 0x0000ffff;
+		conf_data |= 0x01;
+		conf_data &= ~0x02;
+	}
+
+	return conf_data;
+}
+
+u32 pci_flash_read_reg(int reg)
+{
+	u32 conf_data = 0;
+	u32 hi, lo;
+
+	switch (reg) {
+	case PCI_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_FLASH_DEVICE_ID, CS5536_VENDOR_ID);
+		break;
+	case PCI_COMMAND:
+		/* we just check one flash bar for returning. */
+		_rdmsr(DIVIL_MSR_REG(DIVIL_LBAR_FLSH0), &hi, &lo);
+		if (hi & PCI_COMMAND_IO)
+			conf_data |= PCI_COMMAND_IO;
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
+		_rdmsr(DIVIL_MSR_REG(DIVIL_CAP), &hi, &lo);
+		conf_data = lo & 0x000000ff;
+		conf_data |= (CS5536_FLASH_CLASS_CODE << 8);
+		break;
+	case PCI_CACHE_LINE_SIZE:
+		conf_data =
+		    CFG_PCI_CACHE_LINE_SIZE(PCI_NORMAL_HEADER_TYPE,
+					    PCI_NORMAL_LATENCY_TIMER);
+		break;
+	case PCI_BAR0_REG:
+		return pci_flash_read_bar(0);
+		break;
+	case PCI_BAR1_REG:
+		return pci_flash_read_bar(1);
+		break;
+	case PCI_BAR2_REG:
+		return pci_flash_read_bar(2);
+		break;
+	case PCI_BAR3_REG:
+		return pci_flash_read_bar(3);
+		break;
+	case PCI_CARDBUS_CIS:
+		conf_data = PCI_CARDBUS_CIS_POINTER;
+		break;
+	case PCI_SUBSYSTEM_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_FLASH_SUB_ID,
+				      CS5536_SUB_VENDOR_ID);
+		break;
+	case PCI_ROM_ADDRESS:
+		conf_data = PCI_EXPANSION_ROM_BAR;
+		break;
+	case PCI_CAPABILITY_LIST:
+		conf_data = PCI_CAPLIST_POINTER;
+		break;
+	case PCI_INTERRUPT_LINE:
+		conf_data = CFG_PCI_INTERRUPT_LINE(PCI_DEFAULT_PIN, CS5536_FLASH_INTR);
+		break;
+	case PCI_NOR_FLASH_CTRL_REG:
+		_rdmsr(DIVIL_MSR_REG(NORF_CTRL), &hi, &lo);
+		conf_data = lo & 0x000000ff;
+		break;
+	case PCI_NOR_FLASH_T01_REG:
+		_rdmsr(DIVIL_MSR_REG(NORF_T01), &hi, &lo);
+		conf_data = lo;
+		break;
+	case PCI_NOR_FLASH_T23_REG:
+		_rdmsr(DIVIL_MSR_REG(NORF_T23), &hi, &lo);
+		conf_data = lo;
+		break;
+	default:
+		break;
+	}
+	return conf_data;
+}
+#endif				/* CONFIG_CS5536_NOR_FLASH */
diff --git a/arch/mips/loongson/common/cs5536/cs5536_ide.c b/arch/mips/loongson/common/cs5536/cs5536_ide.c
new file mode 100644
index 0000000..fa605cd
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/cs5536_ide.c
@@ -0,0 +1,193 @@
+/*
+ * the IDE Virtual Support Module of AMD CS5536
+ *
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author : jlliu, liujl@lemote.com
+ *
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
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
+	case PCI_BAR0_REG:
+	case PCI_BAR1_REG:
+	case PCI_BAR2_REG:
+	case PCI_BAR3_REG:
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
+	case PCI_BAR5_REG:
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
+		conf_data = CFG_PCI_INTERRUPT_LINE(PCI_DEFAULT_PIN, CS5536_IDE_INTR);
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
index 0000000..507cd4f
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/cs5536_isa.c
@@ -0,0 +1,376 @@
+/*
+ * the ISA Virtual Support Module of AMD CS5536
+ *
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author : jlliu, liujl@lemote.com
+ *
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
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
+ * WE assume that the ISA is not the BUS MASTER.!!!
+ */
+/* FAST BACK TO BACK '1' for BUS MASTER '0' for BUS SALVE */
+/* COMMAND :
+ * 	bit0 : IO SPACE ENABLE
+ *	bit1 : MEMORY SPACE ENABLE(ignore)
+ *	bit2 : BUS MASTER ENABLE(ignore)
+ *	bit3 : SPECIAL CYCLE(ignore)? default is ignored.
+ *	bit4 : MEMORY WRITE and INVALIDATE(ignore)
+ *	bit5 : VGA PALETTE(ignore)
+ *	bit6 : PARITY ERROR(ignore)? : default is ignored.
+ *	bit7 : WAIT CYCLE CONTROL(ignore)
+ *	bit8 : SYSTEM ERROR(ignore)
+ *	bit9 : FAST BACK TO BACK(ignore)
+ *	bit10-bit15 : RESERVED
+ * STATUS :
+ *	bit0-bit3 : RESERVED
+ *	bit4 : CAPABILITY LIST(ignore)
+ *	bit5 : 66MHZ CAPABLE
+ *	bit6 : RESERVED
+ *	bit7 : FAST BACK TO BACK(ignore)
+ *	bit8 : DATA PARITY ERROR DETECED(ignore)
+ *	bit9-bit10 : DEVSEL TIMING(ALL MEDIUM)
+ *	bit11: SIGNALED TARGET ABORT
+ *	bit12: RECEIVED TARGET ABORT
+ *	bit13: RECEIVED MASTER ABORT
+ *	bit14: SIGNALED SYSTEM ERROR
+ *	bit15: DETECTED PARITY ERROR
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
+ /* COMMAND :
+  *     bit0 : IO SPACE ENABLE
+  *     bit1 : MEMORY SPACE ENABLE(ignore)
+  *     bit2 : BUS MASTER ENABLE(ignore)
+  *     bit3 : SPECIAL CYCLE(ignore)? default is ignored.
+  *     bit4 : MEMORY WRITE and INVALIDATE(ignore)
+  *     bit5 : VGA PALETTE(ignore)
+  *     bit6 : PARITY ERROR(ignore)? : default is ignored.
+  *     bit7 : WAIT CYCLE CONTROL(ignore)
+  *     bit8 : SYSTEM ERROR(ignore)
+  *     bit9 : FAST BACK TO BACK(ignore)
+  *     bit10-bit15 : RESERVED
+  * STATUS :
+  *     bit0-bit3 : RESERVED
+  *     bit4 : CAPABILITY LIST(ignore)
+  *     bit5 : 66MHZ CAPABLE
+  *     bit6 : RESERVED
+  *     bit7 : FAST BACK TO BACK(ignore)
+  *     bit8 : DATA PARITY ERROR DETECED(ignore)?
+  *     bit9-bit10 : DEVSEL TIMING(ALL MEDIUM)
+  *     bit11: SIGNALED TARGET ABORT
+  *     bit12: RECEIVED TARGET ABORT
+  *     bit13: RECEIVED MASTER ABORT
+  *     bit14: SIGNALED SYSTEM ERROR
+  *     bit15: DETECTED PARITY ERROR(?)
+  */
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
index 0000000..71146b3
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/cs5536_ohci.c
@@ -0,0 +1,167 @@
+/*
+ * the OHCI Virtual Support Module of AMD CS5536
+ *
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author : jlliu, liujl@lemote.com
+ *
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
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
+	case PCI_INTERRUPT_LINE:
+		value &= 0x000000ff;
+		break;
+	case PCI_OHCI_PM_REG:
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
+	case PCI_BAR1_REG:
+	case PCI_BAR2_REG:
+	case PCI_BAR3_REG:
+	case PCI_BAR4_REG:
+	case PCI_BAR5_REG:
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
+		conf_data = CFG_PCI_INTERRUPT_LINE(PCI_DEFAULT_PIN, CS5536_USB_INTR);
+		break;
+	case PCI_OHCI_PM_REG:
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
diff --git a/arch/mips/loongson/common/cs5536/cs5536_otg.c b/arch/mips/loongson/common/cs5536/cs5536_otg.c
new file mode 100644
index 0000000..363aa88
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/cs5536_otg.c
@@ -0,0 +1,137 @@
+/*
+ * the OTG Virtual Support Module of AMD CS5536
+ *
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author : jlliu, liujl@lemote.com
+ *
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
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
+void pci_otg_write_reg(int reg, u32 value)
+{
+	u32 hi = 0, lo = value;
+
+	switch (reg) {
+	case PCI_COMMAND:
+		_rdmsr(USB_MSR_REG(USB_OTG), &hi, &lo);
+		if (value & PCI_COMMAND_MEMORY)
+			hi |= PCI_COMMAND_MEMORY;
+		else
+			hi &= ~PCI_COMMAND_MEMORY;
+		_wrmsr(USB_MSR_REG(USB_OTG), hi, lo);
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
+			lo |= SOFT_BAR_OTG_FLAG;
+			_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+		} else if ((value & 0x01) == 0x00) {
+			_rdmsr(USB_MSR_REG(USB_OTG), &hi, &lo);
+			lo &= 0xffffff00;
+			_wrmsr(USB_MSR_REG(USB_OTG), hi, lo);
+
+			value &= 0xfffffff0;
+			hi = 0x40000000 | ((value & 0xff000000) >> 24);
+			lo = 0x000fffff | ((value & 0x00fff000) << 8);
+			_wrmsr(GLIU_MSR_REG(GLIU_P2D_BM1), hi, lo);
+		}
+		break;
+	default:
+		break;
+	}
+
+	return;
+}
+
+u32 pci_otg_read_reg(int reg)
+{
+	u32 conf_data = 0;
+	u32 hi, lo;
+
+	switch (reg) {
+	case PCI_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_OTG_DEVICE_ID, CS5536_VENDOR_ID);
+		break;
+	case PCI_COMMAND:
+		_rdmsr(USB_MSR_REG(USB_OTG), &hi, &lo);
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
+		conf_data |= (CS5536_OTG_CLASS_CODE << 8);
+		break;
+	case PCI_CACHE_LINE_SIZE:
+		conf_data =
+		    CFG_PCI_CACHE_LINE_SIZE(PCI_NORMAL_HEADER_TYPE,
+					    PCI_NORMAL_LATENCY_TIMER);
+		break;
+	case PCI_BAR0_REG:
+		_rdmsr(GLCP_MSR_REG(GLCP_SOFT_COM), &hi, &lo);
+		if (lo & SOFT_BAR_OTG_FLAG) {
+			conf_data = CS5536_OTG_RANGE |
+			    PCI_BASE_ADDRESS_SPACE_MEMORY;
+			lo &= ~SOFT_BAR_OTG_FLAG;
+			_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+		} else {
+			_rdmsr(USB_MSR_REG(USB_OTG), &hi, &lo);
+			conf_data = lo & 0xffffff00;
+			conf_data &= ~0x0000000f;
+		}
+		break;
+	case PCI_BAR1_REG:
+	case PCI_BAR2_REG:
+	case PCI_BAR3_REG:
+	case PCI_BAR4_REG:
+	case PCI_BAR5_REG:
+		break;
+	case PCI_CARDBUS_CIS:
+		conf_data = PCI_CARDBUS_CIS_POINTER;
+		break;
+	case PCI_SUBSYSTEM_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_OTG_SUB_ID, CS5536_SUB_VENDOR_ID);
+		break;
+	case PCI_ROM_ADDRESS:
+		conf_data = PCI_EXPANSION_ROM_BAR;
+		break;
+	case PCI_CAPABILITY_LIST:
+		conf_data = PCI_CAPLIST_USB_POINTER;
+		break;
+	case PCI_INTERRUPT_LINE:
+		conf_data = CFG_PCI_INTERRUPT_LINE(PCI_DEFAULT_PIN, CS5536_USB_INTR);
+		break;
+	default:
+		break;
+	}
+
+	return conf_data;
+}
diff --git a/arch/mips/loongson/common/cs5536/cs5536_pci.c b/arch/mips/loongson/common/cs5536/cs5536_pci.c
new file mode 100644
index 0000000..977d77e
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/cs5536_pci.c
@@ -0,0 +1,126 @@
+/*
+ * read/write operation to the PCI config space of CS5536
+ *
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author : jlliu, liujl@lemote.com
+ *
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ *	the Virtual Support Module(VSM) for virtulizing the PCI
+ *	configure space are defined in cs5536_modulename.c respectively,
+ *	so you can select modules which have been used in his/her board.
+ *	to archive this, you just need to add a "select CS5536_[MODULE]"
+ *	option in your board in arch/mips/loongson/Kconfig
+ *
+ *	after this virtulizing, user can access the PCI configure space
+ *	directly as a normal multi-function PCI device which following
+ *	the PCI-2.2 spec.
+ */
+
+#include <linux/types.h>
+#include <cs5536/cs5536_vsm.h>
+
+enum {
+	CS5536_FUNC_START = -1,
+	CS5536_ISA_FUNC,
+	CS5536_FLASH_FUNC,
+	CS5536_IDE_FUNC,
+	CS5536_ACC_FUNC,
+	CS5536_OHCI_FUNC,
+	CS5536_EHCI_FUNC,
+	CS5536_UDC_FUNC,
+	CS5536_OTG_FUNC,
+	CS5536_FUNC_END,
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
+	switch (function) {
+	case CS5536_ISA_FUNC:
+		pci_isa_write_reg(reg, value);
+		break;
+	case CS5536_FLASH_FUNC:
+		pci_flash_write_reg(reg, value);
+		break;
+	case CS5536_IDE_FUNC:
+		pci_ide_write_reg(reg, value);
+		break;
+	case CS5536_ACC_FUNC:
+		pci_acc_write_reg(reg, value);
+		break;
+	case CS5536_OHCI_FUNC:
+		pci_ohci_write_reg(reg, value);
+		break;
+	case CS5536_EHCI_FUNC:
+		pci_ehci_write_reg(reg, value);
+		break;
+	case CS5536_UDC_FUNC:
+		pci_udc_write_reg(reg, value);
+		break;
+	case CS5536_OTG_FUNC:
+		pci_otg_write_reg(reg, value);
+		break;
+	default:
+		break;
+	}
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
+	switch (function) {
+	case CS5536_ISA_FUNC:
+		data = pci_isa_read_reg(reg);
+		break;
+	case CS5536_FLASH_FUNC:
+		data = pci_flash_read_reg(reg);
+		break;
+	case CS5536_IDE_FUNC:
+		data = pci_ide_read_reg(reg);
+		break;
+	case CS5536_ACC_FUNC:
+		data = pci_acc_read_reg(reg);
+		break;
+	case CS5536_OHCI_FUNC:
+		data = pci_ohci_read_reg(reg);
+		break;
+	case CS5536_EHCI_FUNC:
+		data = pci_ehci_read_reg(reg);
+		break;
+	case CS5536_UDC_FUNC:
+		data = pci_udc_read_reg(reg);
+		break;
+	case CS5536_OTG_FUNC:
+		data = pci_otg_read_reg(reg);
+		break;
+	default:
+		break;
+	}
+	return data;
+}
diff --git a/arch/mips/loongson/common/cs5536/cs5536_udc.c b/arch/mips/loongson/common/cs5536/cs5536_udc.c
new file mode 100644
index 0000000..2050aac
--- /dev/null
+++ b/arch/mips/loongson/common/cs5536/cs5536_udc.c
@@ -0,0 +1,142 @@
+/*
+ * the UDC Virtual Support Module of AMD CS5536
+ *
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author : jlliu, liujl@lemote.com
+ *
+ * Copyright (C) 2009 Lemote, Inc. & Institute of Computing Technology
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
+void pci_udc_write_reg(int reg, u32 value)
+{
+	u32 hi = 0, lo = value;
+
+	switch (reg) {
+	case PCI_COMMAND:
+		_rdmsr(USB_MSR_REG(USB_UDC), &hi, &lo);
+		if (value & PCI_COMMAND_MASTER)
+			hi |= PCI_COMMAND_MASTER;
+		else
+			hi &= ~PCI_COMMAND_MASTER;
+
+		if (value & PCI_COMMAND_MEMORY)
+			hi |= PCI_COMMAND_MEMORY;
+		else
+			hi &= ~PCI_COMMAND_MEMORY;
+		_wrmsr(USB_MSR_REG(USB_UDC), hi, lo);
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
+			lo |= SOFT_BAR_UDC_FLAG;
+			_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+		} else if ((value & 0x01) == 0x00) {
+			_wrmsr(USB_MSR_REG(USB_UDC), hi, lo);
+
+			value &= 0xfffffff0;
+			hi = 0x40000000 | ((value & 0xff000000) >> 24);
+			lo = 0x000fffff | ((value & 0x00fff000) << 8);
+			_wrmsr(GLIU_MSR_REG(GLIU_P2D_BM0), hi, lo);
+		}
+		break;
+	default:
+		break;
+	}
+
+	return;
+}
+
+u32 pci_udc_read_reg(int reg)
+{
+	u32 conf_data = 0;
+	u32 hi, lo;
+
+	switch (reg) {
+	case PCI_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_UDC_DEVICE_ID, CS5536_VENDOR_ID);
+		break;
+	case PCI_COMMAND:
+		_rdmsr(USB_MSR_REG(USB_UDC), &hi, &lo);
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
+		conf_data |= (CS5536_UDC_CLASS_CODE << 8);
+		break;
+	case PCI_CACHE_LINE_SIZE:
+		conf_data =
+		    CFG_PCI_CACHE_LINE_SIZE(PCI_NORMAL_HEADER_TYPE,
+					    PCI_NORMAL_LATENCY_TIMER);
+		break;
+	case PCI_BAR0_REG:
+		_rdmsr(GLCP_MSR_REG(GLCP_SOFT_COM), &hi, &lo);
+		if (lo & SOFT_BAR_UDC_FLAG) {
+			conf_data = CS5536_UDC_RANGE |
+			    PCI_BASE_ADDRESS_SPACE_MEMORY;
+			lo &= ~SOFT_BAR_UDC_FLAG;
+			_wrmsr(GLCP_MSR_REG(GLCP_SOFT_COM), hi, lo);
+		} else {
+			_rdmsr(USB_MSR_REG(USB_UDC), &hi, &lo);
+			conf_data = lo & 0xfffff000;
+			conf_data &= ~0x0000000f;	/* 32bit mem */
+		}
+		break;
+	case PCI_BAR1_REG:
+	case PCI_BAR2_REG:
+	case PCI_BAR3_REG:
+	case PCI_BAR4_REG:
+	case PCI_BAR5_REG:
+		break;
+	case PCI_CARDBUS_CIS:
+		conf_data = PCI_CARDBUS_CIS_POINTER;
+		break;
+	case PCI_SUBSYSTEM_VENDOR_ID:
+		conf_data =
+		    CFG_PCI_VENDOR_ID(CS5536_UDC_SUB_ID, CS5536_SUB_VENDOR_ID);
+		break;
+	case PCI_ROM_ADDRESS:
+		conf_data = PCI_EXPANSION_ROM_BAR;
+		break;
+	case PCI_CAPABILITY_LIST:
+		conf_data = PCI_CAPLIST_USB_POINTER;
+		break;
+	case PCI_INTERRUPT_LINE:
+		conf_data = CFG_PCI_INTERRUPT_LINE(PCI_DEFAULT_PIN, CS5536_USB_INTR);
+		break;
+	default:
+		break;
+	}
+
+	return conf_data;
+}
diff --git a/arch/mips/loongson/fuloong-2f/Makefile b/arch/mips/loongson/fuloong-2f/Makefile
new file mode 100644
index 0000000..010b86c
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2f/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for fuloong-2f
+#
+
+obj-y += irq.o reset.o
diff --git a/arch/mips/loongson/fuloong-2f/irq.c b/arch/mips/loongson/fuloong-2f/irq.c
new file mode 100644
index 0000000..571aeb3
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2f/irq.c
@@ -0,0 +1,53 @@
+/*
+ * Copyright (C) 2007 Lemote Inc. & Insititute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/interrupt.h>
+
+#include <loongson.h>
+#include <machine.h>
+
+inline int mach_i8259_irq(void)
+{
+	int irq, isr, imr;
+
+	irq = -1;
+
+	if ((LOONGSON_INTISR & LOONGSON_INTEN) & LOONGSON_INT_BIT_INT0) {
+		imr = inb(0x21) | (inb(0xa1) << 8);
+		isr = inb(0x20) | (inb(0xa0) << 8);
+		isr &= ~0x4;	/* irq2 for cascade */
+		isr &= ~imr;
+		irq = ffs(isr) - 1;
+	}
+
+	return irq;
+}
+
+inline void mach_irq_dispatch(unsigned int pending)
+{
+	if (pending & CAUSEF_IP7)
+		do_IRQ(LOONGSON_TIMER_IRQ);
+	else if (pending & CAUSEF_IP6) {	/* North Bridge, Perf counter */
+		do_IRQ(LOONGSON_PERFCNT_IRQ);
+		bonito_irqdispatch();
+	} else if (pending & CAUSEF_IP3)	/* CPU UART */
+		do_IRQ(LOONGSON_UART_IRQ);
+	else if (pending & CAUSEF_IP2)	/* South Bridge */
+		i8259_irqdispatch();
+	else
+		spurious_interrupt();
+}
+
+void __init set_irq_trigger_mode(void)
+{
+	/* setup cs5536 as high level trigger */
+	LOONGSON_INTPOL = LOONGSON_INT_BIT_INT0 | LOONGSON_INT_BIT_INT1;
+	LOONGSON_INTEDGE &= ~(LOONGSON_INT_BIT_INT0 | LOONGSON_INT_BIT_INT1);
+}
diff --git a/arch/mips/loongson/fuloong-2f/reset.c b/arch/mips/loongson/fuloong-2f/reset.c
new file mode 100644
index 0000000..0261c17
--- /dev/null
+++ b/arch/mips/loongson/fuloong-2f/reset.c
@@ -0,0 +1,65 @@
+/* Board-specific reboot/shutdown routines
+ *
+ * Copyright (c) 2009 Philippe Vachon <philippe@cowpig.ca>
+ *
+ * Copyright (C) 2009 Lemote Inc. & Insititute of Computing Technology
+ * Author: Wu Zhangjin, wuzj@lemote.com
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/types.h>
+
+#include <loongson.h>
+
+/* cs5536 is the south bridge used by fuloong2f mini PC */
+#include <cs5536/cs5536.h>
+
+void mach_prepare_reboot(void)
+{
+	/*
+	 * reset cpu to full speed, this is needed when enabling cpu frequency
+	 * scalling
+	 */
+	LOONGSON_CHIPCFG0 |= 0x7;
+
+	/* send a reset signal to south bridge.
+	 *
+	 * NOTE: if enable "Power Management" in kernel, rtl8169 will not reset
+	 * normally with this reset operation and it will not work in PMON, but
+	 * you can type halt command and then reboot, seems the hardware reset
+	 * logic not work normally.
+	 */
+	{
+		u32 hi, lo;
+		_rdmsr(DIVIL_MSR_REG(DIVIL_SOFT_RESET), &hi, &lo);
+		lo |= 0x00000001;
+		_wrmsr(DIVIL_MSR_REG(DIVIL_SOFT_RESET), hi, lo);
+	}
+}
+
+void mach_prepare_shutdown(void)
+{
+	u32 hi, lo, val;
+	phys_addr_t gpio_base;
+
+	_rdmsr(DIVIL_MSR_REG(DIVIL_LBAR_GPIO), &hi, &lo);
+
+	gpio_base = mips_io_port_base | (lo & 0xff00);
+
+	/* make cs5536 gpio13 output enable */
+	val = (readl((u32 *) (gpio_base + GPIOL_OUT_EN)) & ~(1 << (16 + 13)))
+	    | (1 << 13);
+	writel(val, (u32 *) (gpio_base + GPIOL_OUT_EN));
+	mmiowb();
+	/* make cs5536 gpio13 output low level voltage. */
+	val = (readl((u32 *) (gpio_base + GPIOL_OUT_VAL)) & ~(1 << (13)))
+	    | (1 << (16 + 13));
+	writel(val, (u32 *) (gpio_base + GPIOL_OUT_VAL));
+	mmiowb();
+}
diff --git a/arch/mips/pci/Makefile b/arch/mips/pci/Makefile
index a0cc238..b96ed14 100644
--- a/arch/mips/pci/Makefile
+++ b/arch/mips/pci/Makefile
@@ -26,7 +26,8 @@ obj-$(CONFIG_MIPS_COBALT)	+= fixup-cobalt.o
 obj-$(CONFIG_SOC_AU1500)	+= fixup-au1000.o ops-au1000.o
 obj-$(CONFIG_SOC_AU1550)	+= fixup-au1000.o ops-au1000.o
 obj-$(CONFIG_SOC_PNX8550)	+= fixup-pnx8550.o ops-pnx8550.o
-obj-$(CONFIG_LEMOTE_FULOONG2E)	+= fixup-fuloong2e.o ops-fuloong2e.o
+obj-$(CONFIG_LEMOTE_FULOONG2E)	+= fixup-fuloong2e.o ops-loongson2.o
+obj-$(CONFIG_LEMOTE_FULOONG2F)	+= fixup-fuloong2f.o ops-loongson2.o
 obj-$(CONFIG_MIPS_MALTA)	+= fixup-malta.o
 obj-$(CONFIG_PMC_MSP7120_GW)	+= fixup-pmcmsp.o ops-pmcmsp.o
 obj-$(CONFIG_PMC_MSP7120_EVAL)	+= fixup-pmcmsp.o ops-pmcmsp.o
diff --git a/arch/mips/pci/fixup-fuloong2f.c b/arch/mips/pci/fixup-fuloong2f.c
new file mode 100644
index 0000000..99fd2c8
--- /dev/null
+++ b/arch/mips/pci/fixup-fuloong2f.c
@@ -0,0 +1,171 @@
+/*
+ * Copyright (C) 2008 Lemote Technology
+ * Copyright (C) 2004 ICT CAS
+ * Author: Li xiaoyu, lixy@ict.ac.cn
+ *
+ * Copyright (C) 2007 Lemote, Inc. & Institute of Computing Technology
+ * Author: Fuxin Zhang, zhangfx@lemote.com
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+#include <linux/init.h>
+#include <linux/pci.h>
+
+#include <loongson.h>
+#include <cs5536/cs5536.h>
+#include <cs5536/cs5536_pci.h>
+
+/* PCI interrupt pins
+ *
+ * These should not be changed, or you should consider loongson2f interrupt
+ * register and your pci card dispatch
+ */
+
+#define PCIA		4
+#define PCIB		5
+#define PCIC		6
+#define PCID		7
+
+/* all the pci device has the PCIA pin, check the datasheet. */
+static char irq_tab[][5] __initdata = {
+	/*      INTA    INTB    INTC    INTD */
+	{0, 0, 0, 0, 0},	/*  11: Unused */
+	{0, 0, 0, 0, 0},	/*  12: Unused */
+	{0, 0, 0, 0, 0},	/*  13: Unused */
+	{0, 0, 0, 0, 0},	/*  14: Unused */
+	{0, 0, 0, 0, 0},	/*  15: Unused */
+	{0, 0, 0, 0, 0},	/*  16: Unused */
+	{0, PCIA, 0, 0, 0},	/*  17: RTL8110-0 */
+	{0, PCIB, 0, 0, 0},	/*  18: RTL8110-1 */
+	{0, PCIC, 0, 0, 0},	/*  19: SiI3114 */
+	{0, PCID, 0, 0, 0},	/*  20: 3-ports nec usb */
+	{0, PCIA, PCIB, PCIC, PCID},	/*  21: PCI-SLOT */
+	{0, 0, 0, 0, 0},	/*  22: Unused */
+	{0, 0, 0, 0, 0},	/*  23: Unused */
+	{0, 0, 0, 0, 0},	/*  24: Unused */
+	{0, 0, 0, 0, 0},	/*  25: Unused */
+	{0, 0, 0, 0, 0},	/*  26: Unused */
+	{0, 0, 0, 0, 0},	/*  27: Unused */
+};
+
+int __init pcibios_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+{
+	int virq;
+
+	if ((PCI_SLOT(dev->devfn) != PCI_IDSEL_CS5536)
+	    && (PCI_SLOT(dev->devfn) < 32)) {
+		virq = irq_tab[slot][pin];
+		printk(KERN_INFO "slot: %d, pin: %d, irq: %d\n", slot, pin,
+		       virq + LOONGSON_IRQ_BASE);
+		if (virq != 0)
+			return LOONGSON_IRQ_BASE + virq;
+		else
+			return 0;
+	} else if (PCI_SLOT(dev->devfn) == PCI_IDSEL_CS5536) {	/*  cs5536 */
+		switch (PCI_FUNC(dev->devfn)) {
+		case 2:
+			pci_write_config_byte(dev, PCI_INTERRUPT_LINE,
+					      CS5536_IDE_INTR);
+			return 14;	/*  for IDE */
+		case 3:
+			pci_write_config_byte(dev, PCI_INTERRUPT_LINE,
+					      CS5536_ACC_INTR);
+			return 9;	/*  for AUDIO */
+		case 4:	/*  for OHCI */
+		case 5:	/*  for EHCI */
+		case 6:	/*  for UDC */
+		case 7:	/*  for OTG */
+			pci_write_config_byte(dev, PCI_INTERRUPT_LINE,
+					      CS5536_USB_INTR);
+			return 11;
+		}
+		return dev->irq;
+	} else {
+		printk(KERN_INFO " strange pci slot number.\n");
+		return 0;
+	}
+}
+
+/* Do platform specific device initialization at pci_enable_device() time */
+int pcibios_plat_dev_init(struct pci_dev *dev)
+{
+	return 0;
+}
+
+/* CS5536 SPEC. fixup */
+static void __init loongson_cs5536_isa_fixup(struct pci_dev *pdev)
+{
+	/* the uart1 and uart2 interrupt in PIC is enabled as default */
+	pci_write_config_dword(pdev, PCI_UART1_INT_REG, 1);
+	pci_write_config_dword(pdev, PCI_UART2_INT_REG, 1);
+	return;
+}
+
+static void __init loongson_cs5536_ide_fixup(struct pci_dev *pdev)
+{
+	/* setting the mutex pin as IDE function */
+	pci_write_config_dword(pdev, PCI_IDE_CFG_REG,
+			       CS5536_IDE_FLASH_SIGNATURE);
+	return;
+}
+
+static void __init loongson_cs5536_acc_fixup(struct pci_dev *pdev)
+{
+	u8 val;
+
+	/* enable the AUDIO interrupt in PIC  */
+	pci_write_config_dword(pdev, PCI_ACC_INT_REG, 1);
+
+#if 1
+	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &val);
+	printk(KERN_INFO "cs5536 acc latency 0x%x\n", val);
+	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0xc0);
+#endif
+	return;
+}
+
+static void __init loongson_cs5536_ohci_fixup(struct pci_dev *pdev)
+{
+	/* enable the OHCI interrupt in PIC */
+	/* THE OHCI, EHCI, UDC, OTG are shared with interrupt in PIC */
+	pci_write_config_dword(pdev, PCI_OHCI_INT_REG, 1);
+	return;
+}
+
+static void __init loongson_cs5536_ehci_fixup(struct pci_dev *pdev)
+{
+	u32 hi, lo;
+
+	/* Serial short detect enable */
+	_rdmsr(USB_MSR_REG(USB_CONFIG), &hi, &lo);
+	_wrmsr(USB_MSR_REG(USB_CONFIG), (1 << 1) | (1 << 2) | (1 << 3), lo);
+
+	/* setting the USB2.0 micro frame length */
+	pci_write_config_dword(pdev, PCI_EHCI_FLADJ_REG, 0x2000);
+	return;
+}
+
+static void __init loongson_nec_fixup(struct pci_dev *pdev)
+{
+	unsigned int val;
+
+	pci_read_config_dword(pdev, 0xe0, &val);
+	/* Only 2 port be used */
+	pci_write_config_dword(pdev, 0xe0, (val & ~3) | 0x2);
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA,
+			 loongson_cs5536_isa_fixup);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_OHC,
+			 loongson_cs5536_ohci_fixup);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_EHC,
+			 loongson_cs5536_ehci_fixup);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_AUDIO,
+			 loongson_cs5536_acc_fixup);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_IDE,
+			 loongson_cs5536_ide_fixup);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NEC, PCI_DEVICE_ID_NEC_USB,
+			 loongson_nec_fixup);
diff --git a/arch/mips/pci/ops-fuloong2e.c b/arch/mips/pci/ops-fuloong2e.c
deleted file mode 100644
index 6bb7919..0000000
--- a/arch/mips/pci/ops-fuloong2e.c
+++ /dev/null
@@ -1,160 +0,0 @@
-/*
- * Copyright (C) 1999, 2000, 2004  MIPS Technologies, Inc.
- *	All rights reserved.
- *	Authors: Carsten Langgaard <carstenl@mips.com>
- *		 Maciej W. Rozycki <macro@mips.com>
- *
- *  This program is free software; you can distribute it and/or modify it
- *  under the terms of the GNU General Public License (Version 2) as
- *  published by the Free Software Foundation.
- *
- *  This program is distributed in the hope it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- *  for more details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * MIPS boards specific PCI support.
- */
-#include <linux/types.h>
-#include <linux/pci.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-
-#include <loongson.h>
-
-#define PCI_ACCESS_READ  0
-#define PCI_ACCESS_WRITE 1
-
-#define CFG_SPACE_REG(offset) \
-	(void *)CKSEG1ADDR(LOONGSON_PCICFG_BASE | (offset))
-#define ID_SEL_BEGIN 11
-#define MAX_DEV_NUM (31 - ID_SEL_BEGIN)
-
-
-static int loongson_pcibios_config_access(unsigned char access_type,
-				      struct pci_bus *bus,
-				      unsigned int devfn, int where,
-				      u32 *data)
-{
-	u32 busnum = bus->number;
-	u32 addr, type;
-	u32 dummy;
-	void *addrp;
-	int device = PCI_SLOT(devfn);
-	int function = PCI_FUNC(devfn);
-	int reg = where & ~3;
-
-	if (busnum == 0) {
-		/* Type 0 configuration for onboard PCI bus */
-		if (device > MAX_DEV_NUM)
-			return -1;
-
-		addr = (1 << (device + ID_SEL_BEGIN)) | (function << 8) | reg;
-		type = 0;
-	} else {
-		/* Type 1 configuration for offboard PCI bus */
-		addr = (busnum << 16) | (device << 11) | (function << 8) | reg;
-		type = 0x10000;
-	}
-
-	/* Clear aborts */
-	LOONGSON_PCICMD |= LOONGSON_PCICMD_MABORT_CLR | \
-				LOONGSON_PCICMD_MTABORT_CLR;
-
-	LOONGSON_PCIMAP_CFG = (addr >> 16) | type;
-
-	/* Flush Bonito register block */
-	dummy = LOONGSON_PCIMAP_CFG;
-	mmiowb();
-
-	addrp = CFG_SPACE_REG(addr & 0xffff);
-	if (access_type == PCI_ACCESS_WRITE)
-		writel(cpu_to_le32(*data), addrp);
-	else
-		*data = le32_to_cpu(readl(addrp));
-
-	/* Detect Master/Target abort */
-	if (LOONGSON_PCICMD & (LOONGSON_PCICMD_MABORT_CLR |
-			     LOONGSON_PCICMD_MTABORT_CLR)) {
-		/* Error occurred */
-
-		/* Clear bits */
-		LOONGSON_PCICMD |= (LOONGSON_PCICMD_MABORT_CLR |
-				  LOONGSON_PCICMD_MTABORT_CLR);
-
-		return -1;
-	}
-
-	return 0;
-
-}
-
-
-/*
- * We can't address 8 and 16 bit words directly.  Instead we have to
- * read/write a 32bit word and mask/modify the data we actually want.
- */
-static int loongson_pcibios_read(struct pci_bus *bus, unsigned int devfn,
-			     int where, int size, u32 *val)
-{
-	u32 data = 0;
-
-	if ((size == 2) && (where & 1))
-		return PCIBIOS_BAD_REGISTER_NUMBER;
-	else if ((size == 4) && (where & 3))
-		return PCIBIOS_BAD_REGISTER_NUMBER;
-
-	if (loongson_pcibios_config_access(PCI_ACCESS_READ, bus, devfn, where,
-				       &data))
-		return -1;
-
-	if (size == 1)
-		*val = (data >> ((where & 3) << 3)) & 0xff;
-	else if (size == 2)
-		*val = (data >> ((where & 3) << 3)) & 0xffff;
-	else
-		*val = data;
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static int loongson_pcibios_write(struct pci_bus *bus, unsigned int devfn,
-			      int where, int size, u32 val)
-{
-	u32 data = 0;
-
-	if ((size == 2) && (where & 1))
-		return PCIBIOS_BAD_REGISTER_NUMBER;
-	else if ((size == 4) && (where & 3))
-		return PCIBIOS_BAD_REGISTER_NUMBER;
-
-	if (size == 4)
-		data = val;
-	else {
-		if (loongson_pcibios_config_access(PCI_ACCESS_READ, bus, devfn,
-					where, &data))
-			return -1;
-
-		if (size == 1)
-			data = (data & ~(0xff << ((where & 3) << 3))) |
-				(val << ((where & 3) << 3));
-		else if (size == 2)
-			data = (data & ~(0xffff << ((where & 3) << 3))) |
-				(val << ((where & 3) << 3));
-	}
-
-	if (loongson_pcibios_config_access(PCI_ACCESS_WRITE, bus, devfn, where,
-				       &data))
-		return -1;
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
-struct pci_ops loongson_pci_ops = {
-	.read = loongson_pcibios_read,
-	.write = loongson_pcibios_write
-};
diff --git a/arch/mips/pci/ops-loongson2.c b/arch/mips/pci/ops-loongson2.c
new file mode 100644
index 0000000..08d705e
--- /dev/null
+++ b/arch/mips/pci/ops-loongson2.c
@@ -0,0 +1,213 @@
+/*
+ * Copyright (C) 1999, 2000, 2004  MIPS Technologies, Inc.
+ *	All rights reserved.
+ *	Authors: Carsten Langgaard <carstenl@mips.com>
+ *		 Maciej W. Rozycki <macro@mips.com>
+ *
+ *  This program is free software; you can distribute it and/or modify it
+ *  under the terms of the GNU General Public License (Version 2) as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope it will be useful, but WITHOUT
+ *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ *  for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
+ *
+ * MIPS boards specific PCI support.
+ */
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+
+#include <loongson.h>
+
+#ifdef CONFIG_CS5536
+#include <cs5536/cs5536_pci.h>
+#include <cs5536/cs5536.h>
+#endif
+
+#define PCI_ACCESS_READ  0
+#define PCI_ACCESS_WRITE 1
+
+#define CFG_SPACE_REG(offset) \
+	(void *)CKSEG1ADDR(LOONGSON_PCICFG_BASE | (offset))
+#define ID_SEL_BEGIN 11
+#define MAX_DEV_NUM (31 - ID_SEL_BEGIN)
+
+
+static int loongson_pcibios_config_access(unsigned char access_type,
+				      struct pci_bus *bus,
+				      unsigned int devfn, int where,
+				      u32 *data)
+{
+	u32 busnum = bus->number;
+	u32 addr, type;
+	u32 dummy;
+	void *addrp;
+	int device = PCI_SLOT(devfn);
+	int function = PCI_FUNC(devfn);
+	int reg = where & ~3;
+
+	if (busnum == 0) {
+		/* board-specific part,currently,only fuloong2f,yeeloong2f
+		 * use CS5536, fuloong2e use via686b, gdium has no
+		 * south bridge
+		 */
+#ifdef CONFIG_CS5536
+		/* cs5536_pci_conf_read4/write4() will call _rdmsr/_wrmsr()
+		 * to access the regsters 0xf4,0xf8,0xfc, which is bigger than
+		 * 0xf0, so, it will not go this branch, but the others. so,
+		 * no calling dead loop here.
+		 */
+		if ((PCI_IDSEL_CS5536 == device) && (reg < 0xF0)) {
+			switch (access_type) {
+			case PCI_ACCESS_READ:
+				*data = cs5536_pci_conf_read4(function, reg);
+				break;
+			case PCI_ACCESS_WRITE:
+				cs5536_pci_conf_write4(function, reg, *data);
+				break;
+			}
+			return 0;
+		}
+#endif
+		/* Type 0 configuration for onboard PCI bus */
+		if (device > MAX_DEV_NUM)
+			return -1;
+
+		addr = (1 << (device + ID_SEL_BEGIN)) | (function << 8) | reg;
+		type = 0;
+	} else {
+		/* Type 1 configuration for offboard PCI bus */
+		addr = (busnum << 16) | (device << 11) | (function << 8) | reg;
+		type = 0x10000;
+	}
+
+	/* Clear aborts */
+	LOONGSON_PCICMD |= LOONGSON_PCICMD_MABORT_CLR | \
+				LOONGSON_PCICMD_MTABORT_CLR;
+
+	LOONGSON_PCIMAP_CFG = (addr >> 16) | type;
+
+	/* Flush Bonito register block */
+	dummy = LOONGSON_PCIMAP_CFG;
+	mmiowb();
+
+	addrp = CFG_SPACE_REG(addr & 0xffff);
+	if (access_type == PCI_ACCESS_WRITE)
+		writel(cpu_to_le32(*data), addrp);
+	else
+		*data = le32_to_cpu(readl(addrp));
+
+	/* Detect Master/Target abort */
+	if (LOONGSON_PCICMD & (LOONGSON_PCICMD_MABORT_CLR |
+			     LOONGSON_PCICMD_MTABORT_CLR)) {
+		/* Error occurred */
+
+		/* Clear bits */
+		LOONGSON_PCICMD |= (LOONGSON_PCICMD_MABORT_CLR |
+				  LOONGSON_PCICMD_MTABORT_CLR);
+
+		return -1;
+	}
+
+	return 0;
+
+}
+
+
+/*
+ * We can't address 8 and 16 bit words directly.  Instead we have to
+ * read/write a 32bit word and mask/modify the data we actually want.
+ */
+static int loongson_pcibios_read(struct pci_bus *bus, unsigned int devfn,
+			     int where, int size, u32 *val)
+{
+	u32 data = 0;
+
+	if ((size == 2) && (where & 1))
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+	else if ((size == 4) && (where & 3))
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+
+	if (loongson_pcibios_config_access(PCI_ACCESS_READ, bus, devfn, where,
+				       &data))
+		return -1;
+
+	if (size == 1)
+		*val = (data >> ((where & 3) << 3)) & 0xff;
+	else if (size == 2)
+		*val = (data >> ((where & 3) << 3)) & 0xffff;
+	else
+		*val = data;
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int loongson_pcibios_write(struct pci_bus *bus, unsigned int devfn,
+			      int where, int size, u32 val)
+{
+	u32 data = 0;
+
+	if ((size == 2) && (where & 1))
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+	else if ((size == 4) && (where & 3))
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+
+	if (size == 4)
+		data = val;
+	else {
+		if (loongson_pcibios_config_access(PCI_ACCESS_READ, bus, devfn,
+					where, &data))
+			return -1;
+
+		if (size == 1)
+			data = (data & ~(0xff << ((where & 3) << 3))) |
+				(val << ((where & 3) << 3));
+		else if (size == 2)
+			data = (data & ~(0xffff << ((where & 3) << 3))) |
+				(val << ((where & 3) << 3));
+	}
+
+	if (loongson_pcibios_config_access(PCI_ACCESS_WRITE, bus, devfn, where,
+				       &data))
+		return -1;
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+struct pci_ops loongson_pci_ops = {
+	.read = loongson_pcibios_read,
+	.write = loongson_pcibios_write
+};
+
+#ifdef CONFIG_CS5536
+void _rdmsr(u32 msr, u32 *hi, u32 *lo)
+{
+	struct pci_bus bus = {
+		.number = PCI_BUS_CS5536
+	};
+	u32 devfn = PCI_DEVFN(PCI_IDSEL_CS5536, 0);
+	loongson_pcibios_write(&bus, devfn, PCI_MSR_ADDR, 4, msr);
+	loongson_pcibios_read(&bus, devfn, PCI_MSR_DATA_LO, 4, lo);
+	loongson_pcibios_read(&bus, devfn, PCI_MSR_DATA_HI, 4, hi);
+}
+EXPORT_SYMBOL(_rdmsr);
+
+void _wrmsr(u32 msr, u32 hi, u32 lo)
+{
+	struct pci_bus bus = {
+		.number = PCI_BUS_CS5536
+	};
+	u32 devfn = PCI_DEVFN(PCI_IDSEL_CS5536, 0);
+	loongson_pcibios_write(&bus, devfn, PCI_MSR_ADDR, 4, msr);
+	loongson_pcibios_write(&bus, devfn, PCI_MSR_DATA_LO, 4, lo);
+	loongson_pcibios_write(&bus, devfn, PCI_MSR_DATA_HI, 4, hi);
+}
+EXPORT_SYMBOL(_wrmsr);
+#endif
-- 
1.6.2.1

