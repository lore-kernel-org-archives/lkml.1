Return-Path: <linux-kernel-owner+w=401wt.eu-S1757686AbYH3XaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbYH3XaB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 19:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755535AbYH3X3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 19:29:52 -0400
Received: from web82106.mail.mud.yahoo.com ([209.191.84.219]:34732 "HELO
	web82106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755414AbYH3X3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 19:29:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=2ChG2XFrA29Pg5ohCGyssZiulAws2H7WT3ULUHYjPyDM6MNW7Wah9BiIhZmTWlzCk04RkLgA6YX2/wzsydewBoaZZFEA/baoTrreYEFg4G724PKtuPNPLvQSSt/cgSC5bfWEARAZboNGrQgfLYj1jdf5HnZA57IY5cNjHYu2Io8=;
X-YMail-OSG: XRCzHAsVM1mYJKm0afyhTZpshIn4C8x_egNPalTHSIxA4VmGKfFDAekjY1Uq16lz3Q--
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218.2
Date: Sat, 30 Aug 2008 16:29:50 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <368766.37978.qm@web82106.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> David, can you test those two patches on top of linus tree?
> 
> YH

Yinghai,

I believe I have applied those patches correctly -- but I have only
been using git since Aug. 4, so please verify that I have done what
you asked.

My git tree was originally created by cloning Linus' linux-2.6 tree.  
I ran into some difficulty applying the patches, but I found a way to
allow them to apply:

===== SHELL SESSION =============
$ git apply --verbose --check ../split_e820_reserve.patch 
Checking patch arch/x86/kernel/e820.c...
Checking patch arch/x86/pci/i386.c...
Checking patch include/asm-x86/e820.h...

$ git apply --verbose ../split_e820_reserve.patch
Checking patch arch/x86/kernel/e820.c...
Checking patch arch/x86/pci/i386.c...
Checking patch include/asm-x86/e820.h...
Applied patch arch/x86/kernel/e820.c cleanly.
Applied patch arch/x86/pci/i386.c cleanly.
Applied patch include/asm-x86/e820.h cleanly.

$ git apply --verbose --check ../split_e820_reserve_xx1.patch 
Checking patch arch/x86/kernel/e820.c...
Checking patch include/linux/ioport.h...
error: while searching for:

extern int request_resource(struct resource *root, struct resource *new);
extern int release_resource(struct resource *new);
extern int insert_resource(struct resource *parent, struct resource *new);
extern int allocate_resource(stru
error: patch failed: include/linux/ioport.h:108
error: include/linux/ioport.h: patch does not apply
Checking patch kernel/resource.c...
error: while searching for:
EXPORT_SYMBOL(allocate_resource);

/**
 * insert_resource - Inserts a resource in the resource tree
 * @parent: parent of the new resource
 * @new: new resource to insert
 *
 * Returns 0 on success, -EBUSY if the resource can't be ins
error: patch failed: kernel/resource.c:363
error: kernel/resource.c: patch does not apply
=================================


Looking over that second patch, I saw that it changes kernel/resource.c.
But I was watching the messages between you and Linus last night, and
I believe he made a commit touching the same file:

=================================
$ git show | head
commit bef69ea0dcce574a425feb0a5aa4c63dd108b9a6
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Aug 29 20:18:31 2008 -0700

    Resource handling: add 'insert_resource_expand_to_fit()' function
    
    Not used anywhere yet, but this complements the existing plain
    'insert_resource()' functionality with a version that can expand the
    resource we are adding in order to fix up any conflicts it has with
    existing resources.
=================================


So I decided to try applying the patches against the tree as it was
before bef69ea0...:

=================================
$ git checkout -f HEAD^
Note: moving to "HEAD^" which isn't a local branch
If you want to create a new branch from this checkout, you may do so
(now or later) by using -b with the checkout command again. Example:
  git checkout -b <new_branch_name>
HEAD is now at 00aeb42... Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6

$ git apply --verbose --check ../split_e820_reserve.patch 
Checking patch arch/x86/kernel/e820.c...
Checking patch arch/x86/pci/i386.c...
Checking patch include/asm-x86/e820.h...

$ git apply --verbose ../split_e820_reserve.patch 
Checking patch arch/x86/kernel/e820.c...
Checking patch arch/x86/pci/i386.c...
Checking patch include/asm-x86/e820.h...
Applied patch arch/x86/kernel/e820.c cleanly.
Applied patch arch/x86/pci/i386.c cleanly.
Applied patch include/asm-x86/e820.h cleanly.

$ git apply --verbose --check ../split_e820_reserve_xx1.patch 
Checking patch arch/x86/kernel/e820.c...
Checking patch include/linux/ioport.h...
Checking patch kernel/resource.c...

$ git apply --verbose ../split_e820_reserve_xx1.patch 
Checking patch arch/x86/kernel/e820.c...
Checking patch include/linux/ioport.h...
Checking patch kernel/resource.c...
Applied patch arch/x86/kernel/e820.c cleanly.
Applied patch include/linux/ioport.h cleanly.
Applied patch kernel/resource.c cleanly.
=================================


The kernel built from this set of changes runs perfectly, so if I
have handled the patches correctly then I have to thank you yet
again for a nice job!

Here are some excerpts from 'dmesg' and /proc/timer_list in case you
are interested:

$ dmesg
Linux version 2.6.27-rc5.split-e820-patches (dawitbro@fileserver) (gcc version 4.3.1 (Debian 4.3.1-9) ) #1 SMP Sat Aug 30 18:25:30 EDT 2008
[...]
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000077fe0000 (usable)
 BIOS-e820: 0000000077fe0000 - 0000000077fe3000 (ACPI NVS)
 BIOS-e820: 0000000077fe3000 - 0000000077ff0000 (ACPI data)
 BIOS-e820: 0000000077ff0000 - 0000000078000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
last_pfn = 0x77fe0 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
 0000000000 - 0077e00000 page 2M
 0077e00000 - 0077fe0000 page 4k
kernel direct mapping tables up to 77fe0000 @ 8000-c000
last_map_addr: 77fe0000 end: 77fe0000
DMI 2.5 present.
ACPI: RSDP 000F7B80, 0024 (r2 RS690 )
ACPI: RSDT 77FE3040, 0038 (r1 RS690  AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 77FE30C0, 0074 (r1 RS690  AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 77FE3180, 4B0B (r1 RS690  AWRDACPI     1000 MSFT  3000000)
ACPI: FACS 77FE0000, 0040
ACPI: SSDT 77FE7DC0, 028A (r1 PTLTD  POWERNOW        1  LTP        1)
ACPI: HPET 77FE80C0, 0038 (r1 RS690  AWRDACPI 42302E31 AWRD       98)
ACPI: MCFG 77FE8140, 003C (r1 RS690  AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 77FE7D00, 0068 (r1 RS690  AWRDACPI 42302E31 AWRD        0)
[...]
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[...]
hpet clockevent registered
[...]
calling  pci_arch_init+0x0/0x4b
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x4b returned 0 after 6 msecs
[...]
calling  pnpacpi_init+0x0/0x91
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:0d: mem resource (0xfed00000-0xfed000ff) overlaps 0000:00:14.0 BAR 1 (0xfed00000-0xfed003ff), disabling
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0x91 returned 0 after 3 msecs
[...]
calling  hpet_late_init+0x0/0xf5
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 32-bit timers, 14318180 Hz
initcall hpet_late_init+0x0/0xf5 returned 0 after 0 msecs
[...]
calling  pnp_system_init+0x0/0x16
system 00:01: ioport range 0x4100-0x411f has been reserved
system 00:01: ioport range 0x228-0x22f has been reserved
system 00:01: ioport range 0x40b-0x40b has been reserved
system 00:01: ioport range 0x4d6-0x4d6 has been reserved
system 00:01: ioport range 0xc00-0xc01 has been reserved
system 00:01: ioport range 0xc14-0xc14 has been reserved
system 00:01: ioport range 0xc50-0xc52 has been reserved
system 00:01: ioport range 0xc6c-0xc6d has been reserved
system 00:01: ioport range 0xc6f-0xc6f has been reserved
system 00:01: ioport range 0xcd0-0xcd1 has been reserved
system 00:01: ioport range 0xcd2-0xcd3 has been reserved
system 00:01: ioport range 0xcd4-0xcdf has been reserved
system 00:01: ioport range 0x4000-0x40fe has been reserved
system 00:01: ioport range 0x4210-0x4217 has been reserved
system 00:01: ioport range 0xb10-0xb1f has been reserved
system 00:07: ioport range 0x4d0-0x4d1 has been reserved
system 00:07: ioport range 0x220-0x225 has been reserved
system 00:07: ioport range 0xb00-0xb0f has been reserved
system 00:0c: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0d: iomem range 0xf0000-0xfffff could not be reserved
system 00:0d: iomem range 0x77fe0000-0x77ffffff could not be reserved
system 00:0d: iomem range 0xffff0000-0xffffffff could not be reserved
system 00:0d: iomem range 0x0-0x9ffff could not be reserved
system 00:0d: iomem range 0x100000-0x77fdffff could not be reserved
system 00:0d: iomem range 0x78000000-0x7fffffff has been reserved
system 00:0d: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0d: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0d: iomem range 0xfff80000-0xfffeffff could not be reserved
initcall pnp_system_init+0x0/0x16 returned 0 after 0 msecs
[...]
calling  hpet_init+0x0/0x6d
hpet_resources: 0xfed00000 is busy
initcall hpet_init+0x0/0x6d returned 0 after 1 msecs
[...]


$ grep -B 1 -A 5 hpet /proc/timer_list
Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   149983003520
 min_delta_ns:   3352
 mult:           61496115
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000000
tick_broadcast_oneshot_mask: 00000000


Thanks,
Dave W.
