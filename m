Return-Path: <linux-kernel-owner+w=401wt.eu-S932523AbXA1KzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbXA1KzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 05:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932543AbXA1KzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 05:55:10 -0500
Received: from main.gmane.org ([80.91.229.2]:54147 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932523AbXA1KzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 05:55:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: [PATCH] nvidiafb: allow ignoring EDID info
Date: Sun, 28 Jan 2007 11:48:59 +0100
Message-ID: <ephv35$4i3$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: host-84-221-15-3.cust-adsl.tiscali.it
User-Agent: KNode/0.10.4
X-Face: ::w9}R^l{WGM\{y)C0QF@4^U,',W3Mk^X0HP)=:bKM^Z]A9+6bY6fe3}O*]fH{l<j1/9RTp  `KR0idy]Im#9^%}P5Dga'>AViT_'?&>&ufo2_X5Vs3C^tPO@drZRuu&6iK}x}~9`F\-dNZ>(p|V7`4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>

Some nVidia video cards have broken EDID information. Using nvidiafb
with CONFIG_FB_NVIDIA_I2C enabled on these systems causes the console
framebuffer to use wrong timing information, causing the display to be
extremely 'snowy'. Since most distribution kernels are compiled with
CONFIG_FB_NVIDIA_I2C enabled, this prevents usage of the nvidia
framebuffer on said broken system without recompiling the kernel
(or at least the nvidiafb module).

Solve the issue by introducing a new boolean module parameter (useedid)
which can be set to 0 to prevent the driver from using the EDID
information.

Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>

---

If this patch is accepted, we can probably get rid of CONFIG_FB_NVIDIA_I2C
altogether.


diff --git a/drivers/video/nvidia/nv_i2c.c b/drivers/video/nvidia/nv_i2c.c
index 8454adf..6387f2b 100644
--- a/drivers/video/nvidia/nv_i2c.c
+++ b/drivers/video/nvidia/nv_i2c.c
@@ -25,6 +25,8 @@
 
 #include "../edid.h"
 
+extern int useedid;
+
 static void nvidia_gpio_setscl(void *data, int state)
 {
        struct nvidia_i2c_chan *chan = data;
@@ -128,6 +130,9 @@ static int nvidia_setup_i2c_bus(struct nvidia_i2c_chan *chan, const char *name)
 
 void nvidia_create_i2c_busses(struct nvidia_par *par)
 {
+       if (!useedid)
+               return;
+
        par->bus = 3;
 
        par->chan[0].par = par;
@@ -146,6 +151,9 @@ void nvidia_create_i2c_busses(struct nvidia_par *par)
 
 void nvidia_delete_i2c_busses(struct nvidia_par *par)
 {
+       if (!useedid)
+               return;
+
        if (par->chan[0].par)
                i2c_del_adapter(&par->chan[0].adapter);
        par->chan[0].par = NULL;
@@ -195,6 +203,9 @@ static u8 *nvidia_do_probe_i2c_edid(struct nvidia_i2c_chan *chan)
 
 int nvidia_probe_i2c_connector(struct fb_info *info, int conn, u8 **out_edid)
 {
+       if (!useedid)
+               return -1;
+
        struct nvidia_par *par = info->par;
        u8 *edid = NULL;
        int i;
diff --git a/drivers/video/nvidia/nvidia.c b/drivers/video/nvidia/nvidia.c
index 538e947..179fd67 100644
--- a/drivers/video/nvidia/nvidia.c
+++ b/drivers/video/nvidia/nvidia.c
@@ -83,6 +83,9 @@ static int bpp __devinitdata = 8;
 #ifdef CONFIG_MTRR
 static int nomtrr __devinitdata = 0;
 #endif
+#ifdef CONFIG_FB_NVIDIA_I2C
+int useedid __devinitdata = 1;
+#endif
 
 static char *mode_option __devinitdata = NULL;
 
@@ -1506,6 +1509,11 @@ module_param(nomtrr, bool, 0);
 MODULE_PARM_DESC(nomtrr, "Disables MTRR support (0 or 1=disabled) "
                 "(default=0)");
 #endif
+#ifdef CONFIG_FB_NVIDIA_I2C
+module_param(useedid, bool, 0);
+MODULE_PARM_DESC(useedid, "Use EDID to detect video modes (0 or 1) "
+                "(default=1, use EDID)");
+#endif
 
 MODULE_AUTHOR("Antonino Daplas");
 MODULE_DESCRIPTION("Framebuffer driver for nVidia graphics chipset");




-- 
Giuseppe "Oblomov" Bilotta

