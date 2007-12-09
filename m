Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbXLIRQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbXLIRQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 12:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbXLIRQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 12:16:18 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:12016 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbXLIRQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 12:16:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject:content-disposition;
        b=d1sbVou2DW+VEOcIMI1T2agu+/HG4X34g+tVf+96fWT1gbapCa/too9Mhh+FKqm0lCVusRWxj4zK5xW1JIciUvbDQrs78eIUNdaY26G/TWOq63SnpEkFLJ+Ehy5etXRXqbMxFbB2N65Mov21EiuBjuch6IjRB0qBcgBcsFrJ+84=
Message-Id: <20071209171601.368743645@gmail.com>
References: <20071209171509.601451827@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 09 Dec 2007 13:15:10 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Giuliano Pochini <pochini@shiny.it>,
       Jaroslav Kysela <perex@perex.cz>, linux-kernel@vger.kernel.org,
       Kevin Winchester <kjwinchester@gmail.com>
Subject: [patch 1/2] echoaudio semaphore to mutex
Content-Disposition: inline; filename=echoaudio-sem-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the semaphore to a mutex in echoaudio.c

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>

---
 sound/pci/echoaudio/echoaudio.c |   18 +++++++++---------
 sound/pci/echoaudio/echoaudio.h |    2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

Index: v2.6.24-rc4/sound/pci/echoaudio/echoaudio.c
===================================================================
--- v2.6.24-rc4.orig/sound/pci/echoaudio/echoaudio.c
+++ v2.6.24-rc4/sound/pci/echoaudio/echoaudio.c
@@ -378,7 +378,7 @@ static int pcm_digital_in_open(struct sn
 
 	DE_ACT(("pcm_digital_in_open\n"));
 	max_channels = num_digital_busses_in(chip) - substream->number;
-	down(&chip->mode_mutex);
+	mutex_lock(&chip->mode_mutex);
 	if (chip->digital_mode == DIGITAL_MODE_ADAT)
 		err = pcm_open(substream, max_channels);
 	else	/* If the card has ADAT, subtract the 6 channels
@@ -405,7 +405,7 @@ static int pcm_digital_in_open(struct sn
 		chip->can_set_rate=0;
 
 din_exit:
-	up(&chip->mode_mutex);
+	mutex_unlock(&chip->mode_mutex);
 	return err;
 }
 
@@ -420,7 +420,7 @@ static int pcm_digital_out_open(struct s
 
 	DE_ACT(("pcm_digital_out_open\n"));
 	max_channels = num_digital_busses_out(chip) - substream->number;
-	down(&chip->mode_mutex);
+	mutex_lock(&chip->mode_mutex);
 	if (chip->digital_mode == DIGITAL_MODE_ADAT)
 		err = pcm_open(substream, max_channels);
 	else	/* If the card has ADAT, subtract the 6 channels
@@ -447,7 +447,7 @@ static int pcm_digital_out_open(struct s
 	if (atomic_read(&chip->opencount) > 1 && chip->rate_set)
 		chip->can_set_rate=0;
 dout_exit:
-	up(&chip->mode_mutex);
+	mutex_unlock(&chip->mode_mutex);
 	return err;
 }
 
@@ -1420,7 +1420,7 @@ static int snd_echo_digital_mode_put(str
 	if (dmode != chip->digital_mode) {
 		/* mode_mutex is required to make this operation atomic wrt
 		pcm_digital_*_open() and set_input_clock() functions. */
-		down(&chip->mode_mutex);
+		mutex_lock(&chip->mode_mutex);
 
 		/* Do not allow the user to change the digital mode when a pcm
 		device is open because it also changes the number of channels
@@ -1439,7 +1439,7 @@ static int snd_echo_digital_mode_put(str
 			if (changed >= 0)
 				changed = 1;	/* No errors */
 		}
-		up(&chip->mode_mutex);
+		mutex_unlock(&chip->mode_mutex);
 	}
 	return changed;
 }
@@ -1566,12 +1566,12 @@ static int snd_echo_clock_source_put(str
 		return -EINVAL;
 	dclock = chip->clock_source_list[eclock];
 	if (chip->input_clock != dclock) {
-		down(&chip->mode_mutex);
+		mutex_lock(&chip->mode_mutex);
 		spin_lock_irq(&chip->lock);
 		if ((changed = set_input_clock(chip, dclock)) == 0)
 			changed = 1;	/* no errors */
 		spin_unlock_irq(&chip->lock);
-		up(&chip->mode_mutex);
+		mutex_unlock(&chip->mode_mutex);
 	}
 
 	if (changed < 0)
@@ -1972,7 +1972,7 @@ static __devinit int snd_echo_create(str
 		return err;
 	}
 	atomic_set(&chip->opencount, 0);
-	init_MUTEX(&chip->mode_mutex);
+	mutex_init(&chip->mode_mutex);
 	chip->can_set_rate = 1;
 	*rchip = chip;
 	/* Init done ! */
Index: v2.6.24-rc4/sound/pci/echoaudio/echoaudio.h
===================================================================
--- v2.6.24-rc4.orig/sound/pci/echoaudio/echoaudio.h
+++ v2.6.24-rc4/sound/pci/echoaudio/echoaudio.h
@@ -361,7 +361,7 @@ struct echoaudio {
 	spinlock_t lock;
 	struct snd_pcm_substream *substream[DSP_MAXPIPES];
 	int last_period[DSP_MAXPIPES];
-	struct semaphore mode_mutex;
+	struct mutex mode_mutex;
 	u16 num_digital_modes, digital_mode_list[6];
 	u16 num_clock_sources, clock_source_list[10];
 	atomic_t opencount;

-- 
