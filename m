Return-Path: <linux-kernel-owner+w=401wt.eu-S1760960AbXFAMMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbXFAMMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 08:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759157AbXFAMMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 08:12:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59320 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885AbXFAMMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 08:12:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 1 Jun 2007 14:11:36 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [GIT PULL] ieee1394 fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.b48f5c718ecc4c84@s5r6.in-berlin.de>
Message-ID: <tkrat.d46a078e3b7ae8af@s5r6.in-berlin.de>
References: <tkrat.b48f5c718ecc4c84@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Linus, please pull from the for-linus branch at
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus
> 
> to receive the following updates to the old and the new IEEE 1394 subsystem:


>From a52938f3e2e7c1dd2f00775016703991b7809c42 Mon Sep 17 00:00:00 2001
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Sun, 27 May 2007 13:11:47 +0200
Subject: [PATCH] ieee1394: fix calculation of sysfs attribute "address"

struct csr1212_keyval.offset is relative to 0xffff f000 0000 rather than
0xffff f000 0400.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/nodemgr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index 835937e..c291602 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -976,7 +976,7 @@ static struct unit_directory *nodemgr_process_unit_directory
 
 	ud->ne = ne;
 	ud->ignore_driver = ignore_drivers;
-	ud->address = ud_kv->offset + CSR1212_CONFIG_ROM_SPACE_BASE;
+	ud->address = ud_kv->offset + CSR1212_REGISTER_SPACE_BASE;
 	ud->ud_kv = ud_kv;
 	ud->id = (*id)++;
 
-- 
1.5.1.6

>From d7794c86686a05276de42f145e485099426aca68 Mon Sep 17 00:00:00 2001
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Sun, 27 May 2007 13:17:15 +0200
Subject: [PATCH] ieee1394: sbp2: offer SAM-conforming target port ID in sysfs

With "modprobe sbp2 long_ieee1394_id=y", the format of
/sys/bus/scsi/devices/*:*:*:*/ieee1394_id is changed from e.g.
0001041010004beb:0:0 to 0001041010004beb:00042c:0000.

The longer format fully conforms to object identifier sizes as per
SAM(-2...4) and reflects what the SAM target port identifier is meant to
contain:  A Discovery ID allegedly specified by ISO/IEC 13213:1994 ---
however there is no such thing; the authors of SAM probably meant
Directory ID).  Especially target nodes with multiple dynamically added
targets may use Directory IDs to persistently identify target ports.

The new format is independent of implementation details of nodemgr.
Thus the same ieee1394_id attribute format can be implemented in the new
firewire stack.

The ieee1394_id is typically used to create persistently named links in
/dev/disk/by-id.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/nodemgr.c |    5 +++++
 drivers/ieee1394/nodemgr.h |    1 +
 drivers/ieee1394/sbp2.c    |   31 +++++++++++++++++++++++++++++--
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/ieee1394/nodemgr.c b/drivers/ieee1394/nodemgr.c
index c291602..81b3864 100644
--- a/drivers/ieee1394/nodemgr.c
+++ b/drivers/ieee1394/nodemgr.c
@@ -977,6 +977,7 @@ static struct unit_directory *nodemgr_process_unit_directory
 	ud->ne = ne;
 	ud->ignore_driver = ignore_drivers;
 	ud->address = ud_kv->offset + CSR1212_REGISTER_SPACE_BASE;
+	ud->directory_id = ud->address & 0xffffff;
 	ud->ud_kv = ud_kv;
 	ud->id = (*id)++;
 
@@ -1085,6 +1086,10 @@ static struct unit_directory *nodemgr_process_unit_directory
 
 			break;
 
+		case CSR1212_KV_ID_DIRECTORY_ID:
+			ud->directory_id = kv->value.immediate;
+			break;
+
 		default:
 			break;
 		}
