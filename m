Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbYD2GZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbYD2GZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYD2GZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:25:13 -0400
Received: from havoc.gtf.org ([69.61.125.42]:54416 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbYD2GZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:25:06 -0400
Date: Tue, 29 Apr 2008 02:25:03 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20080429062503.GA7489@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig                              |    8 +-
 drivers/ata/Makefile                             |    2 +-
 drivers/ata/libata-scsi.c                        |  507 +++++++---------------
 drivers/ata/libata.h                             |   28 --
 drivers/ata/pata_bf54x.c                         |  124 +++++-
 drivers/ata/{pata_rb500_cf.c => pata_rb532_cf.c} |   78 ++--
 drivers/ata/sata_mv.c                            |   77 ++--
 7 files changed, 365 insertions(+), 459 deletions(-)
 rename drivers/ata/{pata_rb500_cf.c => pata_rb532_cf.c} (72%)

Mark Lord (1):
      sata_mv: Improve naming of main_irq cause/mask identifiers

Ralf Baechle (1):
      [MIPS] ATA: Rename routerboard 500 to 532

Sonic Zhang (1):
      Fix bug - Implement bfin ata interrupt handler to avoid "irq 68 nobody cared" (v2)

Tejun Heo (2):
      libata-scsi: clean up inquiry / mode sense related functions
      libata-scsi: improve rbuf handling for simulated commands

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 292aa9a..1c11df9 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -566,11 +566,11 @@ config PATA_RADISYS
 
 	  If unsure, say N.
 
-config PATA_RB500
-	tristate "RouterBoard 500 PATA CompactFlash support"
-	depends on MIKROTIK_RB500
+config PATA_RB532
+	tristate "RouterBoard 532 PATA CompactFlash support"
+	depends on MIKROTIK_RB532
 	help
-	  This option enables support for the RouterBoard 500
+	  This option enables support for the RouterBoard 532
 	  PATA CompactFlash controller.
 
 	  If unsure, say N.
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 1fbc2aa..b693d82 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -55,7 +55,7 @@ obj-$(CONFIG_PATA_PDC2027X)	+= pata_pdc2027x.o
 obj-$(CONFIG_PATA_PDC_OLD)	+= pata_pdc202xx_old.o
 obj-$(CONFIG_PATA_QDI)		+= pata_qdi.o
 obj-$(CONFIG_PATA_RADISYS)	+= pata_radisys.o
-obj-$(CONFIG_PATA_RB500)	+= pata_rb500_cf.o
+obj-$(CONFIG_PATA_RB532)	+= pata_rb532_cf.o
 obj-$(CONFIG_PATA_RZ1000)	+= pata_rz1000.o
 obj-$(CONFIG_PATA_SC1200)	+= pata_sc1200.o
 obj-$(CONFIG_PATA_SERVERWORKS)	+= pata_serverworks.o
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a34f324..3ce4392 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -49,7 +49,11 @@
 
 #include "libata.h"
 
-#define SECTOR_SIZE	512
+#define SECTOR_SIZE		512
+#define ATA_SCSI_RBUF_SIZE	4096
+
+static DEFINE_SPINLOCK(ata_scsi_rbuf_lock);
+static u8 ata_scsi_rbuf[ATA_SCSI_RBUF_SIZE];
 
 typedef unsigned int (*ata_xlat_func_t)(struct ata_queued_cmd *qc);
 
@@ -179,6 +183,13 @@ DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
 		ata_scsi_lpm_show, ata_scsi_lpm_put);
 EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);
 
+static void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
+{
+	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+
+	scsi_build_sense_buffer(0, cmd->sense_buffer, sk, asc, ascq);
+}
+
 static void ata_scsi_invalid_field(struct scsi_cmnd *cmd,
 				   void (*done)(struct scsi_cmnd *))
 {
@@ -1632,53 +1643,48 @@ defer:
 
 /**
  *	ata_scsi_rbuf_get - Map response buffer.
- *	@cmd: SCSI command containing buffer to be mapped.
- *	@buf_out: Pointer to mapped area.
+ *	@flags: unsigned long variable to store irq enable status
+ *	@copy_in: copy in from user buffer
  *
- *	Maps buffer contained within SCSI command @cmd.
+ *	Prepare buffer for simulated SCSI commands.
  *
  *	LOCKING:
- *	spin_lock_irqsave(host lock)
+ *	spin_lock_irqsave(ata_scsi_rbuf_lock) on success
  *
  *	RETURNS:
- *	Length of response buffer.
+ *	Pointer to response buffer.
  */
-
-static unsigned int ata_scsi_rbuf_get(struct scsi_cmnd *cmd, u8 **buf_out)
+static void *ata_scsi_rbuf_get(struct scsi_cmnd *cmd, bool copy_in,
+			       unsigned long *flags)
 {
-	u8 *buf;
-	unsigned int buflen;
-
-	struct scatterlist *sg = scsi_sglist(cmd);
+	spin_lock_irqsave(&ata_scsi_rbuf_lock, *flags);
 
-	if (sg) {
-		buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
-		buflen = sg->length;
-	} else {
-		buf = NULL;
-		buflen = 0;
-	}
-
-	*buf_out = buf;
-	return buflen;
+	memset(ata_scsi_rbuf, 0, ATA_SCSI_RBUF_SIZE);
+	if (copy_in)
+		sg_copy_to_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
+				  ata_scsi_rbuf, ATA_SCSI_RBUF_SIZE);
+	return ata_scsi_rbuf;
 }
 
 /**
  *	ata_scsi_rbuf_put - Unmap response buffer.
  *	@cmd: SCSI command containing buffer to be unmapped.
- *	@buf: buffer to unmap
+ *	@copy_out: copy out result
+ *	@flags: @flags passed to ata_scsi_rbuf_get()
  *
- *	Unmaps response buffer contained within @cmd.
+ *	Returns rbuf buffer.  The result is copied to @cmd's buffer if
+ *	@copy_back is true.
  *
  *	LOCKING:
- *	spin_lock_irqsave(host lock)
+ *	Unlocks ata_scsi_rbuf_lock.
  */
-
-static inline void ata_scsi_rbuf_put(struct scsi_cmnd *cmd, u8 *buf)
+static inline void ata_scsi_rbuf_put(struct scsi_cmnd *cmd, bool copy_out,
+				     unsigned long *flags)
 {
-	struct scatterlist *sg = scsi_sglist(cmd);
-	if (sg)
-		kunmap_atomic(buf - sg->offset, KM_IRQ0);
+	if (copy_out)
+		sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
+				    ata_scsi_rbuf, ATA_SCSI_RBUF_SIZE);
+	spin_unlock_irqrestore(&ata_scsi_rbuf_lock, *flags);
 }
 
 /**
@@ -1696,24 +1702,17 @@ static inline void ata_scsi_rbuf_put(struct scsi_cmnd *cmd, u8 *buf)
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-
-void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
-			unsigned int (*actor) (struct ata_scsi_args *args,
-					       u8 *rbuf, unsigned int buflen))
+static void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
+		unsigned int (*actor)(struct ata_scsi_args *args, u8 *rbuf))
 {
 	u8 *rbuf;
-	unsigned int buflen, rc;
+	unsigned int rc;
 	struct scsi_cmnd *cmd = args->cmd;
 	unsigned long flags;
 
-	local_irq_save(flags);
-
-	buflen = ata_scsi_rbuf_get(cmd, &rbuf);
-	memset(rbuf, 0, buflen);
-	rc = actor(args, rbuf, buflen);
-	ata_scsi_rbuf_put(cmd, rbuf);
-
-	local_irq_restore(flags);
+	rbuf = ata_scsi_rbuf_get(cmd, false, &flags);
+	rc = actor(args, rbuf);
+	ata_scsi_rbuf_put(cmd, rc == 0, &flags);
 
 	if (rc == 0)
 		cmd->result = SAM_STAT_GOOD;
@@ -1721,26 +1720,9 @@ void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
 }
 
 /**
- *	ATA_SCSI_RBUF_SET - helper to set values in SCSI response buffer
- *	@idx: byte index into SCSI response buffer
- *	@val: value to set
- *
- *	To be used by SCSI command simulator functions.  This macros
- *	expects two local variables, u8 *rbuf and unsigned int buflen,
- *	are in scope.
- *
- *	LOCKING:
- *	None.
- */
-#define ATA_SCSI_RBUF_SET(idx, val) do { \
-		if ((idx) < buflen) rbuf[(idx)] = (u8)(val); \
-	} while (0)
-
-/**
  *	ata_scsiop_inq_std - Simulate INQUIRY command
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
- *	@buflen: Response buffer length.
  *
  *	Returns standard device identification data associated
  *	with non-VPD INQUIRY command output.
@@ -1748,10 +1730,17 @@ void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-
-unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf,
-			       unsigned int buflen)
+static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 {
+	const u8 versions[] = {
+		0x60,	/* SAM-3 (no version claimed) */
+
+		0x03,
+		0x20,	/* SBC-2 (no version claimed) */
+
+		0x02,
+		0x60	/* SPC-3 (no version claimed) */
+	};
 	u8 hdr[] = {
 		TYPE_DISK,
 		0,
@@ -1760,35 +1749,21 @@ unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf,
 		95 - 4
 	};
 
