Return-Path: <linux-kernel-owner+w=401wt.eu-S1763839AbZGABAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763839AbZGABAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761481AbZGAAe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:56 -0400
Received: from kroah.org ([198.145.64.141]:60396 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761502AbZGAAey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:54 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:29 2009
Message-Id: <20090701002429.246830955@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 051/108] ALSA: intel8x0 - Fix PCM position craziness
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=alsa-intel8x0-fix-pcm-position-craziness.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit f708eb1d71dc8ffb184da9f0bc53461c6dc10653 upstream.

The PCM pointer callback sometimes returns invalid positions and this
screws up the hw_ptr updater in PCM core.  Especially since now the
jiffies check is optional with xrun_debug, the invalid position is
handled as is, and causes serious sound skips, etc.

This patch simplifies the position-fix strategy in intel8x0 to be more
robust:
- just falls back to the last position if bogus position is detected
- another sanity check for the backward move of the position due to
  a race of register update and the base-index update

This patch is applicable also for 2.6.30.

Tested-by: David Miller <davem@davemloft.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/intel8x0.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -356,8 +356,6 @@ struct ichdev {
         unsigned int position;
 	unsigned int pos_shift;
 	unsigned int last_pos;
-	unsigned long last_pos_jiffies;
-	unsigned int jiffy_to_bytes;
         int frags;
         int lvi;
         int lvi_frag;
@@ -844,7 +842,6 @@ static int snd_intel8x0_pcm_trigger(stru
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
 		val = ICH_IOCE | ICH_STARTBM;
 		ichdev->last_pos = ichdev->position;
-		ichdev->last_pos_jiffies = jiffies;
 		break;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 		ichdev->suspended = 1;
@@ -1048,7 +1045,6 @@ static int snd_intel8x0_pcm_prepare(stru
 			ichdev->pos_shift = (runtime->sample_bits > 16) ? 2 : 1;
 	}
 	snd_intel8x0_setup_periods(chip, ichdev);
-	ichdev->jiffy_to_bytes = (runtime->rate * 4 * ichdev->pos_shift) / HZ;
 	return 0;
 }
 
@@ -1073,19 +1069,23 @@ static snd_pcm_uframes_t snd_intel8x0_pc
 		    ptr1 == igetword(chip, ichdev->reg_offset + ichdev->roff_picb))
 			break;
 	} while (timeout--);
+	ptr = ichdev->last_pos;
 	if (ptr1 != 0) {
 		ptr1 <<= ichdev->pos_shift;
 		ptr = ichdev->fragsize1 - ptr1;
 		ptr += position;
-		ichdev->last_pos = ptr;
-		ichdev->last_pos_jiffies = jiffies;
-	} else {
-		ptr1 = jiffies - ichdev->last_pos_jiffies;
-		if (ptr1)
-			ptr1 -= 1;
-		ptr = ichdev->last_pos + ptr1 * ichdev->jiffy_to_bytes;
-		ptr %= ichdev->size;
+		if (ptr < ichdev->last_pos) {
+			unsigned int pos_base, last_base;
+			pos_base = position / ichdev->fragsize1;
+			last_base = ichdev->last_pos / ichdev->fragsize1;
+			/* another sanity check; ptr1 can go back to full
+			 * before the base position is updated
+			 */
+			if (pos_base == last_base)
+				ptr = ichdev->last_pos;
+		}
 	}
+	ichdev->last_pos = ptr;
 	spin_unlock(&chip->reg_lock);
 	if (ptr >= ichdev->size)
 		return 0;


