Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0BUQ6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 11:58:43 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58374 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab0BUQ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 11:58:41 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 21 Feb 2010 17:58:29 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 6/8] firewire: ohci: add module parameter to activate quirk
 fixes
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
Message-ID: <tkrat.cdeadccf2813dab1@s5r6.in-berlin.de>
References: <tkrat.70de9801677fe5e9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way, we can advise users of precompiled kernel packages to test
existing quirk fixes on chips which have not been listed yet, without
them having to build a kernel from source.

Note, to use this feature on a machine with more than one controller,
steps like these are necessary:
# lspci | grep 1394
# ls /sys/bus/pci/drivers/firewire_ohci/
# echo -n "0000:03:02.0" > /sys/bus/pci/drivers/firewire_ohci/unbind
# echo 2 > /sys/module/firewire_ohci/parameters/quirks
# echo -n "0000:03:02.0" > /sys/bus/pci/drivers/firewire_ohci/bind
# echo 0 > /sys/module/firewire_ohci/parameters/quirks

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -246,6 +246,15 @@ static const struct {
 	{PCI_VENDOR_ID_APPLE,	PCI_DEVICE_ID_APPLE_UNI_N_FW, QUIRK_BE_HEADERS},
 };
 
+/* This overrides anything that was found in ohci_quirks[]. */
+static int param_quirks;
+module_param_named(quirks, param_quirks, int, 0644);
+MODULE_PARM_DESC(quirks, "Chip quirks (default = 0"
+	", nonatomic cycle timer = "	__stringify(QUIRK_CYCLE_TIMER)
+	", reset packet generation = "	__stringify(QUIRK_RESET_PACKET)
+	", AR/selfID endianess = "	__stringify(QUIRK_BE_HEADERS)
+	")");
+
 #ifdef CONFIG_FIREWIRE_OHCI_DEBUG
 
 #define OHCI_PARAM_DEBUG_AT_AR		1
@@ -2370,6 +2379,8 @@ static int __devinit pci_probe(struct pc
 			ohci->quirks = ohci_quirks[i].flags;
 			break;
 		}
+	if (param_quirks)
+		ohci->quirks = param_quirks;
 
 	ar_context_init(&ohci->ar_request_ctx, ohci,
 			OHCI1394_AsReqRcvContextControlSet);

-- 
Stefan Richter
-=====-==-=- --=- =-=-=
http://arcgraph.de/sr/

