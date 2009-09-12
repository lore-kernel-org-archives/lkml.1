Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbZILMZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbZILMZh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 08:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbZILMZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 08:25:36 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:50135 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbZILMZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 08:25:35 -0400
Date: Sat, 12 Sep 2009 14:25:35 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 8/8, retry] sound/soc: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0909121424420.8557@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.
Error handling code following an ioremap should iounmap the allocated data.

The semantic match that finds the first problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 sound/soc/fsl/mpc5200_dma.c         |   33 ++++++++++++--------
 1 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/var/linuxes/linux-next/sound/soc/fsl/mpc5200_dma.c b/var/julia/linuxcopy/sound/soc/fsl/mpc5200_dma.c
index 9ff62e3..6096d22 100644
--- a/var/linuxes/linux-next/sound/soc/fsl/mpc5200_dma.c
+++ b/var/julia/linuxcopy/sound/soc/fsl/mpc5200_dma.c
@@ -447,6 +447,7 @@ int mpc5200_audio_dma_create(struct of_device *op)
 	int size, irq, rc;
 	const __be32 *prop;
 	void __iomem *regs;
+	int ret;
 
 	/* Fetch the registers and IRQ of the PSC */
 	irq = irq_of_parse_and_map(op->node, 0);
@@ -463,14 +464,16 @@ int mpc5200_audio_dma_create(struct of_device *op)
 	/* Allocate and initialize the driver private data */
 	psc_dma = kzalloc(sizeof *psc_dma, GFP_KERNEL);
 	if (!psc_dma) {
-		iounmap(regs);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_unmap;
 	}
 
 	/* Get the PSC ID */
 	prop = of_get_property(op->node, "cell-index", &size);
-	if (!prop || size < sizeof *prop)
-		return -ENODEV;
+	if (!prop || size < sizeof *prop) {
+		ret = -ENODEV;
+		goto out_free;
+	}
 
 	spin_lock_init(&psc_dma->lock);
 	mutex_init(&psc_dma->mutex);
@@ -493,9 +496,8 @@ int mpc5200_audio_dma_create(struct of_device *op)
 	if (!psc_dma->capture.bcom_task ||
 	    !psc_dma->playback.bcom_task) {
 		dev_err(&op->dev, "Could not allocate bestcomm tasks\n");
-		iounmap(regs);
-		kfree(psc_dma);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_free;
 	}
 
 	/* Disable all interrupts and reset the PSC */
@@ -537,12 +539,8 @@ int mpc5200_audio_dma_create(struct of_device *op)
 			  &psc_dma_bcom_irq_tx, IRQF_SHARED,
 			  "psc-dma-playback", &psc_dma->playback);
 	if (rc) {
-		free_irq(psc_dma->irq, psc_dma);
-		free_irq(psc_dma->capture.irq,
-			 &psc_dma->capture);
-		free_irq(psc_dma->playback.irq,
-			 &psc_dma->playback);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_irq;
 	}
 
 	/* Save what we've done so it can be found again later */
@@ -550,6 +548,15 @@ int mpc5200_audio_dma_create(struct of_device *op)
 
 	/* Tell the ASoC OF helpers about it */
 	return snd_soc_register_platform(&mpc5200_audio_dma_platform);
+out_irq:
+	free_irq(psc_dma->irq, psc_dma);
+	free_irq(psc_dma->capture.irq, &psc_dma->capture);
+	free_irq(psc_dma->playback.irq, &psc_dma->playback);
+out_free:
+	kfree(psc_dma);
+out_unmap:
+	iounmap(regs);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(mpc5200_audio_dma_create);
 
