Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYLSV7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYLSV7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbYLSVyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:54:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:48942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938AbYLSVye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:54:34 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 15/45] ocfs2/xattr: Only set buffer update if it doesn't exist in cache.
Date: Fri, 19 Dec 2008 13:53:34 -0800
Message-Id: <1229723644-13630-16-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <tao.ma@oracle.com>

When we call ocfs2_init_xattr_bucket, we deem that the new buffer head
will be written to disk immediately, so we just use sb_getblk. But in
some cases the buffer may have already been in ocfs2 uptodate cache,
so we only call ocfs2_set_buffer_uptodate if the buffer head isn't
in the cache.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 87cf39d..d8fc714 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -219,8 +219,10 @@ static int ocfs2_init_xattr_bucket(struct ocfs2_xattr_bucket *bucket,
 			break;
 		}
 
-		ocfs2_set_new_buffer_uptodate(bucket->bu_inode,
-					      bucket->bu_bhs[i]);
+		if (!ocfs2_buffer_uptodate(bucket->bu_inode,
+					   bucket->bu_bhs[i]))
+			ocfs2_set_new_buffer_uptodate(bucket->bu_inode,
+						      bucket->bu_bhs[i]);
 	}
 
 	if (rc)
-- 
1.5.6

