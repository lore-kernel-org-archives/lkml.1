Return-Path: <linux-kernel-owner+w=401wt.eu-S1757796AbYHRU2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbYHRU2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbYHRU16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:27:58 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:26041 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYHRU1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:27:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :message-id:content-type:content-transfer-encoding;
        b=cxLR+bG/XihhWDqsoPqSbwMRlPTAiP5qyTbQJqonuCUtoY4GVAEbRf6J6jlpIEgguj
         mg3NlS74gwKpDlk7C0YNb3SQBNz+br6yb/Js+Th6rL3laUsuA+MFKmwVr9KxXzbXjTbA
         HGgHO/1Z0igvTBLqhsaEFl852U0hxsS37PBTk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 18 Aug 2008 22:22:28 +0200
Message-Id: <200808182222.28482.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Inside:

* Some IDE PCI host drivers were not using __devexit_p() properly
  (Russell King discovered it the hard way & Adrian Bunk fixed it).

* Fix audio capabilities checking in cdrom.c (from Alexander Inyukhin
  with gdrom/viocd pre-fixes from Borislav Petkov).

* Add missing ATA_* defines to <linux/ata.h>, not fixes per-se
  but since they are obvious and merging it now will save us some
  merge conflicts in linux-next lets do it now.

* Misc obvious fixups/cleanups.

* No octopus.


Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 arch/powerpc/include/asm/ide.h |   43 +-----------
 drivers/cdrom/cdrom.c          |    7 --
 drivers/cdrom/gdrom.c          |    7 ++
 drivers/cdrom/viocd.c          |    7 ++
 drivers/ide/ide-cd.c           |   20 +++---
 drivers/ide/pci/aec62xx.c      |    2 +-
 drivers/ide/pci/cy82c693.c     |    2 +-
 drivers/ide/pci/hpt366.c       |    2 +-
 drivers/ide/pci/it821x.c       |    2 +-
 drivers/ide/pci/pdc202xx_new.c |    2 +-
 drivers/ide/pci/scc_pata.c     |    2 +-
 drivers/ide/pci/sgiioc4.c      |    4 +-
 drivers/ide/pci/siimage.c      |    2 +-
 drivers/ide/pci/sis5513.c      |    2 +-
 drivers/ide/pci/tc86c001.c     |    2 +-
 drivers/ide/pci/via82cxxx.c    |    2 +-
 include/linux/ata.h            |  155 ++++++++++++++++++++++++++++------------
 17 files changed, 146 insertions(+), 117 deletions(-)


Adrian Bunk (3):
      drivers/ide/pci/: use __devexit_p()
      cleanup powerpc/include/asm/ide.h
      ide-cd: use bcd2bin/bin2bcd

Alexander Inyukhin (1):
      cdrom: handle TOC

Bartlomiej Zolnierkiewicz (4):
      sgiioc4: fixup message on resource allocation failure
      ata: add missing ATA_ID_* defines (take 2)
      ata: add missing ATA_CMD_* defines
      ata: add missing ATA_* defines

Borislav Petkov (2):
      viocd: add dummy audio ioctl handler
      gdrom: add dummy audio_ioctl handler


diff --git a/arch/powerpc/include/asm/ide.h b/arch/powerpc/include/asm/ide.h
index 048480e..da01b20 100644
--- a/arch/powerpc/include/asm/ide.h
+++ b/arch/powerpc/include/asm/ide.h
@@ -6,12 +6,7 @@
 #ifndef _ASM_POWERPC_IDE_H
 #define _ASM_POWERPC_IDE_H
 
-#ifdef __KERNEL__
-
-#ifndef __powerpc64__
-#include <linux/sched.h>
-#include <asm/mpc8xx.h>
-#endif
+#include <linux/compiler.h>
 #include <asm/io.h>
 
 #define __ide_mm_insw(p, a, c)	readsw((void __iomem *)(p), (a), (c))
@@ -19,40 +14,4 @@
 #define __ide_mm_outsw(p, a, c)	writesw((void __iomem *)(p), (a), (c))
 #define __ide_mm_outsl(p, a, c)	writesl((void __iomem *)(p), (a), (c))
 
