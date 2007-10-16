Return-Path: <linux-kernel-owner+w=401wt.eu-S934222AbXJPPwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934222AbXJPPwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933466AbXJPPwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:52:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:55317 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933385AbXJPPwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:52:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,284,1188802800"; 
   d="scan'208";a="299652379"
Date: Tue, 16 Oct 2007 08:46:34 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Mark Lord <lkml@rtr.ca>
Cc: pcihpd-discuss@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIe Hotplug:  NFG unless I boot with card already inserted.
Message-Id: <20071016084634.8a0d695a.kristen.c.accardi@intel.com>
In-Reply-To: <4714D700.7060008@rtr.ca>
References: <4714C0A6.1030204@rtr.ca>
	<4714D700.7060008@rtr.ca>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 11:21:36 -0400
Mark Lord <lkml@rtr.ca> wrote:

> Mark Lord wrote:
> > I have a Dell notebook with an PCIe ExpressCard slot.
> > I also have a PCIe ExpressCard SATA controller (uses sata_sil24 driver).
> > 
> > I would like to be able to hot plug/unplug the controller card at will.
> > But alas, Linux doesn't cope with it *unless* I boot the kernel with
> > the card initially inserted.
> > 
> > 1. Booting Linux kernel (latest 2.6.23) without the card inserted
> > means that the card will never be detected, regardless of how many
> > times subsequently the card is inserted/removed/whatever.
> > 
> > 2. Booting Linux kernel *with* the card inserted means that it is
> > detected and used, and can be unplugged/replugged as I please,
> > with intervening suspend/resume (RAM or disk) cycles not interfering.
> > 
> > 3. Booting Linux kernel without the card inserted, and then doing
> > a suspend-to-disk poweroff, inserting the card, and powering on again,
> > the card's BIOS extension runs as normal.  But on resume from the
> > suspend-to-disk, the running kernel again never sees the card,
> > even after removing/reinserting/whatever.
> > 
> > 4. All of this leads me to believe that the kernel must be doing some
> > kind of once-only scan of hardware at boot time, and never repeating
> > it afterwards.  Loading/unloading all of the PCI/PCIe hotplug stuff
> > has no effect on this, so it must be broken elsewhere.
> > 
> > 5. It is not likely to be a BIOS thing, because it still fails on
> > power-on (with card inserted) after a suspend-to-disk, which appears
> > to the BIOS exactly the same as any other power-on.
> > 
> > 6. But it's probably a "kernel relies on BIOS data structure read
> > at boot time" issue, based on the observations above.
> 
> Actually, I must now take back some of that.
> 
> Most of these tests were done a month or two ago.
> With 2.6.23.1 running, I just now redid all of the tests.
> 
> Now it seems that pciehp fails to notice a newly inserted card
> only after a suspend/resume cycle with the slot empty.
> 
> I can now get it to work again by just doing:
> 	1. remove the card, so the slot is empty.
> 	2. rmmod pciehp; modprobe pciehp
> 	3. insert the card again -- it works!
> 
> So we just need to fix an issue or two with suspend/resume (RAM) in pciehp.
> 
> Cheers
> 

Hi Mark,
So, just to make sure I understand, your reproducer for the failing case is:
1.  Boot laptop with no card.
2.  Load pciehp
3.  Suspend laptop (slot is still empty)
4.  Resume laptop (slot is still empty)
5.  insert card - card is not detected.

Can you tell me which Dell laptop you have, and also send me the dmesg
output of the failing case after loading pciehp with pciehp_debug=1.

Thanks,
Kristen
