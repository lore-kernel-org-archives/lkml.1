Return-Path: <linux-kernel-owner+w=401wt.eu-S1762533AbXKCAE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762533AbXKCAE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760835AbXKCAA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:00:59 -0400
Received: from ns.suse.de ([195.135.220.2]:41103 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761861AbXKCAA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:00:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/54] kset: convert dlm to use kset_create
Date: Fri,  2 Nov 2007 16:58:51 -0700
Message-Id: <1194047972-9850-13-git-send-email-gregkh@suse.de>
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
 fs/dlm/lockspace.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 18e4a17..28c3cb4 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -166,7 +166,7 @@ static struct kobj_type dlm_ktype = {
 	.release       = lockspace_kobj_release,
 };
 
-static struct kset dlm_kset;
+static struct kset *dlm_kset;
 
 static int kobject_setup(struct dlm_ls *ls)
 {
@@ -180,7 +180,7 @@ static int kobject_setup(struct dlm_ls *ls)
 	if (error)
 		return error;
 
-	ls->ls_kobj.kset = &dlm_kset;
+	ls->ls_kobj.kset = dlm_kset;
 	ls->ls_kobj.ktype = &dlm_ktype;
 	return 0;
 }
@@ -225,17 +225,19 @@ int dlm_lockspace_init(void)
 	INIT_LIST_HEAD(&lslist);
 	spin_lock_init(&lslist_lock);
 
-	kobject_set_name(&dlm_kset.kobj, "dlm");
-	dlm_kset.kobj.kset = &kernel_subsys;
-	error = kset_register(&dlm_kset);
-	if (error)
-		printk("dlm_lockspace_init: cannot register kset %d\n", error);
-	return error;
+	dlm_kset = kset_create_and_register("dlm", NULL, NULL, &kernel_subsys);
+	if (IS_ERR(dlm_kset)) {
+		error = PTR_ERR(dlm_kset);
+		printk(KERN_WARNING "%s: can not create kset %d\n",
+		       __FUNCTION__, error);
+		return error;
+	}
+	return 0;
 }
 
 void dlm_lockspace_exit(void)
 {
-	kset_unregister(&dlm_kset);
+	kset_unregister(dlm_kset);
 }
 
 static int dlm_scand(void *data)
-- 
1.5.3.4

