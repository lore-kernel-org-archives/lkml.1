Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYDMUtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYDMUtO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 16:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYDMUs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 16:48:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:36954 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbYDMUs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 16:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=NHb/9x5Cz17xY2WGHs3sBwZbg6k2fYgKV1hI0u1JlUniyfXZNE/LwSVj7M6U3dCbxWl0piePRv0ijpY/FLgN9lemx5oURwtajbbNh4oHy7f8j6b4Tpa3plFVHVVOCRGXIjnkWX7V7UmlLupW8EhchMxZoPhgGXHqK8/ZZtGSJ9I=
Date: Mon, 14 Apr 2008 00:44:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, clameter@sgi.com, penberg@cs.helsinki.fi
Subject: 2.6.25-rc8-mm2: IP: [<ffffffff802868f9>] __kmalloc+0x69/0x110
Message-ID: <20080413204422.GA5136@martell.zuzino.mipt.ru>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410203354.f0a6f464.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grrr, I was hunting for oopses in dup_fd and near that were plaguing one
box here for far too long, and hit below.

What happened if freshly booted box (probably not all init scripts finished),
X already started. ssh from another box and reboot from session.


(gdb) p __kmalloc
$1 = {void *(size_t, gfp_t)} 0xffffffff80286890 <__kmalloc>
(gdb) l *(0xffffffff80286890 + 0x69)
0xffffffff802868f9 is in __kmalloc (mm/slub.c:1663).
1658
1659                    object = __slab_alloc(s, gfpflags, node, addr, c);
1660
1661            else {
1662                    object = c->freelist;
1663      ===>          c->freelist = object[c->offset];   <===
1664                    stat(c, ALLOC_FASTPATH);
1665            }
1666            local_irq_restore(flags);



