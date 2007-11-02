Return-Path: <linux-kernel-owner+w=401wt.eu-S1763804AbXKCAQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763804AbXKCAQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762159AbXKCAD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:03:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:41240 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762180AbXKCADZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:03:25 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Thibaut VARENE <varenet@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@parisc-linux.org>
Subject: [PATCH 48/54] kset: convert parisc/pdc_stable.c to use kset_create
Date: Fri,  2 Nov 2007 16:59:26 -0700
Message-Id: <1194047972-9850-48-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically create the kset instead of declaring it statically.
This makes the kobject attributes now work properly that I broke in the
previous patch.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Thibaut VARENE <varenet@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/parisc/pdc_stable.c |   42 ++++++++++++++++++++++++------------------
 1 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/parisc/pdc_stable.c b/drivers/parisc/pdc_stable.c
index e1b9cba..3d71fea 100644
--- a/drivers/parisc/pdc_stable.c
+++ b/drivers/parisc/pdc_stable.c
@@ -960,8 +960,8 @@ static struct attribute_group pdcs_attr_group = {
 	.attrs = pdcs_subsys_attrs,
 };
 
-static decl_subsys(paths, NULL);
-static decl_subsys(stable, NULL);
+static struct kset *stable_kset;
+static struct kset *paths_kset;
 
 /**
  * pdcs_register_pathentries - Prepares path entries kobjects for sysfs usage.
@@ -993,7 +993,7 @@ pdcs_register_pathentries(void)
 
 		if ((err = kobject_set_name(&entry->kobj, "%s", entry->name)))
 			return err;
-		entry->kobj.kset = &paths_subsys;
+		entry->kobj.kset = paths_kset;
 		entry->kobj.ktype = &ktype_pdcspath;
 		if ((err = kobject_register(&entry->kobj)))
 			return err;
@@ -1058,19 +1058,26 @@ pdc_stable_init(void)
 	/* the actual result is 16 bits away */
 	pdcs_osid = (u16)(result >> 16);
 
-	/* For now we'll register the stable subsys within this driver */
-	if ((rc = firmware_register(&stable_subsys)))
+	/* For now we'll register the stable kset within this driver */
+	stable_kset = kset_create_and_register("stable", NULL, NULL,
+					       firmware_kset);
+	if (IS_ERR(stable_kset)) {
+		rc = PTR_ERR(stable_kset);
 		goto fail_firmreg;
+	}
 
 	/* Don't forget the root entries */
-	error = sysfs_create_group(&stable_subsys.kobj, pdcs_attr_group);
-
-	/* register the paths subsys as a subsystem of stable subsys */
-	paths_subsys.kobj.kset = &stable_subsys;
-	if ((rc = subsystem_register(&paths_subsys)))
-		goto fail_subsysreg;
+	error = sysfs_create_group(&stable_kset->kobj, pdcs_attr_group);
+
+	/* register the paths kset as a child of the stable kset */
+	paths_kset = kset_create_and_register("paths", NULL, NULL,
+					      stable_kset);
+	if (IS_ERR(paths_kset)) {
+		rc = PTR_ERR(paths_kset);
+		goto fail_ksetreg;
+	}
 
-	/* now we create all "files" for the paths subsys */
+	/* now we create all "files" for the paths kset */
 	if ((rc = pdcs_register_pathentries()))
 		goto fail_pdcsreg;
 
@@ -1078,10 +1085,10 @@ pdc_stable_init(void)
 	
 fail_pdcsreg:
 	pdcs_unregister_pathentries();
-	subsystem_unregister(&paths_subsys);
+	kset_unregister(paths_kset);
 	
-fail_subsysreg:
-	firmware_unregister(&stable_subsys);
+fail_ksetreg:
+	kset_unregister(stable_kset);
 	
 fail_firmreg:
 	printk(KERN_INFO PDCS_PREFIX " bailing out\n");
@@ -1092,9 +1099,8 @@ static void __exit
 pdc_stable_exit(void)
 {
 	pdcs_unregister_pathentries();
-	subsystem_unregister(&paths_subsys);
-
-	firmware_unregister(&stable_subsys);
+	kset_unregister(paths_kset);
+	kset_unregister(stable_kset);
 }
 
 
-- 
1.5.3.4

