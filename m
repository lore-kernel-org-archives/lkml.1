Return-Path: <linux-kernel-owner+w=401wt.eu-S1761998AbXGCVgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761998AbXGCVgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbXGCVgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:36:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:33579 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760473AbXGCVgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:36:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NTcyzlJVk9Izmvg77scmPOof6JsPWhayTuYYo9qz2lZl5n6bK1FPmS1PrrpBKncxw/01nz3c3J7oLcpmkeSbT+hlj9erzoy4akilX5D0KHh+37p2QlCs/3FMpn9NgkkYgB0XtGa+oXESO485ZsXG8jGRD4kV0nC1pnosu4awFeM=
Message-ID: <92a12cdb0707031436k74a10405p6d3a9976860074de@mail.gmail.com>
Date: Tue, 3 Jul 2007 22:36:40 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: alsa-devel@alsa-project.org
Subject: [PATCH] Improve behaviour of Dreamcast aica ALSA driver in poor resource conditions
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch stops the driver from crashing in certain situations (eg if
the network fails when NFS mounted), please apply.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

--- alsa-kernel/sh/aica.c	2007-06-23 15:25:55.000000000 +0100
+++ linux-2.6.21/sound/sh/aica.c	2007-07-03 22:28:16.000000000 +0100
@@ -366,7 +366,9 @@
 				 *substream)
 {
 	struct snd_card_aica *dreamcastcard = substream->pcm->private_data;
+	flush_workqueue(aica_queue);
 	del_timer(&dreamcastcard->timer);
+	aica_chn_halt();
 	kfree(dreamcastcard->channel);
 	spu_disable();
 	return 0;
@@ -402,16 +404,11 @@
 static int snd_aicapcm_pcm_trigger(struct snd_pcm_substream
 				   *substream, int cmd)
 {
-	struct snd_card_aica *dreamcastcard;
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 		spu_begin_dma(substream);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
-		dreamcastcard = substream->pcm->private_data;
-		if (dreamcastcard->timer.data)
-			del_timer(&dreamcastcard->timer);
-		aica_chn_halt();
 		break;
 	default:
 		return -EINVAL;
