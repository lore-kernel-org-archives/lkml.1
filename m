Return-Path: <linux-kernel-owner+w=401wt.eu-S1752350AbZIEPTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbZIEPTO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 11:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbZIEPTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 11:19:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42851 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbZIEPTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 11:19:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 5 Sep 2009 17:18:50 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.339a6e0a3282e6ef@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive
  - a fix for a post 2.6.30 regression reported at linux1394-devel yesterday,
  - two workarounds for recently found hardware quirks,
  - a fix for an old bug, only recently reported.

Stefan Richter (4):
      firewire: core: fix crash in iso resource management
      firewire: ohci: fix Agere FW643 and multiple cameras
      firewire: ohci: fix Ricoh R5C832, video reception
      firewire: sbp2: fix freeing of unallocated memory

 drivers/firewire/core-iso.c |    4 ++--
 drivers/firewire/ohci.c     |   14 ++++++++++++++
 drivers/firewire/sbp2.c     |    8 ++++----
 3 files changed, 20 insertions(+), 6 deletions(-)

Thanks.


commit baed6b82d9f160184c1c14cdb4accb08f3eb6b87
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Thu Sep 3 23:07:35 2009 +0200

    firewire: sbp2: fix freeing of unallocated memory
    
    If a target writes invalid status (typically status of a command that
    already timed out), firewire-sbp2 attempts to put away an ORB that
    doesn't exist.  https://bugzilla.redhat.com/show_bug.cgi?id=519772
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index d27cb05..05f0c0c 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -456,12 +456,12 @@ static void sbp2_status_write(struct fw_card *card, struct fw_request *request,
 	}
 	spin_unlock_irqrestore(&card->lock, flags);
 
-	if (&orb->link != &lu->orb_list)
+	if (&orb->link != &lu->orb_list) {
 		orb->callback(orb, &status);
-	else
+		kref_put(&orb->kref, free_orb);
+	} else {
 		fw_error("status write for unknown orb\n");
-
-	kref_put(&orb->kref, free_orb);
+	}
 
 	fw_send_response(card, request, RCODE_COMPLETE);
 }

commit 4fe0badd5882c64dc2dcd8893f9b85db63339736
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Fri Aug 28 13:26:03 2009 +0200

    firewire: ohci: fix Ricoh R5C832, video reception
    
    In dual-buffer DMA mode, no video frames are ever received from R5C832
    by libdc1394.  Fallback to packet-per-buffer DMA works reliably.
    http://thread.gmane.org/gmane.linux.kernel.firewire.devel/13393/focus=13476
    
    Reported-by: Jonathan Cameron <jic23@cam.ac.uk>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 3486bc4..76b321b 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2431,6 +2431,11 @@ static int __devinit pci_probe(struct pci_dev *dev,
 	    dev->device == PCI_DEVICE_ID_AGERE_FW643)
 		ohci->use_dualbuffer = false;
 
+	/* dual-buffer mode is broken */
+	if (dev->vendor == PCI_VENDOR_ID_RICOH &&
+	    dev->device == PCI_DEVICE_ID_RICOH_R5C832)
+		ohci->use_dualbuffer = false;
+
 /* x86-32 currently doesn't use highmem for dma_alloc_coherent */
 #if !defined(CONFIG_X86_32)
 	/* dual-buffer mode is broken with descriptor addresses above 2G */

