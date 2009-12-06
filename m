Return-Path: <linux-kernel-owner+w=401wt.eu-S933892AbZLFQvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892AbZLFQvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 11:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932881AbZLFQvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 11:51:48 -0500
Received: from fallback3.mail.ru ([94.100.176.58]:42761 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933880AbZLFQvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 11:51:47 -0500
Date: Sun, 6 Dec 2009 19:51:18 +0300
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org
Subject: Re: linux-next: manual merge of the pcmcia tree with the arm tree
Message-ID: <20091206165118.GA6082@rainbow>
References: <20091201140310.46dbdc59.sfr@canb.auug.org.au>
 <20091202115649.GA2150@rainbow>
 <20091203092525.17d939b3.sfr@canb.auug.org.au>
 <20091205103038.GA11140@flint.arm.linux.org.uk>
 <20091205110721.GB23213@isilmar.linta.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20091205110721.GB23213@isilmar.linta.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 12:07 Sat 05 Dec     , Dominik Brodowski wrote:
> On Sat, Dec 05, 2009 at 10:30:38AM +0000, Russell King wrote:
> > Since Dominik has been ignoring this issue, and has already asked Linus to
> > pull his tree with my (unfortunately just discovered buggy) changes in, I'm
> > going to drop the H3600 PCMCIA changes until something can be sorted out.
> 
> Well, I hope that Linus merges the first bunch of PCMCIA changes soon, so
> that we have a clean base to work from and to sort the dependecies in
> ARM-related patches out.

Well, looks like PCMCIA changes hit Linus' tree already, so the only way
now is to rebase h3600 patches. Closer look show that only one patch in
series needs rebasing - this one:
  ARM: 5811/1: pcmcia: convert sa1100_h3600 driver to gpiolib

Russell, I submitted rebased version to your patch system as 5811/2
It also attached to this letter. Hope this would help to resolve issue.

-- 
Best regards,
Dmitry "MAD" Artamonow


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-pcmcia-convert-sa1100_h3600-driver-to-gpiolib.patch"

>From ce07b36a48f3b72d96f69c5138af3d0489ecd591 Mon Sep 17 00:00:00 2001
From: Dmitry Artamonow <mad_soft@inbox.ru>
Date: Wed, 14 Oct 2009 17:26:41 +0400
Subject: pcmcia: convert sa1100_h3600 driver to gpiolib

Convert all operations with GPLR/GPCR/GPSR to gpiolibs calls.
Also change all IRQ_GPIO* to gpio_to_irq(*GPIO*)

Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
---
 drivers/pcmcia/sa1100_h3600.c |   82 +++++++++++++++++++++++++++++++++++-----
 1 files changed, 71 insertions(+), 11 deletions(-)

diff --git a/drivers/pcmcia/sa1100_h3600.c b/drivers/pcmcia/sa1100_h3600.c
index 3a121ac..97e5667 100644
--- a/drivers/pcmcia/sa1100_h3600.c
+++ b/drivers/pcmcia/sa1100_h3600.c
@@ -10,26 +10,78 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/gpio.h>
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
 #include <asm/mach-types.h>
 #include <mach/h3600.h>
+#include <mach/h3600_gpio.h>
 
 #include "sa1100_generic.h"
 
 static struct pcmcia_irqs irqs[] = {
-	{ 0, IRQ_GPIO_H3600_PCMCIA_CD0, "PCMCIA CD0" },
-	{ 1, IRQ_GPIO_H3600_PCMCIA_CD1, "PCMCIA CD1" }
+	{ .sock = 0, .str = "PCMCIA CD0" }, /* .irq will be filled later */
+	{ .sock = 1, .str = "PCMCIA CD1" }
 };
 
 static int h3600_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
 {
-	skt->socket.pci_irq = skt->nr ? IRQ_GPIO_H3600_PCMCIA_IRQ1
-				      : IRQ_GPIO_H3600_PCMCIA_IRQ0;
+	int err;
 
+	switch (skt->nr) {
+	case 0:
+		err = gpio_request(H3XXX_GPIO_PCMCIA_IRQ0, "PCMCIA IRQ0");
+		if (err)
+			goto err00;
+		err = gpio_direction_input(H3XXX_GPIO_PCMCIA_IRQ0);
+		if (err)
+			goto err01;
+		skt->socket.pci_irq = gpio_to_irq(H3XXX_GPIO_PCMCIA_IRQ0);
+
+		err = gpio_request(H3XXX_GPIO_PCMCIA_CD0, "PCMCIA CD0");
+		if (err)
+			goto err01;
+		err = gpio_direction_input(H3XXX_GPIO_PCMCIA_CD0);
+		if (err)
+			goto err02;
+		irqs[0].irq = gpio_to_irq(H3XXX_GPIO_PCMCIA_CD0);
+
+		err = soc_pcmcia_request_irqs(skt, irqs, ARRAY_SIZE(irqs));
+		if (err)
+			goto err02;
+		break;
+	case 1:
+		err = gpio_request(H3XXX_GPIO_PCMCIA_IRQ1, "PCMCIA IRQ1");
+		if (err)
+			goto err10;
+		err = gpio_direction_input(H3XXX_GPIO_PCMCIA_IRQ1);
+		if (err)
+			goto err11;
+		skt->socket.pci_irq = gpio_to_irq(H3XXX_GPIO_PCMCIA_IRQ1);
+
+		err = gpio_request(H3XXX_GPIO_PCMCIA_CD1, "PCMCIA CD1");
+		if (err)
+			goto err11;
+		err = gpio_direction_input(H3XXX_GPIO_PCMCIA_CD1);
+		if (err)
+			goto err12;
+		irqs[1].irq = gpio_to_irq(H3XXX_GPIO_PCMCIA_CD1);
+
+		err = soc_pcmcia_request_irqs(skt, irqs, ARRAY_SIZE(irqs));
+		if (err)
+			goto err12;
+		break;
+	}
+	return 0;
+
+err02:	gpio_free(H3XXX_GPIO_PCMCIA_CD0);
+err01:	gpio_free(H3XXX_GPIO_PCMCIA_IRQ0);
+err00:	return err;
 
-	return soc_pcmcia_request_irqs(skt, irqs, ARRAY_SIZE(irqs));
+err12:	gpio_free(H3XXX_GPIO_PCMCIA_CD0);
+err11:	gpio_free(H3XXX_GPIO_PCMCIA_IRQ0);
+err10:	return err;
 }
 
 static void h3600_pcmcia_hw_shutdown(struct soc_pcmcia_socket *skt)
@@ -40,17 +92,25 @@ static void h3600_pcmcia_hw_shutdown(struct soc_pcmcia_socket *skt)
 	assign_h3600_egpio(IPAQ_EGPIO_OPT_NVRAM_ON, 0);
 	assign_h3600_egpio(IPAQ_EGPIO_OPT_ON, 0);
 	assign_h3600_egpio(IPAQ_EGPIO_OPT_RESET, 1);
+	switch (skt->nr) {
+	case 0:
+		gpio_free(H3XXX_GPIO_PCMCIA_CD0);
+		gpio_free(H3XXX_GPIO_PCMCIA_IRQ0);
+		break;
+	case 1:
+		gpio_free(H3XXX_GPIO_PCMCIA_CD1);
+		gpio_free(H3XXX_GPIO_PCMCIA_IRQ1);
+		break;
+	}
 }
 
 static void
 h3600_pcmcia_socket_state(struct soc_pcmcia_socket *skt, struct pcmcia_state *state)
 {
-	unsigned long levels = GPLR;
-
 	switch (skt->nr) {
 	case 0:
-		state->detect = levels & GPIO_H3600_PCMCIA_CD0 ? 0 : 1;
-		state->ready = levels & GPIO_H3600_PCMCIA_IRQ0 ? 1 : 0;
+		state->detect = !gpio_get_value(H3XXX_GPIO_PCMCIA_CD0);
+		state->ready = !!gpio_get_value(H3XXX_GPIO_PCMCIA_IRQ0);
 		state->bvd1 = 0;
 		state->bvd2 = 0;
 		state->wrprot = 0; /* Not available on H3600. */
@@ -59,8 +119,8 @@ h3600_pcmcia_socket_state(struct soc_pcmcia_socket *skt, struct pcmcia_state *st
 		break;
 
 	case 1:
-		state->detect = levels & GPIO_H3600_PCMCIA_CD1 ? 0 : 1;
-		state->ready = levels & GPIO_H3600_PCMCIA_IRQ1 ? 1 : 0;
+		state->detect = !gpio_get_value(H3XXX_GPIO_PCMCIA_CD1);
+		state->ready = !!gpio_get_value(H3XXX_GPIO_PCMCIA_IRQ1);
 		state->bvd1 = 0;
 		state->bvd2 = 0;
 		state->wrprot = 0; /* Not available on H3600. */
-- 
1.6.3.4


--mP3DRpeJDSE+ciuQ--
