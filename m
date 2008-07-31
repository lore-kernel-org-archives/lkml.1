Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYGaGvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYGaGvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 02:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYGaGvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 02:51:45 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46991 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbYGaGvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 02:51:42 -0400
Date: Thu, 31 Jul 2008 02:51:41 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20080731065141.GA18091@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ata_piix.c    |    1 +
 drivers/ata/libata-core.c |   57 ++++++++--
 drivers/ata/libata-scsi.c |   34 +------
 drivers/ata/libata.h      |    1 -
 drivers/ata/pata_ali.c    |    3 +-
 drivers/ata/pata_it821x.c |  270 +++++++++++++++++++++++++++++++++++++++------
 drivers/ata/pata_via.c    |   64 +++++++++++-
 include/linux/libata.h    |    9 +-
 8 files changed, 356 insertions(+), 83 deletions(-)

Alan Cox (1):
      pata_it821x: Driver updates and reworking

Alexander Beregalov (1):
      libata.h: replace __FUNCTION__ with __func__

Ben Dooks (1):
      pata_ali: misplaced pci_dev_put()

Elias Oltmanns (1):
      libata-core: make sure that ata_force_tbl is freed in case of an error

JosephChan@via.com.tw (1):
      pata_via: add VX800 flag; add function for fixing h/w bugs

Tejun Heo (2):
      libata: update atapi disable handling
      ata_piix: subsys 106b:00a3 is apple ich8m too

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index a90ae03..c294121 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -250,6 +250,7 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* Mobile SATA Controller IDE (ICH8M), Apple */
 	{ 0x8086, 0x2828, 0x106b, 0x00a0, 0, 0, ich8m_apple_sata },
 	{ 0x8086, 0x2828, 0x106b, 0x00a1, 0, 0, ich8m_apple_sata },
