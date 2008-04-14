Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbYDNQCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbYDNQCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645AbYDNQB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:01:56 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:40705 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbYDNQBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:01:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=khx7ePIylhHAFhM7pGe5/M4BKp7UoTZMuxlEtnNJdeVGaddGGsnADzweCd0Sp4kIfydt11oz4oov7C8hVMs31lSItWX6FdVVO5YbkaTGGdWvInyjS8w4Te7anb7edeFA8ZA5KGIL1yVBaK+Jt9YCuuKjLrB89oyEIjruOX6ZfEQ=
Message-ID: <84144f020804140901p1c076fd2q73e3effe7cd96da3@mail.gmail.com>
Date: Mon, 14 Apr 2008 19:01:53 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: 2.6.25-rc8-mm2: IP: [<ffffffff802868f9>] __kmalloc+0x69/0x110
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       clameter@sgi.com
In-Reply-To: <20080413204422.GA5136@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
	 <20080413204422.GA5136@martell.zuzino.mipt.ru>
X-Google-Sender-Auth: 80876d5d728674b7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 11:44 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> Grrr, I was hunting for oopses in dup_fd and near that were plaguing one
>  box here for far too long, and hit below.
>
>  What happened if freshly booted box (probably not all init scripts finished),
>  X already started. ssh from another box and reboot from session.
>
>  (gdb) p __kmalloc
>  $1 = {void *(size_t, gfp_t)} 0xffffffff80286890 <__kmalloc>
>  (gdb) l *(0xffffffff80286890 + 0x69)
>  0xffffffff802868f9 is in __kmalloc (mm/slub.c:1663).
>  1658
>  1659                    object = __slab_alloc(s, gfpflags, node, addr, c);
>  1660
>  1661            else {
>  1662                    object = c->freelist;
>  1663      ===>          c->freelist = object[c->offset];   <===
>  1664                    stat(c, ALLOC_FASTPATH);
>  1665            }
>  1666            local_irq_restore(flags);
>
>
>
>  BUG: unable to handle kernel paging request at 0000000500000500
>  IP: [<ffffffff802868f9>] __kmalloc+0x69/0x110
>  PGD 17e04a067 PUD 0
>  Oops: 0000 [1] SMP DEBUG_PAGEALLOC
>  last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:05:02.0/resource
>  CPU 1
>  Modules linked in: nf_conntrack_irc ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables usblp ehci_hcd uhci_hcd usbcore sr_mod cdrom
>  Pid: 4966, comm: depscan.sh Not tainted 2.6.25-rc8-mm2 #20
>  RIP: 0010:[<ffffffff802868f9>]  [<ffffffff802868f9>] __kmalloc+0x69/0x110
>  RSP: 0018:ffff81017cba9c68  EFLAGS: 00010006
>  RAX: 0000000000000000 RBX: ffffffff805c3950 RCX: ffff81017e7bb278
>  RDX: ffff81017c868000 RSI: 0000000000000001 RDI: ffffffff802868db
>  RBP: ffff81017cba9c98 R08: 0000000000000000 R09: 0000000000000001
>  R10: 0000000005050561 R11: 00000000036c00b1 R12: 0000000500000500
>  R13: 0000000000000282 R14: 00000000000080d0 R15: ffff810001070360
>  FS:  00007fc9d17276f0(0000) GS:ffff81017fc44600(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>  CR2: 0000000500000500 CR3: 000000017c9c2000 CR4: 00000000000006e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  Process depscan.sh (pid: 4966, threadinfo ffff81017cba8000, task ffff81017c868000)
>  Stack:  ffffffff802d4a42 ffff81017e7bb278 ffff81017e7bb278 00000000fe5c5c7c
>   000000000cb4c2b8 ffff81017efdc8c0 ffff81017cba9cd8 ffffffff802d4a42
>   ffff81017cba9cd8 ffff81017e7bb278 ffff81017f82e2a0 ffff81017cba9da8
>  Call Trace:
>   [<ffffffff802d4a42>] ? ext3_htree_store_dirent+0x32/0x120
>   [<ffffffff802d4a42>] ext3_htree_store_dirent+0x32/0x120
>   [<ffffffff802dba25>] htree_dirblock_to_tree+0x105/0x170
>   [<ffffffff802de30d>] ext3_htree_fill_tree+0x7d/0x220
>   [<ffffffff80252d59>] ? trace_hardirqs_on_caller+0xc9/0x150
>   [<ffffffff802d50f4>] ? ext3_readdir+0x5c4/0x630
>   [<ffffffff802d4c74>] ext3_readdir+0x144/0x630
>   [<ffffffff802975f0>] ? filldir+0x0/0xe0
>   [<ffffffff8045475a>] ? __mutex_lock_common+0x22a/0x330
>   [<ffffffff80297741>] ? vfs_readdir+0x71/0xc0
>   [<ffffffff802975f0>] ? filldir+0x0/0xe0
>   [<ffffffff802975f0>] ? filldir+0x0/0xe0
>   [<ffffffff80297773>] vfs_readdir+0xa3/0xc0
>   [<ffffffff80297822>] sys_getdents+0x92/0xd0
>   [<ffffffff8020b4cb>] system_call_after_swapgs+0x7b/0x80
>
>
>  Code: 48 89 45 d0 9c 41 5d fa e8 f5 a5 fc ff 65 8b 04 25 24 00 00 00 48 98 4c 8b bc c3 c8 00 00 00 4d 8b 27 4d 85 e4 74 7a 41 8b 47 14 <49> 8b 04 c4 49 89 07 41 f7 c5 00 02 00 00 75 37 41 55 9d e8 bf
>  RIP  [<ffffffff802868f9>] __kmalloc+0x69/0x110
>   RSP <ffff81017cba9c68>
>  CR2: 0000000500000500

Looks like freelist corruption where c->freelist is 0x0000000500000500
and c->offset is zero... Christoph?

>  # CONFIG_DEBUG_DRIVER is not set
>  # CONFIG_DEBUG_DEVRES is not set
>  # CONFIG_DEBUG_FS is not set
>  CONFIG_DEBUG_KERNEL=y
>  # CONFIG_DEBUG_SHIRQ is not set
>  CONFIG_DEBUG_OBJECTS=y
>  # CONFIG_DEBUG_OBJECTS_SELFTEST is not set
>  CONFIG_DEBUG_OBJECTS_FREE=y
>  CONFIG_DEBUG_OBJECTS_TIMERS=y
>  CONFIG_DEBUG_RT_MUTEXES=y
>  CONFIG_DEBUG_PI_LIST=y
>  CONFIG_DEBUG_SPINLOCK=y
>  CONFIG_DEBUG_MUTEXES=y
>  CONFIG_DEBUG_LOCK_ALLOC=y
>  # CONFIG_DEBUG_LOCKDEP is not set
>  CONFIG_DEBUG_SPINLOCK_SLEEP=y
>  # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
>  # CONFIG_DEBUG_KOBJECT is not set
>  CONFIG_DEBUG_BUGVERBOSE=y
>  CONFIG_DEBUG_INFO=y
>  CONFIG_DEBUG_VM=y
>  CONFIG_DEBUG_WRITECOUNT=y
>  CONFIG_DEBUG_LIST=y
>  CONFIG_DEBUG_SG=y
>  # CONFIG_DEBUG_SYNCHRO_TEST is not set
>  # CONFIG_DEBUG_STACKOVERFLOW is not set
>  # CONFIG_DEBUG_STACK_USAGE is not set
>  CONFIG_DEBUG_PAGEALLOC=y
>  CONFIG_DEBUG_PER_CPU_MAPS=y
>  CONFIG_DEBUG_RODATA=y
>  CONFIG_DEBUG_RODATA_TEST=y
>  # CONFIG_DEBUG_NX_TEST is not set

I assume you have CONFIG_SLUB_DEBUG enabled but it was left out by the grep?
