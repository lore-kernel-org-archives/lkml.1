Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0BSTr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:47:58 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:40500 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab0BSTrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:47:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=bkLpsrVjAWlq8cFrSV4cmErrsnjOd4ga/YFjKkGokpFkfvLFLmeJAecvETCFfLmh3e
         CmnSr9JTBVsKilInBqjNyLrK3ywy8Bbcp1gN20QFWdPkVtdLFuy6zqynZ4/WMCwTmwpr
         fhphBExdN2Vs1qj67n3JOCgRw3XOt65Esly4o=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 7/7] ocfs2: use nofail variant of inode_setattr()
Date: Fri, 19 Feb 2010 22:47:25 +0300
Message-Id: <1266608845-13212-8-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266608845-13212-7-git-send-email-dmonakhov@openvz.org>
References: <1266608845-13212-1-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-2-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-3-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-4-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-5-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-6-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-7-git-send-email-dmonakhov@openvz.org>
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
 fs/ocfs2/file.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 06ccf6a..4aed46b 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1065,20 +1065,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 			goto bail_unlock;
 		}
 	}
-
-	/*
-	 * This will intentionally not wind up calling vmtruncate(),
-	 * since all the work for a size change has been done above.
-	 * Otherwise, we could get into problems with truncate as
-	 * ip_alloc_sem is used there to protect against i_size
-	 * changes.
-	 */
-	status = inode_setattr(inode, attr);
-	if (status < 0) {
-		mlog_errno(status);
-		goto bail_commit;
-	}
-
+	__inode_setattr(inode, attr);
 	status = ocfs2_mark_inode_dirty(handle, inode, bh);
 	if (status < 0)
 		mlog_errno(status);
-- 
1.6.6

