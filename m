Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbZFVTVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbZFVTVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbZFVTVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:21:02 -0400
Received: from mx2.netapp.com ([216.240.18.37]:6269 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbZFVTU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:20:58 -0400
X-IronPort-AV: E=Sophos;i="4.42,270,1243839600"; 
   d="scan'208";a="194527922"
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 5/5] NFS: Correct the NFS mount path when following a
 referral
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 15:09:14 -0400
Message-ID: <20090622190914.27923.84173.stgit@heimdal.trondhjem.org>
In-Reply-To: <20090622190913.27923.31665.stgit@heimdal.trondhjem.org>
References: <20090622190913.27923.31665.stgit@heimdal.trondhjem.org>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 22 Jun 2009 19:20:59.0734 (UTC) FILETIME=[93241F60:01C9F36E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/super.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 8da7e59..daecbad 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2548,6 +2548,27 @@ static struct vfsmount *nfs_do_root_mount(struct file_system_type *fs_type,
 	return root_mnt;
 }
 
+static void nfs_fix_devname(const struct path *path, struct vfsmount *mnt)
+{
+	char *page = (char *) __get_free_page(GFP_KERNEL);
+	char *devname, *tmp;
+
+	if (page == NULL)
+		return;
+	devname = nfs_path(path->mnt->mnt_devname,
+			path->mnt->mnt_root, path->dentry,
+			page, PAGE_SIZE);
+	if (devname == NULL)
+		goto out_freepage;
+	tmp = kstrdup(devname, GFP_KERNEL);
+	if (tmp == NULL)
+		goto out_freepage;
+	kfree(mnt->mnt_devname);
+	mnt->mnt_devname = tmp;
+out_freepage:
+	free_page((unsigned long)page);
+}
+
 static int nfs_follow_remote_path(struct vfsmount *root_mnt,
 		const char *export_path, struct vfsmount *mnt_target)
 {
@@ -2574,6 +2595,9 @@ static int nfs_follow_remote_path(struct vfsmount *root_mnt,
 	mnt_target->mnt_sb = s;
 	mnt_target->mnt_root = dget(nd.path.dentry);
 
+	/* Correct the device pathname */
+	nfs_fix_devname(&nd.path, mnt_target);
+
 	path_put(&nd.path);
 	down_write(&s->s_umount);
 	return 0;

