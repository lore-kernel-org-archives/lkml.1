Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbYIAUO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbYIAUO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 16:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYIAUOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 16:14:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:58033 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbYIAUOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 16:14:49 -0400
Subject: Misc fixes for 2.6.27
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Mon, 01 Sep 2008 21:14:44 +0100
Message-Id: <1220300084.2982.139.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from
	git://git.infradead.org/users/dwmw2/random-2.6.git

It contains the following fixes for 2.6.27:

Adrian Bunk (1):
      dabusb_fpga_download(): fix a memory leak

David Woodhouse (3):
      intel-iommu.c: Blacklist Intel DG33BU motherboard.
      Fix modules_install on RO nfs-exported trees.
      Remove '#include <stddef.h>' from mm/page_isolation.c

Zev Weiss (1):
      [MTD] mtdchar.c: Fix regression in MEMGETREGIONINFO ioctl()

 drivers/media/video/dabusb.c |    1 +
 drivers/mtd/mtdchar.c        |   16 ++++++++++------
 drivers/pci/intel-iommu.c    |   23 +++++++++++++++++++++++
 firmware/Makefile            |   16 ++++++++++++++--
 mm/page_isolation.c          |    1 -
 5 files changed, 48 insertions(+), 9 deletions(-)

Full patch follows...

diff --git a/drivers/media/video/dabusb.c b/drivers/media/video/dabusb.c
index 48f4b92..79faedf 100644
--- a/drivers/media/video/dabusb.c
+++ b/drivers/media/video/dabusb.c
@@ -403,6 +403,7 @@ static int dabusb_fpga_download (pdabusb_t s, const char *fname)
 	ret = request_firmware(&fw, "dabusb/bitstream.bin", &s->usbdev->dev);
 	if (ret) {
 		err("Failed to load \"dabusb/bitstream.bin\": %d\n", ret);
+		kfree(b);
 		return ret;
 	}
 
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index d2f3318..e00d424 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -410,16 +410,20 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
 
 	case MEMGETREGIONINFO:
 	{
-		struct region_info_user ur;
+		uint32_t ur_idx;
+		struct mtd_erase_region_info *kr;
+		struct region_info_user *ur = (struct region_info_user *) argp;
 
-		if (copy_from_user(&ur, argp, sizeof(struct region_info_user)))
+		if (get_user(ur_idx, &(ur->regionindex)))
 			return -EFAULT;
 
-		if (ur.regionindex >= mtd->numeraseregions)
-			return -EINVAL;
-		if (copy_to_user(argp, &(mtd->eraseregions[ur.regionindex]),
-				sizeof(struct mtd_erase_region_info)))
+		kr = &(mtd->eraseregions[ur_idx]);
+
+		if (put_user(kr->offset, &(ur->offset))
+		    || put_user(kr->erasesize, &(ur->erasesize))
+		    || put_user(kr->numblocks, &(ur->numblocks)))
 			return -EFAULT;
+
 		break;
 	}
 
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 8d0e60a..c3edcdc 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2348,11 +2348,34 @@ static void __init iommu_exit_mempool(void)
 
 }
 
+static int blacklist_iommu(const struct dmi_system_id *id)
+{
+	printk(KERN_INFO "%s detected; disabling IOMMU\n",
+	       id->ident);
+	dmar_disabled = 1;
+	return 0;
+}
+
+static struct dmi_system_id __initdata intel_iommu_dmi_table[] = {
+	{	/* Some DG33BU BIOS revisions advertised non-existent VT-d */
+		.callback = blacklist_iommu,
+		.ident = "Intel DG33BU",
+		{	DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "DG33BU"),
+		}
+	},
+	{ }
+};
+
+
 void __init detect_intel_iommu(void)
 {
 	if (swiotlb || no_iommu || iommu_detected || dmar_disabled)
 		return;
 	if (early_dmar_detect()) {
+		dmi_check_system(intel_iommu_dmi_table);
+		if (dmar_disabled)
+			return;
 		iommu_detected = 1;
 	}
 }
diff --git a/firmware/Makefile b/firmware/Makefile
index 9fe8604..da75a6f 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -146,15 +146,27 @@ $(patsubst %,$(obj)/%.gen.o, $(fw-external-y)): $(obj)/%.gen.o: $(fwdir)/%
 $(obj)/%: $(obj)/%.ihex | $(objtree)/$(obj)/$$(dir %)
 	$(call cmd,ihex)
 
+# Don't depend on ihex2fw if we're installing and it already exists.
+# Putting it after | in the dependencies doesn't seem sufficient when
+# we're installing after a cross-compile, because ihex2fw has dependencies
+# on stuff like /usr/lib/gcc/ppc64-redhat-linux/4.3.0/include/stddef.h and 
+# thus wants to be rebuilt. Which it can't be, if the prebuilt kernel tree
+# is exported read-only for someone to run 'make install'.
+ifeq ($(INSTALL):$(wildcard $(obj)/ihex2fw),install:$(obj)/ihex2fw)
+ihex2fw_dep :=
+else
+ihex2fw_dep := $(obj)/ihex2fw
+endif
+
 # .HEX is also Intel HEX, but where the offset and length in each record
 # is actually meaningful, because the firmware has to be loaded in a certain
 # order rather than as a single binary blob. Thus, we convert them into our
 # more compact binary representation of ihex records (<linux/ihex.h>)
-$(obj)/%.fw: $(obj)/%.HEX $(obj)/ihex2fw | $(objtree)/$(obj)/$$(dir %)
+$(obj)/%.fw: $(obj)/%.HEX $(ihex2fw_dep) | $(objtree)/$(obj)/$$(dir %)
 	$(call cmd,ihex2fw)
 
 # .H16 is our own modified form of Intel HEX, with 16-bit length for records.
-$(obj)/%.fw: $(obj)/%.H16 $(obj)/ihex2fw | $(objtree)/$(obj)/$$(dir %)
+$(obj)/%.fw: $(obj)/%.H16 $(ihex2fw_dep) | $(objtree)/$(obj)/$$(dir %)
 	$(call cmd,h16tofw)
 
 $(firmware-dirs):
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 3444b58..c69f84f 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -2,7 +2,6 @@
  * linux/mm/page_isolation.c
  */
 
-#include <stddef.h>
 #include <linux/mm.h>
 #include <linux/page-isolation.h>
 #include <linux/pageblock-flags.h>


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



