Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbYCAQ05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbYCAQ05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763035AbYCAQXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:23:49 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57362 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763023AbYCAQXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:23:47 -0500
Date: Sat, 1 Mar 2008 18:22:21 +0200
From: Adrian Bunk <bunk@kernel.org>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] libata-scsi.c: possible cleanups
Message-ID: <20080301162221.GV25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains thefollowing possible cleanups:
- make the following needlessly global functions static:
  - ata_cmd_ioctl()
  - ata_task_ioctl()
  - ata_scsi_rbuf_fill()
  - ata_scsiop_inq_std()
  - ata_scsiop_inq_00()
  - ata_scsiop_inq_80()
  - ata_scsiop_inq_83()
  - ata_scsiop_noop()
  - ata_scsiop_mode_sense()
  - ata_scsiop_read_cap()
  - ata_scsiop_report_luns()
  - ata_scsi_set_sense()
  - ata_scsi_simulate()
- #if 0 the following unused global function:
  - ata_scsi_badcmd()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ata/libata-core.c |    1 
 drivers/ata/libata-scsi.c |   50 +++++++++++++++++++++-----------------
 drivers/ata/libata.h      |   27 --------------------
 include/linux/libata.h    |    2 -
 4 files changed, 28 insertions(+), 52 deletions(-)

6c8c9137945d96fbf5bef2f707d1b25a065a92a1 foobar
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 774ca30..1846a7e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -7835,7 +7835,6 @@ EXPORT_SYMBOL_GPL(ata_host_resume);
 #endif /* CONFIG_PM */
 EXPORT_SYMBOL_GPL(ata_id_string);
 EXPORT_SYMBOL_GPL(ata_id_c_string);
-EXPORT_SYMBOL_GPL(ata_scsi_simulate);
 
 EXPORT_SYMBOL_GPL(ata_pio_need_iordy);
 EXPORT_SYMBOL_GPL(ata_timing_find_mode);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0562b0a..832ef8d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -59,6 +59,9 @@ static struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
 					    const struct scsi_device *scsidev);
 static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
 			      unsigned int id, unsigned int lun);
+static void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq);
+static void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
+			      void (*done)(struct scsi_cmnd *));
 
 
 #define RW_RECOVERY_MPAGE 0x1
@@ -265,7 +268,7 @@ static int ata_get_identity(struct scsi_device *sdev, void __user *arg)
  *	RETURNS:
  *	Zero on success, negative errno on error.
  */
