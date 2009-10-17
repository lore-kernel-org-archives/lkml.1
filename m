Return-Path: <linux-kernel-owner+w=401wt.eu-S1751460AbZJQGdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbZJQGdr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 02:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZJQGdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 02:33:46 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:59114 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbZJQGdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 02:33:45 -0400
Date: Sat, 17 Oct 2009 08:33:47 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Kyle McMartin <kyle@mcmartin.ca>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, linux-parisc@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/14] sound/parisc: Move dereference after NULL test
Message-ID: <Pine.LNX.4.64.0910170833240.9213@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test on h is needed in snd_harmony_mixer_init, then the
dereference should be after the NULL test.

Actually, there is a sequence of calls: snd_harmony_create, then
snd_harmony_pcm_init, and then snd_harmony_mixer_init.  snd_harmony_create
initializes h, but may indeed leave it as NULL.  There was no NULL test at
the beginning of snd_harmony_pcm_init, so I have added one.  The NULL test
in snd_harmony_mixer_init is then not necessary, but in case the ordering
of the calls changes, I have left it, and moved the dereference after it.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/parisc/harmony.c              |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/sound/parisc/harmony.c b/sound/parisc/harmony.c
index e924492..f47f9e2 100644
--- a/sound/parisc/harmony.c
+++ b/sound/parisc/harmony.c
@@ -624,6 +624,9 @@ snd_harmony_pcm_init(struct snd_harmony *h)
 	struct snd_pcm *pcm;
 	int err;
 
+	if (snd_BUG_ON(!h))
+		return -EINVAL;
+
 	harmony_disable_interrupts(h);
 	
    	err = snd_pcm_new(h->card, "harmony", 0, 1, 1, &pcm);
@@ -865,11 +868,12 @@ snd_harmony_mixer_reset(struct snd_harmony *h)
 static int __devinit
 snd_harmony_mixer_init(struct snd_harmony *h)
 {
-	struct snd_card *card = h->card;
+	struct snd_card *card;
 	int idx, err;
 
 	if (snd_BUG_ON(!h))
 		return -EINVAL;
+	card = h->card;
 	strcpy(card->mixername, "Harmony Gain control interface");
 
 	for (idx = 0; idx < HARMONY_CONTROLS; idx++) {