+	VPRINTK("ENTER\n");
+
 	/* set scsi removeable (RMB) bit per ata bit */
 	if (ata_id_removeable(args->id))
 		hdr[1] |= (1 << 7);
 
-	VPRINTK("ENTER\n");
-
 	memcpy(rbuf, hdr, sizeof(hdr));
+	memcpy(&rbuf[8], "ATA     ", 8);
+	ata_id_string(args->id, &rbuf[16], ATA_ID_PROD, 16);
+	ata_id_string(args->id, &rbuf[32], ATA_ID_FW_REV, 4);
 
-	if (buflen > 35) {
-		memcpy(&rbuf[8], "ATA     ", 8);
-		ata_id_string(args->id, &rbuf[16], ATA_ID_PROD, 16);
-		ata_id_string(args->id, &rbuf[32], ATA_ID_FW_REV, 4);
-		if (rbuf[32] == 0 || rbuf[32] == ' ')
-			memcpy(&rbuf[32], "n/a ", 4);
-	}
-
-	if (buflen > 63) {
-		const u8 versions[] = {
-			0x60,	/* SAM-3 (no version claimed) */
-
-			0x03,
-			0x20,	/* SBC-2 (no version claimed) */
+	if (rbuf[32] == 0 || rbuf[32] == ' ')
+		memcpy(&rbuf[32], "n/a ", 4);
 
-			0x02,
-			0x60	/* SPC-3 (no version claimed) */
-		};
-
-		memcpy(rbuf + 59, versions, sizeof(versions));
-	}
+	memcpy(rbuf + 59, versions, sizeof(versions));
 
 	return 0;
 }
@@ -1797,27 +1772,22 @@ unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf,
  *	ata_scsiop_inq_00 - Simulate INQUIRY VPD page 0, list of pages
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
- *	@buflen: Response buffer length.
  *
  *	Returns list of inquiry VPD pages available.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-
-unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf,
-			      unsigned int buflen)
+static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
 {
 	const u8 pages[] = {
 		0x00,	/* page 0x00, this page */
 		0x80,	/* page 0x80, unit serial no page */
 		0x83	/* page 0x83, device ident page */
 	};
-	rbuf[3] = sizeof(pages);	/* number of supported VPD pages */
-
-	if (buflen > 6)
-		memcpy(rbuf + 4, pages, sizeof(pages));
 
+	rbuf[3] = sizeof(pages);	/* number of supported VPD pages */
+	memcpy(rbuf + 4, pages, sizeof(pages));
 	return 0;
 }
 
@@ -1825,16 +1795,13 @@ unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf,
  *	ata_scsiop_inq_80 - Simulate INQUIRY VPD page 80, device serial number
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
- *	@buflen: Response buffer length.
  *
  *	Returns ATA device serial number.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-
-unsigned int ata_scsiop_inq_80(struct ata_scsi_args *args, u8 *rbuf,
-			      unsigned int buflen)
+static unsigned int ata_scsiop_inq_80(struct ata_scsi_args *args, u8 *rbuf)
 {
 	const u8 hdr[] = {
 		0,
@@ -1842,12 +1809,10 @@ unsigned int ata_scsiop_inq_80(struct ata_scsi_args *args, u8 *rbuf,
 		0,
 		ATA_ID_SERNO_LEN,	/* page len */
 	};
-	memcpy(rbuf, hdr, sizeof(hdr));
-
-	if (buflen > (ATA_ID_SERNO_LEN + 4 - 1))
-		ata_id_string(args->id, (unsigned char *) &rbuf[4],
-			      ATA_ID_SERNO, ATA_ID_SERNO_LEN);
 
+	memcpy(rbuf, hdr, sizeof(hdr));
+	ata_id_string(args->id, (unsigned char *) &rbuf[4],
+		      ATA_ID_SERNO, ATA_ID_SERNO_LEN);
 	return 0;
 }
 
@@ -1855,7 +1820,6 @@ unsigned int ata_scsiop_inq_80(struct ata_scsi_args *args, u8 *rbuf,
  *	ata_scsiop_inq_83 - Simulate INQUIRY VPD page 83, device identity
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
- *	@buflen: Response buffer length.
  *
  *	Yields two logical unit device identification designators:
  *	 - vendor specific ASCII containing the ATA serial number
@@ -1865,41 +1829,37 @@ unsigned int ata_scsiop_inq_80(struct ata_scsi_args *args, u8 *rbuf,
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-
-unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf,
-			      unsigned int buflen)
+static unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf)
 {
-	int num;
 	const int sat_model_serial_desc_len = 68;
+	int num;
 
 	rbuf[1] = 0x83;			/* this page code */
 	num = 4;
 
-	if (buflen > (ATA_ID_SERNO_LEN + num + 3)) {
-		/* piv=0, assoc=lu, code_set=ACSII, designator=vendor */
-		rbuf[num + 0] = 2;
-		rbuf[num + 3] = ATA_ID_SERNO_LEN;
-		num += 4;
-		ata_id_string(args->id, (unsigned char *) rbuf + num,
-			      ATA_ID_SERNO, ATA_ID_SERNO_LEN);
-		num += ATA_ID_SERNO_LEN;
-	}
-	if (buflen > (sat_model_serial_desc_len + num + 3)) {
-		/* SAT defined lu model and serial numbers descriptor */
-		/* piv=0, assoc=lu, code_set=ACSII, designator=t10 vendor id */
-		rbuf[num + 0] = 2;
-		rbuf[num + 1] = 1;
-		rbuf[num + 3] = sat_model_serial_desc_len;
-		num += 4;
-		memcpy(rbuf + num, "ATA     ", 8);
-		num += 8;
-		ata_id_string(args->id, (unsigned char *) rbuf + num,
-			      ATA_ID_PROD, ATA_ID_PROD_LEN);
-		num += ATA_ID_PROD_LEN;
-		ata_id_string(args->id, (unsigned char *) rbuf + num,
-			      ATA_ID_SERNO, ATA_ID_SERNO_LEN);
-		num += ATA_ID_SERNO_LEN;
-	}
+	/* piv=0, assoc=lu, code_set=ACSII, designator=vendor */
+	rbuf[num + 0] = 2;
+	rbuf[num + 3] = ATA_ID_SERNO_LEN;
+	num += 4;
+	ata_id_string(args->id, (unsigned char *) rbuf + num,
+		      ATA_ID_SERNO, ATA_ID_SERNO_LEN);
+	num += ATA_ID_SERNO_LEN;
+
+	/* SAT defined lu model and serial numbers descriptor */
+	/* piv=0, assoc=lu, code_set=ACSII, designator=t10 vendor id */
+	rbuf[num + 0] = 2;
+	rbuf[num + 1] = 1;
+	rbuf[num + 3] = sat_model_serial_desc_len;
+	num += 4;
+	memcpy(rbuf + num, "ATA     ", 8);
+	num += 8;
+	ata_id_string(args->id, (unsigned char *) rbuf + num, ATA_ID_PROD,
+		      ATA_ID_PROD_LEN);
+	num += ATA_ID_PROD_LEN;
+	ata_id_string(args->id, (unsigned char *) rbuf + num, ATA_ID_SERNO,
+		      ATA_ID_SERNO_LEN);
+	num += ATA_ID_SERNO_LEN;
+
 	rbuf[3] = num - 4;    /* page len (assume less than 256 bytes) */
 	return 0;
 }
@@ -1908,35 +1868,26 @@ unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf,
  *	ata_scsiop_inq_89 - Simulate INQUIRY VPD page 89, ATA info
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
- *	@buflen: Response buffer length.
  *
  *	Yields SAT-specified ATA VPD page.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-
-static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf,
-			      unsigned int buflen)
+static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf)
 {
-	u8 pbuf[60];
 	struct ata_taskfile tf;
-	unsigned int i;
 
-	if (!buflen)
-		return 0;
-
-	memset(&pbuf, 0, sizeof(pbuf));
 	memset(&tf, 0, sizeof(tf));
 
-	pbuf[1] = 0x89;			/* our page code */
-	pbuf[2] = (0x238 >> 8);		/* page size fixed at 238h */
-	pbuf[3] = (0x238 & 0xff);
+	rbuf[1] = 0x89;			/* our page code */
+	rbuf[2] = (0x238 >> 8);		/* page size fixed at 238h */
+	rbuf[3] = (0x238 & 0xff);
 
-	memcpy(&pbuf[8], "linux   ", 8);
-	memcpy(&pbuf[16], "libata          ", 16);
-	memcpy(&pbuf[32], DRV_VERSION, 4);
-	ata_id_string(args->id, &pbuf[32], ATA_ID_FW_REV, 4);
+	memcpy(&rbuf[8], "linux   ", 8);
+	memcpy(&rbuf[16], "libata          ", 16);
+	memcpy(&rbuf[32], DRV_VERSION, 4);
+	ata_id_string(args->id, &rbuf[32], ATA_ID_FW_REV, 4);
 
 	/* we don't store the ATA device signature, so we fake it */
 
@@ -1944,19 +1895,12 @@ static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf,
 	tf.lbal = 0x1;
 	tf.nsect = 0x1;
 
-	ata_tf_to_fis(&tf, 0, 1, &pbuf[36]);	/* TODO: PMP? */
-	pbuf[36] = 0x34;		/* force D2H Reg FIS (34h) */
+	ata_tf_to_fis(&tf, 0, 1, &rbuf[36]);	/* TODO: PMP? */
+	rbuf[36] = 0x34;		/* force D2H Reg FIS (34h) */
 
-	pbuf[56] = ATA_CMD_ID_ATA;
+	rbuf[56] = ATA_CMD_ID_ATA;
 
-	i = min(buflen, 60U);
-	memcpy(rbuf, &pbuf[0], i);
-	buflen -= i;
-
-	if (!buflen)
-		return 0;
-
-	memcpy(&rbuf[60], &args->id[0], min(buflen, 512U));
+	memcpy(&rbuf[60], &args->id[0], 512);
 	return 0;
 }
 
