Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab0BKXXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:23:11 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34064 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab0BKXXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:23:09 -0500
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       "Tejun Heo <tj@kernel.org> Neil Brown" <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] sysfs: Use sysfs_attr_init and sysfs_bin_attr_init on dynamic attributes
References: <19314.1869.847327.15190@notabene.brown>
	<2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com>
	<4B7217CF.2080702@kernel.org> <m1vde57c11.fsf@fess.ebiederm.org>
	<4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org>
	<20100210230544.GA678@suse.de> <m1ocjwwob1.fsf@fess.ebiederm.org>
	<4B73671E.2050105@kernel.org> <m1bpfvxt67.fsf_-_@fess.ebiederm.org>
	<m14olnxt3s.fsf_-_@fess.ebiederm.org>
	<m1ljezwean.fsf_-_@fess.ebiederm.org>
	<m1hbpnwe7i.fsf_-_@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 11 Feb 2010 15:23:05 -0800
In-Reply-To: <m1hbpnwe7i.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's message of "Thu\, 11 Feb 2010 15\:21\:53 -0800")
Message-ID: <m1d40bwe5i.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These are the non-static sysfs attributes that exist on
my test machine.  Fix them to use sysfs_attr_init or
sysfs_bin_attr_init as appropriate.   It simply requires
making a sysfs attribute present to see this.  So this
is a little bit tedious but otherwise not too bad.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
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
index d112829..a50fd08 100644
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
index c5df94e..6fbcbea 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -640,6 +640,7 @@ void pci_create_legacy_files(struct pci_bus *b)
 	if (!b->legacy_io)
 		goto kzalloc_err;
 
+	sysfs_bin_attr_init(&b->legacy_io);
 	b->legacy_io->attr.name = "legacy_io";
 	b->legacy_io->size = 0xffff;
 	b->legacy_io->attr.mode = S_IRUSR | S_IWUSR;
@@ -652,6 +653,7 @@ void pci_create_legacy_files(struct pci_bus *b)
 		goto legacy_io_err;
 
 	/* Allocated above after the legacy_io struct */
+	sysfs_bin_attr_init(&b->legacy_mem);
 	b->legacy_mem = b->legacy_io + 1;
 	b->legacy_mem->attr.name = "legacy_mem";
 	b->legacy_mem->size = 1024*1024;
@@ -798,6 +800,7 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 	if (res_attr) {
 		char *res_attr_name = (char *)(res_attr + 1);
 
+		sysfs_bin_attr_init(res_attr);
 		if (write_combine) {
 			pdev->res_attr_wc[num] = res_attr;
 			sprintf(res_attr_name, "resource%d_wc", num);
@@ -970,6 +973,7 @@ static int pci_create_capabilities_sysfs(struct pci_dev *dev)
 		if (!attr)
 			return -ENOMEM;
 
+		sysfs_bin_attr_init(attr);
 		attr->size = dev->vpd->len;
 		attr->attr.name = "vpd";
 		attr->attr.mode = S_IRUSR | S_IWUSR;
@@ -1036,6 +1040,7 @@ int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
 			retval = -ENOMEM;
 			goto err_resource_files;
 		}
+		sysfs_bin_attr_init(attr);
 		attr->size = rom_size;
 		attr->attr.name = "rom";
 		attr->attr.mode = S_IRUSR;
diff --git a/kernel/params.c b/kernel/params.c
index cf1b691..5bf6deb 100644
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
1.6.5.2.143.g8cc62

