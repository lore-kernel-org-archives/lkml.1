Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbYLSWJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbYLSWJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbYLSVzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:55:32 -0500
Received: from mail.suse.de ([195.135.220.2]:58094 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbYLSVz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:55:29 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 44/45] ocfs2/xattr: Fix a bug in xattr allocation estimation
Date: Fri, 19 Dec 2008 13:54:03 -0800
Message-Id: <1229723644-13630-45-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <tao.ma@oracle.com>

When we extend one xattr's value to a large size, the old value size might
be smaller than the size of a value root. In those cases, we still need to
guess the metadata allocation.

Reported-by: Tiger Yang <tiger.yang@oracle.com>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 8af29b3..d0b94ed 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -2270,6 +2270,7 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 								 value_size);
 			xv = (struct ocfs2_xattr_value_root *)
 			     (base + name_offset + name_len);
+			value_size = OCFS2_XATTR_ROOT_SIZE;
 		} else
 			xv = &def_xv.xv;
 
@@ -2283,7 +2284,8 @@ static int ocfs2_calc_xattr_set_need(struct inode *inode,
 							     &xv->xr_list,
 							     new_clusters -
 							     old_clusters);
-			goto out;
+			if (value_size >= OCFS2_XATTR_ROOT_SIZE)
+				goto out;
 		}
 	} else {
 		/*
-- 
1.5.6

