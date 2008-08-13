Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbYHMUfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbYHMUfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYHMUfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:35:00 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:37052 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbYHMUe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:34:59 -0400
Date: Wed, 13 Aug 2008 14:34:38 -0600
From: Alex Chiang <achiang@hp.com>
To: alan@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: tty-kref-modcount oops in linux-next
Message-ID: <20080813203438.GT25902@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, alan@redhat.com,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Booting the latest linux-next kernel (20080812) on my HP rx6600
(ia64) results in an oops. This is a SLES10 userspace, but I
don't know if that matters.

I bisected it down to this commit:

b18540aa6f5cf3c12b14c3ab9a6cc4492a6eb930 is first bad commit
commit b18540aa6f5cf3c12b14c3ab9a6cc4492a6eb930
Author: Alan Cox <alan@redhat.com>
Date:   Tue Aug 12 09:43:24 2008 +1000

    tty-kref-modcount
    
    Signed-off-by: Alan Cox <alan@redhat.com>

:040000 040000 711e6ccf01cdeff87b2a4a626cc4fe699ab199a6 78cea01630d7d41375f3f22039f660bf4d0aedc9 M      drivers
:040000 040000 3a7e3f37a73bf29f6f5aa169d967ac115ec7bc26 b49452d92deab46cbef27644c0e146973c339cf8 M      include

Here is the bisection log.

git-bisect start
# bad: [f525465432312c3c02532c62e4519298ea23118a] Fix the IA64 arch's use of COW credentials.
git-bisect bad f525465432312c3c02532c62e4519298ea23118a 
# good: [da250c4bb64a4b3cec3b723ead8e9ebc3f9462af] Merge commit 'drm/drm-next'
git-bisect good da250c4bb64a4b3cec3b723ead8e9ebc3f9462af
# bad: [040781b6bc89f83fb51fced4138ad55f8aeedbc9] Merge commit 'agp/agp-next'
git-bisect bad 040781b6bc89f83fb51fced4138ad55f8aeedbc9
# bad: [b18540aa6f5cf3c12b14c3ab9a6cc4492a6eb930] tty-kref-modcount
git-bisect bad b18540aa6f5cf3c12b14c3ab9a6cc4492a6eb930
# good: [f939c7b3a5d7a1760214fa3fbde2e6ab3b4a88d1] blackfin-fix-stop-bug
git-bisect good f939c7b3a5d7a1760214fa3fbde2e6ab3b4a88d1
# good: [2c945d060224e1ea7f8f877240db6cd9ca66d5a1] tty-remove-resize-special
git-bisect good 2c945d060224e1ea7f8f877240db6cd9ca66d5a1
# good: [b569e157488314a50de123634e7c32c4253a3048] tty-split-port
git-bisect good b569e157488314a50de123634e7c32c4253a3048
# good: [d43a0b46168489882b40798bd1b2bb69ccdf5d99] tty-kref
git-bisect good d43a0b46168489882b40798bd1b2bb69ccdf5d99

Note that the first commit is a patch in my local tree:

	http://lkml.org/lkml/2008/8/13/157

One more thing before the oops, I had a little difficulty toward
the end of the bisection run due to build errors. Would it be
possible for you to fold hunks 3, 5, and 8 from commit
b18540aa6f5cf3c12b14c3ab9a6cc4492a6eb930 into commit
d43a0b46168489882b40798bd1b2bb69ccdf5d99?

Or does that break the "published trees are immutable history"
rule?

Thanks.

/ac

------------[ cut here ]------------
WARNING: at lib/kref.c:43 kref_get+0x40/0x80()
Modules linked in: loop md_mod dm_mod reiserfs fan thermal processor

Call Trace:
 [<a000000100016360>] show_stack+0x40/0xa0
                                sp=e00001007209fb60 bsp=e000010072091030
 [<a0000001000163f0>] dump_stack+0x30/0x60
                                sp=e00001007209fd30 bsp=e000010072091018
 [<a00000010009a350>] warn_on_slowpath+0x90/0x100
                                sp=e00001007209fd30 bsp=e000010072090fe8
 [<a0000001002d8540>] kref_get+0x40/0x80
                                sp=e00001007209fe20 bsp=e000010072090fc8
 [<a000000100377650>] get_current_tty+0xb0/0xe0
                                sp=e00001007209fe20 bsp=e000010072090fa0
 [<a00000010037a470>] disassociate_ctty+0x30/0x4a0
                                sp=e00001007209fe20 bsp=e000010072090f60
 [<a0000001000a1cb0>] do_exit+0x570/0x11a0
                                sp=e00001007209fe20 bsp=e000010072090f10
 [<a0000001000a2a70>] do_group_exit+0x190/0x200
                                sp=e00001007209fe30 bsp=e000010072090ed0
 [<a0000001000a2b00>] sys_exit_group+0x20/0x40
                                sp=e00001007209fe30 bsp=e000010072090e78
 [<a00000010000c580>] ia64_ret_from_syscall+0x0/0x20
                                sp=e00001007209fe30 bsp=e000010072090e78
 [<a000000000010720>] __kernel_syscall_via_break+0x0/0x20
                                sp=e0000100720a0000 bsp=e000010072090e78
