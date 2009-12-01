Return-Path: <linux-kernel-owner+w=401wt.eu-S1752469AbZLADDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbZLADDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 22:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZLADDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 22:03:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53338 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZLADDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 22:03:07 -0500
Date: Tue, 1 Dec 2009 14:03:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Artamonow <mad_soft@inbox.ru>,
       Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the pcmcia tree with the arm tree
Message-Id: <20091201140310.46dbdc59.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dominik,

Today's linux-next merge of the pcmcia tree got a conflict in
drivers/pcmcia/sa1100_h3600.c between commit
6ce8f65e71f0d80ee23b543be09789dd865a99be ("ARM: 5811/1: pcmcia: convert
sa1100_h3600 driver to gpiolib") from the arm tree and commit
66024db57d5b9011e274b314affad68f370c0d6f ("PCMCIA: stop duplicating
pci_irq in soc_pcmcia_socket") from the pcmcia tree.

I fixed it up (see below) and can carry the fix as necessary.  Please
check the fix below.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pcmcia/sa1100_h3600.c
index b763cea,3a121ac..0000000
--- a/drivers/pcmcia/sa1100_h3600.c
+++ b/drivers/pcmcia/sa1100_h3600.c
@@@ -26,89 -25,11 +26,89 @@@ static struct pcmcia_irqs irqs[] = 
  
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
- 		skt->irq = gpio_to_irq(H3XXX_GPIO_PCMCIA_IRQ0);
++		skt->socket.pci_irq = gpio_to_irq(H3XXX_GPIO_PCMCIA_IRQ0);
 +
 +		err = gpio_request(H3XXX_GPIO_PCMCIA_CD0, "PCMCIA CD0");
 +		if (err)
 +			goto err01;
 +		err = gpio_direction_input(H3XXX_GPIO_PCMCIA_CD0);
 +		if (err)
 +			goto err02;
 +		irqs[0].irq = gpio_to_irq(H3XXX_GPIO_PCMCIA_CD0);
 +
 +		err = gpio_request(H3XXX_EGPIO_OPT_NVRAM_ON, "OPT NVRAM ON");
 +		if (err)
 +			goto err02;
 +		err = gpio_direction_output(H3XXX_EGPIO_OPT_NVRAM_ON, 0);
 +		if (err)
 +			goto err03;
 +		err = gpio_request(H3XXX_EGPIO_OPT_ON, "OPT ON");
 +		if (err)
 +			goto err03;
 +		err = gpio_direction_output(H3XXX_EGPIO_OPT_ON, 0);
 +		if (err)
 +			goto err04;
 +		err = gpio_request(H3XXX_EGPIO_OPT_RESET, "OPT RESET");
 +		if (err)
 +			goto err04;
 +		err = gpio_direction_output(H3XXX_EGPIO_OPT_RESET, 0);
 +		if (err)
 +			goto err05;
 +		err = gpio_request(H3XXX_EGPIO_CARD_RESET, "PCMCIA CARD RESET");
 +		if (err)
 +			goto err05;
 +		err = gpio_direction_output(H3XXX_EGPIO_CARD_RESET, 0);
 +		if (err)
 +			goto err06;
 +		err = soc_pcmcia_request_irqs(skt, irqs, ARRAY_SIZE(irqs));
 +		if (err)
 +			goto err06;
 +		break;
 +	case 1:
 +		err = gpio_request(H3XXX_GPIO_PCMCIA_IRQ1, "PCMCIA IRQ1");
 +		if (err)
 +			goto err10;
 +		err = gpio_direction_input(H3XXX_GPIO_PCMCIA_IRQ1);
 +		if (err)
 +			goto err11;
- 		skt->irq = gpio_to_irq(H3XXX_GPIO_PCMCIA_IRQ1);
++		skt->socket.pci_irq = gpio_to_irq(H3XXX_GPIO_PCMCIA_IRQ1);
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
  
 -	return soc_pcmcia_request_irqs(skt, irqs, ARRAY_SIZE(irqs));
 +err06:	gpio_free(H3XXX_EGPIO_CARD_RESET);
 +err05:	gpio_free(H3XXX_EGPIO_OPT_RESET);
 +err04:	gpio_free(H3XXX_EGPIO_OPT_ON);
 +err03:	gpio_free(H3XXX_EGPIO_OPT_NVRAM_ON);
 +err02:	gpio_free(H3XXX_GPIO_PCMCIA_CD0);
 +err01:	gpio_free(H3XXX_GPIO_PCMCIA_IRQ0);
 +err00:	return err;
 +
 +err12:	gpio_free(H3XXX_GPIO_PCMCIA_CD0);
 +err11:	gpio_free(H3XXX_GPIO_PCMCIA_IRQ0);
 +err10:	return err;
  }
  
  static void h3600_pcmcia_hw_shutdown(struct soc_pcmcia_socket *skt)
