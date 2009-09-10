Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZIJK3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZIJK3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbZIJK3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:29:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451AbZIJK3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:29:47 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/15] GFS2: Add sysfs link to device
Date: Thu, 10 Sep 2009 12:27:57 +0100
Message-Id: <1252582087-10007-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1252582087-10007-5-git-send-email-swhiteho@redhat.com>
References: <1252582087-10007-1-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-2-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-3-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-4-git-send-email-swhiteho@redhat.com>
 <1252582087-10007-5-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a link from the per-gfs2 sb sysfs directory to
the block device upon which the filesystem is mounted. The
link is called "device", strangely enough :-)

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/sys.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index dda4bf1..0d4f7e9 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <asm/uaccess.h>
 #include <linux/gfs2_ondisk.h>
+#include <linux/genhd.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -542,9 +543,17 @@ int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 	if (error)
 		goto fail_tune;
 
+	error = sysfs_create_link(&sdp->sd_kobj,
+				  &disk_to_dev(sb->s_bdev->bd_disk)->kobj,
+				  "device");
+	if (error)
+		goto fail_lock_module;
+
 	kobject_uevent_env(&sdp->sd_kobj, KOBJ_ADD, envp);
 	return 0;
 
+fail_lock_module:
+	sysfs_remove_group(&sdp->sd_kobj, &lock_module_group);
 fail_tune:
 	sysfs_remove_group(&sdp->sd_kobj, &tune_group);
 fail_reg:
@@ -556,6 +565,7 @@ fail:
 
 void gfs2_sys_fs_del(struct gfs2_sbd *sdp)
 {
+	sysfs_remove_link(&sdp->sd_kobj, "device");
 	sysfs_remove_group(&sdp->sd_kobj, &tune_group);
 	sysfs_remove_group(&sdp->sd_kobj, &lock_module_group);
 	kobject_put(&sdp->sd_kobj);
-- 
1.6.2.5

