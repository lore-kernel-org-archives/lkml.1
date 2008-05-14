Return-Path: <linux-kernel-owner+w=401wt.eu-S1760978AbYENPkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978AbYENPkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYENPjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:39:49 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:60572 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbYENPjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:39:47 -0400
Message-ID: <482B0807.9050404@keyaccess.nl>
Date: Wed, 14 May 2008 17:40:55 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
References: <4823AAF2.7070102@keyaccess.nl>	<20080513180107.1a3893f1@core>	<4829D0E5.8050905@keyaccess.nl>	<200805131718.40138.bjorn.helgaas@hp.com>	<482ADF34.2010004@keyaccess.nl> <s5hod79avks.wl%tiwai@suse.de>
In-Reply-To: <s5hod79avks.wl%tiwai@suse.de>
Content-Type: multipart/mixed;
 boundary="------------010803070404060408070506"
X-Spam-Score: -0.5 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010803070404060408070506
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 14-05-08 15:01, Takashi Iwai wrote:
> At Wed, 14 May 2008 14:46:44 +0200,
> Rene Herman wrote:

>> If it's going to be useful, definitely. The attached does not just set
>>
>>    dev->dma_mask = &dev->coherent_dma_mask
>>
>> as in the fallback_dev when dma_alloc_coherent() is passed a NULL device 
>> only due to the mask juggling in snd_dma_hack_alloc_coherent() (which 
>> wouldn't break, but...) but introduces its own copy in struct isa_dev 
>> same as struct pnp_dev. As far as I'm aware, there's no actual reason 
>> for keeping it other than that and if the hack could go I'd rather lose 
>> the private mask copy again also.
> 
> The snd_dma_hack_alloc_coherent() is gone in the latest ALSA tree.
> It wasn't merged to 2.6.26, though.

Ah, good, thanks, I'll forward port to current ALSA.

>> At least the ALSA one isn't passing a literal NULL it seems. But yes, 
>> current NULL-hack reinstatement (it's been merged by Linus already) is 
>> definitely the correct fix for now.
> 
> Yes.  We need to fix the caller of snd_pcm_lib_preallocate_pages*()
> under sound/isa.  Currently it's called with snd_dma_isa_data(), which
> is expanded to NULL.  Replace it with a proper device pointer should
> suffice.

Like this? With this (on top of the previous patch setting the dma_mask 
ofcourse) legacy ISA actually appears to be fine but it's then ISAPnP 
which goes bonkers again. Sigh. Getting an allocation failure. Don't 
understand why yet since pnp_alloc_dev() definitely sets the mask 
already. Will stare...

Rene.

--------------010803070404060408070506
Content-Type: text/plain;
 name="sound_isa_use_dma_dev.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sound_isa_use_dma_dev.diff"

diff --git a/drivers/base/isa.c b/drivers/base/isa.c
diff --git a/include/sound/memalloc.h b/include/sound/memalloc.h
index ae2921d..81dd009 100644
--- a/include/sound/memalloc.h
+++ b/include/sound/memalloc.h
@@ -36,7 +36,7 @@ struct snd_dma_device {
 
 #ifndef snd_dma_pci_data
 #define snd_dma_pci_data(pci)	(&(pci)->dev)
-#define snd_dma_isa_data()	NULL
+#define snd_dma_isa_data(card)	((card)->dev)
 #define snd_dma_sbus_data(sbus)	((struct device *)(sbus))
 #define snd_dma_continuous_data(x)	((struct device *)(unsigned long)(x))
 #endif
diff --git a/sound/isa/ad1816a/ad1816a_lib.c b/sound/isa/ad1816a/ad1816a_lib.c
index 4b8dfe2..b1a1b79 100644
--- a/sound/isa/ad1816a/ad1816a_lib.c
+++ b/sound/isa/ad1816a/ad1816a_lib.c
@@ -677,7 +677,7 @@ int __devinit snd_ad1816a_pcm(struct snd_ad1816a *chip, int device, struct snd_p
 	snd_ad1816a_init(chip);
 
 	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV,
-					      snd_dma_isa_data(),
+					      snd_dma_isa_data(chip->card),
 					      64*1024, chip->dma1 > 3 || chip->dma2 > 3 ? 128*1024 : 64*1024);
 
 	chip->pcm = pcm;
diff --git a/sound/isa/ad1848/ad1848.c b/sound/isa/ad1848/ad1848.c
index 5f5271e..e992d69 100644
--- a/sound/isa/ad1848/ad1848.c
+++ b/sound/isa/ad1848/ad1848.c
@@ -95,6 +95,8 @@ static int __devinit snd_ad1848_probe(struct device *dev, unsigned int n)
 	if (!card)
 		return -EINVAL;
 
+	snd_card_set_dev(card, dev);
+
 	error = snd_ad1848_create(card, port[n], irq[n], dma1[n],
 			thinkpad[n] ? AD1848_HW_THINKPAD : AD1848_HW_DETECT, &chip);
 	if (error < 0)
@@ -118,8 +120,6 @@ static int __devinit snd_ad1848_probe(struct device *dev, unsigned int n)
 	if (thinkpad[n])
 		strcat(card->longname, " [Thinkpad]");
 
-	snd_card_set_dev(card, dev);
-
 	error = snd_card_register(card);
 	if (error < 0)
 		goto out;
diff --git a/sound/isa/ad1848/ad1848_lib.c b/sound/isa/ad1848/ad1848_lib.c
index 630c90f..2bdcb50 100644
--- a/sound/isa/ad1848/ad1848_lib.c
+++ b/sound/isa/ad1848/ad1848_lib.c
@@ -963,7 +963,7 @@ int snd_ad1848_pcm(struct snd_ad1848 *chip, int device, struct snd_pcm **rpcm)
 	strcpy(pcm->name, snd_ad1848_chip_id(chip));
 
 	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV,
-					      snd_dma_isa_data(),
+					      snd_dma_isa_data(chip->card),
 					      64*1024, chip->dma > 3 ? 128*1024 : 64*1024);
 
 	chip->pcm = pcm;
diff --git a/sound/isa/adlib.c b/sound/isa/adlib.c
index efa8c80..809f514 100644
--- a/sound/isa/adlib.c
+++ b/sound/isa/adlib.c
@@ -59,6 +59,8 @@ static int __devinit snd_adlib_probe(struct device *dev, unsigned int n)
 		return -EINVAL;
 	}
 
+	snd_card_set_dev(card, dev);
+
 	card->private_data = request_region(port[n], 4, CRD_NAME);
 	if (!card->private_data) {
 		snd_printk(KERN_ERR "%s: could not grab ports\n", dev->bus_id);
@@ -83,8 +85,6 @@ static int __devinit snd_adlib_probe(struct device *dev, unsigned int n)
 		goto out;
 	}
 
-	snd_card_set_dev(card, dev);
-
 	error = snd_card_register(card);
 	if (error < 0) {
 		snd_printk(KERN_ERR "%s: could not register card\n", dev->bus_id);
diff --git a/sound/isa/cmi8330.c b/sound/isa/cmi8330.c
index 4d198ec..75b5db6 100644
--- a/sound/isa/cmi8330.c
+++ b/sound/isa/cmi8330.c
@@ -395,7 +395,7 @@ static int __devinit snd_cmi8330_pcm(struct snd_card *card, struct snd_cmi8330 *
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &chip->streams[SNDRV_PCM_STREAM_CAPTURE].ops);
 
 	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV,
-					      snd_dma_isa_data(),
+					      snd_dma_isa_data(card),
 					      64*1024, 128*1024);
 	chip->pcm = pcm;
 
@@ -603,12 +603,12 @@ static int __devinit snd_cmi8330_pnp_detect(struct pnp_card_link *pcard,
 	card = snd_cmi8330_card_new(dev);
 	if (! card)
 		return -ENOMEM;
+	snd_card_set_dev(card, &pcard->card->dev);
 	if ((res = snd_cmi8330_pnp(dev, card->private_data, pcard, pid)) < 0) {
 		snd_printk(KERN_ERR PFX "PnP detection failed\n");
 		snd_card_free(card);
 		return res;
 	}
-	snd_card_set_dev(card, &pcard->card->dev);
 	if ((res = snd_cmi8330_probe(card, dev)) < 0) {
 		snd_card_free(card);
 		return res;
diff --git a/sound/isa/cs423x/cs4231.c b/sound/isa/cs423x/cs4231.c
index e9462b9..fcbe1b2 100644
--- a/sound/isa/cs423x/cs4231.c
+++ b/sound/isa/cs423x/cs4231.c
@@ -99,6 +99,8 @@ static int __devinit snd_cs4231_probe(struct device *dev, unsigned int n)
 	if (!card)
 		return -EINVAL;
 
+	snd_card_set_dev(card, dev);
+
 	error = snd_cs4231_create(card, port[n], -1, irq[n], dma1[n], dma2[n],
 			CS4231_HW_DETECT, 0, &chip);
 	if (error < 0)
@@ -136,8 +138,6 @@ static int __devinit snd_cs4231_probe(struct device *dev, unsigned int n)
 			printk(KERN_WARNING "%s: MPU401 not detected\n", dev->bus_id);
 	}
 
-	snd_card_set_dev(card, dev);
-
 	error = snd_card_register(card);
 	if (error < 0)
 		goto out;
diff --git a/sound/isa/cs423x/cs4231_lib.c b/sound/isa/cs423x/cs4231_lib.c
index 0aa8649..678e9df 100644
--- a/sound/isa/cs423x/cs4231_lib.c
+++ b/sound/isa/cs423x/cs4231_lib.c
@@ -1541,7 +1541,7 @@ int snd_cs4231_pcm(struct snd_cs4231 *chip, int device, struct snd_pcm **rpcm)
 	strcpy(pcm->name, snd_cs4231_chip_id(chip));
 
 	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV,
-					      snd_dma_isa_data(),
+					      snd_dma_isa_data(chip->card),
 					      64*1024, chip->dma1 > 3 || chip->dma2 > 3 ? 128*1024 : 64*1024);
 
 	chip->pcm = pcm;
diff --git a/sound/isa/es1688/es1688.c b/sound/isa/es1688/es1688.c
index f88639e..80951b8 100644
--- a/sound/isa/es1688/es1688.c
+++ b/sound/isa/es1688/es1688.c
@@ -128,6 +128,8 @@ static int __devinit snd_es1688_probe(struct device *dev, unsigned int n)
 	if (!card)
 		return -EINVAL;
 
+	snd_card_set_dev(card, dev);
+
 	error = snd_es1688_legacy_create(card, dev, n, &chip);
 	if (error < 0)
 		goto out;
@@ -164,8 +166,6 @@ static int __devinit snd_es1688_probe(struct device *dev, unsigned int n)
 			goto out;
 	}
 
