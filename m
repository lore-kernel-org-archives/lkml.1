Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbZLGAd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbZLGAd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbZLGAMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:44 -0500
Received: from kroah.org ([198.145.64.141]:34225 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758284AbZLGAMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:40 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:43 2009
Message-Id: <20091207000643.589531946@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [020/119] sound: rawmidi: fix MIDI device O_APPEND error handling
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=sound-rawmidi-fix-midi-device-o_append-error-handling.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Clemens Ladisch <clemens@ladisch.de>

commit b7fe750fcceda4fa6bef399b0e2812562728ea82 upstream.

Commit 9a1b64caac82aa02cb74587ffc798e6f42c6170a in 2.6.30 broke the
error handling code in rawmidi_open_priv().

If only the output substream of a RawMIDI device has been opened and
if this device is then opened with O_RDWR | O_APPEND and if the
initialization of the input substream fails (either because of low
memory or because the device driver's open callback fails), then the
runtime structure of the already open output substream will be freed
and all following writes through the first handle will cause
snd_rawmidi_write() to use the NULL runtime pointer.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/rawmidi.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -272,8 +272,10 @@ static int open_substream(struct snd_raw
 		if (err < 0)
 			return err;
 		err = substream->ops->open(substream);
-		if (err < 0)
+		if (err < 0) {
+			snd_rawmidi_runtime_free(substream);
 			return err;
+		}
 		substream->opened = 1;
 		substream->active_sensing = 0;
 		if (mode & SNDRV_RAWMIDI_LFLG_APPEND)
@@ -300,27 +302,27 @@ static int rawmidi_open_priv(struct snd_
 				       SNDRV_RAWMIDI_STREAM_INPUT,
 				       mode, &sinput);
 		if (err < 0)
-			goto __error;
+			return err;
 	}
 	if (mode & SNDRV_RAWMIDI_LFLG_OUTPUT) {
 		err = assign_substream(rmidi, subdevice,
 				       SNDRV_RAWMIDI_STREAM_OUTPUT,
 				       mode, &soutput);
 		if (err < 0)
-			goto __error;
+			return err;
 	}
 
 	if (sinput) {
 		err = open_substream(rmidi, sinput, mode);
 		if (err < 0)
-			goto __error;
+			return err;
 	}
 	if (soutput) {
 		err = open_substream(rmidi, soutput, mode);
 		if (err < 0) {
 			if (sinput)
 				close_substream(rmidi, sinput, 0);
-			goto __error;
+			return err;
 		}
 	}
 
@@ -328,13 +330,6 @@ static int rawmidi_open_priv(struct snd_
 	rfile->input = sinput;
 	rfile->output = soutput;
 	return 0;
-
-      __error:
-	if (sinput && sinput->runtime)
-		snd_rawmidi_runtime_free(sinput);
-	if (soutput && soutput->runtime)
-		snd_rawmidi_runtime_free(soutput);
-	return err;
 }
 
 /* called from sound/core/seq/seq_midi.c */


