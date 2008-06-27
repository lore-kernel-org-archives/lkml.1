Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbYF0LKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbYF0LKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 07:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYF0LK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:10:28 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:38586 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYF0LK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:10:27 -0400
From: Louis Rilling <louis.rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Louis Rilling <louis.rilling@kerlabs.com>
Subject: [BUGFIX][PATCH] configfs: Fix open directory making rmdir() fail
Date: Fri, 27 Jun 2008 13:10:25 +0200
Message-Id: <1214565025-2646-1-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When checking for user-created elements under an item to be removed by rmdir(),
configfs_detach_prep() counts fake configfs_dirents created by dir_open() as
user-created and fails when finding one. It is however perfectly valid to remove
a directory that is open.

Simply make configfs_detach_prep() skip fake configfs_dirent, like it already
does for attributes, and like detach_groups() does.

Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 fs/configfs/dir.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 2c873fd..e721fd5 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -379,7 +379,8 @@ static int configfs_detach_prep(struct dentry *dentry, struct mutex **wait_mutex
 
 	ret = 0;
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
-		if (sd->s_type & CONFIGFS_NOT_PINNED)
+		if (!sd->s_element ||
+		    (sd->s_type & CONFIGFS_NOT_PINNED))
 			continue;
 		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
 			/* Abort if racing with mkdir() */
-- 
1.5.5.3

