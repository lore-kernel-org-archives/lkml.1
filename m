Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbYLEBqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbYLEBqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 20:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbYLEBpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 20:45:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201AbYLEBpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 20:45:54 -0500
Date: Thu, 4 Dec 2008 17:45:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812050208.33827.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812041724130.3543@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812041545130.3543@nehalem.linux-foundation.org> <alpine.LFD.2.00.0812041645290.3543@nehalem.linux-foundation.org> <200812050208.33827.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > Maybe the PIO window matters? Any magic suspend registers are usually in 
> > PIO space, not in MMIO space. Did /proc/ioports change, and if so, how? 
> 
> |18,20c18,19
> |< 1000-1fff : PCI Bus 0000:03
> |<   1000-10ff : PCI CardBus 0000:04
> |<   1400-14ff : PCI CardBus 0000:04
> |---
> |> 1000-10ff : PCI CardBus 0000:04
> |> 1400-14ff : PCI CardBus 0000:04
> 
> where the first one is with my patch and the second one is with the "no sizing
> for transparent bridges" patch.  No difference to my eyes, if the "transparent"
> bridge is really transparent. :-)

Well, there _is_ a difference, although a subtle one. Not for the Cardbus 
card itself, but for decode of _non-cardbus_ IO ranges.

IOW, if there is a secret magic IO port that we don't know about at (say) 
address 0x1100, then the difference is that now there would be a fight 
over who would take it.

And I think I actually have found some secret IO decoding in ICH7. Damn. I 
_hate_ it when Intel does that. I asked (long ago) that Intel double-check 
that we have quirks for all their idiotic magic IO addresses, but they 
clearly never did that.

Or maybe I'm reading the ICH7 docs wrong. But I don't think I am.

NOTE NOTE NOTE! I didn't check which all LPC bridges there are out there 
that have these magic registers. But it shows up in the ICH7 docs. It 
migth exist in ICH[5-9] for all I know. But at least for ICH7, the only 
LPC bridge ID's I find in the spec update are 27b8, 27b9 and 27bd, which 
are those three devices that I list in the quirks.

Somebody should double-check this, and also check whether ICH6-9 have the 
same LPC decode logic..

Anyway, does this cause anything to be printed out for you? I have _not_ 
checked whether this is the only such programmable hidden range register 
set.

That said, the "no IO window" case should be the safe one (if there are 
hidden IO ports that clash), and it's the one that does _not_ work for 
you, so this may not be it either. But these kinds of quirks were very 
common reasons for ACPI power states not working (because we would just 
allocate something else on top of the damn hidden things that we didn't 
know about).

		Linus

---
 drivers/pci/quirks.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5f4f85f..355ccf2 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -474,6 +474,42 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_4, quirk_
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_7, quirk_ich6_lpc_acpi);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ICH9_8, quirk_ich6_lpc_acpi);
 
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
+	/* Base in bits 15:2 */
+	base = val & 0xfffc;
+
+	/* Decode mask in bits 23:18 */
+	mask = (val >> 16) & 0xfc;
+
+	/* The mask is only on a dword address, the word/byte is always matched */
+	mask |= 3;
+
+	/* Just print it out for now. We should reserve it after debugging */
+	dev_info(&dev->dev, "%s PIO at %04x (mask %04x)\n", name, base, mask);
+}
+
+static void __devinit quirk_ich7_lpc_decode(struct pci_dev *dev)
+{
+	ich7_lpc_generic_decode(dev, 0x84, "ICH7 LPC Generic IO decode 1");
+	ich7_lpc_generic_decode(dev, 0x88, "ICH7 LPC Generic IO decode 2");
+	ich7_lpc_generic_decode(dev, 0x8c, "ICH7 LPC Generic IO decode 3");
+	ich7_lpc_generic_decode(dev, 0x90, "ICH7 LPC Generic IO decode 4");
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ICH7_0, quirk_ich7_lpc_decode);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ICH7_1, quirk_ich7_lpc_decode);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ICH7_31, quirk_ich7_lpc_decode);
+
+
 /*
  * VIA ACPI: One IO region pointed to by longword at
  *	0x48 or 0x20 (256 bytes of ACPI registers)
