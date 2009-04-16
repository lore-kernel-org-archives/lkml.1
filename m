Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbZDPU56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbZDPU56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZDPU5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:57:48 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:34151 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbZDPU5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:57:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Fr32zZqKOVTP9lOQrMSPAv3SGWnMTwDEy3+fawV29QFKnJhxgf4v6JWfvK39m1XTFi
         RWv6EN26bRZC75eyswtnFAthwKhChK3dlsRA7PMiWULicAwCV1JQL3tgXzuhWWI/DZCI
         pPQH7NK1pYOGmYVoKgWfu77XC9EdyL9NInw7w=
Message-ID: <49E79BCA.70703@gmail.com>
Date: Thu, 16 Apr 2009 22:57:46 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: airlied@linux.ie, thomas@shipmail.org, dri-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] drm: count reaches -1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I previously sent this patch, was it lost?
------------------------------>8-------------8<---------------------------------
With a postfix decrement in the test count will reach -1 rather than 0,
subsequent tests fail.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/gpu/drm/via/via_dma.c b/drivers/gpu/drm/via/via_dma.c
index 7a339db..bfb92d2 100644
--- a/drivers/gpu/drm/via/via_dma.c
+++ b/drivers/gpu/drm/via/via_dma.c
@@ -481,11 +481,13 @@ static int via_wait_idle(drm_via_private_t * dev_priv)
 {
 	int count = 10000000;
 
-	while (!(VIA_READ(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY) && count--);
+	while (!(VIA_READ(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY) && --count)
+		;
 
-	while (count-- && (VIA_READ(VIA_REG_STATUS) &
+	while (count && (VIA_READ(VIA_REG_STATUS) &
 			   (VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY |
-			    VIA_3D_ENG_BUSY))) ;
+			    VIA_3D_ENG_BUSY)))
+		--count;
 	return count;
 }
 
@@ -705,7 +707,7 @@ static int via_cmdbuf_size(struct drm_device *dev, void *data, struct drm_file *
 	switch (d_siz->func) {
 	case VIA_CMDBUF_SPACE:
 		while (((tmp_size = via_cmdbuf_space(dev_priv)) < d_siz->size)
-		       && count--) {
+		       && --count) {
 			if (!d_siz->wait) {
 				break;
 			}
@@ -717,7 +719,7 @@ static int via_cmdbuf_size(struct drm_device *dev, void *data, struct drm_file *
 		break;
 	case VIA_CMDBUF_LAG:
 		while (((tmp_size = via_cmdbuf_lag(dev_priv)) > d_siz->size)
-		       && count--) {
+		       && --count) {
 			if (!d_siz->wait) {
 				break;
 			}
