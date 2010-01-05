Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481Ab0AEUN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0AEUN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496Ab0AEUNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:13:51 -0500
Received: from kroah.org ([198.145.64.141]:49979 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456Ab0AEUGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:11 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:00 2010
Message-Id: <20100105200300.684152179@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [13/39] sound: sgio2audio/pdaudiocf/usb-audio: initialize PCM buffer
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

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

--- a/sound/mips/sgio2audio.c
+++ b/sound/mips/sgio2audio.c
@@ -609,7 +609,7 @@ static int snd_sgio2audio_pcm_hw_params(
 	/* alloc virtual 'dma' area */
 	if (runtime->dma_area)
 		vfree(runtime->dma_area);
-	runtime->dma_area = vmalloc(size);
+	runtime->dma_area = vmalloc_user(size);
 	if (runtime->dma_area == NULL)
 		return -ENOMEM;
 	runtime->dma_bytes = size;
--- a/sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c
+++ b/sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c
@@ -51,7 +51,7 @@ static int snd_pcm_alloc_vmalloc_buffer(
 			return 0; /* already enough large */
 		vfree(runtime->dma_area);
 	}
-	runtime->dma_area = vmalloc_32(size);
+	runtime->dma_area = vmalloc_32_user(size);
 	if (! runtime->dma_area)
 		return -ENOMEM;
 	runtime->dma_bytes = size;
--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -752,7 +752,7 @@ static int snd_pcm_alloc_vmalloc_buffer(
 			return 0; /* already large enough */
 		vfree(runtime->dma_area);
 	}
-	runtime->dma_area = vmalloc(size);
+	runtime->dma_area = vmalloc_user(size);
 	if (!runtime->dma_area)
 		return -ENOMEM;
 	runtime->dma_bytes = size;


