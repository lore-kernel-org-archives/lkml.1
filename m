Return-Path: <linux-kernel-owner+w=401wt.eu-S965502AbXA3O1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965502AbXA3O1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965501AbXA3O1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:27:22 -0500
Received: from havoc.gtf.org ([69.61.125.42]:42255 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965498AbXA3O1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:27:20 -0500
Date: Tue, 30 Jan 2007 09:27:18 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20070130142717.GA22521@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c          |    2 +-
 drivers/ata/libata-core.c   |    2 +-
 drivers/ata/libata-eh.c     |    2 +-
 drivers/ata/libata-scsi.c   |   60 +++++++++++++++++++++++++++++++++++--------
 drivers/ata/pata_platform.c |    4 ++-
 drivers/ata/pata_sil680.c   |    2 +-
 6 files changed, 56 insertions(+), 16 deletions(-)

Andrew Morton (1):
      pata_platform: set_mode fix

David Milburn (1):
      libata-scsi: ata_task_ioctl should return ATA registers from sense data

Lennert Buytenhek (1):
      ata_if_xfermask() word 51 fix

Robert Hancock (1):
      libata: fix translation for START STOP UNIT

Sergei Shtylyov (1):
      pata_sil680: PIO1 taskfile transfers overclocking fix (repost)

Tejun Heo (2):
      ahci: port_no should be used when clearing IRQ in ahci_thaw()
      libata: fix ata_eh_suspend() return value

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 28a82e3..48616c6 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1282,7 +1282,7 @@ static void ahci_thaw(struct ata_port *ap)
 	/* clear IRQ */
 	tmp = readl(port_mmio + PORT_IRQ_STAT);
 	writel(tmp, port_mmio + PORT_IRQ_STAT);
-	writel(1 << ap->id, mmio + HOST_IRQ_STAT);
+	writel(1 << ap->port_no, mmio + HOST_IRQ_STAT);
 
 	/* turn IRQ back on */
 	writel(DEF_PORT_IRQ, port_mmio + PORT_IRQ_MASK);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a388a8d..cf70702 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1037,7 +1037,7 @@ static unsigned int ata_id_xfermask(const u16 *id)
 		 * the PIO timing number for the maximum. Turn it into
 		 * a mask.
 		 */
-		u8 mode = id[ATA_ID_OLD_PIO_MODES] & 0xFF;
+		u8 mode = (id[ATA_ID_OLD_PIO_MODES] >> 8) & 0xFF;
 		if (mode < 5)	/* Valid PIO range */
                 	pio_mask = (2 << mode) - 1;
 		else
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 56cf59b..7484358 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1796,7 +1796,7 @@ static int ata_eh_suspend(struct ata_port *ap, struct ata_device **r_failed_dev)
 		*r_failed_dev = dev;
 
 	DPRINTK("EXIT\n");
-	return 0;
+	return rc;
 }
 
 /**
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7cc5a4a..73902d3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -273,8 +273,8 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 {
 	int rc = 0;
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
-	u8 args[7];
-	struct scsi_sense_hdr sshdr;
+	u8 args[7], *sensebuf = NULL;
+	int cmd_result;
 
 	if (arg == NULL)
 		return -EINVAL;
@@ -282,10 +282,14 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	if (copy_from_user(args, arg, sizeof(args)))
 		return -EFAULT;
 
+	sensebuf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
+	if (!sensebuf)
+		return -ENOMEM;
+
 	memset(scsi_cmd, 0, sizeof(scsi_cmd));
 	scsi_cmd[0]  = ATA_16;
 	scsi_cmd[1]  = (3 << 1); /* Non-data */
-	/* scsi_cmd[2] is already 0 -- no off.line, cc, or data xfer */
+	scsi_cmd[2]  = 0x20;     /* cc but no off.line or data xfer */
 	scsi_cmd[4]  = args[1];
 	scsi_cmd[6]  = args[2];
 	scsi_cmd[8]  = args[3];
@@ -295,11 +299,46 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	if (scsi_execute_req(scsidev, scsi_cmd, DMA_NONE, NULL, 0, &sshdr,
-			     (10*HZ), 5))
+	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
+				sensebuf, (10*HZ), 5, 0);
+
+	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
+		u8 *desc = sensebuf + 8;
+		cmd_result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
+
+		/* If we set cc then ATA pass-through will cause a
+		 * check condition even if no error. Filter that. */
+		if (cmd_result & SAM_STAT_CHECK_CONDITION) {
+			struct scsi_sense_hdr sshdr;
+			scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
+						&sshdr);
+			if (sshdr.sense_key==0 &&
+				sshdr.asc==0 && sshdr.ascq==0)
+				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
+		}
+
+		/* Send userspace ATA registers */
+		if (sensebuf[0] == 0x72 &&	/* format is "descriptor" */
+				desc[0] == 0x09) {/* code is "ATA Descriptor" */
+			args[0] = desc[13];	/* status */
+			args[1] = desc[3];	/* error */
+			args[2] = desc[5];	/* sector count (0:7) */
+			args[3] = desc[7];	/* lbal */
+			args[4] = desc[9];	/* lbam */
+			args[5] = desc[11];	/* lbah */
+			args[6] = desc[12];	/* select */
+			if (copy_to_user(arg, args, sizeof(args)))
+				rc = -EFAULT;
+		}
+	}
+
+	if (cmd_result) {
 		rc = -EIO;
+		goto error;
+	}
 
-	/* Need code to retrieve data from check condition? */
+ error:
+	kfree(sensebuf);
 	return rc;
 }
 
@@ -983,11 +1022,10 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 		}
 
 		tf->command = ATA_CMD_VERIFY;	/* READ VERIFY */
-	} else {
-		tf->nsect = 0;	/* time period value (0 implies now) */
-		tf->command = ATA_CMD_STANDBY;
-		/* Consider: ATA STANDBY IMMEDIATE command */
-	}
+	} else
+		/* Issue ATA STANDBY IMMEDIATE command */
+		tf->command = ATA_CMD_STANDBYNOW1;
+
 	/*
 	 * Standby and Idle condition timers could be implemented but that
 	 * would require libata to implement the Power condition mode page
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 443b1d8..ca2999f 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -30,7 +30,8 @@ static int pio_mask = 1;
  * Provide our own set_mode() as we don't want to change anything that has
  * already been configured..
  */
-static void pata_platform_set_mode(struct ata_port *ap)
+static int pata_platform_set_mode(struct ata_port *ap,
+				struct ata_device **r_failed_dev)
 {
 	int i;
 
@@ -44,6 +45,7 @@ static void pata_platform_set_mode(struct ata_port *ap)
 			dev->flags |= ATA_DFLAG_PIO;
 		}
 	}
+	return 0;
 }
 
 static void pata_platform_host_stop(struct ata_host *host)
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 32cf0bf..e8dfd8f 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -135,7 +135,7 @@ static void sil680_error_handler(struct ata_port *ap)
 static void sil680_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	static u16 speed_p[5] = { 0x328A, 0x2283, 0x1104, 0x10C3, 0x10C1 };
-	static u16 speed_t[5] = { 0x328A, 0x1281, 0x1281, 0x10C3, 0x10C1 };
+	static u16 speed_t[5] = { 0x328A, 0x2283, 0x1281, 0x10C3, 0x10C1 };
 
 	unsigned long tfaddr = sil680_selreg(ap, 0x02);
 	unsigned long addr = sil680_seldev(ap, adev, 0x04);
