Return-Path: <linux-kernel-owner+w=401wt.eu-S933454AbXCEOZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454AbXCEOZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 09:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933471AbXCEOZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 09:25:26 -0500
Received: from rtr.ca ([64.26.128.89]:1642 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933454AbXCEOZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 09:25:25 -0500
Message-ID: <45EC2851.7020905@rtr.ca>
Date: Mon, 05 Mar 2007 09:25:21 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: sdhci-devel@list.drzeus.cx, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sdhci regression in 2.6.21-rc2
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015031.GF3441@stusta.de> <45EB9DC6.8010403@rtr.ca> <45EB9E72.6040107@rtr.ca> <45EBAC73.7010600@drzeus.cx>
In-Reply-To: <45EBAC73.7010600@drzeus.cx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Mark Lord wrote:
>> Another regression, for Pierre Ossman this time.
>>
>> My syslog gets spammed like this (below) on suspend/resume (to RAM) cycles.
>> Worked fine, without all of the noise, in all previous kernels up to
>> 2.6.20+.
>>
> 
> This looks like a PCI configuration issue.

To me, it looks like a buggy driver "resume" sequence.
The low-level SDHCI driver is trying to use the device
before the PM/PCI stuff has restored the pre-suspend state.

> Can you bisect which commit caused the issue?

Nope.  I don't have time to run around that (huge) treadmill, thanks.

>And what's the PCI address of the device?

0000:03:01.2 0805: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 17)

So, from the syslog, we see that the machine suspends (to RAM):

>kernel: Stopping tasks ... done.
>kernel: Suspending console(s)
>kernel: pl2303 1-1.3:1.0: no suspend for driver pl2303?
>kernel: ACPI: PCI interrupt for device 0000:03:01.2 disabled
>kernel: ACPI: PCI interrupt for device 0000:03:00.0 disabled
>kernel: ACPI: PCI interrupt for device 0000:00:1f.2 disabled
>kernel: ACPI: PCI interrupt for device 0000:00:1e.2 disabled
>kernel: ACPI: PCI interrupt for device 0000:00:1d.7 disabled
>kernel: ACPI: PCI interrupt for device 0000:00:1d.3 disabled
>kernel: ACPI: PCI interrupt for device 0000:00:1d.2 disabled
>kernel: ACPI: PCI interrupt for device 0000:00:1d.1 disabled
>kernel: ACPI: PCI interrupt for device 0000:00:1d.0 disabled
>kernel: Intel machine check architecture supported.
>kernel: Intel machine check reporting enabled on CPU#0.

A few seconds later, I manually wake-up the machine.
It resumes (from RAM), and the PM code begins restoring PCI config
space for various device:

>kernel: Back to C!
>kernel: PM: Writing back config space on device 0000:00:01.0 at offset 7 (was 2000d0d0, writing d0d0)
>kernel: PM: Writing back config space on device 0000:00:01.0 at offset 3 (was 10000, writing 10010)
>kernel: PCI: Setting latency timer of device 0000:00:01.0 to 64
>kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
>kernel: PCI: Setting latency timer of device 0000:00:1d.0 to 64
>kernel: usb usb2: root hub lost power or was reset
>kernel: PCI: Enabling device 0000:00:1d.1 (0000 -> 0001)
>kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 18
>kernel: PCI: Setting latency timer of device 0000:00:1d.1 to 64
>kernel: PM: Writing back config space on device 0000:00:1d.1 at offset f (was 200, writing 20a)
>kernel: PM: Writing back config space on device 0000:00:1d.1 at offset 8 (was 1, writing bf61)
>kernel: usb usb3: root hub lost power or was reset
>kernel: PCI: Enabling device 0000:00:1d.2 (0000 -> 0001)
>kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 19
>kernel: PCI: Setting latency timer of device 0000:00:1d.2 to 64
>kernel: PM: Writing back config space on device 0000:00:1d.2 at offset f (was 300, writing 309)
>kernel: PM: Writing back config space on device 0000:00:1d.2 at offset 8 (was 1, writing bf41)
>kernel: usb usb4: root hub lost power or was reset
>kernel: PCI: Enabling device 0000:00:1d.3 (0000 -> 0001)
>kernel: ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 17
>kernel: PCI: Setting latency timer of device 0000:00:1d.3 to 64
>kernel: PM: Writing back config space on device 0000:00:1d.3 at offset f (was 400, writing 407)
>kernel: PM: Writing back config space on device 0000:00:1d.3 at offset 8 (was 1, writing bf21)
>kernel: usb usb5: root hub lost power or was reset

