Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbXDVCTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbXDVCTg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 22:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbXDVCTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 22:19:35 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:7070 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbXDVCTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 22:19:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=uLlP2Op/gZ5yB/TPN1tPwVy8ukVKWMGbwwcvGdeB47pG9oTxrcImuNDRoOAfjy9nwSbprK8GRcsILXySJUj0MfhBefPleNG3MFrGrtwDAgR+88k4h/11q6o6Rgptj+LZpbGmE0hCecHHfFZCggec3jZF3LfQCF8mW5ri1GGSfV0=
Message-ID: <f158dc670704211919k19f9592bv9d150770177bc9d2@mail.gmail.com>
Date: Sat, 21 Apr 2007 20:19:33 -0600
From: "Latchesar Ionkov" <lucho@ionkov.net>
To: "Andrew Morton" <akpm@osdl.org>
Subject: [PATCH] v9fs: don't use primary fid when removing file
Cc: "V9FS Developers" <v9fs-developer@lists.sourceforge.net>,
       linux-fsdevel@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 8fa10474a02061f4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

v9fs_insert uses v9fs_fid_lookup (which also locks the fid) to get the primary
fid associated with the dentry and destroys the v9fs_fid struct after removing
the file. If another process called v9fs_fid_lookup on the same dentry, it may
wait undefinitely for the fid's lock (as the struct is freed).

This patch changes v9fs_remove to use a cloned fid, so the primary fid is
not locked and freed.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>

---
commit ca1a80584fc3211dac158492173467d4f87a27ac
tree 787de07bd6d24bdcc9907f90d9085dcd774b2ea4
parent 0f851021c0f91e5073fa89f26b5ac68e23df8e11
author Latchesar Ionkov <lucho@ionkov.net> Sat, 21 Apr 2007 13:37:15 -0600
committer Latchesar Ionkov <lucho@ionkov.net> Sat, 21 Apr 2007 13:37:15 -0600

 fs/9p/vfs_inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 124a085..b01b0a4 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -415,7 +415,7 @@ static int v9fs_remove(struct inode *dir, struct
dentry *file, int rmdir)
 	file_inode = file->d_inode;
 	sb = file_inode->i_sb;
 	v9ses = v9fs_inode2v9ses(file_inode);
-	v9fid = v9fs_fid_lookup(file);
+	v9fid = v9fs_fid_clone(file);
 	if(IS_ERR(v9fid))
 		return PTR_ERR(v9fid);
