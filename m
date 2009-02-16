Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbZBPARF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbZBPARF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbZBPANR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:13:17 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:53581 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbZBPANP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:13:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vONEJ0mnsOBHo4ogEdv4U9Wt1bjk7TRbGsiHwc+oR022c1oeVP1JL29L14qL2Cj0Nq
         LDaS4iLDHIN84rLG+5mR50z5xHeWpx5ZGRE+lnfjpLJ5VP9uaej9xQp52xI3lbkGYNVz
         bcOaNWuqHtw2E22i+p0RoN4g6QK7jcC6b9rwM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 16 Feb 2009 01:14:42 +0100
Message-Id: <20090216001442.27491.81015.sendpatchset@localhost.localdomain>
In-Reply-To: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
References: <20090216001309.27491.59759.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/20] ide-cd: cleanup ide_cd_do_request()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: cleanup ide_cd_do_request()

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1044,8 +1044,11 @@ static ide_startstop_t ide_cd_do_request
 
 	if (blk_fs_request(rq)) {
 		if (cdrom_start_rw(drive, rq) == ide_stopped ||
-		    ide_cd_prepare_rw_request(drive, rq) == ide_stopped)
+		    ide_cd_prepare_rw_request(drive, rq) == ide_stopped) {
+			if (rq->current_nr_sectors == 0)
+				uptodate = 1;
 			goto out_end;
+		}
 	} else if (blk_sense_request(rq) || blk_pc_request(rq) ||
 		   rq->cmd_type == REQ_TYPE_ATA_PC) {
 		if (!rq->timeout)
@@ -1058,6 +1061,8 @@ static ide_startstop_t ide_cd_do_request
 		goto out_end;
 	} else {
 		blk_dump_rq_flags(rq, DRV_NAME " bad flags");
+		if (rq->errors == 0)
+			rq->errors = -EIO;
 		goto out_end;
 	}
 
@@ -1070,14 +1075,6 @@ static ide_startstop_t ide_cd_do_request
 
 	return ide_issue_pc(drive, &cmd);
 out_end:
-	if (blk_fs_request(rq)) {
-		if (rq->current_nr_sectors == 0)
-			uptodate = 1;
-	} else {
-		if (uptodate <= 0 && rq->errors == 0)
-			rq->errors = -EIO;
-	}
-
 	nsectors = rq->hard_nr_sectors;
 
 	if (nsectors == 0)
