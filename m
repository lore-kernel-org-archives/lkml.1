Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270Ab0AEAyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab0AEAyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411Ab0AEAyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:54:15 -0500
Received: from kroah.org ([198.145.64.141]:34139 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab0AEAew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:52 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Eric Millbrandt <emillbrandt@dekaresearch.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/97] ASoC: Do not write to invalid registers on the wm9712.
Date: Mon,  4 Jan 2010 16:32:31 -0800
Message-Id: <1262651630-7354-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Millbrandt <emillbrandt@dekaresearch.com>

commit 48e3cbb3f67a27d9c2db075f3d0f700246c40caa upstream.

This patch fixes a bug where "virtual" registers were being written to the ac97
bus.  This was causing unrelated registers to become corrupted (headphone 0x04,
touchscreen 0x78, etc).

This patch duplicates protection that was included in the wm9713 driver.

Signed-off-by: Eric Millbrandt <emillbrandt@dekaresearch.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/soc/codecs/wm9712.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm9712.c b/sound/soc/codecs/wm9712.c
index 1fd4e88..e9123f5 100644
--- a/sound/soc/codecs/wm9712.c
+++ b/sound/soc/codecs/wm9712.c
@@ -464,7 +464,8 @@ static int ac97_write(struct snd_soc_codec *codec, unsigned int reg,
 {
 	u16 *cache = codec->reg_cache;
 
-	soc_ac97_ops.write(codec->ac97, reg, val);
+	if (reg < 0x7c)
+		soc_ac97_ops.write(codec->ac97, reg, val);
 	reg = reg >> 1;
 	if (reg < (ARRAY_SIZE(wm9712_reg)))
 		cache[reg] = val;
-- 
1.6.6

