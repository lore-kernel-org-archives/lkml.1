Return-Path: <linux-kernel-owner+w=401wt.eu-S1761245AbXEQWcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761245AbXEQWcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757290AbXEQWco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:32:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:65237 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756921AbXEQWco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:32:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,550,1170662400"; 
   d="scan'208";a="229291010"
From: Jesse Barnes <jesse.barnes@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] allow console unregistration
Date: Thu, 17 May 2007 15:32:28 -0700
User-Agent: KMail/1.9.6
Cc: "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       "Jakob Bornecrantz" <wallbraker@gmail.com>,
       dri-devel@lists.sourceforge.net
References: <200705171423.46748.jesse.barnes@intel.com>
In-Reply-To: <200705171423.46748.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171532.28799.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy just informed me that the patch limits are bigger now, so here are the
actual patches.

This patch allows for proper console unregistration via the VT layer, and
updates the FB layer to use it.  This makes debugging new console drivers
much easier, since you can properly clean them up before unloading.
Antonio already checked it out (and suggested a tweak for the fbcon side)
so I think it's on its way already via the FB tree.

Jesse

--- linux-2.6.21-rc4/drivers/video/fbmem.c	2007-03-15 17:20:01.000000000 -0700
+++ linux-2.6.21-rc4-modesetting/drivers/video/fbmem.c	2007-04-26 18:16:52.000000000 -0700
@@ -1349,6 +1349,8 @@
 	if (!registered_fb[i])
 		return -EINVAL;
 
+	event.info = fb_info;
+	fb_notifier_call_chain(FB_EVENT_FB_UNBIND, &event);
 	if (fb_info->pixmap.addr &&
 	    (fb_info->pixmap.flags & FB_PIXMAP_DEFAULT))
 		kfree(fb_info->pixmap.addr);
--- linux-2.6.21-rc4/include/linux/fb.h	2007-03-15 17:20:01.000000000 -0700
+++ linux-2.6.21-rc4-modesetting/include/linux/fb.h	2007-04-26 17:33:07.000000000 -0700
@@ -525,6 +525,8 @@
 #define FB_EVENT_MODE_CHANGE_ALL	0x0B
 /*	A software display blank change occured */
 #define FB_EVENT_CONBLANK               0x0C
+/*      Unbind from the console if possible */
+#define FB_EVENT_FB_UNBIND              0x0E
 
 struct fb_event {
 	struct fb_info *info;
--- linux-2.6.21-rc4/include/linux/console.h	2007-03-15 17:20:01.000000000 -0700
+++ linux-2.6.21-rc4-modesetting/include/linux/console.h	2007-04-26 17:56:31.000000000 -0700
@@ -64,6 +64,7 @@
 extern const struct consw newport_con;	/* SGI Newport console  */
 extern const struct consw prom_con;	/* SPARC PROM console */
 
+int unbind_con_driver(const struct consw *csw, int first, int last, int deflt);
 int con_is_bound(const struct consw *csw);
 int register_con_driver(const struct consw *csw, int first, int last);
 int unregister_con_driver(const struct consw *csw);
--- linux-2.6.21-rc4/drivers/video/console/fbcon.c	2007-03-15 17:20:01.000000000 -0700
+++ linux-2.6.21-rc4-modesetting/drivers/video/console/fbcon.c	2007-04-26 18:15:49.000000000 -0700
@@ -563,8 +563,10 @@
 	for (i = first_fb_vc; i <= last_fb_vc; i++)
 		con2fb_map[i] = info_idx;
 
+	printk(KERN_ERR "calling take_over_console, return value: ");
 	err = take_over_console(&fb_con, first_fb_vc, last_fb_vc,
 				fbcon_is_default);
+	printk(KERN_ERR "%d\n", err);
 
 	if (err) {
 		for (i = first_fb_vc; i <= last_fb_vc; i++) {
@@ -2896,6 +2898,13 @@
 	return found;
 }
 
+static int fbcon_fb_unbind(int idx)
+{
+	unbind_con_driver(&fb_con, 0, MAX_NR_CONSOLES - 1, 0);
+
+	return 0;
+}
+
 static int fbcon_fb_unregistered(int idx)
 {
 	int i;
@@ -2933,6 +2942,7 @@
 {
 	int ret = 0, i;
 
+	printk(KERN_ERR "fbcon registration called\n");
 	if (info_idx == -1) {
 		for (i = first_fb_vc; i <= last_fb_vc; i++) {
 			if (con2fb_map_boot[i] == idx) {
@@ -2941,8 +2951,10 @@
 			}
 		}
 
-		if (info_idx != -1)
+		if (info_idx != -1) {
+			printk(KERN_ERR "fb taking over console\n");
 			ret = fbcon_takeover(1);
+		}
 	} else {
 		for (i = first_fb_vc; i <= last_fb_vc; i++) {
 			if (con2fb_map_boot[i] == idx &&
@@ -3036,6 +3048,9 @@
 		mode = event->data;
 		ret = fbcon_mode_deleted(info, mode);
 		break;
+	case FB_EVENT_FB_UNBIND:
+		ret = fbcon_fb_unbind(info->node);
+		break;
 	case FB_EVENT_FB_REGISTERED:
 		ret = fbcon_fb_registered(info->node);
 		break;
--- linux-2.6.21-rc4/drivers/char/vt.c	2007-03-15 17:20:01.000000000 -0700
+++ linux-2.6.21-rc4-modesetting/drivers/char/vt.c	2007-04-26 18:22:42.000000000 -0700
@@ -2832,8 +2832,24 @@
 	return retval;
 }
 
-static int unbind_con_driver(const struct consw *csw, int first, int last,
-			     int deflt)
+/**
+ * unbind_con_driver - unbind a console driver
+ * @csw: pointer to console driver to unregister
+ * @first: first in range of consoles that @csw should be unbound from
+ * @last: last in range of consoles that @csw should be unbound from
+ * @deflt: should next bound console driver be default after @csw is unbound?
+ * 
+ * To unbind a driver from all possible consoles, pass 0 as @first and
+ * %MAX_NR_CONSOLES as @last.
+ *
+ * @deflt controls whether the console that ends up replacing @csw should be
+ * the default console.
+ *
+ * RETURNS:
+ * -ENODEV if @csw isn't a registered console driver or can't be unregistered
+ * or 0 on success.
+ */
+int unbind_con_driver(const struct consw *csw, int first, int last, int deflt)
 {
 	struct module *owner = csw->owner;
 	const struct consw *defcsw = NULL;
@@ -2918,6 +2934,7 @@
 	return retval;
 
 }
+EXPORT_SYMBOL(unbind_con_driver);
 
 static int vt_bind(struct con_driver *con)
 {
