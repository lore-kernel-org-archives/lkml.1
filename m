Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbYLVWFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbYLVWFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbYLVVuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:50:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:41748 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756208AbYLVVuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:50:10 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 46/56] ocfs2: Explain t_is_new in ocfs2_cp_xattr_cluster().
Date: Mon, 22 Dec 2008 13:48:27 -0800
Message-Id: <1229982517-3455-47-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel Becker <joel.becker@oracle.com>

I was unsure of the JOURNAL_ACCESS parameters in
ocfs2_cp_xattr_cluster().  They're based on the function argument
't_is_new', but I couldn't quite figure out how t_is_new mapped to
allocation.  ocfs2_cp_xattr_cluster() actually overwrites the target,
regardless of t_is_new.

Well, I just figured it out.  So I'm adding a big fat comment for those
who come after me.  ocfs2_divide_xattr_cluster() has the same behavior.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 4dba347..5efcf4e 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -3747,6 +3747,11 @@ static int ocfs2_divide_xattr_bucket(struct inode *inode,
 		goto out;
 	}
 
+	/*
+	 * Hey, if we're overwriting t_bucket, what difference does
+	 * ACCESS_CREATE vs ACCESS_WRITE make?  See the comment in the
+	 * same part of ocfs2_cp_xattr_bucket().
+	 */
 	ret = ocfs2_xattr_bucket_journal_access(handle, t_bucket,
 						new_bucket_head ?
 						OCFS2_JOURNAL_ACCESS_CREATE :
@@ -3918,6 +3923,18 @@ static int ocfs2_cp_xattr_bucket(struct inode *inode,
 	if (ret)
 		goto out;
 
+	/*
+	 * Hey, if we're overwriting t_bucket, what difference does
+	 * ACCESS_CREATE vs ACCESS_WRITE make?  Well, if we allocated a new
+	 * cluster to fill, we came here from ocfs2_cp_xattr_cluster(), and
+	 * it is really new - ACCESS_CREATE is required.  But we also
+	 * might have moved data out of t_bucket before extending back
+	 * into it.  ocfs2_add_new_xattr_bucket() can do this - its call
+	 * to ocfs2_add_new_xattr_cluster() may have created a new extent
+	 * and copied out the end of the old extent.  Then it re-extends
+	 * the old extent back to create space for new xattrs.  That's
+	 * how we get here, and the bucket isn't really new.
+	 */
 	ret = ocfs2_xattr_bucket_journal_access(handle, t_bucket,
 						t_is_new ?
 						OCFS2_JOURNAL_ACCESS_CREATE :
-- 
1.5.6