@@ -1964,7 +1908,6 @@ static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf,
  *	ata_scsiop_noop - Command handler that simply returns success.
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
- *	@buflen: Response buffer length.
  *
  *	No operation.  Simply returns success to caller, to indicate
  *	that the caller should successfully complete this SCSI command.
@@ -1972,47 +1915,16 @@ static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf,
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-
-unsigned int ata_scsiop_noop(struct ata_scsi_args *args, u8 *rbuf,
-			    unsigned int buflen)
+static unsigned int ata_scsiop_noop(struct ata_scsi_args *args, u8 *rbuf)
 {
 	VPRINTK("ENTER\n");
 	return 0;
 }
 
 /**
- *	ata_msense_push - Push data onto MODE SENSE data output buffer
- *	@ptr_io: (input/output) Location to store more output data
- *	@last: End of output data buffer
- *	@buf: Pointer to BLOB being added to output buffer
- *	@buflen: Length of BLOB
- *
- *	Store MODE SENSE data on an output buffer.
- *
- *	LOCKING:
- *	None.
- */
-
-static void ata_msense_push(u8 **ptr_io, const u8 *last,
-			    const u8 *buf, unsigned int buflen)
-{
-	u8 *ptr = *ptr_io;
-
-	if ((ptr + buflen - 1) > last)
-		return;
-
-	memcpy(ptr, buf, buflen);
-
-	ptr += buflen;
-
-	*ptr_io = ptr;
-}
-
-/**
  *	ata_msense_caching - Simulate MODE SENSE caching info page
  *	@id: device IDENTIFY data
- *	@ptr_io: (input/output) Location to store more output data
- *	@last: End of output data buffer
+ *	@buf: output buffer
  *
  *	Generate a caching info page, which conditionally indicates
  *	write caching to the SCSI layer, depending on device
@@ -2021,58 +1933,43 @@ static void ata_msense_push(u8 **ptr_io, const u8 *last,
  *	LOCKING:
  *	None.
  */
-
-static unsigned int ata_msense_caching(u16 *id, u8 **ptr_io,
-				       const u8 *last)
+static unsigned int ata_msense_caching(u16 *id, u8 *buf)
 {
-	u8 page[CACHE_MPAGE_LEN];
-
-	memcpy(page, def_cache_mpage, sizeof(page));
+	memcpy(buf, def_cache_mpage, sizeof(def_cache_mpage));
 	if (ata_id_wcache_enabled(id))
-		page[2] |= (1 << 2);	/* write cache enable */
+		buf[2] |= (1 << 2);	/* write cache enable */
 	if (!ata_id_rahead_enabled(id))
-		page[12] |= (1 << 5);	/* disable read ahead */
-
-	ata_msense_push(ptr_io, last, page, sizeof(page));
-	return sizeof(page);
+		buf[12] |= (1 << 5);	/* disable read ahead */
+	return sizeof(def_cache_mpage);
 }
 
 /**
  *	ata_msense_ctl_mode - Simulate MODE SENSE control mode page
- *	@dev: Device associated with this MODE SENSE command
- *	@ptr_io: (input/output) Location to store more output data
- *	@last: End of output data buffer
+ *	@buf: output buffer
  *
  *	Generate a generic MODE SENSE control mode page.
  *
  *	LOCKING:
  *	None.
  */
-
-static unsigned int ata_msense_ctl_mode(u8 **ptr_io, const u8 *last)
+static unsigned int ata_msense_ctl_mode(u8 *buf)
 {
-	ata_msense_push(ptr_io, last, def_control_mpage,
-			sizeof(def_control_mpage));
+	memcpy(buf, def_control_mpage, sizeof(def_control_mpage));
 	return sizeof(def_control_mpage);
 }
 
 /**
  *	ata_msense_rw_recovery - Simulate MODE SENSE r/w error recovery page
- *	@dev: Device associated with this MODE SENSE command
- *	@ptr_io: (input/output) Location to store more output data
- *	@last: End of output data buffer
+ *	@bufp: output buffer
  *
  *	Generate a generic MODE SENSE r/w error recovery page.
  *
  *	LOCKING:
  *	None.
  */
-
-static unsigned int ata_msense_rw_recovery(u8 **ptr_io, const u8 *last)
+static unsigned int ata_msense_rw_recovery(u8 *buf)
 {
-
-	ata_msense_push(ptr_io, last, def_rw_recovery_mpage,
-			sizeof(def_rw_recovery_mpage));
+	memcpy(buf, def_rw_recovery_mpage, sizeof(def_rw_recovery_mpage));
 	return sizeof(def_rw_recovery_mpage);
 }
 
@@ -2104,7 +2001,6 @@ static int ata_dev_supports_fua(u16 *id)
  *	ata_scsiop_mode_sense - Simulate MODE SENSE 6, 10 commands
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
- *	@buflen: Response buffer length.
  *
  *	Simulate MODE SENSE commands. Assume this is invoked for direct
  *	access devices (e.g. disks) only. There should be no block
@@ -2113,19 +2009,17 @@ static int ata_dev_supports_fua(u16 *id)
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-
-unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf,
-				  unsigned int buflen)
+static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 {
 	struct ata_device *dev = args->dev;
-	u8 *scsicmd = args->cmd->cmnd, *p, *last;
+	u8 *scsicmd = args->cmd->cmnd, *p = rbuf;
 	const u8 sat_blk_desc[] = {
 		0, 0, 0, 0,	/* number of blocks: sat unspecified */
 		0,
 		0, 0x2, 0x0	/* block length: 512 bytes */
 	};
 	u8 pg, spg;
-	unsigned int ebd, page_control, six_byte, output_len, alloc_len, minlen;
+	unsigned int ebd, page_control, six_byte;
 	u8 dpofua;
 
 	VPRINTK("ENTER\n");
@@ -2148,17 +2042,10 @@ unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf,
 		goto invalid_fld;
 	}
 
-	if (six_byte) {
-		output_len = 4 + (ebd ? 8 : 0);
-		alloc_len = scsicmd[4];
-	} else {
-		output_len = 8 + (ebd ? 8 : 0);
-		alloc_len = (scsicmd[7] << 8) + scsicmd[8];
-	}
-	minlen = (alloc_len < buflen) ? alloc_len : buflen;
-
-	p = rbuf + output_len;
-	last = rbuf + minlen - 1;
+	if (six_byte)
+		p += 4 + (ebd ? 8 : 0);
+	else
+		p += 8 + (ebd ? 8 : 0);
 
 	pg = scsicmd[2] & 0x3f;
 	spg = scsicmd[3];
@@ -2171,61 +2058,48 @@ unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf,
 
 	switch(pg) {
 	case RW_RECOVERY_MPAGE:
-		output_len += ata_msense_rw_recovery(&p, last);
+		p += ata_msense_rw_recovery(p);
 		break;
 
 	case CACHE_MPAGE:
-		output_len += ata_msense_caching(args->id, &p, last);
+		p += ata_msense_caching(args->id, p);
 		break;
 
-	case CONTROL_MPAGE: {
-		output_len += ata_msense_ctl_mode(&p, last);
+	case CONTROL_MPAGE:
+		p += ata_msense_ctl_mode(p);
 		break;
-		}
 
 	case ALL_MPAGES:
-		output_len += ata_msense_rw_recovery(&p, last);
-		output_len += ata_msense_caching(args->id, &p, last);
-		output_len += ata_msense_ctl_mode(&p, last);
+		p += ata_msense_rw_recovery(p);
+		p += ata_msense_caching(args->id, p);
+		p += ata_msense_ctl_mode(p);
 		break;
 
 	default:		/* invalid page code */
 		goto invalid_fld;
 	}
 
