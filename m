Return-Path: <linux-kernel-owner+w=401wt.eu-S1758344AbZLGAMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbZLGAMp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758328AbZLGAMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:43 -0500
Received: from kroah.org ([198.145.64.141]:34213 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758301AbZLGAMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:38 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:43 2009
Message-Id: <20091207000643.291159866@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [018/119] sound: rawmidi: fix checking of O_APPEND when opening MIDI device
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=sound-rawmidi-fix-checking-of-o_append-when-opening-midi-device.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Clemens Ladisch <clemens@ladisch.de>

commit 16fb109644b5644e42ececeff644514de6f4bd03 upstream.

Commit 9a1b64caac82aa02cb74587ffc798e6f42c6170a in 2.6.30 dropped the
check that a substream must already have been opened with O_APPEND to be
able to open it a second time.

This would make it possible for a substream to be switched to append
mode, which would mean that non-atomic writes would fail unexpectedly.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/rawmidi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -248,7 +248,8 @@ static int assign_substream(struct snd_r
 	list_for_each_entry(substream, &s->substreams, list) {
 		if (substream->opened) {
 			if (stream == SNDRV_RAWMIDI_STREAM_INPUT ||
-			    !(mode & SNDRV_RAWMIDI_LFLG_APPEND))
+			    !(mode & SNDRV_RAWMIDI_LFLG_APPEND) ||
+			    !substream->append)
 				continue;
 		}
 		if (subdevice < 0 || subdevice == substream->number) {


