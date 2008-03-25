Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbYCYVJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbYCYVJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 17:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYCYVJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 17:09:07 -0400
Received: from www17.your-server.de ([213.133.104.17]:47471 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbYCYVJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 17:09:06 -0400
Message-ID: <47E969E1.6080608@m3y3r.de>
Date: Tue, 25 Mar 2008 22:08:49 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080310)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
References: <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E807EE.2030902@m3y3r.de> <47E8217C.9080400@s5r6.in-berlin.de> <20080325073117.GA8469@elte.hu> <20080325165007.GA7775@elte.hu> <47E94557.4030001@m3y3r.de> <20080325201125.GD15330@elte.hu> <20080325202954.GA22007@elte.hu>
In-Reply-To: <20080325202954.GA22007@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar schrieb:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>>> Modprobing either ohci1394 or firewire_ohci seems to lock up the 
>>> system.
>>>       
>> that's weird. If you do the modprobe from a VGA console and do a 
>> 'dmesg -n 8', do you get any ioremap printk shortly before the hard 
>> lockup?
>>     
>
> basically, old ioremap did this:
>
> [  162.485605] ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level, low) -> IRQ 19
> [  162.485695] ioremap: 00000000(00000800) => f8978000
>
> the theory (fact?) was that the zero physical address there (the 
> '00000000') was some 4GB+ address truncated down to 32-bits.
>   
See file attachments of this bug:

http://bugzilla.kernel.org/show_bug.cgi?id=10080

and compare lspci -vv from 2.6.25 and 2.6.24:

2.6.25:
0c:03.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 61) (prog-if 10 
[OHCI])
    Subsystem: Agere Systems FW323
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B+ DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 248 (3000ns min, 6000ns max), Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 19
    Region 0: [virtual] Memory at 100000000 (32-bit, non-prefetchable) 
[size=4K]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Kernel driver in use: ohci1394
    Kernel modules: firewire-ohci, ohci1394

2.6.24:
0c:03.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 61) (prog-if 10 
[OHCI])
    Subsystem: Agere Systems FW323
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B+ DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 248 (3000ns min, 6000ns max), Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 19
    Region 0: Memory at 8c000000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME+
    Kernel driver in use: ohci1394
    Kernel modules: firewire-ohci, ohci1394
> OTOH, before this system worked for you before, i start to suspect that 
> ioremap is a red herring here and that it's the code that gets to that 
> physical address (which is ioremap-ed) is at fault here.
>
> the hard hang might be your southbridge totally dumbfounded by the host 
> OS attempting to do an MMIO access to an above-4GB address?
>   
Maybe. Is it important that i have an core duo? (32 bit only - not a the 
core *2* duo)?
> so the question is - what physical address did that ioremap do in 2.6.24 
> (which presumly had a working ohci1394, right?), and why did it change 
> to something else in -git?
Is the lspci output sufficient for you?

