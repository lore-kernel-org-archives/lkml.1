Return-Path: <linux-kernel-owner+w=401wt.eu-S1759806AbXFQLZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806AbXFQLZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 07:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbXFQLY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 07:24:56 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:46710 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757394AbXFQLYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 07:24:55 -0400
Message-ID: <467519F6.5000701@interia.pl>
Date: Sun, 17 Jun 2007 13:24:38 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.0 (X11/20070524)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: video4linux-list@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Alsa fix for SAA7134 based "KNC One TV-Station DVR" card
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-EMID: 99526acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sound recording doesn't work for this card because ACNI and ACPF
are not set before snd_card_saa7134_capture_prepare(). As a result
timeout occurs. These registers aren't poked because thread
never gets wake up signal. ACNI initialization is done in the
thread.
Sound is muted when capture stops. Shouldn't be because it may
be used during TV playback.

Signed-off-by: Rafal Bilski <rafalbilski@interia.pl>
---
 drivers/media/video/saa7134/saa7134-alsa.c  |   16 +++++++++++-----
 drivers/media/video/saa7134/saa7134-cards.c |    2 +-
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-alsa.c b/drivers/media/video/saa7134/saa7134-alsa.c
--- a/drivers/media/video/saa7134/saa7134-alsa.c
+++ b/drivers/media/video/saa7134/saa7134-alsa.c
@@ -75,7 +75,8 @@ typedef struct snd_card_saa7134 {
 	struct saa7134_dev *dev;
 
 	unsigned long iobase;
-	int irq;
+	s16 irq;
+	u16 mute_was_on;
 
 	spinlock_t lock;
 } snd_card_saa7134_t;
@@ -589,8 +590,10 @@ static int snd_card_saa7134_capture_close(struct snd_pcm_substream * substream)
 	snd_card_saa7134_t *saa7134 = snd_pcm_substream_chip(substream);
 	struct saa7134_dev *dev = saa7134->dev;
 
-	dev->ctl_mute = 1;
-	saa7134_tvaudio_setmute(dev);
+	if (saa7134->mute_was_on) {
+		dev->ctl_mute = 1;
+		saa7134_tvaudio_setmute(dev);
+	}
 	return 0;
 }
 
@@ -637,8 +640,11 @@ static int snd_card_saa7134_capture_open(struct snd_pcm_substream * substream)
 	runtime->private_free = snd_card_saa7134_runtime_free;
 	runtime->hw = snd_card_saa7134_capture;
 
-	dev->ctl_mute = 0;
-	saa7134_tvaudio_setmute(dev);
+	if (dev->ctl_mute != 0) {
+		saa7134->mute_was_on = 1;
+		dev->ctl_mute = 0;
+		saa7134_tvaudio_setmute(dev);
+	}
 
 	if ((err = snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS)) < 0)
 		return err;
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -400,7 +400,7 @@ struct saa7134_board saa7134_boards[] = {
 		.inputs		= {{
 			.name = name_tv,
 			.vmux = 1,
-			.amux = LINE2,
+			.amux = TV,
 			.tv   = 1,
 			.gpio = 0x20000,
 		},{
-- 



----------------------------------------------------------------------
Ile masz w domu niepotrzebnych rzeczy?
Wymien sie z sasiadami >> http://link.interia.pl/f1a93


