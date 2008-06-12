Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbYFLGnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbYFLGnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbYFLGlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:41:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:9208 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbYFLGlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:41:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=O0j0n1UL7uAbOr9oguFKNeRffGbvgOLTzC4QoIBNTIQAKR4Jd4ej/z+oBkLe8hk3uK
         /VSjwq48e6FvjauyZpWkogFbZAQaqe5HX5ztjehVXXt0UQiClH1toBSiJ0DAqGlp7hRz
         oeRuSm5BYqPzjD2W1N1KUkl/XMXJlfLObRbLs=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 16/18] ide-floppy: pass rq instead of pc to idefloppy_issue_pc
Date: Thu, 12 Jun 2008 08:41:08 +0200
Message-Id: <1213252870-20474-17-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pc is still embedded in rq->buffer.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-floppy.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 8ce7513..1ec4951 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -464,12 +464,12 @@ static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
 }
 
 static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
-		struct ide_atapi_pc *pc)
+					  struct request *rq)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_atapi_pc *pc = (struct ide_atapi_pc *) rq->buffer;
 
-	if (floppy->failed_pc == NULL &&
-	    pc->rq->cmd[0] != GPCMD_REQUEST_SENSE)
+	if (floppy->failed_pc == NULL && rq->cmd[0] != GPCMD_REQUEST_SENSE)
 		floppy->failed_pc = pc;
 	/* Set the current packet command */
 	floppy->pc = pc;
@@ -626,6 +626,7 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 		}
 		pc = idefloppy_next_pc_storage(drive);
 		idefloppy_create_rw_cmd(floppy, pc, rq, block);
+		rq->buffer = (char *) pc;
 	} else if (blk_pc_request(rq))
 		pc = (struct ide_atapi_pc *) rq->buffer;
 	else {
@@ -643,7 +644,7 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 
 	pc->rq = rq;
 
-	return idefloppy_issue_pc(drive, pc);
+	return idefloppy_issue_pc(drive, rq);
 }
 
 /*
-- 
1.5.5.1

