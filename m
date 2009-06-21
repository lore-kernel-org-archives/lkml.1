Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbZFUSu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbZFUSu7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 14:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbZFUSut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 14:50:49 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:45051 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbZFUSus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 14:50:48 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Jun 2009 14:50:48 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
	b=e9EuezHySjgLZl9d+el+yLs0tSx5iwgP8NTn0qaa1UkX0Z6TQ9W3MNo61sOQP+Cn/0p4tFyOHebtZmsMagqK+CsJIxOZqWyqRo86Lw3QdkBof7RxVhp3jemBARJNBARF;
Message-ID: <4A3E8108.5010001@simon.arlott.org.uk>
Date: Sun, 21 Jun 2009 19:50:48 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090328)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, perex@perex.cz,
       tiwai@suse.de
CC: alsa-devel@alsa-project.org
Subject: [PATCH] via82xx: add option to disable 500ms delay in snd_via82xx_codec_wait
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a large 500ms delay in snd_via82xx_codec_wait() that, at least
on my hardware, appears to be unnecessary. The rest of the init of
the card works without logging any warnings or errors and both audio
and mixer settings work.

This adds an "nodelay" parameter to disable this (undocumented in the
code) large delay improving bootup time by 489-500ms.

[    1.034217] initcall alsa_card_via82xx_init+0x0/0x16 returned 0 after 505757 usecs
vs.
[    0.533136] initcall alsa_card_via82xx_init+0x0/0x16 returned 0 after 15915 usecs

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 sound/pci/via82xx.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index 1ef58c5..949fcaf 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -85,6 +85,7 @@ static int joystick;
 static int ac97_clock = 48000;
 static char *ac97_quirk;
 static int dxs_support;
+static int nodelay;
 
 module_param(index, int, 0444);
 MODULE_PARM_DESC(index, "Index value for VIA 82xx bridge.");
@@ -102,6 +103,8 @@ module_param(ac97_quirk, charp, 0444);
 MODULE_PARM_DESC(ac97_quirk, "AC'97 workaround for strange hardware.");
 module_param(dxs_support, int, 0444);
 MODULE_PARM_DESC(dxs_support, "Support for DXS channels (0 = auto, 1 = enable, 2 = disable, 3 = 48k only, 4 = no VRA, 5 = enable any sample rate)");
+module_param(nodelay, int, 0444);
+MODULE_PARM_DESC(nodelay, "Disable 500ms init delay");
 
 /* just for backward compatibility */
 static int enable;
@@ -549,7 +552,8 @@ static void snd_via82xx_codec_wait(struct snd_ac97 *ac97)
 	int err;
 	err = snd_via82xx_codec_ready(chip, ac97->num);
 	/* here we need to wait fairly for long time.. */
-	msleep(500);
+	if (!nodelay)
+		msleep(500);
 }
 
 static void snd_via82xx_codec_write(struct snd_ac97 *ac97,
-- 
1.6.3.1

-- 
Simon Arlott
