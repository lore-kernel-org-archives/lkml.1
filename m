Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbYAOBCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbYAOBCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 20:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYAOBCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 20:02:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56227 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbYAOBCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 20:02:35 -0500
Date: Tue, 15 Jan 2008 02:05:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: unify pagetable accessors patch causes double fault II
Message-ID: <20080115010534.GA24854@one.firstfloor.org>
References: <20080114094814.GA28300@basil.nowhere.org> <20080114125638.GA9510@basil.nowhere.org> <20080114130620.GA14057@elte.hu> <20080114135811.GA16190@one.firstfloor.org> <478BDC43.6050105@goop.org> <20080114222349.GA23409@one.firstfloor.org> <478BE628.7090008@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478BE628.7090008@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 02:46:00PM -0800, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> >>OK, I see the problem.  The problem is that the _PAGE_X defines are 
> >>defined with _AC(UL, 1 << _PAGE_BIT_X), which has unsigned long type.  
> >>This means that ~_PAGE_X also has unsigned long type, and so when cast 
> >>to 64-bit in pte_mkX, it ends up &ing the pte with 0x00000000ffffffxxx, 
> >>with predictable results.
> >>    
> >
> >Actually I fixed some of that -- see the pgtable-nx patch on firstfloor -- 
> >but
> >it still doesn't work. Or maybe my patch was not complete.
> >  
> 
> Yeah, that looks like the right sort of thing, but I wonder if there's 
> other places doing an open-coded "pte_val(pte) & ~_PAGE_FOO".  My patch 
> changes the definition of _PAGE_FOO so it should be OK everywhere.

Yes that's probably better. I just hit it because NX bits went missing.

> 
> >>The original code just used signed constants for the _PAGE_X 
> >>definitions, which will sign-extend when cast to 64-bit, and so have the 
> >>upper bits set when masking.  (Well, actually, the old code just 
> >>operated on pte_low, so the problem didn't arise; however, pgtable_64.h 
> >>also uses integers for its _PAGE_X, which has the same sign-extended 
> >>32->64 casting property).
> >>
> >>I'll put together a fixup patch now.
> >>    
> >
> >I'm leaving now but can test later.
> >  
> 
> Can you try this out?  It applies after "x86: move all asm/pgtable 
> constants into one place".

I just applied over the whole git-x86 patchkit (tip 
2f42671697ea9abc7d10ea7f663d6ef6e8ec6358)  + the two build fixes
Unfortunately it didn't work, although the faulting loop is shorter now:

-Andi


Freeing unused kernel memory: 260k freed
mount[1159]: segfault at b7fcfe98 ip b7ec6b7a sp bfcfcdec error 7
Eeek! page_mapcount(page) went negative! (-1)
  page pfn = bfc33
  page->flags = 80000014
  page->count = 0
  page->mapping = 00000000
  vma->vm_ops = nfs_file_vm_ops+0x0/0x18
  vma->vm_ops->nopage = 0x0
  vma->vm_ops->fault = filemap_fault+0x0/0x34e
  vma->vm_file->f_op->mmap = nfs_file_mmap+0x0/0x61
------------[ cut here ]------------
kernel BUG at /home/lsrc/quilt/linux/mm/rmap.c:631!
invalid opcode: 0000 [#1] SMP
Modules linked in:

Pid: 1159, comm: mount Not tainted (2.6.24-rc7 #55)
EIP: 0060:[<c0152a32>] EFLAGS: 00010282 CPU: 3
EIP is at page_remove_rmap+0xcc/0xe7
EAX: 00000037 EBX: c27f8660 ECX: 00000046 EDX: 00000046
ESI: f7061c60 EDI: f7d87380 EBP: f7060e78 ESP: f7509df8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process mount (pid: 1159, ti=f7508000 task=f7460540 task.ti=f7508000)
Stack: c27f8660 bfc33065 c014d166 00000000 f7061c60 f7509e80 00000000 00000000
       00000000 00000001 b7fd0000 f7555010 f7d87380 c482e240 00000000 ffffffff
       c16e0c0c 00000000 00000000 f7084df8 003d5ee2 b7fd0000 b7fd0000 00000000
Call Trace:
 [<c014d166>] unmap_vmas+0x349/0x5d1
 [<c0150006>] exit_mmap+0x5f/0xcd
 [<c011df0a>] mmput+0x25/0x79
 [<c0122636>] do_exit+0x1a9/0x5eb
 [<c0122ae3>] sys_exit_group+0x0/0xd
 [<c0129dde>] get_signal_to_deliver+0x3e3/0x405
 [<c04334b6>] do_page_fault+0x0/0x69f
 [<c0102606>] do_notify_resume+0x7d/0x64e
 [<c0120383>] printk+0x14/0x18
 [<c0433874>] do_page_fault+0x3be/0x69f
 [<c0433b4c>] do_page_fault+0x696/0x69f
 [<c01508c1>] do_munmap+0x181/0x19b
 [<c04334b6>] do_page_fault+0x0/0x69f
 [<c0102f4e>] work_notifysig+0x13/0x19
 =======================
Code: 8b 46 44 8b 50 08 b8 d2 95 50 c0 e8 9c ad fe ff 8b 46 4c 85 c0 74 14 8b 40 10 85 c0 74 0d 8b 50 2c b8 f0 95 50 c0 e8 81 ad fe ff <0f> 0b eb fe 8b 53 10 89 d8 5b 5e 83 e2 01 f7 da 83 c2 04 e9 c5
EIP: [<c0152a32>] page_remove_rmap+0xcc/0xe7 SS:ESP 0068:f7509df8
---[ end trace eb3c259ee0695fdd ]---
Fixing recursive fault but reboot is needed!
eth0: no IPv6 routers present

