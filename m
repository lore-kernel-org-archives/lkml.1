Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYKFVob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYKFVob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYKFVoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:44:13 -0500
Received: from mail.queued.net ([207.210.101.209]:4016 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbYKFVoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:44:12 -0500
Date: Thu, 6 Nov 2008 16:44:08 -0500
From: Andres Salomon <dilinger@queued.net>
To: jayakumar.alsa@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3/14] ALSA: cs5535audio: invert EAPD for OLPC (newer than
 B3)
Message-ID: <20081106164408.38241426@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix an audible pop described in <http://dev.laptop.org/ticket/977>.  Originally
based upon fixes by Mitch Bradley and Chris Ball.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/cs5535audio.c      |    3 +++
 sound/pci/cs5535audio/cs5535audio.h      |   11 +++++++++--
 sound/pci/cs5535audio/cs5535audio_olpc.c |   11 +++++++++++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio.c b/sound/pci/cs5535audio/cs5535audio.c
index cddfa54..0f5ce36 100644
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -164,6 +164,9 @@ static int __devinit snd_cs5535audio_mixer(struct cs5535audio *cs5535au)
 	ac97.private_data = cs5535au;
 	ac97.pci = cs5535au->pci;
 
+	/* set any OLPC-specific scaps */
+	olpc_prequirks(card, &ac97);
+
 	if ((err = snd_ac97_mixer(pbus, &ac97, &cs5535au->ac97)) < 0) {
 		snd_printk(KERN_ERR "mixer failed\n");
 		return err;
diff --git a/sound/pci/cs5535audio/cs5535audio.h b/sound/pci/cs5535audio/cs5535audio.h
index c67e62f..93602cf 100644
--- a/sound/pci/cs5535audio/cs5535audio.h
+++ b/sound/pci/cs5535audio/cs5535audio.h
@@ -103,9 +103,16 @@ int snd_cs5535audio_resume(struct pci_dev *pci);
 #endif
 
 #ifdef CONFIG_OLPC
-int olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97);
+void __devinit olpc_prequirks(struct snd_card *card,
+		struct snd_ac97_template *ac97);
+int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97);
 #else
-#define olpc_quirks(arg,arg2) (0)
+static inline void olpc_prequirks(struct snd_card *card,
+		struct snd_ac97_template *ac97) { }
+static inline int olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
+{
+	return 0;
+}
 #endif
 
 int __devinit snd_cs5535audio_pcm(struct cs5535audio *cs5535audio);
diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
index c088eef..adc10a3 100644
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -103,6 +103,17 @@ static struct snd_kcontrol_new snd_cs5535audio_controls __devinitdata =
 	.private_value = 0
 };
 
+void __devinit olpc_prequirks(struct snd_card *card,
+		struct snd_ac97_template *ac97)
+{
+	if (!machine_is_olpc())
+		return;
+
+	/* invert EAPD if on an OLPC B3 or higher */
+	if (olpc_board_at_least(olpc_board_pre(0xb3)))
+		ac97->scaps |= AC97_SCAP_INV_EAPD;
+}
+
 int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
 {
 	if (!machine_is_olpc())
-- 
1.5.6.5

