Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbXLMEXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbXLMEXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 23:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbXLMEXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 23:23:09 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:34393 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbXLMEXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 23:23:08 -0500
Date: Wed, 12 Dec 2007 22:22:22 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Possible issue with dangling PCI BARs
In-reply-to: <fa.4FjaYKIciOijtgO+0DDrMkrLjv0@ifi.uio.no>
To: benh@kernel.crashing.org
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Message-id: <4760B37E.3010002@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.YfTvVN5C3e6zwXPW5biWgeZ9XXc@ifi.uio.no>
 <fa.EhUqlM3V3y3HCcQkLBLSEKTJxBs@ifi.uio.no>
 <fa.4FjaYKIciOijtgO+0DDrMkrLjv0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Thu, 2007-12-13 at 14:05 +1100, Benjamin Herrenschmidt wrote:
>> On Thu, 2007-12-13 at 14:00 +1100, Benjamin Herrenschmidt wrote:
>>
>>  .../...
>>
>> (oops, sent too fast)
>>
>>> So not only we can have a dangling BAR, but nothing prevent us to
>>> actually go turn IO or MEM decoding on in case it wasn't already the
>>> case on that device.
>> And I was about to say before I clicked "send".. can't we do something like
>> writing all ff's into the BAR at the same time as we clear res->start ? Isn't
>> that supposed to pretty much disable decoding on that BAR ? Or not... Probably
>> still better than leaving it to whatever dangling value it had no ?
> 
> Ok, reading some other threads, it seems that writing all ff's will not
> be a very good alternative on x86 machines where MMCONFIG sits up
> there...
> 
> I suppose there is nothing totally safe that can be done, thanks to
> Intel not thinking about making BARs individually enable/disable'able
> (or size-able without interrupting access, among other numerous fuckups
> in the PCI spec).
> 
> So if a BAR is left dangling, I think we -must- disable MEM and IO
> decoding on the whole device. In fact, the whole trick of passing a
> bitmask of required BARs to pci_enable_device_bars() in the first place
> doesn't fly.
> 
> Yuck.

We could do a bit better than that - a common use case with 
pci_enable_device_bars would be where the device has some IO space that 
we don't care about because we only want to use MMIO space. If we only 
want to enable MMIO BARs then we don't need to enable IO decoding, and 
in that case it doesn't matter if we failed to find space for the IO 
space and it overlaps something else.

It looks like we already handle the "not enabling IO decoding" part in 
this case, except that it doesn't look like we ever would disable the 
decoding if it was already enabled.

For the case where you say "I want to enable decoding for this MMIO BAR, 
but not that one", though, I don't see an obvious way to provide that 
guarantee with certainty. Normally, one would expect that if a BAR is 
mapped safely outside the decode window of a PCI bridge it's behind, 
that it won't ever see the requests and can't respond to them. However, 
the Intel chipset MMCONFIG overlap fiasco appears to show that this is 
not always the case and in some cases the device can see and respond to 
requests outside of the bridge's decode window (with higher decode 
priority than the MMCONFIG aperture, even)..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

