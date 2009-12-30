Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbZL3BWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbZL3BWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZL3BV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:21:59 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:44835 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZL3BV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:21:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MkP+0tnwxPGyLOWMSQAZV3DuyEYjqnJziickNbjA5D1tdARnAKc4MoKgxafyxerQM2
         YeZIX5SNTPoD50H+6HzSHtxyIK+vDvXQbD1hQzgPMhvEY+sgGyYSl9cD94WIQx3UE9lC
         yt8n9SDCTVuOlJCEWeLPfkwelhul2/rE0924o=
Subject: [PATCH] drm/radeon: fix a couple of array index errors
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 12:21:52 +1100
Message-ID: <1262136112.8733.29.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple of array overruns, and some associated confusion in
the code. 
This is just a wild guess at what the code should actually look like.

Coverity CID: 13305 13306


Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>

diff --git drivers/gpu/drm/radeon/radeon_legacy_tv.c drivers/gpu/drm/radeon/radeon_legacy_tv.c
index 3a12bb0..c37535a 100644
--- drivers/gpu/drm/radeon/radeon_legacy_tv.c
+++ drivers/gpu/drm/radeon/radeon_legacy_tv.c
@@ -112,6 +112,8 @@ static const uint16_t vert_timing_NTSC[] = {
 	0x1817,
 	0x21d4,
 	0x0002,
+	0x0000,
+	0x0000,
 	0
 };
 
@@ -623,9 +625,9 @@ void radeon_legacy_tv_mode_set(struct drm_encoder *encoder,
 	}
 	flicker_removal = (tmp + 500) / 1000;
 
-	if (flicker_removal < 3)
-		flicker_removal = 3;
-	for (i = 0; i < 6; ++i) {
+	if (flicker_removal < 2)
+		flicker_removal = 2;
+	for (i = 0; i < ARRAY_SIZE(SLOPE_limit); ++i) {
 		if (flicker_removal == SLOPE_limit[i])
 			break;
 	}
diff --git drivers/gpu/drm/radeon/radeon_mode.h drivers/gpu/drm/radeon/radeon_mode.h
index 402369d..abee9a9 100644
--- drivers/gpu/drm/radeon/radeon_mode.h
+++ drivers/gpu/drm/radeon/radeon_mode.h
@@ -218,8 +218,8 @@ struct radeon_mode_info {
 
 };
 
-#define MAX_H_CODE_TIMING_LEN 32
-#define MAX_V_CODE_TIMING_LEN 32
+#define MAX_H_CODE_TIMING_LEN 16
+#define MAX_V_CODE_TIMING_LEN 16
 
 /* need to store these as reading
    back code tables is excessive */


