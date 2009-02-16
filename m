Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbZBPATM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbZBPATM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbZBPAN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:13:57 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:41106 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243AbZBPANz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:13:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=nc8pN9PV1G+HpdRpFU3WETn1trKSRdCGTnmnLiHwRYKfu45rBdt1x9dmGDkCXSG3jZ
         l5u5PFdvQuFlXydkMYD5jLBKZRkoK9lLeoMzClSuZH40i9aeWtZhRy/HR70kWtfpsXQT
         PcTGqrAPl2yycWyg0Q4M0XcKZEKWGhPqEAdaQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:15:21 +0100
Message-Id: <20090216001521.27491.46520.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 20/20] ide-cd: unify transfer padding in cdrom_newpc_intr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: unify transfer padding in cdrom_newpc_intr()

* 'thislen' is always <= cmd->nleft for non-fs requests so the transfer
  padding inside the 'while (thislen > 0)' loop can happen only for fs
  requests -- then move it out of the loop and unify with the transfer
  padding for non-fs requests ('thislen' == 'len' for fs requests).

* blk_dump_rq_flags() dumps all request flags so it is enough to pass
  only the function name to it.

* Update my Copyrights while at it.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -4,7 +4,7 @@
  * Copyright (C) 1994-1996   Scott Snyder <snyder@fnald0.fnal.gov>
  * Copyright (C) 1996-1998   Erik Andersen <andersee@debian.org>
  * Copyright (C) 1998-2000   Jens Axboe <axboe@suse.de>
- * Copyright (C) 2005, 2007  Bartlomiej Zolnierkiewicz
+ * Copyright (C) 2005, 2007-2009  Bartlomiej Zolnierkiewicz
  *
  * May be copied or modified under the terms of the GNU General Public
  * License.  See linux/COPYING for more information.
@@ -703,22 +703,8 @@ static ide_startstop_t cdrom_newpc_intr(
 	while (thislen > 0) {
 		int blen = min_t(int, thislen, cmd->nleft);
 
-		if (cmd->nleft == 0) {
-			if (blk_fs_request(rq) && !write)
-				/*
-				 * If the buffers are full, pipe the rest into
-				 * oblivion.
-				 */
-				ide_pad_transfer(drive, 0, thislen);
-			else {
-				printk(KERN_ERR PFX "%s: confused, missing data\n",
-						drive->name);
-				blk_dump_rq_flags(rq, rq_data_dir(rq)
-						  ? "cdrom_newpc_intr, write"
-						  : "cdrom_newpc_intr, read");
-			}
+		if (cmd->nleft == 0)
 			break;
-		}
 
 		ide_pio_bytes(drive, cmd, write, blen);
 		cmd->last_xfer_len += blen;
@@ -731,8 +717,15 @@ static ide_startstop_t cdrom_newpc_intr(
 	}
 
 	/* pad, if necessary */
-	if (!blk_fs_request(rq) && len > 0)
-		ide_pad_transfer(drive, write, len);
+	if (len > 0) {
+		if (blk_fs_request(rq) == 0 || write == 0)
+			ide_pad_transfer(drive, write, len);
+		else {
+			printk(KERN_ERR PFX "%s: confused, missing data\n",
+				drive->name);
+			blk_dump_rq_flags(rq, "cdrom_newpc_intr");
+		}
+	}
 
 	if (blk_pc_request(rq)) {
 		timeout = rq->timeout;