-	snd_card_set_dev(card, dev);
-
 	error = snd_card_register(card);
 	if (error < 0)
 		goto out;
diff --git a/sound/isa/es1688/es1688_lib.c b/sound/isa/es1688/es1688_lib.c
index 1e1e575..170d78c 100644
--- a/sound/isa/es1688/es1688_lib.c
+++ b/sound/isa/es1688/es1688_lib.c
@@ -740,7 +740,7 @@ int snd_es1688_pcm(struct snd_es1688 * chip, int device, struct snd_pcm ** rpcm)
 	chip->pcm = pcm;
 
 	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV,
-					      snd_dma_isa_data(),
+					      snd_dma_isa_data(chip->card),
 					      64*1024, 64*1024);
 
 	if (rpcm)
diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index 90498e4..05b3aca 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -1721,7 +1721,7 @@ static int __devinit snd_es18xx_pcm(struct snd_es18xx *chip, int device, struct
         chip->pcm = pcm;
 
 	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV,
-					      snd_dma_isa_data(),
+					      snd_dma_isa_data(chip->card),
 					      64*1024,
 					      chip->dma1 > 3 || chip->dma2 > 3 ? 128*1024 : 64*1024);
 
diff --git a/sound/isa/gus/gus_pcm.c b/sound/isa/gus/gus_pcm.c
index 99731dc..b82bc55 100644
--- a/sound/isa/gus/gus_pcm.c
+++ b/sound/isa/gus/gus_pcm.c
@@ -857,7 +857,7 @@ int snd_gf1_pcm_new(struct snd_gus_card * gus, int pcm_dev, int control_index, s
 
 	for (substream = pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream; substream; substream = substream->next)
 		snd_pcm_lib_preallocate_pages(substream, SNDRV_DMA_TYPE_DEV,
-					      snd_dma_isa_data(),
+					      snd_dma_isa_data(card),
 					      64*1024, gus->gf1.dma1 > 3 ? 128*1024 : 64*1024);
 	
 	pcm->info_flags = 0;
@@ -867,7 +867,7 @@ int snd_gf1_pcm_new(struct snd_gus_card * gus, int pcm_dev, int control_index, s
 		if (gus->gf1.dma2 == gus->gf1.dma1)
 			pcm->info_flags |= SNDRV_PCM_INFO_HALF_DUPLEX;
 		snd_pcm_lib_preallocate_pages(pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream,
-					      SNDRV_DMA_TYPE_DEV, snd_dma_isa_data(),
+					      SNDRV_DMA_TYPE_DEV, snd_dma_isa_data(card),
 					      64*1024, gus->gf1.dma2 > 3 ? 128*1024 : 64*1024);
 	}
 	strcpy(pcm->name, pcm->id);
diff --git a/sound/isa/gus/gusclassic.c b/sound/isa/gus/gusclassic.c
index 8f914b3..d6e5124 100644
--- a/sound/isa/gus/gusclassic.c
+++ b/sound/isa/gus/gusclassic.c
@@ -155,6 +155,8 @@ static int __devinit snd_gusclassic_probe(struct device *dev, unsigned int n)
 	if (!card)
 		return -EINVAL;
 
+	snd_card_set_dev(card, dev);
+
 	if (pcm_channels[n] < 2)
 		pcm_channels[n] = 2;
 
@@ -201,8 +203,6 @@ static int __devinit snd_gusclassic_probe(struct device *dev, unsigned int n)
 		sprintf(card->longname + strlen(card->longname),
 			"&%d", gus->gf1.dma2);
 
-	snd_card_set_dev(card, dev);
-
 	error = snd_card_register(card);
 	if (error < 0)
 		goto out;
diff --git a/sound/isa/gus/gusextreme.c b/sound/isa/gus/gusextreme.c
index da13185..c016193 100644
--- a/sound/isa/gus/gusextreme.c
+++ b/sound/isa/gus/gusextreme.c
@@ -249,6 +249,8 @@ static int __devinit snd_gusextreme_probe(struct device *dev, unsigned int n)
 	if (!card)
 		return -EINVAL;
 
+	snd_card_set_dev(card, dev);
+
 	if (mpu_port[n] == SNDRV_AUTO_PORT)
 		mpu_port[n] = 0;
 
@@ -330,8 +332,6 @@ static int __devinit snd_gusextreme_probe(struct device *dev, unsigned int n)
 		"irq %i&%i, dma %i&%i", es1688->port,
 		gus->gf1.irq, es1688->irq, gus->gf1.dma1, es1688->dma8);
 
