Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbYAQWm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbYAQWm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760135AbYAQWgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:36:50 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:10808 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757406AbYAQWgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:36:40 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Mark Fasheh <mark.fasheh@oracle.com>
Subject: [PATCH 04/30] ocfs2: Add data downconvert worker to inode lock
Date: Thu, 17 Jan 2008 14:35:30 -0800
Message-Id: <1200609356-17788-5-git-send-email-mark.fasheh@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to extend inode lock coverage to inode data, we use the same data
downconvert worker with only a small modification to only do work for
regular files.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/dlmglue.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 64d6ff4..840aeda 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -228,6 +228,7 @@ static struct ocfs2_lock_res_ops ocfs2_inode_meta_lops = {
 	.get_osb	= ocfs2_get_inode_osb,
 	.check_downconvert = ocfs2_check_meta_downconvert,
 	.set_lvb	= ocfs2_set_meta_lvb,
+	.downconvert_worker = ocfs2_data_convert_worker,
 	.flags		= LOCK_TYPE_REQUIRES_REFRESH|LOCK_TYPE_USES_LVB,
 };
 
@@ -2851,6 +2852,9 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
        	inode = ocfs2_lock_res_inode(lockres);
 	mapping = inode->i_mapping;
 
+	if (S_ISREG(inode->i_mode))
+		goto out;
+
 	/*
 	 * We need this before the filemap_fdatawrite() so that it can
 	 * transfer the dirty bit from the PTE to the
@@ -2876,6 +2880,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
 		filemap_fdatawait(mapping);
 	}
 
+out:
 	return UNBLOCK_CONTINUE;
 }
 
-- 
1.5.3.6

