Return-Path: <linux-kernel-owner+w=401wt.eu-S933575AbXHGLSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbXHGLSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 07:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762602AbXHGLPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 07:15:30 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:61139 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759400AbXHGLPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 07:15:10 -0400
Message-Id: <20070807111846.867733645@de.ibm.com>
References: <20070807111519.972871123@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Aug 2007 13:15:29 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Michael Holzheu <holzheu@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 09/18] vmur: diag14 only works with buffers below 2GB
Content-Disposition: inline; filename=009-vmur-diag14.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@de.ibm.com>

If memory buffers above 2GB are used, diagnose 14 raises a specification
exception. This fix ensures that buffer allocation is done below the 2GB
boundary.

Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/vmur.c |  106 +++++++++++++++++++++++++++++++----------------
 1 file changed, 70 insertions(+), 36 deletions(-)

Index: quilt-2.6/drivers/s390/char/vmur.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/vmur.c
+++ quilt-2.6/drivers/s390/char/vmur.c
@@ -472,7 +472,7 @@ static ssize_t diag14_read(struct file *
 		return rc;
 
 	len = min((size_t) PAGE_SIZE, count);
-	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	buf = (char *) __get_free_page(GFP_KERNEL | GFP_DMA);
 	if (!buf)
 		return -ENOMEM;
 
@@ -499,7 +499,7 @@ static ssize_t diag14_read(struct file *
 	*offs += copied;
 	rc = copied;
 fail:
-	kfree(buf);
+	free_page((unsigned long) buf);
 	return rc;
 }
 
@@ -542,63 +542,97 @@ static int diag_read_next_file_info(stru
 	}
 }
 
-static int verify_device(struct urdev *urd)
+static int verify_uri_device(struct urdev *urd)
 {
-	struct file_control_block fcb;
+	struct file_control_block *fcb;
 	char *buf;
 	int rc;
 
+	fcb = kmalloc(sizeof(*fcb), GFP_KERNEL | GFP_DMA);
+	if (!fcb)
+		return -ENOMEM;
+
+	/* check for empty reader device (beginning of chain) */
+	rc = diag_read_next_file_info(fcb, 0);
+	if (rc)
+		goto fail_free_fcb;
+
+	/* if file is in hold status, we do not read it */
+	if (fcb->file_stat & (FLG_SYSTEM_HOLD | FLG_USER_HOLD)) {
+		rc = -EPERM;
+		goto fail_free_fcb;
+	}
+
+	/* open file on virtual reader	*/
+	buf = (char *) __get_free_page(GFP_KERNEL | GFP_DMA);
+	if (!buf) {
+		rc = -ENOMEM;
+		goto fail_free_fcb;
+	}
+	rc = diag_read_file(urd->dev_id.devno, buf);
+	if ((rc != 0) && (rc != -ENODATA)) /* EOF does not hurt */
+		goto fail_free_buf;
+
+	/* check if the file on top of the queue is open now */
+	rc = diag_read_next_file_info(fcb, 0);
+	if (rc)
+		goto fail_free_buf;
+	if (!(fcb->file_stat & FLG_IN_USE)) {
+		rc = -EMFILE;
+		goto fail_free_buf;
+	}
+	rc = 0;
+
+fail_free_buf:
+	free_page((unsigned long) buf);
+fail_free_fcb:
+	kfree(fcb);
+	return rc;
+}
+
+static int verify_device(struct urdev *urd)
+{
 	switch (urd->class) {
 	case DEV_CLASS_UR_O:
 		return 0; /* no check needed here */
 	case DEV_CLASS_UR_I:
-		/* check for empty reader device (beginning of chain) */
-		rc = diag_read_next_file_info(&fcb, 0);
-		if (rc)
-			return rc;
-		/* if file is in hold status, we do not read it */
-		if (fcb.file_stat & (FLG_SYSTEM_HOLD | FLG_USER_HOLD))
-			return -EPERM;
-		/* open file on virtual reader	*/
-		buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-		if (!buf)
-			return -ENOMEM;
-		rc = diag_read_file(urd->dev_id.devno, buf);
-		kfree(buf);
-		if ((rc != 0) && (rc != -ENODATA)) /* EOF does not hurt */
-			return rc;
-		/* check if the file on top of the queue is open now */
-		rc = diag_read_next_file_info(&fcb, 0);
-		if (rc)
-			return rc;
-		if (!(fcb.file_stat & FLG_IN_USE))
-			return -EMFILE;
-		return 0;
+		return verify_uri_device(urd);
 	default:
 		return -ENOTSUPP;
 	}
 }
 
-static int get_file_reclen(struct urdev *urd)
+static int get_uri_file_reclen(struct urdev *urd)
 {
-	struct file_control_block fcb;
+	struct file_control_block *fcb;
 	int rc;
 
+	fcb = kmalloc(sizeof(*fcb), GFP_KERNEL | GFP_DMA);
+	if (!fcb)
+		return -ENOMEM;
+	rc = diag_read_next_file_info(fcb, 0);
+	if (rc)
+		goto fail_free;
+	if (fcb->file_stat & FLG_CP_DUMP)
+		rc = 0;
+	else
+		rc = fcb->rec_len;
+
+fail_free:
+	kfree(fcb);
+	return rc;
+}
+
+static int get_file_reclen(struct urdev *urd)
+{
 	switch (urd->class) {
 	case DEV_CLASS_UR_O:
 		return 0;
 	case DEV_CLASS_UR_I:
-		rc = diag_read_next_file_info(&fcb, 0);
-		if (rc)
-			return rc;
-		break;
+		return get_uri_file_reclen(urd);
 	default:
 		return -ENOTSUPP;
 	}
-	if (fcb.file_stat & FLG_CP_DUMP)
-		return 0;
-
-	return fcb.rec_len;
 }
 
 static int ur_open(struct inode *inode, struct file *file)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