diff --git a/drivers/ieee1394/nodemgr.h b/drivers/ieee1394/nodemgr.h
index e7ac683..4530b29 100644
--- a/drivers/ieee1394/nodemgr.h
+++ b/drivers/ieee1394/nodemgr.h
@@ -75,6 +75,7 @@ struct unit_directory {
 	struct csr1212_keyval *model_name_kv;
 	quadlet_t specifier_id;
 	quadlet_t version;
+	quadlet_t directory_id;
 
 	unsigned int id;
 
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 875eadd..3f873cc 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -194,6 +194,27 @@ MODULE_PARM_DESC(workarounds, "Work around device bugs (default = 0"
 	", override internal blacklist = " __stringify(SBP2_WORKAROUND_OVERRIDE)
 	", or a combination)");
 
+/*
+ * This influences the format of the sysfs attribute
+ * /sys/bus/scsi/devices/.../ieee1394_id.
+ *
+ * The default format is like in older kernels:  %016Lx:%d:%d
+ * It contains the target's EUI-64, a number given to the logical unit by
+ * the ieee1394 driver's nodemgr (starting at 0), and the LUN.
+ *
+ * The long format is:  %016Lx:%06x:%04x
+ * It contains the target's EUI-64, the unit directory's directory_ID as per
+ * IEEE 1212 clause 7.7.19, and the LUN.  This format comes closest to the
+ * format of SBP(-3) target port and logical unit identifier as per SAM (SCSI
+ * Architecture Model) rev.2 to 4 annex A.  Therefore and because it is
+ * independent of the implementation of the ieee1394 nodemgr, the longer format
+ * is recommended for future use.
+ */
+static int sbp2_long_sysfs_ieee1394_id;
+module_param_named(long_ieee1394_id, sbp2_long_sysfs_ieee1394_id, bool, 0644);
+MODULE_PARM_DESC(long_ieee1394_id, "8+3+2 bytes format of ieee1394_id in sysfs "
+		 "(default = backwards-compatible = N, SAM-conforming = Y)");
+
 
 #define SBP2_INFO(fmt, args...)	HPSB_INFO("sbp2: "fmt, ## args)
 #define SBP2_ERR(fmt, args...)	HPSB_ERR("sbp2: "fmt, ## args)
@@ -2100,8 +2121,14 @@ static ssize_t sbp2_sysfs_ieee1394_id_show(struct device *dev,
 	if (!(lu = (struct sbp2_lu *)sdev->host->hostdata[0]))
 		return 0;
 
-	return sprintf(buf, "%016Lx:%d:%d\n", (unsigned long long)lu->ne->guid,
-		       lu->ud->id, ORB_SET_LUN(lu->lun));
+	if (sbp2_long_sysfs_ieee1394_id)
+		return sprintf(buf, "%016Lx:%06x:%04x\n",
+				(unsigned long long)lu->ne->guid,
+				lu->ud->directory_id, ORB_SET_LUN(lu->lun));
+	else
+		return sprintf(buf, "%016Lx:%d:%d\n",
+				(unsigned long long)lu->ne->guid,
+				lu->ud->id, ORB_SET_LUN(lu->lun));
 }
 
 MODULE_AUTHOR("Ben Collins <bcollins@debian.org>");
-- 
1.5.1.6

>From 14e2198646d92ef52a69d20269580a3fbe7c996b Mon Sep 17 00:00:00 2001
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Sun, 27 May 2007 13:18:27 +0200
Subject: [PATCH] firewire: fw-sbp2: implement sysfs ieee1394_id
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

The attribute /sys/bus/scsi/devices/*:*:*:*/ieee1394_id, as generated by
the old sbp2 driver, is typically used to create persistently named
links in /dev/disk/by-id.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Kristian Høgsberg <krh@redhat.com>
---
 drivers/firewire/fw-device.h |    1 +
 drivers/firewire/fw-sbp2.c   |   53 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/firewire/fw-device.h b/drivers/firewire/fw-device.h
index 0ba9d64..af1723e 100644
--- a/drivers/firewire/fw-device.h
+++ b/drivers/firewire/fw-device.h
@@ -99,6 +99,7 @@ fw_unit(struct device *dev)
 #define CSR_DEPENDENT_INFO	0x14
 #define CSR_MODEL		0x17
 #define CSR_INSTANCE		0x18
+#define CSR_DIRECTORY_ID	0x20
 
 #define SBP2_COMMAND_SET_SPECIFIER	0x38
 #define SBP2_COMMAND_SET		0x39
diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index 6830041..a98d391 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -1108,6 +1108,58 @@ static int sbp2_scsi_abort(struct scsi_cmnd *cmd)
 	return SUCCESS;
 }
 
