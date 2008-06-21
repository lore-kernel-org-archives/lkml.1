Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYFUKAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYFUKAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 06:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbYFUKAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 06:00:24 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:21970 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbYFUKAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 06:00:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eB2py9qkLjrUAgYQ8DphoBPYuPXZhT4wA86tQHPMAqDyUkTeExEM9YL8mLzctn+kmS
         UAUUhaHrf18RJNBI2sRU/A26qnhna0kHxmvFm5CLq11zb52iSE2LsJ9c8p2yh7243CXw
         nv2VHeVTiRPrjyt6gnieOvO26e8Y+cp6jzUmg=
Message-ID: <485CD12C.9080404@gmail.com>
Date: Sat, 21 Jun 2008 07:00:12 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: Bisecting tip/auto-x86-next?
References: <485AFC9B.7090502@gmail.com> <20080620101722.GD17692@elte.hu>	 <d1af83620806200437p7c3817d8i381a99f92f47fd4f@mail.gmail.com>	 <20080620153626.GE17373@elte.hu> <485C4484.3080706@gmail.com> <86802c440806201714p271b7b3fx68183c5f48208bee@mail.gmail.com>
In-Reply-To: <86802c440806201714p271b7b3fx68183c5f48208bee@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Fri, Jun 20, 2008 at 5:00 PM, Kevin Winchester
> <kjwinchester@gmail.com> wrote:
>> Ingo Molnar wrote:
>>> * Kevin Winchester <kjwinchester@gmail.com> wrote:
>>>
>>>>> hm, could you send me the config that triggered this?
>>>> I will do so tonight when I am home again.  It is a UP AMD64 box with a
>>>> VIA chipset, if that helps.
>>>>
>>>>> btw., you can probably ignore this one safely. Also please tell me at
>>>>> which commit ID you were at when you triggered this warning.
>>>> Good to know - I will get the commit ID tonight as well, although
>>>> wouldn't following the same bisection sequence that I did give you the same
>>>> bisection point?  I guess that would assume that linus/master and
>>>> auto-x86-next haven't changed much since last night, which might not be
>>>> correct.
>>> yeah, you'd probably not hit that warning with the x86/gart bisection
>>> sequence. (Assuming the bug is introduced in that branch - so you should
>>> first check whether pure x86/gart kernel triggers the problem too.)
>>>
>>> If you still have the commit ID around then please send it - if you dont,
>>> no problem, it's no big issue. I wanted to check how wide the bisection
>>> window is where the warning triggers.
>>>
>> I'm sorry - I accidentally checkout out x86/gart to test it before grabbing
>> the commit ID.
>>
>> I went ahead with the bisection and found:
>>
>>
>>
>> 8c9fd91a0dc503f085169d44f4360be025f75224 is first bad commit
>> commit 8c9fd91a0dc503f085169d44f4360be025f75224
>> Author: Yinghai Lu <yhlu.kernel@gmail.com>
>> Date:   Sun Apr 13 18:42:31 2008 -0700
>>
>>    x86: checking aperture size order
>>
>>    some systems are using 32M for gart and agp when memory is less than 4G.
>>    Kernel will reject and try to allcate another 64M that is not needed,
>>    and we will waste 64M of perfectly good RAM.
>>
>>    this patch adds a workaround by checking aper_base/order between NB and
>>    agp bridge. If they are the same, and memory size is less than 4G, it
>>    will allow it.
>>
>>    Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>    Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>
>> :040000 040000 848d6e4045a14d01fc0a794d4350d8a84f3ceff6
>> 4a10a52b41309060cd5dc1bf0c322f6d43b2477b M      arch
>> :040000 040000 aa1cee87b1f5b1b30ed03ce6164ad7f404fef2a3
>> f9ce0aaa1f7d4fdc7bdc5a43285495db53a6f531 M      drivers
>>
>>
>> as the first bad commit.  I do not have time to look at the patch right now,
>> but in case anyone else does, I figured I would post it.
>>
> 
> please send out whole boot logs with "debug" in command line.
> 

"debug" in the command line doesn't seem to have any effect on the 
printout (is there some config option I need to use with it?), but here 
it is anyway:

