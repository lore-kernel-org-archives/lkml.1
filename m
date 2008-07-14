Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYGNWIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYGNWIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758351AbYGNWC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:02:28 -0400
Received: from ns2.suse.de ([195.135.220.15]:33240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758322AbYGNWCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:02:24 -0400
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>,
       Louis Rilling <Louis.Rilling@kerlabs.com>
Subject: [PATCH 16/17] configfs: call drop_link() to cleanup after create_link() failure
Date: Mon, 14 Jul 2008 15:01:49 -0700
Message-Id: <1216072910-27226-17-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
References: <1216072910-27226-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Louis Rilling <Louis.Rilling@kerlabs.com>

When allow_link() succeeds but create_link() fails, the subsystem is not
informed of the failure.

This patch fixes this by calling drop_link() on create_link() failures.

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/configfs/symlink.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index faeb441..0004d18 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -140,8 +140,12 @@ int configfs_symlink(struct inode *dir, struct dentry *dentry, const char *symna
 		goto out_put;
 
 	ret = type->ct_item_ops->allow_link(parent_item, target_item);
-	if (!ret)
+	if (!ret) {
 		ret = create_link(parent_item, target_item, dentry);
+		if (ret && type->ct_item_ops->drop_link)
+			type->ct_item_ops->drop_link(parent_item,
+						     target_item);
+	}
 
 	config_item_put(target_item);
 	path_put(&nd.path);
-- 
1.5.4.1