-#ifndef  __powerpc64__
-#include <linux/ioport.h>
-
-/* FIXME: use ide_platform host driver */
-static __inline__ int ide_default_irq(unsigned long base)
-{
-#ifdef CONFIG_PPLUS
-	switch (base) {
-	case 0x1f0:	return 14;
-	case 0x170:	return 15;
-	}
-#endif
-	return 0;
-}
-
-/* FIXME: use ide_platform host driver */
-static __inline__ unsigned long ide_default_io_base(int index)
-{
-#ifdef CONFIG_PPLUS
-	switch (index) {
-	case 0:		return 0x1f0;
-	case 1:		return 0x170;
-	}
-#endif
-	return 0;
-}
-
-#ifdef CONFIG_BLK_DEV_MPC8xx_IDE
-#define IDE_ARCH_ACK_INTR  1
-#define ide_ack_intr(hwif) ((hwif)->ack_intr ? (hwif)->ack_intr(hwif) : 1)
-#endif
-
-#endif /* __powerpc64__ */
-
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_POWERPC_IDE_H */
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index d9d1b65..74031de 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -408,7 +408,6 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	ENSURE(get_last_session, CDC_MULTI_SESSION);
 	ENSURE(get_mcn, CDC_MCN);
 	ENSURE(reset, CDC_RESET);
-	ENSURE(audio_ioctl, CDC_PLAY_AUDIO);
 	ENSURE(generic_packet, CDC_GENERIC_PACKET);
 	cdi->mc_flags = 0;
 	cdo->n_minors = 0;
@@ -2506,8 +2505,6 @@ static int cdrom_ioctl_get_subchnl(struct cdrom_device_info *cdi,
 
 	/* cdinfo(CD_DO_IOCTL,"entering CDROMSUBCHNL\n");*/
 
-	if (!CDROM_CAN(CDC_PLAY_AUDIO))
-		return -ENOSYS;
 	if (copy_from_user(&q, argp, sizeof(q)))
 		return -EFAULT;
 
@@ -2538,8 +2535,6 @@ static int cdrom_ioctl_read_tochdr(struct cdrom_device_info *cdi,
 
 	/* cdinfo(CD_DO_IOCTL, "entering CDROMREADTOCHDR\n"); */
 
-	if (!CDROM_CAN(CDC_PLAY_AUDIO))
-		return -ENOSYS;
 	if (copy_from_user(&header, argp, sizeof(header)))
 		return -EFAULT;
 
@@ -2562,8 +2557,6 @@ static int cdrom_ioctl_read_tocentry(struct cdrom_device_info *cdi,
 
 	/* cdinfo(CD_DO_IOCTL, "entering CDROMREADTOCENTRY\n"); */
 
-	if (!CDROM_CAN(CDC_PLAY_AUDIO))
-		return -ENOSYS;
 	if (copy_from_user(&entry, argp, sizeof(entry)))
 		return -EFAULT;
 
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 1e0455b..1231d95 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -471,6 +471,12 @@ cleanup_sense_final:
 	return err;
 }
 
+static int gdrom_audio_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
+			     void *arg)
+{
+	return -EINVAL;
+}
+
 static struct cdrom_device_ops gdrom_ops = {
 	.open			= gdrom_open,
 	.release		= gdrom_release,
@@ -478,6 +484,7 @@ static struct cdrom_device_ops gdrom_ops = {
 	.media_changed		= gdrom_mediachanged,
 	.get_last_session	= gdrom_get_last_session,
 	.reset			= gdrom_hardreset,
+	.audio_ioctl		= gdrom_audio_ioctl,
 	.capability		= CDC_MULTI_SESSION | CDC_MEDIA_CHANGED |
 				  CDC_RESET | CDC_DRIVE_STATUS | CDC_CD_R,
 	.n_minors		= 1,
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index 9d0dfe6..031e0e1 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -550,12 +550,19 @@ return_complete:
 	}
 }
 
+static int viocd_audio_ioctl(struct cdrom_device_info *cdi, unsigned int cmd,
+			     void *arg)
+{
+	return -EINVAL;
+}
+
 static struct cdrom_device_ops viocd_dops = {
 	.open = viocd_open,
 	.release = viocd_release,
 	.media_changed = viocd_media_changed,
 	.lock_door = viocd_lock_door,
 	.generic_packet = viocd_packet,
+	.audio_ioctl = viocd_audio_ioctl,
 	.capability = CDC_CLOSE_TRAY | CDC_OPEN_TRAY | CDC_LOCK | CDC_SELECT_SPEED | CDC_SELECT_DISC | CDC_MULTI_SESSION | CDC_MCN | CDC_MEDIA_CHANGED | CDC_PLAY_AUDIO | CDC_RESET | CDC_DRIVE_STATUS | CDC_GENERIC_PACKET | CDC_CD_R | CDC_CD_RW | CDC_DVD | CDC_DVD_R | CDC_DVD_RAM | CDC_RAM
 };
 
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 89a112d..49a8c58 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1272,9 +1272,9 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
  */
 static void msf_from_bcd(struct atapi_msf *msf)
 {
-	msf->minute = BCD2BIN(msf->minute);
-	msf->second = BCD2BIN(msf->second);
-	msf->frame  = BCD2BIN(msf->frame);
+	msf->minute = bcd2bin(msf->minute);
+	msf->second = bcd2bin(msf->second);
+	msf->frame  = bcd2bin(msf->frame);
 }
 
 int cdrom_check_status(ide_drive_t *drive, struct request_sense *sense)
@@ -1415,8 +1415,8 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		return stat;
 
 	if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
-		toc->hdr.first_track = BCD2BIN(toc->hdr.first_track);
-		toc->hdr.last_track  = BCD2BIN(toc->hdr.last_track);
+		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
+		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
 	}
 
 	ntracks = toc->hdr.last_track - toc->hdr.first_track + 1;
