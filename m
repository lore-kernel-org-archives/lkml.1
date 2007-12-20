Return-Path: <linux-kernel-owner+w=401wt.eu-S932310AbXLTM2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310AbXLTM2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760186AbXLTM2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:28:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760128AbXLTM2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:28:04 -0500
Message-ID: <476A5FD0.4010804@redhat.com>
Date: Thu, 20 Dec 2007 07:28:00 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-------- Original Message --------
Subject: Re: [PATCH 0/5]PCI: x86 MMCONFIG
Date: Wed, 19 Dec 2007 19:33:45 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
To: Greg KH <gregkh@suse.de>
References: 
<20071219221746.20362.39243.sendpatchset@dhcp83-188.boston.redhat.com> 
<20071219231609.GE24219@suse.de>

Greg KH wrote:
> On Wed, Dec 19, 2007 at 05:17:46PM -0500, tcamuso@redhat.com wrote:
>> There exist devices that do not respond correctly to PCI
>> MMCONFIG accesses in x86 platforms.
> 
> What devices are these?  Do you have reports of them somewhere?
> 
There are the AMD 8131 and 8132, the Serverworks HT1000 bridge chips
and the 830M/MG graphics. Not all versions of these chips present
this pathology, but there are perhaps tens of thousands of systems
out there that have the broken versions of these chipsets.

RedHat have been maintaining a blacklist of systems having these
devices. Systems in the blacklist are confined to legacy PCI
access.

However, some of these systems, high volume ones at that, also have
PCI express buses in them. By limiting the whole platform to legacy
PCI access, we put PCI express extended config capabilities out of
reach. IIRC, the PCIe spec requires platforms to access extended
PCI config space.

> That sounds like this patchset can cause bad side affects on hardware
> that currently works just fine.  That is not a good thing to be adding
> to the kernel, right?
> 
No, the patch set tries to obviate this without requiring endusers to
write customized scripts with "pci=nommconf" and without requiring the
RH folks to add another platform (usually belatedly) to the blacklist.

If a device is going to machine check when you touch it with an mmconfig
access, it will happen with or without this patch-set.

However, the patch-set does cover most of the devices that don't respond
well to mmconfig access. Such devices almost alway7s return garbage when
you read from them.

The one device we know about that throws exceptions is the 830M/MG
graphics chip. This chip passes the read-compare test, so the code
merrily advances to bus sizing. When the bus sizing code writes the
BAR at offset 0x18 in this device, the system hangs.

I am thinking about a machine check handler that can catch these things,
or at least the exceptions. Aborts are not recoverable, according to
intel lore. However, the one device that we know croaks HARD seems to
throw an exception, since it happens in the same exact place every
time. I think we might be able to recover from that.

But that's in the future.


