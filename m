Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbYAYHd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbYAYHd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758099AbYAYHRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:17:31 -0500
Received: from ns.suse.de ([195.135.220.2]:52771 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759200AbYAYHR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:17:29 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 054/196] kset: convert gfs2 to use kset_create
Date: Thu, 24 Jan 2008 23:09:52 -0800
Message-Id: <1201245134-4876-54-git-send-email-gregkh@suse.de>
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
 fs/gfs2/sys.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index a0bdc4a..44cfaae 100644
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
-	gfs2_kset.kobj.parent = fs_kobj;
-	return kset_register(&gfs2_kset);
+	gfs2_kset = kset_create_and_add("gfs2", NULL, fs_kobj);
+	if (!gfs2_kset)
+		return -ENOMEM;
+	return 0;
 }
 
 void gfs2_sys_uninit(void)
 {
 	kfree(gfs2_sys_margs);
-	kset_unregister(&gfs2_kset);
+	kset_unregister(gfs2_kset);
 }
 
-- 
1.5.3.8

