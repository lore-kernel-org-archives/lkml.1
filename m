Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZHKM6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZHKM6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZHKM6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:58:09 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:54232 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbZHKM6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OyJCqNT2t1XkVeK8Gm4qXnlDsOMbrtkFJrV1PKdVzjicyu5tF9Ss5V7OBSnn2odKpo
         QlCwIv/9PxtRa+w8bg3RigxW4xi7meItUEy6s/a+sZcdxD3Y4gYdB6dOuQuzaTOXWDkt
         OBhGRLlY2u4mB4QvYwUmuemtqc/1K11Q7yELg=
MIME-Version: 1.0
Date: Tue, 11 Aug 2009 10:56:34 +0800
Message-ID: <3877989d0908101956o303c43c5i5c5f08297afb312@mail.gmail.com>
Subject: [RFC patch] Add boot option intel_iommu_drhd_mask
From: Luming Yu <luming.yu@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

As a follow up to my rfc-patch "return early if all dmar HW unit ignored",
The following patch add an option intel_iommu_drhd_mask to be able
to disable Dma-remapping hardware unit individually.

Please review. If make sense, please apply.


**The patch is enclosed in text attachment*
**Using web client to send the patch* *
**below is for review, please apply attached  patch*/

Thanks,
Luming


Signed-off-by: Yu Luming <luming.yu@intel.com>

 Documentation/kernel-parameters.txt |    3 +++
 drivers/pci/dmar.c                  |    7 +++++--
 drivers/pci/intel-iommu.c           |   10 ++++++++++
 include/linux/intel-iommu.h         |    1 +
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt
b/Documentation/kernel-parameters.txt
index dd1a6d4..d9eb422 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -981,6 +981,9 @@ and is between 256 and 4096 characters. It is
defined in the file
 			result in a hardware IOTLB flush operation as opposed
 			to batching them for performance.

+	intel_iommu_drhd_mask=0xAAAAAAAA
+			Set a bit mask of DMAR hardware unit to be ignored
+
 	inttest=	[IA64]

 	iomem=		Disable strict checking of access to MMIO memory
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 7b287cb..28f3f6b 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -167,7 +167,7 @@ static int __init dmar_parse_dev_scope(void
*start, void *end, int *cnt,
  * present in the platform
  */
 static int __init
-dmar_parse_one_drhd(struct acpi_dmar_header *header)
+dmar_parse_one_drhd(struct acpi_dmar_header *header, int drhd_count)
 {
 	struct acpi_dmar_hardware_unit *drhd;
 	struct dmar_drhd_unit *dmaru;
@@ -197,6 +197,8 @@ dmar_parse_one_drhd(struct acpi_dmar_header *header)
 		kfree(dmaru);
 		return ret;
 	}
+	if (intel_iommu_drhd_mask & (0x1 << drhd_count))
+		dmaru->ignored = 1;
 	dmar_register_drhd_unit(dmaru);
 	return 0;
 }
@@ -405,6 +407,7 @@ parse_dmar_table(void)
 {
 	struct acpi_table_dmar *dmar;
 	struct acpi_dmar_header *entry_header;
+	int drhd_count = 0;
 	int ret = 0;

 	/*
@@ -440,7 +443,7 @@ parse_dmar_table(void)

 		switch (entry_header->type) {
 		case ACPI_DMAR_TYPE_HARDWARE_UNIT:
-			ret = dmar_parse_one_drhd(entry_header);
+			ret = dmar_parse_one_drhd(entry_header, drhd_count);
 			break;
 		case ACPI_DMAR_TYPE_RESERVED_MEMORY:
 #ifdef CONFIG_DMAR
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 2314ad7..03afd92 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -337,6 +337,7 @@ static DEFINE_SPINLOCK(device_domain_lock);
 static LIST_HEAD(device_domain_list);

 static struct iommu_ops intel_iommu_ops;
+unsigned int intel_iommu_drhd_mask;

 static int __init intel_iommu_setup(char *str)
 {
@@ -371,6 +372,15 @@ static int __init intel_iommu_setup(char *str)
 }
 __setup("intel_iommu=", intel_iommu_setup);

+static int __init intel_iommu_drhd_mask_setup(char *str)
+{
+	if (!str)
+		return -EINVAL;
+	intel_iommu_drhd_mask = simple_strtoul(str, NULL, 0);
+	return 0;
+}
+__setup("intel_iommu_drhd_mask=", intel_iommu_drhd_mask_setup);
+
 static struct kmem_cache *iommu_domain_cache;
 static struct kmem_cache *iommu_devinfo_cache;
 static struct kmem_cache *iommu_iova_cache;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 482dc91..113c8e9 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -359,5 +359,6 @@ extern void qi_flush_dev_iotlb(struct intel_iommu
*iommu, u16 sid, u16 qdep,
 			       u64 addr, unsigned mask);

 extern int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
+extern unsigned int intel_iommu_drhd_mask;

 #endif
