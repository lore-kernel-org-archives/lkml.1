Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbZBIXTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbZBIXTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZBIXS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:18:57 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:56753 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbZBIXSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:18:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=afNJwpGxVM+khQV1/OdrgR/XZWU7pVgGenoYs2lOXBypN9f37fxPa2YIGpedXw2jWH
         TLJ9oDYTugtnT+LlODjqABNvIqcX9AQHjC/n7O/eMcCAzq0FxtFtdYipRggF5nIq6MpW
         vvjG7PoB95JPeqgL37PilTDHdB/A2qvN76mbQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Feb 2009 00:20:05 +0100
Message-Id: <20090209232005.32406.20153.sendpatchset@localhost.localdomain>
In-Reply-To: <20090209231945.32406.14874.sendpatchset@localhost.localdomain>
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/6] ide: set hwif->expiry prior to calling [__]ide_set_handler()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: set hwif->expiry prior to calling [__]ide_set_handler()

* Set hwif->expiry prior to calling [__]ide_set_handler()
  and drop 'expiry' argument.

* Set hwif->expiry to NULL in ide_{timer_expiry,intr}()
  and remove 'hwif->expiry = NULL' assignments.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-atapi.c    |    6 ++++--
 drivers/ide/ide-cd.c       |    3 ++-
 drivers/ide/ide-eh.c       |    9 ++++-----
 drivers/ide/ide-io.c       |    2 ++
 drivers/ide/ide-iops.c     |   13 +++++++------
 drivers/ide/ide-taskfile.c |    6 +++---
 include/linux/ide.h        |    6 ++----
 7 files changed, 24 insertions(+), 21 deletions(-)

Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -471,7 +471,7 @@ static ide_startstop_t ide_pc_intr(ide_d
 		  rq->cmd[0], bcount);
 next_irq:
 	/* And set the interrupt handler again */
-	ide_set_handler(drive, ide_pc_intr, timeout, NULL);
+	ide_set_handler(drive, ide_pc_intr, timeout);
 	return ide_started;
 }
 
@@ -590,11 +590,13 @@ static ide_startstop_t ide_transfer_pc(i
 		}
 	}
 
+	hwif->expiry = expiry;
+
 	/* Set the interrupt routine */
 	ide_set_handler(drive,
 			(dev_is_idecd(drive) ? drive->irq_handler
 					     : ide_pc_intr),
-			timeout, expiry);
+			timeout);
 
 	/* Begin DMA, if necessary */
 	if (dev_is_idecd(drive)) {
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -953,7 +953,8 @@ static ide_startstop_t cdrom_newpc_intr(
 			expiry = ide_cd_expiry;
 	}
 
-	ide_set_handler(drive, cdrom_newpc_intr, timeout, expiry);
+	hwif->expiry = expiry;
+	ide_set_handler(drive, cdrom_newpc_intr, timeout);
 	return ide_started;
 
 end_request:
Index: b/drivers/ide/ide-eh.c
===================================================================
--- a/drivers/ide/ide-eh.c
+++ b/drivers/ide/ide-eh.c
@@ -175,8 +175,7 @@ static ide_startstop_t atapi_reset_pollf
 		printk(KERN_INFO "%s: ATAPI reset complete\n", drive->name);
 	else {
 		if (time_before(jiffies, hwif->poll_timeout)) {
-			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20,
-					NULL);
+			ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20);
 			/* continue polling */
 			return ide_started;
 		}