---[ end trace 5e11c56cf997d468 ]---
Warning: dev (ttyS1) tty->count(2) != #fd's(0) in do_tty_hangup
bad magic number for tty struct (5:1) in release_dev
INIT: Entering runlevel: 3
bad magic number for tty struct (5:1) in tty_ioctl
init_dev but no ldisc
Unable to handle kernel NULL pointer dereference (address 0000000000000008)
rc[4436]: Oops 8804682956800 [1]
Modules linked in: loop md_mod dm_mod reiserfs fan thermal processor

Pid: 4436, CPU 3, comm:                   rc
psr : 00001010081a6018 ifs : 8000000000000307 ip  : [<a00000010016f670>]    Tainted: G        W (2.6.27-rc2-next-20080812-03024-gf525465)
ip is at file_move+0x90/0xe0
unat: 0000000000000000 pfs : 0000000000000307 rsc : 0000000000000003
rnat: 0000000000000000 bsps: 0000000000000000 pr  : 0400000000552995
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c0270033f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a00000010016f620 b6  : a00000010046c300 b7  : a0000001002efe00
f6  : 1003e000000105964fdbe f7  : 1003e000000000000018f
f8  : 1003e000000105964fc2f f9  : 1003e0000000000000001
f10 : 000000000000000000000 f11 : 000000000000000000000
r1  : a000000100f0e310 r2  : e00001007ed8aaa0 r3  : e0000100414a3e88
r8  : 0000000000000000 r9  : a000000100cb46e8 r10 : a000000100d2b5e0
r11 : a000000100cb46c0 r12 : e000010072b2fd60 r13 : e000010072b20000
r14 : 0000000000000000 r15 : 0000000000000008 r16 : e0000100414a3e80
r17 : e000010041e07388 r18 : a000000100d0f840 r19 : a000000101000fa0
r20 : 0000000000006733 r21 : a000000100cb46c8 r22 : 0000000000000001
r23 : a000000100d29b6c r24 : 0000000000004000 r25 : 0000000000004000
r26 : a000000100cb46d8 r27 : 0000000000000000 r28 : c000000084033001
r29 : 0000000000000005 r30 : 0000000000000000 r31 : a000000100c5dd80

Call Trace:
 [<a000000100016360>] show_stack+0x40/0xa0
                                sp=e000010072b2f930 bsp=e000010072b21080
 [<a000000100016c70>] show_regs+0x850/0x8a0
                                sp=e000010072b2fb00 bsp=e000010072b21028
 [<a000000100039c90>] die+0x1b0/0x2c0
                                sp=e000010072b2fb00 bsp=e000010072b20fd8
 [<a000000100062e70>] ia64_do_page_fault+0x8d0/0xa40
                                sp=e000010072b2fb00 bsp=e000010072b20f88
 [<a00000010000c720>] ia64_native_leave_kernel+0x0/0x270
                                sp=e000010072b2fb90 bsp=e000010072b20f88
 [<a00000010016f670>] file_move+0x90/0xe0
                                sp=e000010072b2fd60 bsp=e000010072b20f50
 [<a00000010037dc60>] tty_open+0x3e0/0x800
                                sp=e000010072b2fd60 bsp=e000010072b20f00
 [<a000000100173f90>] chrdev_open+0x310/0x3e0
                                sp=e000010072b2fd70 bsp=e000010072b20ec0
 [<a0000001001694c0>] __dentry_open+0x2e0/0x5a0
                                sp=e000010072b2fd80 bsp=e000010072b20e70
 [<a000000100169800>] nameidata_to_filp+0x80/0xc0
                                sp=e000010072b2fd80 bsp=e000010072b20e48
 [<a000000100186da0>] do_filp_open+0x880/0x1100
                                sp=e000010072b2fd80 bsp=e000010072b20da0
 [<a000000100168f50>] do_sys_open+0x90/0x1c0
                                sp=e000010072b2fe30 bsp=e000010072b20d50
 [<a000000100169150>] sys_open+0x50/0x80
                                sp=e000010072b2fe30 bsp=e000010072b20cf8
 [<a00000010000c580>] ia64_ret_from_syscall+0x0/0x20
                                sp=e000010072b2fe30 bsp=e000010072b20cf8
 [<a000000000010720>] __kernel_syscall_via_break+0x0/0x20
                                sp=e000010072b30000 bsp=e000010072b20cf8
BUG: soft lockup - CPU#3 stuck for 61s! [rc:4433]

[soft lockup stack trace repeats many times]
