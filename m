Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab0BXUXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:23:06 -0500
Received: from relay3.sgi.com ([192.48.152.1]:59453 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757984Ab0BXUXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:23:03 -0500
Date: Wed, 24 Feb 2010 14:22:58 -0600
From: Jack Steiner <steiner@sgi.com>
To: venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Panic in reserve_memtype()
Message-ID: <20100224202258.GA615@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We see an X86_64 regression that started a few days ago. The kernel is booted
via EFI & panics in the pat.c code trying to deref a NULL pointer.

I didn't debug the problem but am suspicious of
	x86, pat: Migrate to rbtree only backend for pat memtype management  x86/pat
		author	Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>	
		Wed, 10 Feb 2010 23:26:07 +0000 (15:26 -0800)
	committer	H. Peter Anvin <hpa@zytor.com>	
		Thu, 18 Feb 2010 23:41:36 +0000 (15:41 -0800)



Has anyone seen this? If not, I can debug further....

Problem is in the git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git tree.



Pid: 0, comm: swapper Not tainted 2.6.33-rc8-tip-medusa+ #2 /
RIP: 0010:[<ffffffff810304b0>]  [<ffffffff810304b0>] rbt_memtype_check_insert+0x1b2/0x232
RSP: 0000:ffffffff81601df8  EFLAGS: 00000256
RAX: 00000000000b0000 RBX: ffff88000f840100 RCX: 00000000000001c1
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88000f8244c0
RBP: ffffffff81601e38 R08: 0000000000000001 R09: ffffffff8152cd79
R10: ffffffff8152cd79 R11: 0000000000018620 R12: ffff88000f8244c0
R13: 0000000000000010 R14: 0000000000000000 R15: 00000000fffffff4
FS:  0000000000000000(0000) GS:ffff880001c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005007b
CR2: 0000000000000000 CR3: 0000000001604000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
Process swapper (pid: 0, threadinfo ffffffff81600000, task ffffffff8160c020)
Stack:
 ffffffff81601e38 00000000000b0000 0000000000006000 ffff88000f840100
<0> ffff88000f8244c0 0000000000000000 0000000000000010 00000000fffffff4
<0> ffffffff81601e88 ffffffff8102edff 00000000000b0000 0000000000006000
Call Trace:
 [<ffffffff8102edff>] reserve_memtype+0x2ce/0x4c9
 [<ffffffff8102e0d0>] set_memory_uc+0x41/0x89
 [<ffffffff816b92be>] efi_enter_virtual_mode+0xc9/0x269
 [<ffffffff816aada0>] start_kernel+0x3b8/0x42b
 [<ffffffff816aa140>] ? early_idt_handler+0x0/0x71
 [<ffffffff816aa29e>] x86_64_start_reservations+0xa5/0xa9
 [<ffffffff816aa3ed>] x86_64_start_kernel+0x14b/0x15a



Source of the NULL pointer is:

	int set_memory_uc(unsigned long addr, int numpages)
	{
		...
		ret = reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
                            _PAGE_CACHE_UC_MINUS, NULL);



--- jack
