Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbYJGAqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbYJGAqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbYJGAnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:43:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:60400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816AbYJGAnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:43:09 -0400
Date: Mon, 6 Oct 2008 17:38:08 -0700
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
Subject: [patch 16/71] ALSA: remove unneeded power_mutex lock in
	snd_pcm_drop
Message-ID: <20081007003808.GQ3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-remove-unneeded-power_mutex-lock-in-snd_pcm_drop.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Takashi Iwai <tiwai@suse.de>

Upstream-commit-id: 24e8fc498e9618338854bfbcf8d1d737e0bf1775

The power_mutex lock in snd_pcm_drop may cause a possible deadlock
chain, and above all, it's unneeded.  Let's get rid of it.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/pcm_native.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1545,16 +1545,10 @@ static int snd_pcm_drop(struct snd_pcm_s
 	card = substream->pcm->card;
 
 	if (runtime->status->state == SNDRV_PCM_STATE_OPEN ||
-	    runtime->status->state == SNDRV_PCM_STATE_DISCONNECTED)
+	    runtime->status->state == SNDRV_PCM_STATE_DISCONNECTED ||
+	    runtime->status->state == SNDRV_PCM_STATE_SUSPENDED)
 		return -EBADFD;
 
-	snd_power_lock(card);
-	if (runtime->status->state == SNDRV_PCM_STATE_SUSPENDED) {
-		result = snd_power_wait(card, SNDRV_CTL_POWER_D0);
-		if (result < 0)
-			goto _unlock;
-	}
-
 	snd_pcm_stream_lock_irq(substream);
 	/* resume pause */
 	if (runtime->status->state == SNDRV_PCM_STATE_PAUSED)
@@ -1563,8 +1557,7 @@ static int snd_pcm_drop(struct snd_pcm_s
 	snd_pcm_stop(substream, SNDRV_PCM_STATE_SETUP);
 	/* runtime->control->appl_ptr = runtime->status->hw_ptr; */
 	snd_pcm_stream_unlock_irq(substream);
- _unlock:
-	snd_power_unlock(card);
+
 	return result;
 }
 

-- 
