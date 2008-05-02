Return-Path: <linux-kernel-owner+w=401wt.eu-S1765553AbYEBOmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765553AbYEBOmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758011AbYEBOmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:42:17 -0400
Received: from smtp-out114.alice.it ([85.37.17.114]:4358 "EHLO
	smtp-out114.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342AbYEBOmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:42:16 -0400
X-Greylist: delayed 915 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 May 2008 10:42:16 EDT
From: Fabio De Francesco <fabiomdf@alice.it>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [x86_32] With 4GB installed, in which cases low mem total is less than 896MB?
Date: Fri, 2 May 2008 16:38:46 +0200
User-Agent: KMail/1.9.9
References: <200804301702.06019.fabiomdf@alice.it> <20080429101852.6719eb59@infradead.org>
In-Reply-To: <20080429101852.6719eb59@infradead.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200805021638.52540.fabiomdf@alice.it>
X-OriginalArrivalTime: 02 May 2008 14:26:59.0812 (UTC) FILETIME=[9515A240:01C8AC60]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2008 19:18:52 Arjan van de Ven wrote:
>On Wed, 30 Apr 2008 17:02:02 +0200
>Fabio De Francesco <fabiomdf@alice.it> wrote:
>
>> Hi all,
>> 
>> I've got a Linux box, Intel Core 2 T7700 with 4GB RAM installed, with
>> vanilla kernel 2.6.24 + TuxOnIce patch-set compiled for x86_32bit
>> (CONFIG_X86_32=y), whose /proc/meminfo shows "LowTotal 794MB".
>
>I'm not an expert in this, but one thing is that the more memory the system has, the more overhead there is.
>(roughly 64 bytes per 4Kb of memory).
>

Arjan,

Unfortunetally my poor knowledge of Linux kernel mechanisms (and code!) prevents me from understanding what could be the causes for that overhead. Do you mean it is a hardware issue? Or is it a kernel one? Anyway another machine of mine, that is equipped with 2GB RAM, doesn't show any proportional reduction of low memory at all. So this makes me think (oh, dear!).

Anyway I started a little research (eh?) in Linux code in order to understand how the low memory mapping is done, just in case... Please be patient if what I've done shows nothing relevant for this subject.  

I've just read arch/x86/mm/init_32.c where, if I understand well(?) the mapping happens. I started from pagetable_init() following the flow to kernel_physical_mapping_init() where the hard work is done. Comments before this last function say that "maps the physical memory to kernel virtual address space, a total of max_low_pfn pages, by creating page tables starting from address PAGE_OFFSET".

Ok, then... max_low_pfn is set upon what the BIOS had provided in arch/x86/kernel/setup_32.c, by function find_max_low_pfn().

After having inserted a couple of printk() showing the value of max_low_pfn and pfn (a local variable of kernel_physical_mapping_init() that is incremented in a for() at each iteration, and which counts how many pages have really been mapped) in the relevant(?) sections/functions, this is the first part of dmesg:

[    0.000000] Linux version 2.6.24-tuxonice-r6-080430 (root@host11) (gcc version 4.2.3 (Gentoo 4.2.3 p1.0)) #5 SMP PREEMPT Thu May 1 22:24:26 CEST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfe72000 (usable)
[    0.000000]  BIOS-e820: 00000000dfe72000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f4000000 - 00000000f8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] ---> find_max_lox_pfn() returns max_low_pfn value of 229376 <---
[    0.000000] 3712MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] ---> In kernel_physical_mapping_init(), max_low_pfn value is 229376 <---
[    0.000000] ---> In kernel_physical_mapping_init(), after mapping, max_low_pfn and pfn values are 229376 and 229376 <---
[    0.000000] Entering add_active_range(0, 0, 1179648) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->  1179648
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->  1179648
[    0.000000] On node 0 totalpages: 1179648
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 7424 pages used for memmap
[    0.000000]   HighMem zone: 942848 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
...skip...
Memory: 4068032k/4718592k available (4030k kernel code, 123504k reserved, 1642k data, 264k init, 3275208k highmem)
[   10.657852] virtual kernel memory layout:
[   10.657852]     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
[   10.657853]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[   10.657854]     vmalloc : 0xf8800000 - 0xffbfe000   ( 115 MB)
[   10.657855]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   10.657856]       .init : 0xc0691000 - 0xc06d3000   ( 264 kB)
[   10.657856]       .data : 0xc04ef916 - 0xc068a154   (1642 kB)
[   10.657857]       .text : 0xc0100000 - 0xc04ef916   (4030 kB)

I think it only remains to me to understand which policy /proc/meminfo uses in calculation of total low memory.

As for it is concerned with my other question, I understand yours and Alan replies on the PCI hole.

Thank you.

-- 
Best Regards,

fabio de francesco
metanix.org
