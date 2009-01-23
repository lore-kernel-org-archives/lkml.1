Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbZAWTFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbZAWTFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 14:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZAWTFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 14:05:24 -0500
Received: from marvin.heresymail.org ([87.106.62.5]:36744 "EHLO
	marvin.heresymail.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZAWTFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 14:05:23 -0500
Message-ID: <497A14ED.2010707@walrond.org>
Date: Fri, 23 Jan 2009 19:05:17 +0000
From: Andrew Walrond <andrew@walrond.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: serial8250 madness
References: <497A0164.90409@walrond.org> <20090123180033.3e67f542@lxorguk.ukuu.org.uk>
In-Reply-To: <20090123180033.3e67f542@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> ttyS0 works fine. Can get grub output, kernel boot and console via ttyS0 
>> as I wanted.
>> ttyS1 doesn't work at all. It's detected, enabled in the bios etc etc 
>> but just doesn't work at all.
>>     
>
> You don't give much information but if it seems to be non working then I
> would look hard at the IRQ/IO reported
>
>   
On Machine A (ttyS0 works fine. ttyS1 dead as dodo):
 $ dmesg | grep ttyS

Command line: console=tty0 console=ttyS0,57600
Kernel command line: console=tty0 console=ttyS0,57600
console [ttyS0] enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A

$ sudo ./setserial -a /dev/ttyS1

/dev/ttyS1, Line 1, UART: 16550A, Port: 0x02f8, IRQ: 3
    Baud_base: 115200, close_delay: 50, divisor: 0
    closing_wait: 3000
    Flags: spd_normal skip_test

user@orac ~ $ cat /proc/interrupts
           CPU0       CPU1      
  0:         35         20   IO-APIC-edge      timer
  1:          0          2   IO-APIC-edge      i8042
  3:          0          1   IO-APIC-edge   
  4:          0        179   IO-APIC-edge      serial
[snip]

>> Machine B
>>
>> ttyS0 and ttyS1 will both receive, but neither will send. Go figure. 
>> Tested using a null modem cable, setserial and cu against the known good 
>> machine above.
>>     
>
> Boggle - what flow control wiring have you done ?
>
>   
:) Same null modem cable as used in all other tests. Setup with 
setserial then connect either ends with the likes of
    cu -s 9600 -l /dev/ttyS?
and this machine can receive and display characters typed on the other 
end, but nothing gets sent the other way.
Have tried with hardware/software flow on/off at both ends. Clueless...

I havent tried yet but will see if grub will push anything out (ie 
independent of the kernel) which will rule out a hardware problem and 
implicate the kernel. But its a relatively new m/b with onboard serial 
so I doubt it's broken.
Will report back.
>
> The big outstanding bug I know about is the incompatibility between the
> PnP 8250 drivers and serial console - that may be your machine C case.
> That one is rather hard to fix so on the long rather than short term hit
> list.
>   
Sounds likely. Any way I can know for sure?
The kernel log looks a bit different on this machine:

Serial: 8250/16550 driver4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
serial 00:09: activated
00:09: ttyS2 at I/O 0x3e8 (irq = 3) is a 16550A
serial 00:0a: activated
00:0a: ttyS3 at I/O 0x2e8 (irq = 5) is a 16550A

compared with Machine A:

Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A

Thanks for your input

Andrew Walrond
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   

