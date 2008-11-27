Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbYK0Oky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbYK0Oky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYK0Okp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:40:45 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:39283 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbYK0Oko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:40:44 -0500
Date: Thu, 27 Nov 2008 15:40:40 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Takashi Iwai <tiwai@suse.de>
Cc: perex@perex.cz, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] sound/pci/mixart/mixart.c: Add missing snd_card_free
In-Reply-To: <s5hljv55j7o.wl%tiwai@suse.de>
Message-ID: <Pine.LNX.4.64.0811271539400.15160@pc-004.diku.dk>
References: <Pine.LNX.4.64.0811271423040.15160@pc-004.diku.dk>
 <Pine.LNX.4.64.0811271432350.15160@pc-004.diku.dk> <s5hk5apz3md.wl%tiwai@suse.de>
 <Pine.LNX.4.64.0811271445310.15160@pc-004.diku.dk> <s5hljv55j7o.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The function snd_mixart_create creates a link between mgr and card that
allows snd_mixart_free to free card as well.  But if snd_mixart_create
fails, then the link has not been created and card has to be freed explicitly.


The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S,S1;
position p1,p2,p3;
expression E,E1;
type T,T1;
expression *ptr != NULL;
@@

(
 if ((x@p1 = snd_card_new(...)) == NULL) S
|
 x@p1 = snd_card_new(...);
)
 ... when != snd_card_free(...,(T)x,...)
     when != if (...) { <+... snd_card_free(...,(T)x,...) ...+> }
     when != true x == NULL || ...
     when != x = E
     when != E = (T)x
     when any
(
 if (x == NULL || ...) S1
|
 if@p2 (...) {
  ... when != snd_card_free(...,(T1)x,...)
      when != if (...) { <+... snd_card_free(...,(T1)x,...) ...+> }
      when != x = E1
      when != E1 = (T1)x
(
  return \(0\|<+...x...+>\|ptr\);
|
  return@p3 ...;
)
}
)

@ script:python @
p1 << r.p1;
p3 << r.p3;
@@

print "* file: %s snd_card_new: %s return: %s" % (p1[0].file,p1[0].line,p3[0].line)

// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/pci/mixart/mixart.c |    4 +++-
 sound/pci/pcxhr/pcxhr.c   |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
index ae7601f..f23a735 100644
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -1010,7 +1010,7 @@ static int __devinit snd_mixart_create(struct mixart_mgr *mgr, struct snd_card *
 		.dev_free = snd_mixart_chip_dev_free,
 	};
 
-	mgr->chip[idx] = chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (! chip) {
 		snd_printk(KERN_ERR "cannot allocate chip\n");
 		return -ENOMEM;
@@ -1025,6 +1025,7 @@ static int __devinit snd_mixart_create(struct mixart_mgr *mgr, struct snd_card *
 		return err;
 	}
 
+	mgr->chip[idx] = chip;
 	snd_card_set_dev(card, &mgr->pci->dev);
 
 	return 0;
@@ -1377,6 +1378,7 @@ static int __devinit snd_mixart_probe(struct pci_dev *pci,
 		sprintf(card->longname, "%s [PCM #%d]", mgr->longname, i);
 
 		if ((err = snd_mixart_create(mgr, card, i)) < 0) {
+			snd_card_free(card);
 			snd_mixart_free(mgr);
 			return err;
 		}
diff --git a/sound/pci/pcxhr/pcxhr.c b/sound/pci/pcxhr/pcxhr.c
index 73de6e9..7d2b136 100644
--- a/sound/pci/pcxhr/pcxhr.c
+++ b/sound/pci/pcxhr/pcxhr.c
@@ -1024,7 +1024,7 @@ static int __devinit pcxhr_create(struct pcxhr_mgr *mgr, struct snd_card *card,
 		.dev_free = pcxhr_chip_dev_free,
 	};
 
-	mgr->chip[idx] = chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (! chip) {
 		snd_printk(KERN_ERR "cannot allocate chip\n");
 		return -ENOMEM;
@@ -1050,6 +1050,7 @@ static int __devinit pcxhr_create(struct pcxhr_mgr *mgr, struct snd_card *card,
 		return err;
 	}
 
+	mgr->chip[idx] = chip;
 	snd_card_set_dev(card, &mgr->pci->dev);
 
 	return 0;
@@ -1310,6 +1311,7 @@ static int __devinit pcxhr_probe(struct pci_dev *pci, const struct pci_device_id
 		sprintf(card->longname, "%s [PCM #%d]", mgr->longname, i);
 
 		if ((err = pcxhr_create(mgr, card, i)) < 0) {
+			snd_card_free(card);
 			pcxhr_free(mgr);
 			return err;
 		}
