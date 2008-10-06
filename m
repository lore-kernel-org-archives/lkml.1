Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063AbYJFRQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbYJFRQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYJFRQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:16:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43880 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550AbYJFRP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:15:59 -0400
From: "Castaneda Gonzalez, Axel" <x0055901@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 6 Oct 2008 12:15:52 -0500
Subject: [PATCH 02/02] [omapzoom]ARM-OMAP3-Automatic_TV_detection
Thread-Topic: [PATCH 02/02] [omapzoom]ARM-OMAP3-Automatic_TV_detection
Thread-Index: Ackk3Pcb6PUraA8ET9K+GSK3NlQoYAAzjqVwAAY7sZAAhDcsMAAAgvpw
Message-ID: <70ABD7B1D427A94DA659B4C84B0F5D4A50B6D427@dlee06.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Castaneda Gonzalez<x0055901@ti.com>

ARM: OMAP3: Automatic TV detection

This patch provides automatic TV detection support
on omapzoom display driver. When a stream is run on 
video1, video2 is automatically linked and displayed on TV.

User can enable or disable this bind to TV, through the 
use of /sys/class/display_control/omap_disp_control/tv_state,
automatic detection/switching is only enabled when this sysfs 
entry is populated with 1 and a TV is connected to S-Video port.

Signed-off-by: Axel Castaneda Gonzalez<x0055901@ti.com>
---
 media/video/omap/omap24xxvout.c    |  139 ++++++++++++++++++++++++++++++++++++-
 media/video/omap/omap24xxvoutdef.h |    6 +
 video/omap/omap_disp_out.c         |   36 ++++++++-
 3 files changed, 173 insertions(+), 8 deletions(-)

Index: git-ti-omap34tree/drivers/media/video/omap/omap24xxvout.c
===================================================================
--- git-ti-omap34tree.orig/drivers/media/video/omap/omap24xxvout.c
+++ git-ti-omap34tree/drivers/media/video/omap/omap24xxvout.c
@@ -134,6 +134,7 @@ static int rotation_support = -1;
 #define SMS_RGB_PIXSIZE		2
 #define SMS_YUYV_PIXSIZE	4
 #define VRFB_TX_TIMEOUT		1000
+#define AUTO_VIDEO_LINK		2
 
 #ifdef CONFIG_FB_OMAP_720P_STREAMING
 #define VID_MAX_WIDTH		HD_720P_WIDTH  /* Largest width */
@@ -143,6 +144,8 @@ static int rotation_support = -1;
 #define VID_MAX_HEIGHT		WVGA_SQUARE_HEIGHT_R90 /* Largest height */
 #endif
 
+static int prev_output_dev = -1;
+
 static struct omap24xxvout_device *saved_v1out, *saved_v2out;
 
 #define STREAMING_IS_ON()	((saved_v1out && saved_v1out->streaming) || \
@@ -156,6 +159,7 @@ static struct omap24xxvout_device *saved
  */
 
 static int vout_linked;
+int tv_state;
 static spinlock_t vout_link_lock;
 
 static struct videobuf_queue_ops dummy_vbq_ops;
@@ -315,6 +319,112 @@ omap24xxvout_sync (struct omap24xxvout_d
 			dest->rotation, dest->mirror);
 }
 
