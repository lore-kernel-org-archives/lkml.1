Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZJTFux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZJTFux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 01:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbZJTFuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 01:50:52 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49381 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZJTFuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 01:50:51 -0400
Date: Mon, 19 Oct 2009 23:50:55 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH 3/3] Expose MSI-X interrupts through a dynamically
	generated sysfs directory
Message-ID: <20091020055055.GF29158@parisc-linux.org>
References: <20091020054740.GC29158@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020054740.GC29158@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Matthew Wilcox <willy@linux.intel.com>
Date: Mon, 19 Oct 2009 01:35:41 -0400
Subject: [PATCH 3/3] Expose MSI-X interrupts through a dynamically generated sysfs directory

Introduce the ability to dynamically generate the attributes (which are
then added to sysfs).  Add a user in the form of the PCI MSI code, which
was why I started on this in the first place.
---
 drivers/pci/msi.c     |   77 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/sysfs/group.c      |    7 ++++-
 include/linux/pci.h   |    2 +
 include/linux/sysfs.h |    9 ++++++
 4 files changed, 90 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index f9cf317..e0971e6 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -275,6 +275,9 @@ static void free_msi_irqs(struct pci_dev *dev)
 {
 	struct msi_desc *entry, *tmp;
 
+	if (dev->msix_dir.name)
+		sysfs_remove_group(&dev->dev.kobj, &dev->msix_dir);
+
 	list_for_each_entry(entry, &dev->msi_list, list) {
 		int i, nvec;
 		if (!entry->irq)
@@ -447,13 +450,12 @@ static void __iomem *msix_map_region(struct pci_dev *dev, unsigned pos,
 }
 
 static int msix_setup_entries(struct pci_dev *dev, unsigned pos,
-				void __iomem *base, struct msix_entry *entries,
-				int nvec)
+				void __iomem *base, struct msix_entry *entries)
 {
 	struct msi_desc *entry;
 	int i;
 
-	for (i = 0; i < nvec; i++) {
+	for (i = 0; i < dev->nr_irqs; i++) {
 		entry = alloc_msi_entry(dev);
 		if (!entry) {
 			if (!i)
@@ -495,6 +497,64 @@ static void msix_program_entries(struct pci_dev *dev,
 	}
 }
 
+struct pci_msix_attribute {
+	struct device_attribute da;
+	unsigned irq;
+	char name[8];	/* current max is 5: "2047\0" */
+};
+
+static ssize_t
+pci_msix_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct pci_msix_attribute *msix_attr;
+	msix_attr = container_of(attr, struct pci_msix_attribute, da);
+	return snprintf(buf, PAGE_SIZE, "%u\n", msix_attr->irq);
+}
+
+#define kobj_to_pci_dev(obj) to_pci_dev(container_of(obj, struct device, kobj))
+
+static int msix_populate(struct dentry *dentry, struct attribute_group *grp)
+{
+	struct pci_dev *pdev = container_of(grp, struct pci_dev, msix_dir);
+	unsigned i, nr_irqs = pdev->nr_irqs;
+	struct pci_msix_attribute *attr;
+	struct attribute **array;
+	struct msi_desc *desc;
+
+	array = kmalloc((nr_irqs + 1) * sizeof(void *), GFP_KERNEL);
+	if (!array)
+		return -ENOMEM;
+	attr = kmalloc(nr_irqs * sizeof(*attr), GFP_KERNEL);
+	if (!attr)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_irqs; i++)
+		array[i] = &attr[i].da.attr;
+	array[i] = NULL;
+	grp->attrs = array;
+
+	list_for_each_entry(desc, &pdev->msi_list, list) {
+		attr->irq = desc->irq;
+		snprintf(attr->name, sizeof(attr->name), "%u",
+						desc->msi_attrib.entry_nr);
+		attr->da.attr.name = (const char *)&attr->name;
+		attr->da.attr.mode = 0444;
+		attr->da.show = pci_msix_show;
+		attr++;
+	}
+
+	return sysfs_populate_group(dentry, grp);
+}
+
+static void msix_depopulate(struct dentry *dentry, struct attribute_group *grp)
+{
+	sysfs_depopulate_group(dentry, grp);
+
+	kfree(grp->attrs[0]);
+	kfree(grp->attrs);
+	grp->attrs = NULL;
+}
+
 /**
  * msix_capability_init - configure device's MSI-X capability
  * @dev: pointer to the pci_dev data structure of MSI-X device function
@@ -524,10 +584,19 @@ static int msix_capability_init(struct pci_dev *dev,
 	if (!base)
 		return -ENOMEM;
 
-	ret = msix_setup_entries(dev, pos, base, entries, nvec);
+	dev->nr_irqs = nvec;
+
+	dev->msix_dir.name = "irqs";
+	dev->msix_dir.populate = msix_populate;
+	dev->msix_dir.depopulate = msix_depopulate;
+	ret = sysfs_create_group(&dev->dev.kobj, &dev->msix_dir);
 	if (ret)
 		return ret;
 
+	ret = msix_setup_entries(dev, pos, base, entries);
+	if (ret)
+		goto error;
+
 	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
 	if (ret)
 		goto error;
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 37ac584..c97139f 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -102,6 +102,8 @@ static
 int group_populate(struct dentry *dentry, struct sysfs_dirent *sd)
 {
 	struct attribute_group *grp = sd->s_dir.data;
+	if (grp->populate)
+		return grp->populate(dentry, grp);
 	return sysfs_populate_group(dentry, grp);
 }
 
@@ -109,7 +111,10 @@ static
 void group_depopulate(struct dentry *dentry, struct sysfs_dirent *sd)
 {
 	struct attribute_group *grp = sd->s_dir.data;
-	sysfs_depopulate_group(dentry, grp);
+	if (grp->depopulate)
+		grp->depopulate(dentry, grp);
+	else
+		sysfs_depopulate_group(dentry, grp);
 }
 
 static void remove_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
diff --git a/include/linux/pci.h b/include/linux/pci.h
index f5c7cd3..47c7fc6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -291,6 +291,8 @@ struct pci_dev {
 	struct bin_attribute *res_attr_wc[DEVICE_COUNT_RESOURCE]; /* sysfs file for WC mapping of resources */
 #ifdef CONFIG_PCI_MSI
 	struct list_head msi_list;
+	struct attribute_group msix_dir;
+	unsigned short nr_irqs;
 #endif
 	struct pci_vpd *vpd;
 #ifdef CONFIG_PCI_IOV
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 9d68fed..cf9d200 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -19,6 +19,7 @@
 
 struct kobject;
 struct module;
+struct dentry;
 
 /* FIXME
  * The *owner field is no longer used.
@@ -36,6 +37,10 @@ struct attribute_group {
 	mode_t			(*is_visible)(struct kobject *,
 					      struct attribute *, int);
 	struct attribute	**attrs;
+	int			(*populate)(struct dentry *,
+						struct attribute_group *);
+	void			(*depopulate)(struct dentry *,
+						struct attribute_group *);
 };
 
 
@@ -115,6 +120,10 @@ int sysfs_update_group(struct kobject *kobj,
 		       const struct attribute_group *grp);
 void sysfs_remove_group(struct kobject *kobj,
 			const struct attribute_group *grp);
+int sysfs_populate_group(struct dentry *dentry,
+			const struct attribute_group *grp);
+void sysfs_depopulate_group(struct dentry *dentry,
+			const struct attribute_group *grp);
 int sysfs_add_file_to_group(struct kobject *kobj,
 			const struct attribute *attr, const char *group);
 void sysfs_remove_file_from_group(struct kobject *kobj,
-- 
1.6.3.3

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
