Return-Path: <linux-kernel-owner+w=401wt.eu-S1765451AbYAYIRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765451AbYAYIRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759138AbYAYIAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:47 -0500
Received: from mx1.suse.de ([195.135.220.2]:59447 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763220AbYAYH7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 114/196] Kobject: change drivers/edac to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:23 -0800
Message-Id: <1201246425-5058-35-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Acked-by: Doug Thompson <dougthompson@xmission.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/edac/edac_device_sysfs.c |   39 +++++++++++--------------------------
 drivers/edac/edac_mc_sysfs.c     |   28 ++++++++------------------
 drivers/edac/edac_pci_sysfs.c    |   29 +++++++--------------------
 3 files changed, 29 insertions(+), 67 deletions(-)

diff --git a/drivers/edac/edac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c
index 70b837f..10e5b19 100644
--- a/drivers/edac/edac_device_sysfs.c
+++ b/drivers/edac/edac_device_sysfs.c
@@ -246,16 +246,6 @@ int edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)
 
 	/* Init the devices's kobject */
 	memset(&edac_dev->kobj, 0, sizeof(struct kobject));
-	edac_dev->kobj.ktype = &ktype_device_ctrl;
-
-	/* set this new device under the edac_class kobject */
-	edac_dev->kobj.parent = &edac_class->kset.kobj;
-
-	/* generate sysfs "..../edac/<name>"   */
-	debugf4("%s() set name of kobject to: %s\n", __func__, edac_dev->name);
-	err = kobject_set_name(&edac_dev->kobj, "%s", edac_dev->name);
-	if (err)
-		goto err_out;
 
 	/* Record which module 'owns' this control structure
 	 * and bump the ref count of the module
@@ -268,12 +258,15 @@ int edac_device_register_sysfs_main_kobj(struct edac_device_ctl_info *edac_dev)
 	}
 
 	/* register */
-	err = kobject_register(&edac_dev->kobj);
+	err = kobject_init_and_add(&edac_dev->kobj, &ktype_device_ctrl,
+				   &edac_class->kset.kobj,
+				   "%s", edac_dev->name);
 	if (err) {
 		debugf1("%s()Failed to register '.../edac/%s'\n",
 			__func__, edac_dev->name);
 		goto err_kobj_reg;
 	}
+	kobject_uevent(&edac_dev->kobj, KOBJ_ADD);
 
 	/* At this point, to 'free' the control struct,
 	 * edac_device_unregister_sysfs_main_kobj() must be used
@@ -533,12 +526,6 @@ static int edac_device_create_block(struct edac_device_ctl_info *edac_dev,
 
 	/* init this block's kobject */
 	memset(&block->kobj, 0, sizeof(struct kobject));
-	block->kobj.parent = &instance->kobj;
-	block->kobj.ktype = &ktype_block_ctrl;
-
-	err = kobject_set_name(&block->kobj, "%s", block->name);
-	if (err)
-		return err;
 
 	/* bump the main kobject's reference count for this controller
 	 * and this instance is dependant on the main
@@ -550,7 +537,9 @@ static int edac_device_create_block(struct edac_device_ctl_info *edac_dev,
 	}
 
 	/* Add this block's kobject */
-	err = kobject_register(&block->kobj);
+	err = kobject_init_and_add(&block->kobj, &ktype_block_ctrl,
+				   &instance->kobj,
+				   "%s", block->name);
 	if (err) {
 		debugf1("%s() Failed to register instance '%s'\n",
 			__func__, block->name);
@@ -579,6 +568,7 @@ static int edac_device_create_block(struct edac_device_ctl_info *edac_dev,
 				goto err_on_attrib;
 		}
 	}
+	kobject_uevent(&block->kobj, KOBJ_ADD);
 
 	return 0;
 
