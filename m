Return-Path: <linux-kernel-owner+w=401wt.eu-S1760706AbYG1SIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706AbYG1SIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbYG1SII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:08:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:36181 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbYG1SIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:08:06 -0400
Date: Mon, 28 Jul 2008 11:05:21 -0700
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Message-ID: <20080728180521.GA10600@kroah.com>
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <200807241407.18543.jbarnes@virtuousgeek.org> <20080724235127.40bd0ac9@mjolnir.drzeus.cx> <200807241506.58973.jbarnes@virtuousgeek.org> <20080724222914.GG5307@ldl.fc.hp.com> <20080725004926.5f201c70@mjolnir.drzeus.cx> <20080724230827.GA30302@ldl.fc.hp.com> <20080725012916.06679a6d@mjolnir.drzeus.cx> <20080725032909.GA6701@parisc-linux.org> <20080725044234.GA18511@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725044234.GA18511@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 10:42:34PM -0600, Alex Chiang wrote:
> * Matthew Wilcox <matthew@wil.cx>:
> > On Fri, Jul 25, 2008 at 01:29:16AM +0200, Pierre Ossman wrote:
> > > On Thu, 24 Jul 2008 17:08:27 -0600
> > > Alex Chiang <achiang@hp.com> wrote:
> > > 
> > > > Sorry for one more round-trip, but could you turn on debugging
> > > > for pciehp as well?
> > > > 
> > > 
> > > Same thing, with debugging:
> > 
> > I have a laptop with a similar problem (though I don't have pciehp
> > enabled, so I didn't notice it).  Obviously, we need to fix this.
> > 
> > There is no question in my mind that firmware has programmed the slot
> > numbers incorrectly.  Here's the evidence from lspci -vvv:
> > 
> > 00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
> >         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
> >                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
> >                         Slot #  2, PowerLimit 6.500000; Interlock- NoCompl-
> > 00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 (rev 03)
> >         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
> >                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
> >                         Slot #  2, PowerLimit 6.500000; Interlock- NoCompl-
> > 
> > I don't think anyone can credibly argue that this is correct.  They're
> > both PCIe devices, they're both both indicating that they have a slot
> > (maybe if I get my screwdriver out, I can see if there's really a slot
> > ...), they're on the same bus (so I don't know how the with_bus
> > parameter makes any difference).
> > 
> > I've always hated that with_bus parameter.  I don't like it being a
> > parameter and I don't like the names it produces.
> > 
> > Part of the problem is the kobject API.  It really hates you trying to
> > register a duplicate name and won't just return -EEXIST and let you try
> > a new name.  Instead it prints an ugly warning and dumps stack.  See
> > kobject_add_internal() in lib/kobject.c.
> 
> Yeah, I don't really like that part of the kobject API either.

Then don't register kobjects with the same name of an already existing
one :)

It's pretty simple, you already have a list of all kobjects associated
with this parent kobject (or driver or class), so search them all before
registering them if you think you might end up with a duplicate.

thanks,

greg k-h
