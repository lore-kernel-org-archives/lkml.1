Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZGRP0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZGRP0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 11:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZGRP0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 11:26:18 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:50671 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbZGRP0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 11:26:16 -0400
Date: Sat, 18 Jul 2009 17:26:14 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/6] sound/isa: convert nested spin_lock_irqsave to spin_lock
Message-ID: <Pine.LNX.4.64.0907181725540.26792@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If spin_lock_irqsave is called twice in a row with the same second
argument, the interrupt state at the point of the second call overwrites
the value saved by the first call.  Indeed, the second call does not need
to save the interrupt state, so it is changed to a simple spin_lock.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression lock1,lock2;
expression flags;
@@

*spin_lock_irqsave(lock1,flags)
... when != flags
*spin_lock_irqsave(lock2,flags)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/isa/gus/gus_pcm.c             |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/isa/gus/gus_pcm.c b/sound/isa/gus/gus_pcm.c
index edb11ee..2dcf45b 100644
--- a/sound/isa/gus/gus_pcm.c
+++ b/sound/isa/gus/gus_pcm.c
@@ -795,13 +795,13 @@ static int snd_gf1_pcm_volume_put(struct snd_kcontrol *kcontrol, struct snd_ctl_
 		if (!(pcmp->flags & SNDRV_GF1_PCM_PFLG_ACTIVE))
 			continue;
 		/* load real volume - better precision */
-		spin_lock_irqsave(&gus->reg_lock, flags);
+		spin_lock(&gus->reg_lock);
 		snd_gf1_select_voice(gus, pvoice->number);
 		snd_gf1_ctrl_stop(gus, SNDRV_GF1_VB_VOLUME_CONTROL);
 		vol = pvoice == pcmp->pvoices[0] ? gus->gf1.pcm_volume_level_left : gus->gf1.pcm_volume_level_right;
 		snd_gf1_write16(gus, SNDRV_GF1_VW_VOLUME, vol);
 		pcmp->final_volume = 1;
-		spin_unlock_irqrestore(&gus->reg_lock, flags);
+		spin_unlock(&gus->reg_lock);
 	}
 	spin_unlock_irqrestore(&gus->voice_alloc, flags);
 	return change;