+	{ 0x8086, 0x2828, 0x106b, 0x00a3, 0, 0, ich8m_apple_sata },
 	/* Mobile SATA Controller IDE (ICH8M) */
 	{ 0x8086, 0x2828, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
 	/* SATA Controller IDE (ICH9) */
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9bef1a8..5ba96c5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -120,7 +120,7 @@ static char ata_force_param_buf[PAGE_SIZE] __initdata;
 module_param_string(force, ata_force_param_buf, sizeof(ata_force_param_buf), 0);
 MODULE_PARM_DESC(force, "Force ATA configurations including cable type, link speed and transfer mode (see Documentation/kernel-parameters.txt for details)");
 
-int atapi_enabled = 1;
+static int atapi_enabled = 1;
 module_param(atapi_enabled, int, 0444);
 MODULE_PARM_DESC(atapi_enabled, "Enable discovery of ATAPI devices (0=off, 1=on)");
 
@@ -1132,6 +1132,8 @@ void ata_id_string(const u16 *id, unsigned char *s,
 {
 	unsigned int c;
 
+	BUG_ON(len & 1);
+
 	while (len > 0) {
 		c = id[ofs] >> 8;
 		*s = c;
@@ -1165,8 +1167,6 @@ void ata_id_c_string(const u16 *id, unsigned char *s,
 {
 	unsigned char *p;
 
-	WARN_ON(!(len & 1));
-
 	ata_id_string(id, s, ofs, len - 1);
 
 	p = s + strnlen(s, len - 1);
@@ -1886,6 +1886,23 @@ static u32 ata_pio_mask_no_iordy(const struct ata_device *adev)
 }
 
 /**
+ *	ata_do_dev_read_id		-	default ID read method
+ *	@dev: device
+ *	@tf: proposed taskfile
+ *	@id: data buffer
+ *
+ *	Issue the identify taskfile and hand back the buffer containing
+ *	identify data. For some RAID controllers and for pre ATA devices
+ *	this function is wrapped or replaced by the driver
+ */
+unsigned int ata_do_dev_read_id(struct ata_device *dev,
+					struct ata_taskfile *tf, u16 *id)
+{
+	return ata_exec_internal(dev, tf, NULL, DMA_FROM_DEVICE,
+				     id, sizeof(id[0]) * ATA_ID_WORDS, 0);
+}
+
+/**
  *	ata_dev_read_id - Read ID data from the specified device
  *	@dev: target device
  *	@p_class: pointer to class of the target device (may be changed)
@@ -1920,7 +1937,7 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 	if (ata_msg_ctl(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER\n", __func__);
 
- retry:
+retry:
 	ata_tf_init(dev, &tf);
 
 	switch (class) {
@@ -1948,8 +1965,11 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 	 */
 	tf.flags |= ATA_TFLAG_POLLING;
 
-	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_FROM_DEVICE,
-				     id, sizeof(id[0]) * ATA_ID_WORDS, 0);
+	if (ap->ops->read_id)
+		err_mask = ap->ops->read_id(dev, &tf, id);
+	else
+		err_mask = ata_do_dev_read_id(dev, &tf, id);
+
 	if (err_mask) {
 		if (err_mask & AC_ERR_NODEV_HINT) {
 			ata_dev_printk(dev, KERN_DEBUG,
@@ -2142,6 +2162,16 @@ int ata_dev_configure(struct ata_device *dev)
 		return 0;
 	}
 
+	if ((!atapi_enabled || (ap->flags & ATA_FLAG_NO_ATAPI)) &&
+	    dev->class == ATA_DEV_ATAPI) {
+		ata_dev_printk(dev, KERN_WARNING,
+			"WARNING: ATAPI is %s, device ignored.\n",
+			atapi_enabled ? "not supported with this driver"
+				      : "disabled");
+		ata_dev_disable(dev);
+		return 0;
+	}
+
 	/* let ACPI work its magic */
 	rc = ata_acpi_on_devcfg(dev);
 	if (rc)
@@ -6088,16 +6118,20 @@ static int __init ata_init(void)
 
 	ata_wq = create_workqueue("ata");
 	if (!ata_wq)
-		return -ENOMEM;
+		goto free_force_tbl;
 
 	ata_aux_wq = create_singlethread_workqueue("ata_aux");
-	if (!ata_aux_wq) {
-		destroy_workqueue(ata_wq);
-		return -ENOMEM;
-	}
+	if (!ata_aux_wq)
+		goto free_wq;
 
 	printk(KERN_DEBUG "libata version " DRV_VERSION " loaded.\n");
 	return 0;
+
+free_wq:
+	destroy_workqueue(ata_wq);
+free_force_tbl:
+	kfree(ata_force_tbl);
+	return -ENOMEM;
 }
 
 static void __exit ata_exit(void)
@@ -6269,6 +6303,7 @@ EXPORT_SYMBOL_GPL(ata_host_resume);
 #endif /* CONFIG_PM */
 EXPORT_SYMBOL_GPL(ata_id_string);
 EXPORT_SYMBOL_GPL(ata_id_c_string);
+EXPORT_SYMBOL_GPL(ata_do_dev_read_id);
 EXPORT_SYMBOL_GPL(ata_scsi_simulate);
 
 EXPORT_SYMBOL_GPL(ata_pio_need_iordy);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index f3b4b15..b9d3ba4 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2551,36 +2551,6 @@ static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
 }
 
 /**
- *	ata_scsi_dev_enabled - determine if device is enabled
- *	@dev: ATA device
- *
- *	Determine if commands should be sent to the specified device.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- *
- *	RETURNS:
- *	0 if commands are not allowed / 1 if commands are allowed
- */
-
-static int ata_scsi_dev_enabled(struct ata_device *dev)
-{
-	if (unlikely(!ata_dev_enabled(dev)))
-		return 0;
-
-	if (!atapi_enabled || (dev->link->ap->flags & ATA_FLAG_NO_ATAPI)) {
-		if (unlikely(dev->class == ATA_DEV_ATAPI)) {
-			ata_dev_printk(dev, KERN_WARNING,
-				       "WARNING: ATAPI is %s, device ignored.\n",
-				       atapi_enabled ? "not supported with this driver" : "disabled");
-			return 0;
-		}
-	}
-
-	return 1;
-}
-
-/**
  *	ata_scsi_find_dev - lookup ata_device from scsi_cmnd
  *	@ap: ATA port to which the device is attached
  *	@scsidev: SCSI device from which we derive the ATA device
@@ -2601,7 +2571,7 @@ ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev)
 {
 	struct ata_device *dev = __ata_scsi_find_dev(ap, scsidev);
 
-	if (unlikely(!dev || !ata_scsi_dev_enabled(dev)))
+	if (unlikely(!dev || !ata_dev_enabled(dev)))
 		return NULL;
 
 	return dev;
@@ -3622,7 +3592,7 @@ int ata_sas_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
 
 	ata_scsi_dump_cdb(ap, cmd);
 
-	if (likely(ata_scsi_dev_enabled(ap->link.device)))
+	if (likely(ata_dev_enabled(ap->link.device)))
 		rc = __ata_scsi_queuecmd(cmd, done, ap->link.device);
 	else {
 		cmd->result = (DID_BAD_TARGET << 16);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index f6f9c28..ade5c75 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -66,7 +66,6 @@ enum {
 
 extern unsigned int ata_print_id;
 extern struct workqueue_struct *ata_aux_wq;
-extern int atapi_enabled;
 extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 0f3e659..5ca70fa 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -550,8 +550,9 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		pci_read_config_byte(isa_bridge, 0x5E, &tmp);
 		if ((tmp & 0x1E) == 0x12)
 	        	ppi[0] = &info_20_udma;
-		pci_dev_put(isa_bridge);
 	}
+	pci_dev_put(isa_bridge);
+
 	return ata_pci_sff_init_one(pdev, ppi, &ali_sht, NULL);
 }
 
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index e108169..27843c7 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -80,7 +80,7 @@
 
 
 #define DRV_NAME "pata_it821x"
-#define DRV_VERSION "0.3.8"
+#define DRV_VERSION "0.4.0"
 
 struct it821x_dev
 {
@@ -425,6 +425,8 @@ static unsigned int it821x_smart_qc_issue(struct ata_queued_cmd *qc)
 		case ATA_CMD_WRITE_MULTI:
 		case ATA_CMD_WRITE_MULTI_EXT:
 		case ATA_CMD_ID_ATA:
+		case ATA_CMD_INIT_DEV_PARAMS:
+		case 0xFC:	/* Internal 'report rebuild state' */
 		/* Arguably should just no-op this one */
 		case ATA_CMD_SET_FEATURES:
 			return ata_sff_qc_issue(qc);
@@ -509,7 +511,7 @@ static void it821x_dev_config(struct ata_device *adev)
 
 	if (strstr(model_num, "Integrated Technology Express")) {
 		/* RAID mode */
-		printk(KERN_INFO "IT821x %sRAID%d volume",
+		ata_dev_printk(adev, KERN_INFO, "%sRAID%d volume",
 			adev->id[147]?"Bootable ":"",
 			adev->id[129]);
 		if (adev->id[129] != 1)
@@ -519,37 +521,51 @@ static void it821x_dev_config(struct ata_device *adev)
 	/* This is a controller firmware triggered funny, don't
 	   report the drive faulty! */
 	adev->horkage &= ~ATA_HORKAGE_DIAGNOSTIC;
+	/* No HPA in 'smart' mode */
+	adev->horkage |= ATA_HORKAGE_BROKEN_HPA;
 }
 
 /**
- *	it821x_ident_hack	-	Hack identify data up
- *	@ap: Port
+ *	it821x_read_id	-	Hack identify data up
+ *	@adev: device to read
+ *	@tf: proposed taskfile
+ *	@id: buffer for returned ident data
  *
- *	Walk the devices on this firmware driven port and slightly
+ *	Query the devices on this firmware driven port and slightly
  *	mash the identify data to stop us and common tools trying to
  *	use features not firmware supported. The firmware itself does
  *	some masking (eg SMART) but not enough.
- *
- *	This is a bit of an abuse of the cable method, but it is the
- *	only method called at the right time. We could modify the libata
- *	core specifically for ident hacking but while we have one offender
- *	it seems better to keep the fallout localised.
  */
 
-static int it821x_ident_hack(struct ata_port *ap)
+static unsigned int it821x_read_id(struct ata_device *adev,
+					struct ata_taskfile *tf, u16 *id)
 {
-	struct ata_device *adev;
-	ata_link_for_each_dev(adev, &ap->link) {
-		if (ata_dev_enabled(adev)) {
-			adev->id[84] &= ~(1 << 6);	/* No FUA */
-			adev->id[85] &= ~(1 << 10);	/* No HPA */
-			adev->id[76] = 0;		/* No NCQ/AN etc */
-		}
+	unsigned int err_mask;
+	unsigned char model_num[ATA_ID_PROD_LEN + 1];
+
+	err_mask = ata_do_dev_read_id(adev, tf, id);
+	if (err_mask)
+		return err_mask;
+	ata_id_c_string(id, model_num, ATA_ID_PROD, sizeof(model_num));
+
+	id[83] &= ~(1 << 12);	/* Cache flush is firmware handled */
+	id[83] &= ~(1 << 13);	/* Ditto for LBA48 flushes */
+	id[84] &= ~(1 << 6);	/* No FUA */
+	id[85] &= ~(1 << 10);	/* No HPA */
+	id[76] = 0;		/* No NCQ/AN etc */
+
+	if (strstr(model_num, "Integrated Technology Express")) {
+		/* Set feature bits the firmware neglects */
+		id[49] |= 0x0300;	/* LBA, DMA */
+		id[82] |= 0x0400;	/* LBA48 */
+		id[83] &= 0x7FFF;
+		id[83] |= 0x4000;	/* Word 83 is valid */
+		id[86] |= 0x0400;	/* LBA48 on */
+		id[ATA_ID_MAJOR_VER] |= 0x1F;
 	}
-	return ata_cable_unknown(ap);
+	return err_mask;
 }
 
-
 /**
  *	it821x_check_atapi_dma	-	ATAPI DMA handler
  *	@qc: Command we are about to issue
@@ -577,6 +593,136 @@ static int it821x_check_atapi_dma(struct ata_queued_cmd *qc)
 	return 0;
 }
 
+/**
+ *	it821x_display_disk	-	display disk setup
+ *	@n: Device number
+ *	@buf: Buffer block from firmware
+ *
+ *	Produce a nice informative display of the device setup as provided
+ *	by the firmware.
+ */
+
+static void it821x_display_disk(int n, u8 *buf)
+{
+	unsigned char id[41];
+	int mode = 0;
+	char *mtype;
+	char mbuf[8];
+	char *cbl = "(40 wire cable)";
+
+	static const char *types[5] = {
+		"RAID0", "RAID1" "RAID 0+1", "JBOD", "DISK"
+	};
+
+	if (buf[52] > 4)	/* No Disk */
+		return;
+
+	ata_id_c_string((u16 *)buf, id, 0, 41); 
+
+	if (buf[51]) {
+		mode = ffs(buf[51]);
+		mtype = "UDMA";
+	} else if (buf[49]) {
+		mode = ffs(buf[49]);
+		mtype = "MWDMA";
+	}
+
+	if (buf[76])
+		cbl = "";
+
+	if (mode)
+		snprintf(mbuf, 8, "%5s%d", mtype, mode - 1);
+	else
+		strcpy(mbuf, "PIO");
+	if (buf[52] == 4)
+		printk(KERN_INFO "%d: %-6s %-8s          %s %s\n",
+				n, mbuf, types[buf[52]], id, cbl);
+	else
+		printk(KERN_INFO "%d: %-6s %-8s Volume: %1d %s %s\n",
+				n, mbuf, types[buf[52]], buf[53], id, cbl);
+	if (buf[125] < 100)
+		printk(KERN_INFO "%d: Rebuilding: %d%%\n", n, buf[125]);
+}
+
+/**
+ *	it821x_firmware_command		-	issue firmware command
+ *	@ap: IT821x port to interrogate
+ *	@cmd: command
+ *	@len: length
+ *
+ *	Issue firmware commands expecting data back from the controller. We
+ *	use this to issue commands that do not go via the normal paths. Other
+ *	commands such as 0xFC can be issued normally.
+ */
+
+static u8 *it821x_firmware_command(struct ata_port *ap, u8 cmd, int len)
+{
+	u8 status;
+	int n = 0;
+	u16 *buf = kmalloc(len, GFP_KERNEL);
+	if (buf == NULL) {
+		printk(KERN_ERR "it821x_firmware_command: Out of memory\n");
+		return NULL;
+	}
+	/* This isn't quite a normal ATA command as we are talking to the
+	   firmware not the drives */
+	ap->ctl |= ATA_NIEN;
+	iowrite8(ap->ctl, ap->ioaddr.ctl_addr);
+	ata_wait_idle(ap);
+	iowrite8(ATA_DEVICE_OBS, ap->ioaddr.device_addr);
+	iowrite8(cmd, ap->ioaddr.command_addr);
+	udelay(1);
+	/* This should be almost immediate but a little paranoia goes a long
+	   way. */
+	while(n++ < 10) {
+		status = ioread8(ap->ioaddr.status_addr);
+		if (status & ATA_ERR) {
+			kfree(buf);
+			printk(KERN_ERR "it821x_firmware_command: rejected\n");
+			return NULL;
+		}
+		if (status & ATA_DRQ) {
+			ioread16_rep(ap->ioaddr.data_addr, buf, len/2);
+			return (u8 *)buf;
+		}
+		mdelay(1);
+	}
+	kfree(buf);
+	printk(KERN_ERR "it821x_firmware_command: timeout\n");
+	return NULL;
+}
+
+/**
+ *	it821x_probe_firmware	-	firmware reporting/setup
+ *	@ap: IT821x port being probed
+ *
+ *	Probe the firmware of the controller by issuing firmware command
+ *	0xFA and analysing the returned data.
+ */
+
+static void it821x_probe_firmware(struct ata_port *ap)
+{
+	u8 *buf;
+	int i;
+
+	/* This is a bit ugly as we can't just issue a task file to a device
+	   as this is controller magic */
+
+	buf = it821x_firmware_command(ap, 0xFA, 512);
+
+	if (buf != NULL) {
+		printk(KERN_INFO "pata_it821x: Firmware %02X/%02X/%02X%02X\n",
+				buf[505],
+				buf[506],
+				buf[507],
+				buf[508]);
+		for (i = 0; i < 4; i++)
+ 			it821x_display_disk(i, buf + 128 * i);
+		kfree(buf);
+	}
+}
+
+
 
 /**
  *	it821x_port_start	-	port setup
@@ -610,6 +756,8 @@ static int it821x_port_start(struct ata_port *ap)
 		/* Long I/O's although allowed in LBA48 space cause the
 		   onboard firmware to enter the twighlight zone */
 		/* No ATAPI DMA in this mode either */
+		if (ap->port_no == 0)
+			it821x_probe_firmware(ap);
 	}
 	/* Pull the current clocks from 0x50 */
 	if (conf & (1 << (1 + ap->port_no)))
@@ -631,6 +779,25 @@ static int it821x_port_start(struct ata_port *ap)
 	return 0;
 }
 
+/**
+ *	it821x_rdc_cable	-	Cable detect for RDC1010
+ *	@ap: port we are checking
+ *
+ *	Return the RDC1010 cable type. Unlike the IT821x we know how to do
+ *	this and can do host side cable detect
+ */
+
+static int it821x_rdc_cable(struct ata_port *ap)
+{
+	u16 r40;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	pci_read_config_word(pdev, 0x40, &r40);
+	if (r40 & (1 << (2 + ap->port_no)))
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
+}
+
 static struct scsi_host_template it821x_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -641,9 +808,10 @@ static struct ata_port_operations it821x_smart_port_ops = {
 	.check_atapi_dma= it821x_check_atapi_dma,
 	.qc_issue	= it821x_smart_qc_issue,
 
-	.cable_detect	= it821x_ident_hack,
+	.cable_detect	= ata_cable_80wire,
 	.set_mode	= it821x_smart_set_mode,
 	.dev_config	= it821x_dev_config,
+	.read_id	= it821x_read_id,
 
 	.port_start	= it821x_port_start,
 };
@@ -664,8 +832,29 @@ static struct ata_port_operations it821x_passthru_port_ops = {
 	.port_start	= it821x_port_start,
 };
 
+static struct ata_port_operations it821x_rdc_port_ops = {
+	.inherits	= &ata_bmdma_port_ops,
+
+	.check_atapi_dma= it821x_check_atapi_dma,
+	.sff_dev_select	= it821x_passthru_dev_select,
+	.bmdma_start 	= it821x_passthru_bmdma_start,
+	.bmdma_stop	= it821x_passthru_bmdma_stop,
+	.qc_issue	= it821x_passthru_qc_issue,
+
+	.cable_detect	= it821x_rdc_cable,
+	.set_piomode	= it821x_passthru_set_piomode,
+	.set_dmamode	= it821x_passthru_set_dmamode,
+
+	.port_start	= it821x_port_start,
+};
+
 static void it821x_disable_raid(struct pci_dev *pdev)
 {
+	/* Neither the RDC nor the IT8211 */
+	if (pdev->vendor != PCI_VENDOR_ID_ITE ||
+			pdev->device != PCI_DEVICE_ID_ITE_8212)
+			return;
+
 	/* Reset local CPU, and set BIOS not ready */
 	pci_write_config_byte(pdev, 0x5E, 0x01);
 
@@ -690,6 +879,7 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.flags = ATA_FLAG_SLAVE_POSS,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
+		.udma_mask = ATA_UDMA6,
 		.port_ops = &it821x_smart_port_ops
 	};
 	static const struct ata_port_info info_passthru = {
@@ -699,6 +889,13 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.udma_mask = ATA_UDMA6,
 		.port_ops = &it821x_passthru_port_ops
 	};
+	static const struct ata_port_info info_rdc = {
+		.flags = ATA_FLAG_SLAVE_POSS,
+		.pio_mask = 0x1f,
+		.mwdma_mask = 0x07,
+		/* No UDMA */
+		.port_ops = &it821x_rdc_port_ops
+	};
 
 	const struct ata_port_info *ppi[] = { NULL, NULL };
 	static char *mode[2] = { "pass through", "smart" };
@@ -707,21 +904,25 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	rc = pcim_enable_device(pdev);
 	if (rc)
 		return rc;
+		
+	if (pdev->vendor == PCI_VENDOR_ID_RDC) {
+		ppi[0] = &info_rdc;
+	} else {
+		/* Force the card into bypass mode if so requested */
+		if (it8212_noraid) {
+			printk(KERN_INFO DRV_NAME ": forcing bypass mode.\n");
+			it821x_disable_raid(pdev);
+		}
+		pci_read_config_byte(pdev, 0x50, &conf);
+		conf &= 1;
 
-	/* Force the card into bypass mode if so requested */
-	if (it8212_noraid) {
-		printk(KERN_INFO DRV_NAME ": forcing bypass mode.\n");
-		it821x_disable_raid(pdev);
+		printk(KERN_INFO DRV_NAME": controller in %s mode.\n",
+								mode[conf]);
+		if (conf == 0)
+			ppi[0] = &info_passthru;
+		else
+			ppi[0] = &info_smart;
 	}
-	pci_read_config_byte(pdev, 0x50, &conf);
-	conf &= 1;
-
-	printk(KERN_INFO DRV_NAME ": controller in %s mode.\n", mode[conf]);
-	if (conf == 0)
-		ppi[0] = &info_passthru;
-	else
-		ppi[0] = &info_smart;
-
 	return ata_pci_sff_init_one(pdev, ppi, &it821x_sht, NULL);
 }
 
@@ -745,6 +946,7 @@ static int it821x_reinit_one(struct pci_dev *pdev)
 static const struct pci_device_id it821x[] = {
 	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8211), },
 	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8212), },
+	{ PCI_VDEVICE(RDC, 0x1010), },
 
 	{ },
 };
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 708ed14..57d951b 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -98,7 +98,8 @@ static const struct via_isa_bridge {
 	u8 rev_max;
 	u16 flags;
 } via_isa_bridges[] = {
-	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
+	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, VIA_UDMA_133 |
+	VIA_BAD_AST | VIA_SATA_PATA },
 	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_SATA_PATA },
