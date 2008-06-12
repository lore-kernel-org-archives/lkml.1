Return-Path: <linux-kernel-owner+w=401wt.eu-S1756333AbYFLPbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbYFLPbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 11:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYFLPat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 11:30:49 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:54020 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbYFLPas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 11:30:48 -0400
Message-Id: <20080612152953.667564205@kerlabs.com>
References: <20080612152645.445504681@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Thu, 12 Jun 2008 17:26:47 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, ocfs2-devel@oss.oracle.com,
       linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 2/3] configfs: call drop_link() to cleanup after create_link() failure
Content-Disposition: inline; filename=configfs-drop_link-if-create_link-fails.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When allow_link() succeeds but create_link() fails, the subsystem is not
informed of the failure.

This patch fixes this by calling drop_link() on create_link() failures.

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
---
 fs/configfs/symlink.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: b/fs/configfs/symlink.c
===================================================================
--- a/fs/configfs/symlink.c	2008-06-12 17:13:27.000000000 +0200
+++ b/fs/configfs/symlink.c	2008-06-12 17:13:38.000000000 +0200
@@ -137,8 +137,12 @@ int configfs_symlink(struct inode *dir, 
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
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

