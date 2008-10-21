Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbYJUP4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbYJUP4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 11:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYJUP4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 11:56:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbYJUP4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 11:56:10 -0400
Message-ID: <48FDFB97.1050208@suse.de>
Date: Tue, 21 Oct 2008 17:56:07 +0200
From: Stefan Assmann <sassmann@suse.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: "M. Vefa Bicakci" <bicave@superonline.com>
Cc: Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Olaf Dabrunz <odabrunz@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Regression in 2.6.27: "irq 18: nobody cared" on Toshiba Satellite
 A100
References: <48FB3ED5.60904@superonline.com> <1224431722.26279.4.camel@sven.thebigcorporation.com> <48FB6321.7030501@superonline.com> <48FC38AE.3030007@suse.de> <48FD0152.60907@superonline.com>
In-Reply-To: <48FD0152.60907@superonline.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

M. Vefa Bicakci wrote:
> Stefan Assmann wrote:
>> M. Vefa Bicakci wrote:
>>> Sven-Thorsten Dietrich wrote:
>>>> On Sun, 2008-10-19 at 10:06 -0400, M. Vefa Bicakci wrote:
>>>>> Hello,
>>>>>
>>>>> As you might guess from the subject line, since I started to use 2.6.27-rcX
>>>>> series, I began to get "irq 18: nobody cared" messages in dmesg. Currently I am
>>>>> using 2.6.27.2 with Sidux on this laptop, which is a Toshiba Satellite A100.
>>>>> I have reproduced this problem with vanilla and sidux's kernels.
>>>>>
>>>> Can you provide the contents of /proc/interrupts? 
>> Could you provide the following:
>> - output of lspci -nn
>> - dmesg output with kernel commandline option apic=debug
> 
> The dmesg output with "apic=debug" is appended to this e-mail. Please note that
> since the regression needs quite a few hours with the computer doing nothing to
> show itself, this dmesg output does not include the "nobody cared" message. If
> you need the dmesg output to contain the "nobody cared" message, then please let
> me know.

No that is not necessary for now. I was curious how many IO-APICs are
present in your system and there's only one. So it's not a routing
problem with multiple IO-APICs. I just wanted to make sure of that.

To get some more information I have some more things to suggest:
1. try the noapic option
2. try the irqpoll option
3. try the latest 2.6.26 kernel to verify this has been introduced with
2.6.27

I know this takes some time to reproduce so try the following patch,
it might trigger the problem more frequently.

