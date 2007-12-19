Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbXLSBll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbXLSBll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 20:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbXLSBlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 20:41:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41803 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752783AbXLSBla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 20:41:30 -0500
Date: Tue, 18 Dec 2007 17:38:58 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Richard Henderson <rth@twiddle.net>
cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Daniel Ritz <daniel.ritz@gmx.ch>, Greg KH <greg@kroah.com>,
       Keith Packard <keithp@keithp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: PCI resource problems caused by improper address rounding
In-Reply-To: <alpine.LFD.0.9999.0712181412530.21557@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0712181722260.21557@woody.linux-foundation.org>
References: <47671377.6000405@redhat.com> <alpine.LFD.0.9999.0712171648150.21557@woody.linux-foundation.org> <47680489.6040809@redhat.com> <alpine.LFD.0.9999.0712180946030.21557@woody.linux-foundation.org> <20071218202234.GA24525@twiddle.net>
 <alpine.LFD.0.9999.0712181240280.21557@woody.linux-foundation.org> <20071218215143.GA24769@twiddle.net> <alpine.LFD.0.9999.0712181412530.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Dec 2007, Linus Torvalds wrote:
> 
> That question also brings up another issue: how come did we actually 
> choose address 0xc0000000 with the original patch you sent in? If we can't 
> find it in the parent resources, we shouldn't have accepted it even if it 
> had room for it!

That

	PCI: Cannot allocate resource region 9 of bridge 0000:00:01.0
	PCI: Cannot allocate resource region 1 of device 0000:01:00.0

thing is really starting to bug me.

I bet that is the real problem here, but it's not printing out enough 
information about the resource to actually give us much of a clue about 
what is wrong.

I suspect that it had a bridge mapping (device 0:01.0) that included the 
range from 0xc0000000 to 0xcfffffff, but there was something stupid wrong 
with it (eg the BIOS had allocated overlapping regions), so we disabled 
it. That, in turn, then caused us to also refuse the existing 0xc0000000 
mapping for the graphics card (device 01:00.0), because now there was no 
valid resource for it.

But that PCI bridge resource handling happens even *before* we look at any 
PnP reserved areas (because we - for really good reasons - trust the 
hardware a _lot_ more than we trust any idiotic firmware tables), so I 
wonder what that strange PCI bridge mapping in 00:01.0 was - it must have 
been _really_ off in order to not fit in the resource tree.

Could you just make it print out what the bridge resources are when it 
scans them? Something like the appended..

		Linus

---
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 42ba0e2..37c4b92 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -117,11 +117,16 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 	/* Depth-First Search on bus tree */
 	list_for_each_entry(bus, bus_list, node) {
 		if ((dev = bus->self)) {
+			printk(KERN_DEBUG "PCI: Bridge %s\n", pci_name(dev));
 			for (idx = PCI_BRIDGE_RESOURCES;
 			    idx < PCI_NUM_RESOURCES; idx++) {
 				r = &dev->resource[idx];
 				if (!r->flags)
 					continue;
+				printk(KERN_DEBUG "PCI: Bridge resource "
+					"%08llx-%08llx (f=%lx)\n",
+					r->start, r->end, r->flags);
+
 				pr = pci_find_parent_resource(dev, r);
 				if (!r->start || !pr ||
 				    request_resource(pr, r) < 0) {
