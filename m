Return-Path: <linux-kernel-owner+w=401wt.eu-S932969AbZLRXBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbZLRXBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 18:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZLRXAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 18:00:45 -0500
Received: from kroah.org ([198.145.64.141]:38542 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933301AbZLRXAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 18:00:14 -0500
Date: Fri, 18 Dec 2009 14:58:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.42
Message-ID: <20091218225850.GB19026@kroah.com>
References: <20091218225835.GA19026@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218225835.GA19026@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 12952ec..552618b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .41
+EXTRAVERSION = .42
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/ia64/lib/ip_fast_csum.S b/arch/ia64/lib/ip_fast_csum.S
index 1f86aeb..620d9dc 100644
--- a/arch/ia64/lib/ip_fast_csum.S
+++ b/arch/ia64/lib/ip_fast_csum.S
@@ -96,20 +96,22 @@ END(ip_fast_csum)
 GLOBAL_ENTRY(csum_ipv6_magic)
 	ld4	r20=[in0],4
 	ld4	r21=[in1],4
-	dep	r15=in3,in2,32,16
+	zxt4	in2=in2
 	;;
 	ld4	r22=[in0],4
 	ld4	r23=[in1],4
-	mux1	r15=r15,@rev
+	dep	r15=in3,in2,32,16
 	;;
 	ld4	r24=[in0],4
 	ld4	r25=[in1],4
-	shr.u	r15=r15,16
+	mux1	r15=r15,@rev
 	add	r16=r20,r21
 	add	r17=r22,r23
+	zxt4	in4=in4
 	;;
 	ld4	r26=[in0],4
 	ld4	r27=[in1],4
+	shr.u	r15=r15,16
 	add	r18=r24,r25
 	add	r8=r16,r17
 	;;
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 05cc22d..39040af 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -646,7 +646,7 @@ static void probe_nmi_watchdog(void)
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
 		if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15 &&
-		    boot_cpu_data.x86 != 16)
+		    boot_cpu_data.x86 != 16 && boot_cpu_data.x86 != 17)
 			return;
 		wd_ops = &k7_wd_ops;
 		break;
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index dcdac6c..34bc987 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -377,13 +377,15 @@ static inline struct iommu_table *find_iommu_table(struct device *dev)
 
 	pdev = to_pci_dev(dev);
 
+	/* search up the device tree for an iommu */
 	pbus = pdev->bus;
-
-	/* is the device behind a bridge? Look for the root bus */
-	while (pbus->parent)
+	do {
+		tbl = pci_iommu(pbus);
+		if (tbl && tbl->it_busno == pbus->number)
+			break;
+		tbl = NULL;
 		pbus = pbus->parent;
-
-	tbl = pci_iommu(pbus);
+	} while (pbus);
 
 	BUG_ON(tbl && (tbl->it_busno != pbus->number));
 
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 87d4d69..4b85cba 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -175,7 +175,7 @@ static __init int iommu_setup(char *p)
 		if (!strncmp(p, "allowdac", 8))
 			forbid_dac = 0;
 		if (!strncmp(p, "nodac", 5))
-			forbid_dac = -1;
+			forbid_dac = 1;
 		if (!strncmp(p, "usedac", 6)) {
 			forbid_dac = -1;
 			return 1;
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index eed133e..625ead6 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -865,7 +865,7 @@ void __init gart_parse_options(char *p)
 #endif
 	if (isdigit(*p) && get_option(&p, &arg))
 		iommu_size = arg;
-	if (!strncmp(p, "fullflush", 8))
+	if (!strncmp(p, "fullflush", 9))
 		iommu_fullflush = 1;
 	if (!strncmp(p, "nofullflush", 11))
 		iommu_fullflush = 0;
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 1177f10..f2e02b7 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -219,6 +219,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Dell XPS710"),
 		},
 	},
+	{       /* Handle problems with rebooting on ASUS P4S800 */
+		.callback = set_bios_reboot,
+		.ident = "ASUS P4S800",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "P4S800"),
+		},
+	},
 	{ }
 };
 
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 233a5fd..2496c2b 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -24,7 +24,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.12"
+#define DRV_VERSION	"0.6.14"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -404,9 +404,8 @@ static void hpt370_set_piomode(struct ata_port *ap, struct ata_device *adev)
 
 	pci_read_config_dword(pdev, addr1, &reg);
 	mode = hpt37x_find_mode(ap, adev->pio_mode);
