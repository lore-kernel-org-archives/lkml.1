Return-Path: <linux-kernel-owner+w=401wt.eu-S933237AbXJLRJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237AbXJLRJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbXJLRHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:07:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:32889 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932670AbXJLRHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:07:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,267,1188802800"; 
   d="scan'208";a="245516640"
Message-ID: <470FA9D3.2050701@intel.com>
Date: Fri, 12 Oct 2007 10:07:31 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Vitaliy Gusev <vgusev@openvz.org>
CC: Greg KH <greg@kroah.com>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jesse Barnes <jesse.barnes@intel.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PCI: Fix boot-time hang on G31/G33 PC
References: <20070826015556.GC14130@parisc-linux.org> <46FBF830.9000704@intel.com> <20070927231344.GD869@kroah.com> <200710121826.54405.vgusev@openvz.org>
In-Reply-To: <200710121826.54405.vgusev@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Oct 2007 17:07:49.0280 (UTC) FILETIME=[6AC25A00:01C80CF2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaliy Gusev wrote:
> On the 28 September 2007 03:13 Greg KH, wrote:
>> On Thu, Sep 27, 2007 at 11:36:32AM -0700, Kok, Auke wrote:
>>> Ivan Kokshaysky wrote:
>>>> On Wed, Sep 26, 2007 at 03:20:40PM -0700, Jesse Barnes wrote:
>>>>> Ivan, your concern is about disabling things like interrupt
>>>>> controllers and power management chips during probe right?  You're
>>>>> right that doing that could cause problems if we get and interrupt or
>>>>> PMU event at just the wrong time, but that could just as easily happen
>>>>> if decode was still enabled but the BAR had a bogus address programmed
>>>>> (as it would during probing).
>>>> Yes, nobody is arguing that moving the BAR around is unsafe, but
>>>> generally it's the less of two evils.
>>>>
>>>> The major problem here is that with IO and MEM bits cleared in the
>>>> command register you disable *all* address decoders on the device, not
>>>> just ranges that have respective BARs. At least this behaviour is
>>>> required by PCI spec. Examples:
>>>> - legacy VGA IO and memory (no corresponding BARs);
>>>> - base/limit registers of P2P bridge;
>>>> - PMU and SMBus registers (sort of normal BARs, but hidden elsewhere
>>>>   in the config space);
>>>> - IDE legacy mode registers;
>>>> - IO-APIC registers (typically sort of read-only BAR).
>>>>
>>>> For all of these address ranges our current BAR probe is effectively
>>>> a no-op, but disable/re-enable clearly isn't.
>>>>
>>>>> Ultimately, I don't care much one way or another as long as we can get
>>>>> the desktop platforms fixed somehow.  I think disabling decode is the
>>>>> most correct way of doing this, but I'm open to other solutions (this
>>>>> is the only patch I've seen though that's been tested to solve the
>>>>> problem).
>>>> There are two other solutions: one is to disable decode selectively,
>>>> only on devices or systems where it's necessary and known to be safe.
>>>> I've posted a patch which introduces "disable_while_probe" pci_dev
>>>> field for that purpose.
>>>> Another one is to delay mmconfig probe until after the PCI probe is
>>>> done, as Matthew suggested, and Robert confirmed that it's feasible.
>>> for everyone who's using this quirk or has the same boot issue: I just
>>> confirmed that the new dg33tl bios update v0287 (released 9/20) fixes the
>>> boot issue for my systems. I encourage everyone to update their BIOS
>>> image and see if this works.
> 
> No, it still doesn't work even with a latest BIOS verstion. I have a computer 
> with Intel DQ35MP motherboard. I upgraded BIOS to rev. 0696, released 
> Oct 1. But kernel (2.6.22.5) still hangs up. Kernel with this fix patch boots 
> and works fine.

please note that your BIOS is completely different than the one posted above. This
may be a clue.

interestingly enough I can attest (somewhat) to this. After the BIOS upgrade
2.6.22 booted just fine without pci=nommconf, but I've had several boot lockups
with 2.6.23-rc8.

So, the issue is still open and Matthew/Jesse's suggested fix becomes much more
attractive to me now.

Greg, I suggest putting this patch back in the "grey" zone

Auke
