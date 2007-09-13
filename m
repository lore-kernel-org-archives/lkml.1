Return-Path: <linux-kernel-owner+w=401wt.eu-S934068AbXIMXtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934068AbXIMXtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762113AbXIMXpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:45:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57151 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510AbXIMXpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:45:10 -0400
Date: Thu, 13 Sep 2007 16:42:00 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Subject: Drivers: clean up direct setting of the name of a kset
Message-ID: <20070913234200.GI10856@kroah.com>
References: <20070913233751.GA10856@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913233751.GA10856@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A kset should not have its name set directly, so dynamically set the
name at runtime.

This is needed to remove the static array in the kobject structure which
will be changed in a future patch.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/edac/edac_mc_sysfs.c |    3 ++-
 fs/dlm/lockspace.c           |    2 +-
 fs/gfs2/locking/dlm/sysfs.c  |    2 +-
 fs/gfs2/sys.c                |    2 +-
 fs/ocfs2/cluster/masklog.c   |    3 ++-
 5 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -743,7 +743,7 @@ static struct kobj_type ktype_mc_set_att
  *	/sys/devices/system/edac/mc
  */
 static struct kset mc_kset = {
-	.kobj = {.name = "mc", .ktype = &ktype_mc_set_attribs },
+	.kobj = {.ktype = &ktype_mc_set_attribs },
 	.ktype = &ktype_mci,
 };
 
@@ -1010,6 +1010,7 @@ int edac_sysfs_setup_mc_kset(void)
 	}
 
 	/* Init the MC's kobject */
+	kobject_set_name(&mc_kset.kobj, "mc");
 	mc_kset.kobj.parent = &edac_class->kset.kobj;
 
 	/* register the mc_kset */
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -167,7 +167,6 @@ static struct kobj_type dlm_ktype = {
 };
 
 static struct kset dlm_kset = {
-	.kobj   = {.name = "dlm",},
 	.ktype  = &dlm_ktype,
 };
 
@@ -228,6 +227,7 @@ int dlm_lockspace_init(void)
 	INIT_LIST_HEAD(&lslist);
 	spin_lock_init(&lslist_lock);
 
+	kobject_set_name(&dlm_kset.kobj, "dlm");
 	kobj_set_kset_s(&dlm_kset, kernel_subsys);
 	error = kset_register(&dlm_kset);
 	if (error)
--- a/fs/gfs2/locking/dlm/sysfs.c
+++ b/fs/gfs2/locking/dlm/sysfs.c
@@ -190,7 +190,6 @@ static struct kobj_type gdlm_ktype = {
 };
 
 static struct kset gdlm_kset = {
-	.kobj   = {.name = "lock_dlm",},
 	.ktype  = &gdlm_ktype,
 };
 
@@ -224,6 +223,7 @@ int gdlm_sysfs_init(void)
 {
 	int error;
 
+	kobject_set_name(&gdlm_kset, "lock_dlm");
 	kobj_set_kset_s(&gdlm_kset, kernel_subsys);
 	error = kset_register(&gdlm_kset);
 	if (error)
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -222,7 +222,6 @@ static struct kobj_type gfs2_ktype = {
 };
 
 static struct kset gfs2_kset = {
-	.kobj   = {.name = "gfs2"},
 	.ktype  = &gfs2_ktype,
 };
 
@@ -553,6 +552,7 @@ int gfs2_sys_init(void)
 {
 	gfs2_sys_margs = NULL;
 	spin_lock_init(&gfs2_sys_margs_lock);
+	kobject_set_name(&gfs2_kset.kobj, "gfs2");
 	kobj_set_kset_s(&gfs2_kset, fs_subsys);
 	return kset_register(&gfs2_kset);
 }
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -143,7 +143,7 @@ static struct kobj_type mlog_ktype = {
 };
 
 static struct kset mlog_kset = {
-	.kobj   = {.name = "logmask", .ktype = &mlog_ktype},
+	.kobj   = {.ktype = &mlog_ktype},
 };
 
 int mlog_sys_init(struct kset *o2cb_subsys)
@@ -156,6 +156,7 @@ int mlog_sys_init(struct kset *o2cb_subs
 	}
 	mlog_attr_ptrs[i] = NULL;
 
+	kobject_set_name(&mlog_kset.kobj, "logmask");
 	kobj_set_kset_s(&mlog_kset, *o2cb_subsys);
 	return kset_register(&mlog_kset);
 }
