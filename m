Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYGGMZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYGGMZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbYGGMYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:24:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:34705 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753066AbYGGMYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:24:53 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1+Rv6odmTORBwcBhmA6Kb3ZjfcZSiWkX4Wx5RGnKx
	vMAutPAga4741B
Date: Mon, 7 Jul 2008 14:24:50 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-NTFS-Dev] Oops with corrupted NTFS image
Message-ID: <20080707122450.GC19313@alice>
References: <20080706172147.GA19559@alice> <F2EEF4B5-3E11-480A-93E7-9078BDC578EA@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <F2EEF4B5-3E11-480A-93E7-9078BDC578EA@cam.ac.uk>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.26-rc8 (x86_64)
X-Uptime: 14:23:46 up 1 day,  1:34,  1 user,  load average: 0.03, 0.48, 0.97
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi,

* Anton Altaparmakov (aia21@cam.ac.uk) wrote:
>
> Thanks for the report.  Would you be able to try the below change to your 
> kernel and repeat?
>
> On 6 Jul 2008, at 18:21, Eric Sesterhenn wrote:
>> 0xc030ad5c is in ntfs_read_locked_inode (fs/ntfs/time.h:95).
>> 90		u64 t = (u64)(sle64_to_cpu(time) - NTFS_TIME_OFFSET);
>> 91		/*
>> 92		 * Convert the time to 1-second intervals and the remainder to
>> 93		 * 1-nano-second intervals.
>> 94		 */
>> 95		ts.tv_nsec = do_div(t, 10000000) * 100;
>> 96		ts.tv_sec = t;
>> 97		return ts;
>> 98	}
>
> Please replace the ts.tv_nsec=... and ts.tv_sec=... with:
>
> 		if (t) {
> 			ts.tv_nsec = do_div(t, 10000000) * 100;
> 			ts.tv_sec = t;
> 		} else {
> 			ts.tv_nsec = 0;
> 			ts.tv_sec = 0;
> 		}
>
> Thanks a lot in advance!

I did this and still get the oops, the strange thing is, that i now
get the bug in line 90

[   76.583958] BUG: unable to handle kernel paging request at c6798558
[   76.584019] IP: [<c030adbc>] ntfs_read_locked_inode+0x16c/0x1570
[   76.584019] *pde = 090b1163 *pte = 06798160 
[   76.584019] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[   76.584019] Modules linked in:
[   76.584019] 
[   76.584019] Pid: 4488, comm: mount Not tainted (2.6.26-rc9-00005-g1b40a89-dirty #1)
[   76.584019] EIP: 0060:[<c030adbc>] EFLAGS: 00010296 CPU: 0
[   76.584019] EIP is at ntfs_read_locked_inode+0x16c/0x1570
[   76.584019] EAX: c6798550 EBX: 00000000 ECX: c678b000 EDX: c678b038
[   76.584019] ESI: 00000000 EDI: 00000000 EBP: c5c2db50 ESP: c5c2dadc
[   76.584019]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   76.584019] Process mount (pid: 4488, ti=c5c2d000 task=c5c12fa0 task.ti=c5c2d000)
[   76.584019] Stack: 00000000 00000000 00000000 00000000 00000000 c8bda000 c0cd58fc c7132d84 
[   76.584019]        c5c2db14 c0976870 c0976870 c0976860 c8bed180 c678b000 c6798550 c8bda000 
[   76.584019]        00000000 c5c2db2c c0755737 c7132c00 c5c2db50 c01a2308 c5c2db60 00000001 
[   76.584019] Call Trace:
[   76.584019]  [<c0755737>] ? _spin_unlock+0x27/0x50
[   76.584019]  [<c01a2308>] ? iget5_locked+0x138/0x160
[   76.584019]  [<c030cd30>] ? ntfs_test_inode+0x0/0x70
[   76.584020]  [<c030c215>] ? ntfs_iget+0x55/0x80
[   76.584020]  [<c030cda0>] ? ntfs_init_locked_inode+0x0/0xf0
[   76.584020]  [<c03186cb>] ? load_and_init_attrdef+0x1b/0x270
[   76.584020]  [<c014678f>] ? lockdep_init_map+0x2f/0x480
[   76.584020]  [<c030219a>] ? __ntfs_error+0x1a/0xd0
[   76.584020]  [<c0318cc6>] ? load_system_files+0x3a6/0x1c50
[   76.584020]  [<c031cdfd>] ? generate_default_upcase+0x2d/0x110
[   76.584020]  [<c031cdfd>] ? generate_default_upcase+0x2d/0x110
[   76.584020]  [<c031cdfd>] ? generate_default_upcase+0x2d/0x110
[   76.584020]  [<c031c01f>] ? ntfs_fill_super+0xccf/0x1420
[   76.584020]  [<c0753a28>] ? mutex_unlock+0x8/0x10
[   76.584020]  [<c0190b6f>] ? get_sb_bdev+0xef/0x120
[   76.584020]  [<c01a5b0d>] ? alloc_vfsmnt+0xdd/0x120
[   76.584020]  [<c01a5b0d>] ? alloc_vfsmnt+0xdd/0x120
[   76.584020]  [<c0317402>] ? ntfs_get_sb+0x22/0x30
[   76.584020]  [<c031b350>] ? ntfs_fill_super+0x0/0x1420
[   76.584020]  [<c01906ba>] ? vfs_kern_mount+0x3a/0x90
[   76.584020]  [<c0190769>] ? do_kern_mount+0x39/0xd0
[   76.584020]  [<c01a6d45>] ? do_new_mount+0x65/0x90
[   76.584020]  [<c01a6eca>] ? do_mount+0x15a/0x1b0
[   76.584020]  [<c0189d95>] ? kmem_cache_alloc+0x95/0xc0
[   76.584020]  [<c016deeb>] ? __get_free_pages+0x1b/0x30
[   76.584020]  [<c01a4bd8>] ? copy_mount_options+0x38/0x140
[   76.584020]  [<c01973be>] ? getname+0x9e/0xd0
[   76.584020]  [<c01a6f8f>] ? sys_mount+0x6f/0xb0
[   76.584020]  [<c0103d79>] ? sysenter_past_esp+0x6a/0xb1
[   76.584020]  =======================
[   76.584020] Code: 0c 89 5c 24 04 c7 04 24 00 00 00 00 e8 ae 2b ff ff 85 c0 89 45 cc 0f 85 76 0c 00 00 8b 45 c8 8b 50 04 0f b7 42 14 01 d0 89 45 c4 <8b> 58 08 8b 70 0c 81 c3 00 80 c1 2a 81 d6 21 4e 62 fe 89 f1 09 
[   76.584020] EIP: [<c030adbc>] ntfs_read_locked_inode+0x16c/0x1570 SS:ESP 0068:c5c2dadc
[   76.584020] ---[ end trace f67599227dc2e4cc ]---

(gdb) l *(ntfs_read_locked_inode+0x16c)
0xc030adbc is in ntfs_read_locked_inode (fs/ntfs/time.h:90).
85	static inline struct timespec ntfs2utc(const sle64 time)
86	{
87		struct timespec ts;
88	
89		/* Subtract the NTFS time offset. */
90		u64 t = (u64)(sle64_to_cpu(time) - NTFS_TIME_OFFSET);
91		/*
92		 * Convert the time to 1-second intervals and the remainder to
93		 * 1-nano-second intervals.
94		 */
(gdb) quit

Not sure why this happens. I checked out a fresh git tree to
make sure my tree isnt broken or something. Might gcc be bogus
or the debug information and the bug happens in reality somewhere else?

root@whiterabbit:/usr/src/linux# gcc -v
Using built-in specs.
Target: i486-linux-gnu
Configured with: ../src/configure -v --enable-languages=c,c++,fortran,objc,obj-c++,treelang --prefix=/usr --enable-shared --with-system-zlib --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --enable-nls --with-gxx-include-dir=/usr/include/c++/4.2 --program-suffix=-4.2 --enable-clocale=gnu --enable-libstdcxx-debug --enable-objc-gc --enable-mpfr --enable-targets=all --enable-checking=release --build=i486-linux-gnu --host=i486-linux-gnu --target=i486-linux-gnu
Thread model: posix
gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)


Greetings, Eric
