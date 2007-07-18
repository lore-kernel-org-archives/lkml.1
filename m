Return-Path: <linux-kernel-owner+w=401wt.eu-S936543AbXGRX2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936543AbXGRX2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936269AbXGRX0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:26:42 -0400
Received: from mail.suse.de ([195.135.220.2]:57429 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935848AbXGRX0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:26:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/14] sysfs: avoid kmem_cache_free(NULL)
Date: Wed, 18 Jul 2007 16:25:41 -0700
Message-Id: <1184801169806-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <118480116414-git-send-email-gregkh@suse.de>
References: <20070718232400.GC4620@kroah.com>
 <11848011502972-git-send-email-gregkh@suse.de>
 <11848011551094-git-send-email-gregkh@suse.de>
 <11848011593154-git-send-email-gregkh@suse.de>
 <118480116414-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

kmem_cache_free() with NULL is not allowed. But it may happen
if out of memory error is triggered in sysfs_new_dirent().
This patch fixes that error handling.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index aee966c..2e6775a 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -361,20 +361,20 @@ static struct dentry_operations sysfs_dentry_ops = {
 struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 {
 	char *dup_name = NULL;
-	struct sysfs_dirent *sd = NULL;
+	struct sysfs_dirent *sd;
 
 	if (type & SYSFS_COPY_NAME) {
 		name = dup_name = kstrdup(name, GFP_KERNEL);
 		if (!name)
-			goto err_out;
+			return NULL;
 	}
 
 	sd = kmem_cache_zalloc(sysfs_dir_cachep, GFP_KERNEL);
 	if (!sd)
-		goto err_out;
+		goto err_out1;
 
 	if (sysfs_alloc_ino(&sd->s_ino))
-		goto err_out;
+		goto err_out2;
 
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_active, 0);
@@ -386,9 +386,10 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 
 	return sd;
 
- err_out:
-	kfree(dup_name);
+ err_out2:
 	kmem_cache_free(sysfs_dir_cachep, sd);
+ err_out1:
+	kfree(dup_name);
 	return NULL;
 }
 
-- 
1.5.2.2

