Return-Path: <linux-kernel-owner+w=401wt.eu-S1761322AbYFET3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322AbYFET3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYFET3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:29:01 -0400
Received: from mxl.seznam.cz ([77.75.72.44]:58182 "EHLO mxl.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbYFET3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:29:00 -0400
X-Greylist: delayed 884 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 15:28:59 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=post.cz;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding:X-Smtpd:X-Seznam-User:X-QM-Mark;
	b=oQbhZlp3FbGUEfBv1ByF5RZ1aWmGynoMLxvlxkUjYuPgZpysyH40YNSmwtNqD9cEE
	jAFH0cZhz3tN3ml+elV0x/ffpw9jHxNFZkakKUnqRlnkjEF0H9RglyCPuDiXxVchskj
	YLJFGDNelR/vFrAs+bCpwgf6OXmT1cF5McdJHCc=
Message-ID: <48483AE9.9050600@post.cz>
Date: Thu, 05 Jun 2008 21:13:45 +0200
From: Jaroslav Franek <jarin.franek@post.cz>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: perex@perex.cz, James@superbug.co.uk, tiwai@suse.de
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] sound: emu10k1 - fix system hang with Audigy2 ZS Notebook
 PCMCIA card
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Smtpd: 1.0.41@13276
X-Seznam-User: jarin.franek@post.cz
X-QM-Mark: email-qm1<122962532>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from: Jaroslav Franek

When the Linux kernel is compiled with CONFIG_DEBUG_SHIRQ=y,
the Soundblaster Audigy2 ZS Notebook PCMCIA card causes the
system hang during boot (udev stage) or when the card is hot-plug.
The CONFIG_DEBUG_SHIRQ flag is by default 'y' with all Fedora
kernels since 2.6.23. The problem was reported as
https://bugzilla.redhat.com/show_bug.cgi?id=326411

The issue was hunted down to the snd_emu10k1_create() routine:

/* pseudo-code */
snd_emu10k1_create(...) {
	...
	request_irq(... IRQF_SHARED ...) {
		register the irq handler
		#ifdef CONFIG_DEBUG_SHIRQ
		call the irq handler: snd_emu10k1_interrupt() {
			poll I/O port   // <---- !! system hangs
			...
		}
		#endif
	}
	...
	snd_emu10k1_cardbus_init(...) {
		initialize I/O ports
	}
	...
}

The early access to I/O port in the interrupt handler causes
the freeze. Obviously it is necessary to init the I/O ports
before accessing them. This patch moves the registration of
the irq handler after the initialization of the I/O ports.

Signed-off-by: Jaroslav Franek <jarin.franek@post.cz>
---
This is the patch against 2.6.26-rc5. Please give it proper flaming,
it is my first so I do not deserve much mercy ;).

--- a/sound/pci/emu10k1/emu10k1_main.c	2008-05-29 21:29:12.000000000 +0200
+++ b/sound/pci/emu10k1/emu10k1_main.c	2008-06-04 21:31:35.000000000 +0200
@@ -1818,13 +1818,6 @@ int __devinit snd_emu10k1_create(struct 
 	}
 	emu->port = pci_resource_start(pci, 0);
 
-	if (request_irq(pci->irq, snd_emu10k1_interrupt, IRQF_SHARED,
-			"EMU10K1", emu)) {
-		err = -EBUSY;
-		goto error;
-	}
-	emu->irq = pci->irq;
-
 	emu->max_cache_pages = max_cache_bytes >> PAGE_SHIFT;
 	if (snd_dma_alloc_pages(SNDRV_DMA_TYPE_DEV, snd_dma_pci_data(pci),
 				32 * 1024, &emu->ptb_pages) < 0) {
@@ -1887,6 +1880,14 @@ int __devinit snd_emu10k1_create(struct 
 	emu->fx8010.etram_pages.area = NULL;
 	emu->fx8010.etram_pages.bytes = 0;
 
+	/* irq handler must be registered after I/O ports are activated */
+	if (request_irq(pci->irq, snd_emu10k1_interrupt, IRQF_SHARED,
+			"EMU10K1", emu)) {
+		err = -EBUSY;
+		goto error;
+	}
+	emu->irq = pci->irq;
+
 	/*
 	 *  Init to 0x02109204 :
 	 *  Clock accuracy    = 0     (1000ppm)