-	snd_card_set_dev(card, dev);
-
 	error = snd_card_register(card);
 	if (error < 0)
 		goto out;
diff --git a/sound/isa/gus/gusmax.c b/sound/isa/gus/gusmax.c
index f87c623..47c287b 100644
--- a/sound/isa/gus/gusmax.c
+++ b/sound/isa/gus/gusmax.c
@@ -221,6 +221,9 @@ static int __devinit snd_gusmax_probe(struct device *pdev, unsigned int dev)
 			    sizeof(struct snd_gusmax));
 	if (card == NULL)
 		return -ENOMEM;
+
+	snd_card_set_dev(card, pdev);
+
 	card->private_free = snd_gusmax_free;
 	maxcard = (struct snd_gusmax *)card->private_data;
 	maxcard->card = card;
@@ -334,8 +337,6 @@ static int __devinit snd_gusmax_probe(struct device *pdev, unsigned int dev)
 	if (xdma2 >= 0)
 		sprintf(card->longname + strlen(card->longname), "&%i", xdma2);
 
-	snd_card_set_dev(card, pdev);
-
 	if ((err = snd_card_register(card)) < 0)
 		goto _err;
 		
diff --git a/sound/isa/opti9xx/miro.c b/sound/isa/opti9xx/miro.c
index 2a1e2f5..2dbf2f8 100644
--- a/sound/isa/opti9xx/miro.c
+++ b/sound/isa/opti9xx/miro.c
@@ -1231,6 +1231,8 @@ static int __devinit snd_miro_probe(struct device *devptr, unsigned int n)
 				  sizeof(struct snd_miro))))
 		return -ENOMEM;
 
