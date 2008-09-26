Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbYIZVkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbYIZVkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 17:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYIZVkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 17:40:42 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:39745 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbYIZVkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 17:40:41 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Frans Pop <elendil@planet.nl>
Subject: [Bug #11550] pnp: Huge number of "io resource overlap" messages
Date: Fri, 26 Sep 2008 15:40:30 -0600
User-Agent: KMail/1.9.9
Cc: Rene Herman <rene.herman@keyaccess.nl>, linux-kernel@vger.kernel.org,
       Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, bugme-daemon@bugzilla.kernel.org
References: <200809091250.08620.elendil@planet.nl> <200809210149.07755.elendil@planet.nl> <200809201756.25157.bjorn.helgaas@hp.com>
In-Reply-To: <200809201756.25157.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809261540.31443.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11550

On Saturday 20 September 2008 05:56:24 pm Bjorn Helgaas wrote:
> > > On Tuesday 09 September 2008 12:31:09 pm Rene Herman wrote:
> > > > On 09-09-08 19:40, Bjorn Helgaas wrote:
> > > > > If the PCI device isn't fully initialized, it doesn't seem right to
> > > > > check it for resource conflicts.  But I don't know how to tell
> > > > > that.
> > > >
> > > > His pci_resource_start() values are 0. How about just checking for
> > > > that?

> ...
> I am still not 100% comfortable with this because I think we really
> want to know whether the BAR value is zero, not whether the CPU
> address is zero, and pci_resource_start() gives us the CPU address.
> 
> Bus and CPU addresses are currently identical on x86, but I expect
> that will change someday.  They're already different on ia64 and
> some other architectures.

The problem seems to be that Frans has some PCI devices that are not
configured by the BIOS, and their BARs contain zero.  A PNP quirk
checks for overlaps of PCI devices and PNP devices, and those zero-
valued BARs of course conflict with the PNP motherboard devices that
describe legacy hardware.

Here's another approach based on section 3.5 of the PCI Firmware spec.
It says:

  Since not all devices may be configured prior to the operating
  system handoff, the operating system needs to know whether a
  specific BAR register has been configured by firmware. The operating
  system makes the determination by checking the I/O Enable, and
  Memory Enable bits in the device's command register, and Expansion
  ROM BAR enable bits. If the enable bit is set, then the corresponding
  resource register has been configured.

So instead of checking whether the BAR contains zero, the patch below
checks the I/O, Mem, and ROM BAR enable bits to determine whether a
BAR is enabled.

Frans, I'm sorry to trouble you again, but could you test this and
make sure it takes care of the "resource overlap" messages you saw?

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 1a5fc83..26195c3 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -26,6 +26,28 @@
 #include "pci.h"
 
 
+int pci_resource_enabled(struct pci_dev *dev, int bar)
+{
+	u16 command = 0;
+	u32 addr = 0;
+
+	pci_read_config_word(dev, PCI_COMMAND, &command);
+
+	if (pci_resource_flags(dev, bar) & IORESOURCE_IO)
+		return command & PCI_COMMAND_IO;
+
+	if (command & PCI_COMMAND_MEMORY) {
+		if (bar == PCI_ROM_RESOURCE) {
+			pci_read_config_dword(dev, dev->rom_base_reg, &addr);
+			return addr & PCI_ROM_ADDRESS_ENABLE;
+		}
+
+		return 1;
+	}
+
+	return 0;
+}
+
 void pci_update_resource(struct pci_dev *dev, struct resource *res, int resno)
 {
 	struct pci_bus_region region;
diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 0bdf9b8..ef5ed99 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -247,6 +247,9 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
 			unsigned int type;
 
+			if (!pci_resource_enabled(pdev, i))
+				continue;
+
 			type = pci_resource_flags(pdev, i) &
 					(IORESOURCE_IO | IORESOURCE_MEM);
 			if (!type || pci_resource_len(pdev, i) == 0)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c0e1400..28ec520 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -796,6 +796,8 @@ static inline int pci_proc_domain(struct pci_bus *bus)
 }
 #endif /* CONFIG_PCI_DOMAINS */
 
+extern int pci_resource_enabled(struct pci_dev *dev, int bar);
+
 #else /* CONFIG_PCI is not enabled */
 
 /*
@@ -976,6 +978,9 @@ static inline struct pci_dev *pci_get_bus_and_slot(unsigned int bus,
 						unsigned int devfn)
 { return NULL; }
 
+static inline int pci_resource_enabled(struct pci_dev *dev, int bar)
+{ return 0; }
+
 #endif /* CONFIG_PCI */
 
 /* Include architecture-dependent settings and functions */
