Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZBWWvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZBWWvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 17:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbZBWWuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 17:50:35 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:35005 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbZBWWuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 17:50:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=fmA83vy38p87T2qwL8f4dDcJC/n0KmhxsdV5Wy+PLRPb6AgGuU1DCU6HyTFgZoBE2s
         OXmZ+Bj2Q0Wv2KFysCPP57t4MsPcT+Z+zwyRIqGq0iF3yvloDR4Ih9aNGT6uIiUE/yTn
         th+7BnIR+F+LqGlP8CY5UvCwQwaqHXY069c5I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 0/6] ide: more unifications of ATA and ATAPI support
Date: Mon, 23 Feb 2009 23:51:17 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090220-dirty; KDE/4.2.0; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain> <20090211071640.GD937@gollum.tnic>
In-Reply-To: <20090211071640.GD937@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902232351.17723.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 February 2009, Borislav Petkov wrote:
> On Tue, Feb 10, 2009 at 12:19:45AM +0100, Bartlomiej Zolnierkiewicz wrote:
> > 
> > After this patchset we have a valid struct ide_cmd available also for
> > ATA_CMD_PACKET commands and comparing struct ide_atapi_pc with ide_cmd it
> > seems that there are many similarities between them and that we may just
> > merge both structs (this should also allow us to unify ide-cd code with
> > non-ide-cd one in ide-atapi.c later).  From the quick look the only gotcha

There is another gotcha there and this one is worth fixing indpendently of
struct ide_atapi_pc and struct ide_cmd merge:

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: decrease size of ->pc_buf field in struct ide_atapi_pc

struct ide_atapi_pc is often allocated on the stack and size of ->pc_buf
size is 256 bytes.  However since only ide_floppy_create_read_capacity_cmd()
and idetape_create_inquiry_cmd() require such size allocate buffers for
these pc-s explicitely and decrease ->pc_buf size to 64 bytes.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c       |    5 ++++-
 drivers/ide/ide-floppy_ioctl.c |    5 ++++-
 drivers/ide/ide-tape.c         |    4 ++++
 include/linux/ide.h            |    2 +-
 4 files changed, 13 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -377,7 +377,7 @@ static int ide_floppy_get_capacity(ide_d
 	struct gendisk *disk = floppy->disk;
 	struct ide_atapi_pc pc;
 	u8 *cap_desc;
-	u8 header_len, desc_cnt;
+	u8 pc_buf[256], header_len, desc_cnt;
 	int i, rc = 1, blocks, length;
 
 	drive->bios_cyl = 0;
@@ -387,6 +387,9 @@ static int ide_floppy_get_capacity(ide_d
 	drive->capacity64 = 0;
 
 	ide_floppy_create_read_capacity_cmd(&pc);
+	pc.buf = &pc_buf[0];
+	pc.buf_size = sizeof(pc_buf);
+
 	if (ide_queue_pc_tail(drive, disk, &pc)) {
 		printk(KERN_ERR PFX "Can't get floppy parameters\n");
 		return 1;
Index: b/drivers/ide/ide-floppy_ioctl.c
===================================================================
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -36,9 +36,9 @@ static int ide_floppy_get_format_capacit
 					    int __user *arg)
 {
 	struct ide_disk_obj *floppy = drive->driver_data;
-	u8 header_len, desc_cnt;
 	int i, blocks, length, u_array_size, u_index;
 	int __user *argp;
+	u8 pc_buf[256], header_len, desc_cnt;
 
 	if (get_user(u_array_size, arg))
 		return -EFAULT;
@@ -47,6 +47,9 @@ static int ide_floppy_get_format_capacit
 		return -EINVAL;
 
 	ide_floppy_create_read_capacity_cmd(pc);
+	pc->buf = &pc_buf[0];
+	pc->buf_size = sizeof(pc_buf);
+
 	if (ide_queue_pc_tail(drive, floppy->disk, pc)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
 		return -EIO;
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2014,9 +2014,13 @@ static void idetape_get_inquiry_results(
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
+	u8 pc_buf[256];
 	char fw_rev[4], vendor_id[8], product_id[16];
 
 	idetape_create_inquiry_cmd(&pc);
+	pc.buf = &pc_buf[0];
+	pc.buf_size = sizeof(pc_buf);
+
 	if (ide_queue_pc_tail(drive, tape->disk, &pc)) {
 		printk(KERN_ERR "ide-tape: %s: can't get INQUIRY results\n",
 				tape->name);
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -377,7 +377,7 @@ enum {
  * With each packet command, we allocate a buffer of IDE_PC_BUFFER_SIZE bytes.
  * This is used for several packet commands (not for READ/WRITE commands).
  */
-#define IDE_PC_BUFFER_SIZE	256
+#define IDE_PC_BUFFER_SIZE	64
 #define ATAPI_WAIT_PC		(60 * HZ)
 
 struct ide_atapi_pc {