+void omap24xxvout_set_link(struct omap24xxvout_device *vout, int link_status)
+{
+
+	int *link = &link_status;
+	spin_lock(&vout_link_lock);
+	if ((*link == 0) && (vout_linked == vout->vid))
+		vout_linked = -1;
+
+	omap2_disp_get_dss();
+
+	if ((*link == 1) && (vout_linked == -1 || vout_linked == vout->vid)) {
+		vout_linked = 2;
+		if (vout_linked == OMAP2_VIDEO2) {
+			/* sync V2 to V1 for img and crop */
+			omap24xxvout_sync(saved_v2out, saved_v1out);
+		} else {
+			/* sync V1 to V2 */
+			omap24xxvout_sync(saved_v1out, saved_v2out);
+		}
+	}
+
+	omap2_disp_put_dss();
+	spin_unlock(&vout_link_lock);
+}
+
+
+int omap24xxvout_streaming_link(struct omap24xxvout_device *vout,
+					struct omap24xxvout_fh *fh) {
+	if (vout->streaming)
+		return -EBUSY;
+
+	vout->streaming = fh;
+	omap2_disp_get_dss();
+
+	omap2_disp_config_vlayer(vout->vid, &vout->pix,
+			&vout->crop, &vout->win, vout->rotation,
+			vout->mirror);
+	omap2_disp_put_dss();
+	return 0;
+}
+
+
+int omap24xxvout_tv_link(void){
+
+	struct omap24xxvout_device *vout = NULL;
+	struct omap24xxvout_fh *fh;
+
+	vout = saved_v2out;
+
+	if (vout == NULL)
+		return -ENODEV;
+
+	/* for now, we only support single open */
+	if (vout->opened)
+		return -EBUSY;
+
+	vout->opened += 1;
+	if (!omap2_disp_request_layer(vout->vid)) {
+		vout->opened -= 1;
+		return -ENODEV;
+	}
+
+	omap2_disp_get_dss();
+
+	/* allocate per-filehandle data */
+	fh = kmalloc(sizeof(*fh), GFP_KERNEL);
+	if (NULL == fh) {
+		omap2_disp_release_layer(vout->vid);
+		omap2_disp_put_dss();
+		vout->opened -= 1;
+		return -ENOMEM;
+	}
+
+	omap2_disp_put_dss();
+
+	omap24xxvout_set_link(vout, 1);
+	omap24xxvout_streaming_link(vout, fh);
+	return 0;
+}
+
+static  int
+omap24xxvout_tv_link_release(void) {
+	struct omap24xxvout_device *vout = saved_v2out;
+
+	omap2_disp_get_dss();
+	vout->streaming = NULL;
+	omap2_disp_disable_layer(vout->vid);
+
+	if ((vout_linked != -1) && (vout->vid != vout_linked))
+		omap2_disp_disable_layer((vout->vid ==
+				OMAP2_VIDEO1) ? OMAP2_VIDEO2 : OMAP2_VIDEO1);
+
+	omap2_disp_release_layer(vout->vid);
+	omap2_disp_put_dss();
+	vout->opened -= 1;
+
+	/* need to remove the link when the either slave or master is gone */
+	spin_lock(&vout_link_lock);
+	omap24xxvout_set_link(vout, 0);
+	if (vout_linked != -1)
+		vout_linked = -1;
+
+	spin_unlock(&vout_link_lock);
+	return 0;
+}
+
 static int
 omap24xxvout_do_ioctl (struct inode *inode, struct file *file,
 		       unsigned int cmd, void *arg)
