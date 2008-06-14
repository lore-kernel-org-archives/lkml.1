Return-Path: <linux-kernel-owner+w=401wt.eu-S1761999AbYFNAOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761999AbYFNAOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760229AbYFNAMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:12:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:51663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760159AbYFNAMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:12:40 -0400
Date: Fri, 13 Jun 2008 17:10:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jaroslav Franek <jarin.franek@post.cz>,
       James Courtier-Dutton <James@superbug.co.uk>,
       Takashi Iwai <tiwai@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 07/47] sound: emu10k1 - fix system hang with Audigy2 ZS
	Notebook PCMCIA card
Message-ID: <20080614001031.GG24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sound-emu10k1-fix-system-hang-with-audigy2-zs-notebook-pcmcia-card.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jaroslav Franek <jarin.franek@post.cz>

upstream commit: 868e15dbd2940f9453b4399117686f408dc77299

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
Acked-by: James Courtier-Dutton <James@superbug.co.uk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 sound/pci/emu10k1/emu10k1_main.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -1817,13 +1817,6 @@ int __devinit snd_emu10k1_create(struct 
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
@@ -1886,6 +1879,14 @@ int __devinit snd_emu10k1_create(struct 
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

-- 