@@ -1456,8 +1456,8 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 			return stat;
 
 		if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
-			toc->hdr.first_track = (u8)BIN2BCD(CDROM_LEADOUT);
-			toc->hdr.last_track = (u8)BIN2BCD(CDROM_LEADOUT);
+			toc->hdr.first_track = (u8)bin2bcd(CDROM_LEADOUT);
+			toc->hdr.last_track = (u8)bin2bcd(CDROM_LEADOUT);
 		} else {
 			toc->hdr.first_track = CDROM_LEADOUT;
 			toc->hdr.last_track = CDROM_LEADOUT;
@@ -1470,14 +1470,14 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	toc->hdr.toc_length = be16_to_cpu(toc->hdr.toc_length);
 
 	if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
-		toc->hdr.first_track = BCD2BIN(toc->hdr.first_track);
-		toc->hdr.last_track  = BCD2BIN(toc->hdr.last_track);
+		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
+		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
 	}
 
 	for (i = 0; i <= ntracks; i++) {
 		if (drive->atapi_flags & IDE_AFLAG_TOCADDR_AS_BCD) {
 			if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD)
-				toc->ent[i].track = BCD2BIN(toc->ent[i].track);
+				toc->ent[i].track = bcd2bin(toc->ent[i].track);
 			msf_from_bcd(&toc->ent[i].addr.msf);
 		}
 		toc->ent[i].addr.lba = msf_to_lba(toc->ent[i].addr.msf.minute,
diff --git a/drivers/ide/pci/aec62xx.c b/drivers/ide/pci/aec62xx.c
index 40644b6..3187215 100644
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -307,7 +307,7 @@ static struct pci_driver driver = {
 	.name		= "AEC62xx_IDE",
 	.id_table	= aec62xx_pci_tbl,
 	.probe		= aec62xx_init_one,
-	.remove		= aec62xx_remove,
+	.remove		= __devexit_p(aec62xx_remove),
 };
 
 static int __init aec62xx_ide_init(void)
diff --git a/drivers/ide/pci/cy82c693.c b/drivers/ide/pci/cy82c693.c
index bfae2f8..e6d8ee8 100644
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -447,7 +447,7 @@ static struct pci_driver driver = {
 	.name		= "Cypress_IDE",
 	.id_table	= cy82c693_pci_tbl,
 	.probe		= cy82c693_init_one,
-	.remove		= cy82c693_remove,
+	.remove		= __devexit_p(cy82c693_remove),
 };
 
 static int __init cy82c693_ide_init(void)
diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 748793a..eb107ee 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1620,7 +1620,7 @@ static struct pci_driver driver = {
 	.name		= "HPT366_IDE",
 	.id_table	= hpt366_pci_tbl,
 	.probe		= hpt366_init_one,
-	.remove		= hpt366_remove,
+	.remove		= __devexit_p(hpt366_remove),
 };
 
 static int __init hpt366_ide_init(void)
diff --git a/drivers/ide/pci/it821x.c b/drivers/ide/pci/it821x.c
index b6dc723..4a1508a 100644
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -686,7 +686,7 @@ static struct pci_driver driver = {
 	.name		= "ITE821x IDE",
 	.id_table	= it821x_pci_tbl,
 	.probe		= it821x_init_one,
-	.remove		= it821x_remove,
+	.remove		= __devexit_p(it821x_remove),
 };
 
 static int __init it821x_ide_init(void)
diff --git a/drivers/ide/pci/pdc202xx_new.c b/drivers/ide/pci/pdc202xx_new.c
index 0f609b7..d477da6 100644
--- a/drivers/ide/pci/pdc202xx_new.c
+++ b/drivers/ide/pci/pdc202xx_new.c
@@ -566,7 +566,7 @@ static struct pci_driver driver = {
 	.name		= "Promise_IDE",
 	.id_table	= pdc202new_pci_tbl,
 	.probe		= pdc202new_init_one,
-	.remove		= pdc202new_remove,
+	.remove		= __devexit_p(pdc202new_remove),
 };
 
 static int __init pdc202new_ide_init(void)
diff --git a/drivers/ide/pci/scc_pata.c b/drivers/ide/pci/scc_pata.c
index 6cde48b..44cccd1 100644
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -954,7 +954,7 @@ static struct pci_driver driver = {
 	.name = "SCC IDE",
 	.id_table = scc_pci_tbl,
 	.probe = scc_init_one,
-	.remove = scc_remove,
+	.remove = __devexit_p(scc_remove),
 };
 
 static int scc_ide_init(void)
diff --git a/drivers/ide/pci/sgiioc4.c b/drivers/ide/pci/sgiioc4.c
index 42eef19..681306c 100644
--- a/drivers/ide/pci/sgiioc4.c
+++ b/drivers/ide/pci/sgiioc4.c
@@ -621,9 +621,9 @@ sgiioc4_ide_setup_pci_device(struct pci_dev *dev)
 	if (!request_mem_region(cmd_phys_base, IOC4_CMD_CTL_BLK_SIZE,
 	    DRV_NAME)) {
 		printk(KERN_ERR
-			"%s : %s -- ERROR, Addresses "
+			"%s %s: -- ERROR, Addresses "
 			"0x%p to 0x%p ALREADY in use\n",
-		       __func__, DRV_NAME, (void *) cmd_phys_base,
+		       DRV_NAME, pci_name(dev), (void *)cmd_phys_base,
 		       (void *) cmd_phys_base + IOC4_CMD_CTL_BLK_SIZE);
 		return -ENOMEM;
 	}
diff --git a/drivers/ide/pci/siimage.c b/drivers/ide/pci/siimage.c
index 445ce6f..db2b88a 100644
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -832,7 +832,7 @@ static struct pci_driver driver = {
 	.name		= "SiI_IDE",
 	.id_table	= siimage_pci_tbl,
 	.probe		= siimage_init_one,
-	.remove		= siimage_remove,
+	.remove		= __devexit_p(siimage_remove),
 };
 
 static int __init siimage_ide_init(void)
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index e5a4b42..5efe21d 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -610,7 +610,7 @@ static struct pci_driver driver = {
 	.name		= "SIS_IDE",
 	.id_table	= sis5513_pci_tbl,
 	.probe		= sis5513_init_one,
-	.remove		= sis5513_remove,
+	.remove		= __devexit_p(sis5513_remove),
 };
 
 static int __init sis5513_ide_init(void)
diff --git a/drivers/ide/pci/tc86c001.c b/drivers/ide/pci/tc86c001.c
index 7fc88c3..927277c 100644
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -249,7 +249,7 @@ static struct pci_driver driver = {
 	.name		= "TC86C001",
 	.id_table	= tc86c001_pci_tbl,
 	.probe		= tc86c001_init_one,
-	.remove		= tc86c001_remove,
+	.remove		= __devexit_p(tc86c001_remove),
 };
 
 static int __init tc86c001_ide_init(void)
diff --git a/drivers/ide/pci/via82cxxx.c b/drivers/ide/pci/via82cxxx.c
index a6b2cc8..94fb9ab 100644
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -491,7 +491,7 @@ static struct pci_driver driver = {
 	.name 		= "VIA_IDE",
 	.id_table 	= via_pci_tbl,
 	.probe 		= via_init_one,
-	.remove		= via_remove,
+	.remove		= __devexit_p(via_remove),
 };
 
 static int __init via_ide_init(void)
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 1c622e2..1ce19c1 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -46,18 +46,48 @@ enum {
 	ATA_MAX_SECTORS_TAPE	= 65535,
 
 	ATA_ID_WORDS		= 256,
+	ATA_ID_CONFIG		= 0,
+	ATA_ID_CYLS		= 1,
+	ATA_ID_HEADS		= 3,
+	ATA_ID_SECTORS		= 6,
 	ATA_ID_SERNO		= 10,
+	ATA_ID_BUF_SIZE		= 21,
 	ATA_ID_FW_REV		= 23,
 	ATA_ID_PROD		= 27,
+	ATA_ID_MAX_MULTSECT	= 47,
+	ATA_ID_DWORD_IO		= 48,
+	ATA_ID_CAPABILITY	= 49,
 	ATA_ID_OLD_PIO_MODES	= 51,
+	ATA_ID_OLD_DMA_MODES	= 52,
 	ATA_ID_FIELD_VALID	= 53,
+	ATA_ID_CUR_CYLS		= 54,
+	ATA_ID_CUR_HEADS	= 55,
+	ATA_ID_CUR_SECTORS	= 56,
+	ATA_ID_MULTSECT		= 59,
+	ATA_ID_LBA_CAPACITY	= 60,
+	ATA_ID_SWDMA_MODES	= 62,
 	ATA_ID_MWDMA_MODES	= 63,
 	ATA_ID_PIO_MODES	= 64,
 	ATA_ID_EIDE_DMA_MIN	= 65,
+	ATA_ID_EIDE_DMA_TIME	= 66,
 	ATA_ID_EIDE_PIO		= 67,
 	ATA_ID_EIDE_PIO_IORDY	= 68,
-	ATA_ID_UDMA_MODES	= 88,
+	ATA_ID_QUEUE_DEPTH	= 75,
 	ATA_ID_MAJOR_VER	= 80,
+	ATA_ID_COMMAND_SET_1	= 82,
+	ATA_ID_COMMAND_SET_2	= 83,
+	ATA_ID_CFSSE		= 84,
+	ATA_ID_CFS_ENABLE_1	= 85,
+	ATA_ID_CFS_ENABLE_2	= 86,
+	ATA_ID_CSF_DEFAULT	= 87,
+	ATA_ID_UDMA_MODES	= 88,
+	ATA_ID_HW_CONFIG	= 93,
+	ATA_ID_SPG		= 98,
+	ATA_ID_LBA_CAPACITY_2	= 100,
+	ATA_ID_LAST_LUN		= 126,
+	ATA_ID_DLF		= 128,
+	ATA_ID_CSFO		= 129,
+	ATA_ID_CFA_POWER	= 160,
 	ATA_ID_PIO4		= (1 << 1),
 
 	ATA_ID_SERNO_LEN	= 20,
@@ -123,13 +153,26 @@ enum {
 	ATA_BUSY		= (1 << 7),	/* BSY status bit */
 	ATA_DRDY		= (1 << 6),	/* device ready */
 	ATA_DF			= (1 << 5),	/* device fault */
+	ATA_DSC			= (1 << 4),	/* drive seek complete */
 	ATA_DRQ			= (1 << 3),	/* data request i/o */
+	ATA_CORR		= (1 << 2),	/* corrected data error */
+	ATA_IDX			= (1 << 1),	/* index */
 	ATA_ERR			= (1 << 0),	/* have an error */
 	ATA_SRST		= (1 << 2),	/* software reset */
 	ATA_ICRC		= (1 << 7),	/* interface CRC error */
+	ATA_BBK			= ATA_ICRC,	/* pre-EIDE: block marked bad */
 	ATA_UNC			= (1 << 6),	/* uncorrectable media error */
+	ATA_MC			= (1 << 5),	/* media changed */
 	ATA_IDNF		= (1 << 4),	/* ID not found */
+	ATA_MCR			= (1 << 3),	/* media change requested */
 	ATA_ABORTED		= (1 << 2),	/* command aborted */
+	ATA_TRK0NF		= (1 << 1),	/* track 0 not found */
+	ATA_AMNF		= (1 << 0),	/* address mark not found */
+	ATAPI_LFS		= 0xF0,		/* last failed sense */
+	ATAPI_EOM		= ATA_TRK0NF,	/* end of media */
+	ATAPI_ILI		= ATA_AMNF,	/* illegal length indication */
+	ATAPI_IO		= (1 << 1),
+	ATAPI_COD		= (1 << 0),
 
 	/* ATA command block registers */
 	ATA_REG_DATA		= 0x00,
@@ -192,6 +235,13 @@ enum {
 	ATA_CMD_PMP_WRITE	= 0xE8,
 	ATA_CMD_CONF_OVERLAY	= 0xB1,
 	ATA_CMD_SEC_FREEZE_LOCK	= 0xF5,
+	ATA_CMD_SMART		= 0xB0,
+	ATA_CMD_MEDIA_LOCK	= 0xDE,
+	ATA_CMD_MEDIA_UNLOCK	= 0xDF,
+	/* marked obsolete in the ATA/ATAPI-7 spec */
+	ATA_CMD_RESTORE		= 0x10,
+	/* EXABYTE specific */
+	ATA_EXABYTE_ENABLE_NEST	= 0xF0,
 
 	/* READ_LOG_EXT pages */
 	ATA_LOG_SATA_NCQ	= 0x10,
@@ -232,6 +282,10 @@ enum {
 	SETFEATURES_WC_ON	= 0x02, /* Enable write cache */
 	SETFEATURES_WC_OFF	= 0x82, /* Disable write cache */
 
+	/* Enable/Disable Automatic Acoustic Management */
+	SETFEATURES_AAM_ON	= 0x42,
+	SETFEATURES_AAM_OFF	= 0xC2,
+
 	SETFEATURES_SPINUP	= 0x07, /* Spin-up drive */
 
 	SETFEATURES_SATA_ENABLE = 0x10, /* Enable use of SATA feature */
@@ -254,6 +308,15 @@ enum {
 	ATA_DCO_IDENTIFY	= 0xC2,
 	ATA_DCO_SET		= 0xC3,
 
+	/* feature values for SMART */
+	ATA_SMART_ENABLE	= 0xD8,
+	ATA_SMART_READ_VALUES	= 0xD0,
+	ATA_SMART_READ_THRESHOLDS = 0xD1,
+
+	/* password used in LBA Mid / LBA High for executing SMART commands */
+	ATA_SMART_LBAM_PASS	= 0x4F,
+	ATA_SMART_LBAH_PASS	= 0xC2,
+
 	/* ATAPI stuff */
 	ATAPI_PKT_DMA		= (1 << 0),
 	ATAPI_DMADIR		= (1 << 2),	/* ATAPI data dir:
@@ -438,17 +501,17 @@ static inline int ata_is_data(u8 prot)
 /*
  * id tests
  */
-#define ata_id_is_ata(id)	(((id)[0] & (1 << 15)) == 0)
-#define ata_id_has_lba(id)	((id)[49] & (1 << 9))
-#define ata_id_has_dma(id)	((id)[49] & (1 << 8))
+#define ata_id_is_ata(id)	(((id)[ATA_ID_CONFIG] & (1 << 15)) == 0)
+#define ata_id_has_lba(id)	((id)[ATA_ID_CAPABILITY] & (1 << 9))
+#define ata_id_has_dma(id)	((id)[ATA_ID_CAPABILITY] & (1 << 8))
 #define ata_id_has_ncq(id)	((id)[76] & (1 << 8))
-#define ata_id_queue_depth(id)	(((id)[75] & 0x1f) + 1)
-#define ata_id_removeable(id)	((id)[0] & (1 << 7))
+#define ata_id_queue_depth(id)	(((id)[ATA_ID_QUEUE_DEPTH] & 0x1f) + 1)
+#define ata_id_removeable(id)	((id)[ATA_ID_CONFIG] & (1 << 7))
 #define ata_id_has_atapi_AN(id)	\
 	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
 	  ((id)[78] & (1 << 5)) )
-#define ata_id_iordy_disable(id) ((id)[49] & (1 << 10))
-#define ata_id_has_iordy(id) ((id)[49] & (1 << 11))
+#define ata_id_iordy_disable(id) ((id)[ATA_ID_CAPABILITY] & (1 << 10))
+#define ata_id_has_iordy(id) ((id)[ATA_ID_CAPABILITY] & (1 << 11))
 #define ata_id_u32(id,n)	\
 	(((u32) (id)[(n) + 1] << 16) | ((u32) (id)[(n)]))
 #define ata_id_u64(id,n)	\
@@ -457,7 +520,7 @@ static inline int ata_is_data(u8 prot)
 	  ((u64) (id)[(n) + 1] << 16) |	\
 	  ((u64) (id)[(n) + 0]) )
 
-#define ata_id_cdb_intr(id)	(((id)[0] & 0x60) == 0x20)
+#define ata_id_cdb_intr(id)	(((id)[ATA_ID_CONFIG] & 0x60) == 0x20)
 
 static inline bool ata_id_has_hipm(const u16 *id)
 {
@@ -482,75 +545,75 @@ static inline bool ata_id_has_dipm(const u16 *id)
 
 static inline int ata_id_has_fua(const u16 *id)
 {
-	if ((id[84] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_CFSSE] & 0xC000) != 0x4000)
 		return 0;
-	return id[84] & (1 << 6);
+	return id[ATA_ID_CFSSE] & (1 << 6);
 }
 
 static inline int ata_id_has_flush(const u16 *id)
 {
-	if ((id[83] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
 		return 0;
-	return id[83] & (1 << 12);
+	return id[ATA_ID_COMMAND_SET_2] & (1 << 12);
 }
 
 static inline int ata_id_has_flush_ext(const u16 *id)
 {
-	if ((id[83] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
 		return 0;
-	return id[83] & (1 << 13);
+	return id[ATA_ID_COMMAND_SET_2] & (1 << 13);
 }
 
 static inline int ata_id_has_lba48(const u16 *id)
 {
-	if ((id[83] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
 		return 0;
-	if (!ata_id_u64(id, 100))
+	if (!ata_id_u64(id, ATA_ID_LBA_CAPACITY_2))
 		return 0;
-	return id[83] & (1 << 10);
+	return id[ATA_ID_COMMAND_SET_2] & (1 << 10);
 }
 
 static inline int ata_id_hpa_enabled(const u16 *id)
 {
 	/* Yes children, word 83 valid bits cover word 82 data */
-	if ((id[83] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
 		return 0;
 	/* And 87 covers 85-87 */
-	if ((id[87] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
 		return 0;
 	/* Check command sets enabled as well as supported */
-	if ((id[85] & ( 1 << 10)) == 0)
+	if ((id[ATA_ID_CFS_ENABLE_1] & (1 << 10)) == 0)
 		return 0;
-	return id[82] & (1 << 10);
+	return id[ATA_ID_COMMAND_SET_1] & (1 << 10);
 }
 
 static inline int ata_id_has_wcache(const u16 *id)
 {
 	/* Yes children, word 83 valid bits cover word 82 data */
-	if ((id[83] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
 		return 0;
-	return id[82] & (1 << 5);
+	return id[ATA_ID_COMMAND_SET_1] & (1 << 5);
 }
 
 static inline int ata_id_has_pm(const u16 *id)
 {
-	if ((id[83] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
 		return 0;
-	return id[82] & (1 << 3);
+	return id[ATA_ID_COMMAND_SET_1] & (1 << 3);
 }
 
 static inline int ata_id_rahead_enabled(const u16 *id)
 {
-	if ((id[87] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
 		return 0;
-	return id[85] & (1 << 6);
+	return id[ATA_ID_CFS_ENABLE_1] & (1 << 6);
 }
 
 static inline int ata_id_wcache_enabled(const u16 *id)
 {
-	if ((id[87] & 0xC000) != 0x4000)
+	if ((id[ATA_ID_CSF_DEFAULT] & 0xC000) != 0x4000)
 		return 0;
-	return id[85] & (1 << 5);
+	return id[ATA_ID_CFS_ENABLE_1] & (1 << 5);
 }
 
 /**
@@ -581,7 +644,7 @@ static inline unsigned int ata_id_major_version(const u16 *id)
 
 static inline int ata_id_is_sata(const u16 *id)
 {
-	return ata_id_major_version(id) >= 5 && id[93] == 0;
+	return ata_id_major_version(id) >= 5 && id[ATA_ID_HW_CONFIG] == 0;
 }
 
 static inline int ata_id_has_tpm(const u16 *id)
@@ -599,7 +662,7 @@ static inline int ata_id_has_dword_io(const u16 *id)
 	/* ATA 8 reuses this flag for "trusted" computing */
 	if (ata_id_major_version(id) > 7)
 		return 0;
-	if (id[48] & (1 << 0))
+	if (id[ATA_ID_DWORD_IO] & (1 << 0))
 		return 1;
 	return 0;
 }
@@ -608,22 +671,22 @@ static inline int ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command
 	   has not been issued to the device then the values of
-	   id[54] to id[56] are vendor specific. */
-	return (id[53] & 0x01) && /* Current translation valid */
-		id[54] &&  /* cylinders in current translation */
-		id[55] &&  /* heads in current translation */
-		id[55] <= 16 &&
-		id[56];    /* sectors in current translation */
+	   id[ATA_ID_CUR_CYLS] to id[ATA_ID_CUR_SECTORS] are vendor specific. */
+	return (id[ATA_ID_FIELD_VALID] & 1) && /* Current translation valid */
+		id[ATA_ID_CUR_CYLS] &&  /* cylinders in current translation */
+		id[ATA_ID_CUR_HEADS] &&  /* heads in current translation */
+		id[ATA_ID_CUR_HEADS] <= 16 &&
+		id[ATA_ID_CUR_SECTORS];    /* sectors in current translation */
 }
 
 static inline int ata_id_is_cfa(const u16 *id)
 {
-	u16 v = id[0];
-	if (v == 0x848A)	/* Standard CF */
+	if (id[ATA_ID_CONFIG] == 0x848A)	/* Standard CF */
 		return 1;
 	/* Could be CF hiding as standard ATA */
-	if (ata_id_major_version(id) >= 3 &&  id[82] != 0xFFFF &&
-			(id[82] & ( 1 << 2)))
+	if (ata_id_major_version(id) >= 3 &&
+	    id[ATA_ID_COMMAND_SET_1] != 0xFFFF &&
+	   (id[ATA_ID_COMMAND_SET_1] & (1 << 2)))
 		return 1;
 	return 0;
 }
@@ -632,21 +695,21 @@ static inline int ata_drive_40wire(const u16 *dev_id)
 {
 	if (ata_id_is_sata(dev_id))
 		return 0;	/* SATA */
-	if ((dev_id[93] & 0xE000) == 0x6000)
+	if ((dev_id[ATA_ID_HW_CONFIG] & 0xE000) == 0x6000)
 		return 0;	/* 80 wire */
 	return 1;
 }
 
 static inline int ata_drive_40wire_relaxed(const u16 *dev_id)
 {
-	if ((dev_id[93] & 0x2000) == 0x2000)
+	if ((dev_id[ATA_ID_HW_CONFIG] & 0x2000) == 0x2000)
 		return 0;	/* 80 wire */
 	return 1;
 }
 
 static inline int atapi_cdb_len(const u16 *dev_id)
 {
-	u16 tmp = dev_id[0] & 0x3;
+	u16 tmp = dev_id[ATA_ID_CONFIG] & 0x3;
 	switch (tmp) {
 	case 0:		return 12;
 	case 1:		return 16;
@@ -656,7 +719,7 @@ static inline int atapi_cdb_len(const u16 *dev_id)
 
 static inline int atapi_command_packet_set(const u16 *dev_id)
 {
-	return (dev_id[0] >> 8) & 0x1f;
+	return (dev_id[ATA_ID_CONFIG] >> 8) & 0x1f;
 }
 
 static inline int atapi_id_dmadir(const u16 *dev_id)