+/*
+ * Format of /sys/bus/scsi/devices/.../ieee1394_id:
+ * u64 EUI-64 : u24 directory_ID : u16 LUN  (all printed in hexadecimal)
+ *
+ * This is the concatenation of target port identifier and logical unit
+ * identifier as per SAM-2...SAM-4 annex A.
+ */
+static ssize_t
+sbp2_sysfs_ieee1394_id_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct sbp2_device *sd;
+	struct fw_unit *unit;
+	struct fw_device *device;
+	u32 directory_id;
+	struct fw_csr_iterator ci;
+	int key, value, lun;
+
+	if (!sdev)
+		return 0;
+	sd = (struct sbp2_device *)sdev->host->hostdata;
+	unit = sd->unit;
+	device = fw_device(unit->device.parent);
+
+	/* implicit directory ID */
+	directory_id = ((unit->directory - device->config_rom) * 4
+			+ CSR_CONFIG_ROM) & 0xffffff;
+
+	/* explicit directory ID, overrides implicit ID if present */
+	fw_csr_iterator_init(&ci, unit->directory);
+	while (fw_csr_iterator_next(&ci, &key, &value))
+		if (key == CSR_DIRECTORY_ID) {
+			directory_id = value;
+			break;
+		}
+
+	/* FIXME: Make this work for multi-lun devices. */
+	lun = 0;
+
+	return sprintf(buf, "%08x%08x:%06x:%04x\n",
+			device->config_rom[3], device->config_rom[4],
+			directory_id, lun);
+}
+
+static DEVICE_ATTR(ieee1394_id, S_IRUGO, sbp2_sysfs_ieee1394_id_show, NULL);
+
+static struct device_attribute *sbp2_scsi_sysfs_attrs[] = {
+	&dev_attr_ieee1394_id,
+	NULL
+};
+
 static struct scsi_host_template scsi_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "SBP-2 IEEE-1394",
@@ -1121,6 +1173,7 @@ static struct scsi_host_template scsi_driver_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.cmd_per_lun		= 1,
 	.can_queue		= 1,
+	.sdev_attrs		= sbp2_scsi_sysfs_attrs,
 };
 
 MODULE_AUTHOR("Kristian Hoegsberg <krh@bitplanet.net>");
-- 
1.5.1.6

>From b32744751e751e0abb184cf3b7359c9387a4bdf8 Mon Sep 17 00:00:00 2001
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Wed, 30 May 2007 20:44:52 -0400
Subject: [PATCH] firewire: add to MAINTAINERS
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Acked-by: Kristian Høgsberg <krh@redhat.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4cc17b9..f63d03a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1486,6 +1486,14 @@ P:	Alexander Viro
 M:	viro@zeniv.linux.org.uk
 S:	Maintained
 
+FIREWIRE SUBSYSTEM
+P:	Kristian Hoegsberg, Stefan Richter
+M:	krh@redhat.com, stefanr@s5r6.in-berlin.de
+L:	linux1394-devel@lists.sourceforge.net
+W:	http://www.linux1394.org/
+T:	git kernel.org:/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git
+S:	Maintained
+
 FIRMWARE LOADER (request_firmware)
 L:	linux-kernel@vger.kernel.org
 S:	Orphan
-- 
1.5.1.6

>From 2aef469a35a273609beaa7094d5a07c1f6d75285 Mon Sep 17 00:00:00 2001
From: =?utf-8?q?Kristian_H=C3=B8gsberg?= <krh@redhat.com>
Date: Wed, 30 May 2007 19:06:35 -0400
Subject: [PATCH] firewire: Implement suspend/resume PCI driver hooks.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

It's a low-impact design, that just makes suspend/resume look like
a bus reset to the upper level drivers, but it should be sufficient.