-	if (minlen < 1)
-		return 0;
-
 	dpofua = 0;
 	if (ata_dev_supports_fua(args->id) && (dev->flags & ATA_DFLAG_LBA48) &&
 	    (!(dev->flags & ATA_DFLAG_PIO) || dev->multi_count))
 		dpofua = 1 << 4;
 
 	if (six_byte) {
-		output_len--;
-		rbuf[0] = output_len;
-		if (minlen > 2)
-			rbuf[2] |= dpofua;
+		rbuf[0] = p - rbuf - 1;
+		rbuf[2] |= dpofua;
 		if (ebd) {
-			if (minlen > 3)
-				rbuf[3] = sizeof(sat_blk_desc);
-			if (minlen > 11)
-				memcpy(rbuf + 4, sat_blk_desc,
-				       sizeof(sat_blk_desc));
+			rbuf[3] = sizeof(sat_blk_desc);
+			memcpy(rbuf + 4, sat_blk_desc, sizeof(sat_blk_desc));
 		}
 	} else {
-		output_len -= 2;
+		unsigned int output_len = p - rbuf - 2;
+
 		rbuf[0] = output_len >> 8;
-		if (minlen > 1)
-			rbuf[1] = output_len;
-		if (minlen > 3)
-			rbuf[3] |= dpofua;
+		rbuf[1] = output_len;
+		rbuf[3] |= dpofua;
 		if (ebd) {
-			if (minlen > 7)
-				rbuf[7] = sizeof(sat_blk_desc);
-			if (minlen > 15)
-				memcpy(rbuf + 8, sat_blk_desc,
-				       sizeof(sat_blk_desc));
+			rbuf[7] = sizeof(sat_blk_desc);
+			memcpy(rbuf + 8, sat_blk_desc, sizeof(sat_blk_desc));
 		}
 	}
 	return 0;
@@ -2245,15 +2119,13 @@ saving_not_supp:
  *	ata_scsiop_read_cap - Simulate READ CAPACITY[ 16] commands
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
- *	@buflen: Response buffer length.
  *
  *	Simulate READ CAPACITY commands.
  *
  *	LOCKING:
  *	None.
  */
-unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf,
-				 unsigned int buflen)
+static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 {
 	u64 last_lba = args->dev->n_sectors - 1; /* LBA of the last block */
 
@@ -2264,28 +2136,28 @@ unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf,
 			last_lba = 0xffffffff;
 
 		/* sector count, 32-bit */
-		ATA_SCSI_RBUF_SET(0, last_lba >> (8 * 3));
-		ATA_SCSI_RBUF_SET(1, last_lba >> (8 * 2));
-		ATA_SCSI_RBUF_SET(2, last_lba >> (8 * 1));
-		ATA_SCSI_RBUF_SET(3, last_lba);
+		rbuf[0] = last_lba >> (8 * 3);
+		rbuf[1] = last_lba >> (8 * 2);
+		rbuf[2] = last_lba >> (8 * 1);
+		rbuf[3] = last_lba;
 
 		/* sector size */
-		ATA_SCSI_RBUF_SET(6, ATA_SECT_SIZE >> 8);
-		ATA_SCSI_RBUF_SET(7, ATA_SECT_SIZE & 0xff);
+		rbuf[6] = ATA_SECT_SIZE >> 8;
+		rbuf[7] = ATA_SECT_SIZE & 0xff;
 	} else {
 		/* sector count, 64-bit */
-		ATA_SCSI_RBUF_SET(0, last_lba >> (8 * 7));
-		ATA_SCSI_RBUF_SET(1, last_lba >> (8 * 6));
-		ATA_SCSI_RBUF_SET(2, last_lba >> (8 * 5));
-		ATA_SCSI_RBUF_SET(3, last_lba >> (8 * 4));
-		ATA_SCSI_RBUF_SET(4, last_lba >> (8 * 3));
-		ATA_SCSI_RBUF_SET(5, last_lba >> (8 * 2));
-		ATA_SCSI_RBUF_SET(6, last_lba >> (8 * 1));
-		ATA_SCSI_RBUF_SET(7, last_lba);
+		rbuf[0] = last_lba >> (8 * 7);
+		rbuf[1] = last_lba >> (8 * 6);
+		rbuf[2] = last_lba >> (8 * 5);
+		rbuf[3] = last_lba >> (8 * 4);
+		rbuf[4] = last_lba >> (8 * 3);
+		rbuf[5] = last_lba >> (8 * 2);
+		rbuf[6] = last_lba >> (8 * 1);
+		rbuf[7] = last_lba;
 
 		/* sector size */
-		ATA_SCSI_RBUF_SET(10, ATA_SECT_SIZE >> 8);
-		ATA_SCSI_RBUF_SET(11, ATA_SECT_SIZE & 0xff);
+		rbuf[10] = ATA_SECT_SIZE >> 8;
+		rbuf[11] = ATA_SECT_SIZE & 0xff;
 	}
 
 	return 0;
@@ -2295,16 +2167,13 @@ unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf,
  *	ata_scsiop_report_luns - Simulate REPORT LUNS command
  *	@args: device IDENTIFY data / SCSI command of interest.
  *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