[    0.000000] Linux version 2.6.26-rc2-00003-g8c9fd91 (kevin@alekhine) 
(gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #53 PREEMPT Sat Jun 21 
06:53:46 ADT 2008
[    0.000000] Command line: root=/dev/sda1 ro hpet=force debug
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fef0000 (usable)
[    0.000000]  BIOS-e820: 000000003fef0000 - 000000003fef3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fef3000 - 000000003ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] update e820 for GART
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003fef0000 (usable)
[    0.000000]  modified: 000000003fef0000 - 000000003fef3000 (ACPI NVS)
[    0.000000]  modified: 000000003fef3000 - 000000003ff00000 (ACPI data)
[    0.000000]  modified: 00000000e0000000 - 00000000e8000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 261872) 1 entries of 
256 used
[    0.000000] max_pfn_mapped = 1048576
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] init_memory_mapping
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F77D0, 0014 (r0 VIAK8T)
[    0.000000] ACPI: RSDT 3FEF3040, 0034 (r1 VIAK8T AWRDACPI 42302E31 
AWRD        0)
[    0.000000] ACPI: FACP 3FEF30C0, 0074 (r1 VIAK8T AWRDACPI 42302E31 
AWRD        0)
[    0.000000] ACPI: DSDT 3FEF3180, 4F8A (r1 VIAK8T AWRDACPI     1000 
MSFT  100000E)
[    0.000000] ACPI: FACS 3FEF0000, 0040
[    0.000000] ACPI: BOOT 3FEF8180, 0028 (r1 VIAK8T AWRDACPI 42302E31 
AWRD        0)
[    0.000000] ACPI: SSDT 3FEF82C0, 00B5 (r1 PTLTD  POWERNOW        1 
LTP        1)
[    0.000000] ACPI: APIC 3FEF8200, 0068 (r1 VIAK8T AWRDACPI 42302E31 
AWRD        0)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 261872) 1 entries of 
256 used
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-b0c907] TEXT DATA BSS
[    0.000000]   early res: 3 [9f800-fffff] BIOS reserved
[    0.000000]   early res: 4 [8000-afff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe20000dfffff] PMD -> 
[ffff810001200000-ffff810001ffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   261872
[    0.000000] On node 0 totalpages: 261775
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2420 pages reserved
[    0.000000]   DMA zone: 1523 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3524 pages used for memmap
[    0.000000]   DMA32 zone: 254252 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] Looks like a VIA chipset. Disabling IOMMU. Override with 
iommu=allowed
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 
3ff00000:a0100000)
[4294014.506571] Built 1 zonelists in Zone order, mobility grouping on. 
  Total pages: 255775
[4294014.506571] Kernel command line: root=/dev/sda1 ro hpet=force debug
[4294014.506571] Initializing CPU#0
[4294014.506571] Preemptible RCU implementation.
[4294014.506571] PID hash table entries: 4096 (order: 12, 32768 bytes)
[4294014.506571] TSC calibrated against PM_TIMER
[4294014.506571] time.c: Detected 1804.093 MHz processor.
[4294014.506571] Console: colour VGA+ 80x25
[4294014.506571] console [tty0] enabled
[4294014.506571] Lock dependency validator: Copyright (c) 2006 Red Hat, 
Inc., Ingo Molnar
[4294014.506571] ... MAX_LOCKDEP_SUBCLASSES:    8
[4294014.506571] ... MAX_LOCK_DEPTH:          48
[4294014.506571] ... MAX_LOCKDEP_KEYS:        2048
[4294014.506571] ... CLASSHASH_SIZE:           1024
[4294014.506571] ... MAX_LOCKDEP_ENTRIES:     8192
[4294014.506571] ... MAX_LOCKDEP_CHAINS:      16384
[4294014.506571] ... CHAINHASH_SIZE:          8192
[4294014.506571]  memory used by lock dependency info: 1648 kB
[4294014.506571]  per task-struct memory footprint: 2688 bytes
[4294014.506571] ------------------------
[4294014.506571] | Locking API testsuite:
[4294014.506571] 
----------------------------------------------------------------------------
[4294014.506571]                                  | spin |wlock |rlock 
|mutex | wsem | rsem |
[4294014.506571] 
--------------------------------------------------------------------------
[4294014.506571]                      A-A deadlock:  ok  |  ok  |  ok  | 
  ok  |  ok  |  ok  |
[4294014.506571]                  A-B-B-A deadlock:  ok  |  ok  |  ok  | 
  ok  |  ok  |  ok  |
[4294014.506571]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  | 
  ok  |  ok  |  ok  |
[4294014.506571]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  | 
  ok  |  ok  |  ok  |
[4294014.506571]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  | 
  ok  |  ok  |  ok  |
[4294014.506571]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  | 
  ok  |  ok  |  ok  |
[4294014.506571]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  | 
  ok  |  ok  |  ok  |
[4294014.506571]                     double unlock:  ok  |  ok  |  ok  | 
  ok  |  ok  |  ok  |
[4294014.506571]                   initialize held:  ok  |  ok  |  ok  | 
  ok  |  ok  |  ok  |
