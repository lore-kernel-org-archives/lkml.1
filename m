Return-Path: <linux-kernel-owner+w=401wt.eu-S1760436AbZCPU0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436AbZCPU0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 16:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758469AbZCPU0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 16:26:09 -0400
Received: from mx1.wp.pl ([212.77.101.5]:54324 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758353AbZCPU0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 16:26:08 -0400
Date: Mon, 16 Mar 2009 21:32:25 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-sound@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix NULL dereference when suspending snd_opl3sa2
Message-Id: <20090316213225.5d59aca1.krzysztof.h1@wp.pl>
In-Reply-To: <1237212968.11067.3.camel@localhost.localdomain>
References: <1237197709.7210.2.camel@localhost.localdomain>
	<1237212968.11067.3.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [AeN0]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009 15:16:08 +0100
Lubomir Rintel <lkundrak@v3.sk> wrote:

> On Mon, 2009-03-16 at 11:01 +0100, Lubomir Rintel wrote:
> > This should fix the following OOPS:
> > http://www.kerneloops.org/raw.php?rawid=80591&msgid=
> 

> This is the same issue, with 2.6.28:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=519939
> 
> 

One should no force loading of the snd-opl3sa2 driver
in the above cases. It was forced as the opl3sa2 is a PnP chip
and the drivers were loaded as plain ISA devices.

However, this is not a cause of the OOPS. The cause is that
despite the driver returns -ENODEV, the higher layer
hides it and the driver is bound to the bus. I suppose,
the suspend and resume functions are called on it.

Look at the ISA probe function:

static int __devinit snd_opl3sa2_isa_probe(struct device *pdev,
                       unsigned int dev)
{
    struct snd_card *card;
    int err;

    card = snd_opl3sa2_card_new(dev);
    if (! card)
        return -ENOMEM;
    snd_card_set_dev(card, pdev);
    if ((err = snd_opl3sa2_probe(card, dev)) < 0) {
        snd_card_free(card);
        return err;
    }
    dev_set_drvdata(pdev, card);
    return 0;
}

If the probe function fails, the drvdata is
never set to the snd_card structure pointer.

The patch below should fix suspend and resume
functions.

Regards,
Krzysztof
PS. It is the same situation for PnP and
BIOS PnP probing in this driver.
---

Fix the OOPS during a opl3sa2 card suspend
and resume if the driver is loaded but the card
is not found.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>

--- a/sound/isa/opl3sa2.c~	2008-10-13 18:03:52.000000000 +0200
+++ b/sound/isa/opl3sa2.c	2009-03-16 21:20:30.841348261 +0100
@@ -550,21 +550,27 @@ static int __devinit snd_opl3sa2_mixer(s
 #ifdef CONFIG_PM
 static int snd_opl3sa2_suspend(struct snd_card *card, pm_message_t state)
 {
-	struct snd_opl3sa2 *chip = card->private_data;
+	if (card) {
+		struct snd_opl3sa2 *chip = card->private_data;
 
-	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
-	chip->wss->suspend(chip->wss);
-	/* power down */
-	snd_opl3sa2_write(chip, OPL3SA2_PM_CTRL, OPL3SA2_PM_D3);
+		snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
+		chip->wss->suspend(chip->wss);
+		/* power down */
+		snd_opl3sa2_write(chip, OPL3SA2_PM_CTRL, OPL3SA2_PM_D3);
+	}
 
 	return 0;
 }
 
 static int snd_opl3sa2_resume(struct snd_card *card)
 {
-	struct snd_opl3sa2 *chip = card->private_data;
+	struct snd_opl3sa2 *chip;
 	int i;
 
+	if (!card)
+		return 0;
+
+	chip = card->private_data;
 	/* power up */
 	snd_opl3sa2_write(chip, OPL3SA2_PM_CTRL, OPL3SA2_PM_D0);
 

