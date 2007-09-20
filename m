Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbXITHG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbXITHG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbXITHFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:05:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:43685 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbXITHFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:05:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=s9fhaUXg7Sl1qWtG3KGEEUEjjENRbz42S+h124Sd/Q0rSixxp05bsOW6hj3PwLirCzU7s3Zk0KK6+tnRt8UxQIswav6dQYpAvOMYUc0FCAuAG893W/qUNM2Q/hrAwiah67No8OIvjsahUBRIHbezCZa2Maw3NYvW47vwQYLxNPA=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 01/15] sysfs: kill SYSFS_FLAG_REMOVED
In-Reply-To: <11902719091692-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:05:09 +0900
Message-Id: <1190271909505-git-send-email-htejun@gmail.com>
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

With sysfs_get_dentry() simplified, there's no user of
SYSFS_FLAG_REMOVED left.  Kill it.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
This patch reverts driver/sysfs-kill-sysfs_flag_removed.patch and thus
can be removed together with it.

 fs/sysfs/dir.c        |    5 ++++-
 include/linux/sysfs.h |    1 +
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index a493c6f..da4bb66 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -222,7 +222,7 @@ static void sysfs_deactivate(struct sysfs_dirent *sd)
 	DECLARE_COMPLETION_ONSTACK(wait);
 	int v;
 
-	BUG_ON(sd->s_sibling);
+	BUG_ON(sd->s_sibling || !(sd->s_flags & SYSFS_FLAG_REMOVED));
 	sd->s_sibling = (void *)&wait;
 
 	/* atomic_add_return() is a mb(), put_active() will always see
@@ -462,8 +462,11 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
  */
 void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
+	BUG_ON(sd->s_flags & SYSFS_FLAG_REMOVED);
+
 	sysfs_unlink_sibling(sd);
 
+	sd->s_flags |= SYSFS_FLAG_REMOVED;
 	sd->s_sibling = acxt->removed;
 	acxt->removed = sd;
 
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 82c31b2..c16e4c5 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -83,6 +83,7 @@ struct sysfs_ops {
 #define SYSFS_COPY_NAME		(SYSFS_DIR | SYSFS_KOBJ_LINK)
 
 #define SYSFS_FLAG_MASK		~SYSFS_TYPE_MASK
+#define SYSFS_FLAG_REMOVED	0x0100
 
 #ifdef CONFIG_SYSFS
 
-- 
1.5.0.3


