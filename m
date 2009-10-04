Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbZJDTpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbZJDTpR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 15:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757887AbZJDTpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 15:45:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862AbZJDTpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 15:45:09 -0400
Date: Sun, 4 Oct 2009 16:43:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, bluesmoke-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] edac: Create an unique instance for each kobj
Message-ID: <20091004164354.5ff55ea1@pedra.chehab.org>
In-Reply-To: <20090924192821.7fcffc80@pedra.chehab.org>
References: <20090924192821.7fcffc80@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code only works when there's just one memory
controller, since we need one kobj for each instance.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_core.h     |   21 ++++++++---
 drivers/edac/edac_mc_sysfs.c |   75 +++++++++++++++++++++++++++--------------
 2 files changed, 64 insertions(+), 32 deletions(-)

diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index d035ee9..f84da6e 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -341,23 +341,29 @@ struct csrow_info {
 };
 
 struct mcidev_sysfs_group {
-	const char *name;
-	struct mcidev_sysfs_attribute *mcidev_attr;
-	struct kobject kobj;
+	const char *name;				/* group name */
+	struct mcidev_sysfs_attribute *mcidev_attr;	/* group attributes */
+};
+
+struct mcidev_sysfs_group_kobj {
+	struct list_head list;		/* list for all instances within a mc */
+
+	struct kobject kobj;		/* kobj for the group */
 
+	struct mcidev_sysfs_group *grp;	/* group description table */
 	struct mem_ctl_info *mci;	/* the parent */
 };
 
-
 /* mcidev_sysfs_attribute structure
  *	used for driver sysfs attributes and in mem_ctl_info
  * 	sysfs top level entries
  */
 struct mcidev_sysfs_attribute {
+	/* It should use either attr or grp */
 	struct attribute attr;
+	struct mcidev_sysfs_group *grp;	/* Points to a group of attributes */
 
-	struct mcidev_sysfs_group *grp;
-
+	/* Ops for show/store values at the attribute - not used on group */
         ssize_t (*show)(struct mem_ctl_info *,char *);
         ssize_t (*store)(struct mem_ctl_info *, const char *,size_t);
 };
