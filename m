Return-Path: <linux-kernel-owner+w=401wt.eu-S933261AbYETQur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261AbYETQur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762136AbYETQuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:50:14 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:60685 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760764AbYETQuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:50:11 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2008 12:50:11 EDT
Message-Id: <20080520164318.369365434@kerlabs.com>
References: <20080520163320.025971210@kerlabs.com>
User-Agent: quilt/0.46-1
Date: Tue, 20 May 2008 18:33:21 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: Louis.Rilling@kerlabs.com, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: [RFC][PATCH 1/3] configfs: set CONFIGFS_USET_DEFAULT earlier in configfs_attach_group()
Content-Disposition: inline; filename=configfs-tell-configfs_attach_group-if-default-group.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When creating a config_group, the CONFIGFS_USET_DEFAULT flag of default
sub-groups is only known after create_default_group() finishes its work, that is
after having creating the whole sub-hierarchy. In order to track which lock to
hide from lockdep, we need to known whether a config_group is default earlier,
that is before creating the sub-hierarchy.

This patch adds a def_group flag to configfs_attach_group(), which allows
configfs_attach_group to set the CONFIGFS_USET_DEFAULT flag before calling
populate_groups().

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
---
 fs/configfs/dir.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)


Index: b/fs/configfs/dir.c
===================================================================
--- a/fs/configfs/dir.c	2008-05-20 17:13:18.000000000 +0200
+++ b/fs/configfs/dir.c	2008-05-20 18:19:35.000000000 +0200
@@ -445,7 +445,8 @@ static int populate_attrs(struct config_
 
 static int configfs_attach_group(struct config_item *parent_item,
 				 struct config_item *item,
-				 struct dentry *dentry);
+				 struct dentry *dentry,
+				 int def_group);
 static void configfs_detach_group(struct config_item *item);
 
 static void detach_groups(struct config_group *group)
@@ -500,7 +501,6 @@ static int create_default_group(struct c
 {
 	int ret;
 	struct qstr name;
-	struct configfs_dirent *sd;
 	/* We trust the caller holds a reference to parent */
 	struct dentry *child, *parent = parent_group->cg_item.ci_dentry;
 
@@ -516,11 +516,9 @@ static int create_default_group(struct c
 		d_add(child, NULL);
 
 		ret = configfs_attach_group(&parent_group->cg_item,
-					    &group->cg_item, child);
-		if (!ret) {
-			sd = child->d_fsdata;
-			sd->s_type |= CONFIGFS_USET_DEFAULT;
-		} else {
+					    &group->cg_item, child,
+					    1);
+		if (ret) {
 			d_delete(child);
 			dput(child);
 		}
@@ -692,7 +690,8 @@ static void configfs_detach_item(struct 
 
 static int configfs_attach_group(struct config_item *parent_item,
 				 struct config_item *item,
-				 struct dentry *dentry)
+				 struct dentry *dentry,
+				 int def_group)
 {
 	int ret;
 	struct configfs_dirent *sd;
@@ -701,6 +700,8 @@ static int configfs_attach_group(struct 
 	if (!ret) {
 		sd = dentry->d_fsdata;
 		sd->s_type |= CONFIGFS_USET_DIR;
+		if (def_group)
+			sd->s_type |= CONFIGFS_USET_DEFAULT;
 
 		ret = populate_groups(to_config_group(item));
 		if (ret) {
@@ -1094,7 +1095,7 @@ static int configfs_mkdir(struct inode *
 	module_got = 1;
 
 	if (group)
-		ret = configfs_attach_group(parent_item, item, dentry);
+		ret = configfs_attach_group(parent_item, item, dentry, 0);
 	else
 		ret = configfs_attach_item(parent_item, item, dentry);
 
@@ -1418,7 +1419,8 @@ int configfs_register_subsystem(struct c
 		d_add(dentry, NULL);
 
 		err = configfs_attach_group(sd->s_element, &group->cg_item,
-					    dentry);
+					    dentry,
+					    0);
 		if (err) {
 			d_delete(dentry);
 			dput(dentry);

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

