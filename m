Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbXIPUCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbXIPUCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 16:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXIPUCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 16:02:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:46999 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbXIPUCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 16:02:07 -0400
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070913151637.A1679@jurassic.park.msu.ru>
References: <1189664467.17835.1.camel@sli10-conroe.sh.intel.com>
	 <20070913073140.GA17367@parisc-linux.org>
	 <1189668286.18361.3.camel@sli10-conroe.sh.intel.com>
	 <20070913075536.GB17367@parisc-linux.org> <20070913095313.GA745@suse.de>
	 <20070913151637.A1679@jurassic.park.msu.ru>
Content-Type: text/plain
Date: Sun, 16 Sep 2007 22:01:52 +0200
Message-Id: <1189972912.6403.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 15:16 +0400, Ivan Kokshaysky wrote:
> On Thu, Sep 13, 2007 at 02:53:13AM -0700, Greg KH wrote:
> > On Thu, Sep 13, 2007 at 01:55:36AM -0600, Matthew Wilcox wrote:
> > > Unfortunately if this patch does cause any machine to break, these will
> > > be machines that worked fine up until this point, so that would be a
> > > regression, which is worse.  Life sucks.
> > 
> > If, after a while, you think the change should go into the -stable tree,
> > I have no objection.
> 
> I think it shouldn't - this change will almost certainly cause a regression.
> There is a lot of system devices besides the host bridges that shouldn't be
> disabled during BAR probe, like interrupt controllers, power management
> controllers and so on.
> 
> We need a more sophisticated fix - I'm thinking of introducing "probe" field
> in struct pci_dev which can be set by "early" quirk routines.

Agreed. I have a similar problem on ppc where it's common to have things
like the main PIC on a PCI device. Note that another problem is (or at
least was, i haven't checked recently) the P2P bridge scanning code
that, in a similar way, can block the path to all devices below it. I
-do- have a case for example with Apple Xserve G4's where the main Apple
IO ASIC, which is a PCI device containing the PIC, the power management
controller, and various low level system control IOs is behind a pair of
P2P bridges.

One solution for us (PPC) is to enforce those devices and bridges to be
described in the OF tree, and generalize a bit the code we have for some
64 bits machines, that synthetizes the pci_dev's from the OF nodes
rather than probing. But that's not going to help other archs.

In fact, that's a problem we also have with
pci_assign_unassigned_resources() which will happily move things around
that must not be moved, especially when sitting behind P2P bridges.

So the root of the issue is much deeper than just a quirk here I
believe.

Cheers,
Ben.


