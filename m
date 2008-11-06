Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbYKFVoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbYKFVoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYKFVn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:43:57 -0500
Received: from mail.queued.net ([207.210.101.209]:4009 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbYKFVn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:43:57 -0500
Date: Thu, 6 Nov 2008 16:43:53 -0500
From: Andres Salomon <dilinger@queued.net>
To: jayakumar.alsa@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>, Jordan Crouse <jordan.crouse@amd.com>
Subject: [PATCH 2/14] ALSA: cs5535audio: Use OLPC/Geode basic infrastructure
Message-ID: <20081106164353.0c7713d6@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jordan Crouse <jordan.crouse@amd.com>

Use basic infrastructure code; geode_gpio* (rather than indexed i/o
EC access), and do an OLPC machine check in olpc_quirk.

[dilinger@debian.org: don't return failure in olpc_quirks if !OLPC]
[dilinger@debian.org: drop the <B2 workarounds; those machines are EOL'd]

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/cs5535audio_olpc.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
index 6d3ccb9..c088eef 100644
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -1,9 +1,10 @@
-#include <linux/olpc.h>
 #include <sound/driver.h>
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
 #include <sound/ac97_codec.h>
+
+#include <asm/olpc.h>
 #include "cs5535audio.h"
 
 /* OLPC has an additional feature on top of regular AD1888 codec
@@ -81,13 +82,11 @@ static int snd_cs5535audio_ctl_put(struct snd_kcontrol *kcontrol,
 	if (err < 0)
 		snd_printk(KERN_ERR "Error updating AD_TEST2 %d\n", err);
 
+	/* B2 and newer writes directly to a GPIO pin */
 	if (value)
-		err = write_ec_command(0x01); /* activate MIC_AC_OFF */
-	else 
-		err = write_ec_command(0x02); /* deactivates MIC_AC_OFF */
-
-	if (err < 0)
-		snd_printk(KERN_ERR "Error talking to EC %d\n", err);
+		geode_gpio_set(OLPC_GPIO_MIC_AC, GPIO_OUTPUT_VAL);
+	else
+		geode_gpio_clear(OLPC_GPIO_MIC_AC, GPIO_OUTPUT_VAL);
 
 	cs5535au->ec_analog_input_mode = value;
 
@@ -106,6 +105,9 @@ static struct snd_kcontrol_new snd_cs5535audio_controls __devinitdata =
 
 int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
 {
+	if (!machine_is_olpc())
+		return 0;
+
 	/* setup callback for mixer control that does analog input mode */	
 	return snd_ctl_add(card, snd_ctl_new1(&snd_cs5535audio_controls, 
 						ac97->private_data));
-- 
1.5.6.5

