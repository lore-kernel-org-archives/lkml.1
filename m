Return-Path: <linux-kernel-owner+w=401wt.eu-S1764015AbYAYH65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764015AbYAYH65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757354AbYAYHhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:37:13 -0500
Received: from mx1.suse.de ([195.135.220.2]:55489 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759844AbYAYHhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:37:11 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 109/196] Kobject: change GFS2 to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:18 -0800
Message-Id: <1201246425-5058-30-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/dlm/lockspace.c          |   26 ++++----------------------
 fs/gfs2/locking/dlm/sysfs.c |   13 +++----------
 fs/gfs2/sys.c               |   10 +++-------
 3 files changed, 10 insertions(+), 39 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index e64b0dc..b750f13 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -168,23 +168,6 @@ static struct kobj_type dlm_ktype = {
 
 static struct kset *dlm_kset;
 
-static int kobject_setup(struct dlm_ls *ls)
-{
-	char lsname[DLM_LOCKSPACE_LEN];
-	int error;
-
-	memset(lsname, 0, DLM_LOCKSPACE_LEN);
-	snprintf(lsname, DLM_LOCKSPACE_LEN, "%s", ls->ls_name);
-
-	error = kobject_set_name(&ls->ls_kobj, "%s", lsname);
-	if (error)
-		return error;
-
-	ls->ls_kobj.kset = dlm_kset;
-	ls->ls_kobj.ktype = &dlm_ktype;
-	return 0;
-}
-
 static int do_uevent(struct dlm_ls *ls, int in)
 {
 	int error;
@@ -545,13 +528,12 @@ static int new_lockspace(char *name, int namelen, void **lockspace,
 		goto out_delist;
 	}
 
-	error = kobject_setup(ls);
-	if (error)
-		goto out_stop;
-
-	error = kobject_register(&ls->ls_kobj);
+	ls->ls_kobj.kset = dlm_kset;
+	error = kobject_init_and_add(&ls->ls_kobj, &dlm_ktype, NULL,
+				     "%s", ls->ls_name);
 	if (error)
 		goto out_stop;
+	kobject_uevent(&ls->ls_kobj, KOBJ_ADD);
 
 	/* let kobject handle freeing of ls if there's an error */
 	do_unreg = 1;
diff --git a/fs/gfs2/locking/dlm/sysfs.c b/fs/gfs2/locking/dlm/sysfs.c
index e5a4fbf..a7336b9 100644
--- a/fs/gfs2/locking/dlm/sysfs.c
+++ b/fs/gfs2/locking/dlm/sysfs.c
@@ -195,19 +195,12 @@ int gdlm_kobject_setup(struct gdlm_ls *ls, struct kobject *fskobj)
 {
 	int error;
 
-	error = kobject_set_name(&ls->kobj, "%s", "lock_module");
-	if (error) {
-		log_error("can't set kobj name %d", error);
-		return error;
-	}
-
 	ls->kobj.kset = gdlm_kset;
-	ls->kobj.ktype = &gdlm_ktype;
-	ls->kobj.parent = fskobj;
-
-	error = kobject_register(&ls->kobj);
+	error = kobject_init_and_add(&ls->kobj, &gdlm_ktype, fskobj,
+				     "lock_module");
 	if (error)
 		log_error("can't register kobj %d", error);
+	kobject_uevent(&ls->kobj, KOBJ_ADD);
 
 	return error;
 }
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 44cfaae..8d9cd5b 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -494,13 +494,8 @@ int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 	int error;
 
 	sdp->sd_kobj.kset = gfs2_kset;
-	sdp->sd_kobj.ktype = &gfs2_ktype;
-
-	error = kobject_set_name(&sdp->sd_kobj, "%s", sdp->sd_table_name);
-	if (error)
-		goto fail;
-
-	error = kobject_register(&sdp->sd_kobj);
+	error = kobject_init_and_add(&sdp->sd_kobj, &gfs2_ktype, NULL,
+				     "%s", sdp->sd_table_name);
 	if (error)
 		goto fail;
 
@@ -520,6 +515,7 @@ int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 	if (error)
 		goto fail_args;
 
+	kobject_uevent(&sdp->sd_kobj, KOBJ_ADD);
 	return 0;
 
 fail_args:
-- 
1.5.3.8

