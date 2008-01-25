Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbYAYHy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbYAYHy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761975AbYAYHg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:36:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761795AbYAYHg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:36:27 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       John Rose <johnrose@austin.ibm.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: [PATCH 098/196] kobject: clean up rpadlpar horrid sysfs abuse
Date: Thu, 24 Jan 2008 23:32:07 -0800
Message-Id: <1201246425-5058-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rpadlpar pci hotplug driver was doing some pretty bad stuff with the
sysfs files.  This cleans up the logic to be sane and gets rid of the
gratuitous kset that is not needed for a simple directory like this.

Note, this patch is not even build tested, let alone run-time tested.
Someone with access to this hardware and can test would be greatly
appreciated.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: John Rose <johnrose@austin.ibm.com>
Cc: Badari Pulavarty <pbadari@gmail.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/hotplug/rpadlpar_sysfs.c |  112 +++++++++++++---------------------
 1 files changed, 43 insertions(+), 69 deletions(-)

diff --git a/drivers/pci/hotplug/rpadlpar_sysfs.c b/drivers/pci/hotplug/rpadlpar_sysfs.c
index 5c3ddb6..9cde367 100644
--- a/drivers/pci/hotplug/rpadlpar_sysfs.c
+++ b/drivers/pci/hotplug/rpadlpar_sysfs.c
@@ -23,44 +23,13 @@
 
 #define MAX_DRC_NAME_LEN 64
 
-/* Store return code of dlpar operation in attribute struct */
-struct dlpar_io_attr {
-	int rc;
-	struct attribute attr;
-	ssize_t (*store)(struct dlpar_io_attr *dlpar_attr, const char *buf,
-		size_t nbytes);
-};
 
-/* Common show callback for all attrs, display the return code
- * of the dlpar op */
-static ssize_t
-dlpar_attr_show(struct kobject * kobj, struct attribute * attr, char * buf)
-{
-	struct dlpar_io_attr *dlpar_attr = container_of(attr,
-						struct dlpar_io_attr, attr);
-	return sprintf(buf, "%d\n", dlpar_attr->rc);
-}
-
-static ssize_t
-dlpar_attr_store(struct kobject * kobj, struct attribute * attr,
-		 const char *buf, size_t nbytes)
-{
-	struct dlpar_io_attr *dlpar_attr = container_of(attr,
-						struct dlpar_io_attr, attr);
-	return dlpar_attr->store ?
-		dlpar_attr->store(dlpar_attr, buf, nbytes) : -EIO;
-}
-
-static struct sysfs_ops dlpar_attr_sysfs_ops = {
-	.show = dlpar_attr_show,
-	.store = dlpar_attr_store,
-};
-
-static ssize_t add_slot_store(struct dlpar_io_attr *dlpar_attr,
-				const char *buf, size_t nbytes)
+static ssize_t add_slot_store(struct kobject *kobj, struct kobj_attribute *attr,
+			      const char *buf, size_t nbytes)
 {
 	char drc_name[MAX_DRC_NAME_LEN];
 	char *end;
+	int rc;
 
 	if (nbytes >= MAX_DRC_NAME_LEN)
 		return 0;
@@ -72,15 +41,25 @@ static ssize_t add_slot_store(struct dlpar_io_attr *dlpar_attr,
 		end = &drc_name[nbytes];
 	*end = '\0';
 
-	dlpar_attr->rc = dlpar_add_slot(drc_name);
+	rc = dlpar_add_slot(drc_name);
+	if (rc)
+		return rc;
 
 	return nbytes;
 }
 
-static ssize_t remove_slot_store(struct dlpar_io_attr *dlpar_attr,
-		 		const char *buf, size_t nbytes)
+static ssize_t add_slot_show(struct kobject *kobj,
+			     struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0\n");
+}
+
+static ssize_t remove_slot_store(struct kobject *kobj,
+				 struct kobj_attribute *attr,
+				 const char *buf, size_t nbytes)
 {
 	char drc_name[MAX_DRC_NAME_LEN];
+	int rc;
 	char *end;
 
 	if (nbytes >= MAX_DRC_NAME_LEN)
@@ -93,22 +72,24 @@ static ssize_t remove_slot_store(struct dlpar_io_attr *dlpar_attr,
 		end = &drc_name[nbytes];
 	*end = '\0';
 
-	dlpar_attr->rc = dlpar_remove_slot(drc_name);
+	rc = dlpar_remove_slot(drc_name);
+	if (rc)
+		return rc;
 
 	return nbytes;
 }
 
-static struct dlpar_io_attr add_slot_attr = {
-	.rc = 0,
-	.attr = { .name = ADD_SLOT_ATTR_NAME, .mode = 0644, },
-	.store = add_slot_store,
-};
+static ssize_t remove_slot_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0\n");
+}
 
-static struct dlpar_io_attr remove_slot_attr = {
-	.rc = 0,
-	.attr = { .name = REMOVE_SLOT_ATTR_NAME, .mode = 0644},
-	.store = remove_slot_store,
-};
+static struct kobj_attribute add_slot_attr =
+	__ATTR(ADD_SLOT_ATTR_NAME, 0644, add_slot_show, add_slot_store);
+
+static struct kobj_attribute remove_slot_attr =
+	__ATTR(REMOVE_SLOT_ATTR_NAME, 0644, remove_slot_show, remove_slot_store);
 
 static struct attribute *default_attrs[] = {
 	&add_slot_attr.attr,
@@ -116,36 +97,29 @@ static struct attribute *default_attrs[] = {
 	NULL,
 };
 
-static void dlpar_io_release(struct kobject *kobj)
-{
-	/* noop */
-	return;
-}
-
-struct kobj_type ktype_dlpar_io = {
-	.release = dlpar_io_release,
-	.sysfs_ops = &dlpar_attr_sysfs_ops,
-	.default_attrs = default_attrs,
+static struct attribute_group dlpar_attr_group = {
+	.attrs = default_attrs,
 };
 
-struct kset dlpar_io_kset = {
-	.kobj = {.ktype = &ktype_dlpar_io,
-		 .parent = &pci_hotplug_slots_kset->kobj},
-};
+static struct kobject *dlpar_kobj;
 
 int dlpar_sysfs_init(void)
 {
-	kobject_set_name(&dlpar_io_kset.kobj, DLPAR_KOBJ_NAME);
-	if (kset_register(&dlpar_io_kset)) {
-		printk(KERN_ERR "rpadlpar_io: cannot register kset for %s\n",
-				kobject_name(&dlpar_io_kset.kobj));
+	int error;
+
+	dlpar_kobj = kobject_create_and_add(DLPAR_KOBJ_NAME,
+					    &pci_hotplug_slots_kset->kobj);
+	if (!dlpar_kobj)
 		return -EINVAL;
-	}
 
-	return 0;
+	error = sysfs_create_group(dlpar_kobj, &dlpar_attr_group);
+	if (error)
+		kobject_unregister(dlpar_kobj);
+	return error;
 }
 
 void dlpar_sysfs_exit(void)
 {
-	kset_unregister(&dlpar_io_kset);
+	sysfs_remove_group(dlpar_kobj, &dlpar_attr_group);
+	kobject_unregister(dlpar_kobj);
 }
-- 
1.5.3.8