+	snd_card_set_dev(card, devptr);
+
 	card->private_free = snd_card_miro_free;
 	miro = card->private_data;
 	miro->card = card;
@@ -1396,8 +1398,6 @@ static int __devinit snd_miro_probe(struct device *devptr, unsigned int n)
                 return error;
 	}
 
-	snd_card_set_dev(card, devptr);
-
 	if ((error = snd_card_register(card))) {
 		snd_card_free(card);
 		return error;
diff --git a/sound/isa/opti9xx/opti92x-ad1848.c b/sound/isa/opti9xx/opti92x-ad1848.c
index fe1afc1..761347f 100644
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -1368,7 +1368,7 @@ static int snd_opti93x_pcm(struct snd_opti93x *codec, int device, struct snd_pcm
 	strcpy(pcm->name, snd_opti93x_chip_id(codec));
 
 	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV,
-					      snd_dma_isa_data(),
+					      snd_dma_isa_data(codec->card),
 					      64*1024, codec->dma1 > 3 || codec->dma2 > 3 ? 128*1024 : 64*1024);
 
 	codec->pcm = pcm;
diff --git a/sound/isa/sb/sb16_main.c b/sound/isa/sb/sb16_main.c
index f7e8192..9878041 100644
--- a/sound/isa/sb/sb16_main.c
+++ b/sound/isa/sb/sb16_main.c
@@ -887,7 +887,7 @@ int snd_sb16dsp_pcm(struct snd_sb * chip, int device, struct snd_pcm ** rpcm)
 		pcm->info_flags = SNDRV_PCM_INFO_HALF_DUPLEX;
 
 	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV,
-					      snd_dma_isa_data(),
+					      snd_dma_isa_data(card),
 					      64*1024, 128*1024);
 
 	if (rpcm)
