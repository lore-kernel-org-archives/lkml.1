Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbZLGAM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbZLGAM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbZLGAMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:52 -0500
Received: from kroah.org ([198.145.64.141]:34267 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758331AbZLGAMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:47 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:44 2009
Message-Id: <20091207000644.688098245@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Devin Heitmueller <dheitmueller@kernellabs.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [027/119] V4L/DVB (13190): em28xx: fix panic that can occur when starting audio streaming
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=v4l-dvb-13190-em28xx-fix-panic-that-can-occur-when-starting-audio-streaming.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Devin Heitmueller <dheitmueller@kernellabs.com>

commit 96fbf771d86a90ff006bc62ca4d4de6474b3de31 upstream.

Because the counters were not reset when starting up streaming, they would
be reused from the previous run.  This can result in cases such that when the
second instance of streaming starts up, the "cnt" variable in
em28xx_audio_isocirq() can end up being negative, resulting in attempting to
write to memory before the start of runtime->dma_area (as well as having a
negative number of bytes to copy).

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/em28xx/em28xx-audio.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -383,6 +383,11 @@ static int snd_em28xx_hw_capture_free(st
 
 static int snd_em28xx_prepare(struct snd_pcm_substream *substream)
 {
+	struct em28xx *dev = snd_pcm_substream_chip(substream);
+
+	dev->adev.hwptr_done_capture = 0;
+	dev->adev.capture_transfer_done = 0;
+
 	return 0;
 }
 


