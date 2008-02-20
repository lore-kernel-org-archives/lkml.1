Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbYBTIRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbYBTIRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 03:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYBTIRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 03:17:35 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47961 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631AbYBTIRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 03:17:34 -0500
X-Sasl-enc: sowv6S+hKFXPerF/DBn2vukeEAjLjWpU81Aov+WHENyJ 1203495453
Message-ID: <47BBE288.7010501@ladisch.de>
Date: Wed, 20 Feb 2008 09:19:20 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andreas Matthus <matthus@nexgo.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: snd_bt87x crash with kernel 2.6.24.2 on amd64
References: <1203449798.9669.19.camel@mahome1.localdomain>
In-Reply-To: <1203449798.9669.19.camel@mahome1.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Matthus wrote:
> Feb 19 19:17:01 mahome1 kernel: RIP: 0010:[<ffffffff88486a52>]  [<ffffffff88486a52>] :snd_bt87x:snd_bt87x_interrupt+0x13/0x1b8
> ...
> Feb 19 19:17:01 mahome1 kernel:  [<ffffffff80262739>] free_irq+0xf6/0x141
> Feb 19 19:17:01 mahome1 kernel:  [<ffffffff884861f2>] :snd_bt87x:snd_bt87x_free+0x34/0x52

This is caused a bug in the driver (it calls iounmap() before
free_irq()).

The patch below fixes this (I just applied it to the ALSA tree);
or you could disable CONFIG_DEBUG_SHIRQ.


Regards,
Clemens

-- 
bt87X: fix freeing of shared interrupt

Call free_irq() after iounmap() because other devices could trigger our
shared interrupt handler.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- linux.orig/sound/pci/bt87x.c	Tue Feb 19 15:03:57 2008 +0100
+++ linux/sound/pci/bt87x.c	Wed Feb 20 08:55:18 2008 +0100
@@ -681,15 +681,12 @@ static struct snd_kcontrol_new snd_bt87x

 static int snd_bt87x_free(struct snd_bt87x *chip)
 {
-	if (chip->mmio) {
+	if (chip->mmio)
 		snd_bt87x_stop(chip);
-		if (chip->irq >= 0)
-			synchronize_irq(chip->irq);
-
-		iounmap(chip->mmio);
-	}
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
+	if (chip->mmio)
+		iounmap(chip->mmio);
 	pci_release_regions(chip->pci);
 	pci_disable_device(chip->pci);
 	kfree(chip);
