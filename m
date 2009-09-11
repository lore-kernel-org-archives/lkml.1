Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbZIKXGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbZIKXGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 19:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbZIKXGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 19:06:49 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:42865 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864AbZIKXGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 19:06:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=QzS6o6E6A0w+KR+VYuw3r46fyxzaDgZyAbF7rQQbh2BpYO1cEuf8G8MC/Cqq0QxSbm
         kfuRAdcGXMeWd5vm0lS9l6w9soWdQNimYzgY95Hfhvir2N/aphX6OsUFlJ2QddS/TrPL
         W4H6LqpgJADRWmYb68rkAV5obpARM2vnBmGJ4=
From: Miguel Boton <waninkoko@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] logo: random logo selection option
Date: Sat, 12 Sep 2009 01:03:40 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-zen0; KDE/4.3.0; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200909120103.41128.mboton@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we select more than one logo in the kernel configuration, only the 'latest' one gets
displayed. Because of this the other logos do not ever have a chance to be displayed.

This patch adds a selectable option to display a random logo during the bootup process.
This way the kernel will be able to display any available logo, making the bootup process
a little different every time ;)

Signed-off-by: Miguel Boton <mboton@gmail.com>
--
 drivers/video/logo/Kconfig |    8 +++
 drivers/video/logo/logo.c  |  113 +++++++++++++++++++++++++------------------
 2 files changed, 74 insertions(+), 47 deletions(-)

diff --git a/drivers/video/logo/Kconfig b/drivers/video/logo/Kconfig
index 39ac49e..8b79ef5 100644
--- a/drivers/video/logo/Kconfig
+++ b/drivers/video/logo/Kconfig
@@ -15,6 +15,15 @@ config FB_LOGO_EXTRA
 	depends on FB=y
 	default y if SPU_BASE
 
+config LOGO_RANDOM
+	bool "Select random available logo"
+	default n
+	help
+	  This option enables random logo selection from available logos
+	  during the bootup process.
+
+comment "Available logos"
+
 config LOGO_LINUX_MONO
 	bool "Standard black and white Linux logo"
 	default y
diff --git a/drivers/video/logo/logo.c b/drivers/video/logo/logo.c
index ea7a8cc..f90c21b 100644
--- a/drivers/video/logo/logo.c
+++ b/drivers/video/logo/logo.c
@@ -13,6 +13,10 @@
 #include <linux/stddef.h>
 #include <linux/module.h>
 
+#ifdef CONFIG_LOGO_RANDOM
+#include <linux/random.h>
+#endif
+
 #ifdef CONFIG_M68K
 #include <asm/setup.h>
 #endif
@@ -25,82 +29,97 @@ static int nologo;
 module_param(nologo, bool, 0);
 MODULE_PARM_DESC(nologo, "Disables startup logo");
 
