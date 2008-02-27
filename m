Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbYB0SWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbYB0SWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756816AbYB0SV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:21:28 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:49230 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbYB0SVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:21:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=Z9wvZNYbxKBPHyO3T1ffFd3fpC88TsqFSPjXIwImRWtf+JhcD/jVtzvLvUJWEWIqkmCBF5uB/lOhy60o7vwSC2ZjMDsSrV7xEblEwLvfC8lhNBlPDqid7nadJ456M7D9Kxw77ectivap/GrAiMcBxrjjBe/47x/S0XGn42MB3Oc=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 2/5] ide-cd: put all proc-related code at one place
Date: Wed, 27 Feb 2008 19:20:46 +0100
Message-Id: <1204136449-9490-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204136449-9490-1-git-send-email-petkovbb@gmail.com>
References: <1204136449-9490-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   71 ++++++++++++++++++++++++-------------------------
 1 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 4d39567..bb7944b 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1695,15 +1695,6 @@ int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 	return nslots;
 }
 
-#ifdef CONFIG_IDE_PROC_FS
-static void ide_cdrom_add_settings(ide_drive_t *drive)
-{
-	ide_add_setting(drive, "dsc_overlap", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1, &drive->dsc_overlap, NULL);
-}
-#else
-static inline void ide_cdrom_add_settings(ide_drive_t *drive) { ; }
-#endif
-
 /*
  * standard prep_rq_fn that builds 10 byte cmds
  */
@@ -1789,6 +1780,41 @@ struct cd_list_entry {
 	unsigned int	cd_flags;
 };
 
+#ifdef CONFIG_IDE_PROC_FS
+static sector_t ide_cdrom_capacity(ide_drive_t *drive)
+{
+	unsigned long capacity, sectors_per_frame;
+
+	if (cdrom_read_capacity(drive, &capacity, &sectors_per_frame, NULL))
+		return 0;
+
+	return capacity * sectors_per_frame;
+}
+
+static int proc_idecd_read_capacity
+	(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	ide_drive_t *drive = data;
+	int len;
+
+	len = sprintf(page, "%llu\n", (long long)ide_cdrom_capacity(drive));
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
+}
+
+static ide_proc_entry_t idecd_proc[] = {
+	{ "capacity", S_IFREG|S_IRUGO, proc_idecd_read_capacity, NULL },
+	{ NULL, 0, NULL, NULL }
+};
+
+static void ide_cdrom_add_settings(ide_drive_t *drive)
+{
+	ide_add_setting(drive, "dsc_overlap", SETTING_RW, TYPE_BYTE, 0, 1, 1, 1,
+			&drive->dsc_overlap, NULL);
+}
+#else
+static inline void ide_cdrom_add_settings(ide_drive_t *drive) { ; }
+#endif
+
 static const struct cd_list_entry ide_cd_quirks_list[] = {
 	/* Limit transfer size per interrupt. */
 	{ "SAMSUNG CD-ROM SCR-2430", NULL,   IDE_CD_FLAG_LIMIT_NFRAMES	    },
@@ -1930,33 +1956,6 @@ static void ide_cd_release(struct kref *kref)
 
 static int ide_cd_probe(ide_drive_t *);
 
-#ifdef CONFIG_IDE_PROC_FS
-static sector_t ide_cdrom_capacity(ide_drive_t *drive)
-{
-	unsigned long capacity, sectors_per_frame;
-
-	if (cdrom_read_capacity(drive, &capacity, &sectors_per_frame, NULL))
-		return 0;
-
-	return capacity * sectors_per_frame;
-}
-
-static int proc_idecd_read_capacity
-	(char *page, char **start, off_t off, int count, int *eof, void *data)
-{
-	ide_drive_t *drive = data;
-	int len;
-
-	len = sprintf(page, "%llu\n", (long long)ide_cdrom_capacity(drive));
-	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
-}
-
-static ide_proc_entry_t idecd_proc[] = {
-	{ "capacity", S_IFREG|S_IRUGO, proc_idecd_read_capacity, NULL },
-	{ NULL, 0, NULL, NULL }
-};
-#endif
-
 static ide_driver_t ide_cdrom_driver = {
 	.gen_driver = {
 		.owner		= THIS_MODULE,
-- 
1.5.4.1

