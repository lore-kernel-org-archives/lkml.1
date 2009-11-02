Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbZKBKNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbZKBKNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZKBKMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:12:41 -0500
Received: from cantor.suse.de ([195.135.220.2]:47270 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370AbZKBKHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:00 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
       Abhishek Kulkarni <adkulkar@umail.iu.edu>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       v9fs-developer@lists.sourceforge.net
Subject: [PATCH 09/27] BKL: Remove BKL from 9p
Date: Mon,  2 Nov 2009 11:04:49 +0100
Message-Id: <1257156307-24175-10-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in get_sb. It is safe to remove it.

The only shared data structure that is accessed during get_sb is the session
list which is protected by a spinlock.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/9p/vfs_super.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 4156a0c..14a8644 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -106,15 +106,11 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 	struct p9_fid *fid;
 	int retval = 0;
 
-	lock_kernel();
-
 	P9_DPRINTK(P9_DEBUG_VFS, " \n");
 
 	v9ses = kzalloc(sizeof(struct v9fs_session_info), GFP_KERNEL);
-	if (!v9ses) {
-		unlock_kernel();
+	if (!v9ses)
 		return -ENOMEM;
-	}
 
 	fid = v9fs_session_init(v9ses, dev_name, data);
 	if (IS_ERR(fid)) {
@@ -159,7 +155,6 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 
 P9_DPRINTK(P9_DEBUG_VFS, " simple set mount, return 0\n");
 	simple_set_mnt(mnt, sb);
-	unlock_kernel();
 	return 0;
 
 free_stat:
@@ -172,14 +167,12 @@ clunk_fid:
 close_session:
 	v9fs_session_close(v9ses);
 	kfree(v9ses);
-	unlock_kernel();
 	return retval;
 
 release_sb:
 	p9stat_free(st);
 	kfree(st);
 	deactivate_locked_super(sb);
-	unlock_kernel();
 	return retval;
 }
 
-- 
1.6.4.2