-/* logo's are marked __initdata. Use __init_refok to tell
- * modpost that it is intended that this function uses data
- * marked __initdata.
- */
-const struct linux_logo * __init_refok fb_find_logo(int depth)
-{
-	const struct linux_logo *logo = NULL;
-
-	if (nologo)
-		return NULL;
-
-	if (depth >= 1) {
+/* Monochromatic logos */
+static const struct linux_logo *logo_mono[] = {
 #ifdef CONFIG_LOGO_LINUX_MONO
-		/* Generic Linux logo */
-		logo = &logo_linux_mono;
+	&logo_linux_mono,		/* Generic Linux logo */
 #endif
 #ifdef CONFIG_LOGO_SUPERH_MONO
-		/* SuperH Linux logo */
-		logo = &logo_superh_mono;
+	&logo_superh_mono,		/* SuperH Linux logo */
 #endif
-	}
-	
-	if (depth >= 4) {
+};
+
+/* 16-colour logos */
+static const struct linux_logo *logo_vga16[] = {
 #ifdef CONFIG_LOGO_LINUX_VGA16
-		/* Generic Linux logo */
-		logo = &logo_linux_vga16;
+	&logo_linux_vga16,		/* Generic Linux logo */
 #endif
 #ifdef CONFIG_LOGO_BLACKFIN_VGA16
-		/* Blackfin processor logo */
-		logo = &logo_blackfin_vga16;
+	&logo_blackfin_vga16,		/* Blackfin processor logo */
 #endif
 #ifdef CONFIG_LOGO_SUPERH_VGA16
-		/* SuperH Linux logo */
-		logo = &logo_superh_vga16;
+	&logo_superh_vga16,		/* SuperH Linux logo */
 #endif
-	}
-	
-	if (depth >= 8) {
+};
+
+/* 224-colour logos */
+static const struct linux_logo *logo_clut224[] = {
 #ifdef CONFIG_LOGO_LINUX_CLUT224
-		/* Generic Linux logo */
-		logo = &logo_linux_clut224;
+	&logo_linux_clut224,		/* Generic Linux logo */
 #endif
 #ifdef CONFIG_LOGO_BLACKFIN_CLUT224
-		/* Blackfin Linux logo */
-		logo = &logo_blackfin_clut224;
+	&logo_blackfin_clut224,		/* Blackfin Linux logo */
 #endif
 #ifdef CONFIG_LOGO_DEC_CLUT224
-		/* DEC Linux logo on MIPS/MIPS64 or ALPHA */
-		logo = &logo_dec_clut224;
+	&logo_dec_clut224,		/* DEC Linux logo on MIPS/MIPS64 or ALPHA */
 #endif
 #ifdef CONFIG_LOGO_MAC_CLUT224
-		/* Macintosh Linux logo on m68k */
-		if (MACH_IS_MAC)
-			logo = &logo_mac_clut224;
+	&logo_mac_clut224,		/* Macintosh Linux logo on m68k */
 #endif
 #ifdef CONFIG_LOGO_PARISC_CLUT224
-		/* PA-RISC Linux logo */
-		logo = &logo_parisc_clut224;
+	&logo_parisc_clut224,		/* PA-RISC Linux logo */
 #endif
 #ifdef CONFIG_LOGO_SGI_CLUT224
-		/* SGI Linux logo on MIPS/MIPS64 and VISWS */
-		logo = &logo_sgi_clut224;
+	&logo_sgi_clut224,		/* SGI Linux logo on MIPS/MIPS64 and VISWS */
 #endif
 #ifdef CONFIG_LOGO_SUN_CLUT224
-		/* Sun Linux logo */
-		logo = &logo_sun_clut224;
+	&logo_sun_clut224,		/* Sun Linux logo */
 #endif
 #ifdef CONFIG_LOGO_SUPERH_CLUT224
-		/* SuperH Linux logo */
-		logo = &logo_superh_clut224;
+	&logo_superh_clut224,		/* SuperH Linux logo */
 #endif
 #ifdef CONFIG_LOGO_M32R_CLUT224
-		/* M32R Linux logo */
-		logo = &logo_m32r_clut224;
+	&logo_m32r_clut224,		/* M32R Linux logo */
 #endif
+};
+
+#ifdef CONFIG_LOGO_RANDOM
+#define LOGO_INDEX(s)	(get_random_int() % s)
+#else
+#define LOGO_INDEX(s)	(s - 1)
+#endif
+
+/* logo's are marked __initdata. Use __init_refok to tell
+ * modpost that it is intended that this function uses data
+ * marked __initdata.
+ */
+const struct linux_logo * __init_refok fb_find_logo(int depth)
+{
+	const struct linux_logo *logo = NULL;
+	const struct linux_logo **array = NULL;
+	unsigned int size;
+
+	if (nologo)
+		return NULL;
+
+	/* Select logo array */
+	if (depth >= 1) {
+		array = logo_mono;
+		size = ARRAY_SIZE(logo_mono);
+	}
+	if (depth >= 4) {
+		array = logo_vga16;
+		size = ARRAY_SIZE(logo_vga16);
+	}
+	if (depth >= 8) {
+		array = logo_clut224;
+		size = ARRAY_SIZE(logo_clut224);
 	}
+
+	/* We've got some logos to display */
+	if (array && size)
+		logo = array[LOGO_INDEX(size)];
+
 	return logo;
 }
 EXPORT_SYMBOL_GPL(fb_find_logo);