@@ -435,6 +441,9 @@ struct mem_ctl_info {
 	/* edac sysfs device control */
 	struct kobject edac_mci_kobj;
 
+	/* list for all grp instances within a mc */
+	struct list_head grp_kobj_list;
+
 	/* Additional top controller level attributes, but specified
 	 * by the low level driver.
 	 *
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 473246b..299547c 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -729,7 +729,7 @@ void edac_mc_unregister_sysfs_main_kobj(struct mem_ctl_info *mci)
 
 #define EDAC_DEVICE_SYMLINK	"device"
 
-#define grp_to_mci(k) (container_of(k, struct mcidev_sysfs_group, kobj)->mci)
+#define grp_to_mci(k) (container_of(k, struct mcidev_sysfs_group_kobj, kobj)->mci)
 
 /* MCI show/store functions for top most object */
 static ssize_t inst_grp_show(struct kobject *kobj, struct attribute *attr,
@@ -763,12 +763,12 @@ static ssize_t inst_grp_store(struct kobject *kobj, struct attribute *attr,
 /* No memory to release for this kobj */
 static void edac_inst_grp_release(struct kobject *kobj)
 {
-	struct mcidev_sysfs_group *grp;
+	struct mcidev_sysfs_group_kobj *grp;
 	struct mem_ctl_info *mci;
 
 	debugf1("%s()\n", __func__);
 
-	grp = container_of(kobj, struct mcidev_sysfs_group, kobj);
+	grp = container_of(kobj, struct mcidev_sysfs_group_kobj, kobj);
 	mci = grp->mci;
 
 	kobject_put(&mci->edac_mci_kobj);
@@ -803,22 +803,30 @@ static int edac_create_mci_instance_attributes(struct mem_ctl_info *mci,
 
 	while (sysfs_attrib) {
 		if (sysfs_attrib->grp) {
-			struct kobject *newkobj = &sysfs_attrib->grp->kobj;
+			struct mcidev_sysfs_group_kobj *grp_kobj;
+
+			grp_kobj = kzalloc(sizeof(*grp_kobj), GFP_KERNEL);
+			if (!grp_kobj)
+				return -ENOMEM;
+
+			list_add_tail(&grp_kobj->list, &mci->grp_kobj_list);
+
+			grp_kobj->grp = sysfs_attrib->grp;
+			grp_kobj->mci = mci;
 
 			debugf0("%s() grp %s, mci %p\n", __func__,
 				sysfs_attrib->grp->name, mci);
 
-			sysfs_attrib->grp->mci = mci;
-
-			err = kobject_init_and_add(newkobj, &ktype_inst_grp,
+			err = kobject_init_and_add(&grp_kobj->kobj,
+						&ktype_inst_grp,
 						&mci->edac_mci_kobj,
 						sysfs_attrib->grp->name);
 			if (err)
 				return err;
 
 			err = edac_create_mci_instance_attributes(mci,
-					sysfs_attrib->grp->mcidev_attr,
-					newkobj);
+					grp_kobj->grp->mcidev_attr,
+					&grp_kobj->kobj);
 
 			if (err)
 				return err;
@@ -844,25 +852,27 @@ static int edac_create_mci_instance_attributes(struct mem_ctl_info *mci,
  *	remove MC driver specific attributes at the topmost level
  *	directory of this mci instance.
  */
-static void edac_remove_mci_instance_attributes(
+static void edac_remove_mci_instance_attributes(struct mem_ctl_info *mci,
 				struct mcidev_sysfs_attribute *sysfs_attrib,
-				struct kobject *kobj)
+				struct kobject *kobj, int count)
 {
+	struct mcidev_sysfs_group_kobj *grp_kobj, *tmp;
+
 	debugf1("%s()\n", __func__);
 
-	/* loop if there are attributes and until we hit a NULL entry */
+	/*
+	 * loop if there are attributes and until we hit a NULL entry
+	 * Remove first all the atributes
+	 */
 	while (sysfs_attrib) {
 		if (sysfs_attrib->grp) {
-			struct kobject *newkobj = &sysfs_attrib->grp->kobj;
-
-			debugf0("%s() grp %s\n", __func__,
-				sysfs_attrib->grp->name);
-
-			edac_remove_mci_instance_attributes(
-				sysfs_attrib->grp->mcidev_attr, newkobj);
-
-			kobject_put(newkobj);
-		} else  if (sysfs_attrib->attr.name) {
+			list_for_each_entry(grp_kobj, &mci->grp_kobj_list,
+					    list)
+				if (grp_kobj->grp == sysfs_attrib->grp)
+					edac_remove_mci_instance_attributes(mci,
+						    grp_kobj->grp->mcidev_attr,
+						    &grp_kobj->kobj, count + 1);
+		} else if (sysfs_attrib->attr.name) {
 			debugf0("%s() file %s\n", __func__,
 				sysfs_attrib->attr.name);
 			sysfs_remove_file(kobj, &sysfs_attrib->attr);
@@ -870,6 +880,16 @@ static void edac_remove_mci_instance_attributes(
 			break;
 		sysfs_attrib++;
 	}
+
+	/*
+	 * Now that all attributes got removed, it is save to remove all groups
+	 */
+	if (!count)
+		list_for_each_entry_safe(grp_kobj, tmp, &mci->grp_kobj_list,
+					 list) {
+			debugf0("%s() grp %s\n", __func__, grp_kobj->grp->name);
+			kobject_put(&grp_kobj->kobj);
+		}
 }
 
 
@@ -890,6 +910,8 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 
 	debugf0("%s() idx=%d\n", __func__, mci->mc_idx);
 
+	INIT_LIST_HEAD(&mci->grp_kobj_list);
+
 	/* create a symlink for the device */
 	err = sysfs_create_link(kobj_mci, &mci->dev->kobj,
 				EDAC_DEVICE_SYMLINK);
@@ -939,8 +961,8 @@ fail1:
 	}
 
 	/* remove the mci instance's attributes, if any */
-	edac_remove_mci_instance_attributes(
-		mci->mc_driver_sysfs_attributes, &mci->edac_mci_kobj);
+	edac_remove_mci_instance_attributes(mci,
+		mci->mc_driver_sysfs_attributes, &mci->edac_mci_kobj, 0);
 
 	/* remove the symlink */
 	sysfs_remove_link(kobj_mci, EDAC_DEVICE_SYMLINK);
@@ -974,8 +996,9 @@ void edac_remove_sysfs_mci_device(struct mem_ctl_info *mci)
 	debugf0("%s()  remove_mci_instance\n", __func__);
 
 	/* remove this mci instance's attribtes */
-	edac_remove_mci_instance_attributes(mci->mc_driver_sysfs_attributes,
-					    &mci->edac_mci_kobj);
+	edac_remove_mci_instance_attributes(mci,
+					    mci->mc_driver_sysfs_attributes,
+					    &mci->edac_mci_kobj, 0);
 	debugf0("%s()  unregister this mci kobj\n", __func__);
 
 	/* unregister this instance's kobject *

-- 

Cheers,
Mauro
