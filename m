Return-Path: <linux-kernel-owner+w=401wt.eu-S1751800AbXBEQxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbXBEQxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 11:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbXBEQxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 11:53:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:18072 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbXBEQxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 11:53:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=lzczeJJODFCorTOtCEnMaW3nCWumLmKPX4U9Lv2rv2vUh677LXqa2XC+kSUyGWPps6y5ffbvh63rviwnOUxRK4Msrcwk2iBpFpsX6kvvzpoC/JKrwbe11XJSSMCVk9EHf1Az7vskISo8A81J4FunCCZIVHh6iWxwUipqzUmenNY=
Date: Mon, 5 Feb 2007 18:53:33 +0200
To: pvrusb2@isely.net
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20] pvrusb2: use ARRAY_SIZE macro when appropriate (2)
Message-ID: <20070205165333.GB3896@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205165134.GA3896@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
A patch to use ARRAY_SIZE already defined in kernel.h. This patch is
a complementry (and does not include) the one sent one week earlier.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
It seems that the earlier grep expression I used to produce the first
patch didn't catch the below occurences. Sorry for the incovenience.

Patch is compile tested.

diff --git a/drivers/media/video/pvrusb2/pvrusb2-audio.c b/drivers/media/video/pvrusb2/pvrusb2-audio.c
index 9846c46..4a32fa2 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-audio.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-audio.c
@@ -24,6 +24,7 @@
 #include "pvrusb2-hdw-internal.h"
 #include "pvrusb2-debug.h"
 #include <linux/videodev2.h>
+#include <linux/kernel.h>
 #include <media/msp3400.h>
 #include <media/v4l2-common.h>
 
@@ -99,8 +100,7 @@ static int msp3400_check(struct pvr2_msp3400_handler *ctxt)
 	unsigned long msk;
 	unsigned int idx;
 