- *	@buflen: Response buffer length.
  *
  *	Simulate REPORT LUNS command.
  *
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-
-unsigned int ata_scsiop_report_luns(struct ata_scsi_args *args, u8 *rbuf,
-				   unsigned int buflen)
+static unsigned int ata_scsiop_report_luns(struct ata_scsi_args *args, u8 *rbuf)
 {
 	VPRINTK("ENTER\n");
 	rbuf[3] = 8;	/* just one lun, LUN 0, size 8 bytes */
@@ -2312,53 +2181,6 @@ unsigned int ata_scsiop_report_luns(struct ata_scsi_args *args, u8 *rbuf,
 	return 0;
 }
 
-/**
- *	ata_scsi_set_sense - Set SCSI sense data and status
- *	@cmd: SCSI request to be handled
- *	@sk: SCSI-defined sense key
- *	@asc: SCSI-defined additional sense code
- *	@ascq: SCSI-defined additional sense code qualifier
- *
- *	Helper function that builds a valid fixed format, current
- *	response code and the given sense key (sk), additional sense
- *	code (asc) and additional sense code qualifier (ascq) with
- *	a SCSI command status of %SAM_STAT_CHECK_CONDITION and
- *	DRIVER_SENSE set in the upper bits of scsi_cmnd::result .
- *
- *	LOCKING:
- *	Not required
- */
-
-void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
-{
-	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
-
-	scsi_build_sense_buffer(0, cmd->sense_buffer, sk, asc, ascq);
-}
-
-/**
- *	ata_scsi_badcmd - End a SCSI request with an error
- *	@cmd: SCSI request to be handled
- *	@done: SCSI command completion function
- *	@asc: SCSI-defined additional sense code
- *	@ascq: SCSI-defined additional sense code qualifier
- *
- *	Helper function that completes a SCSI command with
- *	%SAM_STAT_CHECK_CONDITION, with a sense key %ILLEGAL_REQUEST
- *	and the specified additional sense codes.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-
-void ata_scsi_badcmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *), u8 asc, u8 ascq)
-{
-	DPRINTK("ENTER\n");
-	ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, asc, ascq);
-
-	done(cmd);
-}
-
 static void atapi_sense_complete(struct ata_queued_cmd *qc)
 {
 	if (qc->err_mask && ((qc->err_mask & AC_ERR_DEV) == 0)) {
@@ -2485,13 +2307,10 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 		u8 *scsicmd = cmd->cmnd;
 
 		if ((scsicmd[0] == INQUIRY) && ((scsicmd[1] & 0x03) == 0)) {
-			u8 *buf = NULL;
-			unsigned int buflen;
 			unsigned long flags;
+			u8 *buf;
 
-			local_irq_save(flags);
-
-			buflen = ata_scsi_rbuf_get(cmd, &buf);
+			buf = ata_scsi_rbuf_get(cmd, true, &flags);
 
 	/* ATAPI devices typically report zero for their SCSI version,
 	 * and sometimes deviate from the spec WRT response data
@@ -2506,9 +2325,7 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 				buf[3] = 0x32;
 			}
 
-			ata_scsi_rbuf_put(cmd, buf);
-
-			local_irq_restore(flags);
+			ata_scsi_rbuf_put(cmd, true, &flags);
 		}
 
 		cmd->result = SAM_STAT_GOOD;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index ae2cfd9..4514283 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -146,34 +146,6 @@ extern void ata_scsi_scan_host(struct ata_port *ap, int sync);
 extern int ata_scsi_offline_dev(struct ata_device *dev);
 extern void ata_scsi_media_change_notify(struct ata_device *dev);
 extern void ata_scsi_hotplug(struct work_struct *work);
-extern unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf,
-			       unsigned int buflen);
-
-extern unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf,
-			      unsigned int buflen);
-
-extern unsigned int ata_scsiop_inq_80(struct ata_scsi_args *args, u8 *rbuf,
-			      unsigned int buflen);
-extern unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf,
-			      unsigned int buflen);
-extern unsigned int ata_scsiop_noop(struct ata_scsi_args *args, u8 *rbuf,
-			    unsigned int buflen);
-extern unsigned int ata_scsiop_sync_cache(struct ata_scsi_args *args, u8 *rbuf,
-				  unsigned int buflen);
-extern unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf,
-				  unsigned int buflen);
-extern unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf,
-			        unsigned int buflen);
-extern unsigned int ata_scsiop_report_luns(struct ata_scsi_args *args, u8 *rbuf,
-				   unsigned int buflen);
-extern void ata_scsi_badcmd(struct scsi_cmnd *cmd,
-			    void (*done)(struct scsi_cmnd *),
-			    u8 asc, u8 ascq);
-extern void ata_scsi_set_sense(struct scsi_cmnd *cmd,
-			       u8 sk, u8 asc, u8 ascq);
-extern void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
-                        unsigned int (*actor) (struct ata_scsi_args *args,
-                                           u8 *rbuf, unsigned int buflen));
 extern void ata_schedule_scsi_eh(struct Scsi_Host *shost);
 extern void ata_scsi_dev_rescan(struct work_struct *work);
 extern int ata_bus_probe(struct ata_port *ap);
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index a75de06..9ab8973 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1272,8 +1272,8 @@ static void bfin_freeze(struct ata_port *ap)
 
 void bfin_thaw(struct ata_port *ap)
 {
+	dev_dbg(ap->dev, "in atapi dma thaw\n");
 	bfin_check_status(ap);
-	bfin_irq_clear(ap);
 	bfin_irq_on(ap);
 }
 
@@ -1339,13 +1339,130 @@ static int bfin_port_start(struct ata_port *ap)
 	return 0;
 }
 
+static unsigned int bfin_ata_host_intr(struct ata_port *ap,
+				   struct ata_queued_cmd *qc)
+{
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	u8 status, host_stat = 0;
+
+	VPRINTK("ata%u: protocol %d task_state %d\n",
+		ap->print_id, qc->tf.protocol, ap->hsm_task_state);
+
+	/* Check whether we are expecting interrupt in this state */
+	switch (ap->hsm_task_state) {
+	case HSM_ST_FIRST:
+		/* Some pre-ATAPI-4 devices assert INTRQ
+		 * at this state when ready to receive CDB.
+		 */
+
+		/* Check the ATA_DFLAG_CDB_INTR flag is enough here.
+		 * The flag was turned on only for atapi devices.
+		 * No need to check is_atapi_taskfile(&qc->tf) again.
+		 */
+		if (!(qc->dev->flags & ATA_DFLAG_CDB_INTR))
+			goto idle_irq;
+		break;
+	case HSM_ST_LAST:
+		if (qc->tf.protocol == ATA_PROT_DMA ||
+		    qc->tf.protocol == ATAPI_PROT_DMA) {
+			/* check status of DMA engine */
+			host_stat = ap->ops->bmdma_status(ap);
+			VPRINTK("ata%u: host_stat 0x%X\n",
+				ap->print_id, host_stat);
+
+			/* if it's not our irq... */
+			if (!(host_stat & ATA_DMA_INTR))
+				goto idle_irq;
+
+			/* before we do anything else, clear DMA-Start bit */
+			ap->ops->bmdma_stop(qc);
+
+			if (unlikely(host_stat & ATA_DMA_ERR)) {
+				/* error when transfering data to/from memory */
+				qc->err_mask |= AC_ERR_HOST_BUS;
+				ap->hsm_task_state = HSM_ST_ERR;
+			}
+		}
+		break;
+	case HSM_ST:
+		break;
+	default:
+		goto idle_irq;
+	}
+
+	/* check altstatus */
+	status = ap->ops->sff_check_altstatus(ap);
+	if (status & ATA_BUSY)
+		goto busy_ata;
+
+	/* check main status, clearing INTRQ */
+	status = ap->ops->sff_check_status(ap);
+	if (unlikely(status & ATA_BUSY))
+		goto busy_ata;
+
+	/* ack bmdma irq events */
+	ap->ops->sff_irq_clear(ap);
+
+	ata_sff_hsm_move(ap, qc, status, 0);
+
+	if (unlikely(qc->err_mask) && (qc->tf.protocol == ATA_PROT_DMA ||
+				       qc->tf.protocol == ATAPI_PROT_DMA))
+		ata_ehi_push_desc(ehi, "BMDMA stat 0x%x", host_stat);
+
+busy_ata:
+	return 1;	/* irq handled */
+
+idle_irq:
+	ap->stats.idle_irq++;
+
+#ifdef ATA_IRQ_TRAP
+	if ((ap->stats.idle_irq % 1000) == 0) {
+		ap->ops->irq_ack(ap, 0); /* debug trap */
+		ata_port_printk(ap, KERN_WARNING, "irq trap\n");
+		return 1;
+	}
+#endif
+	return 0;	/* irq not handled */
+}
+
+static irqreturn_t bfin_ata_interrupt(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	unsigned int i;
+	unsigned int handled = 0;
+	unsigned long flags;
+
+	/* TODO: make _irqsave conditional on x86 PCI IDE legacy mode */
+	spin_lock_irqsave(&host->lock, flags);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap;
+
+		ap = host->ports[i];
+		if (ap &&
+		    !(ap->flags & ATA_FLAG_DISABLED)) {
+			struct ata_queued_cmd *qc;
+
+			qc = ata_qc_from_tag(ap, ap->link.active_tag);
+			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)) &&
+			    (qc->flags & ATA_QCFLAG_ACTIVE))
+				handled |= bfin_ata_host_intr(ap, qc);
+		}
+	}
+
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	return IRQ_RETVAL(handled);
+}
+
+
 static struct scsi_host_template bfin_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize		= SG_NONE,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 };
 
