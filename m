Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbYLPTew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbYLPTew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758083AbYLPTcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:32:39 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:33945 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056AbYLPTci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:32:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=oK2PqW4rAfUM3RqygcZCPJ3yD2P0Loz6ly4lCdm935W2iz6dwgybcPqfyrBBigpRPE
         f6R5TA5pgKm8aG6yJ6xOdWFkTPTYknc/tTdF//W1jsbzt9cAzCzOV9V1/WWLr6wCRS/c
         735uCjYe8+OugNBZzpHCUvpxwbECn0lTzBLKs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 16 Dec 2008 20:32:30 +0100
Message-Id: <20081216193230.3959.45427.sendpatchset@localhost.localdomain>
In-Reply-To: <20081216193137.3959.70339.sendpatchset@localhost.localdomain>
References: <20081216193137.3959.70339.sendpatchset@localhost.localdomain>
Subject: [PATCH 9/9] ide: remove ->error method from struct ide_driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove ->error method from struct ide_driver

* Remove (now superfluous) ->error method from struct ide_driver.

* Unexport __ide_error() and make it static.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c   |    1 -
 drivers/ide/ide-gd.c   |    1 -
 drivers/ide/ide-io.c   |   13 ++-----------
 drivers/ide/ide-tape.c |    1 -
 include/linux/ide.h    |    3 ---
 5 files changed, 2 insertions(+), 17 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1952,7 +1952,6 @@ static struct ide_driver ide_cdrom_drive
 	.version		= IDECD_VERSION,
 	.do_request		= ide_cd_do_request,
 	.end_request		= ide_end_request,
-	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc_entries		= ide_cd_proc_entries,
 	.proc_devsets		= ide_cd_proc_devsets,
Index: b/drivers/ide/ide-gd.c
===================================================================
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -162,7 +162,6 @@ static struct ide_driver ide_gd_driver =
 	.version		= IDE_GD_VERSION,
 	.do_request		= ide_gd_do_request,
 	.end_request		= ide_gd_end_request,
-	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc_entries		= ide_disk_proc_entries,
 	.proc_devsets		= ide_disk_proc_devsets,
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -291,7 +291,7 @@ static ide_startstop_t ide_atapi_error(i
 	return ide_stopped;
 }
 
-ide_startstop_t
+static ide_startstop_t
 __ide_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 {
 	if (drive->media == ide_disk)
@@ -299,8 +299,6 @@ __ide_error(ide_drive_t *drive, struct r
 	return ide_atapi_error(drive, rq, stat, err);
 }
 
-EXPORT_SYMBOL_GPL(__ide_error);
-
 /**
  *	ide_error	-	handle an error on the IDE
  *	@drive: drive the error occurred on
@@ -332,15 +330,8 @@ ide_startstop_t ide_error (ide_drive_t *
 		return ide_stopped;
 	}
 
-	if (rq->rq_disk) {
-		struct ide_driver *drv;
-
-		drv = *(struct ide_driver **)rq->rq_disk->private_data;
-		return drv->error(drive, rq, stat, err);
-	} else
-		return __ide_error(drive, rq, stat, err);
+	return __ide_error(drive, rq, stat, err);
 }
-
 EXPORT_SYMBOL_GPL(ide_error);
 
 static void ide_tf_set_specify_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2324,7 +2324,6 @@ static struct ide_driver idetape_driver 
 	.version		= IDETAPE_VERSION,
 	.do_request		= idetape_do_request,
 	.end_request		= idetape_end_request,
-	.error			= __ide_error,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc_entries		= ide_tape_proc_entries,
 	.proc_devsets		= ide_tape_proc_devsets,
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1112,7 +1112,6 @@ struct ide_driver {
 	const char			*version;
 	ide_startstop_t	(*do_request)(ide_drive_t *, struct request *, sector_t);
 	int		(*end_request)(ide_drive_t *, int, int);
-	ide_startstop_t	(*error)(ide_drive_t *, struct request *rq, u8, u8);
 	struct device_driver	gen_driver;
 	int		(*probe)(ide_drive_t *);
 	void		(*remove)(ide_drive_t *);
@@ -1156,8 +1155,6 @@ void ide_execute_pkt_cmd(ide_drive_t *);
 
 void ide_pad_transfer(ide_drive_t *, int, int);
 
-ide_startstop_t __ide_error(ide_drive_t *, struct request *, u8, u8);
-
 ide_startstop_t ide_error(ide_drive_t *, const char *, u8);
 
 void ide_fix_driveid(u16 *);
