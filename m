Return-Path: <linux-kernel-owner+w=401wt.eu-S1763860AbXGPOAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763860AbXGPOAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 10:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757462AbXGPOAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 10:00:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:27924 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301AbXGPOAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 10:00:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=PN6Cs35G8NujZMbqeyqiAkjI0d+nkcKUtPKlTj3EZtRMD2EEyd+/70+3gRNGx18OmX0S4KrfIZ3DjeqZfmwzhZFS6L1d4vIfTHzNPF//hU3q/A0y0ftfufHXy5NEmIsX/VpJlYDebGuK9gLe86BA6H6P5yZSNqSLV6Vj1sLVVP4=
Date: Mon, 16 Jul 2007 22:50:28 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/10] sysfs: fix kmem_cache_free(NULL)
Message-ID: <20070716135028.GA2040@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
References: <20070716134855.GA1858@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716134855.GA1858@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes out of memory error handling in sysfs_new_dirent().
kmem_cache_free() with NULL is not allowed.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 fs/sysfs/dir.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: 2.6-mm/fs/sysfs/dir.c
===================================================================
--- 2.6-mm.orig/fs/sysfs/dir.c
+++ 2.6-mm/fs/sysfs/dir.c
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
 
