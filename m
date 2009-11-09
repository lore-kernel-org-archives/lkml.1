Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZKIAjC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZKIAjC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 19:39:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZKIAjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 19:39:01 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:34432 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZKIAjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 19:39:00 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org,
       linux-fsdevel@vger.kernel.org
Cc: smfrench@gmail.com
Subject: [PATCH] cifs: don't use CIFSGetSrvInodeNumber in is_path_accessible
Date: Sun,  8 Nov 2009 19:39:04 -0500
Message-Id: <1257727144-6468-2-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1257727144-6468-1-git-send-email-jlayton@redhat.com>
References: <1257727144-6468-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because it's lighter weight, CIFS tries to use CIFSGetSrvInodeNumber to
verify the accessibility of the root inode and then falls back to doing a
full QPathInfo if that fails with -EOPNOTSUPP. I have at least a report
of a server that returns NT_STATUS_INTERNAL_ERROR rather than something
that translates to EOPNOTSUPP.

Rather than trying to be clever with that call, just have
is_path_accessible do a normal QPathInfo. That call is widely
supported and it shouldn't increase the overhead significantly.

Cc: Stable <stable@kernel.org>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
---
 fs/cifs/connect.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b090980..63ea83f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2220,16 +2220,8 @@ is_path_accessible(int xid, struct cifsTconInfo *tcon,
 		   struct cifs_sb_info *cifs_sb, const char *full_path)
 {
 	int rc;
-	__u64 inode_num;
 	FILE_ALL_INFO *pfile_info;
 
-	rc = CIFSGetSrvInodeNumber(xid, tcon, full_path, &inode_num,
-				   cifs_sb->local_nls,
-				   cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
-	if (rc != -EOPNOTSUPP)
-		return rc;
-
 	pfile_info = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
 	if (pfile_info == NULL)
 		return -ENOMEM;
-- 
1.6.0.6

