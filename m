Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbYGYFj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbYGYFj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 01:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYGYFjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 01:39:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50097 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYGYFju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 01:39:50 -0400
Message-ID: <488966DE.8020307@jp.fujitsu.com>
Date: Fri, 25 Jul 2008 14:38:38 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <200807241407.18543.jbarnes@virtuousgeek.org> <20080724235127.40bd0ac9@mjolnir.drzeus.cx> <200807241506.58973.jbarnes@virtuousgeek.org> <20080724222914.GG5307@ldl.fc.hp.com> <20080725004926.5f201c70@mjolnir.drzeus.cx> <20080724230827.GA30302@ldl.fc.hp.com> <20080725012916.06679a6d@mjolnir.drzeus.cx> <20080725032909.GA6701@parisc-linux.org> <20080725044234.GA18511@ldl.fc.hp.com>
In-Reply-To: <20080725044234.GA18511@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> * Matthew Wilcox <matthew@wil.cx>:
>> On Fri, Jul 25, 2008 at 01:29:16AM +0200, Pierre Ossman wrote:
>>> On Thu, 24 Jul 2008 17:08:27 -0600
>>> Alex Chiang <achiang@hp.com> wrote:
>>>
>>>> Sorry for one more round-trip, but could you turn on debugging
>>>> for pciehp as well?
>>>>
>>> Same thing, with debugging:
>> I have a laptop with a similar problem (though I don't have pciehp
>> enabled, so I didn't notice it).  Obviously, we need to fix this.
>>
>> There is no question in my mind that firmware has programmed the slot
>> numbers incorrectly.  Here's the evidence from lspci -vvv:
>>
>> 00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
>>         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
>>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
>>                         Slot #  2, PowerLimit 6.500000; Interlock- NoCompl-
>> 00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 (rev 03)
>>         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
>>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
>>                         Slot #  2, PowerLimit 6.500000; Interlock- NoCompl-
>>
>> I don't think anyone can credibly argue that this is correct.  They're
>> both PCIe devices, they're both both indicating that they have a slot
>> (maybe if I get my screwdriver out, I can see if there's really a slot
>> ...), they're on the same bus (so I don't know how the with_bus
>> parameter makes any difference).
>>
>> I've always hated that with_bus parameter.  I don't like it being a
>> parameter and I don't like the names it produces.
>>
>> Part of the problem is the kobject API.  It really hates you trying to
>> register a duplicate name and won't just return -EEXIST and let you try
>> a new name.  Instead it prints an ugly warning and dumps stack.  See
>> kobject_add_internal() in lib/kobject.c.
> 
> Yeah, I don't really like that part of the kobject API either.
> 
>> So we need a way to find if there's already a slot of this name.  I
>> don't see a kobject routine to do that.  Maybe we can do it internally
>> to the pci slot code.
> 
> Well, we have this code in pci_hp_register:
> 
>         /* Check if we have already registered a slot with the same name. */
>         if (get_slot_from_name(slot->name))
>                 return -EEXIST;
> 
>> Then we need to pick a new name for the kobject if it does collide.
>> My suggestion is that the second time we find an object named "2", we
>> call it "2dup1" (the third time "2dup2", etc.)  Other opinions I've
>> seen include "2a", "2b", ... or "2-1", "2-2", ... or "2-brokenfw1",
>> "2-brokenfw2".
>>
>> I'm at OLS this week, so no patch from me.
> 
> It should be pretty easy for pci_hp_register() to fix up the name
> in the event of a collision.
> 
> The hard part is figuring out a convention that we can all agree
> on. ;) I've no strong feelings here, but of the options
> presented, I lean towards "2a", "2b" or "2-1", "2-2".
> 

Only my hope is I don't want to look "2a" or "2-1" on normal platform.
It should be "2" on normal platform.

I'd like to try to make a patch, but it will be middle of next week
because of other jobs. Is that ok?

Thanks,
Kenji Kaneshige