Signed-off-by: Kristian Høgsberg <krh@redhat.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c |    5 -
 drivers/firewire/fw-ohci.c |  187 +++++++++++++++++++++++++++++---------------
 2 files changed, 123 insertions(+), 69 deletions(-)

diff --git a/drivers/firewire/fw-card.c b/drivers/firewire/fw-card.c
index 636151a..9eb1eda 100644
--- a/drivers/firewire/fw-card.c
+++ b/drivers/firewire/fw-card.c
@@ -407,11 +407,6 @@ fw_card_add(struct fw_card *card,
 	card->link_speed = link_speed;
 	card->guid = guid;
 
-	/* Activate link_on bit and contender bit in our self ID packets.*/
-	if (card->driver->update_phy_reg(card, 4, 0,
-					 PHY_LINK_ACTIVE | PHY_CONTENDER) < 0)
-		return -EIO;
-
 	/*
 	 * The subsystem grabs a reference when the card is added and
 	 * drops it when the driver calls fw_core_remove_card.
diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 2e4cfa5..0d08bf9 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -417,12 +417,21 @@ ar_context_init(struct ar_context *ctx, struct fw_ohci *ohci, u32 regs)
 	ctx->current_buffer = ab.next;
 	ctx->pointer = ctx->current_buffer->data;
 
-	reg_write(ctx->ohci, COMMAND_PTR(ctx->regs),
-		  le32_to_cpu(ab.descriptor.branch_address));
+	return 0;
+}
+
+static void ar_context_run(struct ar_context *ctx)
+{
+	struct ar_buffer *ab = ctx->current_buffer;
+	dma_addr_t ab_bus;
+	size_t offset;
+
+	offset = offsetof(struct ar_buffer, data);
+	ab_bus = ab->descriptor.data_address - offset;
+
+	reg_write(ctx->ohci, COMMAND_PTR(ctx->regs), ab_bus | 1);
 	reg_write(ctx->ohci, CONTROL_SET(ctx->regs), CONTEXT_RUN);
 	flush_writes(ctx->ohci);
-
-	return 0;
 }
 
 static void context_tasklet(unsigned long data)
@@ -1039,11 +1048,78 @@ static irqreturn_t irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static int software_reset(struct fw_ohci *ohci)
+{
+	int i;
+
+	reg_write(ohci, OHCI1394_HCControlSet, OHCI1394_HCControl_softReset);
+
+	for (i = 0; i < OHCI_LOOP_COUNT; i++) {
+		if ((reg_read(ohci, OHCI1394_HCControlSet) &
+		     OHCI1394_HCControl_softReset) == 0)
+			return 0;
+		msleep(1);
+	}
+
+	return -EBUSY;
+}
+
 static int ohci_enable(struct fw_card *card, u32 *config_rom, size_t length)
 {
 	struct fw_ohci *ohci = fw_ohci(card);
 	struct pci_dev *dev = to_pci_dev(card->device);
 
+	if (software_reset(ohci)) {
+		fw_error("Failed to reset ohci card.\n");
+		return -EBUSY;
+	}
+
+	/*
+	 * Now enable LPS, which we need in order to start accessing
+	 * most of the registers.  In fact, on some cards (ALI M5251),
+	 * accessing registers in the SClk domain without LPS enabled
+	 * will lock up the machine.  Wait 50msec to make sure we have
+	 * full link enabled.
+	 */
+	reg_write(ohci, OHCI1394_HCControlSet,
+		  OHCI1394_HCControl_LPS |
+		  OHCI1394_HCControl_postedWriteEnable);
+	flush_writes(ohci);
+	msleep(50);
+
+	reg_write(ohci, OHCI1394_HCControlClear,
+		  OHCI1394_HCControl_noByteSwapData);
+
+	reg_write(ohci, OHCI1394_LinkControlSet,
+		  OHCI1394_LinkControl_rcvSelfID |
+		  OHCI1394_LinkControl_cycleTimerEnable |
+		  OHCI1394_LinkControl_cycleMaster);
+
+	reg_write(ohci, OHCI1394_ATRetries,
+		  OHCI1394_MAX_AT_REQ_RETRIES |
+		  (OHCI1394_MAX_AT_RESP_RETRIES << 4) |
+		  (OHCI1394_MAX_PHYS_RESP_RETRIES << 8));
+
+	ar_context_run(&ohci->ar_request_ctx);
+	ar_context_run(&ohci->ar_response_ctx);
+
+	reg_write(ohci, OHCI1394_SelfIDBuffer, ohci->self_id_bus);
+	reg_write(ohci, OHCI1394_PhyUpperBound, 0x00010000);
+	reg_write(ohci, OHCI1394_IntEventClear, ~0);
+	reg_write(ohci, OHCI1394_IntMaskClear, ~0);
+	reg_write(ohci, OHCI1394_IntMaskSet,
+		  OHCI1394_selfIDComplete |
+		  OHCI1394_RQPkt | OHCI1394_RSPkt |
+		  OHCI1394_reqTxComplete | OHCI1394_respTxComplete |
+		  OHCI1394_isochRx | OHCI1394_isochTx |
+		  OHCI1394_masterIntEnable |
+		  OHCI1394_cycle64Seconds);
+
+	/* Activate link_on bit and contender bit in our self ID packets.*/
+	if (ohci_update_phy_reg(card, 4, 0,
+				PHY_LINK_ACTIVE | PHY_CONTENDER) < 0)
+		return -EIO;
+
 	/*
 	 * When the link is not yet enabled, the atomic config rom
 	 * update mechanism described below in ohci_set_config_rom()
@@ -1701,22 +1777,6 @@ static const struct fw_card_driver ohci_driver = {
 	.stop_iso		= ohci_stop_iso,
 };
 
-static int software_reset(struct fw_ohci *ohci)
-{
-	int i;
-
-	reg_write(ohci, OHCI1394_HCControlSet, OHCI1394_HCControl_softReset);
-
-	for (i = 0; i < OHCI_LOOP_COUNT; i++) {
-		if ((reg_read(ohci, OHCI1394_HCControlSet) &
-		     OHCI1394_HCControl_softReset) == 0)
-			return 0;
-		msleep(1);
-	}
-
-	return -EBUSY;
-}
-
 static int __devinit
 pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 {
@@ -1762,33 +1822,6 @@ pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 		goto fail_iomem;
 	}
 
-	if (software_reset(ohci)) {
-		fw_error("Failed to reset ohci card.\n");
-		err = -EBUSY;
-		goto fail_registers;
-	}
-
-	/*
-	 * Now enable LPS, which we need in order to start accessing
-	 * most of the registers.  In fact, on some cards (ALI M5251),
-	 * accessing registers in the SClk domain without LPS enabled
-	 * will lock up the machine.  Wait 50msec to make sure we have
-	 * full link enabled.
-	 */
-	reg_write(ohci, OHCI1394_HCControlSet,
-		  OHCI1394_HCControl_LPS |
-		  OHCI1394_HCControl_postedWriteEnable);
-	flush_writes(ohci);
-	msleep(50);
-
-	reg_write(ohci, OHCI1394_HCControlClear,
-		  OHCI1394_HCControl_noByteSwapData);
-
-	reg_write(ohci, OHCI1394_LinkControlSet,
-		  OHCI1394_LinkControl_rcvSelfID |
-		  OHCI1394_LinkControl_cycleTimerEnable |
-		  OHCI1394_LinkControl_cycleMaster);
-
 	ar_context_init(&ohci->ar_request_ctx, ohci,
 			OHCI1394_AsReqRcvContextControlSet);
 
@@ -1801,11 +1834,6 @@ pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 	context_init(&ohci->at_response_ctx, ohci, AT_BUFFER_SIZE,
 		     OHCI1394_AsRspTrContextControlSet, handle_at_packet);
 
-	reg_write(ohci, OHCI1394_ATRetries,
-		  OHCI1394_MAX_AT_REQ_RETRIES |
-		  (OHCI1394_MAX_AT_RESP_RETRIES << 4) |
-		  (OHCI1394_MAX_PHYS_RESP_RETRIES << 8));
-
 	reg_write(ohci, OHCI1394_IsoRecvIntMaskSet, ~0);
 	ohci->it_context_mask = reg_read(ohci, OHCI1394_IsoRecvIntMaskSet);
 	reg_write(ohci, OHCI1394_IsoRecvIntMaskClear, ~0);
@@ -1835,18 +1863,6 @@ pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 		goto fail_registers;
 	}
 
