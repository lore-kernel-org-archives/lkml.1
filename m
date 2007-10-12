Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbXJLWZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbXJLWZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761164AbXJLWSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:18:41 -0400
Received: from mx1.suse.de ([195.135.220.2]:53150 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761099AbXJLWSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:18:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/75] Drivers: clean up direct setting of the name of a kset
Date: Fri, 12 Oct 2007 15:16:18 -0700
Message-Id: <11922275031518-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922274993462-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A kset should not have its name set directly, so dynamically set the
name at runtime.

This is needed to remove the static array in the kobject structure which
will be changed in a future patch.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/edac/edac_mc_sysfs.c         |    3 ++-
 drivers/pci/hotplug/rpadlpar_sysfs.c |    6 +++---
 fs/dlm/lockspace.c                   |    2 +-
 fs/gfs2/locking/dlm/sysfs.c          |    2 +-
 fs/gfs2/sys.c                        |    2 +-
 fs/ocfs2/cluster/masklog.c           |    3 ++-
 6 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 4a0576b..3706b2b 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -743,7 +743,7 @@ static struct kobj_type ktype_mc_set_attribs = {
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
diff --git a/drivers/pci/hotplug/rpadlpar_sysfs.c b/drivers/pci/hotplug/rpadlpar_sysfs.c
index df07606..a080fed 100644
--- a/drivers/pci/hotplug/rpadlpar_sysfs.c
+++ b/drivers/pci/hotplug/rpadlpar_sysfs.c
@@ -129,17 +129,17 @@ struct kobj_type ktype_dlpar_io = {
 };
 
 struct kset dlpar_io_kset = {
-	.kobj = {.name = DLPAR_KOBJ_NAME,
-		 .ktype = &ktype_dlpar_io,
+	.kobj = {.ktype = &ktype_dlpar_io,
 		 .parent = &pci_hotplug_slots_subsys.kobj},
 	.ktype = &ktype_dlpar_io,
 };
 
 int dlpar_sysfs_init(void)
 {
+	kobject_set_name(&dlpar_io_kset.kobj, DLPAR_KOBJ_NAME);
 	if (kset_register(&dlpar_io_kset)) {
 		printk(KERN_ERR "rpadlpar_io: cannot register kset for %s\n",
-				dlpar_io_kset.kobj.name);
+				kobject_name(&dlpar_io_kset.kobj));
 		return -EINVAL;
 	}
 
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 1dc7210..f88f88f 100644
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
diff --git a/fs/gfs2/locking/dlm/sysfs.c b/fs/gfs2/locking/dlm/sysfs.c
index d9fe3ca..ae9e6a2 100644
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
 
+	kobject_set_name(&gdlm_kset.kobj, "lock_dlm");
 	kobj_set_kset_s(&gdlm_kset, kernel_subsys);
 	error = kset_register(&gdlm_kset);
 	if (error)
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index c26c21b..640cb6a 100644
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
diff --git a/fs/ocfs2/cluster/masklog.c b/fs/ocfs2/cluster/masklog.c
index e9e042b..a4882c8 100644
--- a/fs/ocfs2/cluster/masklog.c
+++ b/fs/ocfs2/cluster/masklog.c
@@ -143,7 +143,7 @@ static struct kobj_type mlog_ktype = {
 };
 
 static struct kset mlog_kset = {
-	.kobj   = {.name = "logmask", .ktype = &mlog_ktype},
+	.kobj   = {.ktype = &mlog_ktype},
 };
 
 int mlog_sys_init(struct kset *o2cb_subsys)
@@ -156,6 +156,7 @@ int mlog_sys_init(struct kset *o2cb_subsys)
 	}
 	mlog_attr_ptrs[i] = NULL;
 
+	kobject_set_name(&mlog_kset.kobj, "logmask");
 	kobj_set_kset_s(&mlog_kset, *o2cb_subsys);
 	return kset_register(&mlog_kset);
 }
-- 
1.5.3.4

