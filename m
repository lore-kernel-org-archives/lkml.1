Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbZG1XDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbZG1XDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZG1XDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:03:48 -0400
Received: from kroah.org ([198.145.64.141]:42914 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbZG1XDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:03:46 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:41 2009
Message-Id: <20090728225941.579958466@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:58:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 04/37] sound: usb-audio: add workaround for Blue Microphones devices
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=sound-usb-audio-add-workaround-for-blue-microphones-devices.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit 8886f33f25083a47d5fa24ad7b57bb708c5c5403 upstream.

Blue Microphones USB devices have an alternate setting that sends two
channels of data to the computer.  Unfortunately, the descriptors of
that altsetting have a wrong channel setting, which means that any
recorded data from such a device has twice the sample rate from what
would be expected.

This patch adds a workaround to ignore that altsetting.  Since these
devices have only one actual channel, no data is lost.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/usbaudio.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -2674,7 +2674,7 @@ static int parse_audio_endpoints(struct 
 	struct usb_interface_descriptor *altsd;
 	int i, altno, err, stream;
 	int format;
-	struct audioformat *fp;
+	struct audioformat *fp = NULL;
 	unsigned char *fmt, *csep;
 	int num;
 
@@ -2747,6 +2747,18 @@ static int parse_audio_endpoints(struct 
 			continue;
 		}
 
+		/*
+		 * Blue Microphones workaround: The last altsetting is identical
+		 * with the previous one, except for a larger packet size, but
+		 * is actually a mislabeled two-channel setting; ignore it.
+		 */
+		if (fmt[4] == 1 && fmt[5] == 2 && altno == 2 && num == 3 &&
+		    fp && fp->altsetting == 1 && fp->channels == 1 &&
+		    fp->format == SNDRV_PCM_FORMAT_S16_LE &&
+		    le16_to_cpu(get_endpoint(alts, 0)->wMaxPacketSize) ==
+							fp->maxpacksize * 2)
+			continue;
+
 		csep = snd_usb_find_desc(alts->endpoint[0].extra, alts->endpoint[0].extralen, NULL, USB_DT_CS_ENDPOINT);
 		/* Creamware Noah has this descriptor after the 2nd endpoint */
 		if (!csep && altsd->bNumEndpoints >= 2)


