Return-Path: <linux-kernel-owner+w=401wt.eu-S932434AbZJUTZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbZJUTZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbZJUTZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:25:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174AbZJUTVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:21:16 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>
Subject: [PATCH 28/41] union-mount: call do_whiteout() on unlink and rmdir
Date: Wed, 21 Oct 2009 12:19:26 -0700
Message-Id: <1256152779-10054-29-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-28-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
 <1256152779-10054-9-git-send-email-vaurora@redhat.com>
 <1256152779-10054-10-git-send-email-vaurora@redhat.com>
 <1256152779-10054-11-git-send-email-vaurora@redhat.com>
 <1256152779-10054-12-git-send-email-vaurora@redhat.com>
 <1256152779-10054-13-git-send-email-vaurora@redhat.com>
 <1256152779-10054-14-git-send-email-vaurora@redhat.com>
 <1256152779-10054-15-git-send-email-vaurora@redhat.com>
 <1256152779-10054-16-git-send-email-vaurora@redhat.com>
 <1256152779-10054-17-git-send-email-vaurora@redhat.com>
 <1256152779-10054-18-git-send-email-vaurora@redhat.com>
 <1256152779-10054-19-git-send-email-vaurora@redhat.com>
 <1256152779-10054-20-git-send-email-vaurora@redhat.com>
 <1256152779-10054-21-git-send-email-vaurora@redhat.com>
 <1256152779-10054-22-git-send-email-vaurora@redhat.com>
 <1256152779-10054-23-git-send-email-vaurora@redhat.com>
 <1256152779-10054-24-git-send-email-vaurora@redhat.com>
 <1256152779-10054-25-git-send-email-vaurora@redhat.com>
 <1256152779-10054-26-git-send-email-vaurora@redhat.com>
 <1256152779-10054-27-git-send-email-vaurora@redhat.com>
 <1256152779-10054-28-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Call do_whiteout() when removing files and directories.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f7ef769..1f2a214 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2898,6 +2898,10 @@ static int do_whiteout(struct nameidata *nd, struct path *path, int isdir)
 	if (err)
 		goto out;
 
+	err = -ENOENT;
+	if (!dentry->d_inode)
+		goto out;
+
 	err = -ENOTEMPTY;
 	if (isdir && !directory_is_empty(path->dentry, path->mnt))
 		goto out;
@@ -3012,6 +3016,10 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	error = hash_lookup_union(&nd, &nd.last, &path);
 	if (error)
 		goto exit2;
+	if (is_unionized(nd.path.dentry, nd.path.mnt)) {
+		error = do_whiteout(&nd, &path, 1);
+		goto exit3;
+	}
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto exit3;
@@ -3100,6 +3108,10 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 		inode = path.dentry->d_inode;
 		if (inode)
 			atomic_inc(&inode->i_count);
+		if (is_unionized(nd.path.dentry, nd.path.mnt)) {
+			error = do_whiteout(&nd, &path, 0);
+			goto exit2;
+		}
 		error = mnt_want_write(nd.path.mnt);
 		if (error)
 			goto exit2;
-- 
1.6.3.3

