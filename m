Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbYGZNpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbYGZNpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbYGZNnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:43:14 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:59438 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbYGZNnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:43:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=EMqlypbl+seBDAeKaQ8tXypg2ayiSgOVF8axpj3SmaOjCPPKj1xBgyyKf2injUY71n
         hiFtFxQyjFXREXG09Sr43EhmphbwBuPIQSIKphQvqXnBxE0yV35zHCzUOwXaeHWSAH+N
         J4MkVmOBOs5Fq5vPMZt6UoMeQZyQIxZMWefjo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 26 Jul 2008 15:41:05 +0200
Message-Id: <20080726134105.10589.64086.sendpatchset@localhost.localdomain>
In-Reply-To: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
References: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/10] ide: use correct data phase for SMART READ DATA / LOG in ide_cmd_ioctl()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-taskfile.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -758,15 +758,25 @@ int ide_cmd_ioctl (ide_drive_t *drive, u
 		tf->lbam  = 0x4f;
 		tf->lbah  = 0xc2;
 		tfargs.tf_flags = IDE_TFLAG_OUT_TF | IDE_TFLAG_IN_NSECT;
+
+		/* SMART READ DATA / LOG */
+		if (tf->feature == 0xD0 || tf->feature == 0xD5)
+			tfargs.data_phase = TASKFILE_IN;
+		else
+			tfargs.data_phase = TASKFILE_NO_DATA;
 	} else {
 		tf->nsect = args[1];
 		tfargs.tf_flags = IDE_TFLAG_OUT_FEATURE |
 				  IDE_TFLAG_OUT_NSECT | IDE_TFLAG_IN_NSECT;
+
+		if (args[3])
+			tfargs.data_phase = TASKFILE_IN;
+		else
+			tfargs.data_phase = TASKFILE_NO_DATA;
 	}
 	tf->command = args[0];
-	tfargs.data_phase = args[3] ? TASKFILE_IN : TASKFILE_NO_DATA;
 
-	if (args[3]) {
+	if (tfargs.data_phase == TASKFILE_IN) {
 		tfargs.tf_flags |= IDE_TFLAG_IO_16BIT;
 		bufsize = SECTOR_WORDS * 4 * args[3];
 		buf = kzalloc(bufsize, GFP_KERNEL);
