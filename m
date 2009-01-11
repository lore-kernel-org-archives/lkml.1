Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZAKTNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZAKTNO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:13:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbZAKTLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:11:16 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:63185 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbZAKTLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:11:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=InncJgLfrRZIwMen+LXOu2zRAG+mkjj7xsdc8KX07gqEHAxffCGH3MUziZgzKpK0/S
         yROyqo7o6Zb/t/1VoJJamUytcTCv3GOf3rTYb3hMCNQZsKhptzmdpCuVJoOB7ParzFeL
         A9p14iEaWv7W1a8X+7HMzgU4suTrb8Px+Ws0w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 11 Jan 2009 20:12:07 +0100
Message-Id: <20090111191207.17361.76977.sendpatchset@localhost.localdomain>
In-Reply-To: <20090111191120.17361.69981.sendpatchset@localhost.localdomain>
References: <20090111191120.17361.69981.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/8] ide-acpi: remove taskfile_load_raw()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-acpi: remove taskfile_load_raw()

* taskfile_load_raw() is used only by do_drive_set_taskfiles()
  so inline it there.

While at it:
- rename 'args' variable to 'task'
- remove struct taskfile_array
- do ide_acpigtf check early
- use REGS_PER_GTF

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-acpi.c |   69 ++++++++++++++++---------------------------------
 1 file changed, 23 insertions(+), 46 deletions(-)

Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -26,9 +26,6 @@
 #include <acpi/actypes.h>
 
 #define REGS_PER_GTF		7
-struct taskfile_array {
-	u8	tfa[REGS_PER_GTF];	/* regs. 0x1f1 - 0x1f7 */
-};
 
 struct GTM_buffer {
 	u32	PIO_speed0;
@@ -291,43 +288,6 @@ out:
 }
 
 /**
- * taskfile_load_raw - send taskfile registers to drive
- * @drive: drive to which output is sent
- * @gtf: raw ATA taskfile register set (0x1f1 - 0x1f7)
- *
- * Outputs IDE taskfile to the drive.
- */
-static int taskfile_load_raw(ide_drive_t *drive,
-			      const struct taskfile_array *gtf)
-{
-	ide_task_t args;
-	int err = 0;
-
-	DEBPRINT("(0x1f1-1f7): hex: "
-	       "%02x %02x %02x %02x %02x %02x %02x\n",
-	       gtf->tfa[0], gtf->tfa[1], gtf->tfa[2],
-	       gtf->tfa[3], gtf->tfa[4], gtf->tfa[5], gtf->tfa[6]);
-
-	memset(&args, 0, sizeof(ide_task_t));
-
-	/* convert gtf to IDE Taskfile */
-	memcpy(&args.tf_array[7], &gtf->tfa, 7);
-	args.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
-
-	if (!ide_acpigtf) {
-		DEBPRINT("_GTF execution disabled\n");
-		return err;
-	}
-
-	err = ide_no_data_taskfile(drive, &args);
-	if (err)
-		printk(KERN_ERR "%s: ide_no_data_taskfile failed: %u\n",
-		       __func__, err);
-
-	return err;
-}
-
-/**
  * do_drive_set_taskfiles - write the drive taskfile settings from _GTF
  * @drive: the drive to which the taskfile command should be sent
  * @gtf_length: total number of bytes of _GTF taskfiles
@@ -343,19 +303,36 @@ static int do_drive_set_taskfiles(ide_dr
 	int			rc = 0, err;
 	int			gtf_count = gtf_length / REGS_PER_GTF;
 	int			ix;
-	struct taskfile_array	*gtf;
 
 	DEBPRINT("total GTF bytes=%u (0x%x), gtf_count=%d, addr=0x%lx\n",
 		 gtf_length, gtf_length, gtf_count, gtf_address);
 
+	/* send all taskfile registers (0x1f1-0x1f7) *in*that*order* */
 	for (ix = 0; ix < gtf_count; ix++) {
-		gtf = (struct taskfile_array *)
-			(gtf_address + ix * REGS_PER_GTF);
+		u8 *gtf = (u8 *)(gtf_address + ix * REGS_PER_GTF);
+		ide_task_t task;
 
-		/* send all TaskFile registers (0x1f1-0x1f7) *in*that*order* */
-		err = taskfile_load_raw(drive, gtf);
-		if (err)
+		DEBPRINT("(0x1f1-1f7): "
+			 "hex: %02x %02x %02x %02x %02x %02x %02x\n",
+			 gtf[0], gtf[1], gtf[2],
+			 gtf[3], gtf[4], gtf[5], gtf[6]);
+
+		if (!ide_acpigtf) {
+			DEBPRINT("_GTF execution disabled\n");
+			continue;
+		}
+
+		/* convert GTF to taskfile */
+		memset(&task, 0, sizeof(ide_task_t));
+		memcpy(&task.tf_array[7], gtf, REGS_PER_GTF);
+		task.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
+
+		err = ide_no_data_taskfile(drive, &task);
+		if (err) {
+			printk(KERN_ERR "%s: ide_no_data_taskfile failed: %u\n",
+					__func__, err);
 			rc = err;
+		}
 	}
 
 	return rc;
