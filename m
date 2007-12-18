Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbXLRWcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbXLRWcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXLRWcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:32:47 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658AbXLRWcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:32:46 -0500
Date: Tue, 18 Dec 2007 14:31:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Richard Henderson <rth@twiddle.net>
cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: PCI resource problems caused by improper address rounding
In-Reply-To: <20071218215143.GA24769@twiddle.net>
Message-ID: <alpine.LFD.0.9999.0712181412530.21557@woody.linux-foundation.org>
References: <47671377.6000405@redhat.com> <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org> <47680489.6040809@redhat.com> <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org> <20071218202234.GA24525@twiddle.net>
 <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org> <20071218215143.GA24769@twiddle.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Dec 2007, Richard Henderson wrote:
> 
> Another way to look at this is that the graphics BAR came in from
> the BIOS allocated at c0000000, and we ignored that.

We did?

> Perhaps there's a way to give weight to the BIOS settings when 
> consdering where the PCI region is supposed to start?

Normally, we *always* keep the BIOS allocations, unless it explicitly 
clashes with something and we have reason to believe that they cannot 
work. And there's nothing it clashes with, so we definitely *should* have 
kept it.

Why do you think it came pre-allocated at 0xc0000000? I'm seeing the 
message 

   PCI: Cannot allocate resource region 1 of device 0000:01:00.0

and I can well imagine that that is it, but if it was a valid allocation, 
then we really should have kept it there.

That question also brings up another issue: how come did we actually 
choose address 0xc0000000 with the original patch you sent in? If we can't 
find it in the parent resources, we shouldn't have accepted it even if it 
had room for it!

Which brings up *another* potential fix for this thing: as mentioned, 
Intel bridges often claim to be "Normal decode", but the core ones seem to 
almost never actually be that, and they tend to be "Negative decode". So 
what may be going on is:

 - the kernel sees that BIOS allocation at 0xc0000000 (I'll take your word 
   for it, it doesn't actually say so without PCI debugging enabled)

 - ...and notices that the PCI BAR is behind a PCI bridge that does
   not claim to be able to actually bridge that resource (it's normal 
   decode, and the ranges it *does* decode are elsewhere!)

 - so clearly that old allocation is pure crap and has to be re-done in a 
   range that is actually properly bridged.

but that decision bases itself on the Intel bridge not lying, and if it 
turns out that the bridge at 0000:00:01.0 actually is transparent, then 
the original allocation would have been ok.

That said, your bridge at 00:1e.0 is *also* transparent, and it's actually 
against the PCI specs to have two transparent bridges on the same PCI bus, 
so I'm a bit surprised about that. But it does bring up a new thing you 
could *try*, namely this patch...

(You obviously have to replace "insert-your-device-here" with the proper 
PCI device ID for the thing you have - your lspci output only gives the 
name, not the numbers)

We seem to have a multitude of possible reasons for this insanity. It 
would be interesting to hear which one(s) of the possibilities make a 
difference, if any.

			Linus

---
 drivers/pci/quirks.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 26cc4dc..c3b52f5 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -820,6 +820,7 @@ static void __devinit quirk_transparent_bridge(struct pci_dev *dev)
 {
 	dev->transparent = 1;
 }
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	insert-your-device-id-here,	quirk_transparent_bridge );
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82380FB,	quirk_transparent_bridge );
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_TOSHIBA,	0x605,	quirk_transparent_bridge );
 
