Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbYGaKcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbYGaKcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYGaKc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:32:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43385 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbYGaKcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:32:24 -0400
Message-ID: <48919471.6010304@jp.fujitsu.com>
Date: Thu, 31 Jul 2008 19:31:13 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <200807241407.18543.jbarnes@virtuousgeek.org> <20080724235127.40bd0ac9@mjolnir.drzeus.cx> <200807241506.58973.jbarnes@virtuousgeek.org> <20080724222914.GG5307@ldl.fc.hp.com> <20080725004926.5f201c70@mjolnir.drzeus.cx> <20080724230827.GA30302@ldl.fc.hp.com> <20080725012916.06679a6d@mjolnir.drzeus.cx> <20080725032909.GA6701@parisc-linux.org> <48895D3C.7040100@jp.fujitsu.com> <20080730023842.GA4269@ldl.fc.hp.com>
In-Reply-To: <20080730023842.GA4269@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>> Matthew Wilcox wrote:
>>> So we need a way to find if there's already a slot of this
>>> name.  I don't see a kobject routine to do that.  Maybe we can
>>> do it internally to the pci slot code.
> 
> pci_hp_register already does this with get_slot_from_name().
> 
>>> Then we need to pick a new name for the kobject if it does
>>> collide.  My suggestion is that the second time we find an
>>> object named "2", we call it "2dup1" (the third time "2dup2",
>>> etc.)  Other opinions I've seen include "2a", "2b", ... or
>>> "2-1", "2-2", ... or "2-brokenfw1", "2-brokenfw2".
>> That looks quite better than using bus number.
> 
> I went with:
> 
> 	- first slot to register gets "2"
> 	- second slot to register gets "2-1"
> 	- Mth slot to register gets "2-M"
> 
> At first, I thought it would have been better to put this logic
> inside of pci_hp_register, since it knows about the collision,
> and could just fix stuff up for the caller.
> 
> However, the problem is that each hotplug driver can have a
> different length for "name", and it got messy quickly.
> 
> So, I just patched the two drivers that are known to be
> problematic.
> 
> Two patches follow, against 2.6.27-rc1.
> 
> Compile tested only -- I don't have hardware to replicate this.
> 
> I'd say they're somewhere between RFC and requested for
> inclusion. I'm certainly not tied to them, just trying to show
> some code to implement the approach described above. If we decide
> that looking at _RMV + other bits is the way to go, then I'm fine
> with that.
> 
> It would be great if Pierre and Kenji-san could try them out.

Thank you for patches, Alex-san!

I've reviewed those patches and tested them on my ia64 machine
that have both shpc and pcie hotplug slots. Your patch looks
good.

As you mentioned, we are considering the problem also from the
view point of slot detection. But I think your patch is needed
regardless of that because there might be platforms whose slots
are detected properly but firmware assigns the physical slot
number wrongly. I think Alex's patch should go to mainline.

P.S.: I found a possible improvement, though it is not a big
problem and we don't not need to fix it soon. I'd like to tell
you about it just in case. Current pci_hp_register() checks if
name is duplicated first, before checking if another hotplug
driver is already registered to the slot. So, if shpchp/pciehp
driver tries to register hotplug slot that is already registered
by the other hotplug driver (e.g. acpiphp) with the same name,
shpchp/pciehp driver will do as follows:

(1) shpchp/pciehp call pci_hp_register()
(2) pci_hp_register() returns -EEXIST
(3) shpchp/pciehp call pci_hp_register() with other name ("M-1")
(4) pci_hp_register() returns -EBUSY

if pci_hp_register() checked if another hotplug driver is already
registered first, step (2) and (3) could be removed.

Thanks,
Kenji Kaneshige

