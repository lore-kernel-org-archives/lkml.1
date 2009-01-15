Return-Path: <linux-kernel-owner+w=401wt.eu-S932205AbZAOUBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbZAOUBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:01:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761562AbZAOUAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:17 -0500
Received: from kroah.org ([198.145.64.141]:48702 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760574AbZAOUAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:15 -0500
Date: Thu, 15 Jan 2009 11:57:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 03/94] ALSA: caiaq - Fix Oops with MIDI
Message-ID: <20090115195717.GC14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-caiaq-fix-oops-with-midi.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit f3f80a9205da74fa56d613f4c14b88b6e4e6caa8 upstream.

The snd-usb-caiaq driver causes Oops occasionally when accessing MIDI
devices.  This patch fixes the Oops and invalid URB submission errors
as well.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/caiaq/caiaq-device.h |    1 +
 sound/usb/caiaq/caiaq-midi.c   |   32 ++++++++++++++++++--------------
 2 files changed, 19 insertions(+), 14 deletions(-)

--- a/sound/usb/caiaq/caiaq-device.h
+++ b/sound/usb/caiaq/caiaq-device.h
@@ -75,6 +75,7 @@ struct snd_usb_caiaqdev {
 	wait_queue_head_t ep1_wait_queue;
 	wait_queue_head_t prepare_wait_queue;
 	int spec_received, audio_parm_answer;
+	int midi_out_active;
 
 	char vendor_name[CAIAQ_USB_STR_LEN];
 	char product_name[CAIAQ_USB_STR_LEN];
--- a/sound/usb/caiaq/caiaq-midi.c
+++ b/sound/usb/caiaq/caiaq-midi.c
@@ -59,6 +59,11 @@ static int snd_usb_caiaq_midi_output_ope
 
 static int snd_usb_caiaq_midi_output_close(struct snd_rawmidi_substream *substream)
 {
+	struct snd_usb_caiaqdev *dev = substream->rmidi->private_data;
+	if (dev->midi_out_active) {
+		usb_kill_urb(&dev->midi_out_urb);
+		dev->midi_out_active = 0;
+	}
 	return 0;
 }
 
@@ -69,7 +74,8 @@ static void snd_usb_caiaq_midi_send(stru
 	
 	dev->midi_out_buf[0] = EP1_CMD_MIDI_WRITE;
 	dev->midi_out_buf[1] = 0; /* port */
-	len = snd_rawmidi_transmit_peek(substream, dev->midi_out_buf+3, EP1_BUFSIZE-3);
+	len = snd_rawmidi_transmit(substream, dev->midi_out_buf + 3,
+				   EP1_BUFSIZE - 3);
 	
 	if (len <= 0)
 		return;
@@ -79,24 +85,24 @@ static void snd_usb_caiaq_midi_send(stru
 	
 	ret = usb_submit_urb(&dev->midi_out_urb, GFP_ATOMIC);
 	if (ret < 0)
-		log("snd_usb_caiaq_midi_send(%p): usb_submit_urb() failed, %d\n",
-				substream, ret);
+		log("snd_usb_caiaq_midi_send(%p): usb_submit_urb() failed,"
+		    "ret=%d, len=%d\n",
+		    substream, ret, len);
+	else
+		dev->midi_out_active = 1;
 }
 
 static void snd_usb_caiaq_midi_output_trigger(struct snd_rawmidi_substream *substream, int up)
 {
 	struct snd_usb_caiaqdev *dev = substream->rmidi->private_data;
 	
-	if (dev->midi_out_substream != NULL)
-		return;
-	
-	if (!up) {
+	if (up) {
+		dev->midi_out_substream = substream;
+		if (!dev->midi_out_active)
+			snd_usb_caiaq_midi_send(dev, substream);
+	} else {
 		dev->midi_out_substream = NULL;
-		return;
 	}
-	
-	dev->midi_out_substream = substream;
-	snd_usb_caiaq_midi_send(dev, substream);
 }
 
 
@@ -161,16 +167,14 @@ int snd_usb_caiaq_midi_init(struct snd_u
 void snd_usb_caiaq_midi_output_done(struct urb* urb)
 {
 	struct snd_usb_caiaqdev *dev = urb->context;
-      	char *buf = urb->transfer_buffer;
 	
+	dev->midi_out_active = 0;
 	if (urb->status != 0)
 		return;
 
 	if (!dev->midi_out_substream)
 		return;
 
-	snd_rawmidi_transmit_ack(dev->midi_out_substream, buf[2]);
-	dev->midi_out_substream = NULL;
 	snd_usb_caiaq_midi_send(dev, dev->midi_out_substream);
 }
 

