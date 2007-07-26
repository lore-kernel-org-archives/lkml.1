Return-Path: <linux-kernel-owner+w=401wt.eu-S1765936AbXGZKpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765936AbXGZKpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 06:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760322AbXGZKpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 06:45:34 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:57941 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759203AbXGZKpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 06:45:32 -0400
Message-ID: <46A87B3D.3020003@free.fr>
Date: Thu, 26 Jul 2007 12:45:17 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Pin-pointing the root of unusual application latencies
References: <469600F7.3060603@free.fr> <20070725133835.GA17616@elte.hu> <46A758B5.9070602@free.fr> <200707251309.54240.lenb@kernel.org> <46A85CE9.7070506@free.fr>
In-Reply-To: <46A85CE9.7070506@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

> Len Brown wrote:
> 
>> John Sigler wrote:
>>
>>> # cat /proc/interrupts
>>>             CPU0
>>>    0:         37    XT-PIC-XT        timer
>>>    1:          2    XT-PIC-XT        i8042
>>>    2:          0    XT-PIC-XT        cascade
>>>    7:          0    XT-PIC-XT        acpi
>>>   10:        175    XT-PIC-XT        eth2, Dta1xx
>>>   11:       1129    XT-PIC-XT        eth0
>>>   12:          4    XT-PIC-XT        eth1
>>>   14:      21482    XT-PIC-XT        ide0
>>> NMI:          0
>>> LOC:     161632
>>> ERR:          0
>>> MIS:          0
>>>
>>> IRQ 10 is shared between a NIC and an I/O board.
>>>
>>> For eth2, the kernel said:
>>> ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC]
>>>    -> GSI 10 (level, low) -> IRQ 10
>>>
>>> For Dta1xx, the kernel said:
>>> ACPI: PCI Interrupt 0000:02:0e.0[A] -> Link [LNKC]
>>>    -> GSI 10 (level, low) -> IRQ 10
>>>
>>> Is it possible to avoid the two boards sharing IRQ 10?
>>
>> Maybe.  In this configuration, INTA of the two devices
>> is physically connected to the same wire on the device-side
>> of the interrupt re-mapper -- so you'd have to change the configuration.
>> If you have an IOAPIC and can enable it, that will not hurt --
> 
> I believe this board does not provide an IO-APIC.
> Even the LAPIC is disabled in the BIOS.
> (Why would they do that??)
> 
>> though unless something else changes, these devices are still
>> tied together on the device-side of the mapper.
>> So if you can physically move one of the devices to another slot
>> that is your best bet.

The NICs are on-board, therefore it is not possible to move them.

The motherboard only has one PCI slot, so the manufacturer includes
a backplane (is that what it's called?) to provide two PCI slots.

The results I've given so far were with the I/O board inserted in
the bottom slot. If it is inserted in the top slot, the results are
different indeed.

# cat /proc/interrupts
            CPU0
   0:         37    XT-PIC-XT        timer
   1:          2    XT-PIC-XT        i8042
   2:          0    XT-PIC-XT        cascade
   5:      20270    XT-PIC-XT        Dta1xx
   7:          0    XT-PIC-XT        acpi
  10:          4    XT-PIC-XT        eth2
  11:       2639    XT-PIC-XT        eth0
  12:          4    XT-PIC-XT        eth1
  14:      13984    XT-PIC-XT        ide0
NMI:          0
LOC:     518501
ERR:          0
MIS:          0

$ diff dmesg.adlink dmesg2.adlink
208c208,210
< ACPI: PCI Interrupt 0000:02:0e.0[A] -> Link [LNKC] -> GSI 10 (level, 
low) -> IRQ 10
---
 > ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 5
 > PCI: setting IRQ 5 as level-triggered
 > ACPI: PCI Interrupt 0000:02:0f.0[A] -> Link [LNKD] -> GSI 5 (level, 
low) -> IRQ 5

$ diff lspci.adlink lspci2.adlink
121c121
< 02:0e.0 Multimedia controller: PLX Technology, Inc. 9056 PCI I/O 
Accelerator
---
 > 02:0f.0 Multimedia controller: PLX Technology, Inc. 9056 PCI I/O 
Accelerator
126c126
<       Interrupt: pin A routed to IRQ 10
---
 >       Interrupt: pin A routed to IRQ 5

I'll give a 4-port PCI NIC a spin.

Regards.
