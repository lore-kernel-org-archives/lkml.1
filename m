Return-Path: <linux-kernel-owner+w=401wt.eu-S1753105AbYIUWpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbYIUWpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 18:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYIUWpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 18:45:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:52936 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbYIUWpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 18:45:38 -0400
Date: Sun, 21 Sep 2008 15:45:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: neilb@suse.de, mingo@elte.hu, davej@redhat.com
Subject: [PATCH] raid: make RAID autodetect default a KConfig option
Message-ID: <20080921154541.371f2ebe@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 812bf9a448d96375a3aec5c51764d74cace85abb Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 21 Sep 2008 15:44:32 -0700
Subject: [PATCH] raid: make RAID autodetect default a KConfig option

RAID autodetect has the side effect of requiring synchronisation
of all device drivers, which can make the boot several seconds longer
(I've measured 7 on one of my laptops).... even for systems that don't
have RAID setup for the root filesystem (the only FS where this matters).

This patch makes the default for autodetect a config option; either way
the user can always override via the kernel command line.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/md/Kconfig  |   14 ++++++++++++++
 init/do_mounts_md.c |   11 +++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 07d92c1..8e72c91 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -30,6 +30,20 @@ config BLK_DEV_MD
 
 	  If unsure, say N.
 
+config MD_AUTODETECT
+	bool "Autodetect RAID arrays during kernel boot"
+	depends on BLK_DEV_MD
+	default y
+	---help---
+	  If you say Y here, then the kernel will try to autodetect raid
+	  arrays as part of its boot process. 
+
+	  If you don't use raid and say Y, this autodetection can cause 
+	  a several-second delay in the boot time due to various
+	  synchronisation steps that are part of this step.
+
+	  If unsure, say Y.
+
 config MD_LINEAR
 	tristate "Linear (append) mode"
 	depends on BLK_DEV_MD
diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index c0dfd3c..48b3fad 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -12,7 +12,12 @@
  * The code for that is here.
  */
 
-static int __initdata raid_noautodetect, raid_autopart;
+#ifdef CONFIG_MD_AUTODETECT
+static int __initdata raid_noautodetect;
+#else
+static int __initdata raid_noautodetect=1;
+#endif
+static int __initdata raid_autopart;
 
 static struct {
 	int minor;
@@ -252,6 +257,8 @@ static int __init raid_setup(char *str)
 
 		if (!strncmp(str, "noautodetect", wlen))
 			raid_noautodetect = 1;
+		if (!strncmp(str, "autodetect", wlen))
+			raid_noautodetect = 0;
 		if (strncmp(str, "partitionable", wlen)==0)
 			raid_autopart = 1;
 		if (strncmp(str, "part", wlen)==0)
@@ -288,7 +295,7 @@ void __init md_run_setup(void)
 	create_dev("/dev/md0", MKDEV(MD_MAJOR, 0));
 
 	if (raid_noautodetect)
-		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. (raid=noautodetect)\n");
+		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. (raid=autodetect will force)\n");
 	else
 		autodetect_raid();
 	md_setup_drive();
-- 
1.5.5.1


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
