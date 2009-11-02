Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbZKBKIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbZKBKIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbZKBKH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:07:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:47280 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363AbZKBKHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:07:02 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Alan Cox <alan@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Serge Hallyn <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 15/27] BKL: Remove BKL from devpts
Date: Mon,  2 Nov 2009 11:04:55 +0100
Message-Id: <1257156307-24175-16-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL is only used in get_sb. It is safe to remove it.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/devpts/inode.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index e206eef..d5f8c96 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -24,7 +24,6 @@
 #include <linux/parser.h>
 #include <linux/fsnotify.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h> /* just for lock_kernel() */
 
 #define DEVPTS_DEFAULT_MODE 0600
 /*
@@ -364,23 +363,17 @@ static int devpts_get_sb(struct file_system_type *fs_type,
 	struct pts_mount_opts opts;
 	struct super_block *s;
 
-	lock_kernel();
-
 	error = parse_mount_options(data, PARSE_MOUNT, &opts);
-	if (error) {
-		unlock_kernel();
+	if (error)
 		return error;
-	}
 
 	if (opts.newinstance)
 		s = sget(fs_type, NULL, set_anon_super, NULL);
 	else
 		s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
 
-	if (IS_ERR(s)) {
-		unlock_kernel();
+	if (IS_ERR(s))
 		return PTR_ERR(s);
-	}
 
 	if (!s->s_root) {
 		s->s_flags = flags;
@@ -398,7 +391,6 @@ static int devpts_get_sb(struct file_system_type *fs_type,
 	if (error)
 		goto out_dput;
 
-	unlock_kernel();
 	return 0;
 
 out_dput:
@@ -406,7 +398,6 @@ out_dput:
 
 out_undo_sget:
 	deactivate_locked_super(s);
-	unlock_kernel();
 	return error;
 }
 
-- 
1.6.4.2

