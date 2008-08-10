Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbYHJPjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbYHJPjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 11:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755886AbYHJPiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 11:38:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:22641 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbYHJPiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 11:38:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jrKsGOEVycnaUfagmVCa6znt+nLynOy7m01MquAOhXUGBjYoIRf7uZfp8cluvNURro
         74H6wLEBoB9pyBGbk3k4fjZjfv2Xab7y0azIU7IbmOldNwCqbs2v83oNtP/239OBWCPu
         1SKAyYrnfZmoe2eX+Rr3AU4Leo/I5H1NqCRiY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 10 Aug 2008 17:36:02 +0200
Message-Id: <20080810153602.16255.44911.sendpatchset@localhost.localdomain>
In-Reply-To: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
References: <20080810153527.16255.2504.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/22] ide-tape: add ide_tape_set_media_lock() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ide_tape_set_media_lock() helper and convert idetape_mtioctop(),
idetape_chrdev_open() and idetape_chrdev_release() to use it.

There should be no functional changes caused by this patch (it is
OK to modify ->door_locked if idetape_create_prevent_cmd() fails).

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-tape.c |   39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1298,6 +1298,16 @@ static int idetape_create_prevent_cmd(id
 	return 1;
 }
 
+static int ide_tape_set_media_lock(ide_drive_t *drive, int on)
+{
+	struct ide_atapi_pc pc;
+
+	if (!idetape_create_prevent_cmd(drive, &pc, on))
+		return 0;
+
+	return idetape_queue_pc_tail(drive, &pc);
+}
+
 static void __ide_tape_discard_merge_buffer(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
@@ -1926,9 +1936,8 @@ static int idetape_mtioctop(ide_drive_t 
 		 * attempting to eject.
 		 */
 		if (tape->door_locked) {
-			if (idetape_create_prevent_cmd(drive, &pc, 0))
-				if (!idetape_queue_pc_tail(drive, &pc))
-					tape->door_locked = DOOR_UNLOCKED;
+			if (!ide_tape_set_media_lock(drive, 0))
+				tape->door_locked = DOOR_UNLOCKED;
 		}
 		ide_tape_discard_merge_buffer(drive, 0);
 		idetape_create_load_unload_cmd(drive, &pc,
@@ -1972,17 +1981,13 @@ static int idetape_mtioctop(ide_drive_t 
 	case MTFSR:
 	case MTBSR:
 	case MTLOCK:
-		if (!idetape_create_prevent_cmd(drive, &pc, 1))
-			return 0;
-		retval = idetape_queue_pc_tail(drive, &pc);
+		retval = ide_tape_set_media_lock(drive, 1);
 		if (retval)
 			return retval;
 		tape->door_locked = DOOR_EXPLICITLY_LOCKED;
 		return 0;
 	case MTUNLOCK:
-		if (!idetape_create_prevent_cmd(drive, &pc, 0))
-			return 0;
-		retval = idetape_queue_pc_tail(drive, &pc);
+		retval = ide_tape_set_media_lock(drive, 0);
 		if (retval)
 			return retval;
 		tape->door_locked = DOOR_UNLOCKED;
@@ -2084,7 +2089,6 @@ static int idetape_chrdev_open(struct in
 	unsigned int minor = iminor(inode), i = minor & ~0xc0;
 	ide_drive_t *drive;
 	idetape_tape_t *tape;
-	struct ide_atapi_pc pc;
 	int retval;
 
 	if (i >= MAX_HWIFS * MAX_DRIVES)
@@ -2147,11 +2151,9 @@ static int idetape_chrdev_open(struct in
 
 	/* Lock the tape drive door so user can't eject. */
 	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
-		if (idetape_create_prevent_cmd(drive, &pc, 1)) {
-			if (!idetape_queue_pc_tail(drive, &pc)) {
-				if (tape->door_locked != DOOR_EXPLICITLY_LOCKED)
-					tape->door_locked = DOOR_LOCKED;
-			}
+		if (!ide_tape_set_media_lock(drive, 1)) {
+			if (tape->door_locked != DOOR_EXPLICITLY_LOCKED)
+				tape->door_locked = DOOR_LOCKED;
 		}
 	}
 	unlock_kernel();
@@ -2184,7 +2186,6 @@ static int idetape_chrdev_release(struct
 {
 	struct ide_tape_obj *tape = ide_tape_f(filp);
 	ide_drive_t *drive = tape->drive;
-	struct ide_atapi_pc pc;
 	unsigned int minor = iminor(inode);
 
 	lock_kernel();
@@ -2203,10 +2204,8 @@ static int idetape_chrdev_release(struct
 		(void) idetape_rewind_tape(drive);
 	if (tape->chrdev_dir == IDETAPE_DIR_NONE) {
 		if (tape->door_locked == DOOR_LOCKED) {
-			if (idetape_create_prevent_cmd(drive, &pc, 0)) {
-				if (!idetape_queue_pc_tail(drive, &pc))
-					tape->door_locked = DOOR_UNLOCKED;
-			}
+			if (!ide_tape_set_media_lock(drive, 0))
+				tape->door_locked = DOOR_UNLOCKED;
 		}
 	}
 	clear_bit(IDE_AFLAG_BUSY, &drive->atapi_flags);
