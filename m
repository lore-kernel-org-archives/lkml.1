Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbXITHFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbXITHFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbXITHFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:05:18 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:64799 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbXITHFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:05:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=JvnHsCCRjsUa/WZWxotK+iVDBywkh8Mo+T/H9d+GVszNBRUj/ICoOgupDYVNevECBYlp1lXzAn3wECqLHEkdaELI+1lIWpUo934RWXC5twEX0UrNIViHwPywg6d+wCCaY6VZmbP0IwVPVUs+AnYbOWbRdqr9R0oEEa1pyxOQjUM=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 03/15] sysfs: fix sysfs_chmod_file() such that it updates sd->s_mode too
In-Reply-To: <11902719091692-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:05:10 +0900
Message-Id: <11902719102786-git-send-email-htejun@gmail.com>
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

sysfs_chmod_file() looked and updated only inode of the target file.
Dentry and inode are reclaimable and the update mode data will go away
when the inode is reclaimed.  This patch makes sysfs_chmod_file()
update sd->s_mode too such that the change is permanent.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/file.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index ff93c92..9fdf8da 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -521,10 +521,19 @@ int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 	}
 
 	inode = victim->d_inode;
+
 	mutex_lock(&inode->i_mutex);
+
 	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
 	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
 	rc = notify_change(victim, &newattrs);
+
+	if (rc == 0) {
+		mutex_lock(&sysfs_mutex);
+		victim_sd->s_mode = newattrs.ia_mode;
+		mutex_unlock(&sysfs_mutex);
+	}
+
 	mutex_unlock(&inode->i_mutex);
  out:
 	dput(victim);
-- 
1.5.0.3


