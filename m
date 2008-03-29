Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbYC2Xyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbYC2Xyy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 19:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYC2Xyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 19:54:45 -0400
Received: from smtprelay07.ispgateway.de ([80.67.29.7]:49871 "EHLO
	smtprelay07.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYC2Xyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 19:54:45 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Mar 2008 19:54:44 EDT
Date: Sun, 30 Mar 2008 00:49:44 +0100
From: Andreas Mueller <andreas@stapelspeicher.org>
To: linux-kernel@vger.kernel.org
Cc: MatzeBraun@gmx.de, tiwai@suse.de
Subject: [PATCH] es1968: fix jitter on some maestro cards
Message-ID: <20080329234943.GA2899@slappy>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Df-Sender: 399301
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch suppresses jitter on several Maestro cards in stereo mode
(ALSA of course).

The patch is also incorporated in the *BSD drivers where I "ported" it from.
I am barely used to driver-development so please take a look (esp. the channel
parameters), nevertheless it completely works for me.

Without this patch most of the stereo audio gets out of sync and really
distorted (oss-emulation with mplayer at 48000khz worked somehow).

CCed to those listed in the .c file.

Yours sincerely,
Andreas Mueller.

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="es1968_jitter.patch"

--- sound/pci/es1968.c.old	2008-03-29 19:17:16.771116317 +0100
+++ sound/pci/es1968.c	2008-03-30 00:14:35.363057160 +0100
@@ -1816,7 +1816,24 @@
 
 	return 0;
 }
+/*
+ * suppress jitter on some maestros when playing stereo
+ */
+static void snd_es1968_suppress_jitter(struct es1968 *chip, struct esschan *es)
+{
+	unsigned int cp1;
+	unsigned int cp2;
+	unsigned int diff;
 
+	cp1 = __apu_get_register(chip, 0, 5);
+	cp2 = __apu_get_register(chip, 1, 5);
+	diff = (cp1 > cp2 ? cp1 - cp2 : cp2 - cp1);
+	
+	if (diff > 1) {
+		__maestro_write(chip, IDR0_DATA_PORT, cp1);
+	}
+}
+	
 /*
  * update pointer
  */
@@ -1937,8 +1954,11 @@
 		struct esschan *es;
 		spin_lock(&chip->substream_lock);
 		list_for_each_entry(es, &chip->substream_list, list) {
-			if (es->running)
+			if (es->running) {
 				snd_es1968_update_pcm(chip, es);
+				if (es->fmt & ESS_FMT_STEREO)
+					snd_es1968_suppress_jitter(chip, es);
+			}
 		}
 		spin_unlock(&chip->substream_lock);
 		if (chip->in_measurement) {

--CE+1k2dSO48ffgeK--
