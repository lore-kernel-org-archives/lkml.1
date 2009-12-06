Return-Path: <linux-kernel-owner+w=401wt.eu-S1758327AbZLGAMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327AbZLGAMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758351AbZLGAMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:47 -0500
Received: from kroah.org ([198.145.64.141]:34219 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758282AbZLGAMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:39 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:43 2009
Message-Id: <20091207000643.451880574@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [019/119] sound: rawmidi: fix double init when opening MIDI device with O_APPEND
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=sound-rawmidi-fix-double-init-when-opening-midi-device-with-o_append.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Clemens Ladisch <clemens@ladisch.de>

commit 8579d2d7779d7ff41ea2a0183015e0e5038f1043 upstream.

Commit 9a1b64caac82aa02cb74587ffc798e6f42c6170a in 2.6.30 moved the
substream initialization code to where it would be executed every time
the substream is opened.

This had the consequence that any further opening would drop and leak
the data in the existing buffer, and that the device driver's open
callback would be called multiple times, unexpectedly.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/rawmidi.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -267,17 +267,19 @@ static int open_substream(struct snd_raw
 {
 	int err;
 
-	err = snd_rawmidi_runtime_create(substream);
-	if (err < 0)
-		return err;
-	err = substream->ops->open(substream);
-	if (err < 0)
-		return err;
-	substream->opened = 1;
-	if (substream->use_count++ == 0)
+	if (substream->use_count == 0) {
+		err = snd_rawmidi_runtime_create(substream);
+		if (err < 0)
+			return err;
+		err = substream->ops->open(substream);
+		if (err < 0)
+			return err;
+		substream->opened = 1;
 		substream->active_sensing = 0;
-	if (mode & SNDRV_RAWMIDI_LFLG_APPEND)
-		substream->append = 1;
+		if (mode & SNDRV_RAWMIDI_LFLG_APPEND)
+			substream->append = 1;
+	}
+	substream->use_count++;
 	rmidi->streams[substream->stream].substream_opened++;
 	return 0;
 }