-	mode &= ~0x8000000;	/* No FIFO in PIO */
-	mode &= ~0x30070000;	/* Leave config bits alone */
-	reg &= 0x30070000;	/* Strip timing bits */
+	mode &= 0xCFC3FFFF;	/* Leave DMA bits alone */
+	reg &= ~0xCFC3FFFF;	/* Strip timing bits */
 	pci_write_config_dword(pdev, addr1, reg | mode);
 }
 
@@ -423,8 +422,7 @@ static void hpt370_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 addr1, addr2;
-	u32 reg;
-	u32 mode;
+	u32 reg, mode, mask;
 	u8 fast;
 
 	addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
@@ -436,11 +434,12 @@ static void hpt370_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	fast |= 0x01;
 	pci_write_config_byte(pdev, addr2, fast);
 
+	mask = adev->dma_mode < XFER_UDMA_0 ? 0x31C001FF : 0x303C0000;
+
 	pci_read_config_dword(pdev, addr1, &reg);
 	mode = hpt37x_find_mode(ap, adev->dma_mode);
-	mode |= 0x8000000;	/* FIFO in MWDMA or UDMA */
-	mode &= ~0xC0000000;	/* Leave config bits alone */
-	reg &= 0xC0000000;	/* Strip timing bits */
+	mode &= mask;
+	reg &= ~mask;
 	pci_write_config_dword(pdev, addr1, reg | mode);
 }
 
@@ -508,9 +507,8 @@ static void hpt372_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	mode = hpt37x_find_mode(ap, adev->pio_mode);
 
 	printk("Find mode for %d reports %X\n", adev->pio_mode, mode);
-	mode &= ~0x80000000;	/* No FIFO in PIO */
-	mode &= ~0x30070000;	/* Leave config bits alone */
-	reg &= 0x30070000;	/* Strip timing bits */
+	mode &= 0xCFC3FFFF;	/* Leave DMA bits alone */
+	reg &= ~0xCFC3FFFF;	/* Strip timing bits */
 	pci_write_config_dword(pdev, addr1, reg | mode);
 }
 
@@ -527,8 +525,7 @@ static void hpt372_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 addr1, addr2;
-	u32 reg;
-	u32 mode;
+	u32 reg, mode, mask;
 	u8 fast;
 
 	addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
@@ -539,12 +536,13 @@ static void hpt372_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	fast &= ~0x07;
 	pci_write_config_byte(pdev, addr2, fast);
 
+	mask = adev->dma_mode < XFER_UDMA_0 ? 0x31C001FF : 0x303C0000;
+
 	pci_read_config_dword(pdev, addr1, &reg);
 	mode = hpt37x_find_mode(ap, adev->dma_mode);
 	printk("Find mode for DMA %d reports %X\n", adev->dma_mode, mode);
-	mode &= ~0xC0000000;	/* Leave config bits alone */
-	mode |= 0x80000000;	/* FIFO in MWDMA or UDMA */
-	reg &= 0xC0000000;	/* Strip timing bits */
+	mode &= mask;
+	reg &= ~mask;
 	pci_write_config_dword(pdev, addr1, reg | mode);
 }
 
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index d5c9fd7..5f9b60f 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt3x2n"
-#define DRV_VERSION	"0.3.4"
+#define DRV_VERSION	"0.3.7"
 
 enum {
 	HPT_PCI_FAST	=	(1 << 31),
@@ -185,9 +185,8 @@ static void hpt3x2n_set_piomode(struct ata_port *ap, struct ata_device *adev)
 
 	pci_read_config_dword(pdev, addr1, &reg);
 	mode = hpt3x2n_find_mode(ap, adev->pio_mode);
-	mode &= ~0x8000000;	/* No FIFO in PIO */
-	mode &= ~0x30070000;	/* Leave config bits alone */
-	reg &= 0x30070000;	/* Strip timing bits */
+	mode &= 0xCFC3FFFF;	/* Leave DMA bits alone */
+	reg &= ~0xCFC3FFFF;	/* Strip timing bits */
 	pci_write_config_dword(pdev, addr1, reg | mode);
 }
 
@@ -204,8 +203,7 @@ static void hpt3x2n_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 addr1, addr2;
-	u32 reg;
-	u32 mode;
+	u32 reg, mode, mask;
 	u8 fast;
 
 	addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