@@ -238,7 +237,7 @@ static ide_startstop_t reset_pollfunc(id
 
 	if (!OK_STAT(tmp, 0, ATA_BUSY)) {
 		if (time_before(jiffies, hwif->poll_timeout)) {
-			ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
+			ide_set_handler(drive, &reset_pollfunc, HZ/20);
 			/* continue polling */
 			return ide_started;
 		}
@@ -355,7 +354,7 @@ static ide_startstop_t do_reset1(ide_dri
 		ndelay(400);
 		hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
 		hwif->polling = 1;
-		__ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20, NULL);
+		__ide_set_handler(drive, &atapi_reset_pollfunc, HZ/20);
 		spin_unlock_irqrestore(&hwif->lock, flags);
 		return ide_started;
 	}
@@ -415,7 +414,7 @@ static ide_startstop_t do_reset1(ide_dri
 	udelay(10);
 	hwif->poll_timeout = jiffies + WAIT_WORSTCASE;
 	hwif->polling = 1;
-	__ide_set_handler(drive, &reset_pollfunc, HZ/20, NULL);
+	__ide_set_handler(drive, &reset_pollfunc, HZ/20);
 
 	/*
 	 * Some weird controller like resetting themselves to a strange
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -647,6 +647,7 @@ void ide_timer_expiry (unsigned long dat
 			}
 		}
 		hwif->handler = NULL;
+		hwif->expiry = NULL;
 		/*
 		 * We need to simulate a real interrupt when invoking
 		 * the handler() function, which means we need to
@@ -826,6 +827,7 @@ irqreturn_t ide_intr (int irq, void *dev
 		goto out;
 
 	hwif->handler = NULL;
+	hwif->expiry = NULL;
 	hwif->req_gen++;
 	del_timer(&hwif->timer);
 	spin_unlock(&hwif->lock);
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -425,26 +425,25 @@ int ide_config_drive_speed(ide_drive_t *
  * See also ide_execute_command
  */
 void __ide_set_handler(ide_drive_t *drive, ide_handler_t *handler,
-		       unsigned int timeout, ide_expiry_t *expiry)
+		       unsigned int timeout)
 {
 	ide_hwif_t *hwif = drive->hwif;
 
 	BUG_ON(hwif->handler);
 	hwif->handler		= handler;
-	hwif->expiry		= expiry;
 	hwif->timer.expires	= jiffies + timeout;
 	hwif->req_gen_timer	= hwif->req_gen;
 	add_timer(&hwif->timer);
 }
 
-void ide_set_handler (ide_drive_t *drive, ide_handler_t *handler,
-		      unsigned int timeout, ide_expiry_t *expiry)
+void ide_set_handler(ide_drive_t *drive, ide_handler_t *handler,
+		     unsigned int timeout)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hwif->lock, flags);
-	__ide_set_handler(drive, handler, timeout, expiry);
+	__ide_set_handler(drive, handler, timeout);
 	spin_unlock_irqrestore(&hwif->lock, flags);
 }
 EXPORT_SYMBOL(ide_set_handler);
@@ -469,8 +468,10 @@ void ide_execute_command(ide_drive_t *dr
 	ide_hwif_t *hwif = drive->hwif;
 	unsigned long flags;
 
+	hwif->expiry = expiry;
+
 	spin_lock_irqsave(&hwif->lock, flags);
-	__ide_set_handler(drive, handler, timeout, expiry);
+	__ide_set_handler(drive, handler, timeout);
 	hwif->tp_ops->exec_command(hwif, cmd);
 	/*
 	 * Drive takes 400nS to respond, we must avoid the IRQ being
Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -140,7 +140,7 @@ static ide_startstop_t task_no_data_intr
 		} else if (custom && tf->command == ATA_CMD_INIT_DEV_PARAMS) {
 			if ((stat & (ATA_ERR | ATA_DRQ)) == 0) {
 				ide_set_handler(drive, &task_no_data_intr,
-						WAIT_WORSTCASE, NULL);
+						WAIT_WORSTCASE);
 				return ide_started;
 			}
 		}
@@ -347,7 +347,7 @@ static ide_startstop_t task_pio_intr(ide
 	}
 out_wait:
 	/* Still data left to transfer. */
-	ide_set_handler(drive, &task_pio_intr, WAIT_WORSTCASE, NULL);
+	ide_set_handler(drive, &task_pio_intr, WAIT_WORSTCASE);
 	return ide_started;
 out_end:
 	if ((cmd->tf_flags & IDE_TFLAG_FS) == 0)
@@ -377,7 +377,7 @@ static ide_startstop_t pre_task_out_intr
 	if ((drive->dev_flags & IDE_DFLAG_UNMASK) == 0)
 		local_irq_disable();
 
-	ide_set_handler(drive, &task_pio_intr, WAIT_WORSTCASE, NULL);
+	ide_set_handler(drive, &task_pio_intr, WAIT_WORSTCASE);
 
 	ide_pio_datablock(drive, cmd, 1);
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1132,10 +1132,8 @@ unsigned int ide_rq_bytes(struct request
 int ide_end_rq(ide_drive_t *, struct request *, int, unsigned int);
 void ide_kill_rq(ide_drive_t *, struct request *);
 
-void __ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int,
-		       ide_expiry_t *);
-void ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int,
-		     ide_expiry_t *);
+void __ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int);
+void ide_set_handler(ide_drive_t *, ide_handler_t *, unsigned int);
 
 void ide_execute_command(ide_drive_t *, u8, ide_handler_t *, unsigned int,
 			 ide_expiry_t *);
