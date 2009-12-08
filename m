Return-Path: <linux-kernel-owner+w=401wt.eu-S965188AbZLHASo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188AbZLHASo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964924AbZLHASn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:18:43 -0500
Received: from snt0-omc4-s23.snt0.hotmail.com ([65.55.90.226]:3031 "EHLO
	snt0-omc4-s23.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935700AbZLHASm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:18:42 -0500
X-Originating-IP: [94.195.177.167]
X-Originating-Email: [johnkyr83@hotmail.com]
Message-ID: <SNT111-DS1740657A3615A93A6C0EDFA78F0@phx.gbl>
From: "Ioannis Kyriakopoulos" <johnkyr83@hotmail.com>
To: "'john stultz'" <johnstul@us.ibm.com>
CC: <linux-kernel@vger.kernel.org>
References: <Acp3UXhD1R6mbV5yTGykTs+HAU6bQg==>	 <SNT111-DS1957B574BA05A48FEDBFF0A7900@phx.gbl> <1f1b08da0912071330i35808790r554f7a3a8d712ca7@mail.gmail.com>
In-Reply-To: <1f1b08da0912071330i35808790r554f7a3a8d712ca7@mail.gmail.com>
Subject: RE: timer interrupt stucks using tickless kernel
Date: Tue, 8 Dec 2009 00:18:41 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acp3hJTXgP6MoRScQaWxQOq8QJ5D+QAFaWmg
Content-Language: en-gb
X-OriginalArrivalTime: 08 Dec 2009 00:18:49.0273 (UTC) FILETIME=[039D6290:01CA779C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I have configured my kernel (2.6.31.6) so that I get periodic ticks from
>> the timer interrupt (i.e. tickless is not configured) with a rate
determined
>> by the HZ value. I've also checked the "high resolution timer support"
>> and also SMP support. The posblem is that the timer is getting
incremented
>> very slowly (way slower than the HZ value), just like it would be if the
>> kernel was tickless. Is there an explanation for that? How can I get
>> periodic
>> timer ticks?
>>
>> AFAI understand, the HPET timer is used through the IO-APIC controller to
>> trigger the processors (N.B. if the "High Resolution Timer Support"
option
>> wasn't checked, the timer used would  be PIT, right?) and each
processor's
>> LAPIC timer is used for time keeping. Please correct me if I am wrong.
>
>Not quite, if High Resolution Timers support was disabled, you would
>still use the HPET hardware instead of the pit, but you'd stay in
>periodic mode. However, since you have Highres Timers on, the system
>is using oneshot mode (which is necessary to trigger interrupts faster
>then HZ), and likely has chosen the LAPIC timer as the interrupt
>source.
>
>In this case, the timer tick becomes an hrt event, that triggers every
>HZ, instead of being caused by a periodic interrupt.

OK, so I configured the kernel as follows, expecting to have periodic 
interrupts by the HPET timer using the PIC controller using only a single
processor (UP configuration). 

Unselected: 
Tickless System (Dynamic Ticks)
High Resolution Timer Support  
Symmetric multi-processing support 
IO-APIC support on uniprocessors (NEW)

Selected: 
Local APIC support on uniprocessors
HPET timer support
 
However, when I ran /proc/interrupts, I noticed many weird things:
1.	The timer is still not getting incremented at a rate determined by
HZ.
2.	When performing cat proc/interrupts, I see that:
          0:        157   IO-APIC-edge      timer
	How the system timer is attached on IO-APIC at the time that the
IO-APIC 
      is disabled on kernel configurations? Basically, the timer is not the
only
      peripheral attached to IO-APIC as can be seen by /proc/interrupts.

Here is the output of /proc/interrupts :

           CPU0
  0:        157   IO-APIC-edge      timer
  1:          2   IO-APIC-edge      i8042
  4:        544   IO-APIC-edge      serial
  8:          1   IO-APIC-edge      rtc0
  9:          0   IO-APIC-fasteoi   acpi
 12:          4   IO-APIC-edge      i8042
 14:          4   IO-APIC-edge      ata_piix
 15:          0   IO-APIC-edge      ata_piix
 16:          0   IO-APIC-fasteoi   uhci_hcd:usb5
 18:          0   IO-APIC-fasteoi   uhci_hcd:usb4
 19:         45   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb3
 22:        149   IO-APIC-fasteoi   HDA Intel
 23:         72   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
 27:          0   PCI-MSI-edge      eth0
NMI:          0   Non-maskable interrupts
LOC:    1865130   Local timer interrupts
SPU:          0   Spurious interrupts
CNT:          0   Performance counter interrupts
PND:          0   Performance pending work
TRM:          0   Thermal event interrupts
THR:          0   Threshold APIC interrupts
MCE:          0   Machine check exceptions
MCP:          7   Machine check polls
ERR:          0
MIS:          0

Is it that difficult to have periodic timer interrupts using HZ rate?

Thanks,

John K.

