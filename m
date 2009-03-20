Return-Path: <linux-kernel-owner+w=401wt.eu-S1761620AbZCTXQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761620AbZCTXQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbZCTXNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:13:40 -0400
Received: from kroah.org ([198.145.64.141]:53059 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757873AbZCTXNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:13:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:27:10 2009
Message-Id: <20090320222710.038424016@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:26:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 07/32] ALSA: hda - Fix DMA mask for ATI controllers
References: <20090320222611.872315885@mini.kroah.org>
Content-Disposition: inline; filename=alsa-hda-fix-dma-mask-for-ati-controllers.patch
In-Reply-To: <20090320231037.GA2732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 09240cf429505891d6123ce14a29f58f2a60121e upstream.

ATI controllers (at least some SB0600 models) appear buggy to handle
64bit DMA.  As a workaround, reset GCAP bit0 and let the driver to
use only 32bit DMA on these controllers.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2110,9 +2110,17 @@ static int __devinit azx_create(struct s
 	gcap = azx_readw(chip, GCAP);
 	snd_printdd("chipset global capabilities = 0x%x\n", gcap);
 
+	/* ATI chips seems buggy about 64bit DMA addresses */
+	if (chip->driver_type == AZX_DRIVER_ATI)
+		gcap &= ~0x01;
+
 	/* allow 64bit DMA address if supported by H/W */
 	if ((gcap & 0x01) && !pci_set_dma_mask(pci, DMA_64BIT_MASK))
 		pci_set_consistent_dma_mask(pci, DMA_64BIT_MASK);
+	else {
+		pci_set_dma_mask(pci, DMA_32BIT_MASK);
+		pci_set_consistent_dma_mask(pci, DMA_32BIT_MASK);
+	}
 
 	/* read number of streams from GCAP register instead of using
 	 * hardcoded value


