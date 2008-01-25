Return-Path: <linux-kernel-owner+w=401wt.eu-S1763543AbYAYHzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763543AbYAYHzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:55:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760390AbYAYHgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:36:40 -0500
Received: from ns2.suse.de ([195.135.220.15]:50030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762021AbYAYHgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:36:38 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Thibaut VARENE <varenet@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@parisc-linux.org>
Subject: [PATCH 101/196] kobject: convert parisc/pdc_stable to use kobject_create
Date: Thu, 24 Jan 2008 23:32:10 -0800
Message-Id: <1201246425-5058-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a kset for this simple directory is an overkill.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Thibaut VARENE <varenet@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/parisc/pdc_stable.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/parisc/pdc_stable.c b/drivers/parisc/pdc_stable.c
index ef1a353..880b10b 100644
--- a/drivers/parisc/pdc_stable.c
+++ b/drivers/parisc/pdc_stable.c
@@ -960,7 +960,7 @@ static struct attribute_group pdcs_attr_group = {
 	.attrs = pdcs_subsys_attrs,
 };
 
-static struct kset *stable_kset;
+static struct kobject *stable_kobj;
 static struct kset *paths_kset;
 
 /**
@@ -1058,18 +1058,18 @@ pdc_stable_init(void)
 	/* the actual result is 16 bits away */
 	pdcs_osid = (u16)(result >> 16);
 
-	/* For now we'll register the stable kset within this driver */
-	stable_kset = kset_create_and_add("stable", NULL, firmware_kobj);
-	if (!stable_kset) {
+	/* For now we'll register the directory at /sys/firmware/stable */
+	stable_kobj = kobject_create_and_add("stable", firmware_kobj);
+	if (!stable_kobj) {
 		rc = -ENOMEM;
 		goto fail_firmreg;
 	}
 
 	/* Don't forget the root entries */
-	error = sysfs_create_group(&stable_kset->kobj, pdcs_attr_group);
+	error = sysfs_create_group(stable_kobj, pdcs_attr_group);
 
 	/* register the paths kset as a child of the stable kset */
-	paths_kset = kset_create_and_add("paths", NULL, &stable_kset->kobj);
+	paths_kset = kset_create_and_add("paths", NULL, stable_kobj);
 	if (!paths_kset) {
 		rc = -ENOMEM;
 		goto fail_ksetreg;
@@ -1086,7 +1086,7 @@ fail_pdcsreg:
 	kset_unregister(paths_kset);
 	
 fail_ksetreg:
-	kset_unregister(stable_kset);
+	kobject_unregister(stable_kobj);
 	
 fail_firmreg:
 	printk(KERN_INFO PDCS_PREFIX " bailing out\n");
@@ -1098,7 +1098,7 @@ pdc_stable_exit(void)
 {
 	pdcs_unregister_pathentries();
 	kset_unregister(paths_kset);
-	kset_unregister(stable_kset);
+	kobject_unregister(stable_kobj);
 }
 
 
-- 
1.5.3.8

