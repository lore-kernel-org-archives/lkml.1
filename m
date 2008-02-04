Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbYBDTJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbYBDTJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbYBDTJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:09:14 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:24308 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212AbYBDTJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:09:12 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Mark Fasheh <mark.fasheh@oracle.com>
Subject: [PATCH 1/2] sysfs: Allow removal of symlinks in the sysfs root
Date: Mon,  4 Feb 2008 11:07:41 -0800
Message-Id: <1202152062-28370-2-git-send-email-mark.fasheh@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1202152062-28370-1-git-send-email-mark.fasheh@oracle.com>
References: <1202152062-28370-1-git-send-email-mark.fasheh@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow callers of sysfs_remove_link() to pass a NULL kobj, in which case
sysfs_root will be used as the parent directory. This allows us to tear down
top level symlinks created via sysfs_create_link(), which already has
similar handling of a NULL parent object.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/sysfs/symlink.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 5f66c44..817f596 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -87,7 +87,14 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 
 void sysfs_remove_link(struct kobject * kobj, const char * name)
 {
-	sysfs_hash_and_remove(kobj->sd, name);
+	struct sysfs_dirent *parent_sd = NULL;
+
+	if (!kobj)
+		parent_sd = &sysfs_root;
+	else
+		parent_sd = kobj->sd;
+
+	sysfs_hash_and_remove(parent_sd, name);
 }
 
 static int sysfs_get_target_path(struct sysfs_dirent *parent_sd,
-- 
1.5.3.6

