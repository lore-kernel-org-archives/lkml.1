Return-Path: <linux-kernel-owner+w=401wt.eu-S1762999AbZGABNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762999AbZGABNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761592AbZGAAfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:44 -0400
Received: from kroah.org ([198.145.64.141]:60644 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761542AbZGAAfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:40 2009
Message-Id: <20090701002440.509344548@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 089/108] sound: seq_midi_event: fix decoding of (N)RPN events
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=sound-seq_midi_event-fix-decoding-of-rpn-events.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 6423f9ea8035138d70bae1a278d3b57b743f8b3e upstream.

When decoding (N)RPN sequencer events into raw MIDI commands, the
extra_decode_xrpn() function had accidentally swapped the MSB and LSB
controller values of both the parameter number and the data value.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/seq/seq_midi_event.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/core/seq/seq_midi_event.c
+++ b/sound/core/seq/seq_midi_event.c
@@ -504,10 +504,10 @@ static int extra_decode_xrpn(struct snd_
 	if (dev->nostat && count < 12)
 		return -ENOMEM;
 	cmd = MIDI_CMD_CONTROL|(ev->data.control.channel & 0x0f);
-	bytes[0] = ev->data.control.param & 0x007f;
-	bytes[1] = (ev->data.control.param & 0x3f80) >> 7;
-	bytes[2] = ev->data.control.value & 0x007f;
-	bytes[3] = (ev->data.control.value & 0x3f80) >> 7;
+	bytes[0] = (ev->data.control.param & 0x3f80) >> 7;
+	bytes[1] = ev->data.control.param & 0x007f;
+	bytes[2] = (ev->data.control.value & 0x3f80) >> 7;
+	bytes[3] = ev->data.control.value & 0x007f;
 	if (cmd != dev->lastcmd && !dev->nostat) {
 		if (count < 9)
 			return -ENOMEM;


