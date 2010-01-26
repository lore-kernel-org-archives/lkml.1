Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175Ab0AZPGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab0AZPGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 10:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067Ab0AZPGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 10:06:30 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:42418 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab0AZPG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 10:06:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=L3ovqVFF7WdJ+euLXDdq3lsZNHyII5HpOgEya+MAJAR3+Yjd6Ng2UWlYGpNNeBhqLJ
         w1HRB+gHiAz+fmRUJVr4ytzNhN4bPzdXS5AycNDfkWouaJSZsiRSHS18wgo3i/SYH4hM
         kR6EN/dtzZ2JPZs91v2/7ZeinqyU0V0haAG5k=
MIME-Version: 1.0
Date: Tue, 26 Jan 2010 15:06:27 +0000
Message-ID: <2573e5e41001260706y5beae0dbj394412fbed130e9a@mail.gmail.com>
Subject: NUMA Enumeration and Memory Zone design
From: Luciann Bennet <gravaera@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gravaera@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A warm salutation to the newsgroup and general linux kernel
development community. I am new to newsgroups, and have only (for now)
come to present an elegant design idea for the linux kernel, based on
my own private design.

A simple outline:

You can fully abstract all memory region (zone as the linux kernel
refers to them) specifics for a particular architecture/chipset setup
in runtime code with little kernel image bloat by using the following:

Take a header, chipset_memory.h:
//--Begin chipset_memory.h
//--The snippet is tab indented; I'm not sure how it will display after mailing.

#define CHIPSET_MEMORY_N_SPECIAL_REGIONS 2

struct memoryReservedRangeMapEntry_t {
	//The members in this struct must of course be of absolutely
unambiguous alignment since they will be
	//parsed via pointer arithmetic, much like the multibootv1 memory
map, for example.
	uintptr_t	startPAddr, nFramesForward;
};

struct memorySpecialRegionMapEntry_t {
	uintptr_t	startPhysAddr, size, nReservedRanges;
	memoryReservedRangeMapEntry_t	*reservedRangeMap;
};
//--End header snippet.

The #define at the top tells how many separate bitmaps/stacks (i.e:
separate regions or 'zones') to generate at runtime. This is of course
a static value, since for any architecture/chipset combination, the
zone information would be known at compile time.

memorySpecialRegionMapEntry_t is used to indicate a single zone for
special frame allocations, such as ISA-DMA, etc. Any build of the
kernel may indicate how many zones it needs by defining an array of N
of these structs, such that the Physical Memory Manager can simply
parse the array at runtime, to determine the number of zones to eb
generated.

Within any zone, there may be known reserved regions, such as, for
example, on x86, if you have a 'lowmem' zone for the 1st 1MB, you
would want to map the 1st physical frame as a known reserved region,
or the VGA framebuffer, etc.

So the pointer member points to, of course, a
memoryReservedRangeMapEntry array, and the number of reserved ranges
for any zone in the zone array is given in the array index. The MM
parses this reserved range array via pointers, obviously such that the
1st reserved range entry == 4B on a 32 bit arch, 8B on a 64 bit arch,
and the reserved ranges are given using their start physical address,
and then the number of physical frames forward from there. (A simple
PAGING_PAGE_SIZE token for every arch would easily make this
architecture independent.)

The idea is to have a huge super physical memory structure, (a huge
bitmap, or other system which is the 'default' PMM structure which
will detail memory for all of the machine, and then create extra
bitmaps/other structures for zones. So if you define 2 zones, you'll
end up with those two, plus a third for the default physical address
space.

So in order for an architecture to be ported, and not have to modify
the kernel's already existing zone configuration, and make the kernel
itself dynamic in the way it handles zones, one simply provides, for
any architecture/chipset combination a C source file with the
following:

//--ibm_pc_zones.c
//--This is a paradigm example everyone can relate to: an x86 setup
//--The way I have chosen to do this is to have 3 zones for x86: (thus
the use of 2 for the N_SPECIAL_REGIONS token)
//--One for low memory, then another for the next 15MB up to the 16MB
mark for ISA-DMA, and the other
//--for all the rest of physical memory.
extern struct memoryReservedRangeMapEntry_t lowMemReservedMap[],
dmaRegionReservedMap[];

struct memorySpecialRegionMapEntry_t	platform_memory_regions[CHIPSET_MEMORY_N_SPECIAL_REGIONS]
=
{
	{
		//Low memory zone, start phys. addr, and size
		0x0, 0x100000,
		//number of reserved ranges:
		2,
		lowMemReservedMap
	},
	{
		//DMA Region
		0x100000, 0xF00000
		1,
		dmaRegionReservedMap
	}
};

//--The kernel can now look for this structure and parse it and auto
generate zones at runtime. Much more elegant.
//--Now to define the reserved ranges for each zone:
extern struct memoryReservedRangeMapEntry_t lowMemReservedMap[2] =
{
	//Rsvd region 1: starting at 0x0, and extending for 1 physical frame.
	{ 0x0, 1 },
	{ 0xA0000, 96}
};

struct memoryReservedRangeMapEntry_t dmaRegionReservedMap[1] =
{
	//This is paranoia: In older PCs there was the occasional PC with a
small reserved range just below 16MB.
	{ (0x1000000 - (4 * PAGING_PAGE_SIZE)), 4 }
};
//--End snippet.

So each platform build would have its own version of this, and of
course, one can also define CHIPSET_MEMORY_N_SPECIAL_REGIONS to a zero
value, indicating that there are no special zones for the build. Thus
we get rid of any ugly hacks in the PMM on init.

In the absence of any zones, the PMM simply queries the firmware for
the total amount of RAM, and generates a huge BMP for all of physical
RAM. NUMA abstractions can easily be built on top of this huge bmp,
such that mini-per node PMMs would be given a specific range of bit in
the super BMP to search when allocating on a per-node basis.

In the case of one or more zones being detailed to the kernel, the
super BMP is generated last, and when it is generated, the ranges of
frames that the zones would cover are mapped fully used in the super
BMP, and so any allocations passing through that region of the super
BMP would see all those bits as being used, and thus, bits for a
special zone are not allocated by the general physical memory manager.
The separate per-zone bitmaps can be used to allocate from the zones.

It's cleaner, and probably more efficient. I do understand though,
that implementing such a design would take a lot of changes to the
tree across multiple architectures, etc. *Shrug*. Removing hacks
usually does. But implementing this would make porting significantly
easier and cleaner and removed the #ifdefs within the PMM that are
associated with zone allocation, etc.
