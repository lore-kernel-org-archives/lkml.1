Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbYLFOLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbYLFOLf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 09:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbYLFOKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 09:10:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59673 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756265AbYLFOKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 09:10:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/3] Sound (HDA Intel): Restore PCI configuration space with interrupts off
Date: Sat, 6 Dec 2008 15:09:08 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812061505.33815.rjw@sisk.pl>
In-Reply-To: <200812061505.33815.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812061509.08994.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: Sound (HDA Intel): Restore PCI configuration space with interrupts off

Move the restoration of the standard PCI configuration registers
in the snd_hda_intel driver to a ->resume_early() callback executed
with interrupts disabled, since doing that with interrupts enabled
may lead to problems in some cases.

This patch addresses the regression from 2.6.26 tracked as
http://bugzilla.kernel.org/show_bug.cgi?id=12121 .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 sound/pci/hda/hda_intel.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6/sound/pci/hda/hda_intel.c
===================================================================
--- linux-2.6.orig/sound/pci/hda/hda_intel.c
+++ linux-2.6/sound/pci/hda/hda_intel.c
@@ -1951,13 +1951,16 @@ static int azx_suspend(struct pci_dev *p
 	return 0;
 }
 
+static int azx_resume_early(struct pci_dev *pci)
+{
+	return pci_restore_state(pci);
+}
+
 static int azx_resume(struct pci_dev *pci)
 {
 	struct snd_card *card = pci_get_drvdata(pci);
 	struct azx *chip = card->private_data;
 
-	pci_set_power_state(pci, PCI_D0);
-	pci_restore_state(pci);
 	if (pci_enable_device(pci) < 0) {
 		printk(KERN_ERR "hda-intel: pci_enable_device failed, "
 		       "disabling device\n");
@@ -2465,6 +2468,7 @@ static struct pci_driver driver = {
 	.remove = __devexit_p(azx_remove),
 #ifdef CONFIG_PM
 	.suspend = azx_suspend,
+	.resume_early = azx_resume_early,
 	.resume = azx_resume,
 #endif
 };
