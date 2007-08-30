Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbXH3D0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbXH3D0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 23:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758455AbXH3D0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 23:26:30 -0400
Received: from mail.queued.net ([207.210.101.209]:1785 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758299AbXH3D03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 23:26:29 -0400
Date: Wed, 29 Aug 2007 23:28:12 -0400
From: Andres Salomon <dilinger@queued.net>
To: jayakumar.alsa@gmail.com
Cc: akpm@linux-foundation.org, jordan.crouse@amd.com,
       linux-kernel@vger.kernel.org, info-linux@geode.amd.com
Subject: [PATCH 1/5] ALSA: cs5535audio: correctly set dma->substream
Message-Id: <20070829232812.80e4c71c.dilinger@queued.net>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We're never actually setting dma->substream to the current substream; that
means the dma->substream checks that we do in the suspend/resume path
are never satisfied, and the PRD registers are never correctly managed.  This
changes it so that we set the substream when constructing the specific
bus master DMA, and unsetting it when we tear down the BM's DMA.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---

 sound/pci/cs5535audio/cs5535audio_pcm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio_pcm.c b/sound/pci/cs5535audio/cs5535audio_pcm.c
index 5450a9e..e61f972 100644
--- a/sound/pci/cs5535audio/cs5535audio_pcm.c
+++ b/sound/pci/cs5535audio/cs5535audio_pcm.c
@@ -164,6 +164,7 @@ static int cs5535audio_build_dma_packets(struct cs5535audio *cs5535au,
 	jmpprd_addr = cpu_to_le32(lastdesc->addr +
 				  (sizeof(struct cs5535audio_dma_desc)*periods));
 
+	dma->substream = substream;
 	dma->period_bytes = period_bytes;
 	dma->periods = periods;
 	spin_lock_irq(&cs5535au->reg_lock);
@@ -241,6 +242,7 @@ static void cs5535audio_clear_dma_packets(struct cs5535audio *cs5535au,
 {
 	snd_dma_free_pages(&dma->desc_buf);
 	dma->desc_buf.area = NULL;
+	dma->substream = NULL;
 }
 
 static int snd_cs5535audio_hw_params(struct snd_pcm_substream *substream,
