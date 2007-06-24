Return-Path: <linux-kernel-owner+w=401wt.eu-S1751505AbXFXSpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbXFXSpX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 14:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbXFXSoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 14:44:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61210 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbXFXSox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 14:44:53 -0400
Message-ID: <467EBB9F.7010102@anagramm.de>
Date: Sun, 24 Jun 2007 20:44:47 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: pharon@gmail.com
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: Dual slot PCI riser messes up ivtv
References: <fa.ELPuDi4dcntxF8hk4oCNldcvgoc@ifi.uio.no>	 <467A89D4.6080607@shaw.ca> <4683D4A0.3000100@anagramm.de>	 <20070621162654.GA10008@csclub.uwaterloo.ca> <4683EA26.6030306@anagramm.de> <1182695244.6316.11.camel@iamer-laptop>
In-Reply-To: <1182695244.6316.11.camel@iamer-laptop>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX185ygKThs50LOoeCzL7PIxR3O7/1Rsb/SjhxxQ
 pNM0VtbxTdRSsJMAmR80td32ugsWozs4t7yhfw0gIkF8M06g80
 yH81n190avwL4olQZz2Ow==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

[problem with PCI riser card, hardware discussion]

> First the riser card is a dual slot one , with a chip on it so I assumed
> it is active. It has jumpers to set the device number of the upper slot
> and the devices in the two slots have to share the IRQ. This is it
> here :
> www.tranquilpc.co.uk/support/Files/TPC014/Tranquil%20Riser.pdf

No, that's not an active one as Krzysztof wrote already.
The GAL only does some simple things.

> Third : The bug lies in the situation where the PVR-150 card is in the
> upper slot and the DVB card is in the lower slot, in which case the DVB
> card does not work. That was the dmesg output I posted earlier.

I have the 32bit version of these cards:
http://paui.de/pub/archive/image/PCI_Riser_3x32bit_passive.jpg
http://paui.de/pub/archive/image/PCI_Riser_3x64bit_passive.jpg

As you can see, the cards are a 1:1 extension to the center slot.
The lower as well as the upper slot gets the additional signals from
the two small PCBs which are the four INTA...INTD and the REQest and
GraNT lines. The IDSELect's are soldered via 220R resistors to some
address lines.

> Fourth : here's cat /proc/interrupts in the current working situation
> with the PVR-150 card in the lower slot and the DVB card in the upper
> slot.
>   0:         64   IO-APIC-edge      timer
>   1:       1130   IO-APIC-edge      i8042
>   7:          0   IO-APIC-edge      parport0
>   8:          3   IO-APIC-edge      rtc
>   9:          0   IO-APIC-fasteoi   acpi
>  12:          4   IO-APIC-edge      i8042
>  14:      18035   IO-APIC-edge      ide0
>  17:          0   IO-APIC-fasteoi   ohci_hcd:usb1
>  18:         26   IO-APIC-fasteoi   ohci_hcd:usb2
>  19:          0   IO-APIC-fasteoi   ohci_hcd:usb3
>  20:          2   IO-APIC-fasteoi   ehci_hcd:usb4
>  21:      12329   IO-APIC-fasteoi   eth1
>  22:      16399   IO-APIC-fasteoi   SiS SI7012
>  23:      15020   IO-APIC-fasteoi   saa7134[0], saa7134[0], ivtv0
> NMI:          0 
> LOC:     757294 
> ERR:          0
> MIS:          0
> 
> As you can see the two cards are sharing the IRQ properly.

IRQ sharing is possible. But on the PCI Bus, the usually four
IRQ lines are wired in a "Round Robin" scheme to avoid IRQ sharing.

Additionally, each slot gets a unique ID by wiring the IDSELect
of the slot connector to an AD bus line on the motherboard as
mentioned above.

So, each slot with a ID get it's fixed IRQ routed (along with the
REQn/GNTn lines). If the IDs and the IRQ lines don't fit together,
you might run into problems like you mentioned.
I think it's possible to tell the kernel the right ID-IRQ routing
associations manually. But I think it's not easy to get the BIOS fixed.
So, I suggest to figure out how the BIOS (the kernel get that
info from the BIOS, AFAIK (is that correct?)) wants to see its IRQ
on the IDs and rewire the riser card that they all fit together.

Well... that's what I did some time ago. For me it is more easy
to fit the hardware once to the default kernel settings instead of
patching every kernel on my embedded platform.

You can find some more details here:
http://www.formfactors.org/developer%5Cspecs%5CATX_Spec_V1_0.pdf
And there is the official PCI Spec at http://www.pcisig.com
however you have to be a member of the PCI SIG.

Good luck,
-- 
Clemens Koller
_______________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Str. 45/1
81379 Muenchen
Germany

http://www.anagramm-technology.com
Phone: +49-89-741518-50
Fax: +49-89-741518-19
