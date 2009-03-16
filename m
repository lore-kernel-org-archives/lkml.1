Return-Path: <linux-kernel-owner+w=401wt.eu-S1759654AbZCPO0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654AbZCPO0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 10:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZCPO00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 10:26:26 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:52621 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZCPO0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:26:25 -0400
Date: Mon, 16 Mar 2009 23:26:20 +0900 (JST)
Message-Id: <20090316.232620.95066093.anemo@mba.ocn.ne.jp>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Manuel Lauss <mano@roarinelk.homelinux.net>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: Only deregister AC97 dev if it's name was not "AC97"
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 14fa43f53ff3a9c3d8b9662574b7369812a31a97 ("ASoC: Only
register AC97 bus if it's not done already") added a condition for
calling of soc_ac97_dev_register() but not added for calling of
soc_ac97_dev_unregister().  This patch adds same condition for
soc_ac97_dev_unregister().  Without this fix, kernel crashes when
unloading an asoc driver.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
I found this problem when I start debugging a new asoc driver.  While
the driver is in very early stage, it should lack many things and have
many bugs.  So I'm not sure this is asoc's bug or my driver's bug.

 sound/soc/soc-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index ec3f8bb..fec57a3 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1435,7 +1435,8 @@ void snd_soc_free_pcms(struct snd_soc_device *socdev)
 #ifdef CONFIG_SND_SOC_AC97_BUS
 	for (i = 0; i < codec->num_dai; i++) {
 		codec_dai = &codec->dai[i];
-		if (codec_dai->ac97_control && codec->ac97) {
+		if (codec_dai->ac97_control && codec->ac97 &&
+		    strcmp(codec->name, "AC97") != 0) {
 			soc_ac97_dev_unregister(codec);
 			goto free_card;
 		}
-- 
1.5.6.3