diff --git a/sound/isa/sb/sb8.c b/sound/isa/sb/sb8.c
index 336a342..8cb40ef 100644
--- a/sound/isa/sb/sb8.c
+++ b/sound/isa/sb/sb8.c
@@ -107,6 +107,9 @@ static int __devinit snd_sb8_probe(struct device *pdev, unsigned int dev)
 			    sizeof(struct snd_sb8));
 	if (card == NULL)
 		return -ENOMEM;
+
+	snd_card_set_dev(card, pdev);
+
 	acard = card->private_data;
 	card->private_free = snd_sb8_free;
 
@@ -191,8 +194,6 @@ static int __devinit snd_sb8_probe(struct device *pdev, unsigned int dev)
 		chip->port,
 		irq[dev], dma8[dev]);
 
-	snd_card_set_dev(card, pdev);
-
 	if ((err = snd_card_register(card)) < 0)
 		goto _err;
 
diff --git a/sound/isa/sb/sb8_main.c b/sound/isa/sb/sb8_main.c
index fe03bb8..7ef15a3 100644
--- a/sound/isa/sb/sb8_main.c
+++ b/sound/isa/sb/sb8_main.c
@@ -524,7 +524,7 @@ int snd_sb8dsp_pcm(struct snd_sb *chip, int device, struct snd_pcm ** rpcm)
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &snd_sb8_capture_ops);
 
 	snd_pcm_lib_preallocate_pages_for_all(pcm, SNDRV_DMA_TYPE_DEV,
-					      snd_dma_isa_data(),
+					      snd_dma_isa_data(card),
 					      64*1024, 64*1024);
 
 	if (rpcm)
diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
index da3d152..a99c42c 100644
--- a/sound/isa/sc6000.c
+++ b/sound/isa/sc6000.c
@@ -493,6 +493,8 @@ static int __devinit snd_sc6000_probe(struct device *devptr, unsigned int dev)
 	if (!card)
 		return -ENOMEM;
 
