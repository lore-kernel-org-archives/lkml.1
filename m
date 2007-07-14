Return-Path: <linux-kernel-owner+w=401wt.eu-S1764920AbXGNCNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764920AbXGNCNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 22:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762857AbXGNCN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 22:13:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:13380 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761925AbXGNCN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 22:13:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=D4wyxfvwFnbdUG5vyrJOGPhbIRPDMy1d3KISEdfp/0+mLXqCIV3OUaG4n0YJCSrttWioKsBti5o5vXHqCZ+BR7Go9/08bGZIr3nafPuYaaBGjXHFe4qq4EI18lqPdM4FJxPSdEZo9MU0XJk71arkKad2YRYKHwydl2pxeA/Wrz0=
Date: Sat, 14 Jul 2007 11:03:35 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] sysfs: avoid kmem_cache_free(NULL)
Message-ID: <20070714020335.GA12453@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kmem_cache_free() with NULL is not allowed. But it may happen
if out of memory error is triggered in sysfs_new_dirent().
This patch fixes that error handling.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 fs/sysfs/dir.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: 2.6-git/fs/sysfs/dir.c
===================================================================
--- 2.6-git.orig/fs/sysfs/dir.c
+++ 2.6-git/fs/sysfs/dir.c
@@ -361,20 +361,20 @@ static struct dentry_operations sysfs_de
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
@@ -386,9 +386,10 @@ struct sysfs_dirent *sysfs_new_dirent(co
 
 	return sd;
 
- err_out:
-	kfree(dup_name);
+ err_out2:
 	kmem_cache_free(sysfs_dir_cachep, sd);
+ err_out1:
+	kfree(dup_name);
 	return NULL;
 }
 
