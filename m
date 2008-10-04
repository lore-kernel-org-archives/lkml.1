Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbYJDNWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbYJDNWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 09:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbYJDNWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 09:22:43 -0400
Received: from smtp2.ono.com ([62.42.230.20]:32522 "EHLO resmaa04.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752016AbYJDNWk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 09:22:40 -0400
Date: Sat, 4 Oct 2008 15:22:35 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yinghai@kernel.org>
Subject: Re: Strange mtrrs in Aspire One
Message-ID: <20081004152235.387a6f61@werewolf.home>
In-Reply-To: <86802c440809291805r71877ad1wc68525c1ca0603e1@mail.gmail.com>
References: <20080930015733.5c6ea984@werewolf.home>
	<86802c440809291805r71877ad1wc68525c1ca0603e1@mail.gmail.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008 18:05:51 -0700, "Yinghai Lu" <yinghai@kernel.org> wrote:

> On Mon, Sep 29, 2008 at 4:57 PM, J.A. Magallón <jamagallon@ono.com> wrote:
> > Hi all...
> >
> > My aspire one is giving some strange MTRR settings with rc7-git5 (and
> > prevous kernels, but that is what I run now...):
> >
> > one:~> cat /proc/mtrr
> > reg00: base=0xfffe0000 (4095MB), size= 128KB: write-protect, count=1
> > reg01: base=0xfffc0000 (4095MB), size= 128KB: uncachable, count=1
> 
> could make mtrr_cleanup to support 128K gran_size
> 
> > reg02: base=0x00000000 (   0MB), size= 256MB: write-back, count=1
> > reg03: base=0x10000000 ( 256MB), size= 256MB: write-back, count=1
> > reg04: base=0x1f800000 ( 504MB), size=   8MB: uncachable, count=1
> > reg05: base=0x1f600000 ( 502MB), size=   2MB: uncachable, count=1
> > reg06: base=0x1f500000 ( 501MB), size=   1MB: uncachable, count=1
> 
> > reg07: base=0x00000000 (   0MB), size= 128KB: uncachable, count=1
> ..
> >  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> 
> last entry is really sick...
> 

I have applied the patches you have posted in other threads, and this
give a very strange result. The mtrr cleanup did nothing, and I had to put
some printk's all around.

The thing is that the cleanup stops here:


    printk(KERN_INFO "GO 6 %d\n",num[MTRR_TYPE_WRBACK] + num[MTRR_TYPE_UNCACHABL
    printk(KERN_INFO "GO 6 %d\n",num_var_ranges - num[MTRR_NUM_TYPES]);
    /* check if we only had WB and UC */
     if (num[MTRR_TYPE_WRBACK] + num[MTRR_TYPE_UNCACHABLE] !=
        num_var_ranges - num[MTRR_NUM_TYPES])
        return 0;

Result is:

GO 6 7
GO 6 8

If I comment the test, it can not found a suitable setup.
Full dmesg below.

Linux version 2.6.26-jam15 (root@one.home) (gcc version 4.3.2 (GCC) ) #4 SMP PREEMPT Sat Oct 4 10:57:32 CEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001f376000 (usable)
 BIOS-e820: 000000001f376000 - 000000001f3bf000 (reserved)
 BIOS-e820: 000000001f3bf000 - 000000001f46d000 (usable)
 BIOS-e820: 000000001f46d000 - 000000001f4bf000 (ACPI NVS)
 BIOS-e820: 000000001f4bf000 - 000000001f4f0000 (usable)
 BIOS-e820: 000000001f4f0000 - 000000001f4ff000 (ACPI data)
 BIOS-e820: 000000001f4ff000 - 000000001f500000 (usable)
 BIOS-e820: 000000001f500000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
last_pfn = 0x1f500 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
GO 1 1 1
GO 2 0
GO 3
GO 4 8
GO 5 5
GO 6 7
GO 6 8
total RAM coverred: 500M
*BAD*gran_size: 64K 	chunk_size: 64K 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 64K 	chunk_size: 128K 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 64K 	chunk_size: 256K 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 64K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 64K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 64K 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 64K 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 64K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: -128K
*BAD*gran_size: 64K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 64K 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: -128K
*BAD*gran_size: 64K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 64K 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: -128K
*BAD*gran_size: 64K 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: -128K
*BAD*gran_size: 64K 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: -128K
*BAD*gran_size: 64K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 64K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 64K 	chunk_size: 4G 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 128K 	chunk_size: 128K 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 128K 	chunk_size: 256K 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 128K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 128K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 128K 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 128K 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 128K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: -128K
*BAD*gran_size: 128K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 128K 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: -128K
*BAD*gran_size: 128K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 128K 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: -128K
*BAD*gran_size: 128K 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: -128K
*BAD*gran_size: 128K 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: -128K
*BAD*gran_size: 128K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 128K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 128K 	chunk_size: 4G 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 256K 	chunk_size: 256K 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 256K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 256K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 256K 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 256K 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 256K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: -128K
*BAD*gran_size: 256K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 256K 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: -128K
*BAD*gran_size: 256K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 256K 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: -128K
*BAD*gran_size: 256K 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: -128K
*BAD*gran_size: 256K 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: -128K
*BAD*gran_size: 256K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 256K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 256K 	chunk_size: 4G 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 512K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 512K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 512K 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 512K 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 512K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: -128K
*BAD*gran_size: 512K 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 512K 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: -128K
*BAD*gran_size: 512K 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 512K 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: -128K
*BAD*gran_size: 512K 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: -128K
*BAD*gran_size: 512K 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: -128K
*BAD*gran_size: 512K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 512K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 512K 	chunk_size: 4G 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 1M 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 1M 	chunk_size: 2M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 1M 	chunk_size: 4M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 1M 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: -128K
*BAD*gran_size: 1M 	chunk_size: 16M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 1M 	chunk_size: 32M 	num_reg: 8  	lose cover RAM: -128K
*BAD*gran_size: 1M 	chunk_size: 64M 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 1M 	chunk_size: 128M 	num_reg: 6  	lose cover RAM: -128K
*BAD*gran_size: 1M 	chunk_size: 256M 	num_reg: 5  	lose cover RAM: -128K
*BAD*gran_size: 1M 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: -128K
*BAD*gran_size: 1M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 1M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: -128K
*BAD*gran_size: 1M 	chunk_size: 4G 	num_reg: 7  	lose cover RAM: -128K
 gran_size: 2M 	chunk_size: 2M 	num_reg: 6  	lose cover RAM: 896K
 gran_size: 2M 	chunk_size: 4M 	num_reg: 6  	lose cover RAM: 896K
 gran_size: 2M 	chunk_size: 8M 	num_reg: 6  	lose cover RAM: 896K
 gran_size: 2M 	chunk_size: 16M 	num_reg: 6  	lose cover RAM: 896K
 gran_size: 2M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 896K
 gran_size: 2M 	chunk_size: 64M 	num_reg: 6  	lose cover RAM: 896K
 gran_size: 2M 	chunk_size: 128M 	num_reg: 5  	lose cover RAM: 896K
 gran_size: 2M 	chunk_size: 256M 	num_reg: 4  	lose cover RAM: 896K
 gran_size: 2M 	chunk_size: 512M 	num_reg: 3  	lose cover RAM: 896K
 gran_size: 2M 	chunk_size: 1G 	num_reg: 6  	lose cover RAM: 896K
 gran_size: 2M 	chunk_size: 2G 	num_reg: 6  	lose cover RAM: 896K
 gran_size: 2M 	chunk_size: 4G 	num_reg: 6  	lose cover RAM: 896K
 gran_size: 4M 	chunk_size: 4M 	num_reg: 6  	lose cover RAM: 896K
 gran_size: 4M 	chunk_size: 8M 	num_reg: 6  	lose cover RAM: 896K
 gran_size: 4M 	chunk_size: 16M 	num_reg: 6  	lose cover RAM: 896K
 gran_size: 4M 	chunk_size: 32M 	num_reg: 7  	lose cover RAM: 896K
 gran_size: 4M 	chunk_size: 64M 	num_reg: 6  	lose cover RAM: 896K
 gran_size: 4M 	chunk_size: 128M 	num_reg: 5  	lose cover RAM: 896K
 gran_size: 4M 	chunk_size: 256M 	num_reg: 4  	lose cover RAM: 896K
 gran_size: 4M 	chunk_size: 512M 	num_reg: 3  	lose cover RAM: 896K
 gran_size: 4M 	chunk_size: 1G 	num_reg: 6  	lose cover RAM: 896K
 gran_size: 4M 	chunk_size: 2G 	num_reg: 6  	lose cover RAM: 896K
 gran_size: 4M 	chunk_size: 4G 	num_reg: 6  	lose cover RAM: 896K
 gran_size: 8M 	chunk_size: 8M 	num_reg: 5  	lose cover RAM: 4992K
 gran_size: 8M 	chunk_size: 16M 	num_reg: 5  	lose cover RAM: 4992K
 gran_size: 8M 	chunk_size: 32M 	num_reg: 5  	lose cover RAM: 4992K
 gran_size: 8M 	chunk_size: 64M 	num_reg: 5  	lose cover RAM: 4992K
 gran_size: 8M 	chunk_size: 128M 	num_reg: 4  	lose cover RAM: 4992K
 gran_size: 8M 	chunk_size: 256M 	num_reg: 3  	lose cover RAM: 4992K
 gran_size: 8M 	chunk_size: 512M 	num_reg: 2  	lose cover RAM: 4992K
 gran_size: 8M 	chunk_size: 1G 	num_reg: 5  	lose cover RAM: 4992K
 gran_size: 8M 	chunk_size: 2G 	num_reg: 5  	lose cover RAM: 4992K
 gran_size: 8M 	chunk_size: 4G 	num_reg: 5  	lose cover RAM: 4992K
 gran_size: 16M 	chunk_size: 16M 	num_reg: 5  	lose cover RAM: 4992K
 gran_size: 16M 	chunk_size: 32M 	num_reg: 5  	lose cover RAM: 4992K
 gran_size: 16M 	chunk_size: 64M 	num_reg: 5  	lose cover RAM: 4992K
 gran_size: 16M 	chunk_size: 128M 	num_reg: 4  	lose cover RAM: 4992K
 gran_size: 16M 	chunk_size: 256M 	num_reg: 3  	lose cover RAM: 4992K
 gran_size: 16M 	chunk_size: 512M 	num_reg: 2  	lose cover RAM: 4992K
 gran_size: 16M 	chunk_size: 1G 	num_reg: 5  	lose cover RAM: 4992K
 gran_size: 16M 	chunk_size: 2G 	num_reg: 5  	lose cover RAM: 4992K
 gran_size: 16M 	chunk_size: 4G 	num_reg: 5  	lose cover RAM: 4992K
 gran_size: 32M 	chunk_size: 32M 	num_reg: 4  	lose cover RAM: 21376K
 gran_size: 32M 	chunk_size: 64M 	num_reg: 4  	lose cover RAM: 21376K
 gran_size: 32M 	chunk_size: 128M 	num_reg: 4  	lose cover RAM: 21376K
 gran_size: 32M 	chunk_size: 256M 	num_reg: 3  	lose cover RAM: 21376K
 gran_size: 32M 	chunk_size: 512M 	num_reg: 2  	lose cover RAM: 21376K
 gran_size: 32M 	chunk_size: 1G 	num_reg: 4  	lose cover RAM: 21376K
 gran_size: 32M 	chunk_size: 2G 	num_reg: 4  	lose cover RAM: 21376K
 gran_size: 32M 	chunk_size: 4G 	num_reg: 4  	lose cover RAM: 21376K
 gran_size: 64M 	chunk_size: 64M 	num_reg: 3  	lose cover RAM: 54144K
 gran_size: 64M 	chunk_size: 128M 	num_reg: 3  	lose cover RAM: 54144K
 gran_size: 64M 	chunk_size: 256M 	num_reg: 3  	lose cover RAM: 54144K
 gran_size: 64M 	chunk_size: 512M 	num_reg: 2  	lose cover RAM: 54144K
 gran_size: 64M 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 54144K
 gran_size: 64M 	chunk_size: 2G 	num_reg: 3  	lose cover RAM: 54144K
 gran_size: 64M 	chunk_size: 4G 	num_reg: 3  	lose cover RAM: 54144K
 gran_size: 128M 	chunk_size: 128M 	num_reg: 2  	lose cover RAM: 119680K
 gran_size: 128M 	chunk_size: 256M 	num_reg: 2  	lose cover RAM: 119680K
 gran_size: 128M 	chunk_size: 512M 	num_reg: 2  	lose cover RAM: 119680K
 gran_size: 128M 	chunk_size: 1G 	num_reg: 2  	lose cover RAM: 119680K
mtrr_cleanup: can not find optimal value
please specify mtrr_gran_size/mtrr_chunk_size
kernel direct mapping tables up to 1f500000 @ 7000-d000
DMI 2.4 present.
ACPI: RSDP 000FE020, 0024 (r2 INTEL )
ACPI: XSDT 1F4FE120, 0064 (r1 INTEL  Napa            1       1000013)
ACPI: FACP 1F4FC000, 00F4 (r4 INTEL  Napa            1 MSFT  1000013)
ACPI: DSDT 1F4F2000, 5DAE (r1 INTEL  Napa            1 MSFT  1000013)
ACPI: FACS 1F488000, 0040
ACPI: SSDT 1F4FD000, 04C4 (r2  PmRef    CpuPm     3000 INTL 20051117)
ACPI: HPET 1F4FB000, 0038 (r1 INTEL  Napa            1 MSFT  1000013)
ACPI: APIC 1F4FA000, 0068 (r2 INTEL  Napa            1 MSFT  1000013)
ACPI: MCFG 1F4F9000, 003C (r1 INTEL  Napa            1 MSFT  1000013)
ACPI: ASF! 1F4F8000, 00A5 (r32 INTEL  Napa            1 MSFT  1000013)
ACPI: SLIC 1F4F1000, 0180 (r1 INTEL  Napa            1 MSFT  1000013)
ACPI: BOOT 1F4F0000, 0028 (r1 INTEL  Napa            1 MSFT  1000013)
ACPI: DMI detected: Acer
501MB LOWMEM available.
  mapped low ram: 0 - 1f500000
  low ram: 00000000 - 1f500000
  bootmap 00002000 - 00005ea0
(8 early reservations) ==> bootmem [0000000000 - 001f500000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 00005766d0]    TEXT DATA BSS ==> [0000100000 - 00005766d0]
  #4 [0000577000 - 000057a000]    INIT_PG_TABLE ==> [0000577000 - 000057a000]
  #5 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
  #7 [0000002000 - 0000006000]          BOOTMAP ==> [0000002000 - 0000006000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x0001f500
Movable zone start PFN for each node
early_node_map[5] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0001f376
    0: 0x0001f3bf -> 0x0001f46d
    0: 0x0001f4bf -> 0x0001f4f0
    0: 0x0001f4ff -> 0x0001f500
On node 0 totalpages: 127989
free_area_init_node: node 0, pgdat c04b5600, node_mem_map c1000000
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 123020 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 000000001f376000 - 000000001f3bf000
PM: Registered nosave memory: 000000001f46d000 - 000000001f4bf000
PM: Registered nosave memory: 000000001f4f0000 - 000000001f4ff000
Allocating PCI resources starting at 30000000 (gap: 20000000:c0000000)
PERCPU: Allocating 39836 bytes of per cpu data
NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 126987
Kernel command line: video=vesafb:mtrr,ywrap vga=788 ro root=/dev/sda1 resume=/dev/sda2 elevator=noop enable_mtrr_cleanup mtrr-cleanup
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 1595.987 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 502512k/513024k available (2788k kernel code, 9136k reserved, 1070k data, 268k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb9000 - 0xfffff000   ( 280 kB)
    vmalloc : 0xe0000000 - 0xfffb7000   ( 511 MB)
    lowmem  : 0xc0000000 - 0xdf500000   ( 501 MB)
      .init : 0xc04cc000 - 0xc050f000   ( 268 kB)
      .data : 0xc03b90fc - 0xc04c4c10   (1070 kB)
      .text : 0xc0100000 - 0xc03b90fc   (2788 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 3191.97 BogoMIPS (lpj=1595987)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 24K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using mwait in idle threads.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080609
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3191.84 BogoMIPS (lpj=1595922)
CPU: L1 I cache: 32K, L1 D cache: 24K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (6383.81 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level SIBLING
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level SIBLING
  groups: 1 0
net_namespace: 296 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: missing confirmations, switch off interrupt mode.
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: 0000:00:02.0 reg 10 32bit mmio: [38480000, 384fffff]
PCI: 0000:00:02.0 reg 14 io port: [60c0, 60c7]
PCI: 0000:00:02.0 reg 18 32bit mmio: [20000000, 2fffffff]
PCI: 0000:00:02.0 reg 1c 32bit mmio: [38500000, 3853ffff]
PCI: 0000:00:02.1 reg 10 32bit mmio: [38400000, 3847ffff]
PCI: 0000:00:1b.0 reg 10 64bit mmio: [38540000, 38543fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
PCI: 0000:00:1d.0 reg 20 io port: [6080, 609f]
PCI: 0000:00:1d.1 reg 20 io port: [6060, 607f]
PCI: 0000:00:1d.2 reg 20 io port: [6040, 605f]
PCI: 0000:00:1d.3 reg 20 io port: [6020, 603f]
PCI: 0000:00:1d.7 reg 10 32bit mmio: [38544400, 385447ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
PCI: 0000:00:1f.2 reg 10 io port: [0, 7]
PCI: 0000:00:1f.2 reg 14 io port: [0, 3]
PCI: 0000:00:1f.2 reg 18 io port: [0, 7]
PCI: 0000:00:1f.2 reg 1c io port: [0, 3]
PCI: 0000:00:1f.2 reg 20 io port: [60a0, 60af]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
PCI: 0000:00:1f.3 reg 20 io port: [6000, 601f]
PCI: bridge 0000:00:1c.0 io port: [5000, 5fff]
PCI: bridge 0000:00:1c.0 32bit mmio: [37300000, 383fffff]
PCI: bridge 0000:00:1c.0 64bit mmio pref: [30000000, 30ffffff]
PCI: 0000:02:00.0 reg 10 io port: [3000, 30ff]
PCI: 0000:02:00.0 reg 18 32bit mmio: [31010000, 31010fff]
PCI: 0000:02:00.0 reg 20 32bit mmio: [31000000, 3100ffff]
PCI: 0000:02:00.0 reg 30 32bit mmio: [fffe0000, ffffffff]
pci 0000:02:00.0: supports D1
pci 0000:02:00.0: supports D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
PCI: bridge 0000:00:1c.1 io port: [3000, 4fff]
PCI: bridge 0000:00:1c.1 32bit mmio: [36300000, 372fffff]
PCI: bridge 0000:00:1c.1 64bit mmio pref: [31000000, 320fffff]
PCI: 0000:03:00.0 reg 10 64bit mmio: [35200000, 3520ffff]
Pre-1.1 PCIe device detected, disable ASPM for 0000:00:1c.2. It can be enabled forcedly with 'pcie_aspm=force'
PCI: bridge 0000:00:1c.2 io port: [2000, 2fff]
PCI: bridge 0000:00:1c.2 32bit mmio: [35200000, 362fffff]
PCI: bridge 0000:00:1c.2 64bit mmio pref: [32100000, 330fffff]
PCI: 0000:04:00.0 reg 10 32bit mmio: [34100300, 341003ff]
PCI: 0000:04:00.0 reg 30 32bit mmio: [ffff8000, ffffffff]
PCI: 0000:04:00.2 reg 10 32bit mmio: [34100200, 341002ff]
PCI: 0000:04:00.3 reg 10 32bit mmio: [34100100, 341001ff]
PCI: 0000:04:00.4 reg 10 32bit mmio: [34100000, 341000ff]
PCI: bridge 0000:00:1c.3 io port: [1000, 1fff]
PCI: bridge 0000:00:1c.3 32bit mmio: [34100000, 351fffff]
PCI: bridge 0000:00:1c.3 64bit mmio pref: [33100000, 340fffff]
pci 0000:00:1e.0: transparent bridge
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:01: io resource (0x164e-0x164f) overlaps 0000:00:1c.3 BAR 7 (0x1000-0x1fff), disabling
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Switched to high resolution mode on CPU 0
tracer: 772 pages allocated for 65536 entries of 48 bytes
   actual entries 65620
ACPI Error (dsfield-0139): [CAPB] Namespace lookup failure, AE_ALREADY_EXISTS
ACPI Error (psparse-0530): Method parse/execution failed [\_SB_.PCI0._OSC] (Node dec13cc0), AE_ALREADY_EXISTS
ACPI: Marking method _OSC as Serialized because of AE_ALREADY_EXISTS error
Switched to high resolution mode on CPU 1
system 00:01: ioport range 0x200-0x20f has been reserved
system 00:01: ioport range 0x600-0x60f has been reserved
system 00:01: ioport range 0x610-0x610 has been reserved
system 00:01: ioport range 0x800-0x80f has been reserved
system 00:01: ioport range 0x400-0x47f has been reserved
system 00:01: ioport range 0x500-0x53f has been reserved
system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfee00000-0xfee00fff could not be reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
pci 0000:00:1c.0:   IO window: 0x5000-0x5fff
pci 0000:00:1c.0:   MEM window: 0x37300000-0x383fffff
pci 0000:00:1c.0:   PREFETCH window: 0x00000030000000-0x00000030ffffff
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.1:   IO window: 0x3000-0x4fff
pci 0000:00:1c.1:   MEM window: 0x36300000-0x372fffff
pci 0000:00:1c.1:   PREFETCH window: 0x00000031000000-0x000000320fffff
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.2:   IO window: 0x2000-0x2fff
pci 0000:00:1c.2:   MEM window: 0x35200000-0x362fffff
pci 0000:00:1c.2:   PREFETCH window: 0x00000032100000-0x000000330fffff
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.3:   IO window: 0x1000-0x1fff
pci 0000:00:1c.3:   MEM window: 0x34100000-0x351fffff
pci 0000:00:1c.3:   PREFETCH window: 0x00000033100000-0x000000340fffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: disabled
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffff]
bus: 01 index 0 io port: [5000, 5fff]
bus: 01 index 1 mmio: [37300000, 383fffff]
bus: 01 index 2 mmio: [30000000, 30ffffff]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [3000, 4fff]
bus: 02 index 1 mmio: [36300000, 372fffff]
bus: 02 index 2 mmio: [31000000, 320fffff]
bus: 02 index 3 mmio: [0, 0]
bus: 03 index 0 io port: [2000, 2fff]
bus: 03 index 1 mmio: [35200000, 362fffff]
bus: 03 index 2 mmio: [32100000, 330fffff]
bus: 03 index 3 mmio: [0, 0]
bus: 04 index 0 io port: [1000, 1fff]
bus: 04 index 1 mmio: [34100000, 351fffff]
bus: 04 index 2 mmio: [33100000, 340fffff]
bus: 04 index 3 mmio: [0, 0]
bus: 05 index 0 mmio: [0, 0]
bus: 05 index 1 mmio: [0, 0]
bus: 05 index 2 mmio: [0, 0]
bus: 05 index 3 io port: [0, ffff]
bus: 05 index 4 mmio: [0, ffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag value 0x5 read from CMOS RAM was invalid
Simple Boot Flag at 0x44 set to 0x1
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 982
io scheduler noop registered (default)
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
pci 0000:00:02.0: Boot video device
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie02: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
pcieport-driver 0000:00:1c.2: setting latency timer to 64
pcieport-driver 0000:00:1c.2: found MSI capability
pci_express 0000:00:1c.2:pcie00: allocate port service
pci_express 0000:00:1c.2:pcie02: allocate port service
pci_express 0000:00:1c.2:pcie03: allocate port service
pcieport-driver 0000:00:1c.3: setting latency timer to 64
pcieport-driver 0000:00:1c.3: found MSI capability
pci_express 0000:00:1c.3:pcie00: allocate port service
pci_express 0000:00:1c.3:pcie02: allocate port service
pci_express 0000:00:1c.3:pcie03: allocate port service
vesafb: framebuffer at 0x20000000, mapped to 0xe0080000, using 1875k, total 7872k
vesafb: mode is 800x600x16, linelength=1600, pages=7
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 100x37
fb0: VESA VGA frame buffer device
vga16fb: initializing
vga16fb: mapped to 0xc00a0000
fb1: VGA16 VGA frame buffer device
hpet_resources: 0xfed00000 is busy
Driver 'sd' needs updating - please use bus_type methods
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x60a0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x60a8 irq 15
ata2.00: ATA-5: SSDPAMM0008G1EA, Ver2.I0H, max UDMA/66
ata2.00: 15761088 sectors, multi 0: LBA 
ata2.00: configured for UDMA/66
scsi 1:0:0:0: Direct-Access     ATA      SSDPAMM0008G1EA  Ver2 PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] 15761088 512-byte hardware sectors (8070 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sda] 15761088 512-byte hardware sectors (8070 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 1:0:0:0: [sda] Attached SCSI disk
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUE] at 0x60,0x64 irq 1,12
i8042.c: Warning: Keylock active.
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
NET: Registered protocol family 15
Using IPI No-Shortcut mode
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04771/0xa40000
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio2/input/input1
EXT4-fs warning (device sda1): ext4_fill_super: extents feature not enabled on this filesystem, use tune2fs.

EXT4-fs: sda1: not marked OK to use with test code.
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 268k freed
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
sd 1:0:0:0: Attached scsi generic sg0 type 0
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
r8169 0000:02:00.0: setting latency timer to 64
r8169 0000:02:00.0: unknown MAC (27a00000)
eth0: RTL8169 at 0xe0026000, 00:1e:68:8c:23:ad, XID 24a00000 IRQ 219
ACPI: WMI: Mapper loaded
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 16, io mem 0x38544400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
USB Universal Host Controller Interface driver v3.0
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
ACPI: Power Button (CM) [PWRB]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input4
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
Linux agpgart interface v0.103
ACPI: Lid Switch [LID0]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input5
ACPI: Sleep Button (CM) [SLPB]
ACPI: SSDT 1F380C90, 0239 (r2  PmRef  Cpu0Ist     3000 INTL 20051117)
ACPI: SSDT 1F37FE10, 01C7 (r2  PmRef  Cpu0Cst     3001 INTL 20051117)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 1F380F10, 00D0 (r2  PmRef  Cpu1Ist     3000 INTL 20051117)
ACPI: SSDT 1F37EF10, 0083 (r2  PmRef  Cpu1Cst     3000 INTL 20051117)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI0007:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
Marking TSC unstable due to TSC halts in idle
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.26-jam15 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00006080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: Battery Slot [BAT1] (battery present)
ACPI: AC Adapter [ACAD] (on-line)
usb 1-5: new high speed USB device using ehci_hcd and address 3
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:19/input/input6
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.26-jam15 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
agpgart-intel 0000:00:00.0: Intel 945GME Chipset
agpgart-intel 0000:00:00.0: detected 7932K stolen memory
ACPI: Video Device [OVGA] (multi-head: yes  rom: yes  post: no)
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x20000000
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 17, io base 0x00006060
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
acer-wmi: Acer Laptop ACPI-WMI Extras
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.26-jam15 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
ath5k_pci 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ath5k_pci 0000:03:00.0: setting latency timer to 64
ath5k_pci 0000:03:00.0: registered as 'phy0'
ath5k phy0: Support for RF2425 is under development.
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006040
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-5: configuration #1 chosen from 1 choice
usb 1-5: New USB device found, idVendor=0c45, idProduct=62c0
usb 1-5: New USB device strings: Mfr=2, Product=1, SerialNumber=0
usb 1-5: Product: USB 2.0 Camera
usb 1-5: Manufacturer: Sonix Technology Co., Ltd.
phy0: Selected rate control algorithm 'pid'
ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
sdhci-pci 0000:04:00.0: SDHCI controller found [197b:2382] (rev 0)
sdhci-pci 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
sdhci-pci 0000:04:00.0: setting latency timer to 64
mmc0: SDHCI controller on PCI [0000:04:00.0] using ADMA
sdhci-pci 0000:04:00.2: SDHCI controller found [197b:2381] (rev 0)
sdhci-pci 0000:04:00.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
sdhci-pci 0000:04:00.2: Refusing to bind to secondary interface.
sdhci-pci 0000:04:00.2: PCI INT A disabled
usb 2-1: new low speed USB device using uhci_hcd and address 2
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.26-jam15 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00006020
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: New USB device found, idVendor=046d, idProduct=c00f
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-1: Product: USB-PS/2 Optical Mouse
usb 2-1: Manufacturer: Logitech
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.26-jam15 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: Unknown model for ALC268, trying auto-probe from BIOS...
Linux video capture interface: v2.00
uvcvideo: Found UVC 1.00 device USB 2.0 Camera (0c45:62c0)
input: USB 2.0 Camera as /devices/pci0000:00/0000:00:1d.7/usb1/1-5/1-5:1.0/input/input7
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
mmc0: new SDHC card at address 0002
mmcblk0: mmc0:0002       7917568KiB 
 mmcblk0: p1
usbcore: registered new interface driver hiddev
input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input8
input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
kjournald starting.  Commit interval 30 seconds
EXT3 FS on mmcblk0p1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
loop: module loaded
Adding 530136k swap on /dev/sda2.  Priority:-1 extents:1 across:530136k
coretemp coretemp.0: Unable to read IA32_TEMPERATURE_TARGET MSR
coretemp coretemp.1: Unable to read IA32_TEMPERATURE_TARGET MSR
r8169: eth0: link up
r8169: eth0: link up
wlan0: authenticate with AP 00:18:39:86:f1:9a
wlan0: authenticated
wlan0: associate with AP 00:18:39:86:f1:9a
wlan0: RX AssocResp from 00:18:39:86:f1:9a (capab=0x411 status=0 aid=2)
wlan0: associated
[drm] Initialized drm 1.1.0 20060810
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0
mtrr: no more MTRRs available


-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
