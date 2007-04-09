Return-Path: <linux-kernel-owner+w=401wt.eu-S933814AbXDIO4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814AbXDIO4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933793AbXDIO4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:56:40 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:44040 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933782AbXDIOzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:55:09 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 21/21] Unionfs: Don't inline do_remount_{add,del,mode}_option
Date: Mon,  9 Apr 2007 10:54:12 -0400
Message-Id: <11761304561043-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.268.g3dda
In-Reply-To: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

gcc4 decided to inline do_remount_{add,del,mode}_option creating an 600 byte
stack abuser on a x86_64 test box.

Reported by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/lookup.c |    2 +-
 fs/unionfs/super.c  |   20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 0572247..0fc5993 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -30,7 +30,7 @@ static int is_validname(const char *name)
 }
 
 /* The rest of these are utility functions for lookup. */
-static int is_opaque_dir(struct dentry *dentry, int bindex)
+static noinline int is_opaque_dir(struct dentry *dentry, int bindex)
 {
 	int err = 0;
 	struct dentry *hidden_dentry;
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index ec5706b..e6a6cc1 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -148,9 +148,9 @@ static int unionfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 }
 
 /* handle mode changing during remount */
-static int do_remount_mode_option(char *optarg, int cur_branches,
-				  struct unionfs_data *new_data,
-				  struct path *new_lower_paths)
+static noinline int do_remount_mode_option(char *optarg, int cur_branches,
+					   struct unionfs_data *new_data,
+					   struct path *new_lower_paths)
 {
 	int err = -EINVAL;
 	int perms, idx;
@@ -207,9 +207,9 @@ out:
 }
 
 /* handle branch deletion during remount */
-static int do_remount_del_option(char *optarg, int cur_branches,
-				 struct unionfs_data *new_data,
-				 struct path *new_lower_paths)
+static noinline int do_remount_del_option(char *optarg, int cur_branches,
+					  struct unionfs_data *new_data,
+					  struct path *new_lower_paths)
 {
 	int err = -EINVAL;
 	int idx;
@@ -268,10 +268,10 @@ out:
 }
 
 /* handle branch insertion during remount */
-static int do_remount_add_option(char *optarg, int cur_branches,
-				 struct unionfs_data *new_data,
-				 struct path *new_lower_paths,
-				 int *high_branch_id)
+static noinline int do_remount_add_option(char *optarg, int cur_branches,
+					  struct unionfs_data *new_data,
+					  struct path *new_lower_paths,
+					  int *high_branch_id)
 {
 	int err = -EINVAL;
 	int perms;
-- 
1.5.0.3.268.g3dda

