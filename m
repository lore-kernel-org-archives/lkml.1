Return-Path: <linux-kernel-owner+w=401wt.eu-S1759048AbYCEQTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbYCEQTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbYCEQTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:19:23 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:38726 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbYCEQTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:19:22 -0500
Message-ID: <47CEC816.6000808@keyaccess.nl>
Date: Wed, 05 Mar 2008 17:19:34 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
CC: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>
Subject: Re: ehci-hcd affects hda speed
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr>
In-Reply-To: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-03-08 23:27, Lev A. Melnikovsky wrote:

> I have recently installed a VT6212L-based PCI USB controller into my old 
> rock-stable P3B-F computer

Uh oh...

> just to discover that, even being idle, it significantly slows down main
> PATA hard drive. I have found an earlier thread with similar (?) problem
> (archived at http://marc.info/?t=111749614000002&r=1&w=2 ) but it
> provides no solution. Can this behaviour be explained? Can it be fixed?

Yes, that one was my same problem. It was diagnosed to the VT6212L doing 
decidedly weird things with toggling the Async bit and tying up the bus. 
People seemed reluctant to either confirm or deny my suspicion that this was 
VIA trying to shine on benchmarks while screwing you over so what exactly 
that amounts to I don't know. My own solution has consisted of replacing the 
controller with a somewhat slower but decent NEC controller and selling of 
the VIA crapware to some unsuspecting poor sod...

> There's one thing that makes me optimistic: USB traffic _speeds_up_ hda. 
> That is hdparm gives ~20% improvement in buffered reads if a USB flash 
> is inserted and another xterm simultaneously runs
> # dd if=/dev/sda of=/dev/null bs=1024

Sort of interesting. I doubt something can be done about the idle thing 
though but David is the person to talk to. Leaving in the rest:

> Here's what I see:
> 
> ------------------------------------------------------------------------------ 
> 
> # hdparm -t -T /dev/hda
>     /dev/hda:
>      Timing cached reads:   312 MB in  2.01 seconds = 155.60 MB/sec
>      Timing buffered disk reads:   88 MB in  3.06 seconds =  28.77 MB/sec
> # modprobe ehci-hcd
> # hdparm -t -T /dev/hda
>     /dev/hda:
>      Timing cached reads:   274 MB in  2.01 seconds = 136.58 MB/sec
>      Timing buffered disk reads:   44 MB in  3.10 seconds =  14.20 MB/sec
> # rmmod ehci-hcd
> # hdparm -t -T /dev/hda
>     /dev/hda:
>      Timing cached reads:   286 MB in  2.01 seconds = 142.48 MB/sec
>      Timing buffered disk reads:   90 MB in  3.06 seconds =  29.44 MB/sec
> ------------------------------------------------------------------------------ 
> 
> 
> And here's what I have (kernel 2.6.24.3):
> 
> ------------------------------------------------------------------------------ 
> 
> #lspci -v
> 
> 00:09.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
> Controller (rev 62) (prog-if 00 [UHCI])
>         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
>         Flags: medium devsel, IRQ 5
>         I/O ports at d000 [size=32]
>         Capabilities: [80] Power Management version 2
> 
> 00:09.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 
> Controller (rev 62) (prog-if 00 [UHCI])
>         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
>         Flags: medium devsel, IRQ 9
>         I/O ports at b800 [size=32]
>         Capabilities: [80] Power Management version 2
> 
> 00:09.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 65) (prog-if 
> 20 [EHCI])
>         Subsystem: VIA Technologies, Inc. USB 2.0
>         Flags: bus master, medium devsel, latency 32, IRQ 11
>         Memory at d3800000 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [80] Power Management version 2
> 
> # cat /proc/interrupts
>            CPU0
>   0:  100814528    XT-PIC-XT        timer
>   1:       4057    XT-PIC-XT        i8042
>   2:          0    XT-PIC-XT        cascade
>   3:       1013    XT-PIC-XT
>   4:          2    XT-PIC-XT
>   5:    7165568    XT-PIC-XT        bttv0, FM801, uhci_hcd:usb2, 
> uhci_hcd:usb3
>   8:   25956003    XT-PIC-XT
>   9:     661413    XT-PIC-XT        eth1, uhci_hcd:usb4
>  10:          4    XT-PIC-XT
>  11:   13526145    XT-PIC-XT        eth0, ehci_hcd:usb1
>  12:    1068179    XT-PIC-XT        i8042
>  14:     710123    XT-PIC-XT        ide0
>  15:       4365    XT-PIC-XT        ide1
> NMI:          0   Non-maskable interrupts
> TRM:          0   Thermal event interrupts
> SPU:          0   Spurious interrupts
> ERR:          0
> ------------------------------------------------------------------------------ 
> 
> 
> Please let me know if I missed something important.

Rene.
