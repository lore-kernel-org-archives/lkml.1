Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbZBIUCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbZBIUCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 15:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbZBIUAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 15:00:21 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:48124 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078AbZBIUAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 15:00:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=WuaDFjOojqHeV7jDpiI37trf2z+w6M67c23lUnAcjWJ1+BpZspBuaY8hVChyvhZcO4
         J+aYCSa15zZ+s1ja3mlOJiTR8tIa3Sxjw/y5wZyZ8RhePjnSopcYp1ouCwk1b8Gp/8Wj
         mAZho6P5UOdcFbde2lQCY5+i9jdcbKPrd2lVU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 09 Feb 2009 21:01:28 +0100
Message-Id: <20090209200128.7985.59685.sendpatchset@localhost.localdomain>
In-Reply-To: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
References: <20090209200042.7985.94247.sendpatchset@localhost.localdomain>
Subject: [PATCH 6/9] ide: remove BUG() from ide_complete_rq()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove BUG() from ide_complete_rq()

It is no longer needed so remove it, also while at it dequeue the request
only on blk_end_request() success and make ide_complete_rq() return an error
value.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-io.c |   10 ++++++----
 include/linux/ide.h  |    2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -137,15 +137,17 @@ void ide_complete_cmd(ide_drive_t *drive
 		kfree(cmd);
 }
 
-void ide_complete_rq(ide_drive_t *drive, int error)
+int ide_complete_rq(ide_drive_t *drive, int error)
 {
 	ide_hwif_t *hwif = drive->hwif;
 	struct request *rq = hwif->rq;
+	int rc;
 
-	hwif->rq = NULL;
+	rc = blk_end_request(rq, error, blk_rq_bytes(rq));
+	if (rc == 0)
+		hwif->rq = NULL;
 
-	if (unlikely(blk_end_request(rq, error, blk_rq_bytes(rq))))
-		BUG();
+	return rc;
 }
 EXPORT_SYMBOL(ide_complete_rq);
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1163,7 +1163,7 @@ extern int ide_devset_execute(ide_drive_
 			      const struct ide_devset *setting, int arg);
 
 void ide_complete_cmd(ide_drive_t *, struct ide_cmd *, u8, u8);
-void ide_complete_rq(ide_drive_t *, int);
+int ide_complete_rq(ide_drive_t *, int);
 
 void ide_tf_dump(const char *, struct ide_taskfile *);
 