@@ -1017,10 +1127,25 @@ omap24xxvout_do_ioctl (struct inode *ino
 		int k;
 		if (vout->streaming)
 			return -EBUSY;
-		/* 
-		 * If rotation mode is selected then allocate a 
-		 *  dummy or hidden buffer to map the SMS virtual space 
+
+		if (automatic_link && vout->vid == 1) {
+			tv_state = get_tv_state();
+			if (tv_state) {
+				prev_output_dev =
+					omap2_disp_get_output_dev(
+						AUTO_VIDEO_LINK);
+				if (prev_output_dev != OMAP2_OUTPUT_TV)
+					set_output_device("tv",
+						AUTO_VIDEO_LINK);
+					omap24xxvout_tv_link();
+			}
+		}
+
+		/*
+		 * If rotation mode is selected then allocate a
+		 *  dummy or hidden buffer to map the SMS virtual space
 		 */
+
 		if (vout->vid != vout_linked){
 			if (vout->rotation >= 0){
 				
@@ -1122,6 +1247,13 @@ omap24xxvout_do_ioctl (struct inode *ino
 		 * stop streaming
 		 */
 
+		if (automatic_link && tv_state && vout->vid == 1) {
+			omap24xxvout_tv_link_release();
+			if (prev_output_dev == OMAP2_OUTPUT_LCD) {
+				set_output_device("lcd", AUTO_VIDEO_LINK);
+				prev_output_dev = -1;
+			}
+		}
 		if (vout->streaming == fh){
 			omap2_disp_disable_layer (vout->vid);
 			vout->streaming = NULL;
@@ -2273,6 +2405,7 @@ omap24xxvout_init (void)
 	omap2_disp_save_initstate(OMAP2_VIDEO2);
 	omap2_disp_put_dss();
 
+	tv_state = 0;
 	vout_linked = -1;
 	spin_lock_init (&vout_link_lock);
 	return 0;
Index: git-ti-omap34tree/drivers/video/omap/omap_disp_out.c
===================================================================
--- git-ti-omap34tree.orig/drivers/video/omap/omap_disp_out.c
+++ git-ti-omap34tree/drivers/video/omap/omap_disp_out.c
@@ -195,6 +195,8 @@ struct res_handle * tv_rhandle = NULL;
 static struct spi_device *wvgalcd_spi;
 #endif
 
+int automatic_link;
+
 #ifdef CONFIG_OMAP2_LCD
 static int dvi_in_use; /* dvi output flag */
 static int lcd_in_use;
@@ -981,7 +983,7 @@ lcd_suspend(struct platform_device *odev
        mdelay(40);
 #endif
 	omap2_dss_rgb_disable();
-	
+	automatic_link = 0;
 	return 0;
 }
 
@@ -1862,20 +1864,44 @@ static void disable_tv_detect(void){
 	omap2_disp_put_all_clks();
 }
 
-static ssize_t
-tv_state_show(struct device *dev, struct device_attribute *attr, char *buf) {
+ssize_t
+set_output_device(const char *buffer, int layer) {
+	ssize_t ret;
+	if (strncmp(buffer, "lcd", 3) == 0)
+		ret = write_layer_out("lcd", 3, layer);
+	else  if (strncmp(buffer, "tv", 2) == 0)
+		ret = write_layer_out("tv", 2, layer);
+	else
+		ret = -EINVAL;
+	return  ret;
+}
+EXPORT_SYMBOL(set_output_device);
+
+int
+get_tv_state(void){
 	int tv_state;
+
 	enable_tv_detect();
 	msleep(TV_DETECT_DELAY);
 	tv_state = omap_get_gpio_datain(TV_INT_GPIO);
 	disable_tv_detect();
-	return  sprintf(buf, "%d\n", tv_state);
+	return tv_state;
+}
+EXPORT_SYMBOL(get_tv_state);
+
+static ssize_t
+tv_state_show(struct device *dev, struct device_attribute *attr, char *buf) {
+	return  sprintf(buf, "%d\n", get_tv_state());
 }
 
 static ssize_t
 tv_state_store(struct device *dev, struct device_attribute *attr,
 		const char *buffer, size_t count) {
-	return 0;
+	if (strncmp(buffer, "1", 1) == 0)
+		automatic_link = 1;
+	else if (strncmp(buffer, "0", 1) == 0)
+		automatic_link = 0;
+	return count;
 }
 #endif
 
Index: git-ti-omap34tree/drivers/media/video/omap/omap24xxvoutdef.h
===================================================================
--- git-ti-omap34tree.orig/drivers/media/video/omap/omap24xxvoutdef.h
+++ git-ti-omap34tree/drivers/media/video/omap/omap24xxvoutdef.h
@@ -102,6 +102,7 @@ struct omap24xxvout_fh {
 	struct videobuf_queue vbq;
 };
 
+
 #ifdef CONFIG_ARCH_OMAP34XX
 
 
@@ -174,4 +175,9 @@ struct omap3_aux_disp_fh {
 };
 #endif
 
+/* TV detection autoswitching support */
+	extern int automatic_link;
+	extern int get_tv_state(void);
+	extern ssize_t set_output_device(const char *buffer, int);
+
 #endif	/* ifndef OMAP24XXVOUTDEF_H */
--
