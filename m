Return-Path: <linux-kernel-owner+w=401wt.eu-S2992896AbXDTLT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992896AbXDTLT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992942AbXDTLT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:19:28 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:64601 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992896AbXDTLT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:19:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=caE3B13QD8EbAZwXn9cxcEkZNCtCdXjKmKeJ//olIaIdIygPNx53GZUl3uYqjutd9DYOLBbG+te3x8H7uhEOn3qzCFluxf2rOPnkwDjeJaxiGEaiyRoqEuKcQlb6G/MqoEEy6Mc6TAjWJ55t11V/5n8ApYkoX4JdqcIbJ+jNZDA=
Message-ID: <6278d2220704200419p6f035769p654caa23e9a724e9@mail.gmail.com>
Date: Fri, 20 Apr 2007 12:19:24 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: sky2 X86-64 PCI synchronization problems
Cc: "Linux Networking" <linux-net@vger.kernel.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

>From your description of the problem, it sounds just like writes to
PCI memory-mapped address space are being delayed and/or reordered in
the processor when in x86-64 mode.

I'd suggest to add wmb()/rmb() or (overkill) mb() calls after MMIO
stores to flush writes immediately and force give the intended
ordering; often drivers will issue a dummy read, which flushes writes
(but is far less efficient than a 'wmb', due to the PCI bus
read-latency). Also, if a PCI MMIO page is marked write-combining, the
processor will delay writes and burst them in up to 64-byte blocks,
which can be very good for getting maximal performance, but needs
careful considerations.

On the ia64 platform, the maximum time MMIO writes can be waiting in
the processor's write buffers, is something of the order of 2uS (!),
and MMIO store semantics are out-of-order, so read/write barriers are
critical.

Thanks,
  Dan

Stephen Hemminger wrote:
> I am testing a Gigabyte 965P-S3 motherboard with onboard Marvell
> 88E8056 Ethernet controller (sky2 driver). The CPU is a Core-2 Duo.
> Strange errors occur under moderate load with X86-64 kernel.
> Surprisingly, with i386 kernel the controller runs fine without errors.
>
> These look bus/PCI related because:
> * there is also 88E8052 on an PCI-E X1 card, it has no problem.
>   Similar chip but different bus interface internally (no ram buffer).
>
> * the errors look like the controller didn't access memory correctly:
> 	1. receive status arrives but data buffer not updated
> 	2. transmit descriptor errors, implying that controller read
>            a non-initialized memory.
>   the command blocks look okay, it's like the device didn't read them.
>
> It looks like a PCI bus synchronization issue. Any ideas for driver
> workarounds?
>
> This is the working controller:
>
> 03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8052 PCI-E ASF Gigabit Ethernet Controller (rev 22)
> 	Subsystem: Marvell Technology Group Ltd. Marvell RDK-8052
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0, Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 217
> 	Region 0: Memory at f8000000 (64-bit, non-prefetchable) [size=16K]
> 	Region 2: I/O ports at 7000 [size=256]
> 	[virtual] Expansion ROM at 80000000 [disabled] [size=128K]
> 	Capabilities: [48] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
> 	Capabilities: [50] Vital Product Data
> 	Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
> 		Address: 00000000fee0300c  Data: 417a
> 	Capabilities: [e0] Express Legacy Endpoint IRQ 0
> 		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
> 		Device: Latency L0s unlimited, L1 unlimited
> 		Device: AtnBtn- AtnInd- PwrInd-
> 		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
> 		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> 		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
> 		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
> 		Link: Latency L0s <256ns, L1 unlimited
> 		Link: ASPM Disabled RCB 128 bytes CommClk- ExtSynch-
> 		Link: Speed 2.5Gb/s, Width x1
> 	Capabilities: [100] Advanced Error Reporting
> 00: ab 11 60 43 07 04 10 00 22 00 00 02 08 00 00 00
> 10: 04 00 00 f8 00 00 00 00 01 70 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 ab 11 21 52
> 30: 00 00 00 00 48 00 00 00 00 00 00 00 0b 01 00 00
>
>
> This is the non-working controller:
>
> 05:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev 12)
> 	Subsystem: Giga-byte Technology Unknown device e000
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0, Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 216
> 	Region 0: Memory at fa000000 (64-bit, non-prefetchable) [size=16K]
> 	Region 2: I/O ports at a000 [size=256]
> 	[virtual] Expansion ROM at 80100000 [disabled] [size=128K]
> 	Capabilities: [48] Power Management version 3
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
> 	Capabilities: [50] Vital Product Data
> 	Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
> 		Address: 00000000fee0300c  Data: 4182
> 	Capabilities: [e0] Express Legacy Endpoint IRQ 0
> 		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
> 		Device: Latency L0s unlimited, L1 unlimited
> 		Device: AtnBtn- AtnInd- PwrInd-
> 		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
> 		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> 		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
> 		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
> 		Link: Latency L0s <256ns, L1 unlimited
> 		Link: ASPM Disabled RCB 128 bytes CommClk- ExtSynch-
> 		Link: Speed 2.5Gb/s, Width x1
> 	Capabilities: [100] Advanced Error Reporting
> 00: ab 11 64 43 07 04 10 00 12 00 00 02 08 00 00 00
> 10: 04 00 00 fa 00 00 00 00 01 a0 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 58 14 00 e0
> 30: 00 00 00 00 48 00 00 00 00 00 00 00 0e 01 00 00
-- 
Daniel J Blueman
