Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbYGDXW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbYGDXW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 19:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYGDXWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 19:22:18 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:47016 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYGDXWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 19:22:17 -0400
Date: Sat, 5 Jul 2008 01:22:12 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Michael Chan <mchan@broadcom.com>, linux-kernel@vger.kernel.org
Subject: [RESEND] [PATCH] bnx2 - use request_firmware()
Message-ID: <20080704232212.GA2636@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Michael Chan <mchan@broadcom.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David

This patch is used by Debian since 2.6.25 to use request_firmware in the
bnx2 driver. It lacks a small piece of inline patching for now.

The firmware files includes 7 firmwares with up to 3 sections plus some
additional initialisation data. The corresponding firmware file
generator is located at
svn://svn.debian.org/kernel/dists/trunk/firmware-nonfree/bnx2/fwcutter.

Signed-off-by: Bastian Blank <waldi@debian.org>

Bastian

 drivers/net/Kconfig        |    1 +
 drivers/net/bnx2.c         |  256 ++++++++++++++++++++++----------------------
 drivers/net/bnx2.h         |   40 +-------
 drivers/net/bnx2_fw_file.h |   25 +++++
 4 files changed, 156 insertions(+), 166 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index f4182cf..0686d45 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2236,6 +2236,7 @@ config TIGON3
 
 config BNX2
 	tristate "Broadcom NetXtremeII support"
+	select FW_LOADER
 	depends on PCI
 	select CRC32
 	select ZLIB_INFLATE
diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
index 367b6d4..a77205f 100644
--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -46,11 +46,10 @@
 #include <linux/crc32.h>
 #include <linux/prefetch.h>
 #include <linux/cache.h>
-#include <linux/zlib.h>
+#include <linux/firmware.h>
 
 #include "bnx2.h"
-#include "bnx2_fw.h"
-#include "bnx2_fw2.h"
+#include "bnx2_fw_file.h"
 
 #define FW_BUF_SIZE		0x10000
 
@@ -58,12 +57,20 @@
 #define PFX DRV_MODULE_NAME	": "
 #define DRV_MODULE_VERSION	"1.7.5"
 #define DRV_MODULE_RELDATE	"April 29, 2008"
+#define FW_FILE_06		"bnx2-06-4.0.5.fw"
+#define FW_FILE_09		"bnx2-09-4.0.5.fw"
 
 #define RUN_AT(x) (jiffies + (x))
 
 /* Time in jiffies before concluding the transmitter is hung. */
 #define TX_TIMEOUT  (5*HZ)
 
+#ifdef DEBUG
+#  define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __FUNCTION__ , ## args)
+#else
+#  define DPRINTK(fmt, args...)
+#endif
+
 static char version[] __devinitdata =
 	"Broadcom NetXtreme II Gigabit Ethernet Driver " DRV_MODULE_NAME " v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
 
@@ -71,6 +78,8 @@ MODULE_AUTHOR("Michael Chan <mchan@broadcom.com>");
 MODULE_DESCRIPTION("Broadcom NetXtreme II BCM5706/5708 Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
+MODULE_FIRMWARE(FW_FILE_06);
+MODULE_FIRMWARE(FW_FILE_09);
 
 static int disable_msi = 0;
 
@@ -3173,32 +3182,32 @@ bnx2_set_rx_mode(struct net_device *dev)
 	spin_unlock_bh(&bp->phy_lock);
 }
 
