Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbYJBWDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbYJBWDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbYJBWDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:03:21 -0400
Received: from smtp2.ono.com ([62.42.230.20]:23667 "EHLO resmaa04.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754518AbYJBWDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:03:18 -0400
Date: Fri, 3 Oct 2008 00:03:14 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
Message-ID: <20081003000314.771b2f68@werewolf.home>
In-Reply-To: <1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com>
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com>
 <1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: Claws Mail 3.5.0cvs144 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008 18:54:12 -0700, Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> one have gran < 1M
> 
> reg00: base=0xd8000000 (3456MB), size= 128MB: uncachable, count=1
> reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
> reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
> reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
> reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
> reg05: base=0xd7f80000 (3455MB), size= 512KB: uncachable, count=1
> 
> will get
> 
> Found optimal setting for mtrr clean up
> gran_size: 512K         chunk_size: 2M  num_reg: 7      lose RAM: 0G
> range0: 0000000000000000 - 00000000d8000000
> Setting variable MTRR 0, base: 0GB, range: 2GB, type WB
> Setting variable MTRR 1, base: 2GB, range: 1GB, type WB
> Setting variable MTRR 2, base: 3GB, range: 256MB, type WB
> Setting variable MTRR 3, base: 3328MB, range: 128MB, type WB
> hole: 00000000d7f00000 - 00000000d7f80000
> Setting variable MTRR 4, base: 3455MB, range: 512KB, type UC
> rangeX: 0000000100000000 - 0000000128000000
> Setting variable MTRR 5, base: 4GB, range: 512MB, type WB
> Setting variable MTRR 6, base: 4608MB, range: 128MB, type WB
> 
> so start from 64k instead of 1M
> 

Or there is something I don't catch about mtrrs, or it still does silly
things.

I have an ASUS PCDL, dual xeon, 2Gb of memory. Mtrrs after cleanup are:

werewolf:/proc> cat mtrr
reg00: base=0x00000000 (   0MB), size=1024MB: write-back, count=1
reg01: base=0x40000000 (1024MB), size= 512MB: write-back, count=1
reg02: base=0x60000000 (1536MB), size= 256MB: write-back, count=1
reg03: base=0x70000000 (1792MB), size= 128MB: write-back, count=1
reg04: base=0x78000000 (1920MB), size=  64MB: write-back, count=1
reg05: base=0x7c000000 (1984MB), size=  64MB: write-back, count=1
reg06: base=0x7ff00000 (2047MB), size=   1MB: uncachable, count=1

So it adds a last WB zone, but substracts the last 1Mb. (Why do 
I have that stupid uncacheable mb ? probably a bios issue...)
But those two 64 mb zones could be add to a 128Mb, that new one
with previous to 256Mb and so on, giving something like:

reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x7ff00000 (2047MB), size=   1MB: uncachable, count=1

Is this incorrect ?

dmesg is below

Linux version 2.6.26-jam14 (root@werewolf.home) (gcc version 4.3.2 (GCC) ) #2 SMP PREEMPT Thu Oct 2 23:48:10 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fee0000 (usable)
 BIOS-e820: 000000007fee0000 - 000000007fee3000 (ACPI NVS)
 BIOS-e820: 000000007fee3000 - 000000007fef0000 (ACPI data)
 BIOS-e820: 000000007fef0000 - 000000007ff00000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
last_pfn = 0x7fee0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
total RAM coverred: 2047M
 gran_size: 64K 	chunk_size: 64K 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 64K 	chunk_size: 128K 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 64K 	chunk_size: 256K 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 64K 	chunk_size: 512K 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 64K 	chunk_size: 1M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 64K 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 64K 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 64K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 7M
*BAD*gran_size: 64K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: -1M
 gran_size: 64K 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 2G 	num_reg: 2  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 4G 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 128K 	chunk_size: 128K 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 128K 	chunk_size: 256K 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 128K 	chunk_size: 512K 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 128K 	chunk_size: 1M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 128K 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 128K 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 128K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 7M
*BAD*gran_size: 128K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: -1M
 gran_size: 128K 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 2G 	num_reg: 2  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 4G 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 256K 	chunk_size: 256K 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 256K 	chunk_size: 512K 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 256K 	chunk_size: 1M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 256K 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 256K 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 256K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 7M
*BAD*gran_size: 256K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: -1M
 gran_size: 256K 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 2G 	num_reg: 2  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 4G 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 512K 	chunk_size: 512K 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 512K 	chunk_size: 1M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 512K 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 512K 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 512K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 7M
*BAD*gran_size: 512K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: -1M
 gran_size: 512K 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 2G 	num_reg: 2  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 4G 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 1M 	chunk_size: 1M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 1M 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 1M 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 1M 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 7M
*BAD*gran_size: 1M 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: -1M
 gran_size: 1M 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 2G 	num_reg: 2  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 4G 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 2M 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 2M 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 2M 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 7M
*BAD*gran_size: 2M 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: -1M
 gran_size: 2M 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 2G 	num_reg: 2  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 4G 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 4M 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 4M 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 7M
*BAD*gran_size: 4M 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: -1M
 gran_size: 4M 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 3M
 gran_size: 4M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 3M
 gran_size: 4M 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 3M
 gran_size: 4M 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: 3M
 gran_size: 4M 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 3M
 gran_size: 4M 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 3M
 gran_size: 4M 	chunk_size: 2G 	num_reg: 2  	lose cover RAM: 3M
 gran_size: 4M 	chunk_size: 4G 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 8M 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 8M 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 8M 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 8M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 7M
 gran_size: 8M 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 7M
 gran_size: 8M 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: 7M
 gran_size: 8M 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 7M
 gran_size: 8M 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 7M
 gran_size: 8M 	chunk_size: 2G 	num_reg: 2  	lose cover RAM: 7M
 gran_size: 8M 	chunk_size: 4G 	num_reg: 8  	lose cover RAM: 7M
 gran_size: 16M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: 15M
 gran_size: 16M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 15M
 gran_size: 16M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: 15M
 gran_size: 16M 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 15M
 gran_size: 16M 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: 15M
 gran_size: 16M 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 15M
 gran_size: 16M 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 15M
 gran_size: 16M 	chunk_size: 2G 	num_reg: 2  	lose cover RAM: 15M
 gran_size: 16M 	chunk_size: 4G 	num_reg: 7  	lose cover RAM: 15M
 gran_size: 32M 	chunk_size: 32M 	num_reg: 6  	lose cover RAM: 31M
 gran_size: 32M 	chunk_size: 64M 	num_reg: 6  	lose cover RAM: 31M
 gran_size: 32M 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: 31M
 gran_size: 32M 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: 31M
 gran_size: 32M 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 31M
 gran_size: 32M 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 31M
 gran_size: 32M 	chunk_size: 2G 	num_reg: 2  	lose cover RAM: 31M
 gran_size: 32M 	chunk_size: 4G 	num_reg: 6  	lose cover RAM: 31M
 gran_size: 64M 	chunk_size: 64M 	num_reg: 5  	lose cover RAM: 63M
 gran_size: 64M 	chunk_size: 128M 	num_reg: 5  	lose cover RAM: 63M
 gran_size: 64M 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: 63M
 gran_size: 64M 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 63M
 gran_size: 64M 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 63M
 gran_size: 64M 	chunk_size: 2G 	num_reg: 2  	lose cover RAM: 63M
 gran_size: 64M 	chunk_size: 4G 	num_reg: 5  	lose cover RAM: 63M
 gran_size: 128M 	chunk_size: 128M 	num_reg: 4  	lose cover RAM: 127M
 gran_size: 128M 	chunk_size: 256M 	num_reg: 4  	lose cover RAM: 127M
 gran_size: 128M 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 127M
 gran_size: 128M 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 127M
Found optimal setting for mtrr clean up
gran_size: 64K 	chunk_size: 64M 	num_reg: 7  	lose RAM: 0G
range0: 0000000000000000 - 000000007c000000
Setting variable MTRR 0, base: 0GB, range: 1GB, type WB
Setting variable MTRR 1, base: 1GB, range: 512MB, type WB
Setting variable MTRR 2, base: 1536MB, range: 256MB, type WB
Setting variable MTRR 3, base: 1792MB, range: 128MB, type WB
Setting variable MTRR 4, base: 1920MB, range: 64MB, type WB
range: 000000007c000000 - 0000000080000000
Setting variable MTRR 5, base: 1984MB, range: 64MB, type WB
hole: 000000007ff00000 - 0000000080000000
Setting variable MTRR 6, base: 2047MB, range: 1MB, type UC
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
After WB checking
MTRR MAP PFN: 0000000000000000 - 0000000000080000
After UC checking
MTRR MAP PFN: 0000000000000000 - 000000000007ff00
After sorting
MTRR MAP PFN: 0000000000000000 - 000000000007ff00
kernel direct mapping tables up to 38000000 @ 7000-c000
DMI 2.3 present.
ACPI: RSDP 000F7260, 0014 (r0 IntelR)
ACPI: RSDT 7FEE3000, 0030 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 7FEE3040, 0074 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 7FEE30C0, 44C1 (r1 INTELR AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 7FEE0000, 0040
ACPI: ASF! 7FEE7680, 008A (r32 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 7FEE75C0, 0084 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
1150MB HIGHMEM available.
896MB LOWMEM available.
  mapped low ram: 0 - 38000000
  low ram: 00000000 - 38000000
  bootmap 00008000 - 0000f000
(8 early reservations) ==> bootmem [0000000000 - 0038000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 00004b0ea0]    TEXT DATA BSS ==> [0000100000 - 00004b0ea0]
  #4 [00004b1000 - 00004b4000]    INIT_PG_TABLE ==> [00004b1000 - 00004b4000]
  #5 [000009f400 - 0000100000]    BIOS reserved ==> [000009f400 - 0000100000]
  #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
  #7 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
found SMP MP-table at [c00f57c0] 000f57c0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00038000
  HighMem  0x00038000 -> 0x0007fee0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0007fee0
On node 0 totalpages: 523903
free_area_init_node: node 0, pgdat c041a680, node_mem_map c1000000
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 292322 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Allocating PCI resources starting at 80000000 (gap: 7ff00000:7ed00000)
PERCPU: Allocating 38940 bytes of per cpu data
NR_CPUS: 4, nr_cpu_ids: 4, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 519809
Kernel command line: video=vesafb:mtrr,ywrap vga=773 ro root=/dev/sda1
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0478000 soft=c0474000
PID hash table entries: 4096 (order: 12, 16384 bytes)
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PMTIMER calibration value
Detected 2405.452 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2073644k/2096000k available (2377k kernel code, 21180k reserved, 857k data, 272k init, 1178496k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff85000 - 0xfffff000   ( 488 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc042d000 - 0xc0471000   ( 272 kB)
      .data : 0xc0352618 - 0xc0428bb8   ( 857 kB)
      .text : 0xc0100000 - 0xc0352618   (2377 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency.. 4810.90 BogoMIPS (lpj=2405452)
Mount-cache hash table entries: 512
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 10k freed
ACPI: Core revision 20080609
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(TM) CPU 2.40GHz stepping 09
CPU 1 irqstacks, hard=c0479000 soft=c0475000
Booting processor 1/6 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4810.31 BogoMIPS (lpj=2405156)
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Xeon(TM) CPU 2.40GHz stepping 09
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
CPU 2 irqstacks, hard=c047a000 soft=c0476000
Booting processor 2/1 ip 6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4810.28 BogoMIPS (lpj=2405141)
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Intel(R) Xeon(TM) CPU 2.40GHz stepping 09
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
CPU 3 irqstacks, hard=c047b000 soft=c0477000
Booting processor 3/7 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4810.31 BogoMIPS (lpj=2405159)
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Intel(R) Xeon(TM) CPU 2.40GHz stepping 09
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
Total of 4 processors activated (19241.81 BogoMIPS).
net_namespace: 296 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb7f0, last bus=3
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: 0000:00:00.0 reg 10 32bit mmio: [f0000000, f1ffffff]
PCI: 0000:00:1d.0 reg 20 io port: [bc00, bc1f]
PCI: 0000:00:1d.1 reg 20 io port: [b000, b01f]
PCI: 0000:00:1d.2 reg 20 io port: [b400, b41f]
PCI: 0000:00:1d.3 reg 20 io port: [b800, b81f]
PCI: 0000:00:1d.7 reg 10 32bit mmio: [f7100000, f71003ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH4 GPIO
PCI: 0000:00:1f.1 reg 10 io port: [0, 7]
PCI: 0000:00:1f.1 reg 14 io port: [0, 3]
PCI: 0000:00:1f.1 reg 18 io port: [0, 7]
PCI: 0000:00:1f.1 reg 1c io port: [0, 3]
PCI: 0000:00:1f.1 reg 20 io port: [f000, f00f]
PCI: 0000:00:1f.1 reg 24 32bit mmio: [0, 3ff]
PCI: 0000:00:1f.2 reg 10 io port: [c000, c007]
PCI: 0000:00:1f.2 reg 14 io port: [c400, c403]
PCI: 0000:00:1f.2 reg 18 io port: [c800, c807]
PCI: 0000:00:1f.2 reg 1c io port: [cc00, cc03]
PCI: 0000:00:1f.2 reg 20 io port: [d000, d00f]
PCI: 0000:00:1f.3 reg 20 io port: [500, 51f]
PCI: 0000:00:1f.5 reg 10 io port: [d800, d8ff]
PCI: 0000:00:1f.5 reg 14 io port: [dc00, dc3f]
PCI: 0000:00:1f.5 reg 18 32bit mmio: [f7101000, f71011ff]
PCI: 0000:00:1f.5 reg 1c 32bit mmio: [f7102000, f71020ff]
pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.5: PME# disabled
PCI: 0000:01:00.0 reg 10 32bit mmio: [f2000000, f2ffffff]
PCI: 0000:01:00.0 reg 14 32bit mmio: [e0000000, efffffff]
PCI: 0000:01:00.0 reg 18 32bit mmio: [f3000000, f3ffffff]
PCI: 0000:01:00.0 reg 30 32bit mmio: [0, 1ffff]
PCI: bridge 0000:00:01.0 32bit mmio: [f2000000, f4ffffff]
PCI: bridge 0000:00:01.0 32bit mmio pref: [e0000000, efffffff]
PCI: 0000:02:01.0 reg 10 32bit mmio: [f7000000, f701ffff]
PCI: 0000:02:01.0 reg 18 io port: [a000, a01f]
pci 0000:02:01.0: PME# supported from D0 D3hot D3cold
pci 0000:02:01.0: PME# disabled
PCI: bridge 0000:00:03.0 io port: [a000, afff]
PCI: bridge 0000:00:03.0 32bit mmio: [f7000000, f70fffff]
PCI: 0000:03:03.0 reg 10 32bit mmio: [f6008000, f60087ff]
PCI: 0000:03:03.0 reg 14 32bit mmio: [f6000000, f6003fff]
pci 0000:03:03.0: supports D1
pci 0000:03:03.0: supports D2
pci 0000:03:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:03:03.0: PME# disabled
PCI: 0000:03:0a.0 reg 10 io port: [8000, 80ff]
PCI: 0000:03:0a.0 reg 14 64bit mmio: [f6004000, f6005fff]
PCI: 0000:03:0a.0 reg 1c io port: [8400, 84ff]
PCI: 0000:03:0a.0 reg 30 32bit mmio: [0, 7ffff]
PCI: 0000:03:0a.1 reg 10 io port: [8800, 88ff]
PCI: 0000:03:0a.1 reg 14 64bit mmio: [f6006000, f6007fff]
PCI: 0000:03:0a.1 reg 1c io port: [8c00, 8cff]
PCI: 0000:03:0a.1 reg 30 32bit mmio: [0, 7ffff]
PCI: 0000:03:0b.0 reg 10 io port: [9000, 901f]
PCI: 0000:03:0b.1 reg 10 io port: [9400, 9407]
PCI: 0000:03:0d.0 reg 10 io port: [9800, 987f]
PCI: 0000:03:0d.0 reg 14 32bit mmio: [f6009000, f600907f]
PCI: 0000:03:0d.0 reg 30 32bit mmio: [0, 1ffff]
pci 0000:03:0d.0: supports D1
pci 0000:03:0d.0: supports D2
pci 0000:03:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:0d.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 io port: [8000, 9fff]
PCI: bridge 0000:00:1e.0 32bit mmio: [f5000000, f6ffffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 *9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
hpet clockevent registered
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
system 00:01: ioport range 0xb78-0xb7b has been reserved
system 00:01: ioport range 0xf78-0xf7b has been reserved
system 00:01: ioport range 0xa78-0xa7b has been reserved
system 00:01: ioport range 0xe78-0xe7b has been reserved
system 00:01: ioport range 0xbbc-0xbbf has been reserved
system 00:01: ioport range 0xfbc-0xfbf has been reserved
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:0d: ioport range 0x400-0x4bf could not be reserved
system 00:0d: ioport range 0x295-0x296 has been reserved
system 00:0f: iomem range 0xd9e00-0xdbfff has been reserved
system 00:0f: iomem range 0xf0000-0xf7fff could not be reserved
system 00:0f: iomem range 0xf8000-0xfbfff could not be reserved
system 00:0f: iomem range 0xfc000-0xfffff could not be reserved
system 00:0f: iomem range 0x7fee0000-0x7fefffff could not be reserved
system 00:0f: iomem range 0x0-0x9ffff could not be reserved
system 00:0f: iomem range 0x100000-0x7fedffff could not be reserved
system 00:0f: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0f: iomem range 0xfec01000-0xfed8ffff could not be reserved
system 00:0f: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0f: iomem range 0xffb00000-0xffb7ffff could not be reserved
system 00:0f: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:0f: iomem range 0xe0000-0xeffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: 0xf2000000-0xf4ffffff
pci 0000:00:01.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
pci 0000:00:03.0: PCI bridge, secondary bus 0000:02
pci 0000:00:03.0:   IO window: 0xa000-0xafff
pci 0000:00:03.0:   MEM window: 0xf7000000-0xf70fffff
pci 0000:00:03.0:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
pci 0000:00:1e.0:   IO window: 0x8000-0x9fff
pci 0000:00:1e.0:   MEM window: 0xf5000000-0xf6ffffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000080000000-0x000000801fffff
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffff]
bus: 01 index 0 mmio: [0, 0]
bus: 01 index 1 mmio: [f2000000, f4ffffff]
bus: 01 index 2 mmio: [e0000000, efffffff]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [a000, afff]
bus: 02 index 1 mmio: [f7000000, f70fffff]
bus: 02 index 2 mmio: [0, 0]
bus: 02 index 3 mmio: [0, 0]
bus: 03 index 0 io port: [8000, 9fff]
bus: 03 index 1 mmio: [f5000000, f6ffffff]
bus: 03 index 2 mmio: [80000000, 801fffff]
bus: 03 index 3 io port: [0, ffff]
bus: 03 index 4 mmio: [0, ffffffff]
...

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
