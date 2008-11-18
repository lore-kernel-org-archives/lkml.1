Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbYKRAyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbYKRAyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYKRAyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:54:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbYKRAyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:54:14 -0500
Date: Mon, 17 Nov 2008 19:54:08 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large stack usage in fs code (especially for PPC64)
In-Reply-To: <alpine.LFD.2.00.0811171309580.18283@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0811171936480.26123@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0811171508300.8722@gandalf.stny.rr.com> <alpine.DEB.1.10.0811171557370.26123@gandalf.stny.rr.com> <alpine.LFD.2.00.0811171309580.18283@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 17 Nov 2008, Linus Torvalds wrote:
> 
> I do wonder just _what_ it is that causes the stack frames to be so 
> horrid. For example, you have
> 
> 	 18)     8896     160   .kmem_cache_alloc+0xfc/0x140
> 
> and I'm looking at my x86-64 compile, and it has a stack frame of just 8 
> bytes (!) for local variables plus the save/restore area (which looks like 
> three registers plus frame pointer plus return address). IOW, if I'm 
> looking at the code right (so big caveat: I did _not_ do a real stack 
> dump!) the x86-64 stack cost for that same function is on the order of 48 
> bytes. Not 160.

Out of curiosity, I just ran stack_trace on the latest version of git 
(pulled sometime today) and ran it on my x86_64.

I have SLUB and SLUB debug defined, and here's what I found:

 11)     3592      64   kmem_cache_alloc+0x64/0xa3

64 bytes, still much lower than the 160 of PPC64.

Just to see where it got that number, I ran objdump on slub.o.

000000000000300e <kmem_cache_alloc_node>:
    300e:       55                      push   %rbp
    300f:       48 89 e5                mov    %rsp,%rbp
    3012:       41 57                   push   %r15
    3014:       41 56                   push   %r14
    3016:       41 55                   push   %r13
    3018:       41 54                   push   %r12
    301a:       53                      push   %rbx
    301b:       48 83 ec 08             sub    $0x8,%rsp

Six words pushed, plus the 8 byte stack frame.

  6*8+8 = 56

But we also add the push of the function return address which is another 8 
bytes which gives us 64 bytes.

Here's the complete dump:

[root@bxrhel51 linux-compile.git]# cat /debug/tracing/stack_trace 
        Depth   Size      Location    (54 entries)
        -----   ----      --------
  0)     4504      48   __mod_zone_page_state+0x59/0x68
  1)     4456      64   __rmqueue_smallest+0xa0/0xd9
  2)     4392      80   __rmqueue+0x24/0x172
  3)     4312      96   rmqueue_bulk+0x57/0xa3
  4)     4216     224   get_page_from_freelist+0x371/0x6e1
  5)     3992     160   __alloc_pages_internal+0xe0/0x3f8
  6)     3832      16   __alloc_pages_nodemask+0xe/0x10
  7)     3816      48   alloc_pages_current+0xbe/0xc7
  8)     3768      16   alloc_slab_page+0x28/0x34
  9)     3752      64   new_slab+0x4a/0x1bb
 10)     3688      96   __slab_alloc+0x203/0x364
 11)     3592      64   kmem_cache_alloc+0x64/0xa3
 12)     3528      48   alloc_buffer_head+0x22/0x9d
 13)     3480      64   alloc_page_buffers+0x2f/0xd1
 14)     3416      48   create_empty_buffers+0x22/0xb5
 15)     3368     176   block_read_full_page+0x6b/0x25c
 16)     3192      16   blkdev_readpage+0x18/0x1a
 17)     3176      64   read_cache_page_async+0x85/0x11a
 18)     3112      32   read_cache_page+0x13/0x48
 19)     3080      48   read_dev_sector+0x36/0xaf
 20)     3032      96   read_lba+0x51/0xb0
 21)     2936     176   efi_partition+0x92/0x585
 22)     2760     128   rescan_partitions+0x173/0x308
 23)     2632      96   __blkdev_get+0x22a/0x2ea
 24)     2536      16   blkdev_get+0x10/0x12
 25)     2520      80   register_disk+0xe5/0x14a
 26)     2440      48   add_disk+0xbd/0x11f
 27)     2392      96   sd_probe+0x2c5/0x3ad
 28)     2296      48   driver_probe_device+0xc5/0x14c
 29)     2248      16   __device_attach+0xe/0x10
 30)     2232      64   bus_for_each_drv+0x56/0x8d
 31)     2168      48   device_attach+0x68/0x7f
 32)     2120      32   bus_attach_device+0x2d/0x5e
 33)     2088     112   device_add+0x45f/0x5d3
 34)     1976      64   scsi_sysfs_add_sdev+0xb7/0x246
 35)     1912     336   scsi_probe_and_add_lun+0x9f9/0xad7
 36)     1576      80   __scsi_add_device+0xb6/0xe5
 37)     1496      80   ata_scsi_scan_host+0x9e/0x1c6
 38)     1416      64   ata_host_register+0x238/0x252
 39)     1352      96   ata_pci_sff_activate_host+0x1a1/0x1ce
 40)     1256     256   piix_init_one+0x646/0x6b2
 41)     1000     144   pci_device_probe+0xc9/0x120
 42)      856      48   driver_probe_device+0xc5/0x14c
 43)      808      48   __driver_attach+0x67/0x91
 44)      760      64   bus_for_each_dev+0x54/0x84
 45)      696      16   driver_attach+0x21/0x23
 46)      680      64   bus_add_driver+0xba/0x204
 47)      616      64   driver_register+0x98/0x110
 48)      552      48   __pci_register_driver+0x6b/0xa4
 49)      504      16   piix_init+0x19/0x2c
 50)      488     272   _stext+0x5d/0x145
 51)      216      32   kernel_init+0x127/0x17a
 52)      184     184   child_rip+0xa/0x11

-- Steve

