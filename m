Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbYGVFjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbYGVFjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757161AbYGVFZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:25:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:53958 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861AbYGVFZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:25:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 52/79] driver core: remove DEVICE_NAME_SIZE define
Date: Mon, 21 Jul 2008 22:19:16 -0700
Message-Id: <1216703983-21448-52-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

There is no such thing as a "device name size" in the driver core, so
remove the define and fix up any users of this odd define in the rest of
the kernel.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/eisa/Makefile        |    2 +-
 drivers/eisa/eisa-bus.c      |    4 ++--
 drivers/mca/mca-bus.c        |    2 +-
 drivers/video/aty/aty128fb.c |    2 +-
 drivers/video/aty/radeonfb.h |    2 +-
 include/linux/device.h       |    3 ---
 include/linux/eisa.h         |    2 +-
 7 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/eisa/Makefile b/drivers/eisa/Makefile
index 70abf93..5369ce9 100644
--- a/drivers/eisa/Makefile
+++ b/drivers/eisa/Makefile
@@ -9,7 +9,7 @@ obj-${CONFIG_EISA_VIRTUAL_ROOT} += virtual_root.o
 
 
 # Ugly hack to get DEVICE_NAME_SIZE value...
-DEVICE_NAME_SIZE =$(shell awk '$$1=="\#define" && $$2=="DEVICE_NAME_SIZE" {print $$3-1}' $(srctree)/include/linux/device.h)
+DEVICE_NAME_SIZE = 50
 
 $(obj)/eisa-bus.o: $(obj)/devlist.h
 
diff --git a/drivers/eisa/eisa-bus.c b/drivers/eisa/eisa-bus.c
index 65dcf04..c950bf8 100644
--- a/drivers/eisa/eisa-bus.c
+++ b/drivers/eisa/eisa-bus.c
@@ -22,7 +22,7 @@
 
 struct eisa_device_info {
 	struct eisa_device_id id;
-	char name[DEVICE_NAME_SIZE];
+	char name[50];
 };
 
 #ifdef CONFIG_EISA_NAMES
@@ -63,7 +63,7 @@ static void __init eisa_name_device (struct eisa_device *edev)
 		if (!strcmp (edev->id.sig, eisa_table[i].id.sig)) {
 			strlcpy (edev->pretty_name,
 				 eisa_table[i].name,
-				 DEVICE_NAME_SIZE);
+				 sizeof(edev->pretty_name));
 			return;
 		}
 	}
diff --git a/drivers/mca/mca-bus.c b/drivers/mca/mca-bus.c
index 67b8e94..ef2dbfe 100644
--- a/drivers/mca/mca-bus.c
+++ b/drivers/mca/mca-bus.c
@@ -40,7 +40,7 @@ static struct mca_bus *mca_root_busses[MAX_MCA_BUSSES];
 
 struct mca_device_info {
 	short pos_id;		/* the 2 byte pos id for this card */
-	char name[DEVICE_NAME_SIZE];
+	char name[50];
 };
 
 static int mca_bus_match (struct device *dev, struct device_driver *drv)
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index 24ee96c..07b6add 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -1872,7 +1872,7 @@ static int __devinit aty128_init(struct pci_dev *pdev, const struct pci_device_i
 	struct fb_info *info = pci_get_drvdata(pdev);
 	struct aty128fb_par *par = info->par;
 	struct fb_var_screeninfo var;
-	char video_card[DEVICE_NAME_SIZE];
+	char video_card[50];
 	u8 chip_rev;
 	u32 dac;
 
diff --git a/drivers/video/aty/radeonfb.h b/drivers/video/aty/radeonfb.h
index c347e38..ccbfffd 100644
--- a/drivers/video/aty/radeonfb.h
+++ b/drivers/video/aty/radeonfb.h
@@ -289,7 +289,7 @@ struct radeonfb_info {
 	struct radeon_regs 	state;
 	struct radeon_regs	init_state;
 
-	char			name[DEVICE_NAME_SIZE];
+	char			name[50];
 
 	unsigned long		mmio_base_phys;
 	unsigned long		fb_base_phys;
diff --git a/include/linux/device.h b/include/linux/device.h
index fba1bb0..894fdb2 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -25,9 +25,6 @@
 #include <asm/atomic.h>
 #include <asm/device.h>
 
-#define DEVICE_NAME_SIZE	50
-/* DEVICE_NAME_HALF is really less than half to accommodate slop */
-#define DEVICE_NAME_HALF	__stringify(20)
 #define DEVICE_ID_SIZE		32
 #define BUS_ID_SIZE		20
 
diff --git a/include/linux/eisa.h b/include/linux/eisa.h
index fe806b6..e61c0be 100644
--- a/include/linux/eisa.h
+++ b/include/linux/eisa.h
@@ -40,7 +40,7 @@ struct eisa_device {
 	u64                   dma_mask;
 	struct device         dev; /* generic device */
 #ifdef CONFIG_EISA_NAMES
-	char		      pretty_name[DEVICE_NAME_SIZE];
+	char		      pretty_name[50];
 #endif
 };
 
-- 
1.5.6.3

