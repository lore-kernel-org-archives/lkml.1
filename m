Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYAAP7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYAAP7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbYAAP7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:59:11 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:64266 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbYAAP7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:59:09 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18aAfCC0eQrQpAsHSeOjSRU
Message-ID: <477A62F4.9010504@reed.com>
Date: Tue, 01 Jan 2008 10:57:40 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
References: <4762C551.5070003@zytor.com>	<20071214210652.GB28793@elf.ucw.cz>	<4763001A.1070102@zytor.com>	<20071214232955.545ab809@the-village.bc.nu>	<20071215080831.404cdb32@tux.DEF.witbe.net>	<47638C8C.2090604@gmail.com>	<476438B4.2020600@zytor.com>	<476462BE.3030701@gmail.com>	<4764687D.6080609@zytor.com>	<476524DB.7020806@gmail.com>	<20071216152250.GA21245@elte.hu>	<4765D43E.1010800@gmail.com>	<4765D95C.4010404@zytor.com>	<4765DCB0.8030901@gmail.com>	<4765EE7F.80002@zytor.com>	<47667366.7010405@gmail.com>	<4766AE88.4080904@zytor.com>	<4766D175.7040807@reed.com> <20071217212509.5edaa372@the-village.bc.nu>
In-Reply-To: <20071217212509.5edaa372@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> responds to reads differently than "unused" ports.  In particular, an 
>> inb takes 1/2 the elapsed time compared to a read to "known" unused port 
>> 0xed - 792 tsc ticks for port 80 compared to about 1450 tsc ticks for 
>> port 0xed and other unused ports (tsc at 800 MHz).
>>     
>
> Well at least we know where the port is now - thats too fast for an LPC
> bus device, so it must be an SMI trap.
>
> Only easy way to find out is to use the debugging event counters and see
> how many instruction cycles are issued as part of the 0x80 port. If its
> suprisingly high then you've got a firmware bug and can go spank HP.
>
>   
Alan, thank you for the pointers.  I have been doing variations on this 
testing theme for a while - I get intrigued by a good debugging 
challenge, and after all it's my machine...

Two relevant new data points, and then some more suggestions:

1. It appears to be a real port.  SMI traps are not happening in the 
normal outb to 80.  Hundreds of them execute perfectly with the expected 
instruction counts.  If I can trace the particular event that creates 
the hard freeze (getting really creative, here) and stop before the 
freeze disables the entire computer, I will.  That may be an SMI, or 
perhaps any other kind of interrupt or exception.  Maybe someone knows 
how to safely trace through an impending SMI while doing printk's or 
something?

2. It appears to be the standard POST diagnostic port.  On a whim, I 
disassembled my DSDT code, and studied it more closely.   It turns out 
that there are a bunch of "Store(..., DBUG)" instructions scattered 
throughout, and when you look at what DBUG is defined as, it is defined 
as an IO Port at IO address DBGP, which is a 1-byte value = 0x80.  So 
the ACPI BIOS thinks it has something to do with debugging.   There's a 
little strangeness here, however, because the value sent to the port 
occasionally has something to do with arguments to the ACPI operations 
relating to sleep and wakeup ...  could just be that those arguments are 
distinctive.

In thinking about this, I recognize a couple of things.  ACPI is telling 
us something when it declares a reference to port 80 in its code.  It's 
not telling us the function of this port on this machine, but it is 
telling us that it is being used by the BIOS.   This could be a reason 
to put out a printk warning message...   'warning: port 80 is used by 
ACPI BIOS - if you are experiencing problems, you might try an alternate 
means of iodelay.'

Second, it seems likely that there are one of two possible reasons that 
the port 80 writes cause hang/freezes:

1. buffer overflow in such a device.

2. there is some "meaning" to certain byte values being written (the 
_PTS and _WAK use of arguments that come from callers to store into port 
80 makes me suspicious.)   That might mean that the freeze happens only 
when certain values are written, or when they are written closely in 
time to some other action - being used to communicate something to the 
SMM code).   If there is some race in when Linux's port 80 writes happen 
that happen to change the meaning of a request to the hardware or to 
SMM, then we could be rarely stepping on



