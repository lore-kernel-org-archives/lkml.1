Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbYANNz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbYANNz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYANNzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:55:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36594 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYANNzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:55:14 -0500
Date: Mon, 14 Jan 2008 14:58:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault II
Message-ID: <20080114135811.GA16190@one.firstfloor.org>
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114130620.GA14057@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 02:06:20PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Subject was wrong of course -- it was a recursive oops, not a double 
> > fault. Sorry for the inaccuracy.
> > 
> > Hopefully it can be fixed soon because it inhibits further testing 
> > here.
> 
> no context. Your first mail did not seem to make it to lkml. (yet)

Sorry. Not sure what happened. Here is it again:

----

This is as of 2f42671697ea9abc7d10ea7f663d6ef6e8ec6358 git-x86 HEAD:

One of my test machines here when booted with git-x86 gives a double
fault on entering user space. I bisected it down to the following commit.

commit c64ba9309275f2e89bd18adbe4d932b6ecc7eb07
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Fri Jan 11 18:11:41 2008 +0100

    x86/pgtable: unify pagetable accessors
    
    Unify functions to test and set bits in pagetable entries.

This is with PAE and seems to only happen with enough RAM (6GB);
a 2GB system boots. 64bit also works.

-Andi

VFS: Mounted root (nfs filesystem).
Freeing unused kernel memory: 260k freed
boot[1151]: segfault at 00000000 ip 00000000 sp bfe5c1fc error 14
Bad page state in process 'boot'
page:c27f8000 flags:0x80080010 mapping:00000000 mapcount:0 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
Pid: 1151, comm: boot Not tainted 2.6.24-rc7-gc64ba930 #10
 [<c01474eb>] bad_page+0x48/0x6f
 [<c01478de>] free_hot_cold_page+0x5b/0x148
 [<c01479e3>] __pagevec_free+0x18/0x22
 [<c014a03d>] release_pages+0x13f/0x147
 [<c0151191>] free_pgtables+0x86/0x93
 [<c01568bb>] free_pages_and_swap_cache+0x6a/0x7e
 [<c01521e1>] exit_mmap+0xa2/0xcd
 [<c011fece>] mmput+0x25/0x79
 [<c01245fa>] do_exit+0x1a9/0x5eb
 [<c0124aa7>] sys_exit_group+0x0/0xd
 [<c012bda2>] get_signal_to_deliver+0x3e3/0x405
 [<c043577c>] do_page_fault+0x0/0x6a4
 [<c01043de>] do_notify_resume+0x7d/0x64e
 [<c0122346>] printk+0x14/0x18
 [<c0435b3a>] do_page_fault+0x3be/0x6a4
 [<c0435e17>] do_page_fault+0x69b/0x6a4
 [<c043577c>] do_page_fault+0x0/0x6a4
 [<c0104d26>] work_notifysig+0x13/0x19
 =======================
Bad page state in process 'boot'
page:c27f8120 flags:0x80000000 mapping:00000000 mapcount:1 count:1
Trying to fix it up, but a reboot is needed
Backtrace:
Pid: 1153, comm: boot Tainted: G    B   2.6.24-rc7-gc64ba930 #10
 [<c01474eb>] bad_page+0x48/0x6f
 [<c0147f27>] get_page_from_freelist+0x242/0x30f
 [<c014807f>] __alloc_pages+0x67/0x2c5
 [<c014e9b5>] do_wp_page+0x20e/0x494
 [<c0150ac2>] handle_mm_fault+0x6c1/0x75a
 [<c0435a2b>] do_page_fault+0x2af/0x6a4
 [<c043577c>] do_page_fault+0x0/0x6a4
 [<c043455a>] error_code+0x72/0x78
 [<c02122aa>] __put_user_4+0x12/0x18
 [<c011e09c>] schedule_tail+0x52/0x55
 [<c0104b6e>] ret_from_fork+0x6/0x1c
 =======================
boot[1153]: segfault at 0574c985 ip b7d9488a sp bfe5bfd8 error 6
Eeek! page_mapcount(page) went negative! (-1)
  page pfn = bfc09
  page->flags = 80000060
  page->count = 1
  page->mapping = f702d091
  vma->vm_ops = 0x0
------------[ cut here ]------------
kernel BUG at /home/lsrc/git-arch-x86/linux-2.6-x86/mm/rmap.c:631!
invalid opcode: 0000 [#1] SMP 
Modules linked in:

Pid: 1153, comm: boot Tainted: G    B   (2.6.24-rc7-gc64ba930 #10)
EIP: 0060:[<c0154bd6>] EFLAGS: 00010246 CPU: 2
EIP is at page_remove_rmap+0xcc/0xe7
EAX: 00000000 EBX: c27f8120 ECX: 00000046 EDX: 00000046
ESI: f7074948 EDI: c27f8120 EBP: f7078198 ESP: f709ddfc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process boot (pid: 1153, ti=f709c000 task=f7460000 task.ti=f709c000)
Stack: bfc09045 00000000 c014f18f 00000000 f7074948 f709de80 bfc09045 00000000 
       00000000 00000001 b7e37000 f7070010 f70468c0 c4825240 ffffffff 00000000 
       c16e0f0c 00000000 f70aadf8 003f9ed9 b7e37000 b7e37000 00000000 b7e33000 
Call Trace:
 [<c014f18f>] unmap_vmas+0x334/0x5c9
 [<c015219e>] exit_mmap+0x5f/0xcd
 [<c011fece>] mmput+0x25/0x79
 [<c01245fa>] do_exit+0x1a9/0x5eb
 [<c0124aa7>] sys_exit_group+0x0/0xd
 [<c012bda2>] get_signal_to_deliver+0x3e3/0x405
 [<c043577c>] do_page_fault+0x0/0x6a4
 [<c01043de>] do_notify_resume+0x7d/0x64e
 [<c0122346>] printk+0x14/0x18
 [<c0435b3a>] do_page_fault+0x3be/0x6a4
 [<c0435e17>] do_page_fault+0x69b/0x6a4
 [<c043577c>] do_page_fault+0x0/0x6a4
 [<c0104d26>] work_notifysig+0x13/0x19
 =======================
Code: 8b 46 44 8b 50 08 b8 e3 aa 50 c0 e8 c0 ab fe ff 8b 46 4c 85 c0 74 14 8b 40 10 85 c0 74 0d 8b 50 2c b8 01 ab 50 c0 e8 a5 ab fe ff <0f> 0b eb fe 8b 53 10 89 d8 5b 5e 83 e2 01 f7 da 83 c2 04 e9 e1 
EIP: [<c0154bd6>] page_remove_rmap+0xcc/0xe7 SS:ESP 0068:f709ddfc
---[ end trace 8cd8c46e6dae67bc ]---
Fixing recursive fault but reboot is needed!
eth0: no IPv6 routers present
