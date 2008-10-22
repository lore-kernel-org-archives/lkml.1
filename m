Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYJVHUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYJVHUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYJVHUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:20:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:37503 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbYJVHUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:20:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,462,1220252400"; 
   d="scan'208";a="351051039"
Message-ID: <48FED3FA.6040703@linux.intel.com>
Date: Wed, 22 Oct 2008 09:19:22 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Henroid, Andrew D" <andrew.d.henroid@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] i7300_idle driver v1.55
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com> <e8b529091b2ab65f5a4783e292c2b472e309116e.1223706853.git.len.brown@intel.com> <20081011083347.GA31918@elte.hu> <alpine.LFD.1.10.0810161805360.3026@localhost.localdomain> <48FE07AE.4010203@linux.intel.com> <7E82351C108FA840AB1866AC776AEC4637CD27F3@orsmsx505.amr.corp.intel.com>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC4637CD27F3@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
> 
>>> +#if CONFIG_I7300_IDLE_IOAT_CHANNEL
>>> +     device->common.chancnt--;
>>> +#endif
>> I still think this lone decrement looks fishy. Can there please be some
>> explanation how it exactly relates to the i7300 idle driver, where the
>> matching increment is, etc.?
> 
> No. This is not a increment/decrement thing. It is basically telling other
> Users of IOAT that they have one IOAT channel less that they can use.
> The last IOAT channel is used by i7300 idle driver to get the throttling to
> work.

Ok then it should be made conditional on the i7300 actually be available
in the system?  It looks like you do it always no matter what chipset is in there.


> udelay may be more power efficient than polling. 

Isn't that function a one off anyways?

>>> +/* Check for known platforms with I/O-AT */
>>> +static int __init i7300_idle_platform_probe(void)
>>> +{
>>> +     int i;
>>> +
>>> +     fbd_dev = pci_get_bus_and_slot(MEMCTL_BUS, MEMCTL_DEVFN)
>> Is there a specific reason you cannot match this by pci vendor/devid
>> like all standard drivers do?
>>
>> If there is a good reason add a comment.
> 
> They have to match vendor device and function. Its not unique to
> just vendor and device id.

It might be still better then to use the standard callback style and just ignore
devices that don't match?


> 
>> ;
>>> +static void __exit i7300_idle_exit(void)
>>> +{
>>> +     idle_notifier_unregister(&i7300_idle_nb);
>> I still think this needs some kind of idle synchronization.
> 
> This unregister uses atomic_notifier_chain_unregister() which
> uses RCU and handles the race conditions that way. 

I didn't do a full analysis, but I didn't think RCU protects
against the idle handler itself.  At least not standard RCU.
You would need to go through at least two quiescent periods,
not one as standard code.

There used to be an older
idle synchronization interface for this case (which was removed
at some point), perhaps it needs to be readded.

Or just use stop_machine(). That protects against idle too
and while it's a big hammer for unloading it should be ok.

-Andi
