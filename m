Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbZEVPN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbZEVPN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 11:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756954AbZEVPNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 11:13:18 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:46215 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZEVPNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 11:13:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=s1/jns112QxR4gl5AnNvJ2v55AL2hYmcowb60iUCIHSLqhgfusTVFHJHAQiJZH3INB
         6m5EJjIXfSjxjOMr/WWXAnN8zYJbvXpl8548YH7EysoNefz2CMD2+cUabbXr/qZvzxSo
         sdHVM5qEbdSD8Azn2x+szY00BX18Qv1LTrWKc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 22 May 2009 17:17:40 +0200
Message-Id: <200905221717.41481.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Fix for ide-cd error recovery OOPS, workaround for broken cable
detection on TSST SH-S202* ATAPI devices, improvements to error
reporting and addition of VIA VX855/VX875 IDE support.


Linus, please pull from 'for-linus' branch of:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git for-linus

to receive the following updates:

 drivers/ide/ide-io.c    |    4 ++--
 drivers/ide/ide-iops.c  |   21 +++++++++++++++++----
 drivers/ide/ide-lib.c   |   27 ++++++---------------------
 drivers/ide/ide-probe.c |    9 ++++++---
 drivers/ide/via82cxxx.c |    2 ++
 include/linux/ide.h     |    2 +-
 include/linux/pci_ids.h |    2 +-
 7 files changed, 35 insertions(+), 32 deletions(-)


Bartlomiej Zolnierkiewicz (5):
      ide: fix 40-wire cable detection for TSST SH-S202* ATAPI devices (v2)
      ide: fix OOPS during ide-cd error recovery
      ide: fix printk() levels in ide_dump_ata[pi]_error()
      ide: improve failed opcode reporting
      ide: report timeouts in ide_busy_sleep()

Harald Welte (1):
      via82cxxx: Add VIA VX855 PCI Device ID


diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 35dc38d..6415a2e 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -696,7 +696,7 @@ void ide_timer_expiry (unsigned long data)
 		}
 		spin_lock_irq(&hwif->lock);
 		enable_irq(hwif->irq);
