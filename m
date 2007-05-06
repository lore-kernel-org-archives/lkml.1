Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbXEFJfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbXEFJfA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 05:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933471AbXEFJfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 05:35:00 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:45542 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711AbXEFJe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 05:34:59 -0400
Date: Sun, 6 May 2007 11:32:24 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
cc: Wander Winkelhorst <w.winkelhorst@gmail.com>,
       David Johnson <dj@david-web.co.uk>, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
In-Reply-To: <463D9E8E.8040500@interia.pl>
Message-ID: <Pine.LNX.4.61.0705061125010.8623@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr> 
 <200705042320.41278.dj@david-web.co.uk>  <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>
  <463C18C4.7030304@interia.pl> <5699f8f00705050144s5c00a455s8f7dba9258d83986@mail.gmail.com>
 <463CC380.3060603@interia.pl> <Pine.LNX.4.61.0705052028560.18504@yvahk01.tjqt.qr>
 <463CE1FB.4050305@interia.pl> <Pine.LNX.4.61.0705052237580.18504@yvahk01.tjqt.qr>
 <463D63D8.8010901@interia.pl> <Pine.LNX.4.61.0705060959200.23047@yvahk01.tjqt.qr>
 <463D9E8E.8040500@interia.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 6 2007 11:23, Rafał Bilski wrote:
>
>> <6>No local APIC present or hardware disabled
>> <7>mapped APIC to ffffd000 (011ea000)
>> <5>Local APIC not detected. Using dummy APIC emulation.
>
>I/O APIC is very bad thing with Longhaul, but You don't have 
>local APIC, so it shouldn't be used.
>
>> <6>ACPI: Using PIC for interrupt routing
>
>Looks like it isn't.
>
>> <4>ACPI: PCI Interrupt Link [ALKA] (IRQs *20), disabled.
>> <4>ACPI: PCI Interrupt Link [ALKB] (IRQs *21)
>> <4>ACPI: PCI Interrupt Link [ALKC] (IRQs *22)
>> <4>ACPI: PCI Interrupt Link [ALKD] (IRQs *23), disabled.
>
>This is pointing to I/O APIC, but I don't see later that 
>such high interrupts are used. And if I/O APIC would be in 
>use You would have lockup in the moment of transition.

cn:~ # cat /proc/interrupts 
           CPU0       
  0:    1745595    XT-PIC-XT        timer
  1:         29    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  5:       1194    XT-PIC-XT        uhci_hcd:usb1, uhci_hcd:usb2, eth0
  7:          1    XT-PIC-XT        ehci_hcd:usb5
  8:          2    XT-PIC-XT        rtc
  9:          0    XT-PIC-XT        acpi
 12:          0    XT-PIC-XT        uhci_hcd:usb3, uhci_hcd:usb4, eth1
 14:      59882    XT-PIC-XT        libata
 15:          0    XT-PIC-XT        libata
NMI:          0 
LOC:          0 
ERR:          0
MIS:          0

So, just the regular 16.

>I was suspecting:
>> One of the 2.6.21 regressions was Guilherme's problem seeing his box
>> lock up when the system detected an unstable TSC and dropped back to
>> using the HPET.
>> 
>> In digging deeper, we found the HPET is not actually incrementing on
>> this system. And in fact, the reason why this issue just cropped up was
>> because of Thomas's clocksource watchdog code was comparing the TSC to
>> the HPET (which wasn't moving) and thought the TSC was broken.
>
>because I know that VT8237 has HPET built in. But I don't see any lines 
>starting with "hpet: enabled" or something similar. But I don't know 
>what to search for. I didn't have contact with HPET earlier.
>It is very similar and Your problem with ondemand is starting right 
>after
>
>> May  3 19:17:22 cn kernel: Clocksource tsc unstable (delta = -136422685 
>> ns)
>
>I don't see such message as long as "performance" governor is used. 

Well this message pops up whenever the frequency changes, because
the CPU does not have constant_tsc. E.g.

<performance is default and active>
echo 598000 >/sys/devices/cpu/cpu0/cpufreq

spews out the clocksource message. I do not think the clocksource
is a culprit. The kernel just noticed the TSC jumped and hence
uses a new clocksource.

>Anyway adding "hpet=disable" at boot should confirm for sure that it 
>isn't it. And I think that John already ruled this out by 
>clocksource=acpi_pm.
>
>Sorry 
>Rafał

Nevermind, it does not look like it gets any cooler at lower frequencies,
so it's a nobrainer to run it at the default 733.


Jan
-- 
