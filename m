Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbXITH1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbXITH1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758793AbXITH00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:26:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:23307 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759907AbXITH0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:26:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=ezzwUWASGJTHTo8P8n2CPbXG6aBt9KSDllOCbpp16VZkeOquYf4YxiNPTYn7UUVRb5dM0CdvPyaFnenwre6bAjuWPwXT83hOccVrbnWthV9PiWZodFxE8f/7O+U0Ad4tnJGMberx8iv/beDrV2KgnnsDcTTsaE1K58AeD2xYqNs=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 2/4] sysfs: make the sysfs_addrm_cxt->removed list FIFO
In-Reply-To: <11902731752407-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:26:15 +0900
Message-Id: <11902731753916-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add sysfs_addrm_cxt->removed_tail to make the ->removed list FIFO.
This will be used to implement care-free suicide.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |    7 +++++--
 fs/sysfs/sysfs.h |    2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index ad3394a..c902bdc 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -361,6 +361,7 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
 
 	memset(acxt, 0, sizeof(*acxt));
 	acxt->parent_sd = parent_sd;
+	acxt->removed_tail = &acxt->removed;
 
 	/* Lookup parent inode.  inode initialization and I_NEW
 	 * clearing are protected by sysfs_mutex.  By grabbing it and
@@ -448,8 +449,10 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 	sysfs_unlink_sibling(sd);
 
 	sd->s_flags |= SYSFS_FLAG_REMOVED;
-	sd->s_sibling = acxt->removed;
-	acxt->removed = sd;
+	*acxt->removed_tail = sd;
+	/* keep them in FIFO order, suicide check depends on it */
+	acxt->removed_tail = &sd->s_sibling;
+	*acxt->removed_tail = NULL;
 
 	if (sysfs_type(sd) == SYSFS_DIR && acxt->parent_inode)
 		drop_nlink(acxt->parent_inode);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 269c845..be16947 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -71,7 +71,7 @@ static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 struct sysfs_addrm_cxt {
 	struct sysfs_dirent	*parent_sd;
 	struct inode		*parent_inode;
-	struct sysfs_dirent	*removed;
+	struct sysfs_dirent	*removed, **removed_tail;
 	int			cnt;
 };
 
-- 
1.5.0.3


