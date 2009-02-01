Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbZBAUME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbZBAUME (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 15:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZBAULx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 15:11:53 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:10597 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbZBAULw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 15:11:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bm3k4zankrYqcFSYlnjRB8jY+PxHj47MhLeFITYqfyRXmFYSc03AVJQPHMHIiOHOsK
         EVZSKaR6W6XSKNrr8SsXGWEhC7u4bB5HqVHagMWLZPxQV4FZqQJeUTyMnennf1H84QIP
         +zNn5wNiHLPSHCsk/FvBVZdI3xu9u9V7AWwrk=
Message-ID: <49860206.2050709@gmail.com>
Date: Sun, 01 Feb 2009 14:11:50 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
CC: linux-kernel@vger.kernel.org, abelay@mit.edu, bjorn.helgaas@hp.com
Subject: Re: [BUG] pnpbios breaks floppy support
References: <20090131212915.GA19276@frolo.macqel> <49854A71.500@gmail.com> <20090201131801.GA326@frolo.macqel>
In-Reply-To: <20090201131801.GA326@frolo.macqel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter wrote:
> On Sun, Feb 01, 2009 at 01:08:33AM -0600, Robert Hancock wrote:
>> Philippe De Muyter wrote:
>>> Hello linux experts,
>>> Today I tried to upgrade a PC's kernel from 2.6.11 to 2.6.22, and
>>> I saw some strange messages when booting :
>>> 	Floppy drive(s): fd0 is 1.44M
>>> 	floppy0: Floppy io-port 0x03f2 in use
>>> Previously, I had :
>>> 	Floppy drive(s): fd0 is 1.44M
>>> 	FDC 0 is a post-1991 82077
>>> Needless to say, my floppy hardware works perfectly, and my floppy
>>> was usable with the old kernel, while the floppy is now inaccessible
>>> with the new kernel.  Even /dev/fd0 does not exist anymore.
>>> Searching for a cause to that problem, I saw the following messages
>>> before the floppy probe in the new kernel :
>>> 	PnPBIOS: Scanning system for PnP BIOS support...
>>> 	PnPBIOS: Found PnP BIOS installation structure at 0xc00fd5e0
>>> 	PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0x5ba3, dseg 0xf0000
>>> 	PnPBIOS: 17 nodes reported by PnP BIOS; 17 recorded by driver
>>> 	[...]
>>> 	pnp: 00:07: ioport range 0x3f0-0x3f1 has been reserved
>>> 	pnp: 00:07: ioport range 0x3f3-0x3f3 has been reserved
>>> 	[...]
>>> Searching the web and the outdated pnp kernel documentation, I
>>> finally found an option to add to my kernel parameters line :
>>> 	pnpbios=off
>>> Now my floppy works again, but I am not really satisfied.
>>> What do I loose with the 'pnpbios=off' option ?
>>> Isn't there a smoother option to allow pnpbios but avoiding to reserve
>>> floppy's io-ports ?
>>> Should I modify rather /drivers/block/floppy.c or /drivers/pnp/*.c
>>> to make pnpbios and floppy driver coexist peacefully ? And is there
>>> an example of such modifications for other standard peripherals ?
>> Presumably the problem is that your BIOS marks the IO ports used by the 
>> floppy controller as reserved which prevents the floppy driver from binding 
>> to them. (2.6.11 probably was before we even processed PnP reserved 
>> regions.)
>>
>> I think we now have handling for the case where the reservations overlap 
>> PCI devices, but I think it's the first I've heard of them overlapping the 
>> floppy IO ports..
> 
> I should have added that, when started with pnpbios enabled, 
> I have found the following in /sys/devices/pnp0/ :
> 
> 	$ cat 00:03/id
> 	PNP0700
> 	$ cat 00:03/resources 
> 	state = active
> 	io 0x3f4-0x3f5
> 	io 0x3f2-0x3f2
> 	irq 6
> 	dma 2
> 	$ cat 00:03/options
> 	port 0x3f4-0x3f4, align 0x0, size 0x2, 16-bit address decoding
> 	port 0x3f2-0x3f2, align 0x0, size 0x1, 16-bit address decoding
> 	irq 6 High-Edge
> 	dma 2 8-bit compatible
> 
> AFAIK, PNP0700 is the pnp id for the standard floppy disk,
> and the resources and options files describe the expected io-ports
> of the floppy disk, so this does not seem to be an error in the bios.

There's likely another resource with id of PNP0C01 or PNP0C02 
(Motherboard resources) which contains that same IO port range.
