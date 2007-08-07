Return-Path: <linux-kernel-owner+w=401wt.eu-S1762272AbXHGLSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272AbXHGLSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 07:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762461AbXHGLP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 07:15:28 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:50436 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759303AbXHGLPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 07:15:10 -0400
Message-Id: <20070807111846.372739941@de.ibm.com>
References: <20070807111519.972871123@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Aug 2007 13:15:27 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Michael Holzheu <holzheu@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 07/18] vmur: reject open on z/VM reader files with status HOLD
Content-Disposition: inline; filename=007-vmur-hold.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@de.ibm.com>

If a reader file with HOLD status is at the top of the reader queue, currently
all read requests will return data of the second file in the queue. But the
semantics of vmur is that always the topmost file is read. With this fix
-EPERM is returned on open, if the topmost reader file is in HOLD status.

Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/vmur.c |    4 +++-
 drivers/s390/char/vmur.h |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

Index: quilt-2.6/drivers/s390/char/vmur.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/vmur.c
+++ quilt-2.6/drivers/s390/char/vmur.c
@@ -556,7 +556,9 @@ static int verify_device(struct urdev *u
 		rc = diag_read_next_file_info(&fcb, 0);
 		if (rc)
 			return rc;
-
+		/* if file is in hold status, we do not read it */
+		if (fcb.file_stat & (FLG_SYSTEM_HOLD | FLG_USER_HOLD))
+			return -EPERM;
 		/* open file on virtual reader	*/
 		buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!buf)
Index: quilt-2.6/drivers/s390/char/vmur.h
===================================================================
--- quilt-2.6.orig/drivers/s390/char/vmur.h
+++ quilt-2.6/drivers/s390/char/vmur.h
@@ -50,7 +50,9 @@ struct file_control_block {
 	char  rest[200];
 } __attribute__ ((packed));
 
-#define FLG_CP_DUMP 0x10
+#define FLG_SYSTEM_HOLD	0x04
+#define FLG_CP_DUMP	0x10
+#define FLG_USER_HOLD	0x20
 
 /*
  * A struct urdev is created for each ur device that is made available

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