[4294014.506571]                  bad unlock order:  ok  |  ok  |  ok  | 
  ok  |  ok  |  ok  |
[4294014.506571] 
--------------------------------------------------------------------------
[4294014.506571]               recursive read-lock:             |  ok  | 
             |  ok  |
[4294014.506571]            recursive read-lock #2:             |  ok  | 
             |  ok  |
[4294014.506571]             mixed read-write-lock:             |  ok  | 
             |  ok  |
[4294014.506571]             mixed write-read-lock:             |  ok  | 
             |  ok  |
[4294014.506571] 
--------------------------------------------------------------------------
[4294014.506571]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[4294014.506571]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[4294014.506571]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[4294014.506571]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[4294014.506571]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[4294014.506571]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[4294014.506571]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[4294014.506571]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[4294014.506571]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[4294014.506571]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[4294014.506571]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[4294014.506571]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[4294014.506571]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[4294014.506571]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[4294014.506571]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[4294014.506571]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[4294014.506571]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[4294014.506571]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[4294014.506571]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[4294014.506571]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[4294014.506571]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[4294014.506571]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[4294014.506571]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[4294014.506571]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[4294014.506571]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[4294014.506571]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[4294014.506571]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[4294014.506571]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[4294014.506571]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[4294014.506571]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[4294014.506571]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[4294014.506571]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[4294014.506571]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[4294014.506571]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[4294014.506571]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[4294014.506571]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[4294014.506571]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[4294014.506571]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[4294014.506571]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[4294014.506571]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[4294014.506571]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[4294014.506571]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[4294014.506571]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[4294014.506571]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[4294014.506571]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[4294014.506571]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[4294014.506571]       hard-irq read-recursion/123:  ok  |
[4294014.506571]       soft-irq read-recursion/123:  ok  |
[4294014.506571]       hard-irq read-recursion/132:  ok  |
[4294014.506571]       soft-irq read-recursion/132:  ok  |
[4294014.506571]       hard-irq read-recursion/213:  ok  |
[4294014.506571]       soft-irq read-recursion/213:  ok  |
[4294014.506571]       hard-irq read-recursion/231:  ok  |
[4294014.506571]       soft-irq read-recursion/231:  ok  |
[4294014.506571]       hard-irq read-recursion/312:  ok  |
[4294014.506571]       soft-irq read-recursion/312:  ok  |
[4294014.506571]       hard-irq read-recursion/321:  ok  |
[4294014.506571]       soft-irq read-recursion/321:  ok  |
[4294014.506571] -------------------------------------------------------
[4294014.506571] Good, all 218 testcases passed! |
[4294014.506571] ---------------------------------
[4294014.506571] Dentry cache hash table entries: 131072 (order: 8, 
1048576 bytes)
[4294014.506571] Inode-cache hash table entries: 65536 (order: 7, 524288 
bytes)
[4294014.506571] Memory: 1021212k/1047488k available (2715k kernel code, 
25316k reserved, 1315k data, 204k init)
[4294014.506571] CPA: page pool initialized 1 of 1 pages preallocated
[4294014.506571] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=1, Nodes=1
[4294014.566594] Calibrating delay using timer specific routine.. 
3611.98 BogoMIPS (lpj=1805993)
[4294014.566707] Mount-cache hash table entries: 256
[4294014.567359] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)
[4294014.567403] CPU: L2 Cache: 512K (64 bytes/line)
[4294014.567445] CPU: AMD Athlon(tm) 64 Processor 3000+ stepping 00
[4294014.567512] ACPI: Core revision 20080321
[4294014.587546] Using local APIC timer interrupts.
[4294014.589558] APIC timer calibration result 12528424
[4294014.589558] Detected 12.528 MHz APIC timer.
[4294014.589558] net_namespace: 456 bytes
[4294014.589558] NET: Registered protocol family 16
[4294014.590073] No dock devices found.
[4294014.590309] node 0 link 0: io port [1000, fffff]
[4294014.590338] TOM: 0000000040000000 aka 1024M
[4294014.590365] node 0 link 0: mmio [a0000, bffff]
[4294014.590401] node 0 link 0: mmio [40000000, ff70ffff]
[4294014.590438] bus: [00,ff] on node 0 link 0
[4294014.590464] bus: 00 index 0 io port: [0, ffff]
[4294014.590491] bus: 00 index 1 mmio: [a0000, bffff]
[4294014.590517] bus: 00 index 2 mmio: [40000000, fcffffffff]
[4294014.590558] ACPI: bus type pci registered
[4294014.590603] PCI: Using configuration type 1 for base access
[4294014.595977] ACPI: EC: Look up EC in DSDT
[4294014.607934] ACPI: Interpreter enabled
[4294014.607966] ACPI: (supports S0 S3 S5)
[4294014.608061] ACPI: Using IOAPIC for interrupt routing
[4294014.619360] ACPI: PCI Root Bridge [PCI0] (0000:00)
[4294014.620741] pci 0000:00:11.0: Force enabled HPET at 0xfed00000
[4294014.621197] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[4294014.705272] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 11 12) *5
[4294014.705659] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11 12)
[4294014.706025] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12)
[4294014.706355] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12) 
*0, disabled.
[4294014.706716] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12) 
*0, disabled.
[4294014.707099] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12) 
*0, disabled.
[4294014.707470] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 6 7 *10 11 12)
[4294014.707819] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 6 7 *10 11 12)
[4294014.708197] ACPI: PCI Interrupt Link [ALKA] (IRQs *20)
[4294014.708506] ACPI: PCI Interrupt Link [ALKB] (IRQs *21)
[4294014.708825] ACPI: PCI Interrupt Link [ALKC] (IRQs *22)
[4294014.709186] ACPI: PCI Interrupt Link [ALKD] (IRQs *23), disabled.
[4294014.709585] Linux Plug and Play Support v0.97 (c) Adam Belay
[4294014.709683] pnp: PnP ACPI init
[4294014.709733] ACPI: bus type pnp registered
[4294014.715829] pnp: PnP ACPI: found 10 devices
[4294014.715864] ACPI: ACPI bus type pnp unregistered
[4294014.716251] SCSI subsystem initialized
[4294014.716342] libata version 3.00 loaded.
[4294014.716606] usbcore: registered new interface driver usbfs
[4294014.716706] usbcore: registered new interface driver hub
[4294014.716845] usbcore: registered new device driver usb
[4294014.717558] PCI: Using ACPI for IRQ routing
[4294014.717597] PCI: Cannot allocate resource region 0 of device 
0000:00:00.0
[4294014.727717] agpgart: Detected AGP bridge 0
[4294014.727750] agpgart: Aperture conflicts with PCI mapping.
[4294014.727785] agpgart: Aperture from AGP @ e0000000 size 128 MB
[4294014.727816] agpgart: Aperture conflicts with PCI mapping.
[4294014.727846] agpgart: No usable aperture found.
[4294014.727874] agpgart: Consider rebooting with iommu=memaper=2 to get 
a good aperture.
[4294014.728175] hpet clockevent registered
[4294014.728205] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[4294014.728270] hpet0: 3 32-bit timers, 14318180 Hz
[4294014.729438] ACPI: RTC can wake from S4
[4294014.739570] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[4294014.739602] system 00:00: iomem range 0xf0000-0xf7fff could not be 
reserved
[4294014.739633] system 00:00: iomem range 0xf8000-0xfbfff could not be 
reserved
[4294014.739664] system 00:00: iomem range 0xfc000-0xfffff could not be 
reserved
[4294014.739695] system 00:00: iomem range 0x3ff00000-0x3fffffff has 
been reserved
[4294014.739736] system 00:00: iomem range 0x3fef0000-0x3fefffff could 
not be reserved
[4294014.739778] system 00:00: iomem range 0xffff0000-0xffffffff could 
not be reserved
[4294014.739819] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[4294014.739850] system 00:00: iomem range 0x100000-0x3feeffff could not 
be reserved
[4294014.739891] system 00:00: iomem range 0xfec00000-0xfec00fff could 
not be reserved
[4294014.739933] system 00:00: iomem range 0xfee00000-0xfee00fff could 
not be reserved
[4294014.739975] system 00:00: iomem range 0xfff80000-0xfffeffff could 
not be reserved
[4294014.740027] system 00:02: ioport range 0x4000-0x407f has been reserved
[4294014.740058] system 00:02: ioport range 0x5000-0x500f has been reserved
[4294014.740098] system 00:03: ioport range 0xb78-0xb7b has been reserved
[4294014.740128] system 00:03: ioport range 0xf78-0xf7b has been reserved
[4294014.740158] system 00:03: ioport range 0xa78-0xa7b has been reserved
[4294014.740188] system 00:03: ioport range 0xe78-0xe7b has been reserved
[4294014.740218] system 00:03: ioport range 0xbbc-0xbbf has been reserved
[4294014.740248] system 00:03: ioport range 0xfbc-0xfbf has been reserved
[4294014.740278] system 00:03: ioport range 0x4d0-0x4d1 has been reserved
[4294014.740308] system 00:03: ioport range 0x290-0x297 has been reserved
[4294014.741461] PCI: Bridge: 0000:00:01.0
[4294014.741489]   IO window: c000-cfff
[4294014.741518]   MEM window: 0xf8000000-0xf80fffff
[4294014.741554]   PREFETCH window: 0x00000000e8000000-0x00000000f7ffffff
[4294014.741602] PCI: Setting latency timer of device 0000:00:01.0 to 64
[4294014.741648] NET: Registered protocol family 2
[4294014.775651] IP route cache hash table entries: 32768 (order: 6, 
262144 bytes)
[4294014.776315] TCP established hash table entries: 131072 (order: 9, 
2097152 bytes)
[4294014.777732] TCP bind hash table entries: 65536 (order: 9, 3670016 
bytes)
[4294014.783659] TCP: Hash tables configured (established 131072 bind 65536)
[4294014.783721] TCP reno registered
[4294014.795637] NET: Registered protocol family 1
[4294014.795940] Simple Boot Flag at 0x37 set to 0x1
[4294014.804867] Block layer SCSI generic (bsg) driver version 0.4 
loaded (major 253)
[4294014.804923] io scheduler noop registered
[4294014.805073] io scheduler cfq registered (default)
[4294014.805122] PCI: VIA PCI bridge detected.Disabling DAC.
[4294014.805265] pci 0000:01:00.0: Boot video device
[4294014.805580] input: Power Button (FF) as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[4294014.805650] ACPI: Power Button (FF) [PWRF]
[4294014.805840] input: Power Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[4294014.805884] ACPI: Power Button (CM) [PWRB]
[4294014.806522] ACPI: ACPI0007:00 is registered as cooling_device0
[4294014.835953] Linux agpgart interface v0.103
[4294014.836063] [drm] Initialized drm 1.1.0 20060810
[4294014.837008] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[4294014.837225] [drm] Initialized radeon 1.28.0 20060524 on minor 0
[4294014.838309] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 
seconds, margin is 60 seconds).
[4294014.838351] Hangcheck: Using get_cycles().
[4294014.838566] via-rhine: Broken BIOS detected, avoid_D3 enabled.
[4294014.838747] VIA Networking Velocity Family Gigabit Ethernet Adapter 
Driver Ver. 1.14
[4294014.838789] Copyright (c) 2002, 2003 VIA Networking Technologies, Inc.
[4294014.838818] Copyright (c) 2004 Red Hat Inc.
[4294014.838858] ACPI: PCI Interrupt 0000:00:0e.0[A] -> GSI 22 (level, 
low) -> IRQ 22
[4294014.840052] eth0: VIA Networking Velocity Family Gigabit Ethernet 
Adapter
[4294014.840084] eth0: Ethernet Address: 00:50:8D:D1:28:BB
[4294014.850648] PPP generic driver version 2.4.2
[4294014.850942] PPP MPPE Compression module registered
[4294014.851367] Driver 'sd' needs updating - please use bus_type methods
[4294014.851464] Driver 'sr' needs updating - please use bus_type methods
[4294014.851782] sata_via 0000:00:0f.0: version 2.3
[4294014.852160] ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
[4294014.852198] ACPI: PCI Interrupt 0000:00:0f.0[B] -> Link [ALKA] -> 
GSI 20 (level, low) -> IRQ 20
[4294014.852334] sata_via 0000:00:0f.0: routed to hard irq line 11
[4294014.852463] scsi0 : sata_via
[4294014.852829] scsi1 : sata_via
[4294014.853039] ata1: SATA max UDMA/133 cmd 0xe900 ctl 0xea00 bmdma 
0xe200 irq 20
[4294014.853080] ata2: SATA max UDMA/133 cmd 0xe000 ctl 0xe100 bmdma 
0xe208 irq 20
[4294015.053537] ata1: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
[4294015.238139] Switched to high resolution mode on CPU 0
[4294015.275517] ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
[4294015.278478] pata_via 0000:00:0f.1: version 0.3.3
[4294015.278525] ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [ALKA] -> 
GSI 20 (level, low) -> IRQ 20
[4294015.278575] scsi2 : pata_via
[4294015.280804] scsi3 : pata_via
[4294015.284094] ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 
0xe400 irq 14
[4294015.284125] ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 
0xe408 irq 15
[4294015.437925] ata3.00: ATAPI: COMPAQ  DVD-ROM DRD-8120B, 1.10, max 
UDMA/33
[4294015.437971] ata3.01: ATAPI: HL-DT-ST GCE-8525B, 1.03, max UDMA/33
[4294015.443795] ata3.00: configured for UDMA/33
[4294015.449794] ata3.01: configured for UDMA/33
[4294015.615040] ata4.00: ATA-6: WDC WD800JB-00JJA0, 05.01C05, max UDMA/100
[4294015.615071] ata4.00: 156301488 sectors, multi 16: LBA
[4294015.617901] ata4.00: configured for UDMA/100
[4294015.618035] isa bounce pool size: 16 pages
[4294015.618589] scsi 2:0:0:0: CD-ROM            COMPAQ   DVD-ROM 
DRD8120B 1.10 PQ: 0 ANSI: 5
[4294015.621794] sr0: scsi3-mmc drive: 0x/40x cd/rw xa/form2 cdda tray
[4294015.621824] Uniform CD-ROM driver Revision: 3.20
[4294015.622294] sr 2:0:0:0: Attached scsi CD-ROM sr0
[4294015.622599] sr 2:0:0:0: Attached scsi generic sg0 type 5
[4294015.623278] scsi 2:0:1:0: CD-ROM            HL-DT-ST CD-RW 
GCE-8525B  1.03 PQ: 0 ANSI: 5
[4294015.626460] sr1: scsi3-mmc drive: 40x/52x writer cd/rw xa/form2 
cdda tray
[4294015.626750] sr 2:0:1:0: Attached scsi CD-ROM sr1
[4294015.626962] sr 2:0:1:0: Attached scsi generic sg1 type 5
[4294015.627224] scsi 3:0:0:0: Direct-Access     ATA      WDC 
WD800JB-00JJ 05.0 PQ: 0 ANSI: 5
[4294015.627726] sd 3:0:0:0: [sda] 156301488 512-byte hardware sectors 
(80026 MB)
[4294015.627794] sd 3:0:0:0: [sda] Write Protect is off
[4294015.627822] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[4294015.627902] sd 3:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[4294015.628320] sd 3:0:0:0: [sda] 156301488 512-byte hardware sectors 
(80026 MB)
[4294015.628391] sd 3:0:0:0: [sda] Write Protect is off
[4294015.628421] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[4294015.628504] sd 3:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[4294015.628553]  sda: sda1 sda2 < sda5 sda6 >
[4294015.663111] sd 3:0:0:0: [sda] Attached SCSI disk
[4294015.663325] sd 3:0:0:0: Attached scsi generic sg2 type 0
[4294015.663741] ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 23 (level, 
low) -> IRQ 23
[4294015.722583] firewire_ohci: Added fw-ohci device 0000:00:07.0, OHCI 
version 1.0
[4294015.722878] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, 
low) -> IRQ 21
[4294015.722937] ehci_hcd 0000:00:10.4: EHCI Host Controller
[4294015.723544] ehci_hcd 0000:00:10.4: new USB bus registered, assigned 
bus number 1
[4294015.723662] ehci_hcd 0000:00:10.4: irq 21, io mem 0xf8121000
[4294015.729587] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, 
driver 10 Dec 2004
[4294015.730135] usb usb1: configuration #1 chosen from 1 choice
[4294015.730303] hub 1-0:1.0: USB hub found
[4294015.730366] hub 1-0:1.0: 8 ports detected
[4294015.830956] USB Universal Host Controller Interface driver v3.0
[4294015.831061] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, 
low) -> IRQ 21
[4294015.831122] uhci_hcd 0000:00:10.0: UHCI Host Controller
[4294015.831253] uhci_hcd 0000:00:10.0: new USB bus registered, assigned 
bus number 2
[4294015.831317] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000e500
[4294015.831664] usb usb2: configuration #1 chosen from 1 choice
[4294015.831788] hub 2-0:1.0: USB hub found
[4294015.831859] hub 2-0:1.0: 2 ports detected
[4294015.932797] ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, 
low) -> IRQ 21
[4294015.932853] uhci_hcd 0000:00:10.1: UHCI Host Controller
[4294015.932979] uhci_hcd 0000:00:10.1: new USB bus registered, assigned 
bus number 3
[4294015.933040] uhci_hcd 0000:00:10.1: irq 21, io base 0x0000e600
[4294015.933392] usb usb3: configuration #1 chosen from 1 choice
[4294015.933513] hub 3-0:1.0: USB hub found
[4294015.933550] hub 3-0:1.0: 2 ports detected
[4294015.985646] hub 1-0:1.0: unable to enumerate USB device on port 1
[4294016.034756] ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, 
low) -> IRQ 21
[4294016.034813] uhci_hcd 0000:00:10.2: UHCI Host Controller
[4294016.034940] uhci_hcd 0000:00:10.2: new USB bus registered, assigned 
bus number 4
[4294016.035001] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e700
[4294016.035336] usb usb4: configuration #1 chosen from 1 choice
[4294016.035459] hub 4-0:1.0: USB hub found
[4294016.035496] hub 4-0:1.0: 2 ports detected
[4294016.135753] ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, 
low) -> IRQ 21
[4294016.135809] uhci_hcd 0000:00:10.3: UHCI Host Controller
[4294016.135935] uhci_hcd 0000:00:10.3: new USB bus registered, assigned 
bus number 5
[4294016.135998] uhci_hcd 0000:00:10.3: irq 21, io base 0x0000e800
[4294016.136336] usb usb5: configuration #1 chosen from 1 choice
[4294016.136455] hub 5-0:1.0: USB hub found
[4294016.136492] hub 5-0:1.0: 2 ports detected
[4294016.140603] hub 1-0:1.0: unable to enumerate USB device on port 2
[4294016.222985] firewire_core: created device fw0: GUID 
00508d0000d028bb, S400
[4294016.346588] usb 2-1: new low speed USB device using uhci_hcd and 
address 2
[4294016.474582] usb 2-1: configuration #1 chosen from 1 choice
[4294016.715588] usb 2-2: new low speed USB device using uhci_hcd and 
address 3
[4294016.847573] usb 2-2: configuration #1 chosen from 1 choice
[4294016.889752] usbcore: registered new interface driver usblp
[4294016.889783] Initializing USB Mass Storage driver...
[4294017.097706] usbcore: registered new interface driver usb-storage
[4294017.097737] USB Mass Storage support registered.
[4294017.098077] PNP: No PS/2 controller found. Probing ports directly.
[4294017.100530] serio: i8042 KBD port at 0x60,0x64 irq 1
[4294017.100575] serio: i8042 AUX port at 0x60,0x64 irq 12
[4294017.100964] mice: PS/2 mouse device common for all mice
[4294017.122020] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[4294017.122081] rtc0: alarms up to one year, y3k
[4294017.122177] i2c /dev entries driver
[4294017.146603] w83627hf: Found W83627HF chip at 0x290
[4294017.286574] w83627hf w83627hf.656: Enabling temp2, readings might 
not make sense
[4294017.286574] w83627hf w83627hf.656: Enabling temp3, readings might 
not make sense
[4294017.512660] abituguru: testing bank1 sensor 0
[4294017.534773] abituguru:   alarm not raised during volt sensor test
[4294017.588582] abituguru:   found temp sensor
[4294017.590583] abituguru: testing bank1 sensor 1
[4294017.612024] abituguru:   alarm not raised during volt sensor test
[4294017.664582] abituguru:   found temp sensor
[4294017.666583] abituguru: testing bank1 sensor 3
[4294017.690582] abituguru:   found volt sensor
[4294017.692583] abituguru: testing bank1 sensor 4
[4294017.716582] abituguru:   found volt sensor
[4294017.718583] abituguru: testing bank1 sensor 10
[4294017.740486] abituguru:   found volt sensor
[4294017.742582] abituguru: testing bank1 sensor 8
[4294017.766582] abituguru:   found volt sensor
[4294017.768583] abituguru: testing bank1 sensor 14
[4294017.792582] abituguru:   found volt sensor
[4294017.794583] abituguru: testing bank1 sensor 2
[4294017.818582] abituguru:   found volt sensor
[4294017.820583] abituguru: testing bank1 sensor 9
[4294017.844732] abituguru:   found volt sensor
[4294017.846653] abituguru: testing bank1 sensor 6
[4294017.868473] abituguru:   found volt sensor
[4294017.870582] abituguru: testing bank1 sensor 5
[4294017.894582] abituguru:   found volt sensor
[4294017.896583] abituguru: testing bank1 sensor 11
[4294017.920582] abituguru:   found volt sensor
[4294017.922654] abituguru: testing bank1 sensor 15
[4294017.944764] abituguru:   alarm not raised during volt sensor test
[4294017.996451] abituguru:   found temp sensor
[4294017.998582] abituguru: testing bank1 sensor 13
[4294018.022582] abituguru:   found volt sensor
[4294018.024708] abituguru: testing bank1 sensor 7
[4294018.046758] abituguru:   alarm not raised during volt sensor test
[4294018.099582] abituguru:   alarm not raised during temp sensor test
[4294018.101583] abituguru: testing bank1 sensor 12
[4294018.124582] abituguru:   alarm not raised during volt sensor test
[4294018.176758] abituguru:   alarm not raised during temp sensor test
[4294018.177701] abituguru: detecting number of fan sensors
[4294018.177729] abituguru:   bank2 sensor 5 does not seem to be a fan 
sensor: the threshold (0) is below the minimum (5)
[4294018.177774] abituguru:  found: 5 fan sensors
[4294018.177807] abituguru: detecting number of PWM outputs
[4294018.177835] abituguru:   pwm channel 3 does not seem to be a pwm 
channel: settings[0] = C9
[4294018.177876] abituguru:  found: 3 PWM outputs
[4294018.177907] abituguru: found Abit uGuru
[4294018.178700] WDT driver for the Winbond(TM) W83627HF/THF/HG Super 
I/O chip initialising.
[4294018.178845] w83627hf/thf/hg WDT: initialized. timeout=60 sec 
(nowayout=0)
[4294018.178895] cpuidle: using governor ladder
[4294018.178922] cpuidle: using governor menu
[4294018.193574] input: Logitech USB Mouse as 
/devices/pci0000:00/0000:00:10.0/usb2/2-1/2-1:1.0/input/input2
[4294018.217664] input: USB HID v1.10 Mouse [Logitech USB Mouse] on 
usb-0000:00:10.0-1
[4294018.230585] input: Microsoft Microsoft� Digital Media Pro Keyboard 
as /devices/pci0000:00/0000:00:10.0/usb2/2-2/2-2:1.0/input/input3
[4294018.254662] input: USB HID v1.11 Keyboard [Microsoft Microsoft� 
Digital Media Pro Keyboard] on usb-0000:00:10.0-2
[4294018.273573] input: Microsoft Microsoft� Digital Media Pro Keyboard 
as /devices/pci0000:00/0000:00:10.0/usb2/2-2/2-2:1.1/input/input4
[4294018.305661] input: USB HID v1.11 Device [Microsoft Microsoft� 
Digital Media Pro Keyboard] on usb-0000:00:10.0-2
[4294018.305794] usbcore: registered new interface driver usbhid
[4294018.305825] usbhid: v2.6:USB HID core driver
[4294018.305977] Advanced Linux Sound Architecture Driver Version 1.0.16.
[4294018.309575] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, 
low) -> IRQ 22
[4294018.309575] PCI: Setting latency timer of device 0000:00:11.5 to 64
[4294018.825716] ALSA device list:
[4294018.825746]   #0: VIA 8237 with ALC658D at 0xd800, irq 22
[4294018.826596] GRE over IPv4 tunneling driver
[4294018.827292] TCP cubic registered
[4294018.827320] NET: Registered protocol family 17
[4294018.827372] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3000+ 
processors (1 cpu cores) (version 2.20.00)
[4294018.827525] powernow-k8:    0 : fid 0xa (1800 MHz), vid 0x6
[4294018.827553] powernow-k8:    1 : fid 0x2 (1000 MHz), vid 0x12
[4294018.828513] rtc_cmos 00:05: setting system clock to 2008-06-21 
09:56:22 UTC (1214042182)
[4294018.847573] kjournald starting.  Commit interval 5 seconds
[4294018.847573] EXT3-fs: mounted filesystem with ordered data mode.
[4294018.847573] VFS: Mounted root (ext3 filesystem) readonly.
[4294018.847573] Freeing unused kernel memory: 204k freed
[4294018.847573] Write protecting the kernel read-only data: 3696k
[4294018.860730] Testing CPA: undo ffffffff804b3000-ffffffff805a5000
[4294018.860790] Testing CPA: again
[4294019.010751] Marking TSC unstable due to cpufreq changes
[4294019.227590] Clocksource tsc unstable (delta = -98945211 ns)
[4294026.855875] Adding 1502036k swap on /dev/sda5.  Priority:-1 
extents:1 across:1502036k
[4294027.202534] EXT3 FS on sda1, internal journal
[4294027.967603] kjournald starting.  Commit interval 5 seconds
[4294027.967603] EXT3 FS on sda6, internal journal
[4294027.967603] EXT3-fs: mounted filesystem with ordered data mode.
[4294030.341591] warning: `avahi-daemon' uses 32-bit capabilities 
(legacy support in use)
[4294033.364577] Velocity is AUTO mode
[4294035.043577] eth0: Link auto-negotiation speed 100M bps full duplex
[4294044.796597] CPA self-test:
[4294044.809748]  4k 2560 large 1019 gb 0 x 
96[ffff8100000a0000-ffff8100000ff000] miss 524288
[4294044.832917]  4k 109056 large 811 gb 0 x 
96[ffff8100000a0000-ffff8100000ff000] miss 524288
[4294044.853936]  4k 109056 large 811 gb 0 x 
96[ffff8100000a0000-ffff8100000ff000] miss 524288
[4294044.856902] ok.

-- 
Kevin Winchester

