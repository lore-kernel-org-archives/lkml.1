Return-Path: <linux-kernel-owner+w=401wt.eu-S1752326AbXDWNo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbXDWNo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbXDWNo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:44:28 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44931 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752326AbXDWNo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:44:28 -0400
Date: Mon, 23 Apr 2007 14:47:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH]  PPC pci_32: Stop using old hotplug unsafe APIs
Message-ID: <20070423144759.5875dec5@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pci_find_slot isn't hot-plug safe. Move this code to the pci hotplug safe equivalent and hold a refcount
properly while doinmg make_one_node_map.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc6-mm1/arch/powerpc/kernel/pci_32.c linux-2.6.21-rc6-mm1/arch/powerpc/kernel/pci_32.c
--- linux.vanilla-2.6.21-rc6-mm1/arch/powerpc/kernel/pci_32.c	2007-04-12 14:14:43.000000000 +0100
+++ linux-2.6.21-rc6-mm1/arch/powerpc/kernel/pci_32.c	2007-04-23 12:20:22.007864440 +0100
@@ -656,10 +656,13 @@
 		reg = get_property(node, "reg", NULL);
 		if (!reg)
 			continue;
-		dev = pci_find_slot(pci_bus, ((reg[0] >> 8) & 0xff));
-		if (!dev || !dev->subordinate)
+		dev = pci_get_bus_and_slot(pci_bus, ((reg[0] >> 8) & 0xff));
+		if (!dev || !dev->subordinate) {
+			pci_dev_put(dev);
 			continue;
+		}
 		make_one_node_map(node, dev->subordinate->number);
+		pci_dev_put(dev);
 	}
 }
 	