-	reg_write(ohci, OHCI1394_SelfIDBuffer, ohci->self_id_bus);
-	reg_write(ohci, OHCI1394_PhyUpperBound, 0x00010000);
-	reg_write(ohci, OHCI1394_IntEventClear, ~0);
-	reg_write(ohci, OHCI1394_IntMaskClear, ~0);
-	reg_write(ohci, OHCI1394_IntMaskSet,
-		  OHCI1394_selfIDComplete |
-		  OHCI1394_RQPkt | OHCI1394_RSPkt |
-		  OHCI1394_reqTxComplete | OHCI1394_respTxComplete |
-		  OHCI1394_isochRx | OHCI1394_isochTx |
-		  OHCI1394_masterIntEnable |
-		  OHCI1394_cycle64Seconds);
-
 	bus_options = reg_read(ohci, OHCI1394_BusOptions);
 	max_receive = (bus_options >> 12) & 0xf;
 	link_speed = bus_options & 0x7;
@@ -1908,6 +1924,45 @@ static void pci_remove(struct pci_dev *dev)
 	fw_notify("Removed fw-ohci device.\n");
 }
 
+#ifdef CONFIG_PM
+static int pci_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct fw_ohci *ohci = pci_get_drvdata(pdev);
+	int err;
+
+	software_reset(ohci);
+	free_irq(pdev->irq, ohci);
+	err = pci_save_state(pdev);
+	if (err) {
+		fw_error("pci_save_state failed with %d", err);
+		return err;
+	}
+	err = pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	if (err) {
+		fw_error("pci_set_power_state failed with %d", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static int pci_resume(struct pci_dev *pdev)
+{
+	struct fw_ohci *ohci = pci_get_drvdata(pdev);
+	int err;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	err = pci_enable_device(pdev);
+	if (err) {
+		fw_error("pci_enable_device failed with %d", err);
+		return err;
+	}
+
+	return ohci_enable(&ohci->card, ohci->config_rom, CONFIG_ROM_SIZE);
+}
+#endif
+
 static struct pci_device_id pci_table[] = {
 	{ PCI_DEVICE_CLASS(PCI_CLASS_SERIAL_FIREWIRE_OHCI, ~0) },
 	{ }
@@ -1920,6 +1975,10 @@ static struct pci_driver fw_ohci_pci_driver = {
 	.id_table	= pci_table,
 	.probe		= pci_probe,
 	.remove		= pci_remove,
+#ifdef CONFIG_PM
+	.resume		= pci_resume,
+	.suspend	= pci_suspend,
+#endif
 };
 
 MODULE_AUTHOR("Kristian Hoegsberg <krh@bitplanet.net>");
-- 
1.5.1.6

>From 1ca31ae7cfed3e2a8e48fbf6ed6cac06495b6158 Mon Sep 17 00:00:00 2001
From: =?utf-8?q?Kristian_H=C3=B8gsberg?= <krh@redhat.com>
Date: Thu, 31 May 2007 11:16:43 -0400
Subject: [PATCH] firewire: Change struct fw_cdev_iso_packet to not use bitfields.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

The struct is part of the userspace interface and can not use
bitfields.  This patch replaces the bitfields with a __u32 'control'
word and provides access macros to set the bits.

Signed-off-by: Kristian Høgsberg <krh@redhat.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-cdev.c    |   17 ++++++++++++++++-
 include/linux/firewire-cdev.h |   14 ++++++++------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/firewire/fw-cdev.c b/drivers/firewire/fw-cdev.c
index 3ab3585..5d402d6 100644
--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -677,12 +677,21 @@ static int ioctl_create_iso_context(struct client *client, void *buffer)
 	return 0;
 }
 
+/* Macros for decoding the iso packet control header. */
+#define GET_PAYLOAD_LENGTH(v)	((v) & 0xffff)
+#define GET_INTERRUPT(v)	(((v) >> 16) & 0x01)
+#define GET_SKIP(v)		(((v) >> 17) & 0x01)
+#define GET_TAG(v)		(((v) >> 18) & 0x02)
+#define GET_SY(v)		(((v) >> 20) & 0x04)
+#define GET_HEADER_LENGTH(v)	(((v) >> 24) & 0xff)
+
 static int ioctl_queue_iso(struct client *client, void *buffer)
 {
 	struct fw_cdev_queue_iso *request = buffer;
 	struct fw_cdev_iso_packet __user *p, *end, *next;
 	struct fw_iso_context *ctx = client->iso_context;
 	unsigned long payload, buffer_end, header_length;
+	u32 control;
 	int count;
 	struct {
 		struct fw_iso_packet packet;
@@ -717,8 +726,14 @@ static int ioctl_queue_iso(struct client *client, void *buffer)
 	end = (void __user *)p + request->size;
 	count = 0;
 	while (p < end) {
-		if (__copy_from_user(&u.packet, p, sizeof(*p)))
+		if (get_user(control, &p->control))
 			return -EFAULT;
+		u.packet.payload_length = GET_PAYLOAD_LENGTH(control);
+		u.packet.interrupt = GET_INTERRUPT(control);
+		u.packet.skip = GET_SKIP(control);
+		u.packet.tag = GET_TAG(control);
+		u.packet.sy = GET_SY(control);
+		u.packet.header_length = GET_HEADER_LENGTH(control);
 
 		if (ctx->type == FW_ISO_CONTEXT_TRANSMIT) {
 			header_length = u.packet.header_length;
diff --git a/include/linux/firewire-cdev.h b/include/linux/firewire-cdev.h
index d4455eb..efbe1fd 100644
--- a/include/linux/firewire-cdev.h
+++ b/include/linux/firewire-cdev.h
@@ -198,13 +198,15 @@ struct fw_cdev_create_iso_context {
 	__u32 handle;
 };
 
+#define FW_CDEV_ISO_PAYLOAD_LENGTH(v)	(v)
+#define FW_CDEV_ISO_INTERRUPT		(1 << 16)
+#define FW_CDEV_ISO_SKIP		(1 << 17)
+#define FW_CDEV_ISO_TAG(v)		((v) << 18)
+#define FW_CDEV_ISO_SY(v)		((v) << 20)
+#define FW_CDEV_ISO_HEADER_LENGTH(v)	((v) << 24)
+
 struct fw_cdev_iso_packet {
-	__u16 payload_length;	/* Length of indirect payload. */
-	__u32 interrupt : 1;	/* Generate interrupt on this packet */
-	__u32 skip : 1;		/* Set to not send packet at all. */
-	__u32 tag : 2;
-	__u32 sy : 4;
-	__u32 header_length : 8;	/* Length of immediate header. */
+	__u32 control;
 	__u32 header[0];
 };
 
-- 
1.5.1.6

>From ca9a7af35f1ce4a990c6c3aace65ed36f89d50bf Mon Sep 17 00:00:00 2001
From: =?utf-8?q?Kristian_H=C3=B8gsberg?= <krh@redhat.com>
Date: Thu, 31 May 2007 11:36:23 -0400
Subject: [PATCH] firewire: Install firewire-constants.h and firewire-cdev.h for userspace.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

This just adds them to include/linux/Kbuild using header-y.

Signed-off-by: Kristian Høgsberg <krh@redhat.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 include/linux/Kbuild |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index e101315..f317c27 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -62,6 +62,8 @@ header-y += fadvise.h
 header-y += fd.h
 header-y += fdreg.h
 header-y += fib_rules.h
+header-y += firewire-cdev.h
+header-y += firewire-constants.h
 header-y += fuse.h
 header-y += genetlink.h
 header-y += gen_stats.h
-- 
1.5.1.6

-- 
Stefan Richter
-=====-=-=== -==- ----=
http://arcgraph.de/sr/

