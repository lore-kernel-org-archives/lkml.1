Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbYGYD3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbYGYD3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 23:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYGYD31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 23:29:27 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57551 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYGYD30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 23:29:26 -0400
Date: Thu, 24 Jul 2008 21:29:10 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Message-ID: <20080725032909.GA6701@parisc-linux.org>
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <200807241407.18543.jbarnes@virtuousgeek.org> <20080724235127.40bd0ac9@mjolnir.drzeus.cx> <200807241506.58973.jbarnes@virtuousgeek.org> <20080724222914.GG5307@ldl.fc.hp.com> <20080725004926.5f201c70@mjolnir.drzeus.cx> <20080724230827.GA30302@ldl.fc.hp.com> <20080725012916.06679a6d@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725012916.06679a6d@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 01:29:16AM +0200, Pierre Ossman wrote:
> On Thu, 24 Jul 2008 17:08:27 -0600
> Alex Chiang <achiang@hp.com> wrote:
> 
> > Sorry for one more round-trip, but could you turn on debugging
> > for pciehp as well?
> > 
> 
> Same thing, with debugging:

I have a laptop with a similar problem (though I don't have pciehp
enabled, so I didn't notice it).  Obviously, we need to fix this.

There is no question in my mind that firmware has programmed the slot
numbers incorrectly.  Here's the evidence from lspci -vvv:

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
                        Slot #  2, PowerLimit 6.500000; Interlock- NoCompl-
00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 (rev 03)
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
                        Slot #  2, PowerLimit 6.500000; Interlock- NoCompl-

I don't think anyone can credibly argue that this is correct.  They're
both PCIe devices, they're both both indicating that they have a slot
(maybe if I get my screwdriver out, I can see if there's really a slot
...), they're on the same bus (so I don't know how the with_bus
parameter makes any difference).

I've always hated that with_bus parameter.  I don't like it being a
parameter and I don't like the names it produces.

Part of the problem is the kobject API.  It really hates you trying to
register a duplicate name and won't just return -EEXIST and let you try
a new name.  Instead it prints an ugly warning and dumps stack.  See
kobject_add_internal() in lib/kobject.c.

So we need a way to find if there's already a slot of this name.  I
don't see a kobject routine to do that.  Maybe we can do it internally
to the pci slot code.

Then we need to pick a new name for the kobject if it does collide.
My suggestion is that the second time we find an object named "2", we
call it "2dup1" (the third time "2dup2", etc.)  Other opinions I've
seen include "2a", "2b", ... or "2-1", "2-2", ... or "2-brokenfw1",
"2-brokenfw2".

I'm at OLS this week, so no patch from me.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
