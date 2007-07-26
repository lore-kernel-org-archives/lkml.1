Return-Path: <linux-kernel-owner+w=401wt.eu-S1765372AbXGZMD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765372AbXGZMD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 08:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbXGZMC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 08:02:59 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:34581 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbXGZMCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 08:02:54 -0400
Message-ID: <46A88D5E.9060204@free.fr>
Date: Thu, 26 Jul 2007 14:02:38 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Pin-pointing the root of unusual application latencies
References: <469600F7.3060603@free.fr> <20070725133835.GA17616@elte.hu> <46A758B5.9070602@free.fr> <200707251309.54240.lenb@kernel.org> <46A85CE9.7070506@free.fr> <46A87B3D.3020003@free.fr>
In-Reply-To: <46A87B3D.3020003@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> John Sigler wrote:
> 
>> Len Brown wrote:
>>
>>> John Sigler wrote:
>>>
>>>> # cat /proc/interrupts
>>>>             CPU0
>>>>    0:         37    XT-PIC-XT        timer
>>>>    1:          2    XT-PIC-XT        i8042
>>>>    2:          0    XT-PIC-XT        cascade
>>>>    7:          0    XT-PIC-XT        acpi
>>>>   10:        175    XT-PIC-XT        eth2, Dta1xx
>>>>   11:       1129    XT-PIC-XT        eth0
>>>>   12:          4    XT-PIC-XT        eth1
>>>>   14:      21482    XT-PIC-XT        ide0
>>>> NMI:          0
>>>> LOC:     161632
>>>> ERR:          0
>>>> MIS:          0
>>>>
>>>> IRQ 10 is shared between a NIC and an I/O board.
>>>>
>>>> For eth2, the kernel said:
>>>> ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC]
>>>>    -> GSI 10 (level, low) -> IRQ 10
>>>>
>>>> For Dta1xx, the kernel said:
>>>> ACPI: PCI Interrupt 0000:02:0e.0[A] -> Link [LNKC]
>>>>    -> GSI 10 (level, low) -> IRQ 10
>>>>
>>>> Is it possible to avoid the two boards sharing IRQ 10?
>>>
>>> Maybe.  In this configuration, INTA of the two devices
>>> is physically connected to the same wire on the device-side
>>> of the interrupt re-mapper -- so you'd have to change the configuration.
>>> If you have an IOAPIC and can enable it, that will not hurt --
>>
>> I believe this board does not provide an IO-APIC.
>> Even the LAPIC is disabled in the BIOS.
>> (Why would they do that??)
>>
>>> though unless something else changes, these devices are still
>>> tied together on the device-side of the mapper.
>>> So if you can physically move one of the devices to another slot
>>> that is your best bet.
> 
> The NICs are on-board, therefore it is not possible to move them.
> 
> The motherboard only has one PCI slot, so the manufacturer includes
> a backplane (is that what it's called?) to provide two PCI slots.
> 
> The results I've given so far were with the I/O board inserted in
> the bottom slot. If it is inserted in the top slot, the results are
> different indeed.
> 
> # cat /proc/interrupts
>            CPU0
>   0:         37    XT-PIC-XT        timer
>   1:          2    XT-PIC-XT        i8042
>   2:          0    XT-PIC-XT        cascade
>   5:      20270    XT-PIC-XT        Dta1xx
>   7:          0    XT-PIC-XT        acpi
>  10:          4    XT-PIC-XT        eth2
>  11:       2639    XT-PIC-XT        eth0
>  12:          4    XT-PIC-XT        eth1
>  14:      13984    XT-PIC-XT        ide0
> NMI:          0
> LOC:     518501
> ERR:          0
> MIS:          0

With a 4-port NIC (instead of the I/O board) inserted in the top slot.

# cat /proc/interrupts
            CPU0
   0:         37    XT-PIC-XT        timer
   1:          2    XT-PIC-XT        i8042
   2:          0    XT-PIC-XT        cascade
   5:          0    XT-PIC-XT        eth3
   7:          0    XT-PIC-XT        acpi
  10:          4    XT-PIC-XT        eth1, eth5
  11:          4    XT-PIC-XT        eth2, eth6
  12:        265    XT-PIC-XT        eth0, eth4
  14:      12726    XT-PIC-XT        ide0
NMI:          0
LOC:      12704
ERR:          0
MIS:          0

With the 4-port NIC inserted in the bottom slot.

# cat /proc/interrupts
            CPU0
   0:         37    XT-PIC-XT        timer
   1:          2    XT-PIC-XT        i8042
   2:          0    XT-PIC-XT        cascade
   5:          4    XT-PIC-XT        eth2, eth3
   7:          0    XT-PIC-XT        acpi
  10:         99    XT-PIC-XT        eth0, eth5
  11:          4    XT-PIC-XT        eth1, eth6
  12:          0    XT-PIC-XT        eth4
  14:      12138    XT-PIC-XT        ide0
NMI:          0
LOC:       3554
ERR:          0
MIS:          0

As far as I understand, this board has 4 interrupt lines, and they are 
mapped (by the BIOS? by Linux?) to ISA IRQs 5, 10, 11, and 12.

If I insert another 4-port NIC in the remaining slot, eth7 through eth10 
will spread to these IRQs. Correct?

Suppose 3 NICs share the same interrupt line, and each receives 1500 
packets per second. (I suppose that translates to 1500 interrupt 
requests per second.) Will the system cope with 4500 interrupt requests 
from 3 different devices on the same interrupt line? How different is it 
from 4500 interrupt requests from a single device not sharing the line?

Regards.
