Return-Path: <linux-kernel-owner+w=401wt.eu-S1760002AbXITHIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbXITHIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbXITHFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:05:31 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:65209 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbXITHFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:05:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=ow3jf+b9Y47JRKN2Hnf9dQxspYljOsZpdmR31p5tA4ghq3jhQ5qCaQ4vK2UiCcB8NuFvJyMMOTwSzeiICBl+sqHZeeQ0vdnRheyRLbxZJlkPASwVwRI6H0up9ePRZm5q8Dk3ieG4wM/M0ZVnIiwUl6rDiD20isY3bFpbKKKHnp8=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 11/15] sysfs: open code sysfs_attach_dentry()
In-Reply-To: <11902719091692-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:05:11 +0900
Message-Id: <1190271911189-git-send-email-htejun@gmail.com>
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

sysfs_attach_dentry() now has only one caller and isn't doing much
other than obfuscating the code.  Open code and kill it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c |   20 ++++----------------
 1 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 942d8e3..7500407 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -332,21 +332,6 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 	return NULL;
 }
 
-/**
- *	sysfs_attach_dentry - associate sysfs_dirent with dentry
- *	@sd: target sysfs_dirent
- *	@dentry: dentry to associate
- *
- *	LOCKING:
- *	mutex_lock(sysfs_mutex)
- */
-static void sysfs_attach_dentry(struct sysfs_dirent *sd, struct dentry *dentry)
-{
-	dentry->d_op = &sysfs_dentry_ops;
-	dentry->d_fsdata = sysfs_get(sd);
-	d_rehash(dentry);
-}
-
 static int sysfs_ilookup_test(struct inode *inode, void *arg)
 {
 	struct sysfs_dirent *sd = arg;
@@ -692,8 +677,11 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 	}
 
+	/* instantiate and hash dentry */
+	dentry->d_op = &sysfs_dentry_ops;
+	dentry->d_fsdata = sysfs_get(sd);
 	d_instantiate(dentry, inode);
-	sysfs_attach_dentry(sd, dentry);
+	d_rehash(dentry);
 
  out_unlock:
 	mutex_unlock(&sysfs_mutex);
-- 
1.5.0.3


