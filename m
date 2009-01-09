Return-Path: <linux-kernel-owner+w=401wt.eu-S1763461AbZAIAkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763461AbZAIAkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 19:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZAIAkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 19:40:05 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:53448 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbZAIAkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 19:40:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EOQZDA+049Ok/qEWC6NcMwS3wjEJ8QFA4wcZ71fo32YzyNF7SzBjdcq9i5TSEhuLJA
         zVDHjJh4xxhNwuw8Thu56JgyKnIoka/RRyWKazsZHDM7f/9M+qzU7vYta0ArCc+SSKrw
         I1vKyfi1nJarEx0jeu9IXFgng/AjIrqPCu6Ak=
Message-ID: <49669CDA.2010308@gmail.com>
Date: Thu, 08 Jan 2009 19:39:54 -0500
From: Connor Behan <connor.behan@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b1pre) Gecko/20080904135032 Shredder/3.0b1pre
MIME-Version: 1.0
To: Gary Hade <garyhade@us.ibm.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Linux PCI <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Can't allocate resources for PCI video card behind bridge
References: <49665493.4070808@gmail.com> <200901082057.00170.rjw@sisk.pl> <200901081226.38909.jbarnes@virtuousgeek.org> <20090109000808.GA7703@us.ibm.com>
In-Reply-To: <20090109000808.GA7703@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade wrote:
> On Thu, Jan 08, 2009 at 12:26:38PM -0800, Jesse Barnes wrote:
>    
>> On Thursday, January 8, 2009 11:56 am Rafael J. Wysocki wrote:
>>      
>>> Cc-ing linux-pci and Jesse.
>>>
>>> On Thursday 08 January 2009, Connor Behan wrote:
>>>        
>>>> Hello, I am trying to use two video cards. One is the built in ATI Rage
>>>> Mobility M3 AGP card which drives the screen of my laptop (Thinkpad a22m
>>>> 2628-S1U if that matters), the other is the ATI Radeon X1550 PCI card in
>>>> the Thinkpad Dock II which is supposed to drive an external monitor.
>>>> X1550 is a PCI-E chipset but my card is a PCI card with an onboard PCI
>>>> to PCI-E bridge. I first tried this with kernel 2.6.27 as packaged by
>>>> Archlinux and got the following startup errors:
>>>>
>>>> pci 0000:00:04.0: BAR 7: can't allocate resource
>>>> pci 0000:00:04.0: BAR 8: can't allocate resource
>>>> pci 0000:00:04.0: BAR 9: can't allocate resource
>>>>
>>>> I've seen this problem discussed in the archives and couldn't find what
>>>> looked like a fix. I WAS able to fix this by loading dock, pci_slot,
>>>> pci_hotplug and acpiphp and appending pci=assign-busses. However since
>>>> then I have run a package update to kernel 2.6.27.10 and I am once again
>>>> getting the same problem even with the same modules and parameters. I
>>>> have since tried appending irqpoll, pci=bios, pci=routeirq and acpi=off
>>>> with no success. I have even rolled back my kernel to 2.6.27 (and the
>>>> headers and a few other packages) setup my system the way it was setup
>>>> before to the best of my knowledge but I still can't get the PCI card
>>>> working again. Another subtle change must be responsible.
>>>>
>>>> Certain PCI devices in the dock are working such as the Cardbus slots...
>>>> but I could care less about them... is there a way I could tell the
>>>> kernel to prioritize the video card and sacrifice Cardbus slots first if
>>>> it can't allocate enough resources? Also my lspci output shows a large
>>>> gap 01:00.0 to 06:00.0 so some part of my system must have expected
>>>> other devices in that range. When I had the video card working it was
>>>> 02:00.0. I have tried changing the four IRQ numbers in the BIOS but this
>>>> is pointless at best and sometimes causes my soundcard to be disabled.
>>>> My dmesg, lspci and (trimmed) kernel config are pasted:
>>>>
>>>> dmesg: http://pastebin.com/f3ae15a58
>>>> lspci: http://pastebin.com/f5d7dee6e
>>>> .config: http://pastebin.com/fb925760
>>>>
>>>> I'm hoping for a solution that doesn't require recompiling the kernel
>>>> but I definitely would if that's necessary. In any event I'll be much
>>>> more vigilant about system updates if I get this working again.
>>>> Thank-you very much for your time.
>>>>          
>> Can you post the output of lspci -vvv somewhere as well after trying 2.6.28?
>> It may be that we want the "don't allocate resources for transparent bridges"
>> patch after all:
>>
>> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>> index ea979f2..586451c 100644
>> --- a/drivers/pci/setup-bus.c
>> +++ b/drivers/pci/setup-bus.c
>> @@ -467,8 +467,12 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
>>                  }
>>          }
>>
>> -       /* The root bus? */
>> -       if (!bus->self)
>> +       /*
>> +        * We don't need to allocate PCI bridging windows
>> +        * for a root bus (everything bridged) or for a
>> +        * transparent one.
>> +        */
>> +       if (!bus->self || bus->self->transparent)
>>                  return;
>>
>>          switch (bus->self->class>>  8) {
>>      
>
> Jesse, I think this change is doing the same thing as
>    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8fa5913d54f3b1e09948e6a0db34da887e05ff1f
> which was reverted by
>    http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=12c22d6ef299ccf0955e5756eb57d90d7577ac68
> because of
>    http://bugzilla.kernel.org/show_bug.cgi?id=10080
>    http://marc.info/?l=linux-kernel&m=120620382316329&w=2
>    http://marc.info/?l=linux-kernel&m=120653981716729&w=2
>
> It definitely seems like the right thing to do but it apparently
> breaks stuff on systems with oddball transparent bridges.
>
> Gary
>
>    
The output of lspci -vvv is here http://pastebin.com/f126dc794 and it is 
exactly the same on 2.6.27.10 and 2.6.28. I noticed various Thinkpad 
models besdies Subsystem. They are all very close to mine but not 
exactly A22m. Could this mean I need to tweak the DSDT file?

Should I try the above patch at the risk of having to use a custom 
kernel for the rest of my life or do you think there's a way to fix this 
without breaking other systems?