BUG: unable to handle kernel paging request at 0000000500000500
IP: [<ffffffff802868f9>] __kmalloc+0x69/0x110
PGD 17e04a067 PUD 0 
Oops: 0000 [1] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:05:02.0/resource
CPU 1 
Modules linked in: nf_conntrack_irc ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables usblp ehci_hcd uhci_hcd usbcore sr_mod cdrom
Pid: 4966, comm: depscan.sh Not tainted 2.6.25-rc8-mm2 #20
RIP: 0010:[<ffffffff802868f9>]  [<ffffffff802868f9>] __kmalloc+0x69/0x110
RSP: 0018:ffff81017cba9c68  EFLAGS: 00010006
RAX: 0000000000000000 RBX: ffffffff805c3950 RCX: ffff81017e7bb278
RDX: ffff81017c868000 RSI: 0000000000000001 RDI: ffffffff802868db
RBP: ffff81017cba9c98 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000005050561 R11: 00000000036c00b1 R12: 0000000500000500
R13: 0000000000000282 R14: 00000000000080d0 R15: ffff810001070360
FS:  00007fc9d17276f0(0000) GS:ffff81017fc44600(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000500000500 CR3: 000000017c9c2000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process depscan.sh (pid: 4966, threadinfo ffff81017cba8000, task ffff81017c868000)
Stack:  ffffffff802d4a42 ffff81017e7bb278 ffff81017e7bb278 00000000fe5c5c7c
 000000000cb4c2b8 ffff81017efdc8c0 ffff81017cba9cd8 ffffffff802d4a42
 ffff81017cba9cd8 ffff81017e7bb278 ffff81017f82e2a0 ffff81017cba9da8
Call Trace:
 [<ffffffff802d4a42>] ? ext3_htree_store_dirent+0x32/0x120
 [<ffffffff802d4a42>] ext3_htree_store_dirent+0x32/0x120
 [<ffffffff802dba25>] htree_dirblock_to_tree+0x105/0x170
 [<ffffffff802de30d>] ext3_htree_fill_tree+0x7d/0x220
 [<ffffffff80252d59>] ? trace_hardirqs_on_caller+0xc9/0x150
 [<ffffffff802d50f4>] ? ext3_readdir+0x5c4/0x630
 [<ffffffff802d4c74>] ext3_readdir+0x144/0x630
 [<ffffffff802975f0>] ? filldir+0x0/0xe0
 [<ffffffff8045475a>] ? __mutex_lock_common+0x22a/0x330
 [<ffffffff80297741>] ? vfs_readdir+0x71/0xc0
 [<ffffffff802975f0>] ? filldir+0x0/0xe0
 [<ffffffff802975f0>] ? filldir+0x0/0xe0
 [<ffffffff80297773>] vfs_readdir+0xa3/0xc0
 [<ffffffff80297822>] sys_getdents+0x92/0xd0
 [<ffffffff8020b4cb>] system_call_after_swapgs+0x7b/0x80


Code: 48 89 45 d0 9c 41 5d fa e8 f5 a5 fc ff 65 8b 04 25 24 00 00 00 48 98 4c 8b bc c3 c8 00 00 00 4d 8b 27 4d 85 e4 74 7a 41 8b 47 14 <49> 8b 04 c4 49 89 07 41 f7 c5 00 02 00 00 75 37 41 55 9d e8 bf 
RIP  [<ffffffff802868f9>] __kmalloc+0x69/0x110
 RSP <ffff81017cba9c68>
CR2: 0000000500000500
---[ end trace f513ce88520d2ac0 ]---
BUG: sleeping function called from invalid context at kernel/rwsem.c:21
in_atomic():0, irqs_disabled():1
INFO: lockdep is turned off.
irq event stamp: 19250
hardirqs last  enabled at (19249): [<ffffffff80252ded>] trace_hardirqs_on+0xd/0x10
hardirqs last disabled at (19250): [<ffffffff80250edd>] trace_hardirqs_off+0xd/0x10
softirqs last  enabled at (14334): [<ffffffff80236aae>] __do_softirq+0xee/0x110
softirqs last disabled at (14329): [<ffffffff8020c77c>] call_softirq+0x1c/0x30
Pid: 4966, comm: depscan.sh Tainted: G      D   2.6.25-rc8-mm2 #20

Call Trace:
 [<ffffffff802523f0>] ? print_irqtrace_events+0x110/0x120
 [<ffffffff802280e7>] __might_sleep+0xc7/0xe0
 [<ffffffff80454aed>] down_read+0x1d/0x50
 [<ffffffff80232e6e>] exit_mm+0x2e/0xf0
 [<ffffffff802339a9>] do_exit+0x189/0x760
 [<ffffffff80227f6e>] ? __wake_up+0x4e/0x70
 [<ffffffff8020c8a5>] oops_end+0x85/0x90
 [<ffffffff802209ec>] do_page_fault+0x3fc/0x890
 [<ffffffff80253a65>] ? __lock_acquire+0x645/0xc50
 [<ffffffff8045639d>] error_exit+0x0/0xa9
 [<ffffffff802868db>] ? __kmalloc+0x4b/0x110
 [<ffffffff802868f9>] ? __kmalloc+0x69/0x110
 [<ffffffff802868db>] ? __kmalloc+0x4b/0x110
 [<ffffffff802d4a42>] ? ext3_htree_store_dirent+0x32/0x120
 [<ffffffff802d4a42>] ? ext3_htree_store_dirent+0x32/0x120
 [<ffffffff802dba25>] ? htree_dirblock_to_tree+0x105/0x170
 [<ffffffff802de30d>] ? ext3_htree_fill_tree+0x7d/0x220
 [<ffffffff80252d59>] ? trace_hardirqs_on_caller+0xc9/0x150
 [<ffffffff802d50f4>] ? ext3_readdir+0x5c4/0x630
 [<ffffffff802d4c74>] ? ext3_readdir+0x144/0x630
 [<ffffffff802975f0>] ? filldir+0x0/0xe0
 [<ffffffff8045475a>] ? __mutex_lock_common+0x22a/0x330
 [<ffffffff80297741>] ? vfs_readdir+0x71/0xc0
 [<ffffffff802975f0>] ? filldir+0x0/0xe0
 [<ffffffff802975f0>] ? filldir+0x0/0xe0
 [<ffffffff80297773>] ? vfs_readdir+0xa3/0xc0
 [<ffffffff80297822>] ? sys_getdents+0x92/0xd0
 [<ffffffff8020b4cb>] ? system_call_after_swapgs+0x7b/0x80

BUG: unable to handle kernel paging request at 0000000500000500
IP: [<ffffffff80286672>] kmem_cache_alloc+0x52/0xd0
PGD 17e277067 PUD 0 
Oops: 0000 [2] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:05:02.0/resource
CPU 1 
Modules linked in: nf_conntrack_irc ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables usblp ehci_hcd uhci_hcd usbcore sr_mod cdrom
Pid: 4951, comm: bash Tainted: G      D   2.6.25-rc8-mm2 #20
RIP: 0010:[<ffffffff80286672>]  [<ffffffff80286672>] kmem_cache_alloc+0x52/0xd0
RSP: 0018:ffff81017d76dca8  EFLAGS: 00010006
RAX: 0000000000000000 RBX: 0000000500000500 RCX: 0000000000000001
RDX: ffff81017ed45eb0 RSI: 00000000000000d0 RDI: ffffffff80286653
RBP: ffff81017d76dcd8 R08: 0000000000000001 R09: 0000000000000000
R10: ffffffff8022e3b7 R11: 0000000000000000 R12: 0000000000000282
R13: ffff810001070360 R14: 00000000000000d0 R15: ffffffff805c3950
FS:  00007fd0a07386f0(0000) GS:ffff81017fc44600(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000500000500 CR3: 000000017c959000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process bash (pid: 4951, threadinfo ffff81017d76c000, task ffff81017ed45eb0)
Stack:  ffffffff802a0bea 00000000000000ff ffff81017ef30f00 0000000000000100
 ffff81017ef30f10 0000000000000100 ffff81017d76dd28 ffffffff802a0bea
 ffff81017ef30f80 ffff81017ef30f80 ffff81017ee36940 00000000000000c0
Call Trace:
 [<ffffffff802a0bea>] ? expand_files+0xaa/0x300
 [<ffffffff802a0bea>] expand_files+0xaa/0x300
 [<ffffffff8022e3c2>] dup_fd+0x292/0x2d0
 [<ffffffff8022e454>] copy_files+0x54/0x80
 [<ffffffff8022cec7>] ? sched_fork+0x37/0x70
 [<ffffffff8022f346>] copy_process+0x5d6/0x1590
 [<ffffffff80455c46>] ? _spin_unlock+0x26/0x30
 [<ffffffff80230382>] do_fork+0x82/0x280
 [<ffffffff80252ded>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff80455c0b>] ? _spin_unlock_irq+0x2b/0x40
 [<ffffffff8023b856>] ? sigprocmask+0x86/0xf0
 [<ffffffff8020b4cb>] ? system_call_after_swapgs+0x7b/0x80
 [<ffffffff80209393>] sys_clone+0x23/0x30
 [<ffffffff8020b867>] ptregscall_common+0x67/0xb0


Code: 89 45 d0 9c 41 5c fa e8 7d a8 fc ff 65 8b 04 25 24 00 00 00 48 98 4d 8b ac c7 c8 00 00 00 49 8b 5d 00 48 85 db 74 51 41 8b 45 14 <48> 8b 04 c3 49 89 45 00 41 f7 c4 00 02 00 00 75 32 41 54 9d e8 
RIP  [<ffffffff80286672>] kmem_cache_alloc+0x52/0xd0
 RSP <ffff81017d76dca8>
CR2: 0000000500000500
---[ end trace f513ce88520d2ac0 ]---
BUG: unable to handle kernel paging request at 0000000500000500
IP: [<ffffffff80286672>] kmem_cache_alloc+0x52/0xd0
PGD 17fe9f067 PUD 0 
Oops: 0000 [3] SMP DEBUG_PAGEALLOC
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:05:02.0/resource
CPU 1 
Modules linked in: nf_conntrack_irc ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables usblp ehci_hcd uhci_hcd usbcore sr_mod cdrom
Pid: 1, comm: init Tainted: G      D   2.6.25-rc8-mm2 #20
RIP: 0010:[<ffffffff80286672>]  [<ffffffff80286672>] kmem_cache_alloc+0x52/0xd0
RSP: 0018:ffff81017fc9bc78  EFLAGS: 00010006
RAX: 0000000000000000 RBX: 0000000500000500 RCX: 00000000fffffffb
RDX: ffff81017fca0000 RSI: 00000000000000d0 RDI: ffffffff80286653
RBP: ffff81017fc9bca8 R08: 0000000000000001 R09: 0000000000000000
R10: ffff81017fc9bbc8 R11: 0000000000000000 R12: 0000000000000286
R13: ffff810001070360 R14: 00000000000000d0 R15: ffffffff805c3950
FS:  00007f47ac8376f0(0000) GS:ffff81017fc44600(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000500000500 CR3: 000000017ec34000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process init (pid: 1, threadinfo ffff81017fc9a000, task ffff81017fca0000)
Stack:  ffffffff80344a3d ffff81017fdf99f8 ffff81017e1f4000 ffff81017fe52400
 0000000000000000 ffff81017fdf9bf0 ffff81017fc9bd18 ffffffff80344a3d
 ffff81017fc9bcd8 ffff81017fc9bd30 ffff81017fe52400 0000000000000000
Call Trace:
 [<ffffffff80344a3d>] ? init_dev+0x2ad/0x600
 [<ffffffff80344a3d>] init_dev+0x2ad/0x600
 [<ffffffff8034504f>] tty_open+0xff/0x330
 [<ffffffff8024aaf3>] ? down+0x33/0x50
 [<ffffffff8028cdeb>] chrdev_open+0xbb/0x1c0
 [<ffffffff8028cd30>] ? chrdev_open+0x0/0x1c0
 [<ffffffff80288254>] __dentry_open+0xd4/0x330
 [<ffffffff802884f4>] nameidata_to_filp+0x44/0x60
 [<ffffffff8029595f>] do_filp_open+0x25f/0x8d0
 [<ffffffff80288043>] ? get_unused_fd_flags+0x103/0x130
 [<ffffffff802880c8>] do_sys_open+0x58/0xb0
 [<ffffffff8028814b>] sys_open+0x1b/0x20
 [<ffffffff8020b4cb>] system_call_after_swapgs+0x7b/0x80


Code: 89 45 d0 9c 41 5c fa e8 7d a8 fc ff 65 8b 04 25 24 00 00 00 48 98 4d 8b ac c7 c8 00 00 00 49 8b 5d 00 48 85 db 74 51 41 8b 45 14 <48> 8b 04 c3 49 89 45 00 41 f7 c4 00 02 00 00 75 32 41 54 9d e8 
RIP  [<ffffffff80286672>] kmem_cache_alloc+0x52/0xd0
 RSP <ffff81017fc9bc78>
CR2: 0000000500000500
---[ end trace f513ce88520d2ac0 ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: init Tainted: G      D   2.6.25-rc8-mm2 #20

Call Trace:
 [<ffffffff80230ee0>] panic+0xa0/0x180
 [<ffffffff80231df7>] ? printk+0x67/0x70
 [<ffffffff80250edd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff80233f71>] do_exit+0x751/0x760
 [<ffffffff80227f6e>] ? __wake_up+0x4e/0x70
 [<ffffffff8020c8a5>] oops_end+0x85/0x90
 [<ffffffff802209ec>] do_page_fault+0x3fc/0x890
 [<ffffffff8045639d>] error_exit+0x0/0xa9
 [<ffffffff80286653>] ? kmem_cache_alloc+0x33/0xd0
 [<ffffffff80286672>] ? kmem_cache_alloc+0x52/0xd0
 [<ffffffff80286653>] ? kmem_cache_alloc+0x33/0xd0
 [<ffffffff80344a3d>] ? init_dev+0x2ad/0x600
 [<ffffffff80344a3d>] ? init_dev+0x2ad/0x600
 [<ffffffff8034504f>] ? tty_open+0xff/0x330
 [<ffffffff8024aaf3>] ? down+0x33/0x50
 [<ffffffff8028cdeb>] ? chrdev_open+0xbb/0x1c0
 [<ffffffff8028cd30>] ? chrdev_open+0x0/0x1c0
 [<ffffffff80288254>] ? __dentry_open+0xd4/0x330
 [<ffffffff802884f4>] ? nameidata_to_filp+0x44/0x60
 [<ffffffff8029595f>] ? do_filp_open+0x25f/0x8d0
 [<ffffffff80288043>] ? get_unused_fd_flags+0x103/0x130
 [<ffffffff802880c8>] ? do_sys_open+0x58/0xb0
 [<ffffffff8028814b>] ? sys_open+0x1b/0x20
 [<ffffffff8020b4cb>] ? system_call_after_swapgs+0x7b/0x80





# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_FS is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_SYNCHRO_TEST is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_NX_TEST is not set

