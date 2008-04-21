Return-Path: <linux-kernel-owner+w=401wt.eu-S1759950AbYDUDjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950AbYDUDjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 23:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbYDUDjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 23:39:39 -0400
Received: from rs35.luxsci.com ([66.216.127.90]:60156 "EHLO rs35.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586AbYDUDji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 23:39:38 -0400
Message-ID: <480C0C5B.2050403@firmworks.com>
Date: Sun, 20 Apr 2008 17:39:07 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andres Salomon <dilinger@queued.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419031024.GC3503@nineveh.local>	<20080418202925.b18452c5.akpm@linux-foundation.org>	<20080419092544.378664a8@ephemeral>	<20080419133909.5aa6b63e@ephemeral>	<86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>	<480B321B.5020802@zytor.com> <20080420135948.61bdb4c9@ephemeral> <480B8E9F.8000701@firmworks.com> <480B95B4.5030203@zytor.com>
In-Reply-To: <480B95B4.5030203@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Mitch Bradley wrote:
>>
>> The x86 architecture doesn't make this problem easy.
>>
>
> [long rant about the x86 architecture]
>
> It would be more useful if you described the actual defined entry 
> conditions from OpenFirmware look like, including if they are 
> well-defined for all OF implementations or only for OLPC.
>
>     -hpa

Fair enough...

To get the second subquestion out of the way:  At the present time, on 
the x86 architecture, "all OF implementations" and "OLPC" are 
effectively the same.  I am unaware of any other x86 OFW deployments in 
current use.  There have been some in the past, on bespoke systems such 
as Network Appliance servers and at least one settop box, but those have 
fallen by the wayside as those companies have shifted over to commodity 
PC hardware.  The current market status quo is that x86 boards are 
primarily designed for Windows, and thus must run legacy BIOS, with some 
recent migration to EFI, neither of which are open source in the strong 
sense.  While I would like to see more OFW penetration into the larger 
x86 market, I don't really expect it.  x86 motherboard manufacturing is 
becoming more and more difficult as signal speeds increase, leading to a 
decline in the number of manufacturers.  The existing manufacturers 
depend on Windows for sales volume and their internal procedures and 
working knowledge are based on legacy BIOS.

Once upon a time, we had an OFW "binding" document that stipulated the 
interface conditions, with the intention of making that "standard" 
across all OFW-on-x86 systems.  However, by the time OLPC came around, 
there were no other systems to consider, so I felt free to make some 
changes in the interface.  I ended up choosing an ABI that resulted in a 
simple (in the sense of not much code, and no complex state transitions) 
interface with 2.6 Linux kernels.

The interface defined below is not inherently OLPC-specific - it would 
be suitable for any ia32 system that used OFW.  (At a higher level, the 
set of OFW callback functions is architecture-neutral; in this message I 
am focusing on the very low-level details of the ia32 ABI)

The system conditions for the OFW to Linux kernel transition are as follows:

a) OFW can load the Linux kernel from either bzimage format or ELF 
format (either uncompressed or zlib-compressed.)  If the kernel is in 
ELF format with symbols, OFW can do symbolic kernel debugging.  Further 
discussion will focus on bzimage format, as that is what OLPC uses and 
is also the "greased path" for kernel builds.

b) OFW loads the bzimage kernel at 0x100000 and the ramdisk image, if 
any, at 0x800000.

c) OFW runs in 32-bit protected mode with paging enabled.  There are two 
reasons for this.  First, it lets OFW locate itself at the top of both 
physical memory space and virtual address space, the only places that 
are truly "out of the way".  It also lets Linux call back into OFW with 
a minimum of bother (similarly helping with the OFW-debugs-Linux scenario).

d) OFW itself lives at the top of the virtual address space, just below 
the ROM.  (The ROM is mapped virtual=physical  for convenience)  OFW 
uses RAM allocated from the top of physical memory, mapped at the 
aforementioned high virtual addresses.  One page directory entry - the 
next to last one - is used for that RAM mapping and also for mapping 
additional miscellaneous I/O devices.  The 8MB frame buffer requires 2 
additional PDEs, just below.  When Linux takes over the display, OFW no 
longer needs the frame buffer mapping, but it is convenient to preserve 
that mapping temporarily while using OFW as a debugger.

e) Low memory - everything except the ~1Meg that OFW lives in - is 
mapped virtual=physical.

f) The code, data, and stack segment descriptors are all for 32-bit 4GB 
linear segments.  (For debugging convenience, OFW initially uses the 
same segment numbers as the Linux kernel, but that is not an ABI 
requirement - callbacks into OFW will work from any 32-bit segments that 
encompass the kernel and OFW virtual address space.)

g) OFW sets up a boot parameter block at 0x90000, with the format as 
defined in include/asm-x86/bootparam.h  .  The block includes the 
cmdline, memory layout information, screen info, and address/length of 
the ramdisk.

h) OFW also includes in the boot parameter block an additional 
information block at OFW_INFO_OFFSET.  That info block contains:
    "OFW " - 4-byte signature string ('O' at byte offset 0, etc)
    __u32 version  - 1
    __u32 callback  - (actually a 32-bit function pointer) address of 
callback function
    __u32 idt    - address of OFW's interrupt descriptor table, in case 
Linux wants to preserve the breakpoint vector

i) OFW transfers control to the bzimage with the processor in the 
following state:
    * interrupts masked off at the interrupt controller and in the flags 
register
    * 32-bit protected mode, CS=0x60, DS=ES=FS=GS=SS=0x68
    * ebx=ecx=edx=ebp=edi=0
    * eax = &callback_function
    * esi = 0x90000 (boot parameter block)
    * esp = 0x90000 (short-lived initial stack starts below boot 
parameter block)
    * eip = 0x100000 (entry address of bzimage)
    * paging enabled, with V=P mapping of physical memory and one high 
pde for OFW, as in (d) and (e) above

j) Linux must save the following information during early startup:
  1) The callback function address - either from the initial value of 
eax or from the OFW info block.
  2) The the next-to-last page directory entry - just the pointer to the 
page table.  The page table itself lives in OFW's reserved memory.

k) When calling back into OFW, Linux must:
  1) Establish a page directory that contains OFW's PDE (saved in j2 
above) and that maps the client interface argument array, including any 
buffer pointers.
  2) Call callback_function with the address of the argument array in 
eax.  (Ordinary 32-bit near call).

For all of the OLPC kernel's current callbacks into OFW, the 
requirements (j2) and (k1) are easily satisfied by "priming" 
swapper_pg_dir with the contents of the current page directory (as 
pointed to by the CR3 register).



