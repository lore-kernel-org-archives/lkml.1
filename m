Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbXEXWmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbXEXWmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbXEXWmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:42:40 -0400
Received: from mail.epcp.de ([212.6.249.86]:59412 "EHLO mail.epcp.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbXEXWmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:42:38 -0400
X-Greylist: delayed 1878 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 May 2007 18:42:38 EDT
From: "elmar gerdes" <elmar.gerdes@epcp.de>
Date: Fri, 25 May 2007 00:09:42 +0200
To: linux-kernel@vger.kernel.org
Subject: tmpfs/ramfs with no swap oopses on Au1550/mips(el)
Message-ID: <20070524220941.GA17156@engel-kg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,


I am experiencing oopses when using tmpfs heavily on an embedded

	Au1550-based board (MIPS 32-bit core, little-endian, 128MB RAM).

Everything I need seemed to work (PCI, USB, JFFS2, busybox, tools like
mtools, WLAN, network, ...).  The system currently uses busybox-1.00 and
glibc-2.3.2.  Everything has been compiled using mipsel-linux-gcc 3.3.3
created from Dan Kegel's crosstool-0.38.


But when I use tmpfs heavily using mcopy or appending to a file using

	cat filename >> /tmp/xxx

I either get "No space left on device" (kernel 2.6.21-rc7) which is what
I expect, or I get a sequence of oopses (2.6.14, 2.6.18.2, 2.6.19.2).
When getting "No space left on device", inserting a USB-stick might then
cause an oops ("Bad page state in process 'hotplug'").


I have seen various types of oopses, but they all(?)/usually start with
one like these:

  CPU 0 Unable to handle kernel paging request at virtual address\
      5da7bee4, epc == 801795c0, ra == 802b61c8

  CPU 0 Unable to handle kernel paging request at virtual address\
      00000000, epc == 8015b728, ra == 8015ba20

  CPU 0 Unable to handle kernel paging request at virtual address\
      000000c4, epc == 80160b58, ra == 801604c4

  CPU 0 Unable to handle kernel paging request at virtual address\
      000000c4, epc == 80160b58, ra == 801604c4

  CPU 0 Unable to handle kernel paging request at virtual address\
      000000d4, epc == 8015e724, ra == 8015dee8

  CPU 0 Unable to handle kernel paging request at virtual address\
      00000104, epc == 801748bc, ra == 80174844

  CPU 0 Unable to handle kernel paging request at virtual address\
      00000000, epc == 80159858, ra == 80159b70

  CPU 0 Unable to handle kernel paging request at virtual address\
      24ba4d88, epc == 801ace7c, ra == 801b1e84

  CPU 0 Unable to handle kernel paging request at virtual address\
      00000128, epc == 80155628, ra == 8015575c



I tested this using kernel 2.6.19.2, 2.6.18.2, 2.6.14, and 2.6.21-rc7
like this:



# uname -a
Linux mybox 2.6.18.2 #1 Tue May 22 16:58:12 CEST 2007 mips unknown


df(1) under 2.6.18.2 does not show /var, being 40M of tmpfs as 2.6.19.2
would tell us.  /tmp is a symlink to /var/tmp.


Filling tmpfs:

# cat /lib/libc.so.6 >> /tmp/abc
# cat /lib/libc.so.6 >> /tmp/abc
# cat /lib/libc.so.6 >> /tmp/abc
# cat /lib/libc.so.6 >> /tmp/abc
# cat /lib/libc.so.6 >> /tmp/abc
# cat /lib/libc.so.6 >> /tmp/abc

# ll -h /tmp/abc*
-rw-r--r--    1 root     root         9.1M Jan  1 00:02 /tmp/abc

# cp /tmp/abc /tmp/abc2
# cp /tmp/abc /tmp/abc3
# cp /tmp/abc /tmp/abc4

# ll -h /tmp/abc*
-rw-r--r--    1 root     root         9.1M Jan  1 00:02 /tmp/abc
-rw-r--r--    1 root     root         9.1M Jan  1 00:02 /tmp/abc2
-rw-r--r--    1 root     root         9.1M Jan  1 00:02 /tmp/abc3
-rw-r--r--    1 root     root         9.1M Jan  1 00:02 /tmp/abc4

# cp /tmp/abc /tmp/abc5



On 2.6.14, 2.6.18.2, and 2.6.19.2 I get this:


CPU 0 Unable to handle kernel paging request at virtual address 00000000,\
   epc == 80159858, ra == 80159b70
Oops[#1]:
Cpu 0
$ 0   : 00000000 1000fc00 8f818018 810a1458
$ 4   : 00100100 00000000 00200200 803c2054
$ 8   : 0000475d 00000001 00000001 fffffff8
$12   : 0055a000 00000000 00001000 03200008
$16   : 803c2028 1000fc01 803c2048 803c2028
$20   : 00000000 00000000 000280d2 00000000
$24   : 00000000 2ac6342c
$28   : 804c6000 804c7d90 803c2550 80159b70
Hi    : 307d2bf7
Lo    : a60e8300
epc   : 80159858 buffered_rmqueue+0x9c/0x1f4     Not tainted
ra    : 80159b70 get_page_from_freelist+0x10c/0x134
Status: 1000fc02    KERNEL EXL
Cause : 0080000c
BadVA : 00000000
PrId  : 03030200
Modules linked in: aes blowfish llc vfat fat
Process cp (pid: 853, threadinfo=804c6000, task=804d2500)
Stack : 804d2500 00000000 00000000 00000000 803c2550 00000000 00000000 00000000
        00000044 00000000 00000004 80159b70 100d0eb0 87b54e60 00000001 802327fc
        00000044 100cf050 803c2550 804d2500 000280d2 87c8abc8 00000000 00000000
        803c2550 00000558 00000010 80159c00 000280d2 80170d28 801536ac 801549a0
        00001000 386d4434 80704880 00000000 00000000 87c8abc8 87c8ac28 00000000
        ...
Call Trace:
 [<80159b70>] get_page_from_freelist+0x10c/0x134
 [<802327fc>] radix_tree_insert+0x190/0x1e0
 [<80159c00>] __alloc_pages+0x68/0x2fc
 [<80170d28>] shmem_swp_alloc+0xb4/0x254
 [<801536ac>] unlock_page+0x68/0xd8
 [<801549a0>] file_read_actor+0x0/0x100
 [<80171d94>] shmem_getpage+0x234/0x65c
 [<80172824>] shmem_file_write+0x160/0x2b0
 [<80172d08>] shmem_file_read+0x70/0x80
 [<8017a1d4>] vfs_write+0xd4/0x1a0
 [<801340f0>] update_process_times+0x58/0x90
 [<801340d4>] update_process_times+0x3c/0x90
 [<8017a394>] sys_write+0x54/0xa0
 [<8010d380>] stack_done+0x20/0x3c


Code: 8c650004  34840100  34c60200 <aca20000> ac450004  ac640000\
   ac660004  8e020020  2472ffe8
Break instruction in kernel code[#2]:
Cpu 0
(((oops #2 follows)))

Code: 00000040  080579ca  8cc300d4 <0000800d> 080579bf  00000000\
   27bdffe8  afb00010  afbf0014
Fixing recursive fault but reboot is needed!
Unhandled kernel unaligned access[#3]:
Cpu 0
(((oops #3 follows)))

Code: 30630001  14600044  00000000 <8c820000> 000211c2  30420001\
   1040003c  00000000  8c90001c
Break instruction in kernel code[#4]:
Cpu 0
(((oops #4 follows)))

Code: 0000800d  0805d97b  00000000 <0000800d> 0805d979  8ca20018\
   0805d973  8ca5000c  27bdffe0
Kernel panic - not syncing: Attempted to kill init!
 Break instruction in kernel code[#5]:
Cpu 0
(((oops #5 follows)))

Code: 8fb00010  03e00008  27bd0020 <0000800d> 0805d9c7  8c840018\
   0805d9c1  8c84000c  03e00008
Kernel panic - not syncing: Aiee, killing interrupt handler!
(((no more messages)))



On 2.6.21-rc7 I get this:

Bad page state in process 'hotplug'
page:8100cd80 flags:0x00000000 mapping:00000000 mapcount:1 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
Call Trace:
[<80109964>] dump_stack+0x8/0x34
[<8015aa1c>] bad_page+0x6c/0xb0
[<8015ba50>] free_hot_cold_page+0x1b8/0x1c8
[<8015ba70>] free_hot_page+0x10/0x1c
[<8015ff38>] __page_cache_release+0x138/0x2ec
[<8016020c>] put_page+0x68/0xd4
[<80157398>] filemap_nopage+0x368/0x578
[<8016b930>] do_no_page+0x90/0x470
[<8016c118>] __handle_mm_fault+0x168/0x3dc
[<8010e2c0>] do_page_fault+0x100/0x360
[<80103a80>] ret_from_exception+0x0/0x20

Bad page state in process 'hotplug'
page:8100cd80 flags:0x00080000 mapping:00000000 mapcount:0 count:0
Trying to fix it up, but a reboot is needed
(((same backtrace as before, then
CPU 0 Unable to handle kernel paging request at virtual address\
    00100104, epc == 8015adc4, ra == 8015ba34
(((further messages)))



Some thoughts on this:

 - I can reproduce the oops whether root is a JFFS2 partition or
   NFS-root, so I expect that no MTD/JFFS2-stuff is involved.

 - Before I used 40M of tmpfs, I had 64M (of the 128M of RAM).  Filling
   that tmpfs partition lead to the oops when about 40M were reached.
   Using 32M of tmpfs leads to "No space left on device" (as was seen
   for kernel 2.6.21-rc7).  But inserting a USB-stick can already
   provoke the oops after "No space left"...

 - I tried (a) ramfs and (b) a large ramdisk instead of tmpfs, as I
   expected that the missing swap (as backing store) for tmpfs to be the
   reason.  But both lead to oopses.  So I expect that the missing swap
   is not the reason.

 - Since swap seems to not be involved, I expect that commit
   6ebba0e2f56ee77270a9ef8e92c1b4ec38e5f419 ([MIPS] Fix swap entry for
   MIPS32 36-bit physical address) is not involved either.

 - I could not reproduce the oopses on a x86 system, so I think this
   could/should be mips-specific.



Does someone have an idea on how to fix this?


Thank you

	Elmar

