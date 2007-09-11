Return-Path: <linux-kernel-owner+w=401wt.eu-S1764744AbXIKVIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764744AbXIKVIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755977AbXIKVIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:08:17 -0400
Received: from 251.4.221.87.dynamic.jazztel.es ([87.221.4.251]:58189 "EHLO
	traven.no-ip.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752677AbXIKVIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:08:16 -0400
Date: Tue, 11 Sep 2007 23:08:19 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: perex@suse.cz, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/4] ESS Maestro 1/2/2E Sound Card: Use list_for_each_entry
Message-ID: <20070911210819.GH8592@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	perex@suse.cz, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070911205632.GF8592@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911205632.GF8592@traven>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ESS Maestro 1/2/2E Sound Card: Use list_for_each_entry instead of
list_for_each

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 2faf009..d69b11d 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -843,10 +843,9 @@ static void snd_es1968_bob_dec(struct es1968 *chip)
 		snd_es1968_bob_stop(chip);
 	else if (chip->bob_freq > ESM_BOB_FREQ) {
 		/* check reduction of timer frequency */
-		struct list_head *p;
 		int max_freq = ESM_BOB_FREQ;
-		list_for_each(p, &chip->substream_list) {
-			struct esschan *es = list_entry(p, struct esschan, list);
+		struct esschan *es;
+		list_for_each_entry(es, &chip->substream_list, list) {
 			if (max_freq < es->bob_freq)
 				max_freq = es->bob_freq;
 		}
@@ -1316,12 +1315,11 @@ static struct snd_pcm_hardware snd_es1968_capture = {
 
 static int calc_available_memory_size(struct es1968 *chip)
 {
-	struct list_head *p;
 	int max_size = 0;
-	
+	struct esm_memory *buf;
+
 	mutex_lock(&chip->memory_mutex);
-	list_for_each(p, &chip->buf_list) {
-		struct esm_memory *buf = list_entry(p, struct esm_memory, list);
+	list_for_each_entry(buf, &chip->buf_list, list) {
 		if (buf->empty && buf->buf.bytes > max_size)
 			max_size = buf->buf.bytes;
 	}
@@ -1335,12 +1333,10 @@ static int calc_available_memory_size(struct es1968 *chip)
 static struct esm_memory *snd_es1968_new_memory(struct es1968 *chip, int size)
 {
 	struct esm_memory *buf;
-	struct list_head *p;
-	
+
 	size = ALIGN(size, ESM_MEM_ALIGN);
 	mutex_lock(&chip->memory_mutex);
-	list_for_each(p, &chip->buf_list) {
-		buf = list_entry(p, struct esm_memory, list);
+	list_for_each_entry(buf, &chip->buf_list, list) {
 		if (buf->empty && buf->buf.bytes >= size)
 			goto __found;
 	}
@@ -1938,10 +1934,9 @@ static irqreturn_t snd_es1968_interrupt(int irq, void *dev_id)
 	}
 
 	if (event & ESM_SOUND_IRQ) {
-		struct list_head *p;
+		struct esschan *es;
 		spin_lock(&chip->substream_lock);
-		list_for_each(p, &chip->substream_list) {
-			struct esschan *es = list_entry(p, struct esschan, list);
+		list_for_each_entry(es, &chip->substream_list, list) {
 			if (es->running)
 				snd_es1968_update_pcm(chip, es);
 		}
@@ -2345,7 +2340,7 @@ static int es1968_resume(struct pci_dev *pci)
 {
 	struct snd_card *card = pci_get_drvdata(pci);
 	struct es1968 *chip = card->private_data;
-	struct list_head *p;
+	struct esschan *es;
 
 	if (! chip->do_pm)
 		return 0;
@@ -2374,8 +2369,7 @@ static int es1968_resume(struct pci_dev *pci)
 	/* restore ac97 state */
 	snd_ac97_resume(chip->ac97);
 
-	list_for_each(p, &chip->substream_list) {
-		struct esschan *es = list_entry(p, struct esschan, list);
+	list_for_each_entry(es, &chip->substream_list, list) {
 		switch (es->mode) {
 		case ESM_MODE_PLAY:
 			snd_es1968_playback_setup(chip, es, es->substream->runtime);


-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

              Insanity: doing the same thing over and over
                again and expecting different results
                            (Albert Einstein)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