@@ -637,15 +627,8 @@ static int edac_device_create_instance(struct edac_device_ctl_info *edac_dev,
 	/* Init the instance's kobject */
 	memset(&instance->kobj, 0, sizeof(struct kobject));
 
-	/* set this new device under the edac_device main kobject */
-	instance->kobj.parent = &edac_dev->kobj;
-	instance->kobj.ktype = &ktype_instance_ctrl;
 	instance->ctl = edac_dev;
 
-	err = kobject_set_name(&instance->kobj, "%s", instance->name);
-	if (err)
-		goto err_out;
-
 	/* bump the main kobject's reference count for this controller
 	 * and this instance is dependant on the main
 	 */
@@ -655,8 +638,9 @@ static int edac_device_create_instance(struct edac_device_ctl_info *edac_dev,
 		goto err_out;
 	}
 
-	/* Formally register this instance's kobject */
-	err = kobject_register(&instance->kobj);
+	/* Formally register this instance's kobject under the edac_device */
+	err = kobject_init_and_add(&instance->kobj, &ktype_instance_ctrl,
+				   &edac_dev->kobj, "%s", instance->name);
 	if (err != 0) {
 		debugf2("%s() Failed to register instance '%s'\n",
 			__func__, instance->name);
@@ -679,6 +663,7 @@ static int edac_device_create_instance(struct edac_device_ctl_info *edac_dev,
 			goto err_release_instance_kobj;
 		}
 	}
+	kobject_uevent(&instance->kobj, KOBJ_ADD);
 
 	debugf4("%s() Registered instance %d '%s' kobject\n",
 		__func__, idx, instance->name);
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 905fcd7..45b1d36 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -380,13 +380,6 @@ static int edac_create_csrow_object(struct mem_ctl_info *mci,
 	/* generate ..../edac/mc/mc<id>/csrow<index>   */
 	memset(&csrow->kobj, 0, sizeof(csrow->kobj));
 	csrow->mci = mci;	/* include container up link */
-	csrow->kobj.parent = kobj_mci;
-	csrow->kobj.ktype = &ktype_csrow;
-
-	/* name this instance of csrow<id> */
-	err = kobject_set_name(&csrow->kobj, "csrow%d", index);
-	if (err)
-		goto err_out;
 
 	/* bump the mci instance's kobject's ref count */
 	kobj = kobject_get(&mci->edac_mci_kobj);
@@ -396,7 +389,8 @@ static int edac_create_csrow_object(struct mem_ctl_info *mci,
 	}
 
 	/* Instanstiate the csrow object */
-	err = kobject_register(&csrow->kobj);
+	err = kobject_init_and_add(&csrow->kobj, &ktype_csrow, kobj_mci,
+				   "csrow%d", index);
 	if (err)
 		goto err_release_top_kobj;
 
@@ -416,7 +410,7 @@ static int edac_create_csrow_object(struct mem_ctl_info *mci,
 			goto err_out;
 		}
 	}
-
+	kobject_uevent(&csrow->kobj, KOBJ_ADD);
 	return 0;
 
 	/* error unwind stack */
@@ -764,15 +758,6 @@ int edac_mc_register_sysfs_main_kobj(struct mem_ctl_info *mci)
 	/* Init the mci's kobject */
 	memset(kobj_mci, 0, sizeof(*kobj_mci));
 
-	/* this instance become part of the mc_kset */
-	kobj_mci->kset = &mc_kset;
-	kobj_mci->ktype = &ktype_mci;
-
-	/* set the name of the mc<id> object */
-	err = kobject_set_name(kobj_mci, "mc%d", mci->mc_idx);
-	if (err)
-		goto fail_out;
-
 	/* Record which module 'owns' this control structure
 	 * and bump the ref count of the module
 	 */
@@ -784,13 +769,18 @@ int edac_mc_register_sysfs_main_kobj(struct mem_ctl_info *mci)
 		goto fail_out;
 	}
 
+	/* this instance become part of the mc_kset */
+	kobj_mci->kset = &mc_kset;
+
 	/* register the mc<id> kobject to the mc_kset */
