Return-Path: <linux-kernel-owner+w=401wt.eu-S1758416AbZLGAfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416AbZLGAfB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758360AbZLGAe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:34:59 -0500
Received: from kroah.org ([198.145.64.141]:34209 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758291AbZLGAMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:38 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:43 2009
Message-Id: <20091207000643.124751996@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [017/119] sound: rawmidi: disable active-sensing-on-close by default
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=sound-rawmidi-disable-active-sensing-on-close-by-default.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Clemens Ladisch <clemens@ladisch.de>

commit 2d4b842014dc76a81abced47ef27177eedb9deba upstream.

Sending an Active Sensing message when closing a port can interfere with
the following data if the port is reopened and a note-on is sent before
the device's timeout has elapsed.  Therefore, it is better to disable
this setting by default.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>

---
 sound/core/rawmidi.c      |    2 +-
 sound/core/seq/seq_midi.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -274,7 +274,7 @@ static int open_substream(struct snd_raw
 		return err;
 	substream->opened = 1;
 	if (substream->use_count++ == 0)
-		substream->active_sensing = 1;
+		substream->active_sensing = 0;
 	if (mode & SNDRV_RAWMIDI_LFLG_APPEND)
 		substream->append = 1;
 	rmidi->streams[substream->stream].substream_opened++;
--- a/sound/core/seq/seq_midi.c
+++ b/sound/core/seq/seq_midi.c
@@ -236,6 +236,7 @@ static int midisynth_use(void *private_d
 	memset(&params, 0, sizeof(params));
 	params.avail_min = 1;
 	params.buffer_size = output_buffer_size;
+	params.no_active_sensing = 1;
 	if ((err = snd_rawmidi_output_params(msynth->output_rfile.output, &params)) < 0) {
 		snd_rawmidi_kernel_release(&msynth->output_rfile);
 		return err;


