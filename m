Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbZBQPJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbZBQPJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZBQPJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:09:42 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:61610 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZBQPJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:09:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ToKEvvL4BDDiVOuuR9AFbClf6DLi7x9aSGyHstdJVH8y0qk7Tam4UGKHbh3Vh+a4Y5
         jkrChtmxMkL1ymUoM0zf3Cs0CUo3NX/Q0BtLtUwHpZxOKzefTfPsQjPmY5NpaBihTBVD
         d1UPz47C0BBfWqn3dmh9uUpvyfVbWV7oswBEs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for February 12 (ide)
Date: Tue, 17 Feb 2009 15:19:26 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090216; KDE/4.2.0; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
References: <20090212194408.ff7489c1.sfr@canb.auug.org.au> <499451E0.6060004@oracle.com>
In-Reply-To: <499451E0.6060004@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902171519.27031.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 February 2009, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090211:
> 
> 
> When
> # CONFIG_BLK_DEV_IDEDMA is not set
> 
> linux-next-20090212/drivers/ide/ide-taskfile.c:108: error: 'ide_dma_intr' undeclared (first use in this function)

Thanks for spotting this, I fixed it in the revised patch:

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add ->dma_timer_expiry method and remove ->dma_exec_cmd one (v2)

* Rename dma_timer_expiry() to ide_dma_sff_timer_expiry() and export it.

* Add ->dma_timer_expiry method and use it to set hwif->expiry for
  ATA_PROT_DMA protocol in do_rw_taskfile().

* Initialize ->dma_timer_expiry to ide_dma_sff_timer_expiry() for SFF hosts.

* Move setting hwif->expiry from ide_execute_command() to its users and drop
  'expiry' argument.

* Use ide_execute_command() instead of ->dma_exec_cmd in do_rw_taskfile().

* Remove ->dma_exec_cmd method and its implementations.

* Unexport ide_execute_command() and ide_dma_intr().

v2:
* Fix CONFIG_BLK_DEV_IDEDMA=n build (noticed by Randy Dunlap).

* Fix *dma_expiry naming (suggested by Sergei Shtylyov).

There should be no functional changes caused by this patch.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/alim15x3.c     |    2 +-
 drivers/ide/au1xxx-ide.c   |    8 --------
 drivers/ide/cmd64x.c       |    6 +++---
 drivers/ide/cs5536.c       |    2 +-
 drivers/ide/hpt366.c       |    6 +++---
 drivers/ide/icside.c       |    7 -------
 drivers/ide/ide-atapi.c    |    3 ++-
 drivers/ide/ide-dma-sff.c  |   15 ++++-----------
 drivers/ide/ide-dma.c      |    1 -
 drivers/ide/ide-iops.c     |    6 +-----
 drivers/ide/ide-taskfile.c |    6 ++++--
 drivers/ide/it821x.c       |    2 +-
 drivers/ide/ns87415.c      |    2 +-
 drivers/ide/pdc202xx_old.c |    4 ++--
 drivers/ide/pmac.c         |    8 --------
 drivers/ide/sc1200.c       |    2 +-
 drivers/ide/scc_pata.c     |    2 +-
 drivers/ide/siimage.c      |    2 +-
 drivers/ide/sl82c105.c     |    2 +-
 drivers/ide/tc86c001.c     |    2 +-
 drivers/ide/trm290.c       |    6 ------
 drivers/ide/tx4939ide.c    |    2 +-
 include/linux/ide.h        |    8 ++++----
 23 files changed, 33 insertions(+), 71 deletions(-)

Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -504,11 +504,11 @@ static const struct ide_port_ops ali_por
 static const struct ide_dma_ops ali_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ali15x3_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -290,13 +290,6 @@ static void auide_dma_start(ide_drive_t 
 }
 
 
