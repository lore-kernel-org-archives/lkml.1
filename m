Return-Path: <linux-kernel-owner+w=401wt.eu-S932912AbYCABrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912AbYCABrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 20:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757370AbYCABrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 20:47:32 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35990 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbYCABrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 20:47:31 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 1 Mar 2008 02:47:15 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/3] firewire: fw-ohci: Apple UniNorth 1st generation support
To: linux1394-devel@lists.sourceforge.net
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ac97915a5b51e35b@s5r6.in-berlin.de>
Message-ID: <tkrat.c4405ca125bee6ed@s5r6.in-berlin.de>
References: <tkrat.ac97915a5b51e35b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly copied from ohci1394.c.  Necessary for some older Macs, e.g.
PowerBook G3 Pismo and early PowerBook G4 Titanium.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Since my TiBook has a broken FireWire PHY I was only able to test
the byte order of self ID packets but not of the headers of any
other packets.  The code in handle_ar_packet() is only guesswork
from ohci1394.c's respective code.  Also, I wonder what's up with
isochronous packets...

 drivers/firewire/fw-ohci.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

Index: linux-2.6.25-rc3/drivers/firewire/fw-ohci.c
===================================================================
--- linux-2.6.25-rc3.orig/drivers/firewire/fw-ohci.c
+++ linux-2.6.25-rc3/drivers/firewire/fw-ohci.c
@@ -179,6 +179,7 @@ struct fw_ohci {
 	int generation;
 	int request_generation;
 	u32 bus_seconds;
+	bool old_uninorth;
 
 	/*
 	 * Spinlock for accessing fw_ohci data.  Never call out of
@@ -315,15 +316,22 @@ static int ar_context_add_page(struct ar
 	return 0;
 }
 
+#if defined(CONFIG_PPC_PMAC) && defined(CONFIG_PPC32)
+#define cond_le32_to_cpu(v) \
+	(ohci->old_uninorth ? (__force __u32)(v) : le32_to_cpu(v))
+#else
+#define cond_le32_to_cpu(v) le32_to_cpu(v)
+#endif
+
 static __le32 *handle_ar_packet(struct ar_context *ctx, __le32 *buffer)
 {
 	struct fw_ohci *ohci = ctx->ohci;
 	struct fw_packet p;
 	u32 status, length, tcode;
 
-	p.header[0] = le32_to_cpu(buffer[0]);
-	p.header[1] = le32_to_cpu(buffer[1]);
-	p.header[2] = le32_to_cpu(buffer[2]);
+	p.header[0] = cond_le32_to_cpu(buffer[0]);
+	p.header[1] = cond_le32_to_cpu(buffer[1]);
+	p.header[2] = cond_le32_to_cpu(buffer[2]);
 
 	tcode = (p.header[0] >> 4) & 0x0f;
 	switch (tcode) {
@@ -335,7 +343,7 @@ static __le32 *handle_ar_packet(struct a
 		break;
 
 	case TCODE_READ_BLOCK_REQUEST :
-		p.header[3] = le32_to_cpu(buffer[3]);
+		p.header[3] = cond_le32_to_cpu(buffer[3]);
 		p.header_length = 16;
 		p.payload_length = 0;
 		break;
@@ -344,7 +352,7 @@ static __le32 *handle_ar_packet(struct a
 	case TCODE_READ_BLOCK_RESPONSE:
 	case TCODE_LOCK_REQUEST:
 	case TCODE_LOCK_RESPONSE:
-		p.header[3] = le32_to_cpu(buffer[3]);
+		p.header[3] = cond_le32_to_cpu(buffer[3]);
 		p.header_length = 16;
 		p.payload_length = p.header[3] >> 16;
 		break;
@@ -361,7 +369,7 @@ static __le32 *handle_ar_packet(struct a
 
 	/* FIXME: What to do about evt_* errors? */
 	length = (p.header_length + p.payload_length + 3) / 4;
-	status = le32_to_cpu(buffer[length]);
+	status = cond_le32_to_cpu(buffer[length]);
 
 	p.ack        = ((status >> 16) & 0x1f) - 16;
 	p.speed      = (status >> 21) & 0x7;
@@ -1026,13 +1034,14 @@ static void bus_reset_tasklet(unsigned l
 	 */
 
 	self_id_count = (reg_read(ohci, OHCI1394_SelfIDCount) >> 3) & 0x3ff;
-	generation = (le32_to_cpu(ohci->self_id_cpu[0]) >> 16) & 0xff;
+	generation = (cond_le32_to_cpu(ohci->self_id_cpu[0]) >> 16) & 0xff;
 	rmb();
 
 	for (i = 1, j = 0; j < self_id_count; i += 2, j++) {
 		if (ohci->self_id_cpu[i] != ~ohci->self_id_cpu[i + 1])
 			fw_error("inconsistent self IDs\n");
-		ohci->self_id_buffer[j] = le32_to_cpu(ohci->self_id_cpu[i]);
+		ohci->self_id_buffer[j] =
+				cond_le32_to_cpu(ohci->self_id_cpu[i]);
 	}
 	rmb();
 
@@ -2091,6 +2100,10 @@ pci_probe(struct pci_dev *dev, const str
 	pci_write_config_dword(dev, OHCI1394_PCI_HCI_Control, 0);
 	pci_set_drvdata(dev, ohci);
 
+#if defined(CONFIG_PPC_PMAC) && defined(CONFIG_PPC32)
+	ohci->old_uninorth = dev->vendor == PCI_VENDOR_ID_APPLE &&
+			     dev->device == PCI_DEVICE_ID_APPLE_UNI_N_FW;
+#endif
 	spin_lock_init(&ohci->lock);
 
 	tasklet_init(&ohci->bus_reset_tasklet,

-- 
Stefan Richter
-=====-==--- --== ----=
http://arcgraph.de/sr/


