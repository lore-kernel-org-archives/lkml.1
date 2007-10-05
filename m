Return-Path: <linux-kernel-owner+w=401wt.eu-S1761729AbXJEBnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761729AbXJEBnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 21:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760263AbXJEBnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 21:43:40 -0400
Received: from gw.goop.org ([64.81.55.164]:54299 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760244AbXJEBni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 21:43:38 -0400
Message-ID: <470596C4.8060804@goop.org>
Date: Thu, 04 Oct 2007 18:43:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Hugh Dickens <hugh@veritas.com>, David Rientjes <rientjes@google.com>,
       Zachary Amsden <zach@vmware.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Keir Fraser <keir@xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: race with page_referenced_one->ptep_test_and_clear_young and pagetable
 setup/pulldown
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David's change 10a8d6ae4b3182d6588a5809a8366343bc295c20, "i386: add
ptep_test_and_clear_{dirty,young}" has introduced an SMP race which
affects the Xen pv-ops backend.

In Xen, pagetables are normally kept RO so that the hypervisor can
mediate all updates to them.  If Xen sees a write to an active
(currently pointed to by cr3) or pinned (a currently inactive but
registered pagetable), it will trap the write fault and emulate the
instruction making the update; this means that most pagetable-modifying
code doesn't need to know or care that pagetables are RO.

When a pagetable is first created (either in execve or fork), the the
Xen paravirt backend pins the pagetable, and conversely, on exit it is
unpinned; this is done via the arch_dup_mmap() and activate_mm() hooks. 
Pinning is done in two phases: first the pagetable pages are marked RO,
and then the pagetable is registered with Xen; unpinning is the
opposite.  This works assuming that the pagetable is not in use, and not
yet visible to other cpus.

The race on pagetable creation is this: in kernel/fork.c:dup_mmap(), it
copies the old pagetable into the new one, and registers each vma with
the rmap prio tree.  Once everything is copied, it calls
arch_dup_mmap(), which ends up doing the Xen pagetable pin.  However,
because the pagetable is visible to other cpus via the prio tree,
pagetable modifications (specifically, clearing the access bit) can race
with pinning.  If it hits between making the pagetable pages RO but
before they're registered with Xen, modifications to the flags will
fault, and Xen won't know to do the fixup.

The converse is also true in exit_mmap(): arch_exit_mmap is called
before removing the vmas from the prio tree, so it can race with unpinning.

The specific oops I'm seeing is this:

BUG: unable to handle kernel paging request at virtual address c5b023e8
 printing eip:
c016d3f2
*pdpt = 000000004bc1a001
Oops: 0003 [#1]
PREEMPT SMP 
Modules linked in:
CPU:    1
EIP:    0061:[<c016d3f2>]    Not tainted VLI
EFLAGS: 00010202   (2.6.23-rc9-paravirt #1656)
EIP is at page_referenced_one+0xb8/0x12a
eax: c0401b17   ebx: c5b023e8   ecx: c2398000   edx: c044ceca
esi: 0087d000   edi: c5660688   ebp: c2399af4   esp: c2399acc
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0069
Process cc1 (pid: 31474, ti=c2398000 task=c2dc9000 task.ti=c2398000)
Stack: c04014a7 c040f47a 0000011e c03697fe c2399b1c c5eb4500 c113e87c c116b1c8 
       c5660688 c13aa890 c2399b2c c016d4d8 00000000 c7917340 00000008 00000000 
       00000000 c13aa8c4 00000000 00000000 00000005 c116b1c8 00000001 c0473940 
Call Trace:
 [<c010927e>] show_trace_log_lvl+0x1a/0x2f
 [<c0109330>] show_stack_log_lvl+0x9d/0xa5
 [<c010952f>] show_registers+0x1f7/0x336
 [<c0109789>] die+0x11b/0x23b
 [<c035e811>] do_page_fault+0x758/0x838
 [<c035ccca>] error_code+0x72/0x78
 [<c016d4d8>] page_referenced_file+0x74/0xa0
 [<c016d732>] page_referenced+0xbd/0xd0
 [<c01611b4>] shrink_active_list+0x170/0x3a3
 [<c0161e56>] shrink_zone+0xb9/0xf8
 [<c0162808>] try_to_free_pages+0x13c/0x208
 [<c015e269>] __alloc_pages+0x197/0x290
 [<c015fa95>] __do_page_cache_readahead+0xd4/0x1d7
 [<c015fe86>] do_page_cache_readahead+0x4b/0x56
 [<c015be8d>] filemap_fault+0x1b7/0x3de
 [<c0164649>] __do_fault+0x79/0x407
 [<c0167760>] handle_mm_fault+0x27e/0xca0
 [<c035e44a>] do_page_fault+0x391/0x838
 [<c035ccca>] error_code+0x72/0x78
 =======================
Code: 0c fe 97 36 c0 c7 44 24 08 1e 01 00 00 c7 44 24 04 7a f4 40 c0 c7 04 24 a7 14 40 c0 e8 d4 e5 fb ff e8 29 c9 f9 ff f6 03 20 74 27 <f0> 0f ba 33 05 19 c0 85 c0 74 1c 8b 07 89 f2 89 d9 8d b6 00 00 
EIP: [<c016d3f2>] page_referenced_one+0xb8/0x12a SS:ESP 0069:c2399acc


It all worked OK before David's change, because asm-generic/pgtable.h
uses set_pte_at(), which ends up making a hypercall to update the
pagetable, which always works regardless of the state of the pagetable
pages.


It seems to me that there are a few ways to fix this:

   1. Use asm-generic/pgtable.h when CONFIG_PARAVIRT is enabled.  This
      will clearly work, but is pretty blunt.
   2. Make test_and_clear_pte_flags a new paravirt-op, which can be
      implemented in Xen as a hypercall, and as a raw test_and_clear_bit
      for everyone else.  The downside is adding yet another pv-op.
   3. Restructure the pagetable setup code so that the mm is not added
      to the prio tree until after arch_dup_mmap has been called (and
      the converse for exit_mmap).  This is arguably cleaner, but I
      haven't looked to see how much trouble this would be.

Thoughts anyone?  Does making the pagetables visible "early" cause
problems for anyone else?

Thanks,
    J
