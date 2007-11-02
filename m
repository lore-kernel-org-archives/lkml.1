Return-Path: <linux-kernel-owner+w=401wt.eu-S1762342AbXKCADr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762342AbXKCADr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761773AbXKCAAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:00:51 -0400
Received: from mx1.suse.de ([195.135.220.2]:41079 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761757AbXKCAAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:00:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 11/54] kset: convert gfs2 to use kset_create
Date: Fri,  2 Nov 2007 16:58:49 -0700
Message-Id: <1194047972-9850-11-git-send-email-gregkh@suse.de>
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
 fs/gfs2/sys.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index dab7d9d..222dd8d 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -221,7 +221,7 @@ static struct kobj_type gfs2_ktype = {
 	.sysfs_ops     = &gfs2_attr_ops,
 };
 
-static struct kset gfs2_kset;
+static struct kset *gfs2_kset;
 
 /*
  * display struct lm_lockstruct fields
@@ -493,7 +493,7 @@ int gfs2_sys_fs_add(struct gfs2_sbd *sdp)
 {
 	int error;
 
-	sdp->sd_kobj.kset = &gfs2_kset;
+	sdp->sd_kobj.kset = gfs2_kset;
 	sdp->sd_kobj.ktype = &gfs2_ktype;
 
 	error = kobject_set_name(&sdp->sd_kobj, "%s", sdp->sd_table_name);
@@ -548,14 +548,15 @@ int gfs2_sys_init(void)
 {
 	gfs2_sys_margs = NULL;
 	spin_lock_init(&gfs2_sys_margs_lock);
-	kobject_set_name(&gfs2_kset.kobj, "gfs2");
-	gfs2_kset.kobj.kset = fs_kset;
-	return kset_register(&gfs2_kset);
+	gfs2_kset = kset_create_and_register("gfs2", NULL, NULL, fs_kset);
+	if (IS_ERR(gfs2_kset))
+		return PTR_ERR(gfs2_kset);
+	return 0;
 }
 
 void gfs2_sys_uninit(void)
 {
 	kfree(gfs2_sys_margs);
-	kset_unregister(&gfs2_kset);
+	kset_unregister(gfs2_kset);
 }
 
-- 
1.5.3.4

