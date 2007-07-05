Return-Path: <linux-kernel-owner+w=401wt.eu-S1762423AbXGEWHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762423AbXGEWHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760001AbXGEWHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:07:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:44260 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759237AbXGEWHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:07:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=cHhvmOXOmcnz0M3H4yvV55fW+yxArIW2yE57xOyiVQ84MZLBKlNTw0h9Tr9pKvGWT4n5WEcwwgxGY5d5Jm5A4puUiZE2jBAeZ68EtXF5aLIwm9k3vgxm/PCb4169cRTVtPH46KK8Cj708x1awXSPrmje9N+sGnyQmAmFlVvCMuQ=
Message-ID: <92a12cdb0707051507r7ab1516blb7ea755d89c25efa@mail.gmail.com>
Date: Thu, 5 Jul 2007 23:07:44 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: alsa-devel@alsa-project.org, "Takashi Iwai" <tiwai@suse.de>
Subject: [PATCH] ALSA AICA sound on SEGA Dreamcast - fix behaviour in poor resource conditions
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patch against code in alsa-kernel - tested with patched up 2.6.21-rc7
and working well

Submitted by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>


diff -ruN aicaold/aica.c aicanew/aica.c
--- aicaold/aica.c	2007-07-05 23:01:39.000000000 +0100
+++ aicanew/aica.c	2007-07-05 23:02:02.000000000 +0100
@@ -65,10 +65,6 @@

 /* Use workqueue */

-static struct spu_work_holder {
-	struct work_struct spu_dma_work;
-	void *sspointer;
-} spu_working;

 static struct workqueue_struct *aica_queue;

@@ -252,18 +248,15 @@
 static void run_spu_dma(struct work_struct *work)
 {
 	int buffer_size;
-	struct snd_pcm_substream *substream;
 	struct snd_pcm_runtime *runtime;
 	struct snd_card_aica *dreamcastcard;
-	struct spu_work_holder *holder = container_of(work, struct
spu_work_holder, spu_dma_work);
-	substream = holder-> sspointer;
-	dreamcastcard = substream->pcm->private_data;
-	runtime = substream->runtime;
+	dreamcastcard = container_of(work, struct snd_card_aica, spu_dma_work);
+	runtime = dreamcastcard->substream->runtime;
 	if (unlikely(dreamcastcard->dma_check == 0)) {
 		buffer_size = frames_to_bytes(runtime, runtime->buffer_size);
 		if (runtime->channels > 1)
 			dreamcastcard->channel->flags |= 0x01;
-		aica_dma_transfer(runtime->channels, buffer_size, substream);
+		aica_dma_transfer(runtime->channels, buffer_size, dreamcastcard->substream);
 		startup_aica(dreamcastcard);
 		dreamcastcard->clicks =
 		    buffer_size / (AICA_PERIOD_SIZE * runtime->channels);
@@ -271,7 +264,7 @@
 	} else {
 		aica_dma_transfer(runtime->channels,
 				  AICA_PERIOD_SIZE * runtime->channels,
-				  substream);
+				  dreamcastcard->substream);
 		snd_pcm_period_elapsed(dreamcastcard->substream);
 		dreamcastcard->clicks++;
 		if (unlikely(dreamcastcard->clicks >= AICA_PERIOD_NUMBER))
@@ -307,7 +300,8 @@
 		dreamcastcard->current_period = play_period;
 	if (unlikely(dreamcastcard->dma_check == 0))
 		dreamcastcard->dma_check = 1;
-		queue_work(aica_queue, &(spu_working.spu_dma_work));
+		queue_work(aica_queue, &(dreamcastcard->spu_dma_work));
+
 }

 static void spu_begin_dma(struct snd_pcm_substream *substream)
@@ -317,10 +311,8 @@
 	struct snd_pcm_runtime *runtime;
 	runtime = substream->runtime;
 	dreamcastcard = substream->pcm->private_data;
-	/*  Use queue to do the heavy lifting */
-	spu_working.sspointer = substream;
-	INIT_WORK(&(spu_working.spu_dma_work), run_spu_dma);
-	queue_work(aica_queue, &(spu_working.spu_dma_work));
+	//get the queue to do the work
+	queue_work(aica_queue, &(dreamcastcard->spu_dma_work));
 	/* Timer may already be running */
 	if (unlikely(dreamcastcard->timer.data)) {
 		mod_timer(&dreamcastcard->timer, jiffies + 4);
@@ -366,7 +358,9 @@
 				 *substream)
 {
 	struct snd_card_aica *dreamcastcard = substream->pcm->private_data;
+	flush_workqueue(aica_queue);
 	del_timer(&dreamcastcard->timer);
+	aica_chn_halt();
 	kfree(dreamcastcard->channel);
 	spu_disable();
 	return 0;
@@ -402,17 +396,10 @@
 static int snd_aicapcm_pcm_trigger(struct snd_pcm_substream
 				   *substream, int cmd)
 {
-	struct snd_card_aica *dreamcastcard;
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 		spu_begin_dma(substream);
 		break;
-	case SNDRV_PCM_TRIGGER_STOP:
-		dreamcastcard = substream->pcm->private_data;
-		if (dreamcastcard->timer.data)
-			del_timer(&dreamcastcard->timer);
-		aica_chn_halt();
-		break;
 	default:
 		return -EINVAL;
 	}
@@ -610,6 +597,8 @@
 	strcpy(dreamcastcard->card->shortname, SND_AICA_DRIVER);
 	strcpy(dreamcastcard->card->longname,
 	       "Yamaha AICA Super Intelligent Sound Processor for SEGA Dreamcast");
+	//start the worker thread
+	INIT_WORK(&(dreamcastcard->spu_dma_work), run_spu_dma);
 	/* Load the PCM 'chip' */
 	err = snd_aicapcmchip(dreamcastcard, 0);
 	if (unlikely(err < 0))
diff -ruN aicaold/aica.h aicanew/aica.h
--- aicaold/aica.h	2007-07-05 23:01:39.000000000 +0100
+++ aicanew/aica.h	2007-07-05 23:02:02.000000000 +0100
@@ -69,6 +69,7 @@
 };

 struct snd_card_aica {
+	struct work_struct spu_dma_work;
 	struct snd_card *card;
 	struct aica_channel *channel;
 	struct snd_pcm_substream *substream;
