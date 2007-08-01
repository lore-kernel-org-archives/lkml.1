Return-Path: <linux-kernel-owner+w=401wt.eu-S1759023AbXHAGDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023AbXHAGDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 02:03:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756025AbXHAGC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 02:02:59 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:50659 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbXHAGC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 02:02:58 -0400
Date: Wed, 01 Aug 2007 02:02:56 -0400
To: <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-sound@vger.kernel.org>
Subject: [PATCH 2/3] sound/pci ioremap/iounmap balancing
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070801060256.F0BA2DA820@mailserver8.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ioremap / iounmap balancing in sound/pci tree

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
---
diff --git a/sound/pci/mixart/mixart.c b/sound/pci/mixart/mixart.c
index ac007ce..871b09f 100644
--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -1319,6 +1319,13 @@ static int __devinit snd_mixart_probe(struct 
pci_dev *pci,
 						   pci_resource_len(pci, i));
 	}
 
+	if (!mgr->mem[0].virt || !mgr->mem[1].virt){
+		printk(KERN_ERR "unable to remap resource 0x%lx and/or 0x%lx\n",
+			mgr->mem[0].phys, mgr->mem[1].phys);
+		snd_mixart_free(mgr);
+		return -EBUSY;
+	}
+
 	if (request_irq(pci->irq, snd_mixart_interrupt, IRQF_SHARED,
 			CARD_NAME, mgr)) {
 		snd_printk(KERN_ERR "unable to grab IRQ %d\n", pci->irq);
diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
index 618653e..d62d32a 100644
--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -1373,6 +1373,7 @@ static int __devinit snd_rme32_create(struct 
rme32 * rme32)
 	if (request_irq(pci->irq, snd_rme32_interrupt, IRQF_SHARED,
 			"RME32", rme32)) {
 		snd_printk(KERN_ERR "unable to grab IRQ %d\n", pci->irq);
+		iounmap(rme32->iobase);
 		return -EBUSY;
 	}
 	rme32->irq = pci->irq;
@@ -1382,6 +1383,7 @@ static int __devinit snd_rme32_create(struct 
rme32 * rme32)
 
 	/* set up ALSA pcm device for S/PDIF */
 	if ((err = snd_pcm_new(rme32->card, "Digi32 IEC958", 0, 1, 1, 
&rme32->spdif_pcm)) < 0) {
+		iounmap(rme32->iobase);
 		return err;
 	}
 	rme32->spdif_pcm->private_data = rme32;
@@ -1414,6 +1416,7 @@ static int __devinit snd_rme32_create(struct 
rme32 * rme32)
 		if ((err = snd_pcm_new(rme32->card, "Digi32 ADAT", 1,
 				       1, 1, &rme32->adat_pcm)) < 0)
 		{
+			iounmap(rme32->iobase);
 			return err;
 		}		
 		rme32->adat_pcm->private_data = rme32;
@@ -1459,6 +1462,7 @@ static int __devinit snd_rme32_create(struct 
rme32 * rme32)
 
 	/* init switch interface */
 	if ((err = snd_rme32_create_switches(rme32->card, rme32)) < 0) {
+		iounmap(rme32->iobase);
 		return err;
 	}
 
diff --git a/sound/pci/rme96.c b/sound/pci/rme96.c
index e3304b7..25af36c 100644
--- a/sound/pci/rme96.c
+++ b/sound/pci/rme96.c
@@ -1590,6 +1590,7 @@ snd_rme96_create(struct rme96 *rme96)
 	if (request_irq(pci->irq, snd_rme96_interrupt, IRQF_SHARED,
 			"RME96", rme96)) {
 		snd_printk(KERN_ERR "unable to grab IRQ %d\n", pci->irq);
+		iounmap(rme96->iobase);
 		return -EBUSY;
 	}
 	rme96->irq = pci->irq;
@@ -1601,6 +1602,7 @@ snd_rme96_create(struct rme96 *rme96)
 	if ((err = snd_pcm_new(rme96->card, "Digi96 IEC958", 0,
 			       1, 1, &rme96->spdif_pcm)) < 0)
 	{
+		iounmap(rme96->iobase);
 		return err;
 	}
 	rme96->spdif_pcm->private_data = rme96;
@@ -1619,6 +1621,7 @@ snd_rme96_create(struct rme96 *rme96)
 		if ((err = snd_pcm_new(rme96->card, "Digi96 ADAT", 1,
 				       1, 1, &rme96->adat_pcm)) < 0)
 		{
+			iounmap(rme96->iobase);
 			return err;
 		}		
 		rme96->adat_pcm->private_data = rme96;
@@ -1671,6 +1674,7 @@ snd_rme96_create(struct rme96 *rme96)
 	
 	/* init switch interface */
 	if ((err = snd_rme96_create_switches(rme96->card, rme96)) < 0) {
+		iounmap(rme96->iobase);
 		return err;
 	}
 
diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index 3b3ef65..031285f 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -5049,6 +5049,7 @@ static int __devinit snd_hdsp_create(struct 
snd_card *card,
 	if (request_irq(pci->irq, snd_hdsp_interrupt, IRQF_SHARED,
 			"hdsp", hdsp)) {
 		snd_printk(KERN_ERR "Hammerfall-DSP: unable to use IRQ %d\n", 
pci->irq);
+		iounmap(hdsp->iobase);
 		return -EBUSY;
 	}
 
@@ -5057,8 +5058,10 @@ static int __devinit snd_hdsp_create(struct 
snd_card *card,
 	hdsp->use_midi_tasklet = 1;
 	hdsp->dds_value = 0;
 
-	if ((err = snd_hdsp_initialize_memory(hdsp)) < 0)
+	if ((err = snd_hdsp_initialize_memory(hdsp)) < 0) {
+		iounmap(hdsp->iobase);
 		return err;
+	}
 	
 	if (!is_9652 && !is_9632) {
 		/* we wait 2 seconds to let freshly inserted cardbus cards do 
their hardware init */
@@ -5078,8 +5081,10 @@ static int __devinit snd_hdsp_create(struct 
snd_card *card,
 #endif
 			/* no iobox connected, we defer initialization */
 			snd_printk(KERN_INFO "Hammerfall-DSP: card initialization 
pending : waiting for firmware\n");
-			if ((err = snd_hdsp_create_hwdep(card, hdsp)) < 0)
+			if ((err = snd_hdsp_create_hwdep(card, hdsp)) < 0) {
+				iounmap(hdsp->iobase);
 				return err;
+			}
 			return 0;
 		} else {
 			snd_printk(KERN_INFO "Hammerfall-DSP: Firmware already present, 
initializing card.\n");	    
@@ -5090,8 +5095,10 @@ static int __devinit snd_hdsp_create(struct 
snd_card *card,
 		}
 	}
 	
-	if ((err = snd_hdsp_enable_io(hdsp)) != 0)
+	if ((err = snd_hdsp_enable_io(hdsp)) != 0) {
+		iounmap(hdsp->iobase);
 		return err;
+	}
 	
 	if (is_9652)
 	        hdsp->io_type = H9652;
@@ -5099,16 +5106,20 @@ static int __devinit snd_hdsp_create(struct 
snd_card *card,
 	if (is_9632)
 		hdsp->io_type = H9632;
 
-	if ((err = snd_hdsp_create_hwdep(card, hdsp)) < 0)
+	if ((err = snd_hdsp_create_hwdep(card, hdsp)) < 0) {
+		iounmap(hdsp->iobase);
 		return err;
+	}
 	
 	snd_hdsp_initialize_channels(hdsp);
 	snd_hdsp_initialize_midi_flush(hdsp);
 
 	hdsp->state |= HDSP_FirmwareLoaded;	
 
-	if ((err = snd_hdsp_create_alsa_devices(card, hdsp)) < 0)
+	if ((err = snd_hdsp_create_alsa_devices(card, hdsp)) < 0) {
+		iounmap(hdsp->iobase);
 		return err;
+	}
 
 	return 0;	
 }
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 143185e..41fa677 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -4423,6 +4423,7 @@ static int __devinit snd_hdspm_create(struct 
snd_card *card, struct hdspm * hdsp
 	if (request_irq(pci->irq, snd_hdspm_interrupt,
 			IRQF_SHARED, "hdspm", hdspm)) {
 		snd_printk(KERN_ERR "HDSPM: unable to use IRQ %d\n", pci->irq);
+		iounmap(hdspm->iobase);
 		return -EBUSY;
 	}
 
@@ -4439,6 +4440,7 @@ static int __devinit snd_hdspm_create(struct 
snd_card *card, struct hdspm * hdsp
 	    == NULL) {
 		snd_printk(KERN_ERR "HDSPM: unable to kmalloc Mixer memory of %d 
Bytes\n",
 			   (int)sizeof(struct hdspm_mixer));
+		iounmap(hdspm->iobase);
 		return err;
 	}
 
@@ -4447,8 +4449,10 @@ static int __devinit snd_hdspm_create(struct 
snd_card *card, struct hdspm * hdsp
 	hdspm->qs_channels = MADI_QS_CHANNELS;
 
 	snd_printdd("create alsa devices.\n");
-	if ((err = snd_hdspm_create_alsa_devices(card, hdspm)) < 0)
+	if ((err = snd_hdspm_create_alsa_devices(card, hdspm)) < 0) {
+		iounmap(hdspm->iobase);
 		return err;
+        }
 
 	snd_hdspm_initialize_midi_flush(hdspm);
 
diff --git a/sound/pci/rme9652/rme9652.c 
b/sound/pci/rme9652/rme9652.c
index 2de2740..39a54b0 100644
--- a/sound/pci/rme9652/rme9652.c
+++ b/sound/pci/rme9652/rme9652.c
@@ -2499,6 +2499,7 @@ static int __devinit 
snd_rme9652_create(struct snd_card *card,
 	if (request_irq(pci->irq, snd_rme9652_interrupt, IRQF_SHARED,
 			"rme9652", rme9652)) {
 		snd_printk(KERN_ERR "unable to request IRQ %d\n", pci->irq);
+		iounmap(rme9652->iobase);
 		return -EBUSY;
 	}
 	rme9652->irq = pci->irq;
@@ -2559,14 +2560,17 @@ static int __devinit 
snd_rme9652_create(struct snd_card *card,
 	pci_set_master(rme9652->pci);
 
 	if ((err = snd_rme9652_initialize_memory(rme9652)) < 0) {
+		iounmap(rme9652->iobase);
 		return err;
 	}
 
 	if ((err = snd_rme9652_create_pcm(card, rme9652)) < 0) {
+		iounmap(rme9652->iobase);
 		return err;
 	}
 
 	if ((err = snd_rme9652_create_controls(card, rme9652)) < 0) {
+		iounmap(rme9652->iobase);
 		return err;
 	}

--
Visa, MasterCard, AMEX & Discover. Compare Offers & Apply Online. Click here!
http://tagline.hushmail.com/fc/Ioyw6h4d7hwdLPGBswmlpQKKbUXiJeVVD0oC89hmCkABDgmd6flwdG/

