Return-Path: <linux-kernel-owner+w=401wt.eu-S1759605AbZDRSxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605AbZDRSxf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 14:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759297AbZDRSwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 14:52:33 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:47002 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbZDRSw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 14:52:28 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH/RFC 06/16] m68k: amiga - Floppy platform device conversion
Date: Sat, 18 Apr 2009 20:52:14 +0200
Message-Id: <1240080744-14995-7-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1240080744-14995-6-git-send-email-geert@linux-m68k.org>
References: <1240080744-14995-1-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-2-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-3-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-4-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-5-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-6-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/platform.c |    5 ++++
 drivers/block/amiflop.c    |   47 +++++++++++++++++++------------------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index 2e308e7..38f18bf 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -72,6 +72,11 @@ static int __init amiga_init_devices(void)
 	if (AMIGAHW_PRESENT(AMI_AUDIO))
 		platform_device_register_simple("amiga-audio", -1, NULL, 0);
 
+
+	/* storage interfaces */
+	if (AMIGAHW_PRESENT(AMI_FLOPPY))
+		platform_device_register_simple("amiga-floppy", -1, NULL, 0);
+
 	return 0;
 }
 
diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 8df436f..76bf7e2 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -65,6 +65,7 @@
 #include <linux/blkdev.h>
 #include <linux/elevator.h>
 #include <linux/interrupt.h>
+#include <linux/platform_device.h>
 
 #include <asm/setup.h>
 #include <asm/uaccess.h>
@@ -1703,34 +1704,18 @@ static struct kobject *floppy_find(dev_t dev, int *part, void *data)
 	return get_disk(unit[drive].gendisk);
 }
 
-static int __init amiga_floppy_init(void)
+static int __init amiga_floppy_probe(struct platform_device *pdev)
 {
 	int i, ret;
 
-	if (!MACH_IS_AMIGA)
-		return -ENODEV;
-
-	if (!AMIGAHW_PRESENT(AMI_FLOPPY))
-		return -ENODEV;
-
 	if (register_blkdev(FLOPPY_MAJOR,"fd"))
 		return -EBUSY;
 
-	/*
-	 *  We request DSKPTR, DSKLEN and DSKDATA only, because the other
-	 *  floppy registers are too spreaded over the custom register space
-	 */
-	ret = -EBUSY;
-	if (!request_mem_region(CUSTOM_PHYSADDR+0x20, 8, "amiflop [Paula]")) {
-		printk("fd: cannot get floppy registers\n");
-		goto out_blkdev;
-	}
-
 	ret = -ENOMEM;
 	if ((raw_buf = (char *)amiga_chip_alloc (RAW_BUF_SIZE, "Floppy")) ==
 	    NULL) {
 		printk("fd: cannot get chip mem buffer\n");
-		goto out_memregion;
+		goto out_blkdev;
 	}
 
 	ret = -EBUSY;
@@ -1799,18 +1784,13 @@ out_irq2:
 	free_irq(IRQ_AMIGA_DSKBLK, NULL);
 out_irq:
 	amiga_chip_free(raw_buf);
-out_memregion:
-	release_mem_region(CUSTOM_PHYSADDR+0x20, 8);
 out_blkdev:
 	unregister_blkdev(FLOPPY_MAJOR,"fd");
 	return ret;
 }
 
-module_init(amiga_floppy_init);
-#ifdef MODULE
-
 #if 0 /* not safe to unload */
-void cleanup_module(void)
+static int __exit amiga_floppy_remove(struct platform_device *pdev)
 {
 	int i;
 
@@ -1827,12 +1807,25 @@ void cleanup_module(void)
 	custom.dmacon = DMAF_DISK; /* disable DMA */
 	amiga_chip_free(raw_buf);
 	blk_cleanup_queue(floppy_queue);
-	release_mem_region(CUSTOM_PHYSADDR+0x20, 8);
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 }
 #endif
 
-#else
+static struct platform_driver amiga_floppy_driver = {
+	.driver   = {
+		.name	= "amiga-floppy",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init amiga_floppy_init(void)
+{
+	return platform_driver_probe(&amiga_floppy_driver, amiga_floppy_probe);
+}
+
+module_init(amiga_floppy_init);
+
+#ifndef MODULE
 static int __init amiga_floppy_setup (char *str)
 {
 	int n;
@@ -1847,3 +1840,5 @@ static int __init amiga_floppy_setup (char *str)
 
 __setup("floppy=", amiga_floppy_setup);
 #endif
+
+MODULE_ALIAS("platform:amiga-floppy");
-- 
1.6.2.3

