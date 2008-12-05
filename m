Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYLED0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYLED0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 22:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbYLED02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 22:26:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbYLED00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 22:26:26 -0500
Date: Thu, 4 Dec 2008 19:25:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <alpine.LFD.2.00.0812041845210.3543@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0812041917050.3386@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812041545130.3543@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812041645290.3543@nehalem.linux-foundation.org> <200812050208.33827.rjw@sisk.pl> <alpine.LFD.2.00.0812041724130.3543@nehalem.linux-foundation.org>
 <alpine.LFD.2.00.0812041845210.3543@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Dec 2008, Linus Torvalds wrote:
> 
> Ok, the ICH6 LPC side has something similar, but not the same. Just two 
> ranges, and slightly less flexible wrt sizing.
> 
> And ICH8/9/10 seems to have the same thing as ICH7.

Here's a patch that implements what I think is the correct quirks (apart 
from the commented ICH6 lazy detail I didn't do).

It would be very interesting to see if people affected get any printouts 
about IO decodes that don't show up in /proc/ioports...

And I know I've looked for these kinds of things before in the Intel ICH 
docs, and apparently always missed these things (or been too lazy to 
react), so can somebody else see if they can find any other ranges like 
this? Maybe in non-LPC controllers? 

Jesse, are there any Intel chipset people who could once and for all say 
"these are the things we decode in our chipset" for _all_ chipsets and 
_all_ dynamic ranges? I've asked for that before. There must be people who 
know this, without having to wade through many thousands of pages of 
boring datasheets?

The ICH datasheets tend to be 850 pages each, and there is more than one 
of them. And they _do_ differ in the details, even if there is a lot of 
sharing going on. So reading the docs is a huge effort, when there's bound 
to be somebody who just knows the answer.

NOTE! This patch will just add a _printout_ of the IO regions it finds. It 
won't actually register them as known resources. So it won't make the 
kernel know to avoid them if they were to clash!

Also, see the "This is not correct" for the ICH6 dynamically sized case. 

		Linus

---
 drivers/pci/quirks.c |  105 ++++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 90 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5f4f85f..1b64b28 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -449,7 +449,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801DB_12,
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_82801EB_0,		quirk_ich4_lpc_acpi);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,    PCI_DEVICE_ID_INTEL_ESB_1,		quirk_ich4_lpc_acpi);
 
-static void __devinit quirk_ich6_lpc_acpi(struct pci_dev *dev)
+static void __devinit ich6_lpc_acpi_gpio(struct pci_dev *dev)
 {
 	u32 region;
 
@@ -459,20 +459,95 @@ static void __devinit quirk_ich6_lpc_acpi(struct pci_dev *dev)
 	pci_read_config_dword(dev, 0x48, &region);
 	quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES+1, "ICH6 GPIO");
 }
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH6_0, quirk_ich6_lpc_acpi);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH6_1, quirk_ich6_lpc_acpi);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH7_0, quirk_ich6_lpc_acpi);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH7_1, quirk_ich6_lpc_acpi);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH7_31, quirk_ich6_lpc_acpi);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_0, quirk_ich6_lpc_acpi);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_2, quirk_ich6_lpc_acpi);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_3, quirk_ich6_lpc_acpi);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_1, quirk_ich6_lpc_acpi);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_4, quirk_ich6_lpc_acpi);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_2, quirk_ich6_lpc_acpi);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_4, quirk_ich6_lpc_acpi);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_7, quirk_ich6_lpc_acpi);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_8, quirk_ich6_lpc_acpi);
+
+static void __devinit ich6_lpc_generic_decode(struct pci_dev *dev, unsigned reg, const char *name, int dynsize)
+{
+	u32 val;
+	u32 size, base;
+
+	pci_read_config_dword(dev, reg, &val);
+
+	/* Enabled? */
+	if (!(val & 1))
+		return;
+	base = val & 0xfffc;
+	if (dynsize) {
+		/*
+		 * This is not correct. It is 16, 32 or 64 bytes depending on
+		 * register D31:F0:ADh bits 5:4.
+		 *
+		 * But this gets us at least _part_ of it.
+		 */
+		size = 16;
+	} else {
+		size = 128;
+	}
+	base &= ~(size-1);
+
+	/* Just print it out for now. We should reserve it after more debugging */
+	dev_info(&dev->dev, "%s PIO at %04x-%04x\n", name, base, base+size-1);
+}
+
+static void __devinit quirk_ich6_lpc(struct pci_dev *dev)
+{
+	/* Shared ACPI/GPIO decode with all ICH6+ */
+	ich6_lpc_acpi_gpio(dev);
+
+	/* ICH6-specific generic IO decode */
+	ich6_lpc_generic_decode(dev, 0x84, "LPC Generic IO decode 1", 0);
+	ich6_lpc_generic_decode(dev, 0x88, "LPC Generic IO decode 2", 1);
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH6_0, quirk_ich6_lpc);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH6_1, quirk_ich6_lpc);
+
+static void __devinit ich7_lpc_generic_decode(struct pci_dev *dev, unsigned reg, const char *name)
+{
+	u32 val;
+	u32 mask, base;
+
+	pci_read_config_dword(dev, reg, &val);
+
+	/* Enabled? */
+	if (!(val & 1))
+		return;
+
+	/*
+	 * IO base in bits 15:2, mask in bits 23:18, both
+	 * are dword-based
+	 */
+	base = val & 0xfffc;
+	mask = (val >> 16) & 0xfc;
+	mask |= 3;
+
+	/* Just print it out for now. We should reserve it after more debugging */
+	dev_info(&dev->dev, "%s PIO at %04x (mask %04x)\n", name, base, mask);
+}
+
+/* ICH7-10 has the same common LPC generic IO decode registers */
+static void __devinit quirk_ich7_lpc(struct pci_dev *dev)
+{
+	/* We share the common ACPI/DPIO decode with ICH6 */
+	ich6_lpc_acpi_gpio(dev);
+
+	/* And have 4 ICH7+ generic decodes */
+	ich7_lpc_generic_decode(dev, 0x84, "ICH7 LPC Generic IO decode 1");
+	ich7_lpc_generic_decode(dev, 0x88, "ICH7 LPC Generic IO decode 2");
+	ich7_lpc_generic_decode(dev, 0x8c, "ICH7 LPC Generic IO decode 3");
+	ich7_lpc_generic_decode(dev, 0x90, "ICH7 LPC Generic IO decode 4");
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH7_0, quirk_ich7_lpc);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH7_1, quirk_ich7_lpc);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH7_31, quirk_ich7_lpc);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_0, quirk_ich7_lpc);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_2, quirk_ich7_lpc);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_3, quirk_ich7_lpc);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_1, quirk_ich7_lpc);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH8_4, quirk_ich7_lpc);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_2, quirk_ich7_lpc);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_4, quirk_ich7_lpc);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_7, quirk_ich7_lpc);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_8, quirk_ich7_lpc);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ICH10_1, quirk_ich7_lpc);
 
 /*
  * VIA ACPI: One IO region pointed to by longword at
