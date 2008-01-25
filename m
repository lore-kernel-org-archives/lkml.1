Return-Path: <linux-kernel-owner+w=401wt.eu-S1763081AbYAYHtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763081AbYAYHtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761653AbYAYHfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:35:45 -0500
Received: from mx1.suse.de ([195.135.220.2]:55167 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761377AbYAYHfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:35:41 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Thibaut VARENE <varenet@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@parisc-linux.org>
Subject: [PATCH 087/196] kset: convert parisc/pdc_stable.c to use kset_create
Date: Thu, 24 Jan 2008 23:31:56 -0800
Message-Id: <1201246425-5058-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
 drivers/parisc/pdc_stable.c |   38 +++++++++++++++++++++-----------------
 1 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/parisc/pdc_stable.c b/drivers/parisc/pdc_stable.c
index e1b9cba..4444834 100644
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
@@ -1058,19 +1058,24 @@ pdc_stable_init(void)
 	/* the actual result is 16 bits away */
 	pdcs_osid = (u16)(result >> 16);
 
-	/* For now we'll register the stable subsys within this driver */
-	if ((rc = firmware_register(&stable_subsys)))
+	/* For now we'll register the stable kset within this driver */
+	stable_kset = kset_create_and_add("stable", NULL, &firmware_kset->kobj);
+	if (!stable_kset) {
+		rc = -ENOMEM;
 		goto fail_firmreg;
+	}
 
 	/* Don't forget the root entries */
-	error = sysfs_create_group(&stable_subsys.kobj, pdcs_attr_group);
+	error = sysfs_create_group(&stable_kset->kobj, pdcs_attr_group);
 
-	/* register the paths subsys as a subsystem of stable subsys */
-	paths_subsys.kobj.kset = &stable_subsys;
-	if ((rc = subsystem_register(&paths_subsys)))
-		goto fail_subsysreg;
+	/* register the paths kset as a child of the stable kset */
+	paths_kset = kset_create_and_add("paths", NULL, &stable_kset->kobj);
+	if (!paths_kset) {
+		rc = -ENOMEM;
+		goto fail_ksetreg;
+	}
 
-	/* now we create all "files" for the paths subsys */
+	/* now we create all "files" for the paths kset */
 	if ((rc = pdcs_register_pathentries()))
 		goto fail_pdcsreg;
 
@@ -1078,10 +1083,10 @@ pdc_stable_init(void)
 	
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
@@ -1092,9 +1097,8 @@ static void __exit
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
1.5.3.8

