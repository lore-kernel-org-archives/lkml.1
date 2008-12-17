Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760612AbYLQMhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612AbYLQMhX (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYLQM3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53751 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbYLQM33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:29 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 21/24] GFS2: Remove ancient, unused code
Date: Wed, 17 Dec 2008 11:30:20 +0000
Message-Id: <1229513423-19105-22-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-21-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-6-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-7-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-8-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-9-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-10-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-11-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-12-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-13-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-14-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-15-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-16-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-17-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-18-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-19-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-20-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-21-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Remove code that used to have something to do with initrd
but has been unused for a long time.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/mount.c b/fs/gfs2/mount.c
index 8c0f16e..3cb0a44 100644
--- a/fs/gfs2/mount.c
+++ b/fs/gfs2/mount.c
@@ -85,14 +85,6 @@ int gfs2_mount_args(struct gfs2_sbd *sdp, char *data_arg, int remount)
 	int error = 0;
 
 	if (!remount) {
-		/*  If someone preloaded options, use those instead  */
-		spin_lock(&gfs2_sys_margs_lock);
-		if (gfs2_sys_margs) {
-			data = gfs2_sys_margs;
-			gfs2_sys_margs = NULL;
-		}
-		spin_unlock(&gfs2_sys_margs_lock);
-
 		/*  Set some defaults  */
 		args->ar_quota = GFS2_QUOTA_DEFAULT;
 		args->ar_data = GFS2_DATA_DEFAULT;
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 298bcb6..26c1fa7 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -26,9 +26,6 @@
 #include "quota.h"
 #include "util.h"
 
-char *gfs2_sys_margs;
-spinlock_t gfs2_sys_margs_lock;
-
 static ssize_t id_show(struct gfs2_sbd *sdp, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%u:%u\n",
@@ -477,8 +474,6 @@ static struct kset_uevent_ops gfs2_uevent_ops = {
 
 int gfs2_sys_init(void)
 {
-	gfs2_sys_margs = NULL;
-	spin_lock_init(&gfs2_sys_margs_lock);
 	gfs2_kset = kset_create_and_add("gfs2", &gfs2_uevent_ops, fs_kobj);
 	if (!gfs2_kset)
 		return -ENOMEM;
@@ -487,7 +482,6 @@ int gfs2_sys_init(void)
 
 void gfs2_sys_uninit(void)
 {
-	kfree(gfs2_sys_margs);
 	kset_unregister(gfs2_kset);
 }
 
diff --git a/fs/gfs2/sys.h b/fs/gfs2/sys.h
index 1ca8cda..e94560e 100644
--- a/fs/gfs2/sys.h
+++ b/fs/gfs2/sys.h
@@ -13,10 +13,6 @@
 #include <linux/spinlock.h>
 struct gfs2_sbd;
 
-/* Allow args to be passed to GFS2 when using an initial ram disk */
-extern char *gfs2_sys_margs;
-extern spinlock_t gfs2_sys_margs_lock;
-
 int gfs2_sys_fs_add(struct gfs2_sbd *sdp);
 void gfs2_sys_fs_del(struct gfs2_sbd *sdp);
 
-- 
1.6.0.3

