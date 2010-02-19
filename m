Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab0BSTtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:49:33 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:38652 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab0BSTrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:47:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=V1I40naFNkiDOtN0ZlRyVKBwW95LaZsyjNSiNFSG0EE5aAU9zVXGCIpdhhs8BQb2qx
         1ZpfY6+kqRM4s3lG3Stc+6102mIpPpouOCpBdz/gy+E1XULZzeiBts88v6GsxEDIOpnp
         XYEz3AV5GB0+1pel6qBaNyOzAnuwcBiUGFBeE=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 6/7] ext4: use nofail variant of inode_setattr()
Date: Fri, 19 Feb 2010 22:47:24 +0300
Message-Id: <1266608845-13212-7-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266608845-13212-6-git-send-email-dmonakhov@openvz.org>
References: <1266608845-13212-1-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-2-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-3-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-4-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-5-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-6-git-send-email-dmonakhov@openvz.org>
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
 fs/ext4/inode.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 218ea0b..1748265 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5436,8 +5436,11 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			}
 		}
 	}
-
-	rc = inode_setattr(inode, attr);
+	/*
+	 * All necessery check already done in inode_check_ok(),
+	 * it is safe to use nofail version here.
+	 */
+	__inode_setattr(inode, attr);
 
 	/* If inode_setattr's call to ext4_truncate failed to get a
 	 * transaction handle at all, we need to clean up the in-core
-- 
1.6.6