@@ -322,6 +323,65 @@ static void via_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	via_do_set_mode(ap, adev, adev->dma_mode, tclock[mode], set_ast, udma[mode]);
 }
 
+/**
+ *	via_ata_sff_tf_load - send taskfile registers to host controller
+ *	@ap: Port to which output is sent
+ *	@tf: ATA taskfile register set
+ *
+ *	Outputs ATA taskfile to standard ATA host controller.
+ *
+ *	Note: This is to fix the internal bug of via chipsets, which
+ *  will reset the device register after changing the IEN bit on
+ *  ctl register
+ */
+static void via_ata_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	unsigned int is_addr = tf->flags & ATA_TFLAG_ISADDR;
+
+	if (tf->ctl != ap->last_ctl) {
+		iowrite8(tf->ctl, ioaddr->ctl_addr);
+		iowrite8(tf->device, ioaddr->device_addr);
+		ap->last_ctl = tf->ctl;
+		ata_wait_idle(ap);
+	}
+
+	if (is_addr && (tf->flags & ATA_TFLAG_LBA48)) {
+		iowrite8(tf->hob_feature, ioaddr->feature_addr);
+		iowrite8(tf->hob_nsect, ioaddr->nsect_addr);
+		iowrite8(tf->hob_lbal, ioaddr->lbal_addr);
+		iowrite8(tf->hob_lbam, ioaddr->lbam_addr);
+		iowrite8(tf->hob_lbah, ioaddr->lbah_addr);
+		VPRINTK("hob: feat 0x%X nsect 0x%X, lba 0x%X 0x%X 0x%X\n",
+			tf->hob_feature,
+			tf->hob_nsect,
+			tf->hob_lbal,
+			tf->hob_lbam,
+			tf->hob_lbah);
+	}
+
+	if (is_addr) {
+		iowrite8(tf->feature, ioaddr->feature_addr);
+		iowrite8(tf->nsect, ioaddr->nsect_addr);
+		iowrite8(tf->lbal, ioaddr->lbal_addr);
+		iowrite8(tf->lbam, ioaddr->lbam_addr);
+		iowrite8(tf->lbah, ioaddr->lbah_addr);
+		VPRINTK("feat 0x%X nsect 0x%X lba 0x%X 0x%X 0x%X\n",
+			tf->feature,
+			tf->nsect,
+			tf->lbal,
+			tf->lbam,
+			tf->lbah);
+	}
+
+	if (tf->flags & ATA_TFLAG_DEVICE) {
+		iowrite8(tf->device, ioaddr->device_addr);
+		VPRINTK("device 0x%X\n", tf->device);
+	}
+
+	ata_wait_idle(ap);
+}
+
 static struct scsi_host_template via_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
