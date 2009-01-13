Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbZAMCnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbZAMCnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 21:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbZAMCnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 21:43:00 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:62131 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996AbZAMCm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 21:42:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=D4Q7p6vu5TygltEGht3Y9eg+rZi06qdQIU1hsL+9SOqhmRKPIOjGvcud4/bQYVFY4F
         3fQUm9k+uD5bBXVnI4QXv6k+lSSIzZPcGf+9kMEniadgRzLXQkk+Y0TYfbLFk8vcz5rO
         y7jCoFNjKRQUgr7dv6rAjX9yHrmJM7uMYlZhg=
Message-ID: <496BFFAA.3000707@gmail.com>
Date: Mon, 12 Jan 2009 21:42:50 -0500
From: Connor Behan <connor.behan@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b1pre) Gecko/20080904135032 Shredder/3.0b1pre
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linux PCI <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Gary Hade <garyhade@us.ibm.com>
Subject: Re: Can't allocate resources for PCI video card behind bridge
References: <49665493.4070808@gmail.com> <200901082057.00170.rjw@sisk.pl> <200901081226.38909.jbarnes@virtuousgeek.org> <200901091530.58694.bjorn.helgaas@hp.com> <20090110200902.GA14664@colo.lackof.org>
In-Reply-To: <20090110200902.GA14664@colo.lackof.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for being away over the weekend.
>> Here's how I interpret your lspci at http://pastebin.com/f126dc794;
>> see if it makes sense to you:
>>
>> Bus 00 has a bunch of devices that are built into the laptop.
>> Bus 01 has your built-in VGA below the AGP bridge at 00:01.0.
>> Buses 02-05 are for a laptop CardBus slot below the bridge at 00:02.0.
>> Buses 06-09 are for a laptop CardBus slot below the bridge at 00:02.1.
>> Buses 0a-12 are for things below the docking bridge at 00:04.0.
>>    Buses 0b-0e are for a Dock II CardBus slot below the bridge at 
>> 0a:02.0.
>>    Buses 0f-12 are for a Dock II CardBus slot below the bridge at 
>> 0a:02.1.
>>
>> I don't see your plug-in X1550 card.  If it were there, I suppose the
>> PCI to PCI-E bridge would be on bus 0a, with the actual video device
>> on some secondary bus like 13?
Most of that makes sense, I think the PCI to PCI-E bridge was somewhere 
on bus 0a but the VGA Compatible Controller was definitely bus 02. The 
busses only go up to 0a because I'm using pci=assign-busses. If I don't 
use that, they stop at 12.
>>> It may be that we want the "don't allocate resources for transparent 
>>> bridges"
>>> patch after all:
>>>
>>> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>>> index ea979f2..586451c 100644
>>> --- a/drivers/pci/setup-bus.c
>>> +++ b/drivers/pci/setup-bus.c
>>> @@ -467,8 +467,12 @@ void __ref pci_bus_size_bridges(struct pci_bus 
>>> *bus)
>>>                  }
>>>          }
>>>
>>> -       /* The root bus? */
>>> -       if (!bus->self)
>>> +       /*
>>> +        * We don't need to allocate PCI bridging windows
>>> +        * for a root bus (everything bridged) or for a
>>> +        * transparent one.
>>> +        */
>>> +       if (!bus->self || bus->self->transparent)
>>>                  return;
>> I don't understand this transparent bridge stuff very well, but it's
>> common for a bridge to support both positive and subtractive decode.
>> In that case, don't we still want to allocate resources for the
>> positive decode windows?
>>
I tried this patch but the kernel I'm using with that applied gives me 
the following dmesg: http://pastebin.com/f7a01c86 and the following 
lspci -vvv: http://pastebin.com/f3e473a13. Are there any other patches 
that claim to solve this? I know it can be solved without patches 
because of that one fluke attempt where it worked - I just had no way of 
knowing which options actually contributed to that success while it 
lasted. The only thing I remember about my dmesg output when I had this 
working was that it did NOT give the "can't allocate resource" errors 
for BARs 7, 8 and 9.
