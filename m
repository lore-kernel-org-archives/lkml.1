Return-Path: <linux-kernel-owner+w=401wt.eu-S1030259AbXBUOxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259AbXBUOxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 09:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbXBUOxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 09:53:31 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:59729 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbXBUOxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 09:53:30 -0500
Date: Wed, 21 Feb 2007 15:53:53 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Message-ID: <20070221145353.GA23916@enneenne.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 1/1] PXAFB: Support for backlight control
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Backlight control support for the PXA fram buffer.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>

---

Each platform should define the backlight properties in its own setup
file in "linux/arch/arm/mach-pxa/" as follow:

   static int pxafb_bl_get_brightness(struct backlight_device *bl_dev)
   {
   	return read_the_backlight_brightness();
   }

   static int pxafb_bl_update_status(struct backlight_device *bl_dev)
   {
           int perc, ret;

           if (bl_dev->props->power != FB_BLANK_UNBLANK ||
               bl_dev->props->fb_blank != FB_BLANK_UNBLANK)
                   perc = 0;
           else
                   perc = bl_dev->props->brightness;

   	write_the_backlight_brightness(perc);

           return 0;
   }

   static struct backlight_properties wwpc1100_backlight_props = {
           .get_brightness         = pxafb_bl_get_brightness,
           .update_status          = pxafb_bl_update_status,
           .max_brightness         = 100,
   };
      
and then seting up the fb info as follow:

   wwpc1100_pxafb_info.modes = &special_modes;
   wwpc1100_pxafb_info.bl_props = &wwpc1100_backlight_props;
   set_pxa_fb_info(&wwpc1100_pxafb_info);

--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-pxafb-backlight

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index c1536d7..1ee589e 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1514,6 +1514,14 @@ config FB_PXA_PARAMETERS
 
 	  <file:Documentation/fb/pxafb.txt> describes the available parameters.
 
+config FB_PXA_BACKLIGHT
+	bool "Support for backlight control"
+	default y
+	depends on FB_PXA
+	select FB_BACKLIGHT
+	help
+	  Say Y here if you want to control the backlight of your display.
+
 config FB_MBX
 	tristate "2700G LCD framebuffer support"
 	depends on FB && ARCH_PXA
diff --git a/drivers/video/pxafb.c b/drivers/video/pxafb.c
index b4947c8..489174a 100644
--- a/drivers/video/pxafb.c
+++ b/drivers/video/pxafb.c
@@ -9,6 +9,8 @@
  *  which in turn is
  *   Based on acornfb.c Copyright (C) Russell King.
  *
+ * Backlight support by Rodolfo Giometti <giometti@linux.it>
+ *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file COPYING in the main directory of this archive for
  * more details.
@@ -37,6 +39,7 @@
 #include <linux/cpufreq.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
+#include <linux/backlight.h>
 
 #include <asm/hardware.h>
 #include <asm/io.h>
@@ -58,7 +61,6 @@
 #define LCCR0_INVALID_CONFIG_MASK (LCCR0_OUM|LCCR0_BM|LCCR0_QDM|LCCR0_DIS|LCCR0_EFM|LCCR0_IUM|LCCR0_SFM|LCCR0_LDM|LCCR0_ENB)
 #define LCCR3_INVALID_CONFIG_MASK (LCCR3_HSP|LCCR3_VSP|LCCR3_PCD|LCCR3_BPP)
 
-static void (*pxafb_backlight_power)(int);
 static void (*pxafb_lcd_power)(int, struct fb_var_screeninfo *);
 
 static int pxafb_activate_var(struct fb_var_screeninfo *var, struct pxafb_info *);
@@ -69,6 +71,71 @@ static void set_ctrlr_state(struct pxafb_info *fbi, u_int state);
 static char g_options[PXAFB_OPTIONS_SIZE] __initdata = "";
 #endif
 
