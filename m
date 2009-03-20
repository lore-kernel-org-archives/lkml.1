Return-Path: <linux-kernel-owner+w=401wt.eu-S1762894AbZCTX3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762894AbZCTX3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762945AbZCTXY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:28 -0400
Received: from kroah.org ([198.145.64.141]:48554 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762947AbZCTXY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:27 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:24 2009
Message-Id: <20090320222924.477204359@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Krzysztof Helt <krzysztof.h1@wp.pl>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 10/43] ALSA: opl3sa2 - Fix NULL dereference when suspending snd_opl3sa2
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=alsa-opl3sa2-fix-null-dereference-when-suspending-snd_opl3sa2.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Krzysztof Helt <krzysztof.h1@wp.pl>

commit dde332b660cf0bc2baaba678b52768a0fb6e6da2 upstream.

Fix the OOPS during a opl3sa2 card suspend
and resume if the driver is loaded but the card
is not found.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/isa/opl3sa2.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/sound/isa/opl3sa2.c
+++ b/sound/isa/opl3sa2.c
@@ -550,21 +550,27 @@ static int __devinit snd_opl3sa2_mixer(s
 #ifdef CONFIG_PM
 static int snd_opl3sa2_suspend(struct snd_card *card, pm_message_t state)
 {
-	struct snd_opl3sa2 *chip = card->private_data;
+	if (card) {
+		struct snd_opl3sa2 *chip = card->private_data;
 
-	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
-	chip->wss->suspend(chip->wss);
-	/* power down */
-	snd_opl3sa2_write(chip, OPL3SA2_PM_CTRL, OPL3SA2_PM_D3);
+		snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
+		chip->wss->suspend(chip->wss);
+		/* power down */
+		snd_opl3sa2_write(chip, OPL3SA2_PM_CTRL, OPL3SA2_PM_D3);
+	}
 
 	return 0;
 }
 
 static int snd_opl3sa2_resume(struct snd_card *card)
 {
-	struct snd_opl3sa2 *chip = card->private_data;
+	struct snd_opl3sa2 *chip;
 	int i;
 
+	if (!card)
+		return 0;
+
+	chip = card->private_data;
 	/* power up */
 	snd_opl3sa2_write(chip, OPL3SA2_PM_CTRL, OPL3SA2_PM_D0);
 


