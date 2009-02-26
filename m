Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbZBZRXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbZBZRXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 12:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbZBZRXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 12:23:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36819 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbZBZRXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 12:23:31 -0500
Date: Thu, 26 Feb 2009 12:23:27 -0500
From: Kyle McMartin <kyle@infradead.org>
To: airlied@redhat.com
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: [PATCH] drm: edid: don't fail to build on big endian
Message-ID: <20090226172327.GN6690@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Currently, DRM only accidently builds on powerpc/sparc64/etc, because
the #ifdef in drm_edid.h was using BIG_ENDIAN instead of __BIG_ENDIAN.

Since there's currently no driver which can use this on powerpc at the
moment (radeon modesetting is not upstream yet...) instead of failing to
build the entire DRM because of it, just bail out in the individual
EDID functions.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

---
I'll try update the drm_edid.h header to properly handle big endian, but
since I'm lacking a powerpc box at the moment, and I can't currently
test the DRM on parisc, someone else will have to test it for me. :)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index a839a28..3357394 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -551,6 +551,7 @@ static int add_detailed_info(struct drm_connector *connector,
 
 #define DDC_ADDR 0x50
 
+#ifdef __LITTLE_ENDIAN
 unsigned char *drm_do_probe_ddc_edid(struct i2c_adapter *adapter)
 {
 	unsigned char start = 0x0;
@@ -582,6 +583,13 @@ unsigned char *drm_do_probe_ddc_edid(struct i2c_adapter *adapter)
 	kfree(buf);
 	return NULL;
 }
+#else
+unsigned char *drm_do_probe_ddc_edid(struct i2c_adapter *adapter)
+{
+	dev_info(&adapter->dev, "EDID unsupported on big endian.\n");
+	return NULL;
+}
+#endif /*__BIG_ENDIAN*/
 EXPORT_SYMBOL(drm_do_probe_ddc_edid);
 
 static unsigned char *drm_ddc_read(struct i2c_adapter *adapter)
@@ -653,6 +661,7 @@ static unsigned char *drm_ddc_read(struct i2c_adapter *adapter)
  *
  * Return edid data or NULL if we couldn't find any.
  */
+#ifdef __LITTLE_ENDIAN
 struct edid *drm_get_edid(struct drm_connector *connector,
 			  struct i2c_adapter *adapter)
 {
@@ -675,6 +684,15 @@ struct edid *drm_get_edid(struct drm_connector *connector,
 
 	return edid;
 }
+#else
+struct edid *drm_get_edid(struct drm_connector *connector,
+			  struct i2c_adapter *adapter)
+{
+	dev_warn(&connector->dev->pdev->dev, "%s: EDID unsupported on big endian.\n",
+		drm_get_connector_name(connector));
+	return NULL;
+}
+#endif /*__BIG_ENDIAN*/
 EXPORT_SYMBOL(drm_get_edid);
 
 /**
@@ -686,6 +704,7 @@ EXPORT_SYMBOL(drm_get_edid);
  *
  * Return number of modes added or 0 if we couldn't find any.
  */
+#ifdef __LITTLE_ENDIAN
 int drm_add_edid_modes(struct drm_connector *connector, struct edid *edid)
 {
 	int num_modes = 0;
@@ -729,4 +748,12 @@ int drm_add_edid_modes(struct drm_connector *connector, struct edid *edid)
 
 	return num_modes;
 }
+#else
+int drm_add_edid_modes(struct drm_connector *connector, struct edid *edid)
+{
+	dev_warn(&connector->dev->pdev->dev, "%s: EDID unsupported on big endian.\n",
+		 drm_get_connector_name(connector));
+	return 0;
+}
+#endif /*__BIG_ENDIAN*/
 EXPORT_SYMBOL(drm_add_edid_modes);
diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
index ff8d27a..244133b 100644
--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -28,10 +28,6 @@
 #define EDID_LENGTH 128
 #define DDC_ADDR 0x50
 
-#ifdef BIG_ENDIAN
-#error "EDID structure is little endian, need big endian versions"
-#else
-
 struct est_timings {
 	u8 t1;
 	u8 t2;
