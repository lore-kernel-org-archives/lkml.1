Return-Path: <linux-kernel-owner+w=401wt.eu-S1751099AbXBUBnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751099AbXBUBnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbXBUBmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:42:50 -0500
Received: from hub.freebsd.org ([69.147.83.54]:25181 "EHLO hub.freebsd.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbXBUBmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:42:37 -0500
Date: Wed, 21 Feb 2007 01:19:22 +0000
From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Make the IDE DMA timeout modifiable
Message-ID: <20070221011922.GA1777@freefall.freebsd.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It can be changed via /proc/ide/hd?/settings.

Signed-off-by:	Ed Falk <efalk@google.com>

---
 drivers/ide/ide-dma.c |    3 ++-
 drivers/ide/ide.c     |    2 ++
 include/linux/ide.h   |    3 +++
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index 08e7cd0..a8da725 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -579,7 +579,8 @@ EXPORT_SYMBOL_GPL(ide_dma_setup);
 static void ide_dma_exec_cmd(ide_drive_t *drive, u8 command)
 {
 	/* issue cmd to drive */
-	ide_execute_command(drive, command, &ide_dma_intr, 2*WAIT_CMD, dma_timer_expiry);
+	ide_execute_command(drive, command, &ide_dma_intr, drive->dma_timeout,
+	    dma_timer_expiry);
 }
 
 void ide_dma_start(ide_drive_t *drive)
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index b3c0818..ca841f2 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -245,6 +245,7 @@ static void init_hwif_data(ide_hwif_t *h
 		drive->name[1]			= 'd';
 		drive->name[2]			= 'a' + (index * MAX_DRIVES) + unit;
 		drive->max_failures		= IDE_DEFAULT_MAX_FAILURES;
+		drive->dma_timeout		= WAIT_DMA;
 		drive->using_dma		= 0;
 		drive->vdma			= 0;
 		INIT_LIST_HEAD(&drive->list);
@@ -1197,6 +1198,7 @@ void ide_add_generic_settings (ide_drive
 	__ide_add_setting(drive,	"init_speed",		SETTING_RW,					-1,			-1,			TYPE_BYTE,	0,	70,				1,		1,		&drive->init_speed,		NULL,		0);
 	__ide_add_setting(drive,	"current_speed",	SETTING_RW,					-1,			-1,			TYPE_BYTE,	0,	70,				1,		1,		&drive->current_speed,		set_xfer_rate,	0);
 	__ide_add_setting(drive,	"number",		SETTING_RW,					-1,			-1,			TYPE_BYTE,	0,	3,				1,		1,		&drive->dn,			NULL,		0);
+	__ide_add_setting(drive,	"dma_timeout",		SETTING_RW,					-1,			-1,			TYPE_INT,	0,	2000000000,			1,		1,		&drive->dma_timeout,		NULL,		0);
 }
 
 /**
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 79c0282..3861753 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -183,6 +183,7 @@ #define WAIT_READY	(5*HZ)		/* 5sec - som
 #define WAIT_PIDENTIFY	(10*HZ)	/* 10sec  - should be less than 3ms (?), if all ATAPI CD is closed at boot */
 #define WAIT_WORSTCASE	(30*HZ)	/* 30sec  - worst case when spinning up */
 #define WAIT_CMD	(10*HZ)	/* 10sec  - maximum wait for an IRQ to happen */
+#define WAIT_DMA	(20*HZ)	/* 20sec  - maximum wait for an IRQ to happen */
 #define WAIT_MIN_SLEEP	(2*HZ/100)	/* 20msec - minimum sleep time */
 
 /*
@@ -638,6 +639,8 @@ typedef struct ide_drive_s {
 	unsigned int	drive_data;	/* use by tuneproc/selectproc */
 	unsigned int	failures;	/* current failure count */
 	unsigned int	max_failures;	/* maximum allowed failure count */
+	int		dma_timeout;	/* number of jiffies to wait for a
+					  dma to complete */
 	u64		probed_capacity;/* initial reported media capacity (ide-cd only currently) */
 
 	u64		capacity64;	/* total number of sectors */

