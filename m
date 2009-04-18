Return-Path: <linux-kernel-owner+w=401wt.eu-S1760607AbZDRS6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607AbZDRS6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 14:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759376AbZDRSxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 14:53:00 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:55362 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbZDRSw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 14:52:28 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH/RFC 05/16] m68k: amiga - Sound platform device conversion
Date: Sat, 18 Apr 2009 20:52:13 +0200
Message-Id: <1240080744-14995-6-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1240080744-14995-5-git-send-email-geert@linux-m68k.org>
References: <1240080744-14995-1-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-2-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-3-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-4-git-send-email-geert@linux-m68k.org>
 <1240080744-14995-5-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/amiga/platform.c          |    5 +++
 sound/oss/dmasound/dmasound_paula.c |   51 +++++++++++++++++++++-------------
 2 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/arch/m68k/amiga/platform.c b/arch/m68k/amiga/platform.c
index 7fa929c..2e308e7 100644
--- a/arch/m68k/amiga/platform.c
+++ b/arch/m68k/amiga/platform.c
@@ -67,6 +67,11 @@ static int __init amiga_init_devices(void)
 	if (AMIGAHW_PRESENT(AMI_VIDEO))
 		platform_device_register_simple("amiga-video", -1, NULL, 0);
 
+
+	/* sound hardware */
+	if (AMIGAHW_PRESENT(AMI_AUDIO))
+		platform_device_register_simple("amiga-audio", -1, NULL, 0);
+
 	return 0;
 }
 
diff --git a/sound/oss/dmasound/dmasound_paula.c b/sound/oss/dmasound/dmasound_paula.c
index 06e9e88..98acde8 100644
--- a/sound/oss/dmasound/dmasound_paula.c
+++ b/sound/oss/dmasound/dmasound_paula.c
@@ -21,6 +21,7 @@
 #include <linux/ioport.h>
 #include <linux/soundcard.h>
 #include <linux/interrupt.h>
+#include <linux/platform_device.h>
 
 #include <asm/uaccess.h>
 #include <asm/setup.h>
@@ -710,31 +711,41 @@ static MACHINE machAmiga = {
 /*** Config & Setup **********************************************************/
 
 
-static int __init dmasound_paula_init(void)
+static int __init amiga_audio_probe(struct platform_device *pdev)
 {
-	int err;
-
-	if (MACH_IS_AMIGA && AMIGAHW_PRESENT(AMI_AUDIO)) {
-	    if (!request_mem_region(CUSTOM_PHYSADDR+0xa0, 0x40,
-				    "dmasound [Paula]"))
-		return -EBUSY;
-	    dmasound.mach = machAmiga;
-	    dmasound.mach.default_hard = def_hard ;
-	    dmasound.mach.default_soft = def_soft ;
-	    err = dmasound_init();
-	    if (err)
-		release_mem_region(CUSTOM_PHYSADDR+0xa0, 0x40);
-	    return err;
-	} else
-	    return -ENODEV;
+	dmasound.mach = machAmiga;
+	dmasound.mach.default_hard = def_hard ;
+	dmasound.mach.default_soft = def_soft ;
+	return dmasound_init();
 }
 
-static void __exit dmasound_paula_cleanup(void)
+static int __exit amiga_audio_remove(struct platform_device *pdev)
 {
 	dmasound_deinit();
-	release_mem_region(CUSTOM_PHYSADDR+0xa0, 0x40);
+	return 0;
+}
+
+static struct platform_driver amiga_audio_driver = {
+	.remove = __exit_p(amiga_audio_remove),
+	.driver   = {
+		.name	= "amiga-audio",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init amiga_audio_init(void)
+{
+	return platform_driver_probe(&amiga_audio_driver, amiga_audio_probe);
 }
 
-module_init(dmasound_paula_init);
-module_exit(dmasound_paula_cleanup);
+module_init(amiga_audio_init);
+
+static void __exit amiga_audio_exit(void)
+{
+	platform_driver_unregister(&amiga_audio_driver);
+}
+
+module_exit(amiga_audio_exit);
+
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:amiga-audio");
-- 
1.6.2.3

