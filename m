Return-Path: <linux-kernel-owner+w=401wt.eu-S936935AbXGRXdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936935AbXGRXdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936427AbXGRX10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:27:26 -0400
Received: from ns1.suse.de ([195.135.220.2]:57502 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936421AbXGRX1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:27:22 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Gabriel C <nix.or.die@googlemail.com>,
       Miles Lane <miles.lane@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/14] sysfs: cosmetic clean up on node creation failure paths
Date: Wed, 18 Jul 2007 16:25:50 -0700
Message-Id: <11848012062759-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11848012023373-git-send-email-gregkh@suse.de>
References: <20070718232400.GC4620@kroah.com>
 <11848011502972-git-send-email-gregkh@suse.de>
 <11848011551094-git-send-email-gregkh@suse.de>
 <11848011593154-git-send-email-gregkh@suse.de>
 <118480116414-git-send-email-gregkh@suse.de>
 <1184801169806-git-send-email-gregkh@suse.de>
 <11848011731698-git-send-email-gregkh@suse.de>
 <1184801177102-git-send-email-gregkh@suse.de>
 <11848011802979-git-send-email-gregkh@suse.de>
 <11848011842017-git-send-email-gregkh@suse.de>
 <1184801188568-git-send-email-gregkh@suse.de>
 <11848011924027-git-send-email-gregkh@suse.de>
 <11848011982615-git-send-email-gregkh@suse.de>
 <11848012023373-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Node addition failure is detected by testing return value of
sysfs_addfm_finish() which returns the number of added and removed
nodes.  As the function is called as the last step of addition right
on top of error handling block, the if blocks looked like the
following.

	if (sysfs_addrm_finish(&acxt))
		success handling, usually return;
	/* fall through to error handling */

This is the opposite of usual convention in sysfs and makes the code
difficult to understand.  This patch inverts the test and makes those
blocks look more like others.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Gabriel C <nix.or.die@googlemail.com>
Cc: Miles Lane <miles.lane@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c     |   12 +++++++-----
 fs/sysfs/file.c    |    9 +++++----
 fs/sysfs/symlink.c |   10 ++++++----
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 2e6775a..048e605 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -699,17 +699,19 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 
 	/* link in */
 	sysfs_addrm_start(&acxt, parent_sd);
+
 	if (!sysfs_find_dirent(parent_sd, name)) {
 		sysfs_add_one(&acxt, sd);
 		sysfs_link_sibling(sd);
 	}
-	if (sysfs_addrm_finish(&acxt)) {
-		*p_sd = sd;
-		return 0;
+
+	if (!sysfs_addrm_finish(&acxt)) {
+		sysfs_put(sd);
+		return -EEXIST;
 	}
 
-	sysfs_put(sd);
-	return -EEXIST;
+	*p_sd = sd;
+	return 0;
 }
 
 int sysfs_create_subdir(struct kobject *kobj, const char *name,
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index cc49799..3e1cc06 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -410,11 +410,12 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 		sysfs_link_sibling(sd);
 	}
 
-	if (sysfs_addrm_finish(&acxt))
-		return 0;
+	if (!sysfs_addrm_finish(&acxt)) {
+		sysfs_put(sd);
+		return -EEXIST;
+	}
 
-	sysfs_put(sd);
-	return -EEXIST;
+	return 0;
 }
 
 
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index d056e96..4ce687f 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -97,11 +97,13 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 		sysfs_link_sibling(sd);
 	}
 
-	if (sysfs_addrm_finish(&acxt))
-		return 0;
+	if (!sysfs_addrm_finish(&acxt)) {
+		error = -EEXIST;
+		goto out_put;
+	}
+
+	return 0;
 
-	error = -EEXIST;
-	/* fall through */
  out_put:
 	sysfs_put(target_sd);
 	sysfs_put(sd);
-- 
1.5.2.2

