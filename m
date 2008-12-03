Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYLCHxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYLCHxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYLCHxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:53:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44759 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbYLCHxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:53:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Wed, 3 Dec 2008 08:52:35 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812021751450.3256@nehalem.linux-foundation.org> <200812030840.25539.rjw@sisk.pl>
In-Reply-To: <200812030840.25539.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812030852.36437.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 3 of December 2008, Rafael J. Wysocki wrote:
> On Wednesday, 3 of December 2008, Linus Torvalds wrote:
> > 
> > On Wed, 3 Dec 2008, Rafael J. Wysocki wrote:
> > > 
> > > Here's the output of 'lspci -vvxxx':
> > 
> > Ok, I'm not finding any documented quirks that would be memory regions, 
> > and in fact it doesn't look like there is even any remotely likely 32-bit 
> > valies that might be pointers in your PCI config space that look remotely 
> > like they might be conflicting in the area of MMIO space that we allocate 
> > PCI resources from (ie 0x88000000-0x92000000).
> > 
> > Of course, any odd MMIO regions might be descibed by some insane model 
> > that doesn't look like an aligned 32-bit value, but that's unlikely.
> > 
> > So I'm still not seeing anything wrong in there.
> > 
> > > I'll run the 'pci=cbmemsize=4M' test tomorrow (need to have some sleep).
> > 
> > Sure. It will be interesting to see if it makes any difference.
> 
> It didn't help (failure in the 4th consecutive hibernation/resume cycle).

Moreover, to check if the problem may be related to the prefetch window,
I added the appended patch on top of -rc7 (instead of the previous debug
patch), which resulted in the following layout in /proc/iomem:

88000000-8dffffff : PCI Bus 0000:03
  88000000-8bffffff : PCI CardBus 0000:04
  8c000000-8c003fff : 0000:03:0b.1
  8c004000-8c004fff : 0000:03:0b.0
    8c004000-8c004fff : yenta_socket
  8c005000-8c0057ff : 0000:03:0b.1
    8c005000-8c0057ff : firewire_ohci
  8c005800-8c0058ff : 0000:03:0b.3
    8c005800-8c0058ff : mmc0
  8c400000-8c7fffff : PCI CardBus 0000:04

and the first hibernation-resume cycle failed.

Thanks,
Rafael

---
 drivers/pci/setup-bus.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -353,6 +353,25 @@ static int pbus_size_mem(struct pci_bus 
 			r_size = resource_size(r);
 			/* For bridges size != alignment */
 			align = resource_alignment(r);
+			if (r->flags & IORESOURCE_PREFETCH) {
+				resource_size_t expected_align;
+
+				expected_align = (i < PCI_BRIDGE_RESOURCES) ?
+							r_size : r->start;
+				if (align != expected_align) {
+					dev_warn(&dev->dev,
+						"BAR %d [%llx-%llx] "
+						"alignment issue: flags=%lx "
+						"align=%llx (%llx)\n", i,
+						(unsigned long long)r->start,
+						(unsigned long long)r->end,
+						r->flags,
+						(unsigned long long)align,
+						(unsigned long long)expected_align);
+					/* Hacky and wrong, but trying to keep things */
+					align = expected_align;
+				}
+			}
 			order = __ffs(align) - 20;
 			if (order > 11) {
 				dev_warn(&dev->dev, "BAR %d bad alignment %llx: "
