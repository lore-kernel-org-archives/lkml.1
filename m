Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYD2Sch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYD2Sch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYD2Sc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:32:29 -0400
Received: from mga10.intel.com ([192.55.52.92]:36459 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752534AbYD2Sc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:32:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,723,1199692800"; 
   d="scan'208";a="322686746"
Message-ID: <481769B4.9000005@linux.intel.com>
Date: Tue, 29 Apr 2008 11:32:20 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jeff Garzik <jeff@garzik.org>,
       James Bottomley <james.bottomley@steeleye.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, David Miller <davem@davemloft.net>
Subject: background on ioremap, cacheing, cache coherency on x86
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amids some heavy flaming, it's clear that there is a lot of confusion on how
cachability and ioremap cooperate on x86 on a hardware level, and how this
interacts with Linux (both before 2.6.24 and in current trees).
This email tries to describe the various aspects and constraints involved,
in the hope to take away the confusion and to make clear how Linux works,
both in the past and going forward.
(without degrading to flames again, lets keep THIS thread technical please)

Cachable.. what does it mean?
-----------------------------
For the CPU, if a piece of memory is cachable (how it decides that I'll cover
later), it means that
1) The CPU is allowed to read the data from the memory into its cache at any
    point in time, even if the program will never actually read the memory.
    Hardware prefetching, speculative execution etc etc all can cause the cpu
    to get content into its caches if it's cachable. The CPU is also allowed
    to hold on to this content as long as it wants, until something in the
    system forces the CPU to remove the cache line from its cache.
2) The CPU is allowed to write the contents from its cache back to memory at
    any point in time, even if the program will never actually write to the
    cacheline; the later is the result of speculation etc; what will be written
    in that case is the clean cacheline that was in the cache.
    (AMD cpus seem to do this relatively aggressively; Intel cpus may or may
    not do this)
3) The CPU is allowed to write a full cacheline without having read it; it
    will just get the cacheline exclusive in this case.
4) The CPU is allowed to hold on to written cache lines without writing them
    back for as long as it wants, until something in the cache coherency
    protocol forces a commit or discard.

Practically speaking this means that a memory location that the cpu sees as
cachable, needs to be on some device that takes part of the cache coherency
device or a very special case (such as ROM) that:
  - The device must be readable.
  - Writing must be idempotent, ordering-independent and access-size-independent.
  - Writing back a read value must be safe and side-effect-free.
  - Any side effects due to a write can be delayed until the data is explicitly
    flushed by software.

Anything else will lead to data loss (read: corruption) or other "very weird",
unpredictable things will happen.
Regular memory is cache coherent, and DMA (with a few very special cases as
exception that are beyond the scope of this document) is cache coherent with
the CPU on a PC. PCI MMIO regions and other similar pieces of device memory
are NOT cache coherent.

Uncachable.. what does that mean?
---------------------------------
Uncachable is easier than cachable for the CPU... in short it means that
1) every read will go over the bus and will come from the actual device,
    not the cpus caches.
2) every write will go over the bus and will bypass the cpus caches.
    Note: On PCI, the PCI chipset is allowed to buffer (post) such writes and
    group them into bigger transactions before devices actually see the data.
    However reads will not pass writes.

Write combining.. what does that mean?
--------------------------------------
Write combining is like Uncachable in many ways, with one exception:
1) The CPU is allowed to buffer and group consecutive writes into bigger IOs.
This feature is used mostly by graphics cards for accelerating bigger copies
into its video memory.
What happens if you read the data that is being buffered is somewhat undefined,
however if your cpu supports "self snooping" ("ss" in /proc/cpuinfo) then the
expected thing happens (you get the data you just wrote).

Mixing.. can we do that?
------------------------
What if you mix the two rules from above for the same piece of physical memory?

The short answer is:  Don't do that!

The longer answer is: Many weird things can happen, including CPU or chipset
lockups.  The Software Developer Manuals from various CPU vendors explain how
you can safely do transitions from one to the other.



