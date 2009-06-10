Return-Path: <linux-kernel-owner+w=401wt.eu-S932139AbZFJJm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbZFJJm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758815AbZFJJig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40332 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758750AbZFJJiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:38:19 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 19/24] GFS2: Remove lockstruct subdir from gfs2 sysfs files
Date: Wed, 10 Jun 2009 09:31:00 +0100
Message-Id: <1244622665-7470-20-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-19-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-4-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-5-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-6-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-7-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-8-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-9-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-10-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-11-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-12-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-13-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-14-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-15-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-16-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-17-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-18-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-19-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lockstruct sub directory contained two entries, both of
which are duplicated elsewhere in the gfs2 sysfs files as
well as being available via /proc/mounts. There is no userland program
using either of them, so this patch removes them.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 9f6d48b..94bd59e 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -276,25 +276,6 @@ static struct kobj_type gfs2_ktype = {
 	.sysfs_ops     = &gfs2_attr_ops,
 };
 
-/*
- * display struct lm_lockstruct fields
- */
-
-#define LOCKSTRUCT_ATTR(name, fmt)                                          \
-static ssize_t name##_show(struct gfs2_sbd *sdp, char *buf)                 \
-{                                                                           \
-	return snprintf(buf, PAGE_SIZE, fmt, sdp->sd_lockstruct.ls_##name); \
-}                                                                           \
-static struct gfs2_attr lockstruct_attr_##name = __ATTR_RO(name)
-
-LOCKSTRUCT_ATTR(jid,      "%u\n");
-LOCKSTRUCT_ATTR(first,    "%u\n");
-
-static struct attribute *lockstruct_attrs[] = {
-	&lockstruct_attr_jid.attr,
-	&lockstruct_attr_first.attr,
-	NULL,
-};
 
 /*
  * lock_module. Originally from lock_dlm
@@ -397,6 +378,11 @@ static ssize_t recover_status_show(struct gfs2_sbd *sdp, char *buf)
 	return sprintf(buf, "%d\n", ls->ls_recover_jid_status);
 }
 
+static ssize_t jid_show(struct gfs2_sbd *sdp, char *buf)
+{
+	return sprintf(buf, "%u\n", sdp->sd_lockstruct.ls_jid);
+}
+
 #define GDLM_ATTR(_name,_mode,_show,_store) \
 static struct gfs2_attr gdlm_attr_##_name = __ATTR(_name,_mode,_show,_store)
 
@@ -404,6 +390,7 @@ GDLM_ATTR(proto_name,     0444, proto_name_show,	NULL);
 GDLM_ATTR(block,          0644, block_show,		block_store);
 GDLM_ATTR(withdraw,       0644, withdraw_show,		withdraw_store);
 GDLM_ATTR(id,             0444, lkid_show,		NULL);
+GDLM_ATTR(jid,		  0444, jid_show,		NULL);
 GDLM_ATTR(first,          0444, lkfirst_show,		NULL);
 GDLM_ATTR(first_done,     0444, first_done_show,	NULL);
 GDLM_ATTR(recover,        0200, NULL,			recover_store);
@@ -415,7 +402,7 @@ static struct attribute *lock_module_attrs[] = {
 	&gdlm_attr_block.attr,
 	&gdlm_attr_withdraw.attr,
 	&gdlm_attr_id.attr,
-	&lockstruct_attr_jid.attr,
+	&gdlm_attr_jid.attr,
 	&gdlm_attr_first.attr,
 	&gdlm_attr_first_done.attr,
 	&gdlm_attr_recover.attr,
@@ -558,11 +545,6 @@ static struct attribute *tune_attrs[] = {
 	NULL,
 };
 
-static struct attribute_group lockstruct_group = {
-	.name = "lockstruct",
-	.attrs = lockstruct_attrs,
-};
-
 static struct attribute_group args_group = {
 	.name = "args",
 	.attrs = args_attrs,
@@ -588,13 +570,9 @@ int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 	if (error)
 		goto fail;
 
-	error = sysfs_create_group(&sdp->sd_kobj, &lockstruct_group);
-	if (error)
-		goto fail_reg;
-
 	error = sysfs_create_group(&sdp->sd_kobj, &args_group);
 	if (error)
-		goto fail_lockstruct;
+		goto fail_reg;
 
 	error = sysfs_create_group(&sdp->sd_kobj, &tune_group);
 	if (error)
@@ -611,8 +589,6 @@ fail_tune:
 	sysfs_remove_group(&sdp->sd_kobj, &tune_group);
 fail_args:
 	sysfs_remove_group(&sdp->sd_kobj, &args_group);
-fail_lockstruct:
-	sysfs_remove_group(&sdp->sd_kobj, &lockstruct_group);
 fail_reg:
 	kobject_put(&sdp->sd_kobj);
 fail:
@@ -624,7 +600,6 @@ void gfs2_sys_fs_del(struct gfs2_sbd *sdp)
 {
 	sysfs_remove_group(&sdp->sd_kobj, &tune_group);
 	sysfs_remove_group(&sdp->sd_kobj, &args_group);
-	sysfs_remove_group(&sdp->sd_kobj, &lockstruct_group);
 	sysfs_remove_group(&sdp->sd_kobj, &lock_module_group);
 	kobject_put(&sdp->sd_kobj);
 }
-- 
1.6.0.6

