Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYLKWfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYLKWfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757054AbYLKWfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:35:37 -0500
Received: from kumera.dghda.com ([80.68.90.171]:41239 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582AbYLKWfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:35:37 -0500
From: "Duane Griffin" <duaneg@dghda.com>
Date: Thu, 11 Dec 2008 22:35:32 +0000
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>, hch@infradead.org
Subject: [PATCH, v2] sysv: ensure link targets are NUL-terminated
Message-ID: <20081211223532.GD18665@dastardly.home.dghda.com>
References: <1229022995-9898-2-git-send-email-duaneg@dghda.com> <1229022995-9898-3-git-send-email-duaneg@dghda.com> <1229022995-9898-4-git-send-email-duaneg@dghda.com> <1229022995-9898-5-git-send-email-duaneg@dghda.com> <1229022995-9898-6-git-send-email-duaneg@dghda.com> <1229022995-9898-7-git-send-email-duaneg@dghda.com> <1229022995-9898-8-git-send-email-duaneg@dghda.com> <1229022995-9898-9-git-send-email-duaneg@dghda.com> <1229022995-9898-10-git-send-email-duaneg@dghda.com> <1229022995-9898-11-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229022995-9898-11-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure link targets are NUL-terminated, even if corrupted on-disk.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

V2: terminate when the link is read instead of every time it is
followed, as suggested by Dave Kleikamp.

diff --git a/fs/sysv/inode.c b/fs/sysv/inode.c
index df0d435..1511228 100644
--- a/fs/sysv/inode.c
+++ b/fs/sysv/inode.c
@@ -163,8 +163,10 @@ void sysv_set_inode(struct inode *inode, dev_t rdev)
 		if (inode->i_blocks) {
 			inode->i_op = &sysv_symlink_inode_operations;
 			inode->i_mapping->a_ops = &sysv_aops;
-		} else
+		} else {
 			inode->i_op = &sysv_fast_symlink_inode_operations;
+			((char *) SYSV_I(inode)->i_data)[inode->i_size] = '\0';
+		}
 	} else
 		init_special_inode(inode, inode->i_mode, rdev);
 }
-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