+
+/*
+ * Backlight control
+ */
+#ifdef CONFIG_FB_BACKLIGHT
+static void pxafb_bl_suspend(struct pxafb_info *fbi)
+{
+	struct backlight_device *bl_dev = fbi->fb.bl_dev;
+
+	if (bl_dev) {
+		down(&bl_dev->sem);
+		bl_dev->props->fb_blank = FB_BLANK_POWERDOWN;
+		bl_dev->props->update_status(bl_dev);
+		up(&bl_dev->sem);
+	}
+}
+
+static void pxafb_bl_resume(struct pxafb_info *fbi)
+{
+	struct backlight_device *bl_dev = fbi->fb.bl_dev;
+
+	if (bl_dev) {
+		down(&bl_dev->sem);
+		bl_dev->props->fb_blank = FB_BLANK_UNBLANK;
+		bl_dev->props->update_status(bl_dev);
+		up(&bl_dev->sem);
+	}
+}
+
+static void pxafb_bl_init(struct fb_info *info, struct backlight_properties *bl_props)
+{
+	struct backlight_device *bl_dev;
+	char name[16];
+
+	snprintf(name, sizeof(name), "pxabl%d", info->node);
+
+	bl_dev = backlight_device_register(name, info->dev, info, bl_props);
+	if (IS_ERR(bl_dev)) {
+		info->bl_dev = NULL;
+		printk(KERN_WARNING "pxafb: backlight registration failed\n");
+		return;
+	}
+
+	mutex_lock(&info->bl_mutex);
+	info->bl_dev = bl_dev;
+	fb_bl_default_curve(info, 0, 0, 100);	/* level: 0 - 100 */
+	mutex_unlock(&info->bl_mutex);
+
+	down(&bl_dev->sem);
+	bl_dev->props->brightness = bl_props->max_brightness;
+	bl_dev->props->power = FB_BLANK_UNBLANK;
+	bl_dev->props->update_status(bl_dev);
+	up(&bl_dev->sem);
+
+	printk("pxafb: backlight initialized (%s)\n", name);
+}
+#else
+static inline void pxafb_bl_init(struct fb_info *info, struct backlight_properties *bl_props) {}
+static inline void pxafb_bl_suspend(struct pxafb_info *fbi) {}
+static inline void pxafb_bl_resume(struct pxafb_info *fbi) {}
+#endif /* CONFIG_FB_BACKLIGHT */
+
+/*
+ *
+ */
 static inline void pxafb_schedule_work(struct pxafb_info *fbi, u_int state)
 {
 	unsigned long flags;
@@ -736,14 +803,6 @@ static int pxafb_activate_var(struct fb_var_screeninfo *var, struct pxafb_info *
  * to ensure that things happen in the right way 100% of time time.
  *	-- rmk
  */
-static inline void __pxafb_backlight_power(struct pxafb_info *fbi, int on)
-{
-	pr_debug("pxafb: backlight o%s\n", on ? "n" : "ff");
-
- 	if (pxafb_backlight_power)
- 		pxafb_backlight_power(on);
-}
-
 static inline void __pxafb_lcd_power(struct pxafb_info *fbi, int on)
 {
 	pr_debug("pxafb: LCD power o%s\n", on ? "n" : "ff");
@@ -899,7 +958,7 @@ static void set_ctrlr_state(struct pxafb_info *fbi, u_int state)
 		 */
 		if (old_state != C_DISABLE) {
 			fbi->state = state;
-			__pxafb_backlight_power(fbi, 0);
+			pxafb_bl_suspend(fbi);
 			__pxafb_lcd_power(fbi, 0);
 			if (old_state != C_DISABLE_CLKCHANGE)
 				pxafb_disable_controller(fbi);
@@ -953,7 +1012,7 @@ static void set_ctrlr_state(struct pxafb_info *fbi, u_int state)
 			pxafb_setup_gpio(fbi);
 			pxafb_enable_controller(fbi);
 			__pxafb_lcd_power(fbi, 1);
-			__pxafb_backlight_power(fbi, 1);
+			pxafb_bl_resume(fbi);
 		}
 		break;
 	}
@@ -1112,11 +1171,10 @@ static struct pxafb_info * __init pxafb_init_fbinfo(struct device *dev)
 	int i, smemlen;
 
 	/* Alloc the pxafb_info and pseudo_palette in one step */
-	fbi = kmalloc(sizeof(struct pxafb_info) + sizeof(u32) * 16, GFP_KERNEL);
+	fbi = (struct pxafb_info *) framebuffer_alloc(sizeof(u32) * 16, dev);
 	if (!fbi)
 		return NULL;
 
-	memset(fbi, 0, sizeof(struct pxafb_info));
 	fbi->dev = dev;
 
 	strcpy(fbi->fb.fix.id, PXA_NAME);
@@ -1368,7 +1426,6 @@ int __init pxafb_probe(struct platform_device *dev)
 		ret = -EINVAL;
 		goto failed;
 	}
-	pxafb_backlight_power = inf->pxafb_backlight_power;
 	pxafb_lcd_power = inf->pxafb_lcd_power;
 	fbi = pxafb_init_fbinfo(&dev->dev);
 	if (!fbi) {
@@ -1407,6 +1464,9 @@ int __init pxafb_probe(struct platform_device *dev)
 		goto failed;
 	}
 
+	/* Register the backlight support */
+	pxafb_bl_init(&fbi->fb, inf->bl_props);
+
 #ifdef CONFIG_PM
 	// TODO
 #endif
diff --git a/include/asm-arm/arch-pxa/pxafb.h b/include/asm-arm/arch-pxa/pxafb.h
index 81c3928..5c89664 100644
--- a/include/asm-arm/arch-pxa/pxafb.h
+++ b/include/asm-arm/arch-pxa/pxafb.h
@@ -71,7 +71,7 @@ struct pxafb_mach_info {
 	 */
 	u_int		lccr3;
 
-	void (*pxafb_backlight_power)(int);
+	struct backlight_properties	*bl_props;
 	void (*pxafb_lcd_power)(int, struct fb_var_screeninfo *);
 
 };

--mYCpIKhGyMATD0i+--
