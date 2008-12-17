Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760289AbYLQMgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbYLQMgI (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:36:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbYLQM3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53748 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026AbYLQM3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:25 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 18/24] GFS2: Send some sensible sysfs stuff
Date: Wed, 17 Dec 2008 11:30:17 +0000
Message-Id: <1229513423-19105-19-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-18-git-send-email-swhiteho@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

We ought to inform the user of the locktable and lockproto for each
uevent we generate.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking/dlm/sysfs.c b/fs/gfs2/locking/dlm/sysfs.c
index 4ec571c..9b7edcf 100644
--- a/fs/gfs2/locking/dlm/sysfs.c
+++ b/fs/gfs2/locking/dlm/sysfs.c
@@ -195,9 +195,23 @@ void gdlm_kobject_release(struct gdlm_ls *ls)
 	kobject_put(&ls->kobj);
 }
 
+static int gdlm_uevent(struct kset *kset, struct kobject *kobj,
+		       struct kobj_uevent_env *env)
+{
+        struct gdlm_ls *ls = container_of(kobj, struct gdlm_ls, kobj);
+        add_uevent_var(env, "LOCKTABLE=%s:%s", ls->clustername, ls->fsname);
+        add_uevent_var(env, "LOCKPROTO=lock_dlm");
+        return 0;
+}
+
+static struct kset_uevent_ops gdlm_uevent_ops = {
+	.uevent = gdlm_uevent,
+};
+
+
 int gdlm_sysfs_init(void)
 {
-	gdlm_kset = kset_create_and_add("lock_dlm", NULL, kernel_kobj);
+	gdlm_kset = kset_create_and_add("lock_dlm", &gdlm_uevent_ops, kernel_kobj);
 	if (!gdlm_kset) {
 		printk(KERN_WARNING "%s: can not create kset\n", __func__);
 		return -ENOMEM;
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 67ba5b7..298bcb6 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -461,11 +461,25 @@ void gfs2_sys_fs_del(struct gfs2_sbd *sdp)
 	kobject_put(&sdp->sd_kobj);
 }
 
+static int gfs2_uevent(struct kset *kset, struct kobject *kobj,
+		       struct kobj_uevent_env *env)
+{
+	struct gfs2_sbd *sdp = container_of(kobj, struct gfs2_sbd, sd_kobj);
+	add_uevent_var(env, "LOCKTABLE=%s", sdp->sd_table_name);
+	add_uevent_var(env, "LOCKPROTO=%s", sdp->sd_proto_name);
+	return 0;
+}
+
+static struct kset_uevent_ops gfs2_uevent_ops = {
+	.uevent = gfs2_uevent,
+};
+
+
 int gfs2_sys_init(void)
 {
 	gfs2_sys_margs = NULL;
 	spin_lock_init(&gfs2_sys_margs_lock);
-	gfs2_kset = kset_create_and_add("gfs2", NULL, fs_kobj);
+	gfs2_kset = kset_create_and_add("gfs2", &gfs2_uevent_ops, fs_kobj);
 	if (!gfs2_kset)
 		return -ENOMEM;
 	return 0;
-- 
1.6.0.3

