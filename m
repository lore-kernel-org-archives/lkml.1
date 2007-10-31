Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbXJaKdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbXJaKdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXJaKdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:33:00 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:36447 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbXJaKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=J7H1W9aagfWQ30uCs5gIqM7sI5xxtWbanZICr3wJlc2oFvcMDYuKSE34HW7WPcuNz2wjXNlPgV3ut7MH23PxI/ryZVIBE/dG2W6YBp/6WNRx9FhbfhLj9yjptQZDqnV5L6ha7gJrA3EulTvJ1ljIagvf2fGeudsKYjsfN5lE/ew=
From: Denis Cheng <crquan@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [sysfs]: make readlink result shorter when the symlink and its target shared some base sysfs subdirectory
Date: Wed, 31 Oct 2007 18:34:20 +0800
Message-Id: <1193826860-6166-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

this is especially useful after /sys/slab introduced, for example:

$ ls -l /sys/slab/mm_struct
lrwxrwxrwx 1 root root 0 2007-10-31 17:40 /sys/slab/mm_struct -> :0000448

instead of:

$ ls -l /sys/slab/mm_struct
lrwxrwxrwx 1 root root 0 2007-10-31 17:40 /sys/slab/mm_struct -> ../slab/:0000448

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/sysfs/symlink.c |   38 +++++++++++++++++++++++++++-----------
 1 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 3eac20c..230a925 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -19,30 +19,41 @@
 
 #include "sysfs.h"
 
-static int object_depth(struct sysfs_dirent *sd)
+static struct sysfs_dirent *object_base(struct sysfs_dirent *parent,
+		struct sysfs_dirent *sd)
+{
+	for (; sd->s_parent; sd = sd->s_parent)
+		if (sd->s_parent == parent)
+			return parent;
+	return NULL;
+}
+
+static int object_depth(struct sysfs_dirent *base, struct sysfs_dirent *sd)
 {
 	int depth = 0;
 
-	for (; sd->s_parent; sd = sd->s_parent)
+	for (; sd->s_parent && sd != base; sd = sd->s_parent)
 		depth++;
 
 	return depth;
 }
 
-static int object_path_length(struct sysfs_dirent * sd)
+static int object_path_length(struct sysfs_dirent *base,
+		struct sysfs_dirent *sd)
 {
 	int length = 1;
 
-	for (; sd->s_parent; sd = sd->s_parent)
+	for (; sd->s_parent && sd != base; sd = sd->s_parent)
 		length += strlen(sd->s_name) + 1;
 
 	return length;
 }
 
-static void fill_object_path(struct sysfs_dirent *sd, char *buffer, int length)
+static void fill_object_path(struct sysfs_dirent *base,
+		struct sysfs_dirent *sd, char *buffer, int length)
 {
 	--length;
-	for (; sd->s_parent; sd = sd->s_parent) {
+	for (; sd->s_parent && sd != base; sd = sd->s_parent) {
 		int cur = strlen(sd->s_name);
 
 		/* back up enough to print this bus id with '/' */
@@ -129,18 +140,23 @@ static int sysfs_get_target_path(struct sysfs_dirent * parent_sd,
 {
 	char * s;
 	int depth, size;
+	struct sysfs_dirent *base;
 
-	depth = object_depth(parent_sd);
-	size = object_path_length(target_sd) + depth * 3 - 1;
+	base = object_base(parent_sd, target_sd);
+	depth = object_depth(base, parent_sd);
+	size = object_path_length(base, target_sd) + depth * 3 - 1;
 	if (size > PATH_MAX)
 		return -ENAMETOOLONG;
 
-	pr_debug("%s: depth = %d, size = %d\n", __FUNCTION__, depth, size);
+	pr_debug("%s: base = %s, depth = %d, size = %d\n",
+			__FUNCTION__,
+			base ? base->s_name : "/sys",
+			depth, size);
 
 	for (s = path; depth--; s += 3)
-		strcpy(s,"../");
+		strcpy(s, "../");
 
-	fill_object_path(target_sd, path, size);
+	fill_object_path(base, target_sd, path, size);
 	pr_debug("%s: path = '%s'\n", __FUNCTION__, path);
 
 	return 0;
-- 
1.5.3.4