-	err = kobject_register(kobj_mci);
+	err = kobject_init_and_add(kobj_mci, &ktype_mci, NULL,
+				   "mc%d", mci->mc_idx);
 	if (err) {
 		debugf1("%s()Failed to register '.../edac/mc%d'\n",
 			__func__, mci->mc_idx);
 		goto kobj_reg_fail;
 	}
+	kobject_uevent(kobj_mci, KOBJ_ADD);
 
 	/* At this point, to 'free' the control struct,
 	 * edac_mc_unregister_sysfs_main_kobj() must be used
diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index 69f5ddd..834eaa9 100644
--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -162,14 +162,6 @@ static int edac_pci_create_instance_kobj(struct edac_pci_ctl_info *pci, int idx)
 
 	debugf0("%s()\n", __func__);
 
-	/* Set the parent and the instance's ktype */
-	pci->kobj.parent = &edac_pci_top_main_kobj;
-	pci->kobj.ktype = &ktype_pci_instance;
-
-	err = kobject_set_name(&pci->kobj, "pci%d", idx);
-	if (err)
-		return err;
-
 	/* First bump the ref count on the top main kobj, which will
 	 * track the number of PCI instances we have, and thus nest
 	 * properly on keeping the module loaded
@@ -181,7 +173,8 @@ static int edac_pci_create_instance_kobj(struct edac_pci_ctl_info *pci, int idx)
 	}
 
 	/* And now register this new kobject under the main kobj */
-	err = kobject_register(&pci->kobj);
+	err = kobject_init_and_add(&pci->kobj, &ktype_pci_instance,
+				   &edac_pci_top_main_kobj, "pci%d", idx);
 	if (err != 0) {
 		debugf2("%s() failed to register instance pci%d\n",
 			__func__, idx);
@@ -189,6 +182,7 @@ static int edac_pci_create_instance_kobj(struct edac_pci_ctl_info *pci, int idx)
 		goto error_out;
 	}
 
+	kobject_uevent(&pci->kobj, KOBJ_ADD);
 	debugf1("%s() Register instance 'pci%d' kobject\n", __func__, idx);
 
 	return 0;
@@ -364,14 +358,6 @@ int edac_pci_main_kobj_setup(void)
 		goto decrement_count_fail;
 	}
 
-	/* Need the kobject hook ups, and name setting */
-	edac_pci_top_main_kobj.ktype = &ktype_edac_pci_main_kobj;
-	edac_pci_top_main_kobj.parent = &edac_class->kset.kobj;
-
-	err = kobject_set_name(&edac_pci_top_main_kobj, "pci");
-	if (err)
-		goto decrement_count_fail;
-
 	/* Bump the reference count on this module to ensure the
 	 * modules isn't unloaded until we deconstruct the top
 	 * level main kobj for EDAC PCI
@@ -383,23 +369,24 @@ int edac_pci_main_kobj_setup(void)
 	}
 
 	/* Instanstiate the pci object */
-	/* FIXME: maybe new sysdev_create_subdir() */
-	err = kobject_register(&edac_pci_top_main_kobj);
+	err = kobject_init_and_add(&edac_pci_top_main_kobj, &ktype_edac_pci_main_kobj,
+				   &edac_class->kset.kobj, "pci");
 	if (err) {
 		debugf1("Failed to register '.../edac/pci'\n");
-		goto kobject_register_fail;
+		goto kobject_init_and_add_fail;
 	}
 
 	/* At this point, to 'release' the top level kobject
 	 * for EDAC PCI, then edac_pci_main_kobj_teardown()
 	 * must be used, for resources to be cleaned up properly
 	 */
+	kobject_uevent(&edac_pci_top_main_kobj, KOBJ_ADD);
 	debugf1("Registered '.../edac/pci' kobject\n");
 
 	return 0;
 
 	/* Error unwind statck */
-kobject_register_fail:
+kobject_init_and_add_fail:
 	module_put(THIS_MODULE);
 
 decrement_count_fail:
-- 
1.5.3.8