@@ -332,11 +392,13 @@ static struct ata_port_operations via_port_ops = {
 	.set_piomode	= via_set_piomode,
 	.set_dmamode	= via_set_dmamode,
 	.prereset	= via_pre_reset,
+	.sff_tf_load = via_ata_tf_load,
 };
 
 static struct ata_port_operations via_port_ops_noirq = {
 	.inherits	= &via_port_ops,
 	.sff_data_xfer	= ata_sff_data_xfer_noirq,
+	.sff_tf_load = via_ata_tf_load,
 };
 
 /**
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 5b247b8..06b8033 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -60,9 +60,9 @@
 
 /* note: prints function name for you */
 #ifdef ATA_DEBUG
-#define DPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ## args)
+#define DPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __func__, ## args)
 #ifdef ATA_VERBOSE_DEBUG
-#define VPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ## args)
+#define VPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __func__, ## args)
 #else
 #define VPRINTK(fmt, args...)
 #endif	/* ATA_VERBOSE_DEBUG */
@@ -71,7 +71,7 @@
 #define VPRINTK(fmt, args...)
 #endif	/* ATA_DEBUG */
 
-#define BPRINTK(fmt, args...) if (ap->flags & ATA_FLAG_DEBUGMSG) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ## args)
+#define BPRINTK(fmt, args...) if (ap->flags & ATA_FLAG_DEBUGMSG) printk(KERN_ERR "%s: " fmt, __func__, ## args)
 
 /* NEW: debug levels */
 #define HAVE_LIBATA_MSG 1
@@ -750,6 +750,7 @@ struct ata_port_operations {
 	void (*set_piomode)(struct ata_port *ap, struct ata_device *dev);
 	void (*set_dmamode)(struct ata_port *ap, struct ata_device *dev);
 	int  (*set_mode)(struct ata_link *link, struct ata_device **r_failed_dev);
+	unsigned int (*read_id)(struct ata_device *dev, struct ata_taskfile *tf, u16 *id);
 
 	void (*dev_config)(struct ata_device *dev);
 
@@ -951,6 +952,8 @@ extern void ata_id_string(const u16 *id, unsigned char *s,
 			  unsigned int ofs, unsigned int len);
 extern void ata_id_c_string(const u16 *id, unsigned char *s,
 			    unsigned int ofs, unsigned int len);
+extern unsigned int ata_do_dev_read_id(struct ata_device *dev,
+					struct ata_taskfile *tf, u16 *id);
 extern void ata_qc_complete(struct ata_queued_cmd *qc);
 extern int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active);
 extern void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