-static void auide_dma_exec_cmd(ide_drive_t *drive, u8 command)
-{
-	/* issue cmd to drive */
-	ide_execute_command(drive, command, &ide_dma_intr,
-			    (2*WAIT_CMD), NULL);
-}
-
 static int auide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	if (auide_build_dmatable(drive, cmd) == 0) {
@@ -356,7 +349,6 @@ static void auide_init_dbdma_dev(dbdev_t
 static const struct ide_dma_ops au1xxx_dma_ops = {
 	.dma_host_set		= auide_dma_host_set,
 	.dma_setup		= auide_dma_setup,
-	.dma_exec_cmd		= auide_dma_exec_cmd,
 	.dma_start		= auide_dma_start,
 	.dma_end		= auide_dma_end,
 	.dma_test_irq		= auide_dma_test_irq,
Index: b/drivers/ide/cmd64x.c
===================================================================
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -379,11 +379,11 @@ static const struct ide_port_ops cmd64x_
 static const struct ide_dma_ops cmd64x_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= cmd64x_dma_end,
 	.dma_test_irq		= cmd64x_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
@@ -391,11 +391,11 @@ static const struct ide_dma_ops cmd64x_d
 static const struct ide_dma_ops cmd646_rev1_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= cmd646_1_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
@@ -403,11 +403,11 @@ static const struct ide_dma_ops cmd646_r
 static const struct ide_dma_ops cmd648_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= cmd648_dma_end,
 	.dma_test_irq		= cmd648_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
Index: b/drivers/ide/cs5536.c
===================================================================
--- a/drivers/ide/cs5536.c
+++ b/drivers/ide/cs5536.c
@@ -231,11 +231,11 @@ static const struct ide_port_ops cs5536_
 static const struct ide_dma_ops cs5536_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= cs5536_dma_start,
 	.dma_end		= cs5536_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 };
 
Index: b/drivers/ide/hpt366.c
===================================================================
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -1418,11 +1418,11 @@ static const struct ide_port_ops hpt3xx_
 static const struct ide_dma_ops hpt37x_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= hpt374_dma_end,
 	.dma_test_irq		= hpt374_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
@@ -1430,11 +1430,11 @@ static const struct ide_dma_ops hpt37x_d
 static const struct ide_dma_ops hpt370_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= hpt370_dma_start,
 	.dma_end		= hpt370_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= hpt370_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
@@ -1442,11 +1442,11 @@ static const struct ide_dma_ops hpt370_d
 static const struct ide_dma_ops hpt36x_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= hpt366_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -351,12 +351,6 @@ static int icside_dma_setup(ide_drive_t 
 	return 0;
 }
 
-static void icside_dma_exec_cmd(ide_drive_t *drive, u8 cmd)
-{
-	/* issue cmd to drive */
-	ide_execute_command(drive, cmd, ide_dma_intr, 2 * WAIT_CMD, NULL);
-}
-
 static int icside_dma_test_irq(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -380,7 +374,6 @@ static int icside_dma_init(ide_hwif_t *h
 static const struct ide_dma_ops icside_v6_dma_ops = {
 	.dma_host_set		= icside_dma_host_set,
 	.dma_setup		= icside_dma_setup,
-	.dma_exec_cmd		= icside_dma_exec_cmd,
 	.dma_start		= icside_dma_start,
 	.dma_end		= icside_dma_end,
 	.dma_test_irq		= icside_dma_test_irq,
Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -679,8 +679,9 @@ ide_startstop_t ide_issue_pc(ide_drive_t
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
 		if (drive->dma)
 			drive->waiting_for_dma = 0;
+		hwif->expiry = expiry;
 		ide_execute_command(drive, ATA_CMD_PACKET, ide_transfer_pc,
-				    timeout, expiry);
+				    timeout);
 		return ide_started;
 	} else {
 		ide_execute_pkt_cmd(drive);
Index: b/drivers/ide/ide-dma-sff.c
===================================================================
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -224,7 +224,7 @@ int ide_dma_setup(ide_drive_t *drive, st
 EXPORT_SYMBOL_GPL(ide_dma_setup);
 
 /**
- *	dma_timer_expiry	-	handle a DMA timeout
+ *	ide_dma_sff_timer_expiry	-	handle a DMA timeout
  *	@drive: Drive that timed out
  *
  *	An IDE DMA transfer timed out. In the event of an error we ask
@@ -237,7 +237,7 @@ EXPORT_SYMBOL_GPL(ide_dma_setup);
  *	This can occur if an interrupt is lost or due to hang or bugs.
  */
 
-static int dma_timer_expiry(ide_drive_t *drive)
+int ide_dma_sff_timer_expiry(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	u8 dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
@@ -261,14 +261,7 @@ static int dma_timer_expiry(ide_drive_t 
 
 	return 0;	/* Status is unknown -- reset the bus */
 }
-
-void ide_dma_exec_cmd(ide_drive_t *drive, u8 command)
-{
-	/* issue cmd to drive */
-	ide_execute_command(drive, command, &ide_dma_intr, 2 * WAIT_CMD,
-			    dma_timer_expiry);
-}
-EXPORT_SYMBOL_GPL(ide_dma_exec_cmd);
+EXPORT_SYMBOL_GPL(ide_dma_sff_timer_expiry);
 
 void ide_dma_start(ide_drive_t *drive)
 {
@@ -342,10 +335,10 @@ EXPORT_SYMBOL_GPL(ide_dma_test_irq);
 const struct ide_dma_ops sff_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -110,7 +110,6 @@ ide_startstop_t ide_dma_intr(ide_drive_t
 	}
 	return ide_error(drive, "dma_intr", stat);
 }
-EXPORT_SYMBOL_GPL(ide_dma_intr);
 
 int ide_dma_good_drive(ide_drive_t *drive)
 {
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -454,7 +454,6 @@ EXPORT_SYMBOL(ide_set_handler);
  *	@command: command byte to write
  *	@handler: handler for next phase
  *	@timeout: timeout for command
- *	@expiry:  handler to run on timeout
  *
  *	Helper function to issue an IDE command. This handles the
  *	atomicity requirements, command timing and ensures that the
@@ -463,13 +462,11 @@ EXPORT_SYMBOL(ide_set_handler);
  */
 
 void ide_execute_command(ide_drive_t *drive, u8 cmd, ide_handler_t *handler,
-			 unsigned timeout, ide_expiry_t *expiry)
+			 unsigned timeout)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
 
-	hwif->expiry = expiry;
-
 	spin_lock_irqsave(&hwif->lock, flags);
 	__ide_set_handler(drive, handler, timeout);
 	hwif->tp_ops->exec_command(hwif, cmd);
@@ -482,7 +479,6 @@ void ide_execute_command(ide_drive_t *dr
 	ndelay(400);
 	spin_unlock_irqrestore(&hwif->lock, flags);
 }
-EXPORT_SYMBOL(ide_execute_command);
 
 void ide_execute_pkt_cmd(ide_drive_t *drive)
 {
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -98,14 +98,16 @@ ide_startstop_t do_rw_taskfile(ide_drive
 		if (handler == NULL)
 			handler = task_no_data_intr;
 		ide_execute_command(drive, tf->command, handler,
-				    WAIT_WORSTCASE, NULL);
+				    WAIT_WORSTCASE);
 		return ide_started;
 	case ATA_PROT_DMA:
 		if ((drive->dev_flags & IDE_DFLAG_USING_DMA) == 0 ||
 		    ide_build_sglist(drive, cmd) == 0 ||
 		    dma_ops->dma_setup(drive, cmd))
 			return ide_stopped;
-		dma_ops->dma_exec_cmd(drive, tf->command);
+		hwif->expiry = dma_ops->dma_timer_expiry;
+		ide_execute_command(drive, tf->command, ide_dma_intr,
+				    2 * WAIT_CMD);
 		dma_ops->dma_start(drive);
 	default:
 		return ide_started;
Index: b/drivers/ide/it821x.c
===================================================================
--- a/drivers/ide/it821x.c
+++ b/drivers/ide/it821x.c
@@ -509,10 +509,10 @@ static void it821x_quirkproc(ide_drive_t
 static struct ide_dma_ops it821x_pass_through_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= it821x_dma_start,
 	.dma_end		= it821x_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
Index: b/drivers/ide/ns87415.c
===================================================================
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -301,11 +301,11 @@ static const struct ide_port_ops ns87415
 static const struct ide_dma_ops ns87415_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ns87415_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= ns87415_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= superio_dma_sff_read_status,
 };
Index: b/drivers/ide/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pdc202xx_old.c
+++ b/drivers/ide/pdc202xx_old.c
@@ -331,11 +331,11 @@ static const struct ide_port_ops pdc2026
 static const struct ide_dma_ops pdc20246_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= pdc202xx_dma_test_irq,
 	.dma_lost_irq		= pdc202xx_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= pdc202xx_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
@@ -343,11 +343,11 @@ static const struct ide_dma_ops pdc20246
 static const struct ide_dma_ops pdc2026x_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= pdc202xx_dma_start,
 	.dma_end		= pdc202xx_dma_end,
 	.dma_test_irq		= pdc202xx_dma_test_irq,
 	.dma_lost_irq		= pdc202xx_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= pdc202xx_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1527,13 +1527,6 @@ static int pmac_ide_dma_setup(ide_drive_
 	return 0;
 }
 
-static void
-pmac_ide_dma_exec_cmd(ide_drive_t *drive, u8 command)
-{
-	/* issue cmd to drive */
-	ide_execute_command(drive, command, &ide_dma_intr, 2*WAIT_CMD, NULL);
-}
-
 /*
  * Kick the DMA controller into life after the DMA command has been issued
  * to the drive.
@@ -1654,7 +1647,6 @@ pmac_ide_dma_lost_irq (ide_drive_t *driv
 static const struct ide_dma_ops pmac_dma_ops = {
 	.dma_host_set		= pmac_ide_dma_host_set,
 	.dma_setup		= pmac_ide_dma_setup,
-	.dma_exec_cmd		= pmac_ide_dma_exec_cmd,
 	.dma_start		= pmac_ide_dma_start,
 	.dma_end		= pmac_ide_dma_end,
 	.dma_test_irq		= pmac_ide_dma_test_irq,
Index: b/drivers/ide/sc1200.c
===================================================================
--- a/drivers/ide/sc1200.c
+++ b/drivers/ide/sc1200.c
@@ -286,11 +286,11 @@ static const struct ide_port_ops sc1200_
 static const struct ide_dma_ops sc1200_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= sc1200_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -868,12 +868,12 @@ static const struct ide_port_ops scc_por
 static const struct ide_dma_ops scc_dma_ops = {
 	.dma_host_set		= scc_dma_host_set,
 	.dma_setup		= scc_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= scc_dma_start,
 	.dma_end		= scc_dma_end,
 	.dma_test_irq		= scc_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timeout		= ide_dma_timeout,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_sff_read_status	= scc_dma_sff_read_status,
 };
 
Index: b/drivers/ide/siimage.c
===================================================================
--- a/drivers/ide/siimage.c
+++ b/drivers/ide/siimage.c
@@ -711,10 +711,10 @@ static const struct ide_port_ops sil_sat
 static const struct ide_dma_ops sil_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= siimage_dma_test_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
Index: b/drivers/ide/sl82c105.c
===================================================================
--- a/drivers/ide/sl82c105.c
+++ b/drivers/ide/sl82c105.c
@@ -293,11 +293,11 @@ static const struct ide_port_ops sl82c10
 static const struct ide_dma_ops sl82c105_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= sl82c105_dma_start,
 	.dma_end		= sl82c105_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= sl82c105_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= sl82c105_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
Index: b/drivers/ide/tc86c001.c
===================================================================
--- a/drivers/ide/tc86c001.c
+++ b/drivers/ide/tc86c001.c
@@ -182,11 +182,11 @@ static const struct ide_port_ops tc86c00
 static const struct ide_dma_ops tc86c001_dma_ops = {
 	.dma_host_set		= ide_dma_host_set,
 	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= tc86c001_dma_start,
 	.dma_end		= ide_dma_end,
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
Index: b/drivers/ide/trm290.c
===================================================================
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -176,11 +176,6 @@ static void trm290_selectproc (ide_drive
 	trm290_prepare_drive(drive, !!(drive->dev_flags & IDE_DFLAG_USING_DMA));
 }
 
-static void trm290_dma_exec_cmd(ide_drive_t *drive, u8 command)
-{
-	ide_execute_command(drive, command, &ide_dma_intr, WAIT_CMD, NULL);
-}
-
 static int trm290_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
 {
 	ide_hwif_t *hwif = drive->hwif;
@@ -315,7 +310,6 @@ static const struct ide_port_ops trm290_
 static struct ide_dma_ops trm290_dma_ops = {
 	.dma_host_set		= trm290_dma_host_set,
 	.dma_setup 		= trm290_dma_setup,
-	.dma_exec_cmd		= trm290_dma_exec_cmd,
 	.dma_start 		= trm290_dma_start,
 	.dma_end		= trm290_dma_end,
 	.dma_test_irq		= trm290_dma_test_irq,
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -627,11 +627,11 @@ static const struct ide_port_ops tx4939i
 static const struct ide_dma_ops tx4939ide_dma_ops = {
 	.dma_host_set		= tx4939ide_dma_host_set,
 	.dma_setup		= tx4939ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
 	.dma_start		= ide_dma_start,
 	.dma_end		= tx4939ide_dma_end,
 	.dma_test_irq		= tx4939ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
 	.dma_timeout		= ide_dma_timeout,
 	.dma_sff_read_status	= tx4939ide_dma_sff_read_status,
 };
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -714,11 +714,11 @@ struct ide_port_ops {
 struct ide_dma_ops {
 	void	(*dma_host_set)(struct ide_drive_s *, int);
 	int	(*dma_setup)(struct ide_drive_s *, struct ide_cmd *);
-	void	(*dma_exec_cmd)(struct ide_drive_s *, u8);
 	void	(*dma_start)(struct ide_drive_s *);
 	int	(*dma_end)(struct ide_drive_s *);
 	int	(*dma_test_irq)(struct ide_drive_s *);
 	void	(*dma_lost_irq)(struct ide_drive_s *);
+	int	(*dma_timer_expiry)(struct ide_drive_s *);
 	void	(*dma_timeout)(struct ide_drive_s *);
 	/*
 	 * The following method is optional and only required to be
@@ -1135,8 +1135,7 @@ void ide_kill_rq(ide_drive_t *, struct r
 void __ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int);
 void ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int);
 
-void ide_execute_command(ide_drive_t *, u8, ide_handler_t *, unsigned int,
-			 ide_expiry_t *);
+void ide_execute_command(ide_drive_t *, u8, ide_handler_t *, unsigned int);
 
 void ide_execute_pkt_cmd(ide_drive_t *);
 
@@ -1450,10 +1449,10 @@ int config_drive_for_dma(ide_drive_t *);
 int ide_build_dmatable(ide_drive_t *, struct ide_cmd *);
 void ide_dma_host_set(ide_drive_t *, int);
 int ide_dma_setup(ide_drive_t *, struct ide_cmd *);
-void ide_dma_exec_cmd(ide_drive_t *, u8);
 extern void ide_dma_start(ide_drive_t *);
 int ide_dma_end(ide_drive_t *);
 int ide_dma_test_irq(ide_drive_t *);
+int ide_dma_sff_timer_expiry(ide_drive_t *);
 u8 ide_dma_sff_read_status(ide_hwif_t *);
 extern const struct ide_dma_ops sff_dma_ops;
 #else
@@ -1474,6 +1473,7 @@ static inline void ide_dma_on(ide_drive_
 static inline void ide_dma_verbose(ide_drive_t *drive) { ; }
 static inline int ide_set_dma(ide_drive_t *drive) { return 1; }
 static inline void ide_check_dma_crc(ide_drive_t *drive) { ; }
+static inline ide_startstop_t ide_dma_intr(ide_drive_t *drive) { return ide_stopped; }
 static inline ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error) { return ide_stopped; }
 static inline void ide_release_dma_engine(ide_hwif_t *hwif) { ; }
 static inline int ide_build_sglist(ide_drive_t *drive,
