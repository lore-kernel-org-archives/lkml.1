Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbXLQVPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbXLQVPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXLQVP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:15:28 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:32847 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759270AbXLQVPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:15:25 -0500
Message-Id: <20071217211336.846748677@ldl.fc.hp.com>
References: <20071217210937.103111394@ldl.fc.hp.com>
User-Agent: quilt/0.45-1
Date: Mon, 17 Dec 2007 14:09:38 -0700
From: bjorn.helgaas@hp.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Cc: linux-pci@atrey.karlin.mff.cuni.cz
Subject: [patch 1/3] PCI: print quirk name in debug messages
Content-Disposition: inline; filename=pci-quirk-names
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of printing this:

    PCI: Calling quirk c023b250 for 0000:00:00.0

we can print this:

    pci 0000:00:00.0: calling quirk 0xc023b270: quirk_cardbus_legacy+0x0/0x30()

The address is superfluous because sprint_symbol() includes the
address if the symbol lookup fails, but this is the same style used
in do_initcalls() and pnp_fixup_device().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: w/drivers/pci/quirks.c
===================================================================
--- w.orig/drivers/pci/quirks.c	2007-12-17 14:09:01.000000000 -0700
+++ w/drivers/pci/quirks.c	2007-12-17 14:09:03.000000000 -0700
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/acpi.h>
+#include <linux/kallsyms.h>
 #include "pci.h"
 
 /* The Mellanox Tavor device gives false positive parity errors
@@ -1479,7 +1480,11 @@
 	while (f < end) {
 		if ((f->vendor == dev->vendor || f->vendor == (u16) PCI_ANY_ID) &&
  		    (f->device == dev->device || f->device == (u16) PCI_ANY_ID)) {
-			pr_debug("PCI: Calling quirk %p for %s\n", f->hook, pci_name(dev));
+#ifdef DEBUG
+			dev_dbg(&dev->dev, "calling quirk 0x%p", f->hook);
+			print_fn_descriptor_symbol(": %s()\n",
+				(unsigned long) f->hook);
+#endif
 			f->hook(dev);
 		}
 		f++;

--
