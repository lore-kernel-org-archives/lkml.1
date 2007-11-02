Return-Path: <linux-kernel-owner+w=401wt.eu-S1762129AbXKCAEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762129AbXKCAEI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761830AbXKCAAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:00:55 -0400
Received: from mail.suse.de ([195.135.220.2]:41091 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761810AbXKCAAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:00:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 12/54] kset: convert gfs2 dlm to use kset_create
Date: Fri,  2 Nov 2007 16:58:50 -0700
Message-Id: <1194047972-9850-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/gfs2/locking/dlm/sysfs.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/locking/dlm/sysfs.c b/fs/gfs2/locking/dlm/sysfs.c
index 93e66b2..9c351db 100644
--- a/fs/gfs2/locking/dlm/sysfs.c
+++ b/fs/gfs2/locking/dlm/sysfs.c
@@ -189,7 +189,7 @@ static struct kobj_type gdlm_ktype = {
 	.sysfs_ops     = &gdlm_attr_ops,
 };
 
-static struct kset gdlm_kset;
+static struct kset *gdlm_kset;
 
 int gdlm_kobject_setup(struct gdlm_ls *ls, struct kobject *fskobj)
 {
@@ -201,7 +201,7 @@ int gdlm_kobject_setup(struct gdlm_ls *ls, struct kobject *fskobj)
 		return error;
 	}
 
-	ls->kobj.kset = &gdlm_kset;
+	ls->kobj.kset = gdlm_kset;
 	ls->kobj.ktype = &gdlm_ktype;
 	ls->kobj.parent = fskobj;
 
@@ -221,17 +221,19 @@ int gdlm_sysfs_init(void)
 {
 	int error;
 
-	kobject_set_name(&gdlm_kset.kobj, "lock_dlm");
-	gdlm_kset.kobj.kset = &kernel_subsys;
-	error = kset_register(&gdlm_kset);
-	if (error)
-		printk("lock_dlm: cannot register kset %d\n", error);
-
-	return error;
+	gdlm_kset = kset_create_and_register("lock_dlm", NULL,
+					     NULL, &kernel_subsys);
+	if (IS_ERR(gdlm_kset)) {
+		error = PTR_ERR(gdlm_kset);
+		printk(KERN_WARNING "%s: can not create kset %d\n",
+		       __FUNCTION__, error);
+		return error;
+	}
+	return 0;
 }
 
 void gdlm_sysfs_exit(void)
 {
-	kset_unregister(&gdlm_kset);
+	kset_unregister(gdlm_kset);
 }
 
-- 
1.5.3.4

