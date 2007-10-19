Return-Path: <linux-kernel-owner+w=401wt.eu-S1765082AbXJSCmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765082AbXJSCmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 22:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbXJSCmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 22:42:37 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53628 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660AbXJSCmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 22:42:36 -0400
Message-ID: <4718189A.4040609@jp.fujitsu.com>
Date: Fri, 19 Oct 2007 11:38:18 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
Cc: kristen.c.accardi@intel.com, greg@kroah.com,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [Pcihpd-discuss] [PATCH 1/3] pciehp: hotplug: deal with pre-inserted
 ExpressCards
References: <4716CB9D.6080503@rtr.ca> <4716D3C0.20808@rtr.ca> <47174069.9000108@jp.fujitsu.com> <4717602E.2080903@rtr.ca>
In-Reply-To: <4717602E.2080903@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If a PCIe ExpressCard34 is inserted into the slot *before*
> I modprobe pciehp (with pciehp_force=1), then the card is not
> detected nor enabled.  The patch provided here fixes that.
> 
>> Could you give me answers against the following questions?
>>
>>  (1) Did you try "echo 1 > /sys/bus/pci/slots/XXX/power"?
>>      (XXX is the slot number to which your card had been inserted)
>>  (2) If the answer against (1) is yes, did "echo 1 > ..." work?
> 
> 
> After 1. inserting the card, and then 2. modprobing pciehp,
> the value of /sys/bus/pci/slots/XXX/power is already "1".

According to pciehp_debug output from you, your slot doesn't
have software programmable power controller. So your hardware
automatically power on the slot. I think this is why the value
of "power" file is already "1". (But I'm not sure if it is
correct, especially because your firmware doesn't have _OSC.)

On the other hand, my slot has software programmable power
controller. So the value of "power" file is "0" in this case. 

> 
> But, yes, doing "echo 1" into it does trigger card detection
> and things work afterwards.  This doesn't really help,
> because it doesn't happen automatically, unless the kernel patch
> is applied.
> 
>>  (6) I think your slot is surprise removable. Is it correct?
> 
> Yes, it's an externally accessible ExpressCard slot on a notebook,
> which is intended to be fully hotpluggable by surprise or otherwise.

Ok. I think your patch is trying to solve the following two
problems. Right?

  - When the card is inserted *after* modprobing pciehp, the card
    is automatically enabled (pciehp tries to automatically enable
    slot when the card is inserted if the slot is surprise remove
    capable). But if the card is inserted *before* modprobing
    pciehp, the card is not automatically enabled even after
    modprobing pciehp.

  - When the card is inserted *before* modprobing pciehp, the card
    is automatically powered on by hardware, but it is not detected
    by OS. That is, "power" file tells the card is working, but it
    is not working actually. It is strange.

But those are not problems on the slot which is not surprise remove
capable and has software programmable power controller because:

  - When the card is inserted *after* modprobing pciehp, the card
    is *not* automatically powered on/detected. So it is very
    natural that the card, which had been inserted before modprobing
    pciehp, is not automatically enabled at the pciehp modprobe time.

  - When the card is inserted *before* modprobing pciehp, the card
    is not automatically powered on by hardware if the slot has
    sortware programmable power controller. So there is no
    contradiction.

I think your patch has a bad effect to this kind of slots. So I
think your patch needs additional checks to see if the slot should
be enabled or not.

And you need to test your patch on PCIe Native hotplug capable
hardware:)

Thanks,
Kenji Kaneshige





