Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab0CBXeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:34:23 -0500
Received: from kroah.org ([198.145.64.141]:38661 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab0CBX3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:41 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 45/62] sysfs: Use sysfs_attr_init and sysfs_bin_attr_init on dynamic attributes
Date: Tue,  2 Mar 2010 15:28:44 -0800
Message-Id: <1267572541-410-45-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

These are the non-static sysfs attributes that exist on
my test machine.  Fix them to use sysfs_attr_init or
sysfs_bin_attr_init as appropriate.   It simply requires
making a sysfs attribute present to see this.  So this
is a little bit tedious but otherwise not too bad.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    1 +
 drivers/acpi/system.c            |    2 ++
 drivers/pci/pci-sysfs.c          |    5 +++++
 kernel/params.c                  |    1 +
 4 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a8aacd4..28cba46 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2044,6 +2044,7 @@ static __init void mce_init_banks(void)
 		struct mce_bank *b = &mce_banks[i];
 		struct sysdev_attribute *a = &b->attr;
 
+		sysfs_attr_init(&a->attr);
 		a->attr.name	= b->attrname;
 		snprintf(b->attrname, ATTR_LEN, "bank%d", i);
 
diff --git a/drivers/acpi/system.c b/drivers/acpi/system.c
index a206a12..743f244 100644
--- a/drivers/acpi/system.c
+++ b/drivers/acpi/system.c
@@ -101,6 +101,7 @@ static void acpi_table_attr_init(struct acpi_table_attr *table_attr,
 	struct acpi_table_header *header = NULL;
 	struct acpi_table_attr *attr = NULL;
 
+	sysfs_attr_init(&table_attr->attr.attr);
 	if (table_header->signature[0] != '\0')
 		memcpy(table_attr->name, table_header->signature,
 			ACPI_NAME_SIZE);
@@ -475,6 +476,7 @@ void acpi_irq_stats_init(void)
 			goto fail;
 		strncpy(name, buffer, strlen(buffer) + 1);
 
+		sysfs_attr_init(&counter_attrs[i].attr);
 		counter_attrs[i].attr.name = name;
 		counter_attrs[i].attr.mode = 0644;
 		counter_attrs[i].show = counter_show;
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 807224e..9fa183c 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -642,6 +642,7 @@ void pci_create_legacy_files(struct pci_bus *b)
 	if (!b->legacy_io)
 		goto kzalloc_err;
 
+	sysfs_bin_attr_init(&b->legacy_io);
 	b->legacy_io->attr.name = "legacy_io";
 	b->legacy_io->size = 0xffff;
 	b->legacy_io->attr.mode = S_IRUSR | S_IWUSR;
@@ -654,6 +655,7 @@ void pci_create_legacy_files(struct pci_bus *b)
 		goto legacy_io_err;
 
 	/* Allocated above after the legacy_io struct */
+	sysfs_bin_attr_init(&b->legacy_mem);
 	b->legacy_mem = b->legacy_io + 1;
 	b->legacy_mem->attr.name = "legacy_mem";
 	b->legacy_mem->size = 1024*1024;
@@ -800,6 +802,7 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 	if (res_attr) {
 		char *res_attr_name = (char *)(res_attr + 1);
 
+		sysfs_bin_attr_init(res_attr);
 		if (write_combine) {
 			pdev->res_attr_wc[num] = res_attr;
 			sprintf(res_attr_name, "resource%d_wc", num);
@@ -972,6 +975,7 @@ static int pci_create_capabilities_sysfs(struct pci_dev *dev)
 		if (!attr)
 			return -ENOMEM;
 
+		sysfs_bin_attr_init(attr);
 		attr->size = dev->vpd->len;
 		attr->attr.name = "vpd";
 		attr->attr.mode = S_IRUSR | S_IWUSR;
@@ -1038,6 +1042,7 @@ int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
 			retval = -ENOMEM;
 			goto err_resource_files;
 		}
+		sysfs_bin_attr_init(attr);
 		attr->size = rom_size;
 		attr->attr.name = "rom";
 		attr->attr.mode = S_IRUSR;
diff --git a/kernel/params.c b/kernel/params.c
index 4e27762..a60ebed 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -517,6 +517,7 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
 	new->grp.attrs = attrs;
 
 	/* Tack new one on the end. */
+	sysfs_attr_init(&new->attrs[num].mattr.attr);
 	new->attrs[num].param = kp;
 	new->attrs[num].mattr.show = param_attr_show;
 	new->attrs[num].mattr.store = param_attr_store;
-- 
1.7.0.1

