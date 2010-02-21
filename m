Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0BUQ6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 11:58:18 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58353 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab0BUQ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 11:58:15 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 21 Feb 2010 17:58:01 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/8] firewire: ohci: use an ID table for quirks detection
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
Message-ID: <tkrat.426625155b78120b@s5r6.in-berlin.de>
References: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't have a lot of quirks to take into account (especially since
dual-buffer IR is out of the picture), but still, a table-based approach
is more organized than a series of if () clauses.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   46 ++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 18 deletions(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -169,10 +169,7 @@ struct fw_ohci {
 	int node_id;
 	int generation;
 	int request_generation;	/* for timestamping incoming requests */
-
-	bool old_uninorth;
-	bool bus_reset_packet_quirk;
-	bool iso_cycle_timer_quirk;
+	unsigned quirks;
 
 	/*
 	 * Spinlock for accessing fw_ohci data.  Never call out of
@@ -234,6 +231,21 @@ static inline struct fw_ohci *fw_ohci(st
 
 static char ohci_driver_name[] = KBUILD_MODNAME;
 
+#define QUIRK_CYCLE_TIMER		1
+#define QUIRK_RESET_PACKET		2
+#define QUIRK_BE_HEADERS		4
+
+/* In case of multiple matches in ohci_quirks[], only the first one is used. */
+static const struct {
+	unsigned short vendor, device, flags;
+} ohci_quirks[] = {
+	{PCI_VENDOR_ID_TI,	PCI_ANY_ID,	QUIRK_RESET_PACKET},
+	{PCI_VENDOR_ID_AL,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
+	{PCI_VENDOR_ID_NEC,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
+	{PCI_VENDOR_ID_VIA,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
+	{PCI_VENDOR_ID_APPLE,	PCI_DEVICE_ID_APPLE_UNI_N_FW, QUIRK_BE_HEADERS},
+};
+
 #ifdef CONFIG_FIREWIRE_OHCI_DEBUG
 
 #define OHCI_PARAM_DEBUG_AT_AR		1
@@ -507,7 +519,7 @@ static void ar_context_release(struct ar
 
 #if defined(CONFIG_PPC_PMAC) && defined(CONFIG_PPC32)
 #define cond_le32_to_cpu(v) \
-	(ohci->old_uninorth ? (__force __u32)(v) : le32_to_cpu(v))
+	(ohci->quirks & QUIRK_BE_HEADERS ? (__force __u32)(v) : le32_to_cpu(v))
 #else
 #define cond_le32_to_cpu(v) le32_to_cpu(v)
 #endif
@@ -588,7 +600,7 @@ static __le32 *handle_ar_packet(struct a
 	 * at a slightly incorrect time (in bus_reset_tasklet).
 	 */
 	if (evt == OHCI1394_evt_bus_reset) {
-		if (!ohci->bus_reset_packet_quirk)
+		if (!(ohci->quirks & QUIRK_RESET_PACKET))
 			ohci->request_generation = (p.header[2] >> 16) & 0xff;
 	} else if (ctx == &ohci->ar_request_ctx) {
 		fw_core_handle_request(&ohci->card, &p);
@@ -1312,7 +1324,7 @@ static void bus_reset_tasklet(unsigned l
 	context_stop(&ohci->at_response_ctx);
 	reg_write(ohci, OHCI1394_IntEventClear, OHCI1394_busReset);
 
-	if (ohci->bus_reset_packet_quirk)
+	if (ohci->quirks & QUIRK_RESET_PACKET)
 		ohci->request_generation = generation;
 
 	/*
@@ -1806,7 +1818,7 @@ static u32 ohci_get_cycle_time(struct fw
 
 	c2 = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
 
-	if (ohci->iso_cycle_timer_quirk) {
+	if (ohci->quirks & QUIRK_CYCLE_TIMER) {
 		i = 0;
 		c1 = c2;
 		c2 = reg_read(ohci, OHCI1394_IsochronousCycleTimer);
@@ -2308,7 +2320,7 @@ static int __devinit pci_probe(struct pc
 	struct fw_ohci *ohci;
 	u32 bus_options, max_receive, link_speed, version;
 	u64 guid;
-	int err;
+	int i, err;
 	size_t size;
 
 	ohci = kzalloc(sizeof(*ohci), GFP_KERNEL);
@@ -2351,15 +2363,13 @@ static int __devinit pci_probe(struct pc
 
 	version = reg_read(ohci, OHCI1394_Version) & 0x00ff00ff;
 
-#if defined(CONFIG_PPC_PMAC) && defined(CONFIG_PPC32)
-	ohci->old_uninorth = dev->vendor == PCI_VENDOR_ID_APPLE &&
-			     dev->device == PCI_DEVICE_ID_APPLE_UNI_N_FW;
-#endif
-	ohci->bus_reset_packet_quirk = dev->vendor == PCI_VENDOR_ID_TI;
-
-	ohci->iso_cycle_timer_quirk = dev->vendor == PCI_VENDOR_ID_AL	||
-				      dev->vendor == PCI_VENDOR_ID_NEC	||
-				      dev->vendor == PCI_VENDOR_ID_VIA;
+	for (i = 0; i < ARRAY_SIZE(ohci_quirks); i++)
+		if (ohci_quirks[i].vendor == dev->vendor &&
+		    (ohci_quirks[i].device == dev->device ||
+		     ohci_quirks[i].device == (unsigned short)PCI_ANY_ID)) {
+			ohci->quirks = ohci_quirks[i].flags;
+			break;
+		}
 
 	ar_context_init(&ohci->ar_request_ctx, ohci,
 			OHCI1394_AsReqRcvContextControlSet);

-- 
Stefan Richter
-=====-==-=- --=- =-=-=
http://arcgraph.de/sr/

