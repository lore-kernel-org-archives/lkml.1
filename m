Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbYA0N2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbYA0N2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 08:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYA0N2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 08:28:41 -0500
Received: from nelson.telenet-ops.be ([195.130.133.66]:38251 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbYA0N2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 08:28:39 -0500
X-Greylist: delayed 3221 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 08:28:39 EST
Date: Sun, 27 Jan 2008 14:28:35 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] Atari floppy: Rename disk_type to atari_disk_type 
Message-ID: <Pine.LNX.4.64.0801271426590.8108@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atari floppy: Rename disk_type to atari_disk_type

Commit edfaa7c36574f1bf09c65ad602412db9da5f96bf

    Driver core: convert block from raw kobjects to core devices
    
    This moves the block devices to /sys/class/block. It will create a
    flat list of all block devices, with the disks and partitions in one
    directory. For compatibility /sys/block is created and contains symlinks
    to the disks.

introduced a global disk_type variable in <linux/genhd.h>, causing the
following compile error on Atari:

    drivers/block/ataflop.c:93: error: conflicting types for 'disk_type'
    include/linux/genhd.h:21: error: previous declaration of 'disk_type' was here

Rename the local disk_type variable in drivers/block/ataflop.c to
atari_disk_type, to avoid the conflict.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/block/ataflop.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -90,7 +90,7 @@ static struct atari_disk_type {
 	unsigned	blocks;		/* total number of blocks */
 	unsigned	fdc_speed;	/* fdc_speed setting */
 	unsigned 	stretch;	/* track doubling ? */
-} disk_type[] = {
+} atari_disk_type[] = {
 	{ "d360",  9, 720, 0, 0},	/*  0: 360kB diskette */
 	{ "D360",  9, 720, 0, 1},	/*  1: 360kb in 720k or 1.2MB drive */
 	{ "D720",  9,1440, 0, 0},	/*  2: 720kb in 720k or 1.2MB drive */
@@ -658,7 +658,7 @@ static int do_format(int drive, int type
 			return -EINVAL;
 		}
 		type = minor2disktype[type].index;
-		UDT = &disk_type[type];
+		UDT = &atari_disk_type[type];
 	}
 
 	if (!UDT || desc->track >= UDT->blocks/UDT->spt/2 || desc->head >= 2) {
@@ -1064,7 +1064,7 @@ static void fd_rwsec_done1(int status)
 	       searched for a non-existent sector! */
 	    !(read_track && FDC_READ(FDCREG_SECTOR) > SUDT->spt)) {
 		if (Probing) {
-			if (SUDT > disk_type) {
+			if (SUDT > atari_disk_type) {
 			    if (SUDT[-1].blocks > ReqBlock) {
 				/* try another disk type */
 				SUDT--;
@@ -1082,7 +1082,7 @@ static void fd_rwsec_done1(int status)
 		} else {	
 /* record not found, but not probing. Maybe stretch wrong ? Restart probing */
 			if (SUD.autoprobe) {
-				SUDT = disk_type + StartDiskType[DriveType];
+				SUDT = atari_disk_type + StartDiskType[DriveType];
 				set_capacity(unit[SelectedDrive].disk,
 							SUDT->blocks);
 				Probing = 1;
@@ -1421,7 +1421,7 @@ repeat:
 	if (type == 0) {
 		if (!UDT) {
 			Probing = 1;
-			UDT = disk_type + StartDiskType[DriveType];
+			UDT = atari_disk_type + StartDiskType[DriveType];
 			set_capacity(floppy->disk, UDT->blocks);
 			UD.autoprobe = 1;
 		}
@@ -1439,7 +1439,7 @@ repeat:
 			goto repeat;
 		}
 		type = minor2disktype[type].index;
-		UDT = &disk_type[type];
+		UDT = &atari_disk_type[type];
 		set_capacity(floppy->disk, UDT->blocks);
 		UD.autoprobe = 0;
 	}
@@ -1505,7 +1505,7 @@ static int fd_ioctl(struct inode *inode,
 			if (minor2disktype[type].drive_types > DriveType)
 				return -ENODEV;
 			type = minor2disktype[type].index;
-			dtp = &disk_type[type];
+			dtp = &atari_disk_type[type];
 			if (UD.flags & FTD_MSG)
 			    printk (KERN_ERR "floppy%d: found dtp %p name %s!\n",
 			        drive, dtp, dtp->name);
@@ -1576,7 +1576,7 @@ static int fd_ioctl(struct inode *inode,
 				continue;
 			}
 			setidx = minor2disktype[settype].index;
-			dtp = &disk_type[setidx];
+			dtp = &atari_disk_type[setidx];
 
 			/* found matching entry ?? */
 			if (   dtp->blocks  == setprm.size 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