-		if (startstop == ide_stopped) {
+		if (startstop == ide_stopped && hwif->polling == 0) {
 			ide_unlock_port(hwif);
 			plug_device = 1;
 		}
@@ -868,7 +868,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
 	 * same irq as is currently being serviced here, and Linux
 	 * won't allow another of the same (on any CPU) until we return.
 	 */
-	if (startstop == ide_stopped) {
+	if (startstop == ide_stopped && hwif->polling == 0) {
 		BUG_ON(hwif->handler);
 		ide_unlock_port(hwif);
 		plug_device = 1;
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index c19a221..06fe002 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -206,8 +206,6 @@ EXPORT_SYMBOL_GPL(ide_in_drive_list);
 
 /*
  * Early UDMA66 devices don't set bit14 to 1, only bit13 is valid.
- * We list them here and depend on the device side cable detection for them.
- *
  * Some optical devices with the buggy firmwares have the same problem.
  */
 static const struct drive_list_entry ivb_list[] = {
@@ -251,10 +249,25 @@ u8 eighty_ninty_three(ide_drive_t *drive)
 	 * - force bit13 (80c cable present) check also for !ivb devices
 	 *   (unless the slave device is pre-ATA3)
 	 */
-	if ((id[ATA_ID_HW_CONFIG] & 0x4000) ||
-	    (ivb && (id[ATA_ID_HW_CONFIG] & 0x2000)))
+	if (id[ATA_ID_HW_CONFIG] & 0x4000)
 		return 1;
 
+	if (ivb) {
+		const char *model = (char *)&id[ATA_ID_PROD];
+
+		if (strstr(model, "TSSTcorp CDDVDW SH-S202")) {
+			/*
+			 * These ATAPI devices always report 80c cable
+			 * so we have to depend on the host in this case.
+			 */
+			if (hwif->cbl == ATA_CBL_PATA80)
+				return 1;
+		} else {
+			/* Depend on the device side cable detection. */
+			if (id[ATA_ID_HW_CONFIG] & 0x2000)
+				return 1;
+		}
+	}
 no_80w:
 	if (drive->dev_flags & IDE_DFLAG_UDMA33_WARNED)
 		return 0;
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 56ff8c4..2148df8 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -31,24 +31,6 @@ void ide_toggle_bounce(ide_drive_t *drive, int on)
 		blk_queue_bounce_limit(drive->queue, addr);
 }
 
-static void ide_dump_opcode(ide_drive_t *drive)
-{
-	struct request *rq = drive->hwif->rq;
-	struct ide_cmd *cmd = NULL;
-
-	if (!rq)
-		return;
-
-	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
-		cmd = rq->special;
-
-	printk(KERN_ERR "ide: failed opcode was: ");
-	if (cmd == NULL)
-		printk(KERN_CONT "unknown\n");
-	else
-		printk(KERN_CONT "0x%02x\n", cmd->tf.command);
-}
-
 u64 ide_get_lba_addr(struct ide_cmd *cmd, int lba48)
 {
 	struct ide_taskfile *tf = &cmd->tf;
@@ -91,7 +73,7 @@ static void ide_dump_sector(ide_drive_t *drive)
 
 static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 {
-	printk(KERN_ERR "{ ");
+	printk(KERN_CONT "{ ");
 	if (err & ATA_ABORTED)
 		printk(KERN_CONT "DriveStatusError ");
 	if (err & ATA_ICRC)
@@ -121,7 +103,7 @@ static void ide_dump_ata_error(ide_drive_t *drive, u8 err)
 
 static void ide_dump_atapi_error(ide_drive_t *drive, u8 err)
 {
-	printk(KERN_ERR "{ ");
+	printk(KERN_CONT "{ ");
 	if (err & ATAPI_ILI)
 		printk(KERN_CONT "IllegalLengthIndication ");
 	if (err & ATAPI_EOM)
@@ -179,7 +161,10 @@ u8 ide_dump_status(ide_drive_t *drive, const char *msg, u8 stat)
 		else
 			ide_dump_atapi_error(drive, err);
 	}
-	ide_dump_opcode(drive);
+
+	printk(KERN_ERR "%s: possibly failed opcode: 0x%02x\n",
+		drive->name, drive->hwif->cmd.tf.command);
+
 	return err;
 }
 EXPORT_SYMBOL(ide_dump_status);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 7f264ed..c895ed5 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -295,7 +295,7 @@ int ide_dev_read_id(ide_drive_t *drive, u8 cmd, u16 *id)
 
 	timeout = ((cmd == ATA_CMD_ID_ATA) ? WAIT_WORSTCASE : WAIT_PIDENTIFY) / 2;
 
-	if (ide_busy_sleep(hwif, timeout, use_altstatus))
+	if (ide_busy_sleep(drive, timeout, use_altstatus))
 		return 1;
 
 	/* wait for IRQ and ATA_DRQ */
@@ -316,8 +316,9 @@ int ide_dev_read_id(ide_drive_t *drive, u8 cmd, u16 *id)
 	return rc;
 }
 
-int ide_busy_sleep(ide_hwif_t *hwif, unsigned long timeout, int altstatus)
+int ide_busy_sleep(ide_drive_t *drive, unsigned long timeout, int altstatus)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	u8 stat;
 
 	timeout += jiffies;
@@ -330,6 +331,8 @@ int ide_busy_sleep(ide_hwif_t *hwif, unsigned long timeout, int altstatus)
 			return 0;
 	} while (time_before(jiffies, timeout));
 
+	printk(KERN_ERR "%s: timeout in %s\n", drive->name, __func__);
+
 	return 1;	/* drive timed-out */
 }
 
@@ -420,7 +423,7 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
 			tp_ops->dev_select(drive);
 			msleep(50);
 			tp_ops->exec_command(hwif, ATA_CMD_DEV_RESET);
-			(void)ide_busy_sleep(hwif, WAIT_WORSTCASE, 0);
+			(void)ide_busy_sleep(drive, WAIT_WORSTCASE, 0);
 			rc = ide_dev_read_id(drive, cmd, id);
 		}
 
diff --git a/drivers/ide/via82cxxx.c b/drivers/ide/via82cxxx.c
index 3ff7231..028de26 100644
--- a/drivers/ide/via82cxxx.c
+++ b/drivers/ide/via82cxxx.c
@@ -67,6 +67,7 @@ static struct via_isa_bridge {
 	u8 udma_mask;
 	u8 flags;
 } via_isa_bridges[] = {
+	{ "vx855",	PCI_DEVICE_ID_VIA_VX855,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
@@ -474,6 +475,7 @@ static const struct pci_device_id via_pci_tbl[] = {
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_82C576_1),  0 },
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_82C586_1),  0 },
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_CX700_IDE), 0 },
+	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_VX855_IDE), 0 },
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_6410),      1 },
 	{ PCI_VDEVICE(VIA, PCI_DEVICE_ID_VIA_SATA_EIDE), 1 },
 	{ 0, },
diff --git a/include/linux/ide.h b/include/linux/ide.h
index ff65fff..9fed365 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1109,7 +1109,7 @@ void ide_fix_driveid(u16 *);
 
 extern void ide_fixstring(u8 *, const int, const int);
 
-int ide_busy_sleep(ide_hwif_t *, unsigned long, int);
+int ide_busy_sleep(ide_drive_t *, unsigned long, int);
 
 int ide_wait_stat(ide_startstop_t *, ide_drive_t *, u8, u8, unsigned long);
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 06ba90c..0f71812 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1406,7 +1406,7 @@
 #define PCI_DEVICE_ID_VIA_82C598_1	0x8598
 #define PCI_DEVICE_ID_VIA_838X_1	0xB188
 #define PCI_DEVICE_ID_VIA_83_87XX_1	0xB198
-#define PCI_DEVICE_ID_VIA_C409_IDE	0XC409
+#define PCI_DEVICE_ID_VIA_VX855_IDE	0xC409
 #define PCI_DEVICE_ID_VIA_ANON		0xFFFF
 
 #define PCI_VENDOR_ID_SIEMENS           0x110A
