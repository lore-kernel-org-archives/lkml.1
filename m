Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbYA0J4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbYA0J4g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbYA0Jto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:49:44 -0500
Received: from [212.23.103.76] ([212.23.103.76]:59284 "EHLO gollum.tnic"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756751AbYA0Jta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:49:30 -0500
From: Borislav Petkov <petkovbb@gmail.com>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 31/32] ide-tape: remove idetape_config_t typedef
Date: Sun, 27 Jan 2008 10:48:19 +0100
Message-Id: <1201427300-3954-26-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bbpetkov@yahoo.de>

Since this is used only in idetape_blkdev_ioctl(), remove the typedef and make
the struct function-local.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-tape.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index c22d7f6..424879d 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -540,15 +540,6 @@ struct idetape_id_gcw {
 #define	IDETAPE_CAPABILITIES_PAGE	0x2a
 
 /*
- *	Run time configurable parameters.
- */
-typedef struct {
-	int	dsc_rw_frequency;
-	int	dsc_media_access_frequency;
-	int	nr_stages;
-} idetape_config_t;
-
-/*
  *	The variables below are used for the character device interface.
  *	Additional state variables are defined in our ide_drive_t structure.
  */
@@ -2742,14 +2733,21 @@ static int idetape_rewind_tape (ide_drive_t *drive)
 static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 {
 	idetape_tape_t *tape = drive->driver_data;
-	idetape_config_t config;
+
+	struct idetape_config {
+		int dsc_rw_frequency;
+		int dsc_media_access_frequency;
+		int nr_stages;
+	} config;
+
 	void __user *argp = (void __user *)arg;
 
 	debug_log(DBG_PROCS, "Enter %s\n", __func__);
 
 	switch (cmd) {
 		case 0x0340:
-			if (copy_from_user(&config, argp, sizeof (idetape_config_t)))
+			if (copy_from_user(&config, argp,
+						sizeof(struct idetape_config)))
 				return -EFAULT;
 			tape->best_dsc_rw_freq = config.dsc_rw_frequency;
 			tape->max_stages = config.nr_stages;
@@ -2757,7 +2755,8 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd, unsigned l
 		case 0x0350:
 			config.dsc_rw_frequency = (int) tape->best_dsc_rw_freq;
 			config.nr_stages = tape->max_stages; 
-			if (copy_to_user(argp, &config, sizeof (idetape_config_t)))
+			if (copy_to_user(argp, &config,
+						sizeof(struct idetape_config)))
 				return -EFAULT;
 			break;
 		default:
-- 
1.5.3.7

