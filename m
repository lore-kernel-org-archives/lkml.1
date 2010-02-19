Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab0BSTt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:49:57 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49065 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab0BSTro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:47:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=r+zFWs8pHbyh4f103Gl0FamCSt5tM6YkOm0JVsMShI1/lbIDajlLbCNs6GPykLVoK1
         WFuamM+nKI4XofD6ZNHGxIhOgmhBrxZeknzkC8PA75XNv5E9zBlOP8p/PvnR6FtGGkEb
         /aOV9Rybtu+123CTeyD8WwJ4+JFWHUTovDQyQ=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 5/7] ext3: use nofail variant of inode_setattr()
Date: Fri, 19 Feb 2010 22:47:23 +0300
Message-Id: <1266608845-13212-6-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266608845-13212-5-git-send-email-dmonakhov@openvz.org>
References: <1266608845-13212-1-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-2-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-3-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-4-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we updated i_disk_size and stop the journal it is
too late for error handling from inode_setattr().
Since inode_change_ok() is now responsible for all
necessery checks we may call __inode_setattr() which can
not fail.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/inode.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 455e6e6..196aee3 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -3184,8 +3184,11 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 			error = rc;
 		ext3_journal_stop(handle);
 	}
-
-	rc = inode_setattr(inode, attr);
+	/*
+	 * All necessery check already done in inode_check_ok(),
+	 * it is safe to use nofail version here.
+	 */
+	__inode_setattr(inode, attr);
 
 	if (!rc && (ia_valid & ATTR_MODE))
 		rc = ext3_acl_chmod(inode);
-- 
1.6.6

