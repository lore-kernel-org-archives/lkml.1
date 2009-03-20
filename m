Return-Path: <linux-kernel-owner+w=401wt.eu-S1762093AbZCTX3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093AbZCTX3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762928AbZCTXY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:27 -0400
Received: from kroah.org ([198.145.64.141]:48544 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762922AbZCTXY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:24 2009
Message-Id: <20090320222924.315647229@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:19 -0700
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
Subject: [patch 09/43] ALSA: hda - Workaround for buggy DMA position on ATI controllers
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=alsa-hda-workaround-for-buggy-dma-position-on-ati-controllers.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c673ba1c23941173c16ff24c7cb34199e826c8b5 upstream.

The position-buffer on ATI controllers are unreliable as well as
on VIA chips, thus the same workaround for DMA position reading as
VIA is useful for ATI.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_intel.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2063,26 +2063,31 @@ static int __devinit check_position_fix(
 {
 	const struct snd_pci_quirk *q;
 
-	/* Check VIA HD Audio Controller exist */
-	if (chip->pci->vendor == PCI_VENDOR_ID_VIA &&
-	    chip->pci->device == VIA_HDAC_DEVICE_ID) {
+	switch (fix) {
+	case POS_FIX_LPIB:
+	case POS_FIX_POSBUF:
+		return fix;
+	}
+
+	/* Check VIA/ATI HD Audio Controller exist */
+	switch (chip->driver_type) {
+	case AZX_DRIVER_VIA:
+	case AZX_DRIVER_ATI:
 		chip->via_dmapos_patch = 1;
 		/* Use link position directly, avoid any transfer problem. */
 		return POS_FIX_LPIB;
 	}
 	chip->via_dmapos_patch = 0;
 
-	if (fix == POS_FIX_AUTO) {
-		q = snd_pci_quirk_lookup(chip->pci, position_fix_list);
-		if (q) {
-			printk(KERN_INFO
-				    "hda_intel: position_fix set to %d "
-				    "for device %04x:%04x\n",
-				    q->value, q->subvendor, q->subdevice);
-			return q->value;
-		}
+	q = snd_pci_quirk_lookup(chip->pci, position_fix_list);
+	if (q) {
+		printk(KERN_INFO
+		       "hda_intel: position_fix set to %d "
+		       "for device %04x:%04x\n",
+		       q->value, q->subvendor, q->subdevice);
+		return q->value;
 	}
-	return fix;
+	return POS_FIX_AUTO;
 }
 
 /*