-static void
-load_rv2p_fw(struct bnx2 *bp, __le32 *rv2p_code, u32 rv2p_code_len,
-	u32 rv2p_proc)
+static int
+load_rv2p_fw(struct bnx2 *bp, u32 rv2p_proc, const struct bnx2_fw_file_section *fw_section)
 {
-	int i;
+	int i, len, offset;
+	u32 *data;
 	u32 val;
 
-	if (rv2p_proc == RV2P_PROC2 && CHIP_NUM(bp) == CHIP_NUM_5709) {
-		val = le32_to_cpu(rv2p_code[XI_RV2P_PROC2_MAX_BD_PAGE_LOC]);
-		val &= ~XI_RV2P_PROC2_BD_PAGE_SIZE_MSK;
-		val |= XI_RV2P_PROC2_BD_PAGE_SIZE;
-		rv2p_code[XI_RV2P_PROC2_MAX_BD_PAGE_LOC] = cpu_to_le32(val);
-	}
+	len = be32_to_cpu(fw_section->len);
+	offset = be32_to_cpu(fw_section->offset);
+
+	if (!len || !offset || len + offset > bp->firmware->size)
+		return -EINVAL;
+	DPRINTK("load rv2p firmware with length %u from file offset %u\n", len, offset);
 
-	for (i = 0; i < rv2p_code_len; i += 8) {
-		REG_WR(bp, BNX2_RV2P_INSTR_HIGH, le32_to_cpu(*rv2p_code));
-		rv2p_code++;
-		REG_WR(bp, BNX2_RV2P_INSTR_LOW, le32_to_cpu(*rv2p_code));
-		rv2p_code++;
+	data = (u32 *)(bp->firmware->data + offset);
+
+	for (i = 0; i < (len / 4); i += 2) {
+		REG_WR(bp, BNX2_RV2P_INSTR_HIGH, be32_to_cpu(data[i]));
+		REG_WR(bp, BNX2_RV2P_INSTR_LOW, be32_to_cpu(data[i+1]));
 
 		if (rv2p_proc == RV2P_PROC1) {
-			val = (i / 8) | BNX2_RV2P_PROC1_ADDR_CMD_RDWR;
+			val = (i / 2) | BNX2_RV2P_PROC1_ADDR_CMD_RDWR;
 			REG_WR(bp, BNX2_RV2P_PROC1_ADDR_CMD, val);
 		}
 		else {
-			val = (i / 8) | BNX2_RV2P_PROC2_ADDR_CMD_RDWR;
+			val = (i / 2) | BNX2_RV2P_PROC2_ADDR_CMD_RDWR;
 			REG_WR(bp, BNX2_RV2P_PROC2_ADDR_CMD, val);
 		}
 	}
@@ -3210,14 +3219,18 @@ load_rv2p_fw(struct bnx2 *bp, __le32 *rv2p_code, u32 rv2p_code_len,
 	else {
 		REG_WR(bp, BNX2_RV2P_COMMAND, BNX2_RV2P_COMMAND_PROC2_RESET);
 	}
+
+	return 0;
 }
 
 static int
-load_cpu_fw(struct bnx2 *bp, struct cpu_reg *cpu_reg, struct fw_info *fw)
+load_cpu_fw(struct bnx2 *bp, struct cpu_reg *cpu_reg,
+	    const struct bnx2_fw_file_entry *fw_entry)
 {
+	u32 addr, len, file_offset;
 	u32 offset;
 	u32 val;
-	int rc;
+	u32 *data;
 
 	/* Halt the CPU. */
 	val = bnx2_reg_rd_ind(bp, cpu_reg->mode);
@@ -3226,64 +3239,87 @@ load_cpu_fw(struct bnx2 *bp, struct cpu_reg *cpu_reg, struct fw_info *fw)
 	bnx2_reg_wr_ind(bp, cpu_reg->state, cpu_reg->state_value_clear);
 
 	/* Load the Text area. */
-	offset = cpu_reg->spad_base + (fw->text_addr - cpu_reg->mips_view_base);
-	if (fw->gz_text) {
+	addr = be32_to_cpu(fw_entry->text.addr);
+	len = be32_to_cpu(fw_entry->text.len);
+	file_offset = be32_to_cpu(fw_entry->text.offset);
+	data = (u32 *)(bp->firmware->data + file_offset);
+	DPRINTK("load text section to %x with length %u from file offset %x\n", addr, len, file_offset);
+
+	offset = cpu_reg->spad_base + (addr - cpu_reg->mips_view_base);
+	if (len) {
 		int j;
 
-		rc = zlib_inflate_blob(fw->text, FW_BUF_SIZE, fw->gz_text,
-				       fw->gz_text_len);
-		if (rc < 0)
-			return rc;
-
-		for (j = 0; j < (fw->text_len / 4); j++, offset += 4) {
-			bnx2_reg_wr_ind(bp, offset, le32_to_cpu(fw->text[j]));
+		for (j = 0; j < (len / 4); j++, offset += 4) {
+			bnx2_reg_wr_ind(bp, offset, be32_to_cpu(data[j]));
 	        }
 	}
 
 	/* Load the Data area. */
-	offset = cpu_reg->spad_base + (fw->data_addr - cpu_reg->mips_view_base);
-	if (fw->data) {
+	addr = be32_to_cpu(fw_entry->data.addr);
+	len = be32_to_cpu(fw_entry->data.len);
+	file_offset = be32_to_cpu(fw_entry->data.offset);
+	data = (u32 *)(bp->firmware->data + file_offset);
+	DPRINTK("load data section to %x with length %u from file offset %x\n", addr, len, file_offset);
+
+	offset = cpu_reg->spad_base + (addr - cpu_reg->mips_view_base);
+	if (len) {
 		int j;
 
-		for (j = 0; j < (fw->data_len / 4); j++, offset += 4) {
-			bnx2_reg_wr_ind(bp, offset, fw->data[j]);
+		for (j = 0; j < (len / 4); j++, offset += 4) {
+			bnx2_reg_wr_ind(bp, offset, be32_to_cpu(data[j]));
 		}
 	}
 
 	/* Load the SBSS area. */
-	offset = cpu_reg->spad_base + (fw->sbss_addr - cpu_reg->mips_view_base);
-	if (fw->sbss_len) {
+	addr = be32_to_cpu(fw_entry->sbss.addr);
+	len = be32_to_cpu(fw_entry->sbss.len);
+	DPRINTK("init sbss section on %x with length %u\n", addr, len);
+
+	offset = cpu_reg->spad_base + (addr - cpu_reg->mips_view_base);
+	if (len) {
 		int j;
 
-		for (j = 0; j < (fw->sbss_len / 4); j++, offset += 4) {
+		for (j = 0; j < (len / 4); j++, offset += 4) {
 			bnx2_reg_wr_ind(bp, offset, 0);
 		}
 	}
 
 	/* Load the BSS area. */
-	offset = cpu_reg->spad_base + (fw->bss_addr - cpu_reg->mips_view_base);
-	if (fw->bss_len) {
+	addr = be32_to_cpu(fw_entry->bss.addr);
+	len = be32_to_cpu(fw_entry->bss.len);
+	DPRINTK("init bss section on %x with length %u\n", addr, len);
+
+	offset = cpu_reg->spad_base + (addr - cpu_reg->mips_view_base);
+	if (len) {
 		int j;
 
-		for (j = 0; j < (fw->bss_len/4); j++, offset += 4) {
+		for (j = 0; j < (len / 4); j++, offset += 4) {
 			bnx2_reg_wr_ind(bp, offset, 0);
 		}
 	}
 
 	/* Load the Read-Only area. */
-	offset = cpu_reg->spad_base +
-		(fw->rodata_addr - cpu_reg->mips_view_base);
-	if (fw->rodata) {
+	addr = be32_to_cpu(fw_entry->rodata.addr);
+	len = be32_to_cpu(fw_entry->rodata.len);
+	file_offset = be32_to_cpu(fw_entry->rodata.offset);
+	data = (u32 *)(bp->firmware->data + file_offset);
+	DPRINTK("load rodata section to %x with length %u from file offset %x\n", addr, len, file_offset);
+
+	offset = cpu_reg->spad_base + (addr - cpu_reg->mips_view_base);
+	if (len) {
 		int j;
 
-		for (j = 0; j < (fw->rodata_len / 4); j++, offset += 4) {
-			bnx2_reg_wr_ind(bp, offset, fw->rodata[j]);
+		for (j = 0; j < (len / 4); j++, offset += 4) {
+			bnx2_reg_wr_ind(bp, offset, be32_to_cpu(data[j]));
 		}
 	}
 
 	/* Clear the pre-fetch instruction. */
 	bnx2_reg_wr_ind(bp, cpu_reg->inst, 0);
-	bnx2_reg_wr_ind(bp, cpu_reg->pc, fw->start_addr);
+
+	val = be32_to_cpu(fw_entry->start_addr);
+	DPRINTK("starting cpu on %x\n", val);
+	bnx2_reg_wr_ind(bp, cpu_reg->pc, val);
 
 	/* Start the CPU. */
 	val = bnx2_reg_rd_ind(bp, cpu_reg->mode);
@@ -3298,39 +3334,14 @@ static int
 bnx2_init_cpus(struct bnx2 *bp)
 {
 	struct cpu_reg cpu_reg;
-	struct fw_info *fw;
-	int rc, rv2p_len;
-	void *text, *rv2p;
-
-	/* Initialize the RV2P processor. */
-	text = vmalloc(FW_BUF_SIZE);
-	if (!text)
-		return -ENOMEM;
-	if (CHIP_NUM(bp) == CHIP_NUM_5709) {
-		rv2p = bnx2_xi_rv2p_proc1;
-		rv2p_len = sizeof(bnx2_xi_rv2p_proc1);
-	} else {
-		rv2p = bnx2_rv2p_proc1;
-		rv2p_len = sizeof(bnx2_rv2p_proc1);
-	}
-	rc = zlib_inflate_blob(text, FW_BUF_SIZE, rv2p, rv2p_len);
-	if (rc < 0)
-		goto init_cpu_err;
+	const struct bnx2_fw_file *fw = NULL;
+	int rc;
 
-	load_rv2p_fw(bp, text, rc /* == len */, RV2P_PROC1);
+	fw = (struct bnx2_fw_file *)bp->firmware->data;
 
-	if (CHIP_NUM(bp) == CHIP_NUM_5709) {
-		rv2p = bnx2_xi_rv2p_proc2;
-		rv2p_len = sizeof(bnx2_xi_rv2p_proc2);
-	} else {
-		rv2p = bnx2_rv2p_proc2;
-		rv2p_len = sizeof(bnx2_rv2p_proc2);
-	}
-	rc = zlib_inflate_blob(text, FW_BUF_SIZE, rv2p, rv2p_len);
-	if (rc < 0)
-		goto init_cpu_err;
-
-	load_rv2p_fw(bp, text, rc /* == len */, RV2P_PROC2);
+	/* Initialize the RV2P processor. */
+	load_rv2p_fw(bp, RV2P_PROC1, &fw->rv2p_proc1);
+	load_rv2p_fw(bp, RV2P_PROC2, &fw->rv2p_proc2);
 
 	/* Initialize the RX Processor. */
 	cpu_reg.mode = BNX2_RXP_CPU_MODE;
@@ -3346,15 +3357,9 @@ bnx2_init_cpus(struct bnx2 *bp)
 	cpu_reg.spad_base = BNX2_RXP_SCRATCH;
 	cpu_reg.mips_view_base = 0x8000000;
 
-	if (CHIP_NUM(bp) == CHIP_NUM_5709)
-		fw = &bnx2_rxp_fw_09;
-	else
-		fw = &bnx2_rxp_fw_06;
-
-	fw->text = text;
-	rc = load_cpu_fw(bp, &cpu_reg, fw);
+	rc = load_cpu_fw(bp, &cpu_reg, &fw->rxp);
 	if (rc)
-		goto init_cpu_err;
+		return rc;
 
 	/* Initialize the TX Processor. */
 	cpu_reg.mode = BNX2_TXP_CPU_MODE;
@@ -3370,15 +3375,9 @@ bnx2_init_cpus(struct bnx2 *bp)
 	cpu_reg.spad_base = BNX2_TXP_SCRATCH;
 	cpu_reg.mips_view_base = 0x8000000;
 
-	if (CHIP_NUM(bp) == CHIP_NUM_5709)
-		fw = &bnx2_txp_fw_09;
-	else
-		fw = &bnx2_txp_fw_06;
-
-	fw->text = text;
-	rc = load_cpu_fw(bp, &cpu_reg, fw);
+	rc = load_cpu_fw(bp, &cpu_reg, &fw->txp);
 	if (rc)
-		goto init_cpu_err;
+		return rc;
 
 	/* Initialize the TX Patch-up Processor. */
 	cpu_reg.mode = BNX2_TPAT_CPU_MODE;
@@ -3394,15 +3393,9 @@ bnx2_init_cpus(struct bnx2 *bp)
 	cpu_reg.spad_base = BNX2_TPAT_SCRATCH;
 	cpu_reg.mips_view_base = 0x8000000;
 
-	if (CHIP_NUM(bp) == CHIP_NUM_5709)
-		fw = &bnx2_tpat_fw_09;
-	else
-		fw = &bnx2_tpat_fw_06;
-
-	fw->text = text;
-	rc = load_cpu_fw(bp, &cpu_reg, fw);
+	rc = load_cpu_fw(bp, &cpu_reg, &fw->tpat);
 	if (rc)
-		goto init_cpu_err;
+		return rc;
 
 	/* Initialize the Completion Processor. */
 	cpu_reg.mode = BNX2_COM_CPU_MODE;
@@ -3418,15 +3411,9 @@ bnx2_init_cpus(struct bnx2 *bp)
 	cpu_reg.spad_base = BNX2_COM_SCRATCH;
 	cpu_reg.mips_view_base = 0x8000000;
 
-	if (CHIP_NUM(bp) == CHIP_NUM_5709)
-		fw = &bnx2_com_fw_09;
-	else
-		fw = &bnx2_com_fw_06;
-
-	fw->text = text;
-	rc = load_cpu_fw(bp, &cpu_reg, fw);
+	rc = load_cpu_fw(bp, &cpu_reg, &fw->com);
 	if (rc)
-		goto init_cpu_err;
+		return rc;
 
 	/* Initialize the Command Processor. */
 	cpu_reg.mode = BNX2_CP_CPU_MODE;
@@ -3442,17 +3429,7 @@ bnx2_init_cpus(struct bnx2 *bp)
 	cpu_reg.spad_base = BNX2_CP_SCRATCH;
 	cpu_reg.mips_view_base = 0x8000000;
 
-	if (CHIP_NUM(bp) == CHIP_NUM_5709)
-		fw = &bnx2_cp_fw_09;
-	else
-		fw = &bnx2_cp_fw_06;
-
-	fw->text = text;
-	rc = load_cpu_fw(bp, &cpu_reg, fw);
-
-init_cpu_err:
-	vfree(text);
-	return rc;
+	return load_cpu_fw(bp, &cpu_reg, &fw->cp);
 }
 
 static int
@@ -7470,6 +7447,7 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct bnx2 *bp;
 	int rc;
 	char str[40];
+	const char *fw_file;
 	DECLARE_MAC_BUF(mac);
 
 	if (version_printed++ == 0)
@@ -7511,6 +7489,23 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_drvdata(pdev, dev);
 
+	if (CHIP_NUM(bp) == CHIP_NUM_5709)
+		fw_file = FW_FILE_09;
+	else
+		fw_file = FW_FILE_06;
+
+	rc = request_firmware(&bp->firmware, fw_file, &pdev->dev);
+	if (rc) {
+		printk(KERN_ERR PFX "Can't load firmware file %s\n", fw_file);
+		goto error;
+	}
+
+	if (bp->firmware->size < sizeof(struct bnx2_fw_file)) {
+		printk(KERN_ERR PFX "Firmware file too small\n");
+		rc = -EINVAL;
+		goto error;
+	}
+
 	memcpy(dev->dev_addr, bp->mac_addr, 6);
 	memcpy(dev->perm_addr, bp->mac_addr, 6);
 	bp->name = board_info[ent->driver_data].name;
@@ -7528,13 +7523,7 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if ((rc = register_netdev(dev))) {
 		dev_err(&pdev->dev, "Cannot register net device\n");
-		if (bp->regview)
-			iounmap(bp->regview);
-		pci_release_regions(pdev);
-		pci_disable_device(pdev);
-		pci_set_drvdata(pdev, NULL);
-		free_netdev(dev);
-		return rc;
+		goto error;
 	}
 
 	printk(KERN_INFO "%s: %s (%c%d) %s found at mem %lx, "
@@ -7548,6 +7537,15 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		bp->pdev->irq, print_mac(mac, dev->dev_addr));
 
 	return 0;
+
+error:
+	if (bp->regview)
+		iounmap(bp->regview);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+	free_netdev(dev);
+	return rc;
 }
 
 static void __devexit
@@ -7563,6 +7561,8 @@ bnx2_remove_one(struct pci_dev *pdev)
 	if (bp->regview)
 		iounmap(bp->regview);
 
+	release_firmware(bp->firmware);
+
 	free_netdev(dev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
diff --git a/drivers/net/bnx2.h b/drivers/net/bnx2.h
index 2377cc1..ec74554 100644
--- a/drivers/net/bnx2.h
+++ b/drivers/net/bnx2.h
@@ -6812,6 +6812,8 @@ struct bnx2 {
 
 	struct bnx2_irq		irq_tbl[BNX2_MAX_MSIX_VEC];
 	int			irq_nvecs;
+
+	const struct firmware	*firmware;
 };
 
 #define REG_RD(bp, offset)					\
@@ -6842,44 +6844,6 @@ struct cpu_reg {
 	u32 mips_view_base;
 };
 
-struct fw_info {
-	const u32 ver_major;
-	const u32 ver_minor;
-	const u32 ver_fix;
-
-	const u32 start_addr;
-
-	/* Text section. */
-	const u32 text_addr;
-	const u32 text_len;
-	const u32 text_index;
-	__le32 *text;
-	u8 *gz_text;
-	const u32 gz_text_len;
-
-	/* Data section. */
-	const u32 data_addr;
-	const u32 data_len;
-	const u32 data_index;
-	const u32 *data;
-
-	/* SBSS section. */
-	const u32 sbss_addr;
-	const u32 sbss_len;
-	const u32 sbss_index;
-
-	/* BSS section. */
-	const u32 bss_addr;
-	const u32 bss_len;
-	const u32 bss_index;
-
-	/* Read-only section. */
-	const u32 rodata_addr;
-	const u32 rodata_len;
-	const u32 rodata_index;
-	const u32 *rodata;
-};
-
 #define RV2P_PROC1                              0
 #define RV2P_PROC2                              1
 
diff --git a/drivers/net/bnx2_fw_file.h b/drivers/net/bnx2_fw_file.h
new file mode 100644
index 0000000..06c003c
--- /dev/null
+++ b/drivers/net/bnx2_fw_file.h
@@ -0,0 +1,25 @@
+struct bnx2_fw_file_section {
+  uint32_t addr;
+  uint32_t len;
+  uint32_t offset;
+};
+
+struct bnx2_fw_file_entry {
+  uint32_t start_addr;
+  struct bnx2_fw_file_section text;
+  struct bnx2_fw_file_section data;
+  struct bnx2_fw_file_section sbss;
+  struct bnx2_fw_file_section bss;
+  struct bnx2_fw_file_section rodata;
+};
+
+struct bnx2_fw_file {
+  struct bnx2_fw_file_entry com;
+  struct bnx2_fw_file_entry cp;
+  struct bnx2_fw_file_entry rxp;
+  struct bnx2_fw_file_entry tpat;
+  struct bnx2_fw_file_entry txp;
+  struct bnx2_fw_file_section rv2p_proc1;
+  struct bnx2_fw_file_section rv2p_proc2;
+};
+
-- 
Extreme feminine beauty is always disturbing.
		-- Spock, "The Cloud Minders", stardate 5818.4
