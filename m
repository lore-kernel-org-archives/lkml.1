Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbXJVSZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbXJVSZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbXJVSZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:25:44 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45105 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbXJVSZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:25:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 22 Oct 2007 20:25:28 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] FireWire updates
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.5e8200bc7b94eef7@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following FireWire subsystem updates.
They have not been in -mm but they are trivial.

 drivers/firewire/fw-ohci.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

Stefan Richter (2):
      firewire: fw-ohci: log a note about unsupported features
      firewire: fw-ohci: shut up a superfluous compiler warning


Full log and diff:

commit 4b6d51ec62d9c57432430528d6293605794a9f1b
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Oct 21 11:20:07 2007 +0200

    firewire: fw-ohci: shut up a superfluous compiler warning
    
    New warning since commit ab88ca488b8af66c3defa165874e81e695319a19,
    "firewire: fw-ohci: missing dma_unmap_single":
    drivers/firewire/fw-ohci.c: In function 'at_context_transmit':
    drivers/firewire/fw-ohci.c:609: warning: 'payload_bus' may be used
     uninitialized in this function
    
    Access to payload_bus is conditional on packet->payload_length > 0,
    and that won't change while in at_context_queue_packet.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index e4b9a7d..6758832 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -606,7 +606,7 @@ static int
 at_context_queue_packet(struct context *ctx, struct fw_packet *packet)
 {
 	struct fw_ohci *ohci = ctx->ohci;
-	dma_addr_t d_bus, payload_bus;
+	dma_addr_t d_bus, uninitialized_var(payload_bus);
 	struct driver_data *driver_data;
 	struct descriptor *d, *last;
 	__le32 *header;

commit c74e92c209cf30ae6003e042e7c017eb6c370b64
Author: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date:   Sun Oct 21 10:43:11 2007 +0200

    firewire: fw-ohci: log a note about unsupported features
    
    because there seems to be more time needed to implement this.
    Also, change related error return values to more appropriate ones.
    
    Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 2f307c4..e4b9a7d 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -1459,7 +1459,7 @@ ohci_allocate_iso_context(struct fw_card *card, int type, size_t header_size)
 	/* FIXME: We need a fallback for pre 1.1 OHCI. */
 	if (callback == handle_ir_dualbuffer_packet &&
 	    ohci->version < OHCI_VERSION_1_1)
-		return ERR_PTR(-EINVAL);
+		return ERR_PTR(-ENOSYS);
 
 	spin_lock_irqsave(&ohci->lock, flags);
 	index = ffs(*mask) - 1;
@@ -1778,7 +1778,7 @@ ohci_queue_iso(struct fw_iso_context *base,
 							 buffer, payload);
 	else
 		/* FIXME: Implement fallback for OHCI 1.0 controllers. */
-		return -EINVAL;
+		return -ENOSYS;
 }
 
 static const struct fw_card_driver ohci_driver = {
@@ -1898,7 +1898,12 @@ pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 	ohci->version = reg_read(ohci, OHCI1394_Version) & 0x00ff00ff;
 	fw_notify("Added fw-ohci device %s, OHCI version %x.%x\n",
 		  dev->dev.bus_id, ohci->version >> 16, ohci->version & 0xff);
-
+	if (ohci->version < OHCI_VERSION_1_1) {
+		fw_notify("    Isochronous I/O is not yet implemented for "
+			  "OHCI 1.0 chips.\n");
+		fw_notify("    Cameras, audio devices etc. won't work on "
+			  "this controller with this driver version.\n");
+	}
 	return 0;
 
  fail_self_id:

-- 
Stefan Richter
-=====-=-=== =-=- =-==-
http://arcgraph.de/sr/

