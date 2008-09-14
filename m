Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbYINTcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbYINTcu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 15:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbYINTcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 15:32:39 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:64092 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754294AbYINTci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 15:32:38 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org
Cc: Adrian McMenamin <adrian@mcmen.demon.co.uk>,
       Paul Mundt <lethal@linux-sh.org>, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fix section for snd-aica platform driver
Date: Sun, 14 Sep 2008 21:32:33 +0200
Message-Id: <1221420753-6613-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Mailer: git-send-email 1.5.6.5
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use __init but __devinit to define probe function.  A pointer to
snd_aica_probe is passed to the core via platform_driver_register and so the
function must not disappear after the module is loaded.  Using __init
and having HOTPLUG=y and SND_AICA=m the following probably oopses:

	echo -n AICA > /sys/bus/platform/driver/AICA/unbind
	echo -n AICA > /sys/bus/platform/driver/AICA/bind

Strange enough add_aicamixer_controls which is only called by
snd_aica_probe was already using __devinit.

While at it move the remove function to .devexit.text section.

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
Cc: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>

---
 sound/sh/aica.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/sh/aica.c b/sound/sh/aica.c
index 54df8ba..8cdf71a 100644
--- a/sound/sh/aica.c
+++ b/sound/sh/aica.c
@@ -589,7 +589,7 @@ static int __devinit add_aicamixer_controls(struct snd_card_aica
 	return 0;
 }
 
-static int snd_aica_remove(struct platform_device *devptr)
+static int __devexit snd_aica_remove(struct platform_device *devptr)
 {
 	struct snd_card_aica *dreamcastcard;
 	dreamcastcard = platform_get_drvdata(devptr);
@@ -601,7 +601,7 @@ static int snd_aica_remove(struct platform_device *devptr)
 	return 0;
 }
 
-static int __init snd_aica_probe(struct platform_device *devptr)
+static int __devinit snd_aica_probe(struct platform_device *devptr)
 {
 	int err;
 	struct snd_card_aica *dreamcastcard;
@@ -650,7 +650,7 @@ static int __init snd_aica_probe(struct platform_device *devptr)
 
 static struct platform_driver snd_aica_driver = {
 	.probe = snd_aica_probe,
-	.remove = snd_aica_remove,
+	.remove = __devexit_p(snd_aica_remove),
 	.driver = {
 		   .name = SND_AICA_DRIVER},
 };
-- 
tg: (6bfb09a..) t/sectionfixes/snd_aica (depends on: linus/master)
