Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbXGCXI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbXGCXI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 19:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbXGCXIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 19:08:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:30984 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbXGCXIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 19:08:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lEuamW3qAUnA95nwtv3iaMCWCklT052A/rFLAHnwezxX3mRK9x6ilQGsNfEyPJW5D1lA0JHWUmjDZrpwNpwvUyofVefDF9MoMMjXPV1G3g1i2rjy97ylwQb8GA9puyVZTAXSmDbI4xvTzVCjIo3ySPuKBTKWJv7gk55y0zZMqHM=
Message-ID: <92a12cdb0707031608w532beb46yac48ad43a766698d@mail.gmail.com>
Date: Wed, 4 Jul 2007 00:08:46 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: alsa-devel@alsa-project.org
Subject: Re: [PATCH] Improve behaviour of Dreamcast aica ALSA driver in poor resource conditions
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <92a12cdb0707031436k74a10405p6d3a9976860074de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92a12cdb0707031436k74a10405p6d3a9976860074de@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/07, Adrian McMenamin <adrianmcmenamin@gmail.com> wrote:
> This patch stops the driver from crashing in certain situations (eg if
> the network fails when NFS mounted), please apply.
>

Actually, looked at this again and while the previous patch stopped
the driver from crashing it still locked the sound subsystem. This was
because INIT_WORK was being called on the same work_struct when the
device recovered from the network failure. The patch below ensures
that this does not happen and that instead, PREPARE_WORK is called.

Submitted by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

--- alsa-kernel/sh/aica.c	2007-06-23 15:25:55.000000000 +0100
+++ linux-2.6.21/sound/sh/aica.c	2007-07-04 00:01:23.000000000 +0100
@@ -68,6 +68,7 @@
 static struct spu_work_holder {
 	struct work_struct spu_dma_work;
 	void *sspointer;
+	int already_started;
 } spu_working;

 static struct workqueue_struct *aica_queue;
@@ -319,7 +320,13 @@
 	dreamcastcard = substream->pcm->private_data;
 	/*  Use queue to do the heavy lifting */
 	spu_working.sspointer = substream;
-	INIT_WORK(&(spu_working.spu_dma_work), run_spu_dma);
+	if (spu_working.already_started == 1) {
+		PREPARE_WORK(&(spu_working.spu_dma_work), run_spu_dma);
+	}
+	else {
+		INIT_WORK(&(spu_working.spu_dma_work), run_spu_dma);
+		spu_working.already_started = 1;
+	}
 	queue_work(aica_queue, &(spu_working.spu_dma_work));
 	/* Timer may already be running */
 	if (unlikely(dreamcastcard->timer.data)) {
@@ -366,7 +373,9 @@
 				 *substream)
 {
 	struct snd_card_aica *dreamcastcard = substream->pcm->private_data;
+	flush_workqueue(aica_queue);
 	del_timer(&dreamcastcard->timer);
+	aica_chn_halt();
 	kfree(dreamcastcard->channel);
 	spu_disable();
 	return 0;
@@ -402,17 +411,10 @@
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