--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -200,7 +200,7 @@ void note_interrupt(unsigned int irq, st
 		return;

 	desc->irq_count = 0;
-	if (unlikely(desc->irqs_unhandled > 99900)) {
+	if (unlikely(desc->irqs_unhandled > 999)) {
 		/*
 		 * The interrupt is stuck
 		 */

> 
> Here's the output of "lspci -nn":
> 
> === 8< ===
> 00:00.0 Host bridge [0600]: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub [8086:27a0] (rev 03)
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller [8086:27a2] (rev 03)
> 00:02.1 Display controller [0380]: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller [8086:27a6] (rev 03)
> 00:1b.0 Audio device [0403]: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller [8086:27d8] (rev 02)
> 00:1c.0 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 [8086:27d0] (rev 02)
> 00:1c.1 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 [8086:27d2] (rev 02)
> 00:1c.2 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 [8086:27d4] (rev 02)
> 00:1d.0 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 [8086:27c8] (rev 02)
> 00:1d.1 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 [8086:27c9] (rev 02)
> 00:1d.2 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 [8086:27ca] (rev 02)
> 00:1d.3 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 [8086:27cb] (rev 02)
> 00:1d.7 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller [8086:27cc] (rev 02)
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev e2)
> 00:1f.0 ISA bridge [0601]: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge [8086:27b9] (rev 02)
> 00:1f.2 IDE interface [0101]: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller [8086:27c4] (rev 02)
> 00:1f.3 SMBus [0c05]: Intel Corporation 82801G (ICH7 Family) SMBus Controller [8086:27da] (rev 02)
> 05:00.0 Network controller [0280]: Intel Corporation PRO/Wireless 3945ABG [Golan] Network Connection [8086:4222] (rev 02)
> 07:06.0 CardBus bridge [0607]: Texas Instruments PCIxx12 Cardbus Controller [104c:8039]
> 07:06.1 FireWire (IEEE 1394) [0c00]: Texas Instruments PCIxx12 OHCI Compliant IEEE 1394 Host Controller [104c:803a]
> 07:06.2 Mass storage controller [0180]: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD) [104c:803b]
> 07:06.3 SD Host controller [0805]: Texas Instruments PCIxx12 SDA Standard Compliant SD Host Controller [104c:803c]
> 07:08.0 Ethernet controller [0200]: Intel Corporation PRO/100 VE Network Connection [8086:1092] (rev 02)
> === >8 ===
> 
>  
>>> My computer is currently in the "nobody cared" state. Here are the current
>>> contents of /proc/interrupts:
>>>
>>> --- 8< ---
>>>            CPU0       CPU1       
>>>   0:   45249492      60399   IO-APIC-edge      timer
>>>   1:      25451          0   IO-APIC-edge      i8042
>>>   8:          1          0   IO-APIC-edge      rtc0
>>>   9:      36514          0   IO-APIC-fasteoi   acpi
>>>  12:    1147983       2103   IO-APIC-edge      i8042
>>>  14:     170245          0   IO-APIC-edge      ata_piix
>>>  15:     558085        819   IO-APIC-edge      ata_piix
>>>  16:        508          0   IO-APIC-fasteoi   uhci_hcd:usb5, i915@pci:0000:00:02.0
>>>  17:       1353          0   IO-APIC-fasteoi   firewire_ohci
>>>  18:     300158          1   IO-APIC-fasteoi   uhci_hcd:usb4, tifm_7xx1, yenta
>>>  19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
>>>  20:      26606          2   IO-APIC-fasteoi   eth0
>>>  22:    3206279          1   IO-APIC-fasteoi   HDA Intel
>>>  23:          3          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb2
>>> 220:    2105545          0   PCI-MSI-edge      iwl3945
>>> NMI:          0          0   Non-maskable interrupts
>>> LOC:    5971997   27874747   Local timer interrupts
>>> RES:     938710    1791498   Rescheduling interrupts
>>> CAL:     138135     180813   function call interrupts
>>> TLB:      48455      64413   TLB shootdowns
>>> TRM:          0          0   Thermal event interrupts
>>> SPU:          0          0   Spurious interrupts
>>> ERR:          0
>>> MIS:          0
>>> --- >8 ---
>> Nothing unusual at first glance. How long did the system run?
> 
> The computer had been booted at 15:24 on October 18th. I got the "nobody cared"
> message at 05:30 (am) on October 19th. The contents of "/proc/interrupts" that
> are quoted above were generated at about 12:40 (afternoon) on October 19th.
> 
> There is one more thing I would like add. Last night, before going to sleep,
> I wrote a simple bash script which, every two seconds, recorded the contents
> of "/proc/interrupts" to a directory into a "ramfs" mount-point. (I chose "ramfs"
> because I thought that "ramfs" would not interfere with the "swapper" process
> which is shown as the reason in all of the "nobody cared" messsages.)
> 
> Interestingly, when I woke up today, the dmesg contents did *not* contain any
> "nobody cared" messages. So I hit Ctrl-C and ended the execution of the script.
> I then left the computer alone and went on to do other things. And guess what,
> about four-five hours after I ended the script, I got the "nobody cared" message.
> So it looks like the computer really needs to be doing "nothing" in order to get
> this "nobody cared" message.

I'm not sure if it's related to doing "nothing", it's more likely to be
a coincidence. Try the patch I mentioned earlier and see if that gets
you to the problem sooner.

> 
> Unfortunately, all of this happened without the "apic=debug" command line option.
> Tonight, I am going to leave the computer on with the "apic=debug" command line
> option and without anything running.
> 
> Finally, I would like to say that I appreciate your help.

You're welcome!

> 
> Regards,
> 
> M. Vefa Bicakci
> 
> Note: dmesg output with "apic=debug" follows:
[snip dmesg]

  Stefan

-- 
Stefan Assmann          | SUSE LINUX Products GmbH
Software Engineer       | Maxfeldstr. 5, D-90409 Nuernberg
Mail : sassmann@suse.de | GF: Markus Rex, HRB 16746 (AG Nuernberg)
