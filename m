Return-Path: <linux-kernel-owner+w=401wt.eu-S1759140AbYFLGsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140AbYFLGsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759475AbYFLGrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:47:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:21650 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316AbYFLGrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:47:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=pb+iRpeh5Knr1QQ7I7OsTquXIuBYALJu568pUieWzyM630UOKcHjL+oNtJxT90bT7V
         YVlhgEPFQtdOGhZzwuLu2Q0apJ+iM+wjCcjY7tvq4aWhbrstq61zUg4HDM3DBBsMCXsk
         qdJtBuAZmWkLrR56Th9eu+5F0hKz7vwTO3FRY=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 09/18] ide-cd: fold cdrom_start_seek into ide_cd_do_request
Date: Thu, 12 Jun 2008 08:41:01 +0200
Message-Id: <1213252870-20474-10-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do what the compiler does anyway: inline a function that is used only once. This
saves us the overhead of a function call and the function is small enough to be
embedded in the callsite anyways.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index abf9af2..b8c98e1 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -778,14 +778,6 @@ static ide_startstop_t cdrom_start_seek_continuation(ide_drive_t *drive)
 	return cdrom_transfer_packet_command(drive, rq, &cdrom_seek_intr);
 }
 
-static void cdrom_start_seek(ide_drive_t *drive)
-{
-	struct cdrom_info *info = drive->driver_data;
-
-	info->dma = 0;
-	info->start_seek = jiffies;
-}
-
 /*
  * Fix up a possibly partially-processed request so that we can start it over
  * entirely, or even put it back on the request queue.
@@ -1233,7 +1225,8 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		    drive->dsc_overlap) {
 			xferlen = 0;
 			fn = cdrom_start_seek_continuation;
-			cdrom_start_seek(drive);
+			info->dma = 0;
+			info->start_seek = jiffies;
 		} else {
 			xferlen = 32768;
 			fn = cdrom_start_rw_cont;
-- 
1.5.5.1

