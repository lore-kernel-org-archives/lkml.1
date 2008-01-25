Return-Path: <linux-kernel-owner+w=401wt.eu-S1759704AbYAYHdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704AbYAYHdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757746AbYAYHRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:17:35 -0500
Received: from ns1.suse.de ([195.135.220.2]:52780 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759212AbYAYHRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:17:33 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 055/196] kset: convert gfs2 dlm to use kset_create
Date: Thu, 24 Jan 2008 23:09:53 -0800
Message-Id: <1201245134-4876-55-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/gfs2/locking/dlm/sysfs.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/gfs2/locking/dlm/sysfs.c b/fs/gfs2/locking/dlm/sysfs.c
index 93e66b2..0a86140 100644
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
 
@@ -219,19 +219,17 @@ void gdlm_kobject_release(struct gdlm_ls *ls)
 
 int gdlm_sysfs_init(void)
 {
-	int error;
-
-	kobject_set_name(&gdlm_kset.kobj, "lock_dlm");
-	gdlm_kset.kobj.kset = &kernel_subsys;
-	error = kset_register(&gdlm_kset);
-	if (error)
-		printk("lock_dlm: cannot register kset %d\n", error);
-
-	return error;
+	gdlm_kset = kset_create_and_add("lock_dlm", NULL,
+					&kernel_subsys.kobj);
+	if (!gdlm_kset) {
+		printk(KERN_WARNING "%s: can not create kset\n", __FUNCTION__);
+		return -ENOMEM;
+	}
+	return 0;
 }
 
 void gdlm_sysfs_exit(void)
 {
-	kset_unregister(&gdlm_kset);
+	kset_unregister(gdlm_kset);
 }
 
-- 
1.5.3.8

