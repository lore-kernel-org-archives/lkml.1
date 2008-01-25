Return-Path: <linux-kernel-owner+w=401wt.eu-S1761685AbYAYHd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbYAYHd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758675AbYAYHRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:17:39 -0500
Received: from ns2.suse.de ([195.135.220.15]:47622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757038AbYAYHRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:17:37 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 056/196] kset: convert dlm to use kset_create
Date: Thu, 24 Jan 2008 23:09:54 -0800
Message-Id: <1201245134-4876-56-git-send-email-gregkh@suse.de>
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
 fs/dlm/lockspace.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 18e4a17..83a9c4d 100644
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
@@ -218,24 +218,22 @@ static int do_uevent(struct dlm_ls *ls, int in)
 
 int dlm_lockspace_init(void)
 {
-	int error;
-
 	ls_count = 0;
 	mutex_init(&ls_lock);
 	INIT_LIST_HEAD(&lslist);
 	spin_lock_init(&lslist_lock);
 
-	kobject_set_name(&dlm_kset.kobj, "dlm");
-	dlm_kset.kobj.kset = &kernel_subsys;
-	error = kset_register(&dlm_kset);
-	if (error)
-		printk("dlm_lockspace_init: cannot register kset %d\n", error);
-	return error;
+	dlm_kset = kset_create_and_add("dlm", NULL, &kernel_subsys.kobj);
+	if (!dlm_kset) {
+		printk(KERN_WARNING "%s: can not create kset\n", __FUNCTION__);
+		return -ENOMEM;
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
1.5.3.8

