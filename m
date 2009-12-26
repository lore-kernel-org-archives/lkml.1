Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbZLZAf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbZLZAf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 19:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbZLZAf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 19:35:26 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53606 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442AbZLZAfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 19:35:22 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 Dec 2009 01:35:14 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/5] firewire: ohci: always use packet-per-buffer mode for
 isochronous reception
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net,
       Clemens Ladisch <cladisch@fastmail.net>
In-Reply-To: <tkrat.edaaa9d0f51812e8@s5r6.in-berlin.de>
Message-ID: <tkrat.057bc7eccde4ce2f@s5r6.in-berlin.de>
References: <tkrat.edaaa9d0f51812e8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a minimal change meant for the short term:  Never set the
ohci->use_dualbuffer flag to true.

There are two reasons to do so:

  - Packet-per-buffer mode and dual-buffer mode do not behave the same
    under certain circumstances, notably if several packets are covered
    by a single fw_cdev_iso_packet descriptor.
    http://marc.info/?l=linux1394-devel&m=124965653718313
    Therefore the driver stack should not silently choose one or the
    other mode but should leave the choice to the high-level driver
    (regardless if kernel driver or userspace driver).  Or simply always
    only offer packet-per-buffer mode, since a considerable number of
    controllers, even current ones, does not offer dual-buffer support.

  - Even under circumstances where packet-per-buffer mode and
    dual-buffer mode behave exactly the same --- notably when used
    through libraw1394, libdc1394, as well as the current two kernel
    drivers which use isochronous reception (firewire-net and firedtv)
    --- we are still faced with the problem that several OHCI 1.1
    controllers have bugs in dual-buffer mode.  Although it looks like
    we have identified most of those buggy controllers by now, we
    cannot be quite sure about that.

So, use packet-per-buffer by default from now on.  This change should
be followed up by a more complete solution:  Either extend the
in-kernel API and the userspace ABI by a choice between the two IR modes
or remove all dual-buffer related code from firewire-ohci.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.33-rc2/drivers/firewire/ohci.c
===================================================================
--- linux-2.6.33-rc2.orig/drivers/firewire/ohci.c
+++ linux-2.6.33-rc2/drivers/firewire/ohci.c
@@ -2226,7 +2226,6 @@ static int ohci_queue_iso_receive_dualbu
 	if (rest == 0)
 		return -EINVAL;
 
-	/* FIXME: make packet-per-buffer/dual-buffer a context option */
 	while (rest > 0) {
 		d = context_get_descriptors(&ctx->context,
 					    z + header_z, &d_bus);
@@ -2470,7 +2469,10 @@ static int __devinit pci_probe(struct pc
 	}
 
 	version = reg_read(ohci, OHCI1394_Version) & 0x00ff00ff;
+#if 0
+	/* FIXME: make it a context option or remove dual-buffer mode */
 	ohci->use_dualbuffer = version >= OHCI_VERSION_1_1;
+#endif
 
 	/* dual-buffer mode is broken if more than one IR context is active */
 	if (dev->vendor == PCI_VENDOR_ID_AGERE &&

-- 
Stefan Richter
-=====-==--= ==-- ==-=-
http://arcgraph.de/sr/

