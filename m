Return-Path: <linux-kernel-owner+w=401wt.eu-S935838AbYBVVvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935838AbYBVVvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933868AbYBVVnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:43:53 -0500
Received: from ns2.suse.de ([195.135.220.15]:60546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933876AbYBVVnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:43:51 -0500
Date: Fri, 22 Feb 2008 13:40:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Neil Brown <neilb@suse.de>, Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 16/23] NFS: Fix nfs_reval_fsid()
Message-ID: <20080222214045.GQ8686@suse.de>
References: <20080222213114.583282464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfs-fix-nfs_reval_fsid.patch"
In-Reply-To: <20080222213927.GA8686@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

mainline: a0356862bcbeb20acf64bc1a82d28a4c5bb957a7

We don't need to revalidate the fsid on the root directory. It suffices to
revalidate it on the current directory.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Neil Brown <neilb@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/dir.c   |    9 ++++-----
 fs/nfs/inode.c |    4 ++--
 2 files changed, 6 insertions(+), 7 deletions(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -897,14 +897,13 @@ int nfs_is_exclusive_create(struct inode
 	return (nd->intent.open.flags & O_EXCL) != 0;
 }
 
-static inline int nfs_reval_fsid(struct vfsmount *mnt, struct inode *dir,
-				 struct nfs_fh *fh, struct nfs_fattr *fattr)
+static inline int nfs_reval_fsid(struct inode *dir, const struct nfs_fattr *fattr)
 {
 	struct nfs_server *server = NFS_SERVER(dir);
 
 	if (!nfs_fsid_equal(&server->fsid, &fattr->fsid))
-		/* Revalidate fsid on root dir */
-		return __nfs_revalidate_inode(server, mnt->mnt_root->d_inode);
+		/* Revalidate fsid using the parent directory */
+		return __nfs_revalidate_inode(server, dir);
 	return 0;
 }
 
@@ -946,7 +945,7 @@ static struct dentry *nfs_lookup(struct 
 		res = ERR_PTR(error);
 		goto out_unlock;
 	}
-	error = nfs_reval_fsid(nd->mnt, dir, &fhandle, &fattr);
+	error = nfs_reval_fsid(dir, &fattr);
 	if (error < 0) {
 		res = ERR_PTR(error);
 		goto out_unlock;
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -961,8 +961,8 @@ static int nfs_update_inode(struct inode
 		goto out_changed;
 
 	server = NFS_SERVER(inode);
-	/* Update the fsid if and only if this is the root directory */
-	if (inode == inode->i_sb->s_root->d_inode
+	/* Update the fsid? */
+	if (S_ISDIR(inode->i_mode)
 			&& !nfs_fsid_equal(&server->fsid, &fattr->fsid))
 		server->fsid = fattr->fsid;
 

-- 