How does something become cachable / uncachable?
------------------------------------------------
So far so good, easy stuff. However, now it gets more tricky (and more x86
specific).
First of all, there are some CPU configuration bits (cr registers and MSRs)
that allow you to turn on/off caching entirely. The BIOS will turn these on,
and Linux will pretty much never touch these so I'll leave them out for the
rest of this discussion, and just assume these are enabled.

There are 2 major factors that decide if a (virtual) memory location is
considered cachable by the CPU:
1) The Page Table bits for the virtual memory location
2) Memory Type Range Registers for the physical memory location

The page table bits can set, in practice, 4 different settings for a piece of
memory: (these are often called PAT bits)
1) Cachable (default)
2) Write Combining
3) Weak Uncachable (UCminus)
4) Strong Uncachable

The MTRR can also set different settings
1) Cachable
2) Write combining
3) Uncachable

If both the page table and the MTRR agree, things are easy. But what if they
disagree?
The table below describes the end result for the various combinations

      |  UC  UC- WC  WB   [PAT]
  ----+----------------
  UC  |  UC  UC  WC  UC
  WC  |  UC  WC  WC  WC
  WB  |  UC  UC  WC  WB
[MTRR]

UC   - (Strong) Uncachable
UC-  - Weak uncachable
WC   - Write Combining
WB   - Write Back (Cachable)


What happens on PCs
-------------------
On PCs, if the BIOS is not too buggy, the BIOS will set up the MTRRs such that
all regular memory is cachable, and that all MMIO space is set to uncachable,
with a possible exception for the video memory that may be set to write combining.
Linux will not remove MTRRs the BIOS sets up.
(this tends to give problems in SMM mode or with suspend/resume).

The Operating system tends to use the page table bits to control cachability,
and Linux (well X.org) will add MTRRs for the graphics memory if the BIOS did
not set this up as write combining and there are some free MTRRs left for
programming.

The net effect of this is (see the table above) that MMIO space is not cachable
by the cpu, the only thing that the OS can do is turn uncachable space into
write combining space for a few special cases.

Regular memory is Cachable; the OS can decide to mark pieces of it uncachable;
this may be useful for very specific hardware tricks and for things like AGP textures
or video cards that use main memory as video ram.


ioremap - past, present and future
----------------------------------
ioremap() is the Linux API to "map" memory on devices (such as MMIO space on
PCI cards) into the kernels address space so that Linux can then access this
memory, generally from the device driver.

Upto Linux version 2.6.24, Linux would not set any special cache bits in the
page table for ioremap()d device memory on x86. In practice, as long as the
BIOS was not too buggy, the MTRRs would take care of making sure that card
memory was accessed in an uncached way (see the table). Occasionally a
BIOS would  be buggy and weird things would happen. Other types of memory
that get ioremap'd... depends on the BIOS.

Quite some time ago, an API function called "ioremap_uncached()" was introduced
that, in theory, should be used when the device driver knows he only wants
uncachable memory mapping. Use of this API is limited to a few handful of
drivers, even though the vast majority really wants (and gets) uncachable memory.

Recently, the behavior of ioremap() has changed: ioremap() now explicitly sets
the (weak) uncachable bits in the page table; an ioremap_cached() function can
be used by the handful of places that really wants a cached mapping (but beware
of the caching rules! PCI MMIO space shouldn't use this unless it's a ROM! See
the rules above)

There are several reasons for this change:
1) MTRRs are a problem and Linux is, over the next kernel releases, going to
    depend less and less on them (the PAT work is a step in that direction).
2) Depending on the virtue of the BIOS is a trap, especially since there are
    good ways to make sure we get the type we want (uncachable).
3) Almost all users want uncachable memory, even though they don't explicitly
    ask for it.
4) Most other architectures already make ioremap() explicitly uncached.


The rest of the story was a large flamewar that I'm not going to repeat here;
the intention for this text was to make explicit what behavior is happening
so that everyone can understand how this stuff works.
