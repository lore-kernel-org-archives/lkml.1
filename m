Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbZFWKgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbZFWKgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZFWKgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:36:36 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:51861 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752609AbZFWKgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:36:35 -0400
Subject: Re: [PATCH] drm: fix edid interlaced bit position
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Jerome Glisse <jglisse@redhat.com>
Cc: airlied@gmail.com, linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
       Michael Pyne <mpyne@kde.org>
In-Reply-To: <1245700718-2015-1-git-send-email-jglisse@redhat.com>
References: <1245700718-2015-1-git-send-email-jglisse@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Jun 2009 12:36:32 +0200
Message-Id: <1245753392.8882.27.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 21:58 +0200, Jerome Glisse wrote: 
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> ---
>  include/drm/drm_edid.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
> index c263e4d..83ea6c9 100644
> --- a/include/drm/drm_edid.h
> +++ b/include/drm/drm_edid.h
> @@ -51,7 +51,7 @@ struct std_timing {
>  #define DRM_EDID_PT_VSYNC_POSITIVE (1 << 5)
>  #define DRM_EDID_PT_SEPARATE_SYNC  (3 << 3)
>  #define DRM_EDID_PT_STEREO         (1 << 2)
> -#define DRM_EDID_PT_INTERLACED     (1 << 1)
> +#define DRM_EDID_PT_INTERLACED     (1 << 7)

That's just the tip of the iceberg... Looks like I managed to mess up
most shifts when converting from bitfields. :(

The patch below works on my Thinkpad T500 (as well as on my PowerBook,
where the previous change worked as well, maybe out of luck...). I'd
appreciate more testing and eyes looking over it though.

Michael, does this fix your problem?


>From dc72583687632e80b2e36a09d9f973a48fe8364e Mon Sep 17 00:00:00 2001
From: =?utf-8?q?Michel=20D=C3=A4nzer?= <daenzer@vmware.com>
Date: Tue, 23 Jun 2009 08:41:50 +0200
Subject: drm: Fix shifts which were miscalculated when converting from bitfields.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Michel Dänzer <daenzer@vmware.com>
---
 drivers/gpu/drm/drm_edid.c |   12 ++++++------
 include/drm/drm_edid.h     |   38 +++++++++++++++++++-------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 7d08352..80cc6d0 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -294,10 +294,10 @@ static struct drm_display_mode *drm_mode_detailed(struct drm_device *dev,
 	unsigned vactive = (pt->vactive_vblank_hi & 0xf0) << 4 | pt->vactive_lo;
 	unsigned hblank = (pt->hactive_hblank_hi & 0xf) << 8 | pt->hblank_lo;
 	unsigned vblank = (pt->vactive_vblank_hi & 0xf) << 8 | pt->vblank_lo;
-	unsigned hsync_offset = (pt->hsync_vsync_offset_pulse_width_hi & 0x3) << 8 | pt->hsync_offset_lo;
-	unsigned hsync_pulse_width = (pt->hsync_vsync_offset_pulse_width_hi & 0xc) << 6 | pt->hsync_pulse_width_lo;
-	unsigned vsync_offset = (pt->hsync_vsync_offset_pulse_width_hi & 0x30) | (pt->vsync_offset_pulse_width_lo & 0xf);
-	unsigned vsync_pulse_width = (pt->hsync_vsync_offset_pulse_width_hi & 0xc0) >> 2 | pt->vsync_offset_pulse_width_lo >> 4;
+	unsigned hsync_offset = (pt->hsync_vsync_offset_pulse_width_hi & 0xc0) << 2 | pt->hsync_offset_lo;
+	unsigned hsync_pulse_width = (pt->hsync_vsync_offset_pulse_width_hi & 0x30) << 4 | pt->hsync_pulse_width_lo;
+	unsigned vsync_offset = (pt->hsync_vsync_offset_pulse_width_hi & 0xc) >> 2 | pt->vsync_offset_pulse_width_lo >> 4;
+	unsigned vsync_pulse_width = (pt->hsync_vsync_offset_pulse_width_hi & 0x3) << 4 | (pt->vsync_offset_pulse_width_lo & 0xf);
 
 	/* ignore tiny modes */
 	if (hactive < 64 || vactive < 64)
@@ -347,8 +347,8 @@ static struct drm_display_mode *drm_mode_detailed(struct drm_device *dev,
 	mode->flags |= (pt->misc & DRM_EDID_PT_VSYNC_POSITIVE) ?
 		DRM_MODE_FLAG_PVSYNC : DRM_MODE_FLAG_NVSYNC;
 
-	mode->width_mm = pt->width_mm_lo | (pt->width_height_mm_hi & 0xf) << 8;
-	mode->height_mm = pt->height_mm_lo | (pt->width_height_mm_hi & 0xf0) << 4;
+	mode->width_mm = pt->width_mm_lo | (pt->width_height_mm_hi & 0xf0) << 4;
+	mode->height_mm = pt->height_mm_lo | (pt->width_height_mm_hi & 0xf) << 8;
 
 	if (quirks & EDID_QUIRK_DETAILED_IN_CM) {
 		mode->width_mm *= 10;
diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
index c263e4d..7d6c9a2 100644
--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -35,11 +35,11 @@ struct est_timings {
 } __attribute__((packed));
 
 /* 00=16:10, 01=4:3, 10=5:4, 11=16:9 */
-#define EDID_TIMING_ASPECT_SHIFT 0
+#define EDID_TIMING_ASPECT_SHIFT 6
 #define EDID_TIMING_ASPECT_MASK  (0x3 << EDID_TIMING_ASPECT_SHIFT)
 
 /* need to add 60 */
-#define EDID_TIMING_VFREQ_SHIFT  2
+#define EDID_TIMING_VFREQ_SHIFT  0
 #define EDID_TIMING_VFREQ_MASK   (0x3f << EDID_TIMING_VFREQ_SHIFT)
 
 struct std_timing {
@@ -47,11 +47,11 @@ struct std_timing {
 	u8 vfreq_aspect;
 } __attribute__((packed));
 
-#define DRM_EDID_PT_HSYNC_POSITIVE (1 << 6)
-#define DRM_EDID_PT_VSYNC_POSITIVE (1 << 5)
+#define DRM_EDID_PT_HSYNC_POSITIVE (1 << 1)
+#define DRM_EDID_PT_VSYNC_POSITIVE (1 << 2)
 #define DRM_EDID_PT_SEPARATE_SYNC  (3 << 3)
-#define DRM_EDID_PT_STEREO         (1 << 2)
-#define DRM_EDID_PT_INTERLACED     (1 << 1)
+#define DRM_EDID_PT_STEREO         (1 << 5)
+#define DRM_EDID_PT_INTERLACED     (1 << 7)
 
 /* If detailed data is pixel timing */
 struct detailed_pixel_timing {
@@ -93,7 +93,7 @@ struct detailed_data_monitor_range {
 } __attribute__((packed));
 
 struct detailed_data_wpindex {
-	u8 white_xy_lo; /* Upper 2 bits each */
+	u8 white_yx_lo; /* Lower 2 bits each */
 	u8 white_x_hi;
 	u8 white_y_hi;
 	u8 gamma; /* need to divide by 100 then add 1 */
@@ -135,21 +135,21 @@ struct detailed_timing {
 	} data;
 } __attribute__((packed));
 
-#define DRM_EDID_INPUT_SERRATION_VSYNC (1 << 7)
-#define DRM_EDID_INPUT_SYNC_ON_GREEN   (1 << 5)
-#define DRM_EDID_INPUT_COMPOSITE_SYNC  (1 << 4)
+#define DRM_EDID_INPUT_SERRATION_VSYNC (1 << 0)
+#define DRM_EDID_INPUT_SYNC_ON_GREEN   (1 << 1)
+#define DRM_EDID_INPUT_COMPOSITE_SYNC  (1 << 2)
 #define DRM_EDID_INPUT_SEPARATE_SYNCS  (1 << 3)
-#define DRM_EDID_INPUT_BLANK_TO_BLACK  (1 << 2)
-#define DRM_EDID_INPUT_VIDEO_LEVEL     (3 << 1)
-#define DRM_EDID_INPUT_DIGITAL         (1 << 0) /* bits above must be zero if set */
+#define DRM_EDID_INPUT_BLANK_TO_BLACK  (1 << 4)
+#define DRM_EDID_INPUT_VIDEO_LEVEL     (3 << 5)
+#define DRM_EDID_INPUT_DIGITAL         (1 << 7) /* bits below must be zero if set */
 
-#define DRM_EDID_FEATURE_DEFAULT_GTF      (1 << 7)
-#define DRM_EDID_FEATURE_PREFERRED_TIMING (1 << 6)
-#define DRM_EDID_FEATURE_STANDARD_COLOR   (1 << 5)
+#define DRM_EDID_FEATURE_DEFAULT_GTF      (1 << 0)
+#define DRM_EDID_FEATURE_PREFERRED_TIMING (1 << 1)
+#define DRM_EDID_FEATURE_STANDARD_COLOR   (1 << 2)
 #define DRM_EDID_FEATURE_DISPLAY_TYPE     (3 << 3) /* 00=mono, 01=rgb, 10=non-rgb, 11=unknown */
-#define DRM_EDID_FEATURE_PM_ACTIVE_OFF    (1 << 2)
-#define DRM_EDID_FEATURE_PM_SUSPEND       (1 << 1)
-#define DRM_EDID_FEATURE_PM_STANDBY       (1 << 0)
+#define DRM_EDID_FEATURE_PM_ACTIVE_OFF    (1 << 5)
+#define DRM_EDID_FEATURE_PM_SUSPEND       (1 << 6)
+#define DRM_EDID_FEATURE_PM_STANDBY       (1 << 7)
 
 struct edid {
 	u8 header[8];
-- 
1.6.3.1



-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
