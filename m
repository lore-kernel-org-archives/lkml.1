Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbXJ2XvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbXJ2XvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbXJ2XvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:51:07 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:49557 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbXJ2XvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:51:06 -0400
Date: Mon, 29 Oct 2007 17:52:18 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
In-reply-to: <20071027024140.GC29039@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       ak@suse.de, rajesh.shah@intel.com, torvalds@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <47267232.3020506@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org>
 <200710251622.36773.jbarnes@virtuousgeek.org>
 <20071026025407.GA21408@kroah.com>
 <200710260959.46811.jbarnes@virtuousgeek.org>
 <20071027024140.GC29039@kroah.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Oct 26, 2007 at 09:59:45AM -0700, Jesse Barnes wrote:
>> On Thursday, October 25, 2007 7:54 pm Greg KH wrote:
>>> On Thu, Oct 25, 2007 at 04:22:35PM -0700, Jesse Barnes wrote:
>>>> I think Greg doesn't like it, even though we don't have an
>>>> alternative at this point...
>>> Yes, I didn't like it, Ivan didn't like it, and I got reports that it
>>> wasn't even needed at all once you upgraded your BIOS to the latest
>>> version.
>>>
>>> So, is this still needed?  And if so, can you try to implement what
>>> Ivan suggested to do here instead?
>> Yes, it's still needed.  Auke rescinded his "BIOS upgrade makes it work" 
>> message, so something like this is still necessary.
> 
> He did?  Ugh, I can't keep these all straight, sorry.
> 
> Can someone just send what they think is still needed, and explain why
> Ivan will not object to it?  :)

Here's a recap of the whole issue just for people's information:

Right now we disable MMCONFIG on machines where the MCFG area is not 
reserved in the E820 memory map since we figure it's not valid. This is 
a broken heuristic because the PCI Express firmware spec doesn't require 
that it be so reserved, it only needs to be reserved as an ACPI 
motherboard resource, and so many times it's not reserved in E820 
despite being completely valid and working. The 
mmconfig-validate-against-acpi-motherboard-resources.patch changes this 
to validate against the ACPI motherboard resources instead.

The second problem is that on some machines, when we are doing BAR 
sizing on PCI devices, and write all ones to a BAR in order to determine 
how many bits "stick", the BAR ends up overlapping with the MCFG area. 
On some chipsets, this causes writes to the MCFG area (like, to restore 
the original BAR contents) to get decoded by the device instead of by 
the MCFG mechanism, which means the BAR stays disabled and configuration 
access stops working, wreaking havoc. Usually on these machines the 
MMCONFIG is located near the top of 32-bit memory and the PCI device 
causing problems is a PCI Express graphics card. 
pci-disable-decode-of-io-memory-during-bar-sizing.patch, and its 
successors, switch off the device's decoding during sizing so that it 
won't absorb the accesses to the MCFG table.

The concern raised was that this might affect some devices negatively. 
We do avoid disabling decode on host bridges, as it's known that some of 
them disable RAM access when you turn decode off, stupidly. I've yet to 
hear of any other conclusive case where disabling the decode is harmful. 
In general, if disabling the decode causes issues, the mere fact of 
doing the BAR sizing could cause the same issues, and that is unavoidable.

The other possible workaround would be to avoid using MMCONFIG until the 
BAR sizing is done. However, this seems like a poor solution. First of 
all, in the future there may come machines where MMCONFIG is the only 
config mechanism (or, perhaps more likely, it becomes the only tested 
one, so the old methods get broken). Secondly, what happens with 
hot-plug devices that need to be sized after MMCONFIG gets turned on?

The only way these two patches are related is that the E820 check 
happens to wrongly disable MMCONFIG on some of the machines where the 
memory areas could overlap during sizing, so removing that check alone 
without fixing the overlap issue could cause breakage on some machines. 
However, this is purely by chance, and it doesn't prevent the breakage 
on many other machines - as well as the one mentioned in the earlier 
thread, there's this one:

https://bugzilla.redhat.com/show_bug.cgi?id=251493

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/
