Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbYBQTky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbYBQTky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYBQTkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:40:03 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:51808 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbYBQTj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:39:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=plF1rC+hTsBuqih4+CyCABTSt3DP3uULWjG0bJlLgYbcQE0v2PNd80tqAGqKjFpTZ1L2Bjwj1E5XbX4mqxmrit3dIZ4UkNadI/8750qpFf7znwR+7Z8/EIACzN8/okGsRLaxDn4gsyx7c+g2v5/3b45gY3Z7PdDCsXiOraHuCd4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/4] ide-disk: add proc_idedisk_read_smart() helper
Date: Sun, 17 Feb 2008 20:53:22 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802172053.22686.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Factor out common code from proc_idedisk_read_smart_{thresholds,values}()
  to proc_idedisk_read_smart() helper.

* Rename proc_idedisk_read_smart_thresholds() to proc_idedisk_read_st()
  and proc_idedisk_read_smart_values() to proc_idedisk_read_sv().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |   39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -540,13 +540,13 @@ static int proc_idedisk_read_capacity
 	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
 }
 
-static int proc_idedisk_read_smart_thresholds
-	(char *page, char **start, off_t off, int count, int *eof, void *data)
+static int proc_idedisk_read_smart(char *page, char **start, off_t off,
+				   int count, int *eof, void *data, u8 sub_cmd)
 {
 	ide_drive_t	*drive = (ide_drive_t *)data;
 	int		len = 0, i = 0;
 
-	if (get_smart_data(drive, page, SMART_READ_THRESHOLDS) == 0) {
+	if (get_smart_data(drive, page, sub_cmd) == 0) {
 		unsigned short *val = (unsigned short *) page;
 		char *out = ((char *)val) + (SECTOR_WORDS * 4);
 		page = out;
@@ -559,31 +559,26 @@ static int proc_idedisk_read_smart_thres
 	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
 }
 
-static int proc_idedisk_read_smart_values
+static int proc_idedisk_read_sv
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
-	ide_drive_t	*drive = (ide_drive_t *)data;
-	int		len = 0, i = 0;
+	return proc_idedisk_read_smart(page, start, off, count, eof, data,
+				       SMART_READ_VALUES);
+}
 
-	if (get_smart_data(drive, page, SMART_READ_VALUES) == 0) {
-		unsigned short *val = (unsigned short *) page;
-		char *out = ((char *)val) + (SECTOR_WORDS * 4);
-		page = out;
-		do {
-			out += sprintf(out, "%04x%c", le16_to_cpu(*val), (++i & 7) ? ' ' : '\n');
-			val += 1;
-		} while (i < (SECTOR_WORDS * 2));
-		len = out - page;
-	}
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+static int proc_idedisk_read_st
+	(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	return proc_idedisk_read_smart(page, start, off, count, eof, data,
+				       SMART_READ_THRESHOLDS);
 }
 
 static ide_proc_entry_t idedisk_proc[] = {
-	{ "cache",		S_IFREG|S_IRUGO,	proc_idedisk_read_cache,		NULL },
-	{ "capacity",		S_IFREG|S_IRUGO,	proc_idedisk_read_capacity,		NULL },
-	{ "geometry",		S_IFREG|S_IRUGO,	proc_ide_read_geometry,			NULL },
-	{ "smart_values",	S_IFREG|S_IRUSR,	proc_idedisk_read_smart_values,		NULL },
-	{ "smart_thresholds",	S_IFREG|S_IRUSR,	proc_idedisk_read_smart_thresholds,	NULL },
+	{ "cache",	  S_IFREG|S_IRUGO, proc_idedisk_read_cache,    NULL },
+	{ "capacity",	  S_IFREG|S_IRUGO, proc_idedisk_read_capacity, NULL },
+	{ "geometry",	  S_IFREG|S_IRUGO, proc_ide_read_geometry,     NULL },
+	{ "smart_values", S_IFREG|S_IRUSR, proc_idedisk_read_sv,       NULL },
+	{ "smart_thresholds", S_IFREG|S_IRUSR, proc_idedisk_read_st,   NULL },
 	{ NULL, 0, NULL, NULL }
 };
 #endif	/* CONFIG_IDE_PROC_FS */
