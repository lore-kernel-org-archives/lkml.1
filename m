Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbZBAWNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbZBAWNl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 17:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbZBAWNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 17:13:32 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:35174 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbZBAWNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 17:13:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EnKLOPt1Qmiys8l8dFA8k5PeG1ZQyqVnLkabLbdqhej6VGo4sE8g/3tiiWawvTT3Ml
         9augQYGudM2cLCH73d2ISEsbb0gGt7bwwyDg3XP2iLRXR+hEJo9owKAuD0vG7Lt+BgfJ
         LnqR0HU4om1uOL+hRfZZ2a4T4qtcRUAvhTJug=
Message-ID: <49861E88.8060809@gmail.com>
Date: Sun, 01 Feb 2009 16:13:28 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
CC: Adam M Belay <abelay@MIT.EDU>, linux-kernel@vger.kernel.org,
       bjorn.helgaas@hp.com
Subject: Re: [BUG] pnpbios breaks floppy support
References: <20090131212915.GA19276@frolo.macqel> <49854A71.500@gmail.com> <20090201131801.GA326@frolo.macqel> <49860206.2050709@gmail.com> <20090201154849.aekwzfuh5u8c4cso@webmail.mit.edu> <20090201215616.GA24997@frolo.macqel>
In-Reply-To: <20090201215616.GA24997@frolo.macqel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter wrote:
> On Sun, Feb 01, 2009 at 03:48:49PM -0500, Adam M Belay wrote:
>> Quoting Robert Hancock <hancockrwd@gmail.com>:
>>
>>> Philippe De Muyter wrote:
>>>> On Sun, Feb 01, 2009 at 01:08:33AM -0600, Robert Hancock wrote:
>>>>> Philippe De Muyter wrote:
>>>>>> Hello linux experts,
>>>>>> Today I tried to upgrade a PC's kernel from 2.6.11 to 2.6.22, and
>>>>>> I saw some strange messages when booting :
>>>>>> 	Floppy drive(s): fd0 is 1.44M
>>>>>> 	floppy0: Floppy io-port 0x03f2 in use
>>>>>> Previously, I had :
>>>>>> 	Floppy drive(s): fd0 is 1.44M
>>>>>> 	FDC 0 is a post-1991 82077
>>>>>> Needless to say, my floppy hardware works perfectly, and my floppy
>>>>>> was usable with the old kernel, while the floppy is now inaccessible
>>>>>> with the new kernel.  Even /dev/fd0 does not exist anymore.
>>>>>> Searching for a cause to that problem, I saw the following messages
>>>>>> before the floppy probe in the new kernel :
>>>>>> 	PnPBIOS: Scanning system for PnP BIOS support...
>>>>>> 	PnPBIOS: Found PnP BIOS installation structure at 0xc00fd5e0
>>>>>> 	PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0x5ba3, dseg 0xf0000
>>>>>> 	PnPBIOS: 17 nodes reported by PnP BIOS; 17 recorded by driver
>>>>>> 	[...]
>>>>>> 	pnp: 00:07: ioport range 0x3f0-0x3f1 has been reserved
>>>>>> 	pnp: 00:07: ioport range 0x3f3-0x3f3 has been reserved
>>>>>> 	[...]
>>>>>> Searching the web and the outdated pnp kernel documentation, I
>>>>>> finally found an option to add to my kernel parameters line :
>>>>>> 	pnpbios=off
>>>>>> Now my floppy works again, but I am not really satisfied.
>>>>>> What do I loose with the 'pnpbios=off' option ?
>>>>>> Isn't there a smoother option to allow pnpbios but avoiding to reserve
>>>>>> floppy's io-ports ?
>>>>>> Should I modify rather /drivers/block/floppy.c or /drivers/pnp/*.c
>>>>>> to make pnpbios and floppy driver coexist peacefully ? And is there
>>>>>> an example of such modifications for other standard peripherals ?
>>>>> Presumably the problem is that your BIOS marks the IO ports used by the 
>>>>> floppy controller as reserved which prevents the floppy driver from 
>>>>> binding to them. (2.6.11 probably was before we even processed PnP 
>>>>> reserved regions.)
>>>>>
>>>>> I think we now have handling for the case where the reservations overlap 
>>>>> PCI devices, but I think it's the first I've heard of them overlapping 
>>>>> the floppy IO ports..
>>>> I should have added that, when started with pnpbios enabled, I have found 
>>>> the following in /sys/devices/pnp0/ :
>>>>
>>>> 	$ cat 00:03/id
>>>> 	PNP0700
>>>> 	$ cat 00:03/resources 	state = active
>>>> 	io 0x3f4-0x3f5
>>>> 	io 0x3f2-0x3f2
>>>> 	irq 6
>>>> 	dma 2
>>>> 	$ cat 00:03/options
>>>> 	port 0x3f4-0x3f4, align 0x0, size 0x2, 16-bit address decoding
>>>> 	port 0x3f2-0x3f2, align 0x0, size 0x1, 16-bit address decoding
>>>> 	irq 6 High-Edge
>>>> 	dma 2 8-bit compatible
>>>>
>>>> AFAIK, PNP0700 is the pnp id for the standard floppy disk,
>>>> and the resources and options files describe the expected io-ports
>>>> of the floppy disk, so this does not seem to be an error in the bios.
>>> There's likely another resource with id of PNP0C01 or PNP0C02 (Motherboard 
>>> resources) which contains that same IO port range.
>>>
>> Yes, could you post the same information for 00:07 so we can start to 
>> narrow
>> this down?  Also having "cat /proc/ioports" couldn't hurt.
> 
> Here it is, and that shows that you are thus both really experts in that area :
> 
> 	$ cat 00:07/id 00:07/resources
> 	PNP0c02
> 	state = active
> 	io 0x80-0x80
> 	io 0x10-0x1f
> 	io 0x22-0x3f
> 	io 0x44-0x5f
> 	io 0x90-0x9f
> 	io 0xa2-0xbf
> 	io 0x3f0-0x3f1
> 	io 0x3f3-0x3f3
> 	mem 0x100000-0xc0fffff
> 	mem 0xfff80000-0xfff94fff
> 	mem 0xfff98000-0xfffbffff
> 	mem 0xfffc0000-0xffffffff
> 
> 	$ cat /proc/ioports 
> 	0000-001f : dma1
> 	0020-0021 : pic1
> 	0040-0043 : timer0
> 	0050-0053 : timer1
> 	0060-006f : keyboard
> 	0070-0077 : rtc
> 	0080-008f : dma page reg
> 	00a0-00a1 : pic2
> 	00c0-00df : dma2
> 	00f0-00ff : fpu
> 	0170-0177 : 0000:00:07.1
> 	  0170-0177 : libata
> 	01f0-01f7 : 0000:00:07.1
> 	  01f0-01f7 : libata
> 	02f8-02ff : serial
> 	0376-0376 : 0000:00:07.1
> 	  0376-0376 : libata
> 	0378-037a : parport0
> 	037b-037f : parport0
> 	03c0-03df : vga+
> 	03f0-03f1 : pnp 00:07
> 	03f3-03f3 : pnp 00:07
> 	03f6-03f6 : 0000:00:07.1
> 	  03f6-03f6 : libata
> 	03f8-03ff : serial
> 	04d0-04d1 : pnp 00:11
> 	0cf8-0cff : PCI conf1
> 	ec00-ec7f : 0000:00:03.0
> 	  ec00-ec7f : tulip
> 	ecf0-ecff : 0000:00:07.1
> 	  ecf0-ecff : libata
> 
> Thanks for your quick answers.  Feel free to ask more info's

Likely we should change things so that if a motherboard resource 
overlaps another PnP resource then we ignore it, as obviously Windows 
permits this behavior..