@@ -216,11 +214,12 @@ static void hpt3x2n_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	fast &= ~0x07;
 	pci_write_config_byte(pdev, addr2, fast);
 
+	mask = adev->dma_mode < XFER_UDMA_0 ? 0x31C001FF : 0x303C0000;
+
 	pci_read_config_dword(pdev, addr1, &reg);
 	mode = hpt3x2n_find_mode(ap, adev->dma_mode);
-	mode |= 0x8000000;	/* FIFO in MWDMA or UDMA */
-	mode &= ~0xC0000000;	/* Leave config bits alone */
-	reg &= 0xC0000000;	/* Strip timing bits */
+	mode &= mask;
+	reg &= ~mask;
 	pci_write_config_dword(pdev, addr1, reg | mode);
 }
 
diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index cd589ca..6869310 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -2146,6 +2146,13 @@ ohci_queue_iso_receive_dualbuffer(struct fw_iso_context *base,
 	page     = payload >> PAGE_SHIFT;
 	offset   = payload & ~PAGE_MASK;
 	rest     = p->payload_length;
+	/*
+	 * The controllers I've tested have not worked correctly when
+	 * second_req_count is zero.  Rather than do something we know won't
+	 * work, return an error
+	 */
+	if (rest == 0)
+		return -EINVAL;
 
 	/* FIXME: make packet-per-buffer/dual-buffer a context option */
 	while (rest > 0) {
@@ -2199,7 +2206,7 @@ ohci_queue_iso_receive_packet_per_buffer(struct fw_iso_context *base,
 					 unsigned long payload)
 {
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
-	struct descriptor *d = NULL, *pd = NULL;
+	struct descriptor *d, *pd;
 	struct fw_iso_packet *p = packet;
 	dma_addr_t d_bus, page_bus;
 	u32 z, header_z, rest;
@@ -2237,8 +2244,9 @@ ohci_queue_iso_receive_packet_per_buffer(struct fw_iso_context *base,
 		d->data_address = cpu_to_le32(d_bus + (z * sizeof(*d)));
 
 		rest = payload_per_buffer;
+		pd = d;
 		for (j = 1; j < z; j++) {
-			pd = d + j;
+			pd++;
 			pd->control = cpu_to_le16(DESCRIPTOR_STATUS |
 						  DESCRIPTOR_INPUT_MORE);
 
diff --git a/drivers/media/common/tuners/mxl5007t.c b/drivers/media/common/tuners/mxl5007t.c
index cb25e43..4b975e6 100644
--- a/drivers/media/common/tuners/mxl5007t.c
+++ b/drivers/media/common/tuners/mxl5007t.c
@@ -207,7 +207,7 @@ static void copy_reg_bits(struct reg_pair_t *reg_pair1,
 	i = j = 0;
 
 	while (reg_pair1[i].reg || reg_pair1[i].val) {
-		while (reg_pair2[j].reg || reg_pair2[j].reg) {
+		while (reg_pair2[j].reg || reg_pair2[j].val) {
 			if (reg_pair1[i].reg != reg_pair2[j].reg) {
 				j++;
 				continue;
diff --git a/drivers/ssb/sprom.c b/drivers/ssb/sprom.c
index 3668edb..17471a7 100644
--- a/drivers/ssb/sprom.c
+++ b/drivers/ssb/sprom.c
@@ -13,6 +13,8 @@
 
 #include "ssb_private.h"
 
+#include <linux/ctype.h>
+
 
 static int sprom2hex(const u16 *sprom, char *buf, size_t buf_len,
 		     size_t sprom_size_words)
@@ -30,17 +32,27 @@ static int sprom2hex(const u16 *sprom, char *buf, size_t buf_len,
 static int hex2sprom(u16 *sprom, const char *dump, size_t len,
 		     size_t sprom_size_words)
 {
-	char tmp[5] = { 0 };
-	int cnt = 0;
+	char c, tmp[5] = { 0 };
+	int err, cnt = 0;
 	unsigned long parsed;
 
-	if (len < sprom_size_words * 2)
+	/* Strip whitespace at the end. */
+	while (len) {
+		c = dump[len - 1];
+		if (!isspace(c) && c != '\0')
+			break;
+		len--;
+	}
+	/* Length must match exactly. */
+	if (len != sprom_size_words * 4)
 		return -EINVAL;
 
 	while (cnt < sprom_size_words) {
 		memcpy(tmp, dump, 4);
 		dump += 4;
-		parsed = simple_strtoul(tmp, NULL, 16);
+		err = strict_strtoul(tmp, 16, &parsed);
+		if (err)
+			return err;
 		sprom[cnt++] = swab16((u16)parsed);
 	}
 
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index e8a3938..1911589 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2453,9 +2453,14 @@ static int mos7840_startup(struct usb_serial *serial)
 		mos7840_set_port_private(serial->port[i], mos7840_port);
 		spin_lock_init(&mos7840_port->pool_lock);
 
-		mos7840_port->port_num = ((serial->port[i]->number -
-					   (serial->port[i]->serial->minor)) +
-					  1);
+		/* minor is not initialised until later by
+		 * usb-serial.c:get_free_serial() and cannot therefore be used
+		 * to index device instances */
+		mos7840_port->port_num = i + 1;
+		dbg ("serial->port[i]->number = %d", serial->port[i]->number);
+		dbg ("serial->port[i]->serial->minor = %d", serial->port[i]->serial->minor);
+		dbg ("mos7840_port->port_num = %d", mos7840_port->port_num);
+		dbg ("serial->minor = %d", serial->minor);
 
 		if (mos7840_port->port_num == 1) {
 			mos7840_port->SpRegOffset = 0x0;
@@ -2666,10 +2671,12 @@ static void mos7840_disconnect(struct usb_serial *serial)
 
 	for (i = 0; i < serial->num_ports; ++i) {
 		mos7840_port = mos7840_get_port_private(serial->port[i]);
-		spin_lock_irqsave(&mos7840_port->pool_lock, flags);
-		mos7840_port->zombie = 1;
-		spin_unlock_irqrestore(&mos7840_port->pool_lock, flags);
-		usb_kill_urb(mos7840_port->control_urb);
+		if (mos7840_port) {
+			spin_lock_irqsave(&mos7840_port->pool_lock, flags);
+			mos7840_port->zombie = 1;
+			spin_unlock_irqrestore(&mos7840_port->pool_lock, flags);
+			usb_kill_urb(mos7840_port->control_urb);
+		}
 	}
 
 	dbg("%s\n", "Thank u ::");
diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index b15b2b8..b7c1a2c 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -41,7 +41,7 @@ static int fb_notifier_callback(struct notifier_block *self,
 
 static int lcd_register_fb(struct lcd_device *ld)
 {
-	memset(&ld->fb_notif, 0, sizeof(&ld->fb_notif));
+	memset(&ld->fb_notif, 0, sizeof(ld->fb_notif));
 	ld->fb_notif.notifier_call = fb_notifier_callback;
 	return fb_register_client(&ld->fb_notif);
 }
diff --git a/drivers/video/matrox/g450_pll.c b/drivers/video/matrox/g450_pll.c
index d42346e..3dcb6d2 100644
--- a/drivers/video/matrox/g450_pll.c
+++ b/drivers/video/matrox/g450_pll.c
@@ -341,7 +341,8 @@ static int __g450_setclk(WPMINFO unsigned int fout, unsigned int pll,
 					M1064_XDVICLKCTRL_C1DVICLKEN |
 					M1064_XDVICLKCTRL_DVILOOPCTL |
 					M1064_XDVICLKCTRL_P1LOOPBWDTCTL;
-				matroxfb_DAC_out(PMINFO M1064_XDVICLKCTRL,tmp);
+				/* Setting this breaks PC systems so don't do it */
+				/* matroxfb_DAC_out(PMINFO M1064_XDVICLKCTRL,tmp); */
 				matroxfb_DAC_out(PMINFO M1064_XPWRCTRL,
 						 xpwrctrl);
 
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 08e28c9..1332dce 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -32,7 +32,9 @@
 static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
 
-static struct inode *debugfs_get_inode(struct super_block *sb, int mode, dev_t dev)
+static struct inode *debugfs_get_inode(struct super_block *sb, int mode, dev_t dev,
+				       void *data, const struct file_operations *fops)
+
 {
 	struct inode *inode = new_inode(sb);
 
@@ -47,14 +49,18 @@ static struct inode *debugfs_get_inode(struct super_block *sb, int mode, dev_t d
 			init_special_inode(inode, mode, dev);
 			break;
 		case S_IFREG:
-			inode->i_fop = &debugfs_file_operations;
+			inode->i_fop = fops ? fops : &debugfs_file_operations;
+			inode->i_private = data;
 			break;
 		case S_IFLNK:
 			inode->i_op = &debugfs_link_operations;
+			inode->i_fop = fops;
+			inode->i_private = data;
 			break;
 		case S_IFDIR:
 			inode->i_op = &simple_dir_inode_operations;
-			inode->i_fop = &simple_dir_operations;
+			inode->i_fop = fops ? fops : &simple_dir_operations;
+			inode->i_private = data;
 
 			/* directory inodes start off with i_nlink == 2
 			 * (for "." entry) */
@@ -67,7 +73,8 @@ static struct inode *debugfs_get_inode(struct super_block *sb, int mode, dev_t d
 
 /* SMP-safe */
 static int debugfs_mknod(struct inode *dir, struct dentry *dentry,
-			 int mode, dev_t dev)
+			 int mode, dev_t dev, void *data,
+			 const struct file_operations *fops)
 {
 	struct inode *inode;
 	int error = -EPERM;
@@ -75,7 +82,7 @@ static int debugfs_mknod(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_inode)
 		return -EEXIST;
 
-	inode = debugfs_get_inode(dir->i_sb, mode, dev);
+	inode = debugfs_get_inode(dir->i_sb, mode, dev, data, fops);
 	if (inode) {
 		d_instantiate(dentry, inode);
 		dget(dentry);
@@ -84,12 +91,13 @@ static int debugfs_mknod(struct inode *dir, struct dentry *dentry,
 	return error;
 }
 
-static int debugfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
+static int debugfs_mkdir(struct inode *dir, struct dentry *dentry, int mode,
+			 void *data, const struct file_operations *fops)
 {
 	int res;
 
 	mode = (mode & (S_IRWXUGO | S_ISVTX)) | S_IFDIR;
-	res = debugfs_mknod(dir, dentry, mode, 0);
+	res = debugfs_mknod(dir, dentry, mode, 0, data, fops);
 	if (!res) {
 		inc_nlink(dir);
 		fsnotify_mkdir(dir, dentry);
@@ -97,18 +105,20 @@ static int debugfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	return res;
 }
 
-static int debugfs_link(struct inode *dir, struct dentry *dentry, int mode)
+static int debugfs_link(struct inode *dir, struct dentry *dentry, int mode,
+			void *data, const struct file_operations *fops)
 {
 	mode = (mode & S_IALLUGO) | S_IFLNK;
-	return debugfs_mknod(dir, dentry, mode, 0);
+	return debugfs_mknod(dir, dentry, mode, 0, data, fops);
 }
 
-static int debugfs_create(struct inode *dir, struct dentry *dentry, int mode)
+static int debugfs_create(struct inode *dir, struct dentry *dentry, int mode,
+			  void *data, const struct file_operations *fops)
 {
 	int res;
 
 	mode = (mode & S_IALLUGO) | S_IFREG;
-	res = debugfs_mknod(dir, dentry, mode, 0);
+	res = debugfs_mknod(dir, dentry, mode, 0, data, fops);
 	if (!res)
 		fsnotify_create(dir, dentry);
 	return res;
@@ -142,7 +152,9 @@ static struct file_system_type debug_fs_type = {
 
 static int debugfs_create_by_name(const char *name, mode_t mode,
 				  struct dentry *parent,
-				  struct dentry **dentry)
+				  struct dentry **dentry,
+				  void *data,
+				  const struct file_operations *fops)
 {
 	int error = 0;
 
@@ -167,13 +179,16 @@ static int debugfs_create_by_name(const char *name, mode_t mode,
 	if (!IS_ERR(*dentry)) {
 		switch (mode & S_IFMT) {
 		case S_IFDIR:
-			error = debugfs_mkdir(parent->d_inode, *dentry, mode);
+			error = debugfs_mkdir(parent->d_inode, *dentry, mode,
+					      data, fops);
 			break;
 		case S_IFLNK:
-			error = debugfs_link(parent->d_inode, *dentry, mode);
+			error = debugfs_link(parent->d_inode, *dentry, mode,
+					     data, fops);
 			break;
 		default:
-			error = debugfs_create(parent->d_inode, *dentry, mode);
+			error = debugfs_create(parent->d_inode, *dentry, mode,
+					       data, fops);
 			break;
 		}
 		dput(*dentry);
@@ -224,19 +239,13 @@ struct dentry *debugfs_create_file(const char *name, mode_t mode,
 	if (error)
 		goto exit;
 
-	error = debugfs_create_by_name(name, mode, parent, &dentry);
+	error = debugfs_create_by_name(name, mode, parent, &dentry,
+				       data, fops);
 	if (error) {
 		dentry = NULL;
 		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 		goto exit;
 	}
-
-	if (dentry->d_inode) {
-		if (data)
-			dentry->d_inode->i_private = data;
-		if (fops)
-			dentry->d_inode->i_fop = fops;
-	}
 exit:
 	return dentry;
 }
diff --git a/fs/hfs/catalog.c b/fs/hfs/catalog.c
index 6d98f11..424b033 100644
--- a/fs/hfs/catalog.c
+++ b/fs/hfs/catalog.c
@@ -289,6 +289,10 @@ int hfs_cat_move(u32 cnid, struct inode *src_dir, struct qstr *src_name,
 	err = hfs_brec_find(&src_fd);
 	if (err)
 		goto out;
+	if (src_fd.entrylength > sizeof(entry) || src_fd.entrylength < 0) {
+		err = -EIO;
+		goto out;
+	}
 
 	hfs_bnode_read(src_fd.bnode, &entry, src_fd.entryoffset,
 			    src_fd.entrylength);
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index 7c69b98..2b3b861 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -79,6 +79,11 @@ static int hfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 		filp->f_pos++;
 		/* fall through */
 	case 1:
+		if (fd.entrylength > sizeof(entry) || fd.entrylength < 0) {
+			err = -EIO;
+			goto out;
+		}
+
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset, fd.entrylength);
 		if (entry.type != HFS_CDR_THD) {
 			printk(KERN_ERR "hfs: bad catalog folder thread\n");
@@ -109,6 +114,12 @@ static int hfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 			err = -EIO;
 			goto out;
 		}
+
+		if (fd.entrylength > sizeof(entry) || fd.entrylength < 0) {
+			err = -EIO;
+			goto out;
+		}
+
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset, fd.entrylength);
 		type = entry.type;
 		len = hfs_mac2asc(sb, strbuf, &fd.key->cat.CName);
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 4abb104..cd0d15d 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -386,8 +386,13 @@ static int hfs_fill_super(struct super_block *sb, void *data, int silent)
 	/* try to get the root inode */
 	hfs_find_init(HFS_SB(sb)->cat_tree, &fd);
 	res = hfs_cat_find_brec(sb, HFS_ROOT_CNID, &fd);
-	if (!res)
+	if (!res) {
+		if (fd.entrylength > sizeof(rec) || fd.entrylength < 0) {
+			res =  -EIO;
+			goto bail;
+		}
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset, fd.entrylength);
+	}
 	if (res) {
 		hfs_find_exit(&fd);
 		goto bail_no_root;
diff --git a/fs/jffs2/gc.c b/fs/jffs2/gc.c
index 090c556..3b6f2fa 100644
--- a/fs/jffs2/gc.c
+++ b/fs/jffs2/gc.c
@@ -700,7 +700,8 @@ static int jffs2_garbage_collect_metadata(struct jffs2_sb_info *c, struct jffs2_
 	struct jffs2_raw_inode ri;
 	struct jffs2_node_frag *last_frag;
 	union jffs2_device_node dev;
-	char *mdata = NULL, mdatalen = 0;
+	char *mdata = NULL;
+	int mdatalen = 0;
 	uint32_t alloclen, ilen;
 	int ret;
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 09c5851..ebe801e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1803,11 +1803,18 @@ static inline int is_si_special(const struct siginfo *info)
 	return info <= SEND_SIG_FORCED;
 }
 
-/* True if we are on the alternate signal stack.  */
-
+/*
+ * True if we are on the alternate signal stack.
+ */
 static inline int on_sig_stack(unsigned long sp)
 {
-	return (sp - current->sas_ss_sp < current->sas_ss_size);
+#ifdef CONFIG_STACK_GROWSUP
+	return sp >= current->sas_ss_sp &&
+		sp - current->sas_ss_sp < current->sas_ss_size;
+#else
+	return sp > current->sas_ss_sp &&
+		sp - current->sas_ss_sp <= current->sas_ss_size;
+#endif
 }
 
 static inline int sas_ss_flags(unsigned long sp)
