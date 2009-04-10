Return-Path: <linux-kernel-owner+w=401wt.eu-S1764973AbZDJU3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764973AbZDJU3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 16:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756939AbZDJU3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 16:29:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:44975 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499AbZDJU33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 16:29:29 -0400
Message-ID: <49DFABCC.3070001@kernel.org>
Date: Fri, 10 Apr 2009 13:27:56 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: bugzilla-daemon@bugzilla.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [Bug 11103] Can't use framebuffer or vesa Xorg with two memory
 modules
References: <bug-11103-13546@http.bugzilla.kernel.org/> <200904101913.n3AJDhMm018684@demeter.kernel.org>
In-Reply-To: <200904101913.n3AJDhMm018684@demeter.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bugzilla-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=11103
> 
> 
> 
> 
> 
> --- Comment #16 from Yannick <yannick.roehlly@free.fr>  2009-04-10 19:13:43 ---
> Created an attachment (id=20928)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=20928)
> Boot log (from dmesg) with "debug pci=earlydump" passed to kernel 2.6.29.1
> 
root cause:
when 4G installed.
BIOS put ACPI etc need the hole
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
[    0.000000]  BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e3000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bffa0000 (usable)
[    0.000000]  BIOS-e820: 00000000bffa0000 - 00000000bffae000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bffae000 - 00000000bfff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
so resource will be reserved for 0xbffa0000 - 0xbfff0000 for ACPI
0x100000 -  0xbffa0000 for RAM...

then BIOS set 
[    0.240007] pci 0000:00:01.0: bridge 64bit mmio pref: [0xbdf00000-0xddefffff]
[    0.237102] pci 0000:01:00.0: reg 10 32bit mmio: [0xc0000000-0xcfffffff]
that is conflict with reserved res.
so it can not be reserved Kernel.

then Kernel try to get range from 0x140000000 ( above the RAM, 5G and above 4g)
and set let the bridge to use it, and your ATI cards to use it.

but the problem is that your ATI only support 32bit ...

solution:
1. get updated BIOS?
2. kernel side:
a. reserved return one could use range ( shrinked range ), and set it back to pci bridge?
b. or add pci=earlyset like to hack the pci conf in early stage.

also in kernel side, we should not assign 64bit range to pci device that only take 32bit pref, it mess up the pci conf.

01:00.0 VGA compatible controller: ATI Technologies Inc Mobility Radeon HD 3400 Series (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Device 19d3
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at 140000000 (32-bit, prefetchable) [size=256M]
	Region 1: I/O ports at 9000 [size=256]
	Region 2: Memory at fddf0000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at fddc0000 [disabled] [size=128K]
..
00: 02 10 c4 95 07 01 10 00 00 00 00 03 08 00 00 00
10: 08 00 00 40 01 90 00 00 00 00 df fd 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 d3 19
30: 00 00 dc fd 50 00 00 00 00 00 00 00 0a 01 00 00
40: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 d3 19


YH
