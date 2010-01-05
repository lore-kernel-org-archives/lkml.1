Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688Ab0AEAz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0AEAz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190Ab0AEAzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:55:23 -0500
Received: from kroah.org ([198.145.64.141]:34123 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab0AEAeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:46 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Clemens Ladisch <clemens@ladisch.de>,
       Takashi Iwai <tiwai@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/97] sound: sgio2audio/pdaudiocf/usb-audio: initialize PCM buffer
Date: Mon,  4 Jan 2010 16:32:25 -0800
Message-Id: <1262651630-7354-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clemens Ladisch <clemens@ladisch.de>

commit 3e85fd614c7b6bb7f33bb04a0dcb5a3bfca4c0fe upstream.

When allocating the PCM buffer, use vmalloc_user() instead of vmalloc().
Otherwise, it would be possible for applications to play the previous
contents of the kernel memory to the speakers, or to read it directly if
the buffer is exported to userspace.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/mips/sgio2audio.c                |    2 +-
 sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c |    2 +-
 sound/usb/usbaudio.c                   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/mips/sgio2audio.c b/sound/mips/sgio2audio.c
index 8691f4c..f1d9d16 100644
--- a/sound/mips/sgio2audio.c
+++ b/sound/mips/sgio2audio.c
@@ -609,7 +609,7 @@ static int snd_sgio2audio_pcm_hw_params(struct snd_pcm_substream *substream,
 	/* alloc virtual 'dma' area */
 	if (runtime->dma_area)
 		vfree(runtime->dma_area);
-	runtime->dma_area = vmalloc(size);
+	runtime->dma_area = vmalloc_user(size);
 	if (runtime->dma_area == NULL)
 		return -ENOMEM;
 	runtime->dma_bytes = size;
diff --git a/sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c b/sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c
index d057e64..5cfa608 100644
--- a/sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c
+++ b/sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c
@@ -51,7 +51,7 @@ static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs, size_t s
 			return 0; /* already enough large */
 		vfree(runtime->dma_area);
 	}
-	runtime->dma_area = vmalloc_32(size);
+	runtime->dma_area = vmalloc_32_user(size);
 	if (! runtime->dma_area)
 		return -ENOMEM;
 	runtime->dma_bytes = size;
diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
index 8db0374..8803d9d 100644
--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -752,7 +752,7 @@ static int snd_pcm_alloc_vmalloc_buffer(struct snd_pcm_substream *subs, size_t s
 			return 0; /* already large enough */
 		vfree(runtime->dma_area);
 	}
-	runtime->dma_area = vmalloc(size);
+	runtime->dma_area = vmalloc_user(size);
 	if (!runtime->dma_area)
 		return -ENOMEM;
 	runtime->dma_bytes = size;
-- 
1.6.6