-	for (idx = 0; idx < sizeof(msp3400_ops)/sizeof(msp3400_ops[0]);
-	     idx++) {
+	for (idx = 0; idx < ARRAY_SIZE(msp3400_ops); idx++) {
 		msk = 1 << idx;
 		if (ctxt->stale_mask & msk) continue;
 		if (msp3400_ops[idx].check(ctxt)) {
@@ -116,8 +116,7 @@ static void msp3400_update(struct pvr2_msp3400_handler *ctxt)
 	unsigned long msk;
 	unsigned int idx;
 
-	for (idx = 0; idx < sizeof(msp3400_ops)/sizeof(msp3400_ops[0]);
-	     idx++) {
+	for (idx = 0; idx < ARRAY_SIZE(msp3400_ops); idx++) {
 		msk = 1 << idx;
 		if (!(ctxt->stale_mask & msk)) continue;
 		ctxt->stale_mask &= ~msk;
@@ -183,8 +182,7 @@ int pvr2_i2c_msp3400_setup(struct pvr2_hdw *hdw,struct pvr2_i2c_client *cp)
 	ctxt->astat.ctxt = ctxt;
 	ctxt->astat.status = (int (*)(void *))get_audio_status;
 	ctxt->astat.detach = (void (*)(void *))pvr2_msp3400_detach;
-	ctxt->stale_mask = (1 << (sizeof(msp3400_ops)/
-				  sizeof(msp3400_ops[0]))) - 1;
+	ctxt->stale_mask = (1 << ARRAY_SIZE(msp3400_ops)) - 1;
 	cp->handler = &ctxt->i2c_handler;
 	hdw->audio_stat = &ctxt->astat;
 	pvr2_trace(PVR2_TRACE_CHIPS,"i2c 0x%x msp3400 V4L2 handler set up",
diff --git a/drivers/media/video/pvrusb2/pvrusb2-ctrl.c b/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
index c77de85..22b128c 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-ctrl.c
@@ -24,7 +24,7 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/mutex.h>
-
+#include <linux/kernel.h>
 
 /* Set the given control. */
 int pvr2_ctrl_set_value(struct pvr2_ctrl *cptr,int val)
@@ -507,7 +507,7 @@ int pvr2_ctrl_sym_to_value(struct pvr2_ctrl *cptr,
 		} else if (cptr->info->type == pvr2_ctl_bool) {
 			ret = parse_token(
 				ptr,len,valptr,boolNames,
-				sizeof(boolNames)/sizeof(boolNames[0]));
+				ARRAY_SIZE(boolNames));
 			if (ret == 1) {
 				*valptr = *valptr ? !0 : 0;
 			} else if (ret == 0) {
diff --git a/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c b/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c
index 848fb23..e85daf6 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c
@@ -39,6 +39,7 @@
 #include <media/v4l2-common.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <linux/kernel.h>
 
 struct pvr2_v4l_cx2584x {
 	struct pvr2_i2c_handler handler;
@@ -150,8 +151,7 @@ static int decoder_check(struct pvr2_v4l_cx2584x *ctxt)
 	unsigned long msk;
 	unsigned int idx;
 
-	for (idx = 0; idx < sizeof(decoder_ops)/sizeof(decoder_ops[0]);
-	     idx++) {
+	for (idx = 0; idx < ARRAY_SIZE(decoder_ops); idx++) {
 		msk = 1 << idx;
 		if (ctxt->stale_mask & msk) continue;
 		if (decoder_ops[idx].check(ctxt)) {
@@ -167,8 +167,7 @@ static void decoder_update(struct pvr2_v4l_cx2584x *ctxt)
 	unsigned long msk;
 	unsigned int idx;
 
-	for (idx = 0; idx < sizeof(decoder_ops)/sizeof(decoder_ops[0]);
-	     idx++) {
+	for (idx = 0; idx < ARRAY_SIZE(decoder_ops); idx++) {
 		msk = 1 << idx;
 		if (!(ctxt->stale_mask & msk)) continue;
 		ctxt->stale_mask &= ~msk;
@@ -256,8 +255,7 @@ int pvr2_i2c_cx2584x_v4l_setup(struct pvr2_hdw *hdw,
 	ctxt->ctrl.force_reset = (void (*)(void*))decoder_reset;
 	ctxt->client = cp;
 	ctxt->hdw = hdw;
-	ctxt->stale_mask = (1 << (sizeof(decoder_ops)/
-				  sizeof(decoder_ops[0]))) - 1;
+	ctxt->stale_mask = (1 << ARRAY_SIZE(decoder_ops)) - 1;
 	hdw->decoder_ctrl = &ctxt->ctrl;
 	cp->handler = &ctxt->handler;
 	{
diff --git a/drivers/media/video/pvrusb2/pvrusb2-debugifc.c b/drivers/media/video/pvrusb2/pvrusb2-debugifc.c
index f985f00..0f32772 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-debugifc.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-debugifc.c
@@ -21,6 +21,7 @@
 
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/kernel.h>
 #include "pvrusb2-debugifc.h"
 #include "pvrusb2-hdw.h"
 #include "pvrusb2-debug.h"
@@ -152,7 +153,7 @@ static unsigned long debugifc_find_mask(const char *buf,unsigned int count)
 {
 	struct debugifc_mask_item *mip;
 	unsigned int idx;
-	for (idx = 0; idx < sizeof(mask_items)/sizeof(mask_items[0]); idx++) {
+	for (idx = 0; idx < ARRAY_SIZE(mask_items); idx++) {
 		mip = mask_items + idx;
 		if (debugifc_match_keyword(buf,count,mip->name)) {
 			return mip->msk;
@@ -169,7 +170,7 @@ static int debugifc_print_mask(char *buf,unsigned int sz,
 	unsigned int idx;
 	int bcnt = 0;
 	int ccnt;
-	for (idx = 0; idx < sizeof(mask_items)/sizeof(mask_items[0]); idx++) {
+	for (idx = 0; idx < ARRAY_SIZE(mask_items); idx++) {
 		mip = mask_items + idx;
 		if (!(mip->msk & msk)) continue;
 		ccnt = scnprintf(buf,sz,"%s%c%s",
diff --git a/drivers/media/video/pvrusb2/pvrusb2-eeprom.c b/drivers/media/video/pvrusb2/pvrusb2-eeprom.c
index 6cff8e7..b64ebc2 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-eeprom.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-eeprom.c
@@ -20,6 +20,7 @@
  *
  */
 
+#include <linux/kernel.h>
 #include "pvrusb2-eeprom.h"
 #include "pvrusb2-hdw-internal.h"
 #include "pvrusb2-debug.h"
@@ -104,7 +105,7 @@ static u8 *pvr2_eeprom_fetch(struct pvr2_hdw *hdw)
 		msg[1].buf = eeprom+tcnt;
 		if ((ret = i2c_transfer(
 			     &hdw->i2c_adap,
-			     msg,sizeof(msg)/sizeof(msg[0]))) != 2) {
+			     msg,ARRAY_SIZE(msg))) != 2) {
 			pvr2_trace(PVR2_TRACE_ERROR_LEGS,
 				   "eeprom fetch set offs err=%d",ret);
 			kfree(eeprom);
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index d200496..1b3b042 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/firmware.h>
@@ -604,7 +605,7 @@ static void ctrl_stdenumcur_clear_dirty(struct pvr2_ctrl *cptr)
 
 #define DEFENUM(tab) \
 	.type = pvr2_ctl_enum, \
-	.def.type_enum.count = (sizeof(tab)/sizeof((tab)[0])), \
+	.def.type_enum.count = ARRAY_SIZE(tab), \
 	.def.type_enum.value_names = tab
 
 #define DEFBOOL \

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
