Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbXL1TQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbXL1TQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbXL1TQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:16:23 -0500
Received: from mailbox2.myri.com ([64.172.73.26]:1947 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751814AbXL1TQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:16:21 -0500
Message-ID: <47754B26.6050700@myri.com>
Date: Fri, 28 Dec 2007 14:14:46 -0500
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>,
       Kai Ruhnau <kai@tragetaschen.dyndns.org>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
References: <fa.m7tRTz/ymu3iMyLTO2aF1Tvaw24@ifi.uio.no>	 <fa.XrRLIuL4juNAXXaMPF3iY8FyWW8@ifi.uio.no>	 <fa.H0fcNl3b6xVBwzWUgT72M4K6KOU@ifi.uio.no> <4773EBB4.2020805@shaw.ca>	 <alpine.LFD.0.9999.0712271023090.21557@woody.linux-foundation.org>	 <477414C9.3040906@myri.com>	 <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org>	 <1198819790.7209.27.camel@pasglop>	 <alpine.LFD.0.9999.0712272135270.21557@woody.linux-foundation.org> <1198822010.7209.32.camel@pasglop>
In-Reply-To: <1198822010.7209.32.camel@pasglop>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/28/2007 1:06 AM, Benjamin Herrenschmidt wrote:
> On Thu, 2007-12-27 at 21:37 -0800, Linus Torvalds wrote:
>   
>> On Fri, 28 Dec 2007, Benjamin Herrenschmidt wrote:
>>     
>>> I have embedded boards where proper CRS operations is critical since the
>>> kernel brings the PCIe link up itself, and thus is likely to hit devices
>>> still in the middle of CRS.
>>>       
>> .. but that's perfectly fine. A PCI-E bridge will certainly retry it in 
>> hardware (or it isn't a PCI-E bridge!).
>>     
>
> Only a handful of times in many bridges I've seen.
>   




Yes retry implementation are not universal. But bridges with
CRS-visibility might be even less common (both are
optional/implementation-specific features).


To make some choices for our own devices, we experimented at Myricom
with CRS on a few chipsets to see what they implement:

broadcom/serverworks 2000/1000: no-retry/ no-visibility
nvidia CK804/IO804: no-retry/no-visibility
nvidia MPC55/IO55: no-retry/no-visibility
intel-7520: does-retry/no-visibility
intel-975X:  does-retry/no-visibility
intel-5000series: does-retry/no-visibility
intel X38: does-retry/no-visibility
AMD/ATI RD790: no-retry/no-visibility


[ in all no-retry cases, when a CRS is somehow returned to the
pcie-root, the requester will get a 0xfffffffff, depending on chipsets,
other error bits (malformed-tlp, completion-timeout) might be triggered ]


>From the data reported on this mailing-list, it seems like the ATI tries
to implement CRS-visibility, but it is obviously buggy.


Not knowing whether there is any chipset with the visibility feature,
but without the retry capability, and given that CRS is irrelevant for
most Linux platforms (it only matters just after power-on, long before
Linux is started in the common case), it seems fair that
CRS-visibility-enabling should only be added in the specific code of the
specific embedded platforms (with no BIOS/firmware of any kind) that
might need it.



>  
>   
>> So I'm going to disable that thing. If there is some _other_ PCI-E bridge 
>> that is simply buggy, and cannot handle the hw retry itself or is just 
>> otherwise dodgy, we can have a white-list for cases where it really needs 
>> to be done, but the current code is just bogus.
>>     
>
> If you disable it, then isn't there also a problem with PCIE->PCI-X
> bridge which will stop issuing CRS when they should ? (not sure here, I
> may be a bit confused).
>   


This is mostly independant, allowing a PCIE->PCI-X bridge to generate
CRS is a different bit (bit 15 of pcie->devctl on the bridge). FWIW,
Linux does not seem to touch it, and it defaults to zero, so it does not
seem like most current PCIE->PCI-X bridge will never generates a CRS
(some BIOSes might do it, but not the couple of platforms I looked at).
Again the choice of setting here seems something better left to the
specific BIOS/embedded-code for a given platform.


Loic

