Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbYEDRin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbYEDRin (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 13:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYEDRif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 13:38:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45680 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbYEDRie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 13:38:34 -0400
Date: Sun, 4 May 2008 19:37:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Stas Sergeev <stsp@aknet.ru>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch] build fix for sound/drivers/pcsp/pcsp.c
Message-ID: <20080504173740.GA14170@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86.git testing found the following build error in v2.6.26-rc1:

  sound/drivers/pcsp/pcsp.c: In function 'pcsp_suspend':
  sound/drivers/pcsp/pcsp.c:201: error: implicit declaration of function 'snd_pcm_suspend_all'

with the following config:

  http://redhat.com/~mingo/misc/config-Sun_May__4_19_20_01_CEST_2008.bad

the reason is the .suspend callback - which is defined even in the case 
of !CONFIG_PM in which case snd_pcm_suspend_all() is not available. 
Undefine the method for that case, like other platform drivers do.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 sound/drivers/pcsp/pcsp.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/sound/drivers/pcsp/pcsp.c
===================================================================
--- linux.orig/sound/drivers/pcsp/pcsp.c
+++ linux/sound/drivers/pcsp/pcsp.c
@@ -194,6 +194,7 @@ static void pcsp_stop_beep(struct snd_pc
 	spin_unlock_irq(&chip->substream_lock);
 }
 
+#ifdef CONFIG_PM
 static int pcsp_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct snd_pcsp *chip = platform_get_drvdata(dev);
@@ -201,6 +202,7 @@ static int pcsp_suspend(struct platform_
 	snd_pcm_suspend_all(chip->pcm);
 	return 0;
 }
+#endif
 
 static void pcsp_shutdown(struct platform_device *dev)
 {
@@ -215,7 +217,9 @@ static struct platform_driver pcsp_platf
 	},
 	.probe		= pcsp_probe,
 	.remove		= __devexit_p(pcsp_remove),
+#ifdef CONFIG_PM
 	.suspend	= pcsp_suspend,
+#endif
 	.shutdown	= pcsp_shutdown,
 };
 
