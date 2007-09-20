Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbXITHIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbXITHIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbXITHF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:05:28 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:64799 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbXITHFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=SA148FxUQBaYJinITQWxNvTKz8ipax7Py8UxpeeywIVDEYrksUyABWdvEZ4KEvhQ4iWeaIy88n+OnYhlB7M0z3aEggLOl8a49T1zIsiWH1FTAdbH8Tu+oy9Y2JUOKbjNC7XMAiVG8r+jAzqgwvK9nDNrw7lCgIN9PIMSXUasw3U=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 09/15] sysfs: make bin attr open get active reference of parent too
In-Reply-To: <11902719091692-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:05:10 +0900
Message-Id: <11902719101974-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All bin attr operations require active references of itself and its
parent.  There's no reason to allow open when its parent has been
deactivated and allowing it is inconsistent with regular sysfs file.
Use sysfs_get_active_two() in bin attribute open function.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/bin.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index e93fe5e..9c8f882 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -171,8 +171,8 @@ static int open(struct inode * inode, struct file * file)
 	struct bin_buffer *bb = NULL;
 	int error;
 
-	/* need attr_sd for attr */
-	if (!sysfs_get_active(attr_sd))
+	/* binary file operations requires both @sd and its parent */
+	if (!sysfs_get_active_two(attr_sd))
 		return -ENODEV;
 
 	error = -EACCES;
@@ -193,12 +193,12 @@ static int open(struct inode * inode, struct file * file)
 	mutex_init(&bb->mutex);
 	file->private_data = bb;
 
-	/* open succeeded, put active reference */
-	sysfs_put_active(attr_sd);
+	/* open succeeded, put active references */
+	sysfs_put_active_two(attr_sd);
 	return 0;
 
  err_out:
-	sysfs_put_active(attr_sd);
+	sysfs_put_active_two(attr_sd);
 	kfree(bb);
 	return error;
 }
-- 
1.5.0.3


