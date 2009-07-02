Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbZGBWwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbZGBWwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbZGBWwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:52:34 -0400
Received: from smtp-out-077.synserver.de ([212.40.180.77]:1035 "HELO
	smtp-out-036.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753287AbZGBWwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:52:34 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2009 18:52:32 EDT
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 29629
From: Lars-Peter Clausen <lars@metafoo.de>
To: broonie@opensource.wolfsonmicro.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] ASoC: Fix wm8753 register cache size and initialization
Date: Fri,  3 Jul 2009 00:46:08 +0200
Message-Id: <1246574768-11447-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The register cache size is of by one. There are 63 registers in use but the
register cache size has only space for 62.
Furthermore the codec's reg_cache_size is of by another one. Since the wm8753
register cache uses one-based indexing we have to add one to its size.

Register cache initialization only copied the first sizeof(void*) elements leaving the others
uninitialized. Fix it by using the size of the reg cache template.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/wm8753.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8753.c b/sound/soc/codecs/wm8753.c
index d28eeac..18a3ef9 100644
--- a/sound/soc/codecs/wm8753.c
+++ b/sound/soc/codecs/wm8753.c
@@ -79,7 +79,7 @@ static const u16 wm8753_reg[] = {
 	0x0097, 0x0097, 0x0000, 0x0004,
 	0x0000, 0x0083, 0x0024, 0x01ba,
 	0x0000, 0x0083, 0x0024, 0x01ba,
-	0x0000, 0x0000
+	0x0000, 0x0000, 0x0000
 };
 
 /* codec private data */
@@ -1660,11 +1660,11 @@ static int wm8753_register(struct wm8753_priv *wm8753)
 	codec->set_bias_level = wm8753_set_bias_level;
 	codec->dai = wm8753_dai;
 	codec->num_dai = 2;
-	codec->reg_cache_size = ARRAY_SIZE(wm8753->reg_cache);
+	codec->reg_cache_size = ARRAY_SIZE(wm8753->reg_cache) + 1;
 	codec->reg_cache = &wm8753->reg_cache;
 	codec->private_data = wm8753;
 
-	memcpy(codec->reg_cache, wm8753_reg, sizeof(codec->reg_cache));
+	memcpy(codec->reg_cache, wm8753_reg, sizeof(wm8753_reg));
 	INIT_DELAYED_WORK(&codec->delayed_work, wm8753_work);
 
 	ret = wm8753_reset(codec);
-- 
1.5.6.5

