Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbZIJKaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbZIJKaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbZIJKaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:30:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497AbZIJK34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:29:56 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Wengang Wang <wen.gang.wang@oracle.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/15] GFS2: free disk inode which is deleted by remote node -V2
Date: Thu, 10 Sep 2009 12:27:59 +0100
Message-Id: <1252582087-10007-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1252582087-10007-7-git-send-email-swhiteho@redhat.com>
References: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-2-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-3-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-4-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-5-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-6-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-7-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wengang Wang <wen.gang.wang@oracle.com>

this patch is for the same problem that Benjamin Marzinski fixes at commit
b94a170e96dc416828af9d350ae2e34b70ae7347

quotation of the original problem:

---cut here---
When a file is deleted from a gfs2 filesystem on one node, a dcache
entry for it may still exist on other nodes in the cluster. If this
happens, gfs2 will be unable to free this file on disk. Because of this,
it's possible to have a gfs2 filesystem with no files on it and no free
space. With this patch, when a node receives a callback notifying it
that the file is being deleted on another node, it schedules a new
workqueue thread to remove the file's dcache entry.
---end cut---

after applying Benjamin's patch, I think there is still a case in which the disk
inode remains even when "no space" is hit. the case is that when running
d_prune_aliases() against the inode, there are one or more dentries(aliases)
which have reference count number > 0. in this case the dentries won't be pruned.
and even later, the reference count becomes to 0, the dentries can still be
cached in memory. unfortunately, no callback come again, things come back to
the state before the callback runs. thus the on disk inode remains there until
in memoryinode is removed for some other reason(shrinking inode cache or unmount
the volume..).

this patch is to remove those dentries when their reference count becomes to 0 and
the inode is deleted by remote node. for implementation, gfs2_dentry_delete() is
added as dentry_operations.d_delete. the function returns true when the inode is
deleted by remote node. in dput(), gfs2_dentry_delete() is called and since it
returns true, the dentry is unhashed from dcache and then removed. when all dentries
are removed, the in memory inode get removed so that the on disk inode is freed.

Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/dentry.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/dentry.c b/fs/gfs2/dentry.c
index 022c66c..91bedda 100644
--- a/fs/gfs2/dentry.c
+++ b/fs/gfs2/dentry.c
@@ -107,8 +107,26 @@ static int gfs2_dhash(struct dentry *dentry, struct qstr *str)
 	return 0;
 }
 
+static int gfs2_dentry_delete(struct dentry *dentry)
+{
+	struct gfs2_inode *ginode;
+
+	if (!dentry->d_inode)
+		return 0;
+
+	ginode = GFS2_I(dentry->d_inode);
+	if (!ginode->i_iopen_gh.gh_gl)
+		return 0;
+
+	if (test_bit(GLF_DEMOTE, &ginode->i_iopen_gh.gh_gl->gl_flags))
+		return 1;
+
+	return 0;
+}
+
 const struct dentry_operations gfs2_dops = {
 	.d_revalidate = gfs2_drevalidate,
 	.d_hash = gfs2_dhash,
+	.d_delete = gfs2_dentry_delete,
 };
 
-- 
1.6.2.5

