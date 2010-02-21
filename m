Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab0BUQ72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 11:59:28 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58390 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab0BUQ70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 11:59:26 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 21 Feb 2010 17:59:14 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 8/8] firewire: ohci: extend initialization log message
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
Message-ID: <tkrat.e46a1fc81365d521@s5r6.in-berlin.de>
References: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

by the number of available isochronous DMA contexts and active quirks
which is occasionally useful information.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2329,7 +2329,7 @@ static int __devinit pci_probe(struct pc
 	struct fw_ohci *ohci;
 	u32 bus_options, max_receive, link_speed, version;
 	u64 guid;
-	int i, err;
+	int i, err, n_ir, n_it;
 	size_t size;
 
 	ohci = kzalloc(sizeof(*ohci), GFP_KERNEL);
@@ -2370,8 +2370,6 @@ static int __devinit pci_probe(struct pc
 		goto fail_iomem;
 	}
 
-	version = reg_read(ohci, OHCI1394_Version) & 0x00ff00ff;
-
 	for (i = 0; i < ARRAY_SIZE(ohci_quirks); i++)
 		if (ohci_quirks[i].vendor == dev->vendor &&
 		    (ohci_quirks[i].device == dev->device ||
@@ -2398,13 +2396,15 @@ static int __devinit pci_probe(struct pc
 	ohci->ir_context_channels = ~0ULL;
 	ohci->ir_context_mask = reg_read(ohci, OHCI1394_IsoRecvIntMaskSet);
 	reg_write(ohci, OHCI1394_IsoRecvIntMaskClear, ~0);
-	size = sizeof(struct iso_context) * hweight32(ohci->ir_context_mask);
+	n_ir = hweight32(ohci->ir_context_mask);
+	size = sizeof(struct iso_context) * n_ir;
 	ohci->ir_context_list = kzalloc(size, GFP_KERNEL);
 
 	reg_write(ohci, OHCI1394_IsoXmitIntMaskSet, ~0);
 	ohci->it_context_mask = reg_read(ohci, OHCI1394_IsoXmitIntMaskSet);
 	reg_write(ohci, OHCI1394_IsoXmitIntMaskClear, ~0);
-	size = sizeof(struct iso_context) * hweight32(ohci->it_context_mask);
+	n_it = hweight32(ohci->it_context_mask);
+	size = sizeof(struct iso_context) * n_it;
 	ohci->it_context_list = kzalloc(size, GFP_KERNEL);
 
 	if (ohci->it_context_list == NULL || ohci->ir_context_list == NULL) {
@@ -2432,8 +2432,11 @@ static int __devinit pci_probe(struct pc
 	if (err)
 		goto fail_self_id;
 
-	fw_notify("Added fw-ohci device %s, OHCI version %x.%x\n",
-		  dev_name(&dev->dev), version >> 16, version & 0xff);
+	version = reg_read(ohci, OHCI1394_Version) & 0x00ff00ff;
+	fw_notify("Added fw-ohci device %s, OHCI v%x.%x, "
+		  "%d IR + %d IT contexts, quirks 0x%x\n",
+		  dev_name(&dev->dev), version >> 16, version & 0xff,
+		  n_ir, n_it, ohci->quirks);
 
 	return 0;
 

-- 
Stefan Richter
-=====-==-=- --=- =-=-=
http://arcgraph.de/sr/

