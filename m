Return-Path: <linux-kernel-owner+w=401wt.eu-S1758384AbZLGAh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbZLGAh4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757804AbZLGAhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:37:52 -0500
Received: from kroah.org ([198.145.64.141]:34141 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758115AbZLGAMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:24 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:41 2009
Message-Id: <20091207000640.985999630@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [002/119] cifs: dont use CIFSGetSrvInodeNumber in is_path_accessible
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=cifs-don-t-use-cifsgetsrvinodenumber-in-is_path_accessible.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeff Layton <jlayton@redhat.com>

commit f475f6775465283494346663f201ad04810d2e8a upstream.

Because it's lighter weight, CIFS tries to use CIFSGetSrvInodeNumber to
verify the accessibility of the root inode and then falls back to doing a
full QPathInfo if that fails with -EOPNOTSUPP. I have at least a report
of a server that returns NT_STATUS_INTERNAL_ERROR rather than something
that translates to EOPNOTSUPP.

Rather than trying to be clever with that call, just have
is_path_accessible do a normal QPathInfo. That call is widely
supported and it shouldn't increase the overhead significantly.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2200,16 +2200,8 @@ is_path_accessible(int xid, struct cifsT
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