-int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
+static int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 {
 	int rc = 0;
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
@@ -374,7 +377,7 @@ error:
  *	RETURNS:
  *	Zero on success, negative errno on error.
  */
-int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
+static int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 {
 	int rc = 0;
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
@@ -1687,7 +1690,7 @@ static inline void ata_scsi_rbuf_put(struct scsi_cmnd *cmd, u8 *buf)
  *	spin_lock_irqsave(host lock)
  */
 
-void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
+static void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
 			unsigned int (*actor) (struct ata_scsi_args *args,
 					       u8 *rbuf, unsigned int buflen))
 {
@@ -1734,8 +1737,8 @@ void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
  *	spin_lock_irqsave(host lock)
  */
 
-unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf,
-			       unsigned int buflen)
+static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf,
+				       unsigned int buflen)
 {
 	u8 hdr[] = {
 		TYPE_DISK,
@@ -1790,8 +1793,8 @@ unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf,
  *	spin_lock_irqsave(host lock)
  */
 
-unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf,
-			      unsigned int buflen)
+static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf,
+				      unsigned int buflen)
 {
 	const u8 pages[] = {
 		0x00,	/* page 0x00, this page */
@@ -1818,8 +1821,8 @@ unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf,
  *	spin_lock_irqsave(host lock)
  */
 
-unsigned int ata_scsiop_inq_80(struct ata_scsi_args *args, u8 *rbuf,
-			      unsigned int buflen)
+static unsigned int ata_scsiop_inq_80(struct ata_scsi_args *args, u8 *rbuf,
+				      unsigned int buflen)
 {
 	const u8 hdr[] = {
 		0,
@@ -1851,8 +1854,8 @@ unsigned int ata_scsiop_inq_80(struct ata_scsi_args *args, u8 *rbuf,
  *	spin_lock_irqsave(host lock)
  */
 
-unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf,
-			      unsigned int buflen)
+static unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf,
+				      unsigned int buflen)
 {
 	int num;
 	const int sat_model_serial_desc_len = 68;
@@ -1958,8 +1961,8 @@ static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf,
  *	spin_lock_irqsave(host lock)
  */
 
-unsigned int ata_scsiop_noop(struct ata_scsi_args *args, u8 *rbuf,
-			    unsigned int buflen)
+static unsigned int ata_scsiop_noop(struct ata_scsi_args *args, u8 *rbuf,
+				    unsigned int buflen)
 {
 	VPRINTK("ENTER\n");
 	return 0;
@@ -2099,8 +2102,8 @@ static int ata_dev_supports_fua(u16 *id)
  *	spin_lock_irqsave(host lock)
  */
 
-unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf,
-				  unsigned int buflen)
+static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf,
+					  unsigned int buflen)
 {
 	struct ata_device *dev = args->dev;
 	u8 *scsicmd = args->cmd->cmnd, *p, *last;
@@ -2237,8 +2240,8 @@ saving_not_supp:
  *	LOCKING:
  *	None.
  */
-unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf,
-				 unsigned int buflen)
+static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf,
+					unsigned int buflen)
 {
 	u64 last_lba = args->dev->n_sectors - 1; /* LBA of the last block */
 
@@ -2288,8 +2291,9 @@ unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf,
  *	spin_lock_irqsave(host lock)
  */
 
-unsigned int ata_scsiop_report_luns(struct ata_scsi_args *args, u8 *rbuf,
-				   unsigned int buflen)
+static unsigned int ata_scsiop_report_luns(struct ata_scsi_args *args,
+					   u8 *rbuf,
+					   unsigned int buflen)
 {
 	VPRINTK("ENTER\n");
 	rbuf[3] = 8;	/* just one lun, LUN 0, size 8 bytes */
@@ -2314,7 +2318,7 @@ unsigned int ata_scsiop_report_luns(struct ata_scsi_args *args, u8 *rbuf,
  *	Not required
  */
 
-void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
+static void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
 {
 	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 
@@ -2325,6 +2329,7 @@ void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
 	cmd->sense_buffer[13] = ascq;
 }
 
+#if 0
 /**
  *	ata_scsi_badcmd - End a SCSI request with an error
  *	@cmd: SCSI request to be handled
@@ -2347,6 +2352,7 @@ void ata_scsi_badcmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *), u8
 
 	done(cmd);
 }
+#endif  /*  0  */
 
 static void atapi_sense_complete(struct ata_queued_cmd *qc)
 {
@@ -3055,8 +3061,8 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
  *	spin_lock_irqsave(host lock)
  */
 
-void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
-		      void (*done)(struct scsi_cmnd *))
+static void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
+			      void (*done)(struct scsi_cmnd *))
 {
 	struct ata_scsi_args args;
 	const u8 *scsicmd = cmd->cmnd;
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 0b7aa85..13cb98a 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -91,8 +91,6 @@ extern void swap_buf_le16(u16 *buf, unsigned int buf_words);
 extern void ata_dev_init(struct ata_device *dev);
 extern void ata_link_init(struct ata_port *ap, struct ata_link *link, int pmp);
 extern int sata_link_init_spd(struct ata_link *link);
-extern int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg);
-extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern struct ata_port *ata_port_alloc(struct ata_host *host);
 extern void ata_dev_enable_pm(struct ata_device *dev, enum link_pm policy);
 extern void ata_lpm_schedule(struct ata_port *ap, enum link_pm);
@@ -126,34 +124,9 @@ extern void ata_scsi_scan_host(struct ata_port *ap, int sync);
 extern int ata_scsi_offline_dev(struct ata_device *dev);
 extern void ata_scsi_media_change_notify(struct ata_device *dev);
 extern void ata_scsi_hotplug(struct work_struct *work);
-extern unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf,
-			       unsigned int buflen);
 
-extern unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf,
-			      unsigned int buflen);
-
-extern unsigned int ata_scsiop_inq_80(struct ata_scsi_args *args, u8 *rbuf,
-			      unsigned int buflen);
-extern unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf,
-			      unsigned int buflen);
-extern unsigned int ata_scsiop_noop(struct ata_scsi_args *args, u8 *rbuf,
-			    unsigned int buflen);
 extern unsigned int ata_scsiop_sync_cache(struct ata_scsi_args *args, u8 *rbuf,
 				  unsigned int buflen);
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
diff --git a/include/linux/libata.h b/include/linux/libata.h
index b626f27..55ca169 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -904,8 +904,6 @@ extern int ata_hsm_move(struct ata_port *ap, struct ata_queued_cmd *qc,
 extern void ata_qc_complete(struct ata_queued_cmd *qc);
 extern int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active,
 				    void (*finish_qc)(struct ata_queued_cmd *));
-extern void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
-			      void (*done)(struct scsi_cmnd *));
 extern int ata_std_bios_param(struct scsi_device *sdev,
 			      struct block_device *bdev,
 			      sector_t capacity, int geom[]);

