Return-Path: <linux-kernel-owner+w=401wt.eu-S1761177AbYD2UiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761177AbYD2UiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbYD2UiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:38:15 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53748 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbYD2UiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:38:15 -0400
Date: Tue, 29 Apr 2008 22:38:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] x86: fix section mismatch in pci_scan_bus
Message-ID: <20080429203848.GA13741@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following section mismatch warning:
WARNING: vmlinux.o(.text+0x275616): Section mismatch in reference from the function pci_scan_bus() to the function .devinit.text:pci_scan_bus_parented()

The warning was seen with a CONFIG_DEBUG_SECTION_MISMATCH=y build.
The inline function pci_scan_bus refer to functions annotated
__devinit - so annotate it __devinit too.
This revealed a few x86 specific functions that were only
used from __init or __devinit context.
So annotate these __devinit and the warning was killed.

The added include in pci.h was not strictly required but
added to avoid being dependent on indirect includes.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 2a4d751..88b5416 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -489,7 +489,7 @@ void pcibios_disable_device (struct pci_dev *dev)
 		pcibios_disable_irq(dev);
 }
 
-struct pci_bus *pci_scan_bus_on_node(int busno, struct pci_ops *ops, int node)
+struct pci_bus * __devinit pci_scan_bus_on_node(int busno, struct pci_ops *ops, int node)
 {
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
@@ -512,7 +512,7 @@ struct pci_bus *pci_scan_bus_on_node(int busno, struct pci_ops *ops, int node)
 	return bus;
 }
 
-struct pci_bus *pci_scan_bus_with_sysdata(int busno)
+struct pci_bus * __devinit pci_scan_bus_with_sysdata(int busno)
 {
 	return pci_scan_bus_on_node(busno, &pci_root_ops, -1);
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 96acd0d..a59517b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -44,6 +44,7 @@
 #include <linux/mod_devicetable.h>
 
 #include <linux/types.h>
+#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/list.h>
 #include <linux/compiler.h>
@@ -474,7 +475,7 @@ extern struct pci_bus *pci_find_bus(int domain, int busnr);
 void pci_bus_add_devices(struct pci_bus *bus);
 struct pci_bus *pci_scan_bus_parented(struct device *parent, int bus,
 				      struct pci_ops *ops, void *sysdata);
-static inline struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops,
+static inline struct pci_bus * __devinit pci_scan_bus(int bus, struct pci_ops *ops,
 					   void *sysdata)
 {
 	struct pci_bus *root_bus;