+	snd_card_set_dev(card, devptr);
+
 	if (xirq == SNDRV_AUTO_IRQ) {
 		xirq = snd_legacy_find_free_irq(possible_irqs);
 		if (xirq < 0) {
@@ -602,8 +604,6 @@ static int __devinit snd_sc6000_probe(struct device *devptr, unsigned int dev)
 	sprintf(card->longname, "Gallant SC-6000 at 0x%lx, irq %d, dma %d",
 		mss_port[dev], xirq, xdma);
 
-	snd_card_set_dev(card, devptr);
-
 	err = snd_card_register(card);
 	if (err < 0)
 		goto err_unmap2;
diff --git a/sound/isa/sgalaxy.c b/sound/isa/sgalaxy.c
index a07274e..2e04666 100644
--- a/sound/isa/sgalaxy.c
+++ b/sound/isa/sgalaxy.c
@@ -243,6 +243,8 @@ static int __devinit snd_sgalaxy_probe(struct device *devptr, unsigned int dev)
 	if (card == NULL)
 		return -ENOMEM;
 
+	snd_card_set_dev(card, devptr);
+
 	xirq = irq[dev];
 	if (xirq == SNDRV_AUTO_IRQ) {
 		if ((xirq = snd_legacy_find_free_irq(possible_irqs)) < 0) {
@@ -287,8 +289,6 @@ static int __devinit snd_sgalaxy_probe(struct device *devptr, unsigned int dev)
 	sprintf(card->longname, "Sound Galaxy at 0x%lx, irq %d, dma %d",
 		wssport[dev], xirq, xdma1);
 
-	snd_card_set_dev(card, devptr);
-
 	if ((err = snd_card_register(card)) < 0)
 		goto _err;
 
diff --git a/sound/isa/sscape.c b/sound/isa/sscape.c
index 06ad786..002a3a0 100644
--- a/sound/isa/sscape.c
+++ b/sound/isa/sscape.c
@@ -147,6 +147,7 @@ struct soundscape {
 	enum card_type type;
 	struct resource *io_res;
 	struct resource *wss_res;
+	struct snd_card *card;
 	struct snd_cs4231 *chip;
 	struct snd_mpu401 *mpu;
 	struct snd_hwdep *hw;
@@ -185,16 +186,18 @@ static inline struct soundscape *get_hwdep_soundscape(struct snd_hwdep * hw)
  * I think this means that the memory has to map to
  * contiguous pages of physical memory.
  */
-static struct snd_dma_buffer *get_dmabuf(struct snd_dma_buffer *buf, unsigned long size)
+static struct snd_dma_buffer *get_dmabuf(struct snd_card *card,
+		struct snd_dma_buffer *buf, unsigned long size)
 {
 	if (buf) {
-		if (snd_dma_alloc_pages_fallback(SNDRV_DMA_TYPE_DEV, snd_dma_isa_data(),
+		if (snd_dma_alloc_pages_fallback(SNDRV_DMA_TYPE_DEV,
+						 snd_dma_isa_data(card),
 						 size, buf) < 0) {
-			snd_printk(KERN_ERR "sscape: Failed to allocate %lu bytes for DMA\n", size);
+			snd_printk(KERN_ERR "sscape: Failed to allocate "
+				   "%lu bytes for DMA\n", size);
 			return NULL;
 		}
 	}
-
 	return buf;
 }
 
@@ -452,7 +455,7 @@ static int upload_dma_data(struct soundscape *s,
 	struct snd_dma_buffer dma;
 	int ret;
 
-	if (!get_dmabuf(&dma, PAGE_ALIGN(size)))
+	if (!get_dmabuf(s->card, &dma, PAGE_ALIGN(size)))
 		return -ENOMEM;
 
 	spin_lock_irqsave(&s->lock, flags);
@@ -1359,7 +1362,10 @@ static int __devinit snd_sscape_probe(struct device *pdev, unsigned int dev)
 	if (!card)
 		return -ENOMEM;
 
+	snd_card_set_dev(card, pdev);
+
 	sscape = get_card_soundscape(card);
+	sscape->card = card;
 	sscape->type = SSCAPE;
 
 	dma[dev] &= 0x03;
@@ -1367,7 +1373,6 @@ static int __devinit snd_sscape_probe(struct device *pdev, unsigned int dev)
 	if (ret < 0)
 		goto _release_card;
 
-	snd_card_set_dev(card, pdev);
 	if ((ret = snd_card_register(card)) < 0) {
 		printk(KERN_ERR "sscape: Failed to register sound card\n");
 		goto _release_card;
@@ -1464,7 +1469,10 @@ static int __devinit sscape_pnp_detect(struct pnp_card_link *pcard,
 	if (!card)
 		return -ENOMEM;
 
+	snd_card_set_dev(card, &pcard->card->dev);
+
 	sscape = get_card_soundscape(card);
+	sscape->card = card;
 
 	/*
 	 * Identify card model ...
@@ -1493,7 +1501,6 @@ static int __devinit sscape_pnp_detect(struct pnp_card_link *pcard,
 	if (ret < 0)
 		goto _release_card;
 
-	snd_card_set_dev(card, &pcard->card->dev);
 	if ((ret = snd_card_register(card)) < 0) {
 		printk(KERN_ERR "sscape: Failed to register sound card\n");
 		goto _release_card;

--------------010803070404060408070506--
