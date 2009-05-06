Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbZEFV45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbZEFV45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761400AbZEFVy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:26 -0400
Received: from kroah.org ([198.145.64.141]:56926 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761166AbZEFVyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:56 2009
Message-Id: <20090506214756.029181948@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Karsten Wiese <fzu@wemgehoertderstaat.de>,
       Takashi Iwai <tiwai@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 06/58] ALSA: us122l: add snd_us122l_free()
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=alsa-us122l-add-snd_us122l_free.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Karsten Wiese <fzu@wemgehoertderstaat.de>

upstream commit: 5d4af1be06affa2b42cdf59cd376752be1f934b3

Use it to clean up snd_us122l_card_used[].

Without patch unplugging of an US122L soundcard didn't reset the
corresponding element of snd_us122l_card_used[] to 0.
The (SNDRV_CARDS + 1)th plugging in did not result in creating the soundcard
device anymore.
Index values supplied with the modprobe command line were not used correctly
anymore after the first unplugging of an US122L.

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: stable@kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[chrisw: backport to 2.6.29]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 sound/usb/usx2y/us122l.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -478,6 +478,14 @@ static bool us122l_create_card(struct sn
 	return true;
 }
 
+static void snd_us122l_free(struct snd_card *card)
+{
+	struct us122l	*us122l = US122L(card);
+	int		index = us122l->chip.index;
+	if (index >= 0  &&  index < SNDRV_CARDS)
+		snd_us122l_card_used[index] = 0;
+}
+
 static struct snd_card *usx2y_create_card(struct usb_device *device)
 {
 	int		dev;
@@ -492,7 +500,7 @@ static struct snd_card *usx2y_create_car
 	if (!card)
 		return NULL;
 	snd_us122l_card_used[US122L(card)->chip.index = dev] = 1;
-
+	card->private_free = snd_us122l_free;
 	US122L(card)->chip.dev = device;
 	US122L(card)->chip.card = card;
 	mutex_init(&US122L(card)->mutex);
@@ -575,7 +583,7 @@ static void snd_us122l_disconnect(struct
 	}
 
 	usb_put_intf(intf);
-	usb_put_dev(US122L(card)->chip.dev);
+	usb_put_dev(us122l->chip.dev);
 
 	while (atomic_read(&us122l->mmap_count))
 		msleep(500);


