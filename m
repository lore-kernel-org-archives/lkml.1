Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYDMSVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYDMSVp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 14:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYDMSVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 14:21:36 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:32404 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752009AbYDMSVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 14:21:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=x/4+oHJolLr/g29RpVB6SaoS/OfgjQY3VHi5/7qUY+HjVGXQ/7ngyf29SHhXbYegtVb4cwO48GV0dlp9BMci/mHpqauQPM595+uxyCer8VeXaXl+FiewqsN/WUSzf2p0XbWO/A7jBsJnI3m1yXk4t7+wRWeT/55vIrzHQ3qZ7A0=  ;
X-YMail-OSG: HJmaNcoVM1k8uKxyOTosaA9XnIJJkSpdoNxvMhhAdbE8K_aAnuKyBgx0Sl4P0bNL7U2HX8ZaDpFkpzbSJjuGcW7y7JHPK7eiIhy07.euCqA1W9WtcA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>, perex@perex.cz,
       lkml <linux-kernel@vger.kernel.org>, liam.girdwood@wolfsonmicro.com,
       broonie@opensource.wolfsonmicro.com
Subject: [patch 2.6.25-rc9] sound: fix platform driver hotplug/coldplug
Date: Sun, 13 Apr 2008 11:20:40 -0700
User-Agent: KMail/1.9.6
Cc: kay.sievers@vrfy.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804131120.41027.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
modalias is prefixed with "platform:". Add MODULE_ALIAS() to the
hotpluggable sound platform drivers, to re-enable auto loading.

[ dbrownell@users.sourceforge.net: more drivers, registration fixes ]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
NOTE:  not sent to subscribers-only list: alsa-devel@alsa-project.org

 sound/arm/pxa2xx-ac97.c      |    2 ++
 sound/drivers/ml403-ac97cr.c |    4 ++++
 sound/soc/soc-core.c         |    2 ++
 3 files changed, 8 insertions(+)

--- g26.orig/sound/arm/pxa2xx-ac97.c	2008-04-13 10:30:20.000000000 -0700
+++ g26/sound/arm/pxa2xx-ac97.c	2008-04-13 10:33:22.000000000 -0700
@@ -391,6 +391,7 @@ static struct platform_driver pxa2xx_ac9
 	.resume		= pxa2xx_ac97_resume,
 	.driver		= {
 		.name	= "pxa2xx-ac97",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -410,3 +411,4 @@ module_exit(pxa2xx_ac97_exit);
 MODULE_AUTHOR("Nicolas Pitre");
 MODULE_DESCRIPTION("AC97 driver for the Intel PXA2xx chip");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pxa2xx-ac97");
--- g26.orig/sound/drivers/ml403-ac97cr.c	2008-04-13 10:32:22.000000000 -0700
+++ g26/sound/drivers/ml403-ac97cr.c	2008-04-13 10:36:29.000000000 -0700
@@ -1330,11 +1330,15 @@ static int snd_ml403_ac97cr_remove(struc
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:" SND_ML403_AC97CR_DRIVER);
+
 static struct platform_driver snd_ml403_ac97cr_driver = {
 	.probe = snd_ml403_ac97cr_probe,
 	.remove = snd_ml403_ac97cr_remove,
 	.driver = {
 		.name = SND_ML403_AC97CR_DRIVER,
+		.owner = THIS_MODULE,
 	},
 };
 
--- g26.orig/sound/soc/soc-core.c	2008-04-13 10:30:20.000000000 -0700
+++ g26/sound/soc/soc-core.c	2008-04-13 10:34:04.000000000 -0700
@@ -839,6 +839,7 @@ static int soc_remove(struct platform_de
 static struct platform_driver soc_driver = {
 	.driver		= {
 		.name		= "soc-audio",
+		.owner		= THIS_MODULE,
 	},
 	.probe		= soc_probe,
 	.remove		= soc_remove,
@@ -1601,3 +1602,4 @@ module_exit(snd_soc_exit);
 MODULE_AUTHOR("Liam Girdwood, liam.girdwood@wolfsonmicro.com, www.wolfsonmicro.com");
 MODULE_DESCRIPTION("ALSA SoC Core");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:soc-audio");