commit fc383796a8cc5df0a0c8633a16dd2e9528a16a63
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Fri Aug 28 13:25:15 2009 +0200

    firewire: ohci: fix Agere FW643 and multiple cameras
    
    An Agere FW643 OHCI 1.1 card works fine for video reception from one
    camera but fails early if receiving from two cameras.  After a short
    while, no IR IRQ events occur and the context control register does not
    react anymore.  This happens regardless whether both IR DMA contexts are
    dual-buffer or one is dual-buffer and the other packet-per-buffer.
    
    This can be worked around by disabling dual buffer DMA mode entirely.
    http://sourceforge.net/mailarchive/message.php?msg_name=4A7C0594.2020208%40gmail.com
    (Reported by Samuel Audet.)
    
    In another report (by Jonathan Cameron), an FW643 works OK with two
    cameras in dual buffer mode.  Whether this is due to different chip
    revisions or different usage patterns (different video formats) is not
    yet clear.  However, as far as the current capabilities of
    firewire-core's isochronous I/O interface are concerned, simply
    switching off dual-buffer on non-working and working FW643s alike is not
    a problem in practice.  We only need to revisit this issue if we are
    going to enhance the interface, e.g. so that applications can explicitly
    choose modes.
    
    Reported-by: Samuel Audet <samuel.audet@gmail.com>
    Reported-by: Jonathan Cameron <jic23@cam.ac.uk>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index ecddd11..3486bc4 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -34,6 +34,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/pci.h>
+#include <linux/pci_ids.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
 
@@ -2372,6 +2373,9 @@ static void ohci_pmac_off(struct pci_dev *dev)
 #define ohci_pmac_off(dev)
 #endif /* CONFIG_PPC_PMAC */
 
+#define PCI_VENDOR_ID_AGERE		PCI_VENDOR_ID_ATT
+#define PCI_DEVICE_ID_AGERE_FW643	0x5901
+
 static int __devinit pci_probe(struct pci_dev *dev,
 			       const struct pci_device_id *ent)
 {
@@ -2422,6 +2426,11 @@ static int __devinit pci_probe(struct pci_dev *dev,
 	version = reg_read(ohci, OHCI1394_Version) & 0x00ff00ff;
 	ohci->use_dualbuffer = version >= OHCI_VERSION_1_1;
 
+	/* dual-buffer mode is broken if more than one IR context is active */
+	if (dev->vendor == PCI_VENDOR_ID_AGERE &&
+	    dev->device == PCI_DEVICE_ID_AGERE_FW643)
+		ohci->use_dualbuffer = false;
+
 /* x86-32 currently doesn't use highmem for dma_alloc_coherent */
 #if !defined(CONFIG_X86_32)
 	/* dual-buffer mode is broken with descriptor addresses above 2G */

commit 1821bc19d54009b6f5e6462dd79074d728080839
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sat Sep 5 13:23:49 2009 +0200

    firewire: core: fix crash in iso resource management
    
    This fixes a regression due to post 2.6.30 commit "firewire: core: do
    not DMA-map stack addresses" 6fdc03709433ccc2005f0f593ae9d9dd04f7b485.
    
    As David Moore noted, a previously correct sizeof() expression became
    wrong since the commit changed its argument from an array to a pointer.
    This resulted in an oops in ohci_cancel_packet in the shared workqueue
    thread's context when an isochronous resource was to be freed.
    
    Reported-by: Jonathan Cameron <jic23@cam.ac.uk>
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/core-iso.c b/drivers/firewire/core-iso.c
index 110e731..1c0b504 100644
--- a/drivers/firewire/core-iso.c
+++ b/drivers/firewire/core-iso.c
@@ -196,7 +196,7 @@ static int manage_bandwidth(struct fw_card *card, int irm_id, int generation,
 		switch (fw_run_transaction(card, TCODE_LOCK_COMPARE_SWAP,
 				irm_id, generation, SCODE_100,
 				CSR_REGISTER_BASE + CSR_BANDWIDTH_AVAILABLE,
-				data, sizeof(data))) {
+				data, 8)) {
 		case RCODE_GENERATION:
 			/* A generation change frees all bandwidth. */
 			return allocate ? -EAGAIN : bandwidth;
@@ -233,7 +233,7 @@ static int manage_channel(struct fw_card *card, int irm_id, int generation,
 		data[1] = old ^ c;
 		switch (fw_run_transaction(card, TCODE_LOCK_COMPARE_SWAP,
 					   irm_id, generation, SCODE_100,
-					   offset, data, sizeof(data))) {
+					   offset, data, 8)) {
 		case RCODE_GENERATION:
 			/* A generation change frees all channels. */
 			return allocate ? -EAGAIN : i;


-- 
Stefan Richter
-=====-==--= =--= --=-=
http://arcgraph.de/sr/

