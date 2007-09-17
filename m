Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbXIQUbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbXIQUbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbXIQUao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:30:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:53753 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756444AbXIQUan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:30:43 -0400
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070917142241.C21399@jurassic.park.msu.ru>
References: <1189664467.17835.1.camel@sli10-conroe.sh.intel.com>
	 <20070913073140.GA17367@parisc-linux.org>
	 <1189668286.18361.3.camel@sli10-conroe.sh.intel.com>
	 <20070913075536.GB17367@parisc-linux.org> <20070913095313.GA745@suse.de>
	 <20070913151637.A1679@jurassic.park.msu.ru>
	 <1189972912.6403.16.camel@localhost.localdomain>
	 <20070917142241.C21399@jurassic.park.msu.ru>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 06:30:23 +1000
Message-Id: <1190061024.6403.64.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-17 at 14:22 +0400, Ivan Kokshaysky wrote:
> On Sun, Sep 16, 2007 at 10:01:52PM +0200, Benjamin Herrenschmidt wrote:
> > Agreed. I have a similar problem on ppc where it's common to have things
> > like the main PIC on a PCI device. Note that another problem is (or at
> > least was, i haven't checked recently) the P2P bridge scanning code
> > that, in a similar way, can block the path to all devices below it. I
> > -do- have a case for example with Apple Xserve G4's where the main Apple
> > IO ASIC, which is a PCI device containing the PIC, the power management
> > controller, and various low level system control IOs is behind a pair of
> > P2P bridges.
> 
> I think the P2P probing code is pretty safe now - there are read-only
> accesses to the bridge config, unless you request to reassign the bus
> numbers. Though it won't be safe anymore with the patch in question.

In which case I will need to NAK the patch... Note that those Xserve
G4's still have the subtle issue that they -also- reassign bus
numbers :-) But that's going away the day I finally enable domains
support for ppc32 (it's been off for now due to problems with X)

> > One solution for us (PPC) is to enforce those devices and bridges to be
> > described in the OF tree, and generalize a bit the code we have for some
> > 64 bits machines, that synthetizes the pci_dev's from the OF nodes
> > rather than probing. But that's not going to help other archs.
> 
> If you can get reliable PCI info from firmware, it should be relatively easy
> to avoid at least a bar sizing. You can install an "early" fixup for
> PCI_ANY_ID and fill the resource fields of the pci_dev with values obtained
> from firmware. Then all we need in probe.c is just to check that the resource
> is already non-zero and skip the sizing of respective BAR, if so.

Right now, we have code to completely build a pci_dev from the firmware
infos. We only use it on 64 bits pseries currently though. 

> > In fact, that's a problem we also have with
> > pci_assign_unassigned_resources() which will happily move things around
> > that must not be moved, especially when sitting behind P2P bridges.
> 
> It's not supposed to do that. Certainly, there were problems of that sort,
> but hopefully they are in the past.

At this stage (but we are getting a bit OT), ppc has something like 3
different PCI code implementations :-) I do have some plans to fix that
by switching everybody to use pci_assign_unassigned_resources() and
friends but last time I tried, everything blew up :-) I suspect I'll
need a quirk or two in the generic code, but I'll let you know when I
get to it.

Cheers,
Ben.

