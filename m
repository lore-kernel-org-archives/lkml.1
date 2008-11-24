Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbYKXK4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbYKXK4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 05:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYKXK4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 05:56:43 -0500
Received: from bu3sch.de ([62.75.166.246]:48794 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbYKXK4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 05:56:42 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Yuval Hager <yuval@avramzon.net>
Subject: Re: BCM4312 Fails when xdm is started
Date: Mon, 24 Nov 2008 11:55:45 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de
References: <200811151801.02369.yuval@avramzon.net> <4929C68E.6080401@lwfinger.net> <200811241049.45734.yuval@avramzon.net>
In-Reply-To: <200811241049.45734.yuval@avramzon.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811241155.47079.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 November 2008 09:49:38 Yuval Hager wrote:
> On Sunday 23 November 2008, Larry Finger wrote:
> > From a config file posted earlier, the OP is using SLAB. Is there any point
> > in trying SLUB?
> 
> Another try, not sure what it means:
> 
> * Added CONFIG_SLUB and CONFIG_SLUB_DEBUG
> 
> * boot parameters: root=/dev/sda3 debug memory_corruption_check=1 devres.log=1 debug_objects debugpat 
> acpi.debug_layer=0x00410002 acpi.debug_level=0xffffffff acpi=off apic=debug nolapic irqpoll pci=noacpi slub_debug=FZPU
> 
> * cat /proc/interrupts is
>            CPU0       
>   0:      16658    XT-PIC-XT        timer
>   1:        289    XT-PIC-XT        i8042
>   2:          0    XT-PIC-XT        cascade
>   3:         60    XT-PIC-XT        uhci_hcd:usb2, ehci_hcd:usb4
>   5:       9163    XT-PIC-XT        sata_via, HDA Intel
>   7:          0    XT-PIC-XT        uhci_hcd:usb3
>   8:          2    XT-PIC-XT        rtc
>  10:       1712    XT-PIC-XT        b43
>  11:        131    XT-PIC-XT        uhci_hcd:usb1
>  12:        706    XT-PIC-XT        i8042
>  14:          0    XT-PIC-XT        ide0
>  15:          0    XT-PIC-XT        ide1
> NMI:          0   Non-maskable interrupts
> LOC:          0   Local timer interrupts
> RES:          0   Rescheduling interrupts
> CAL:          0   Function call interrupts
> TLB:          0   TLB shootdowns
> TRM:          0   Thermal event interrupts
> SPU:          0   Spurious interrupts
> ERR:          0
> MIS:          0
> 
> * lspci -d 14e4:4312 -x
> 02:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g (rev 02)
> 00: e4 14 12 43 06 01 10 00 02 00 80 02 08 00 00 00
> 10: 04 c0 ff fd 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 71 13
> 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 01 00 00
> 
> * xset dpms force standby
> * wake up
> * dmesg is virtually the same as before, complaining about nobody handling irq 10 and disabling it.

Actually, b43 _does_ use IRQ10 now.
I guess the card dies such a horrible death, that it also asserts the IRQ line forever.

> * /proc/interrupts now is
>   0:      80987    XT-PIC-XT        timer
>   1:       1027    XT-PIC-XT        i8042
>   2:          0    XT-PIC-XT        cascade
>   3:         60    XT-PIC-XT        uhci_hcd:usb2, ehci_hcd:usb4
>   5:      10400    XT-PIC-XT        sata_via, HDA Intel
>   7:          0    XT-PIC-XT        uhci_hcd:usb3
>   8:          2    XT-PIC-XT        rtc
>  10:     200000    XT-PIC-XT        b43
>  11:        131    XT-PIC-XT        uhci_hcd:usb1
>  12:       3059    XT-PIC-XT        i8042
>  14:          0    XT-PIC-XT        ide0
>  15:          0    XT-PIC-XT        ide1
> NMI:          0   Non-maskable interrupts
> LOC:          0   Local timer interrupts
> RES:          0   Rescheduling interrupts
> CAL:          0   Function call interrupts
> TLB:          0   TLB shootdowns
> TRM:          0   Thermal event interrupts
> SPU:          0   Spurious interrupts
> ERR:          0
> MIS:          0
> 
> * Now check this out - the output of lspci -d 14e4:4312 -x
> 02:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g (rev ff)
> 00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 
> (I double checked this)
> 
> huh?

Hah, interesting. I think your hardware may be faulty, in fact.
To me it really seems like the mainboard has power failures on the PCI bus.

This is a laptop, so you can't pull random hardware? Can you run some
hardware burn-in tests like mprime (http://mersenne.org/freesoft/) or memtest?
If that doesn't help, can you try with another operating system?

-- 
Greetings Michael.