-static const struct ata_port_operations bfin_pata_ops = {
+static struct ata_port_operations bfin_pata_ops = {
 	.inherits		= &ata_sff_port_ops,
 
 	.set_piomode		= bfin_set_piomode,
@@ -1370,7 +1487,6 @@ static const struct ata_port_operations bfin_pata_ops = {
 	.thaw			= bfin_thaw,
 	.softreset		= bfin_softreset,
 	.postreset		= bfin_postreset,
-	.post_internal_cmd	= bfin_bmdma_stop,
 
 	.sff_irq_clear		= bfin_irq_clear,
 	.sff_irq_on		= bfin_irq_on,
@@ -1507,7 +1623,7 @@ static int __devinit bfin_atapi_probe(struct platform_device *pdev)
 	}
 
 	if (ata_host_activate(host, platform_get_irq(pdev, 0),
-		ata_sff_interrupt, IRQF_SHARED, &bfin_sht) != 0) {
+		bfin_ata_interrupt, IRQF_SHARED, &bfin_sht) != 0) {
 		peripheral_free_list(atapi_io_port);
 		dev_err(&pdev->dev, "Fail to attach ATAPI device\n");
 		return -ENODEV;
diff --git a/drivers/ata/pata_rb500_cf.c b/drivers/ata/pata_rb500_cf.c
deleted file mode 100644
index 4345174..0000000
--- a/drivers/ata/pata_rb500_cf.c
+++ /dev/null
@@ -1,277 +0,0 @@
-/*
- *  A low-level PATA driver to handle a Compact Flash connected on the
- *  Mikrotik's RouterBoard 532 board.
- *
- *  Copyright (C) 2007 Gabor Juhos <juhosg at openwrt.org>
- *  Copyright (C) 2008 Florian Fainelli <florian@openwrt.org>
- *
- *  This file was based on: drivers/ata/pata_ixp4xx_cf.c
- *	Copyright (C) 2006-07 Tower Technologies
- *	Author: Alessandro Zummo <a.zummo@towertech.it>
- *
- *  Also was based on the driver for Linux 2.4.xx published by Mikrotik for
- *  their RouterBoard 1xx and 5xx series devices. The original Mikrotik code
- *  seems not to have a license.
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License version 2 as
- *  published by the Free Software Foundation.
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-
-#include <linux/io.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-
-#include <linux/libata.h>
-#include <scsi/scsi_host.h>
-
-#include <asm/gpio.h>
-
-#define DRV_NAME	"pata-rb500-cf"
-#define DRV_VERSION	"0.1.0"
-#define DRV_DESC	"PATA driver for RouterBOARD 532 Compact Flash"
-
-#define RB500_CF_MAXPORTS	1
-#define RB500_CF_IO_DELAY	400
-
-#define RB500_CF_REG_CMD	0x0800
-#define RB500_CF_REG_CTRL	0x080E
-#define RB500_CF_REG_DATA	0x0C00
-
-struct rb500_cf_info {
-	void __iomem	*iobase;
-	unsigned int	gpio_line;
-	int		frozen;
-	unsigned int	irq;
-};
-
-/* ------------------------------------------------------------------------ */
-
-static inline void rb500_pata_finish_io(struct ata_port *ap)
-{
-	struct ata_host *ah = ap->host;
-	struct rb500_cf_info *info = ah->private_data;
-
-	ata_sff_altstatus(ap);
-	ndelay(RB500_CF_IO_DELAY);
-
-	set_irq_type(info->irq, IRQ_TYPE_LEVEL_HIGH);
-}
-
-static void rb500_pata_exec_command(struct ata_port *ap,
-				const struct ata_taskfile *tf)
-{
-	writeb(tf->command, ap->ioaddr.command_addr);
-	rb500_pata_finish_io(ap);
-}
-
-static void rb500_pata_data_xfer(struct ata_device *adev, unsigned char *buf,
-				unsigned int buflen, int write_data)
-{
-	struct ata_port *ap = adev->link->ap;
-	void __iomem *ioaddr = ap->ioaddr.data_addr;
-
-	if (write_data) {
-		for (; buflen > 0; buflen--, buf++)
-			writeb(*buf, ioaddr);
-	} else {
-		for (; buflen > 0; buflen--, buf++)
-			*buf = readb(ioaddr);
-	}
-
-	rb500_pata_finish_io(adev->link->ap);
-}
-
-static void rb500_pata_freeze(struct ata_port *ap)
-{
-	struct rb500_cf_info *info = ap->host->private_data;
-
-	info->frozen = 1;
-}
-
-static void rb500_pata_thaw(struct ata_port *ap)
-{
-	struct rb500_cf_info *info = ap->host->private_data;
-
-	info->frozen = 0;
-}
-
-static irqreturn_t rb500_pata_irq_handler(int irq, void *dev_instance)
-{
-	struct ata_host *ah = dev_instance;
-	struct rb500_cf_info *info = ah->private_data;
-
-	if (gpio_get_value(info->gpio_line)) {
-		set_irq_type(info->irq, IRQ_TYPE_LEVEL_LOW);
-		if (!info->frozen)
-			ata_sff_interrupt(info->irq, dev_instance);
-	} else {
-		set_irq_type(info->irq, IRQ_TYPE_LEVEL_HIGH);
-	}
-
-	return IRQ_HANDLED;
-}
-
-static struct ata_port_operations rb500_pata_port_ops = {
-	.inherits		= &ata_sff_port_ops,
-	.sff_exec_command	= rb500_pata_exec_command,
-	.sff_data_xfer		= rb500_pata_data_xfer,
-	.freeze			= rb500_pata_freeze,
-	.thaw			= rb500_pata_thaw,
-};
-
-/* ------------------------------------------------------------------------ */
-
-static struct scsi_host_template rb500_pata_sht = {
-	ATA_PIO_SHT(DRV_NAME),
-};
-
-/* ------------------------------------------------------------------------ */
-
-static void rb500_pata_setup_ports(struct ata_host *ah)
-{
-	struct rb500_cf_info *info = ah->private_data;
-	struct ata_port *ap;
-
-	ap = ah->ports[0];
-
-	ap->ops		= &rb500_pata_port_ops;
-	ap->pio_mask	= 0x1f; /* PIO4 */
-	ap->flags	= ATA_FLAG_NO_LEGACY | ATA_FLAG_MMIO;
-
-	ap->ioaddr.cmd_addr	= info->iobase + RB500_CF_REG_CMD;
-	ap->ioaddr.ctl_addr	= info->iobase + RB500_CF_REG_CTRL;
-	ap->ioaddr.altstatus_addr = info->iobase + RB500_CF_REG_CTRL;
-
-	ata_sff_std_ports(&ap->ioaddr);
-
-	ap->ioaddr.data_addr	= info->iobase + RB500_CF_REG_DATA;
-}
-
-static __devinit int rb500_pata_driver_probe(struct platform_device *pdev)
-{
-	unsigned int irq;
-	int gpio;
-	struct resource *res;
-	struct ata_host *ah;
-	struct rb500_cf_info *info;
-	int ret;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "no IOMEM resource found\n");
-		return -EINVAL;
-	}
-
-	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0) {
-		dev_err(&pdev->dev, "no IRQ resource found\n");
-		return -ENOENT;
-	}
-
-	gpio = irq_to_gpio(irq);
-	if (gpio < 0) {
-		dev_err(&pdev->dev, "no GPIO found for irq%d\n", irq);
-		return -ENOENT;
-	}
-
-	ret = gpio_request(gpio, DRV_NAME);
-	if (ret) {
-		dev_err(&pdev->dev, "GPIO request failed\n");
-		return ret;
-	}
-
-	/* allocate host */
-	ah = ata_host_alloc(&pdev->dev, RB500_CF_MAXPORTS);
-	if (!ah)
-		return -ENOMEM;
-
-	platform_set_drvdata(pdev, ah);
-
-	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
-
-	ah->private_data = info;
-	info->gpio_line = gpio;
-	info->irq = irq;
-
-	info->iobase = devm_ioremap_nocache(&pdev->dev, res->start,
-				res->end - res->start + 1);
-	if (!info->iobase)
-		return -ENOMEM;
-
-	ret = gpio_direction_input(gpio);
-	if (ret) {
-		dev_err(&pdev->dev, "unable to set GPIO direction, err=%d\n",
-				ret);
-		goto err_free_gpio;
-	}
-
-	rb500_pata_setup_ports(ah);
-
-	ret = ata_host_activate(ah, irq, rb500_pata_irq_handler,
-				IRQF_TRIGGER_LOW, &rb500_pata_sht);
-	if (ret)
-		goto err_free_gpio;
-
-	return 0;
-
-err_free_gpio:
-	gpio_free(gpio);
-
-	return ret;
-}
-
-static __devexit int rb500_pata_driver_remove(struct platform_device *pdev)
-{
-	struct ata_host *ah = platform_get_drvdata(pdev);
-	struct rb500_cf_info *info = ah->private_data;
-
-	ata_host_detach(ah);
-	gpio_free(info->gpio_line);
-
-	return 0;
-}
-
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:" DRV_NAME);
-
-static struct platform_driver rb500_pata_platform_driver = {
-	.probe		= rb500_pata_driver_probe,
-	.remove		= __devexit_p(rb500_pata_driver_remove),
-	.driver	 = {
-		.name   = DRV_NAME,
-		.owner  = THIS_MODULE,
-	},
-};
-
-/* ------------------------------------------------------------------------ */
-
-#define DRV_INFO DRV_DESC " version " DRV_VERSION
-
-static int __init rb500_pata_module_init(void)
-{
-	printk(KERN_INFO DRV_INFO "\n");
-
-	return platform_driver_register(&rb500_pata_platform_driver);
-}
-
-static void __exit rb500_pata_module_exit(void)
-{
-	platform_driver_unregister(&rb500_pata_platform_driver);
-}
-
-MODULE_AUTHOR("Gabor Juhos <juhosg at openwrt.org>");
-MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
-MODULE_DESCRIPTION(DRV_DESC);
-MODULE_VERSION(DRV_VERSION);
-MODULE_LICENSE("GPL");
-
-module_init(rb500_pata_module_init);
-module_exit(rb500_pata_module_exit);
diff --git a/drivers/ata/pata_rb532_cf.c b/drivers/ata/pata_rb532_cf.c
new file mode 100644
index 0000000..a108d25
--- /dev/null
+++ b/drivers/ata/pata_rb532_cf.c
@@ -0,0 +1,277 @@
+/*
+ *  A low-level PATA driver to handle a Compact Flash connected on the
+ *  Mikrotik's RouterBoard 532 board.
+ *
+ *  Copyright (C) 2007 Gabor Juhos <juhosg at openwrt.org>
+ *  Copyright (C) 2008 Florian Fainelli <florian@openwrt.org>
+ *
+ *  This file was based on: drivers/ata/pata_ixp4xx_cf.c
+ *	Copyright (C) 2006-07 Tower Technologies
+ *	Author: Alessandro Zummo <a.zummo@towertech.it>
+ *
+ *  Also was based on the driver for Linux 2.4.xx published by Mikrotik for
+ *  their RouterBoard 1xx and 5xx series devices. The original Mikrotik code
+ *  seems not to have a license.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+
+#include <linux/libata.h>
+#include <scsi/scsi_host.h>
+
+#include <asm/gpio.h>
+
+#define DRV_NAME	"pata-rb532-cf"
+#define DRV_VERSION	"0.1.0"
+#define DRV_DESC	"PATA driver for RouterBOARD 532 Compact Flash"
+
+#define RB500_CF_MAXPORTS	1
+#define RB500_CF_IO_DELAY	400
+
+#define RB500_CF_REG_CMD	0x0800
+#define RB500_CF_REG_CTRL	0x080E
+#define RB500_CF_REG_DATA	0x0C00
+
+struct rb532_cf_info {
+	void __iomem	*iobase;
+	unsigned int	gpio_line;
+	int		frozen;
+	unsigned int	irq;
+};
+
+/* ------------------------------------------------------------------------ */
+
+static inline void rb532_pata_finish_io(struct ata_port *ap)
+{
+	struct ata_host *ah = ap->host;
+	struct rb532_cf_info *info = ah->private_data;
+
+	ata_sff_altstatus(ap);
+	ndelay(RB500_CF_IO_DELAY);
+
+	set_irq_type(info->irq, IRQ_TYPE_LEVEL_HIGH);
+}
+
+static void rb532_pata_exec_command(struct ata_port *ap,
+				const struct ata_taskfile *tf)
+{
+	writeb(tf->command, ap->ioaddr.command_addr);
+	rb532_pata_finish_io(ap);
+}
+
+static void rb532_pata_data_xfer(struct ata_device *adev, unsigned char *buf,
+				unsigned int buflen, int write_data)
+{
+	struct ata_port *ap = adev->link->ap;
+	void __iomem *ioaddr = ap->ioaddr.data_addr;
+
+	if (write_data) {
+		for (; buflen > 0; buflen--, buf++)
+			writeb(*buf, ioaddr);
+	} else {
+		for (; buflen > 0; buflen--, buf++)
+			*buf = readb(ioaddr);
+	}
+
+	rb532_pata_finish_io(adev->link->ap);
+}
+
+static void rb532_pata_freeze(struct ata_port *ap)
+{
+	struct rb532_cf_info *info = ap->host->private_data;
+
+	info->frozen = 1;
+}
+
+static void rb532_pata_thaw(struct ata_port *ap)
+{
+	struct rb532_cf_info *info = ap->host->private_data;
+
+	info->frozen = 0;
+}
+
+static irqreturn_t rb532_pata_irq_handler(int irq, void *dev_instance)
+{
+	struct ata_host *ah = dev_instance;
+	struct rb532_cf_info *info = ah->private_data;
+
+	if (gpio_get_value(info->gpio_line)) {
+		set_irq_type(info->irq, IRQ_TYPE_LEVEL_LOW);
+		if (!info->frozen)
+			ata_sff_interrupt(info->irq, dev_instance);
+	} else {
+		set_irq_type(info->irq, IRQ_TYPE_LEVEL_HIGH);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static struct ata_port_operations rb532_pata_port_ops = {
+	.inherits		= &ata_sff_port_ops,
+	.sff_exec_command	= rb532_pata_exec_command,
+	.sff_data_xfer		= rb532_pata_data_xfer,
+	.freeze			= rb532_pata_freeze,
+	.thaw			= rb532_pata_thaw,
+};
+
+/* ------------------------------------------------------------------------ */
+
+static struct scsi_host_template rb532_pata_sht = {
+	ATA_PIO_SHT(DRV_NAME),
+};
+
+/* ------------------------------------------------------------------------ */
+
+static void rb532_pata_setup_ports(struct ata_host *ah)
+{
+	struct rb532_cf_info *info = ah->private_data;
+	struct ata_port *ap;
+
+	ap = ah->ports[0];
+
+	ap->ops		= &rb532_pata_port_ops;
+	ap->pio_mask	= 0x1f; /* PIO4 */
+	ap->flags	= ATA_FLAG_NO_LEGACY | ATA_FLAG_MMIO;
+
+	ap->ioaddr.cmd_addr	= info->iobase + RB500_CF_REG_CMD;
+	ap->ioaddr.ctl_addr	= info->iobase + RB500_CF_REG_CTRL;
+	ap->ioaddr.altstatus_addr = info->iobase + RB500_CF_REG_CTRL;
+
+	ata_sff_std_ports(&ap->ioaddr);
+
+	ap->ioaddr.data_addr	= info->iobase + RB500_CF_REG_DATA;
+}
+
+static __devinit int rb532_pata_driver_probe(struct platform_device *pdev)
+{
+	unsigned int irq;
+	int gpio;
+	struct resource *res;
+	struct ata_host *ah;
+	struct rb532_cf_info *info;
+	int ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "no IOMEM resource found\n");
+		return -EINVAL;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0) {
+		dev_err(&pdev->dev, "no IRQ resource found\n");
+		return -ENOENT;
+	}
+
+	gpio = irq_to_gpio(irq);
+	if (gpio < 0) {
+		dev_err(&pdev->dev, "no GPIO found for irq%d\n", irq);
+		return -ENOENT;
+	}
+
+	ret = gpio_request(gpio, DRV_NAME);
+	if (ret) {
+		dev_err(&pdev->dev, "GPIO request failed\n");
+		return ret;
+	}
+
+	/* allocate host */
+	ah = ata_host_alloc(&pdev->dev, RB500_CF_MAXPORTS);
+	if (!ah)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, ah);
+
+	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	ah->private_data = info;
+	info->gpio_line = gpio;
+	info->irq = irq;
+
+	info->iobase = devm_ioremap_nocache(&pdev->dev, res->start,
+				res->end - res->start + 1);
+	if (!info->iobase)
+		return -ENOMEM;
+
+	ret = gpio_direction_input(gpio);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to set GPIO direction, err=%d\n",
+				ret);
+		goto err_free_gpio;
+	}
+
+	rb532_pata_setup_ports(ah);
+
+	ret = ata_host_activate(ah, irq, rb532_pata_irq_handler,
+				IRQF_TRIGGER_LOW, &rb532_pata_sht);
+	if (ret)
+		goto err_free_gpio;
+
+	return 0;
+
+err_free_gpio:
+	gpio_free(gpio);
+
+	return ret;
+}
+
+static __devexit int rb532_pata_driver_remove(struct platform_device *pdev)
+{
+	struct ata_host *ah = platform_get_drvdata(pdev);
+	struct rb532_cf_info *info = ah->private_data;
+
+	ata_host_detach(ah);
+	gpio_free(info->gpio_line);
+
+	return 0;
+}
+
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:" DRV_NAME);
+
+static struct platform_driver rb532_pata_platform_driver = {
+	.probe		= rb532_pata_driver_probe,
+	.remove		= __devexit_p(rb532_pata_driver_remove),
+	.driver	 = {
+		.name   = DRV_NAME,
+		.owner  = THIS_MODULE,
+	},
+};
+
+/* ------------------------------------------------------------------------ */
+
+#define DRV_INFO DRV_DESC " version " DRV_VERSION
+
+static int __init rb532_pata_module_init(void)
+{
+	printk(KERN_INFO DRV_INFO "\n");
+
+	return platform_driver_register(&rb532_pata_platform_driver);
+}
+
+static void __exit rb532_pata_module_exit(void)
+{
+	platform_driver_unregister(&rb532_pata_platform_driver);
+}
+
+MODULE_AUTHOR("Gabor Juhos <juhosg at openwrt.org>");
+MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
+MODULE_DESCRIPTION(DRV_DESC);
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
+
+module_init(rb532_pata_module_init);
+module_exit(rb532_pata_module_exit);
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 26a6337..842b1a1 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -172,10 +172,11 @@ enum {
 	PCIE_IRQ_MASK_OFS	= 0x1910,
 	PCIE_UNMASK_ALL_IRQS	= 0x40a,	/* assorted bits */
 
-	HC_MAIN_IRQ_CAUSE_OFS	= 0x1d60,
-	HC_MAIN_IRQ_MASK_OFS	= 0x1d64,
-	HC_SOC_MAIN_IRQ_CAUSE_OFS = 0x20020,
-	HC_SOC_MAIN_IRQ_MASK_OFS = 0x20024,
+	/* Host Controller Main Interrupt Cause/Mask registers (1 per-chip) */
+	PCI_HC_MAIN_IRQ_CAUSE_OFS = 0x1d60,
+	PCI_HC_MAIN_IRQ_MASK_OFS  = 0x1d64,
+	SOC_HC_MAIN_IRQ_CAUSE_OFS = 0x20020,
+	SOC_HC_MAIN_IRQ_MASK_OFS  = 0x20024,
 	ERR_IRQ			= (1 << 0),	/* shift by port # */
 	DONE_IRQ		= (1 << 1),	/* shift by port # */
 	HC0_IRQ_PEND		= 0x1ff,	/* bits 0-8 = HC0's ports */
@@ -445,8 +446,8 @@ struct mv_host_priv {
 	const struct mv_hw_ops	*ops;
 	int			n_ports;
 	void __iomem		*base;
-	void __iomem		*main_cause_reg_addr;
-	void __iomem		*main_mask_reg_addr;
+	void __iomem		*main_irq_cause_addr;
+	void __iomem		*main_irq_mask_addr;
 	u32			irq_cause_ofs;
 	u32			irq_mask_ofs;
 	u32			unmask_all_irqs;
@@ -727,8 +728,8 @@ static inline unsigned int mv_hardport_from_port(unsigned int port)
  * Simple code, with two return values, so macro rather than inline.
  *
  * port is the sole input, in range 0..7.
- * shift is one output, for use with the main_cause and main_mask registers.
- * hardport is the other output, in range 0..3
+ * shift is one output, for use with main_irq_cause / main_irq_mask registers.
+ * hardport is the other output, in range 0..3.
  *
  * Note that port and hardport may be the same variable in some cases.
  */
@@ -1679,12 +1680,12 @@ static void mv_process_crpb_entries(struct ata_port *ap, struct mv_port_priv *pp
 /**
  *      mv_host_intr - Handle all interrupts on the given host controller
  *      @host: host specific structure
- *      @main_cause: Main interrupt cause register for the chip.
+ *      @main_irq_cause: Main interrupt cause register for the chip.
  *
  *      LOCKING:
  *      Inherited from caller.
  */
-static int mv_host_intr(struct ata_host *host, u32 main_cause)
+static int mv_host_intr(struct ata_host *host, u32 main_irq_cause)
 {
 	struct mv_host_priv *hpriv = host->private_data;
 	void __iomem *mmio = hpriv->base, *hc_mmio = NULL;
@@ -1705,7 +1706,7 @@ static int mv_host_intr(struct ata_host *host, u32 main_cause)
 		 * Do nothing if port is not interrupting or is disabled:
 		 */
 		MV_PORT_TO_SHIFT_AND_HARDPORT(port, shift, hardport);
-		port_cause = (main_cause >> shift) & (DONE_IRQ | ERR_IRQ);
+		port_cause = (main_irq_cause >> shift) & (DONE_IRQ | ERR_IRQ);
 		if (!port_cause || !ap || (ap->flags & ATA_FLAG_DISABLED))
 			continue;
 		/*
@@ -1811,20 +1812,20 @@ static irqreturn_t mv_interrupt(int irq, void *dev_instance)
 	struct ata_host *host = dev_instance;
 	struct mv_host_priv *hpriv = host->private_data;
 	unsigned int handled = 0;
-	u32 main_cause, main_mask;
+	u32 main_irq_cause, main_irq_mask;
 
 	spin_lock(&host->lock);
-	main_cause = readl(hpriv->main_cause_reg_addr);
-	main_mask  = readl(hpriv->main_mask_reg_addr);
+	main_irq_cause = readl(hpriv->main_irq_cause_addr);
+	main_irq_mask  = readl(hpriv->main_irq_mask_addr);
 	/*
 	 * Deal with cases where we either have nothing pending, or have read
 	 * a bogus register value which can indicate HW removal or PCI fault.
 	 */
-	if ((main_cause & main_mask) && (main_cause != 0xffffffffU)) {
-		if (unlikely((main_cause & PCI_ERR) && HAS_PCI(host)))
+	if ((main_irq_cause & main_irq_mask) && (main_irq_cause != 0xffffffffU)) {
+		if (unlikely((main_irq_cause & PCI_ERR) && HAS_PCI(host)))
 			handled = mv_pci_error(host, hpriv->base);
 		else
-			handled = mv_host_intr(host, main_cause);
+			handled = mv_host_intr(host, main_irq_cause);
 	}
 	spin_unlock(&host->lock);
 	return IRQ_RETVAL(handled);
@@ -2027,7 +2028,7 @@ static void mv_reset_pci_bus(struct ata_host *host, void __iomem *mmio)
 	ZERO(MV_PCI_DISC_TIMER);
 	ZERO(MV_PCI_MSI_TRIGGER);
 	writel(0x000100ff, mmio + MV_PCI_XBAR_TMOUT);
-	ZERO(HC_MAIN_IRQ_MASK_OFS);
+	ZERO(PCI_HC_MAIN_IRQ_MASK_OFS);
 	ZERO(MV_PCI_SERR_MASK);
 	ZERO(hpriv->irq_cause_ofs);
 	ZERO(hpriv->irq_mask_ofs);
@@ -2404,7 +2405,7 @@ static void mv_eh_freeze(struct ata_port *ap)
 {
 	struct mv_host_priv *hpriv = ap->host->private_data;
 	unsigned int shift, hardport, port = ap->port_no;
-	u32 main_mask;
+	u32 main_irq_mask;
 
 	/* FIXME: handle coalescing completion events properly */
 
@@ -2412,9 +2413,9 @@ static void mv_eh_freeze(struct ata_port *ap)
 	MV_PORT_TO_SHIFT_AND_HARDPORT(port, shift, hardport);
 
 	/* disable assertion of portN err, done events */
-	main_mask = readl(hpriv->main_mask_reg_addr);
-	main_mask &= ~((DONE_IRQ | ERR_IRQ) << shift);
-	writelfl(main_mask, hpriv->main_mask_reg_addr);
+	main_irq_mask = readl(hpriv->main_irq_mask_addr);
+	main_irq_mask &= ~((DONE_IRQ | ERR_IRQ) << shift);
+	writelfl(main_irq_mask, hpriv->main_irq_mask_addr);
 }
 
 static void mv_eh_thaw(struct ata_port *ap)
@@ -2423,7 +2424,7 @@ static void mv_eh_thaw(struct ata_port *ap)
 	unsigned int shift, hardport, port = ap->port_no;
 	void __iomem *hc_mmio = mv_hc_base_from_port(hpriv->base, port);
 	void __iomem *port_mmio = mv_ap_base(ap);
-	u32 main_mask, hc_irq_cause;
+	u32 main_irq_mask, hc_irq_cause;
 
 	/* FIXME: handle coalescing completion events properly */
 
@@ -2438,9 +2439,9 @@ static void mv_eh_thaw(struct ata_port *ap)
 	writelfl(hc_irq_cause, hc_mmio + HC_IRQ_CAUSE_OFS);
 
 	/* enable assertion of portN err, done events */
-	main_mask = readl(hpriv->main_mask_reg_addr);
-	main_mask |= ((DONE_IRQ | ERR_IRQ) << shift);
-	writelfl(main_mask, hpriv->main_mask_reg_addr);
+	main_irq_mask = readl(hpriv->main_irq_mask_addr);
+	main_irq_mask |= ((DONE_IRQ | ERR_IRQ) << shift);
+	writelfl(main_irq_mask, hpriv->main_irq_mask_addr);
 }
 
 /**
@@ -2654,15 +2655,15 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 		goto done;
 
 	if (HAS_PCI(host)) {
-		hpriv->main_cause_reg_addr = mmio + HC_MAIN_IRQ_CAUSE_OFS;
-		hpriv->main_mask_reg_addr  = mmio + HC_MAIN_IRQ_MASK_OFS;
+		hpriv->main_irq_cause_addr = mmio + PCI_HC_MAIN_IRQ_CAUSE_OFS;
+		hpriv->main_irq_mask_addr  = mmio + PCI_HC_MAIN_IRQ_MASK_OFS;
 	} else {
-		hpriv->main_cause_reg_addr = mmio + HC_SOC_MAIN_IRQ_CAUSE_OFS;
-		hpriv->main_mask_reg_addr  = mmio + HC_SOC_MAIN_IRQ_MASK_OFS;
+		hpriv->main_irq_cause_addr = mmio + SOC_HC_MAIN_IRQ_CAUSE_OFS;
+		hpriv->main_irq_mask_addr  = mmio + SOC_HC_MAIN_IRQ_MASK_OFS;
 	}
 
 	/* global interrupt mask: 0 == mask everything */
-	writel(0, hpriv->main_mask_reg_addr);
+	writel(0, hpriv->main_irq_mask_addr);
 
 	n_hc = mv_get_hc_count(host->ports[0]->flags);
 
@@ -2712,23 +2713,23 @@ static int mv_init_host(struct ata_host *host, unsigned int board_idx)
 		writelfl(hpriv->unmask_all_irqs, mmio + hpriv->irq_mask_ofs);
 		if (IS_GEN_I(hpriv))
 			writelfl(~HC_MAIN_MASKED_IRQS_5,
-				 hpriv->main_mask_reg_addr);
+				 hpriv->main_irq_mask_addr);
 		else
 			writelfl(~HC_MAIN_MASKED_IRQS,
-				 hpriv->main_mask_reg_addr);
+				 hpriv->main_irq_mask_addr);
 
 		VPRINTK("HC MAIN IRQ cause/mask=0x%08x/0x%08x "
 			"PCI int cause/mask=0x%08x/0x%08x\n",
-			readl(hpriv->main_cause_reg_addr),
-			readl(hpriv->main_mask_reg_addr),
+			readl(hpriv->main_irq_cause_addr),
+			readl(hpriv->main_irq_mask_addr),
 			readl(mmio + hpriv->irq_cause_ofs),
 			readl(mmio + hpriv->irq_mask_ofs));
 	} else {
 		writelfl(~HC_MAIN_MASKED_IRQS_SOC,
-			 hpriv->main_mask_reg_addr);
+			 hpriv->main_irq_mask_addr);
 		VPRINTK("HC MAIN IRQ cause/mask=0x%08x/0x%08x\n",
-			readl(hpriv->main_cause_reg_addr),
-			readl(hpriv->main_mask_reg_addr));
+			readl(hpriv->main_irq_cause_addr),
+			readl(hpriv->main_irq_mask_addr));
 	}
 done:
 	return rc;
