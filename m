Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZK3VWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZK3VWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZK3VWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:22:42 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:36760 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbZK3VWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:22:41 -0500
From: Alex Williamson <alex.williamson@hp.com>
Subject: [PATCH] PCI: Always set prefetchable base/limit upper32 registers
To: jbarnes@virtuousgeek.org
Cc: yinghai@kernel.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, alex.williamson@hp.com
Date: Mon, 30 Nov 2009 14:22:53 -0700
Message-ID: <20091130212228.7555.43533.stgit@debian.lart>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to 1f82de10 we always initialized the upper 32bits of the
prefetchable memory window, regardless of the address range used.
Now we only touch it for a >32bit address, which means the upper32
registers remain whatever the BIOS initialized them too.

It's valid for the BIOS to set the upper32 base/limit to
0xffffffff/0x00000000, which makes us program prefetchable ranges
like 0xffffffffabc00000 - 0x00000000abc00000

Revert the chunk of 1f82de10 that made this conditional so we always
write the upper32 registers.

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
---

 drivers/pci/setup-bus.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index cb1a027..127d759 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -221,11 +221,9 @@ static void pci_setup_bridge(struct pci_bus *bus)
 	}
 	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
 
-	if (pref_mem64) {
-		/* Set the upper 32 bits of PREF base & limit. */
-		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
-		pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
-	}
+	/* Set the upper 32 bits of PREF base & limit. */
+	pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
+	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
 
 	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, bus->bridge_ctl);
 }

