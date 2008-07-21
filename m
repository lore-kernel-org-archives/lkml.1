Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbYGUTN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbYGUTN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbYGUTNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:13:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:33470 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbYGUTNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=nWWiMy5NmcwWH4G3CYq04jjFEHrSTWxGLNt98cVDo4q43rnLgYAB9dWlJOOEm92MD4
         WHYnXmFy9xCmJqnVgur2GykH50KjTNPFgqxERExIkiUmN+gLVviu7TYfkuiOKoJhZTaf
         1b1fHEIveeHq7lBo4oJ//0WSQGrvMyMczugjc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: use proper printk() KERN_* levels in ide-probe.c
Date: Mon, 21 Jul 2008 21:08:15 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807212108.15505.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it:

- fixup printk() messages in save_match() and hwif_init().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   54 ++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -141,7 +141,8 @@ static inline void do_identify (ide_driv
 	 */
 	if ((id->model[0] == 'P' && id->model[1] == 'M') ||
 	    (id->model[0] == 'S' && id->model[1] == 'K')) {
-		printk("%s: EATA SCSI HBA %.10s\n", drive->name, id->model);
+		printk(KERN_ERR "%s: EATA SCSI HBA %.10s\n",
+			drive->name, id->model);
 		goto err_misc;
 	}
 #endif /* CONFIG_SCSI_EATA || CONFIG_SCSI_EATA_PIO */
@@ -167,7 +168,8 @@ static inline void do_identify (ide_driv
 	if (strstr(id->model, "E X A B Y T E N E S T"))
 		goto err_misc;
 
-	printk("%s: %s, ", drive->name, id->model);
+	printk(KERN_INFO "%s: %s, ", drive->name, id->model);
+
 	drive->present = 1;
 	drive->dead = 0;
 
@@ -176,16 +178,17 @@ static inline void do_identify (ide_driv
 	 */
 	if (cmd == WIN_PIDENTIFY) {
 		u8 type = (id->config >> 8) & 0x1f;
-		printk("ATAPI ");
+
+		printk(KERN_CONT "ATAPI ");
 		switch (type) {
 			case ide_floppy:
 				if (!strstr(id->model, "CD-ROM")) {
 					if (!strstr(id->model, "oppy") &&
 					    !strstr(id->model, "poyp") &&
 					    !strstr(id->model, "ZIP"))
-						printk("cdrom or floppy?, assuming ");
+						printk(KERN_CONT "cdrom or floppy?, assuming ");
 					if (drive->media != ide_cdrom) {
-						printk ("FLOPPY");
+						printk(KERN_CONT "FLOPPY");
 						drive->removable = 1;
 						break;
 					}
@@ -198,25 +201,25 @@ static inline void do_identify (ide_driv
 				/* kludge for Apple PowerBook internal zip */
 				if (!strstr(id->model, "CD-ROM") &&
 				    strstr(id->model, "ZIP")) {
-					printk ("FLOPPY");
+					printk(KERN_CONT "FLOPPY");
 					type = ide_floppy;
 					break;
 				}
 #endif
-				printk ("CD/DVD-ROM");
+				printk(KERN_CONT "CD/DVD-ROM");
 				break;
 			case ide_tape:
-				printk ("TAPE");
+				printk(KERN_CONT "TAPE");
 				break;
 			case ide_optical:
-				printk ("OPTICAL");
+				printk(KERN_CONT "OPTICAL");
 				drive->removable = 1;
 				break;
 			default:
-				printk("UNKNOWN (type %d)", type);
+				printk(KERN_CONT "UNKNOWN (type %d)", type);
 				break;
 		}
-		printk (" drive\n");
+		printk(KERN_CONT " drive\n");
 		drive->media = type;
 		/* an ATAPI device ignores DRDY */
 		drive->ready_stat = 0;
@@ -236,7 +239,9 @@ static inline void do_identify (ide_driv
 		drive->removable = 1;
 
 	drive->media = ide_disk;
-	printk("%s DISK drive\n", (id->config == 0x848a) ? "CFA" : "ATA" );
+
+	printk(KERN_CONT "%s DISK drive\n",
+		(id->config == 0x848a) ? "CFA" : "ATA");
 
 	return;
 
@@ -387,7 +392,7 @@ static int try_to_identify (ide_drive_t 
 				/* Mmmm.. multiple IRQs..
 				 * don't know which was ours
 				 */
-				printk("%s: IRQ probe failed (0x%lx)\n",
+				printk(KERN_ERR "%s: IRQ probe failed (0x%lx)\n",
 					drive->name, cookie);
 			}
 		}
@@ -456,7 +461,7 @@ static int do_probe (ide_drive_t *drive,
 			return 4;
 	}
 #ifdef DEBUG
-	printk("probing for %s: present=%d, media=%d, probetype=%s\n",
+	printk(KERN_INFO "probing for %s: present=%d, media=%d, probetype=%s\n",
 		drive->name, drive->present, drive->media,
 		(cmd == WIN_IDENTIFY) ? "ATA" : "ATAPI");
 #endif
@@ -534,7 +539,8 @@ static void enable_nest (ide_drive_t *dr
 	const struct ide_tp_ops *tp_ops = hwif->tp_ops;
 	u8 stat;
 
-	printk("%s: enabling %s -- ", hwif->name, drive->id->model);
+	printk(KERN_INFO "%s: enabling %s -- ", hwif->name, drive->id->model);
+
 	SELECT_DRIVE(drive);
 	msleep(50);
 	tp_ops->exec_command(hwif, EXABYTE_ENABLE_NEST);
@@ -883,7 +889,7 @@ static void save_match(ide_hwif_t *hwif,
 	if (m && m->hwgroup && m->hwgroup != new->hwgroup) {
 		if (!new->hwgroup)
 			return;
-		printk("%s: potential irq problem with %s and %s\n",
+		printk(KERN_WARNING "%s: potential IRQ problem with %s and %s\n",
 			hwif->name, new->name, m->name);
 	}
 	if (!m || m->irq != hwif->irq) /* don't undo a prior perfect match */
@@ -1142,17 +1148,17 @@ static int init_irq (ide_hwif_t *hwif)
 	}
 
 #if !defined(__mc68000__)
-	printk("%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
+	printk(KERN_INFO "%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
 		io_ports->data_addr, io_ports->status_addr,
 		io_ports->ctl_addr, hwif->irq);
 #else
-	printk("%s at 0x%08lx on irq %d", hwif->name,
+	printk(KERN_INFO "%s at 0x%08lx on irq %d", hwif->name,
 		io_ports->data_addr, hwif->irq);
 #endif /* __mc68000__ */
 	if (match)
-		printk(" (%sed with %s)",
+		printk(KERN_CONT " (%sed with %s)",
 			hwif->sharing_irq ? "shar" : "serializ", match->name);
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	mutex_unlock(&ide_cfg_mtx);
 	return 0;
@@ -1287,7 +1293,7 @@ static int hwif_init(ide_hwif_t *hwif)
 	if (!hwif->irq) {
 		hwif->irq = __ide_default_irq(hwif->io_ports.data_addr);
 		if (!hwif->irq) {
-			printk("%s: DISABLED, NO IRQ\n", hwif->name);
+			printk(KERN_ERR "%s: disabled, no IRQ\n", hwif->name);
 			return 0;
 		}
 	}
@@ -1317,16 +1323,16 @@ static int hwif_init(ide_hwif_t *hwif)
 	 */
 	hwif->irq = __ide_default_irq(hwif->io_ports.data_addr);
 	if (!hwif->irq) {
-		printk("%s: Disabled unable to get IRQ %d.\n",
+		printk(KERN_ERR "%s: disabled, unable to get IRQ %d\n",
 			hwif->name, old_irq);
 		goto out;
 	}
 	if (init_irq(hwif)) {
-		printk("%s: probed IRQ %d and default IRQ %d failed.\n",
+		printk(KERN_ERR "%s: probed IRQ %d and default IRQ %d failed\n",
 			hwif->name, old_irq, hwif->irq);
 		goto out;
 	}
-	printk("%s: probed IRQ %d failed, using default.\n",
+	printk(KERN_WARNING "%s: probed IRQ %d failed, using default\n",
 		hwif->name, hwif->irq);
 
 done:
