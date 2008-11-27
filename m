Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbYK0OCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbYK0OCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYK0OB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:01:56 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:43025 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbYK0OBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:01:55 -0500
Date: Thu, 27 Nov 2008 15:01:51 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Takashi Iwai <tiwai@suse.de>
Cc: perex@perex.cz, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] sound/pci/mixart/mixart.c: Add missing snd_card_free
In-Reply-To: <s5hk5apz3md.wl%tiwai@suse.de>
Message-ID: <Pine.LNX.4.64.0811271445310.15160@pc-004.diku.dk>
References: <Pine.LNX.4.64.0811271423040.15160@pc-004.diku.dk>
 <Pine.LNX.4.64.0811271432350.15160@pc-004.diku.dk> <s5hk5apz3md.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008, Takashi Iwai wrote:

> At Thu, 27 Nov 2008 14:33:30 +0100 (CET),
> Julia Lawall wrote:
> > 
> > Oops, please ignore this patch.  There is a problem, but the modification 
> > is not correct.
> 
> How about the patch below?

My solution was to move the initialization of mgr->chip[idx] down below 
the last error return in snd_mixart_create.  I think it depends on what is 
going to happen to the structure ops.  In your solution, if ops.dev_free 
is used later on, then the link between mgr and card will be broken, and 
no one will know to free card.

There is the same code and the same problem in sound/pci/pcxhr/pcxhr.c

I attach a proposed patch for both below.

julia

> Takashi
> 
> ---
> diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
> index ae7601f..3cccfed 100644
> --- a/sound/pci/mixart/mixart.c
> +++ b/sound/pci/mixart/mixart.c
> @@ -989,6 +989,7 @@ static int snd_mixart_pcm_digital(struct snd_mixart *chip)
>  
>  static int snd_mixart_chip_free(struct snd_mixart *chip)
>  {
> +	chip->mgr->chip[chip->chip_idx] = NULL;
>  	kfree(chip);
>  	return 0;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

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