But.. in the middle of all of this, we now see the SHDCI code
trying to talk to its as-yet-not-restored device, and being rather
noisy about it all:

>kernel: sdhci: ============== REGISTER DUMP ==============
>kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
>kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
>kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
>kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
>kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
>kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
>kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
>kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
>kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
>kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
>kernel: sdhci: ===========================================
>kernel: mmc0: Card is consuming too much power!
>kernel: mmc0: Unexpected interrupt 0x00800000.
>kernel: sdhci: ============== REGISTER DUMP ==============
>kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
>kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
>kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
>kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
>kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
>kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
>kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
>kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
>kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
>kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
>kernel: sdhci: ===========================================

Meanwhile, the PM code is also continuing to bring up devices:

>kernel: ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 16 (level, low) -> IRQ 16
>kernel: PCI: Setting latency timer of device 0000:00:1d.7 to 64
>kernel: usb usb1: root hub lost power or was reset
>kernel: ehci_hcd 0000:00:1d.7: debug port 1
>kernel: PCI: cache line size of 32 is not supported by device 0000:00:1d.7
>kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 9 (was 10001, writing 8bf18801)
>kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 8 (was 0, writing dfc0dfc0)
>kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 7 (was 2280e0f0, writing 22802020)
>kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 6 (was 20030300, writing 20070300)
>kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100005, writing 100107)
>kernel: PCI: Setting latency timer of device 0000:00:1e.0 to 64
>kernel: PM: Writing back config space on device 0000:00:1e.2 at offset f (was 100, writing 10b)
>kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 7 (was 0, writing dffffd00)
>kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 6 (was 0, writing dffffe00)
>kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 5 (was 1, writing ec41)
>kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 4 (was 1, writing ed01)
>kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 1 (was 2900000, writing 2900003)
>kernel: ACPI: PCI Interrupt 0000:00:1e.2[A] -> GSI 16 (level, low) -> IRQ 16
>kernel: PCI: Setting latency timer of device 0000:00:1e.2 to 64

And the SDHCI continues to spam the syslog:

>kernel: mmc0: Controller never released inhibit bit(s).
>kernel: sdhci: ============== REGISTER DUMP ==============
>kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
>kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
>kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
>kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
>kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
>kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
>kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
>kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
>kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
>kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
>kernel: sdhci: ===========================================
>kernel: mmc0: Reset 0x2 never completed.
>kernel: sdhci: ============== REGISTER DUMP ==============
>kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
>kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
>kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
>kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
>kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
>kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
>kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
>kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
>kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
>kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
>kernel: sdhci: ===========================================
>kernel: mmc0: Reset 0x4 never completed.
>kernel: sdhci: ============== REGISTER DUMP ==============
>kernel: sdhci: Sys addr: 0xffffffff | Version:  0x0000ffff
>kernel: sdhci: Blk size: 0x0000ffff | Blk cnt:  0x0000ffff
>kernel: sdhci: Argument: 0xffffffff | Trn mode: 0x0000ffff
>kernel: sdhci: Present:  0xffffffff | Host ctl: 0x000000ff
>kernel: sdhci: Power:    0x000000ff | Blk gap:  0x000000ff
>kernel: sdhci: Wake-up:  0x000000ff | Clock:    0x0000ffff
>kernel: sdhci: Timeout:  0x000000ff | Int stat: 0xffffffff
>kernel: sdhci: Int enab: 0xffffffff | Sig enab: 0xffffffff
>kernel: sdhci: AC12 err: 0x0000ffff | Slot int: 0x0000ffff
>kernel: sdhci: Caps:     0xffffffff | Max curr: 0xffffffff
>kernel: sdhci: ===========================================
...
<snip>

And eventually we see more PM recovery messages:

>kernel: PM: Writing back config space on device 0000:00:1f.0 at offset 1 (was 2000007, writing 2000107)
>kernel: PM: Writing back config space on device 0000:00:1f.2 at offset f (was 200, writing 20a)
>kernel: PM: Writing back config space on device 0000:00:1f.2 at offset 9 (was d0000, writing 0)
>kernel: ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 18
>kernel: PCI: Setting latency timer of device 0000:00:1f.2 to 64
>kernel: PM: Writing back config space on device 0000:00:1f.3 at offset f (was 200, writing 20a)
>kernel: PM: Writing back config space on device 0000:00:1f.3 at offset 1 (was 2800001, writing 2800101)
>kernel: PM: Writing back config space on device 0000:01:00.0 at offset f (was 1ff, writing 10b)
>kernel: PM: Writing back config space on device 0000:01:00.0 at offset c (was 0, writing dfe00000)
>kernel: PM: Writing back config space on device 0000:01:00.0 at offset 3 (was 0, writing 10)
>kernel: ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
>kernel: PM: Writing back config space on device 0000:03:00.0 at offset f (was 100, writing 109)
>kernel: PM: Writing back config space on device 0000:03:00.0 at offset 4 (was 0, writing dfcfe000)
>kernel: PM: Writing back config space on device 0000:03:00.0 at offset 3 (was 0, writing 4000)
>kernel: PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 100000, writing 100106)
>kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, low) -> IRQ 19

And here, finally, we see the PM code restoring state for the SDHCI controller:

>kernel: PM: Writing back config space on device 0000:03:01.0 at offset f (was 7800100, writing 58001ff)
>kernel: PM: Writing back config space on device 0000:03:01.0 at offset e (was 0, writing 24fc)
>kernel: PM: Writing back config space on device 0000:03:01.0 at offset d (was 0, writing 2400)
>kernel: PM: Writing back config space on device 0000:03:01.0 at offset c (was 0, writing 20fc)
>kernel: PM: Writing back config space on device 0000:03:01.0 at offset b (was 0, writing 2000)
>kernel: PM: Writing back config space on device 0000:03:01.0 at offset a (was 0, writing 8ffff000)
>kernel: PM: Writing back config space on device 0000:03:01.0 at offset 9 (was 0, writing 8c000000)
>kernel: PM: Writing back config space on device 0000:03:01.0 at offset 8 (was 0, writing 8bfff000)
>kernel: PM: Writing back config space on device 0000:03:01.0 at offset 7 (was 0, writing 88000000)
>kernel: PM: Writing back config space on device 0000:03:01.0 at offset 6 (was 0, writing b0070403)
>kernel: PM: Writing back config space on device 0000:03:01.0 at offset 4 (was 0, writing dfc00000)
>kernel: PM: Writing back config space on device 0000:03:01.0 at offset 3 (was 820000, writing 82a800)
>kernel: PM: Writing back config space on device 0000:03:01.1 at offset 4 (was 0, writing dfcfc800)
>kernel: PM: Writing back config space on device 0000:03:01.1 at offset 3 (was 800000, writing 804000)
>kernel: PM: Writing back config space on device 0000:03:01.1 at offset 1 (was 2100000, writing 2100106)
>kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[dfcfc800-dfcfcfff]  Max Packet=[2048]  IR/IT contexts=[4/4]
>kernel: PM: Writing back config space on device 0000:03:01.2 at offset 4 (was 0, writing dfcfc700)
>kernel: PM: Writing back config space on device 0000:03:01.2 at offset 3 (was 800000, writing 804000)
>kernel: PM: Writing back config space on device 0000:03:01.2 at offset 1 (was 2100000, writing 2100106)
>kernel: ACPI: PCI Interrupt 0000:03:01.2[C] -> GSI 17 (level, low) -> IRQ 18
>kernel: PM: Writing back config space on device 0000:03:03.0 at offset f (was 18030100, writing 1803010a)
>kernel: PM: Writing back config space on device 0000:03:03.0 at offset 4 (was 0, writing dfcfd000)
>kernel: PM: Writing back config space on device 0000:03:03.0 at offset 3 (was 0, writing 4010)
>kernel: PM: Writing back config space on device 0000:03:03.0 at offset 1 (was 2900000, writing 2900112)

So, somewhere, the SDHCI drivers need to be told to stay dormant until their
device has been recovered, just like most other device drivers do.

Cheers

Mark
